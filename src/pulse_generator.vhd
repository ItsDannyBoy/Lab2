library ieee;
use ieee.std_logic_1164.all;
entity pulse_generator is
generic (
	G_CLOCKS_PER_PULSE      : in 	integer := 8  -- Number of clocks counted before pulse is generated
);
port ( 
	
		RST                 : in    std_logic; -- Asynchronous system reset, active low
        CLK                 : in    std_logic; -- System clock
        RATE                : in    std_logic; -- 0 – PULSE output cycle is G_CLOCKS_PER_PULSE CLK cycles
											   -- 1 – PULSE output cycle is G_CLOCKS_PER_PULSE×2 CLK cycles
        PULSE               : out   std_logic  -- Periodic pulse. Must be ‘1’ for exactly 1 CLK cycle. 
										       -- The period time (in CLK cycles) is determined by RATE input
											   -- and G_CLOCKS_PER_PULSE1 and G_CLOCKS_PER_PULSE2 generics.
);
end entity;

architecture behave of pulse_generator is
	signal CLOCK_CNT	: integer range 0 to G_CLOCKS_PER_PULSE * 2-1 := 0;
	constant G_CLOCKS_PER_PULSE_DOUBLED	: integer := G_CLOCKS_PER_PULSE * 2;

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