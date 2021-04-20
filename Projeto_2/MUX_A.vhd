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
entity MUX_A is
	port(TR		: in std_logic_vector(3 downto 0);
		  S		: in std_logic_vector(2 downto 0);
		  Mx_out	: out std_logic_vector(3 downto 0)
);
end MUX_A;
architecture comportamental of MUX_A is
begin
process(TR, S)
begin
case S is
	when "000" => Mx_out <= "0000";
	when "001" => Mx_out <= "0001";
	when "010" => Mx_out <= "1001";
	when "011" => Mx_out <= "0101";
	when "100" => Mx_out <= "0100";
	when "101" => Mx_out <= "0011";
	when "110" => Mx_out <= TR;
	when "111" => Mx_out <= "0000";
	when others => null;
end case;
end process;
end comportamental;