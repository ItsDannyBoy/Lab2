library ieee;
use ieee.std_logic_1164.all;
entity pulse_generator is
generic (
	G_CLOCKS_PER_PULSE      : in 	integer := 8  
);
port ( 
	
		RST                 : in    std_logic;
        CLK                 : in    std_logic;
        RATE                : in    std_logic;
        PULSE               : out   std_logic
);
end entity;

architecture behave of pulse_generator is
--***** works but with many flip flops******
	signal CLOCK_CNT	: integer range 0 to G_CLOCKS_PER_PULSE * 2-1 := 0;
	constant G_CLOCKS_PER_PULSE_DOUBLED	: integer := G_CLOCKS_PER_PULSE * 2;
--********************
--***** works with ONE! flip flops********
--	subtype integer_range is integer range 0 to G_CLOCKS_PER_PULSE * 2; -- used for limitng integer value of clock_counter and g_clocks_per_pulse_doubled integers
																		-- helps minimizing the number of flipflops
	--constant G_CLOCKS_PER_PULSE_DOUBLED	: integer_range := G_CLOCKS_PER_PULSE * 2;
  --  signal CLOCK_CNT : integer_range := 0;

begin

	process(RST, CLK)
	begin
		if RST = '0' then
			PULSE <= '0';
			CLOCK_CNT <= 0;		-- clear the clock counter
		elsif rising_edge(CLK) then
			if RATE = '0' then
				if CLOCK_CNT = G_CLOCKS_PER_PULSE - 1 then
				CLOCK_CNT <= 0;					-- clear the clock counter
				PULSE <= '1';					-- generate pulse
				else
					CLOCK_CNT <= CLOCK_CNT + 1;	-- increment the clock counter
					PULSE <= '0';
				end if;
				
			elsif RATE = '1' then
				if CLOCK_CNT = G_CLOCKS_PER_PULSE_DOUBLED - 1 then
					CLOCK_CNT <= 0;					-- clear the clock counter
					PULSE <= '1';						-- generate pulse
				else
					CLOCK_CNT <= CLOCK_CNT + 1;	-- increment the clock counter
					PULSE <= '0';
				end if;
			end if;
		end if;
	end process;	
end architecture;