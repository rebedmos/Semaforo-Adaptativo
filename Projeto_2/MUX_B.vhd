--********************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 09/2017
-- Componente VHDL: Multiplexador de 4 vias de 4 bits => MUX.vhd
-- Rev. 0
-- Especificações: entradas: Da[3..0], Db[3..0], Dc[3..0], Dd[3..0], S[1..0]
--				   saídas : Mx_out[3..0]
-- MUX seleciona um dos quatro vetores de entradas em função do código de S:
--			S=00 => seleciona Da
--			S=01 => seleciona Db
--			S=10 => seleciona Dc
--			S=11 => seleciona Dd
-- MUX é um seletor assíncrono. 
--********************************************************************************
library ieee;
use ieee.std_logic_1164.all;
entity MUX_B is
	port( D0		: in std_logic_vector(3 downto 0);
		  D1		: in std_logic_vector(3 downto 0);
		  D2		: in std_logic_vector(3 downto 0);
		  D3		: in std_logic_vector(3 downto 0);
		  S		: in std_logic_vector(1 downto 0);
		  Mx_out	: out std_logic_vector(3 downto 0)
);
end MUX_B;
architecture comportamental of MUX_B is
begin
process(D0, D1, D2, D3, S)
begin
case S is
	when "00" => Mx_out <= D0;
	when "01" => Mx_out <= D1;
	when "10" => Mx_out <= D2;
	when "11" => Mx_out <= D3;
	when others => null;
end case;
end process;
end comportamental;