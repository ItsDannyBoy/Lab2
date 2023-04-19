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
	constant DEFAULT_VALUE : std_logic_vector(Q'high downto Q'low) := (Q'low => '1', others => '0');
	signal q_reg : std_logic_vector(Q'high downto Q'low) := DEFAULT_VALUE; -- Same size as Q output
	--signal q_reg : std_logic_vector(G_N_BITS-1 downto 0); -- Same size as Q output
	-- the initial state of the shift register is set in the architecture
	-- declaration of the shift_register entity
begin
	Q <= q_reg;

	process(CLK, RST)
    begin
        if RST='0' then
            q_reg <= DEFAULT_VALUE; -- reset output to 0
        elsif rising_edge(CLK) then
			if ENA='1' then
				if L_Rn = '1' then
					--q_reg <= std_logic_vector(rotate_left(unsigned(q_reg),1)); -- 1 is the number of bits to shift
					q_reg <= q_reg(q_reg'high-1 downto q_reg'low) & q_reg(q_reg'high); -- & is concatenation
				else --L_Rn=0
					--q_reg <= std_logic_vector(rotate_right(unsigned(q_reg),1)); -- Type of shift depends on input to function.
					q_reg <= q_reg(q_reg'low) & q_reg(q_reg'high downto q_reg'low+1);
													 				-- Unsigned=Logical, Signed=Arithmetic
				-- The shift_left function in numeric_std package takes an unsigned as first argument and it returns an unsigned value.
				end if;
			end if;
        end if;
    end process;
end architecture;