library ieee;
use ieee.std_logic_1164.all;

entity pulse_generator_tb is        -- The Testbench entity is empty. No ports.
end entity;

architecture behave of pulse_generator_tb is    -- This is the architecture of the testbench

    -- constants declaration    
	constant C_CLOCKS_PER_PULSE     : integer := 4;
    constant C_CLK_PRD              : time := 20 ns;

    component pulse_generator is                -- This is the component declaration.
    generic (
        G_CLOCKS_PER_PULSE  : integer := 4
    );
    port (
        RST                 : in    std_logic;
        CLK                 : in    std_logic;
        RATE                : in    std_logic;
        PULSE               : out   std_logic
    );
    end component;


-- signals declaration  
    signal clk_sig  : std_logic := '0';
    signal rst_sig  : std_logic := '1';
    signal rate_sig : std_logic := '0';
    
    
begin
   
    dut: pulse_generator                    -- This is the component instantiation. dut is the instance name of the component pulse_generator
    generic map (
        G_CLOCKS_PER_PULSE  => C_CLOCKS_PER_PULSE -- The G_CLOCKS_PER_PULSE generic of the dut instance of the pulse generator component is set to the value of the constant C_CLOCKS_PER_PULSE which is declared in line 10
    )
    port map (
        RST                 => rst_sig, -- The RST input of the dut instance of the pulse generator component is connected to rst_sig signal
        CLK                 => clk_sig, -- The CLK input of the dut instance of the pulse generator component is connected to clk_sig signal
        RATE                => rate_sig,
        PULSE               => open     -- outputs can be left opened
    );
    
    process
    begin 
        wait for (2*C_CLOCKS_PER_PULSE+1)*C_CLK_PRD/2 + C_CLK_PRD/10; 
        rst_sig <= not rst_sig; -- Check rst interrupting the counting
        wait for 3*C_CLK_PRD;
        rst_sig <= not rst_sig;
        rate_sig <= not rate_sig;
        wait for (4*C_CLOCKS_PER_PULSE+3)*C_CLK_PRD/2 + C_CLK_PRD/10; 
        rst_sig <= not rst_sig; -- Check interrupting when rate is *2
        wait for C_CLK_PRD/10;
        rst_sig <= not rst_sig;
	end process;
    
    clk_sig <= not clk_sig after C_CLK_PRD / 2;     -- clk_sig toggles every C_CLK_PRD/2 ns

end architecture;
