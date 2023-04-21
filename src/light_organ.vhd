library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity light_organ is
generic (
	G_NUM_OF_LEDS          : integer := 8; --Total number of LED connected to the output. Should be 8 by default
    G_CLOCKS_PER_PULSE     : integer := 12500000
);
port (
	CLK 	: in  std_logic; -- System clock
	RST 	: in  std_logic; -- Asynchronous system reset, active low
    RATE    : in  std_logic; -- 0 – LEDs are shifted every 0.5 sec
                             -- 1 – LEDs are shifted every 0.25 sec
	LEDS   	: out std_logic_vector(G_NUM_OF_LEDS-1 downto 0)  
);
end entity;
architecture behave of light_organ is 
    component pulse_generator is                -- This is the component declaration.
    generic (
        G_CLOCKS_PER_PULSE  : integer           -- Check if initial value is needed
    );
    port (
        RST                 : in    std_logic;
        CLK                 : in    std_logic;
        RATE                : in    std_logic;
        PULSE               : out   std_logic
    );
    end component;

    component shift_register is                -- This is the component declaration.
    generic (
	    G_N_BITS :    integer 
    );
    port (
        CLK 	: in  std_logic; 
        RST 	: in  std_logic; 
        L_Rn 	: in  std_logic; 
        ENA 	: in  std_logic; 
        Q   	: out std_logic_vector(G_N_BITS-1 downto 0) 
    );
    end component;

    constant DEFAULT_VALUE : std_logic_vector(LEDS'high downto LEDS'low) := (LEDS'low => '1', others => '0');
    signal q_to_leds_sig : std_logic_vector(LEDS'high downto LEDS'low) := DEFAULT_VALUE; -- Check if default value is needed
    signal l_rn_sig : std_logic := '1';
    signal pulse_to_enable_sig : std_logic;
    signal counter : integer range 0 to G_NUM_OF_LEDS - 1 := 0;
    --signal q_to_leds_sig : std_logic;
begin
    LEDS <= q_to_leds_sig;
    
    shift_reg: shift_register                    -- This is the component instantiation. uut is the instance name of the component shift_register
    generic map (
        G_N_BITS  => G_NUM_OF_LEDS -- The G_N_BITS generic of the uut instance of the pulse generator component
                              -- is set to the value of the constant C_N_BITS (which is declared in line 10)
    )
    port map (
        RST                 => RST, -- The RST input of the uut instance of the pulse generator component is connected to rst_sig signal
        CLK                 => CLK, -- The CLK input of the uut instance of the pulse generator component is connected to clk_sig signal
        ENA                 => pulse_to_enable_sig,
        L_Rn                => l_rn_sig,
        Q                   => q_to_leds_sig    
    );

    pulse_gen: pulse_generator                    -- This is the component instantiation. dut is the instance name of the component pulse_generator
    generic map (
        G_CLOCKS_PER_PULSE  => G_CLOCKS_PER_PULSE -- The G_CLOCKS_PER_PULSE generic of the dut instance of the pulse generator component is set to the value of the constant C_CLOCKS_PER_PULSE which is declared in line 10
    )
    port map (
        RST                 => RST, -- The RST input of the dut instance of the pulse generator component is connected to rst_sig signal
        CLK                 => CLK, -- The CLK input of the dut instance of the pulse generator component is connected to clk_sig signal
        RATE                => RATE,
        PULSE               => pulse_to_enable_sig     -- outputs can be left opened
    );

	-- process(q_to_leds_sig)
    -- begin
    --     if (q_to_leds_sig(q_to_leds_sig'high) = '1') then
    --         l_rn_sig <= not l_rn_sig;
    --     end if;
    -- end process;

    process(pulse_to_enable_sig, RST)
    begin
        if RST = '0' then -- return all signals to initial state
            counter <= 0;
            l_rn_sig <= '1';
        elsif falling_edge(pulse_to_enable_sig) then
            counter <= counter + 1;
            if (counter = G_NUM_OF_LEDS-2) then
                l_rn_sig <= not l_rn_sig;
                counter <= 0;
            end if;
        end if;
    end process;
end architecture;