library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register is
generic (
	G_N_BITS : integer   --The size of Q output
);
port (
	CLK 	: in  std_logic; -- System clock
	RST 	: in  std_logic; -- Asynchronous system reset, active low
	L_Rn 	: in  std_logic; -- 0 – Rotate right
							 -- 1 – Rotate left
	ENA 	: in  std_logic; -- 0 – Q is not affected.
							 -- 1 – Q output is rotated left or right
							 -- on the rising edge of the CLK input
							 -- according to L_Rn state.
	Q   	: out std_logic_vector(G_N_BITS-1 downto 0) 
							 --This is the output of the shift register.
);
end entity;
architecture behave of shift_register is 
	process(CLK, RST)
    begin
        if RST='0' then
            Q <= (others=>0); -- reset output to 0
        elsif rising_edge(CLK) then
			if ENA='1' then
				if L_Rn = '1'
					Q <= shift_left(Q,1) -- 1 is the number of bits to shift
				else --L_Rn=0
					Q <= shift_right(Q,1);
				end if;
			end if;
        end if;
    end process;
begin
	
end architecture;