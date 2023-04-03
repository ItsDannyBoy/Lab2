library ieee;
use ieee.std_logic_1164.all;

entity pulse_generator is
port (
	D_IN1,D_IN2,D_IN3, D_IN4 : in  std_logic_vector(7 downto 0);
	SEL : in  std_logic_vector(1 downto 0);
	Q_OUT  : out std_logic_vector(7 downto 0)
);
end entity;
architecture behave of pulse_generator is 

begin
	with SEL select
		Q_OUT<= D_IN1 when "00",
				D_IN2 when "01",
				D_IN3 when "10",
				D_IN4 when "11",
				(others=>'Z') when others;
end architecture;