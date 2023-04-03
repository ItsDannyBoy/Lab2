library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
port (
	D_IN1,D_IN2,D_IN3, D_IN4 : in  std_logic_vector(7 downto 0);
	SEL : in  std_logic_vector(1 downto 0);
	Q_OUT  : out std_logic_vector(7 downto 0)
);
end entity;
architecture behave of pulse_generator is 

begin
	--test
end architecture;