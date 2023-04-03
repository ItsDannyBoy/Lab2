library ieee;
use ieee.std_logic_1164.all;

entity shift_register_tb is        -- The Testbench entity is empty. No ports.
end entity;

architecture behave of shift_register_tb is    -- This is the architecture of the testbench

    -- constants declaration    
	constant C_N_BITS               : integer := 4;
    constant C_CLK_PRD              : time := 20 ns; -- 50Mhz
    constant C_ITERATIONS           : integer := 3; -- Value is arbitrary
    

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


    -- signals declaration  
    signal clk_sig  : std_logic := '0';
    signal rst_sig  : std_logic := '1';
    signal ena_sig  : std_logic := '1';
    signal l_rn_sig  : std_logic := '1';
    --signal q_out_sig  : std_logic_vector(C_N_BITS-1 downto 0) := (others=>'0');
    signal q_out_sig  : std_logic_vector(C_N_BITS-1 downto 0);
    
begin
   
    uut: shift_register                    -- This is the component instantiation. uut is the instance name of the component shift_register
    generic map (
        G_N_BITS  => C_N_BITS -- The G_N_BITS generic of the uut instance of the pulse generator component
                              -- is set to the value of the constant C_N_BITS (which is declared in line 10)
    )
    port map (
        RST                 => rst_sig, -- The RST input of the uut instance of the pulse generator component is connected to rst_sig signal
        CLK                 => clk_sig, -- The CLK input of the uut instance of the pulse generator component is connected to clk_sig signal
        ENA                 => ena_sig,
        L_Rn                => l_rn_sig,
        Q                   => q_out_sig    
    );
    process
    begin
        for iteration in 0 to C_ITERATIONS loop -- Goes up
            wait for (C_N_BITS+1)*C_CLK_PRD; --Enough for Q to perform a full cycle
            rst_sig <= not rst_sig;
        end loop;
	end process;

    process
    begin
        for iteration in 0 to C_ITERATIONS loop -- Goes up
            wait for 15*C_CLK_PRD/2; -- All entries (except RST) are synchronized with clock rising edge
            ena_sig <= not ena_sig;
        end loop;
	end process;

    process
    begin
        for iteration in 0 to C_ITERATIONS loop -- Goes up
            wait for 60*C_CLK_PRD/2; -- All entries (except RST) are synchronized with clock rising edge
            l_rn_sig <= not l_rn_sig;
        end loop;
	end process;
    --q_out_sig <= "1011";
    -- create_q: for i in q_out_sig'range generate
    --     q_out_sig(i) <= '1' when i mod 2 = 1 else '0';
    -- end generate;
    clk_sig <= not clk_sig after C_CLK_PRD / 2;     -- clk_sig toggles every C_CLK_PRD/2 ns
    --ena_sig <= '1', '0' after 100 us;

end architecture;
