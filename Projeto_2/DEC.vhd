--********************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 09/2017
-- Componente VHDL: Decodificador BCD- Didplay de 7 Segmentos => DEC.vhd
-- Rev. 0
-- Especificações: entradas: X[3..0]
--				       saídas : D[6..0]í
-- DEC decodifica um vetor de 4 bits gerando 7 sinais para ativação (em nível lógico zero)
--	   dos 7 segmentos de um display.
-- DEC é um decodificador assíncrono. 
--********************************************************************************
library ieee;
use ieee.std_logic_1164.all;

entity DEC is			  			  			-- declaração da entidade DEC.vhd
	port 
	(
		X 	: in std_logic_vector(3 downto 0); 	-- vetor de entrada X(3) X(2) X(1) X(0)
		D   : out std_logic_vector(6 downto 0) 	-- vetor de saída D(6) D(5) D(4) D(3) D(2) D(1) D(0)
	);
end DEC;

architecture FLUXO_DE_DADOS of DEC is      		-- arquitetura com seletor de dados para DEC
begin
	with X select
		D <="1000000" when "0000",	-- display 0
			"1111001" when "0001",	-- display 1
			"0100100" when "0010",	-- display 2
			"0110000" when "0011",	-- display 3
			"0011001" when "0100",	-- display 4
			"0010010" when "0101",	-- display 5
			"0000010" when "0110",	-- display 6
			"1111000" when "0111",	-- display 7
			"0000000" when "1000",	-- display 8
			"0010000" when "1001",	-- display 9
			"0001000" when "1010",	-- display A
			"0000011" when "1011",	-- display b
			"1000110" when "1100",	-- display C
			"0100001" when "1101",	-- display d
			"0000110" when "1110",	-- display E
			"0001110" when others;	-- display F
end FLUXO_DE_DADOS;
