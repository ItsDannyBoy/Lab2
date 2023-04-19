library ieee;
use ieee.std_logic_1164.all;

entity light_organ_tb is        -- The Testbench entity is empty. No ports.
end entity;

architecture behave of light_organ_tb is    -- This is the architecture of the testbench

    -- constants declaration    
	constant C_NUM_OF_LEDS               : integer := 9;
	constant C_CLOCKS_PER_PULSE          : integer := 2;
    constant C_CLK_PRD              : time := 20 ns; -- 50Mhz
    constant C_ITERATIONS           : integer := 3; -- Value is arbitrary
    

    component light_organ is                -- This is the component declaration.
    generic (
        G_NUM_OF_LEDS          : integer ; --Total number of LED connected to the output. Should be 8 by default
        G_CLOCKS_PER_PULSE     : integer
    );
    port (
        CLK 	: in  std_logic; -- System clock
        RST 	: in  std_logic; -- Asynchronous system reset, active low
        RATE    : in  std_logic; -- 0 – LEDs are shifted every 0.5 sec
                                -- 1 – LEDs are shifted every 0.25 sec
        LEDS   	: out std_logic_vector(G_NUM_OF_LEDS downto 0)  
    );
    end component;


    -- signals declaration  
    signal clk_sig  : std_logic := '0';
    signal rst_sig  : std_logic := '1';
    signal rate_sig  : std_logic := '1';
    
begin
   
    uut: light_organ                    -- This is the component instantiation. uut is the instance name of the component light_organ
    generic map (
        G_NUM_OF_LEDS  => C_NUM_OF_LEDS,
        G_CLOCKS_PER_PULSE => C_CLOCKS_PER_PULSE
    )
    port map (
        CLK  => clk_sig, -- The CLK input of the uut instance of the pulse generator component is connected to clk_sig signal
        RST  => rst_sig, -- The RST input of the uut instance of the pulse generator component is connected to rst_sig signal
        RATE  => rate_sig, -- The RST input of the uut instance of the pulse generator component is connected to rate_sig signal
        LEDS => open  
    );
    process
    begin
        for iteration in 0 to C_ITERATIONS loop -- Goes up
            wait for (2*C_NUM_OF_LEDS+1)*C_CLK_PRD/2 + C_CLK_PRD/10; --Enough for Q to perform a full cycle
            rst_sig <= not rst_sig;
        end loop;
	end process;

    process
    begin
        for iteration in 0 to C_ITERATIONS loop -- Goes up
            wait for (4*C_NUM_OF_LEDS+3)*C_CLK_PRD/2; -- All entries (except RST) are synchronized with clock rising edge
            rate_sig <= not rate_sig;
        end loop;
	end process;

    -- process
    -- begin
    --     for iteration in 0 to C_ITERATIONS loop -- Goes up
    --         wait for (8*C_NUM_OF_LEDS+7)*C_CLK_PRD/2; -- All entries (except RST) are synchronized with clock rising edge
    --         l_rn_sig <= not l_rn_sig;
    --     end loop;
	-- end process;

    clk_sig <= not clk_sig after C_CLK_PRD / 2;     -- clk_sig toggles every C_CLK_PRD/2 ns

end architecture;
