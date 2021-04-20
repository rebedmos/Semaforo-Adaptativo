--********************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 09/2017
-- Componente VHDL: Registrador de 4 bits => REG.vhd
-- Rev. 0
-- Especificações: entradas: CK, LD, R_in[3..0]
--				   	 saídas : R_out[3..0]
-- REG registra o valor da entrada na borda do clock quando LD está ativo.
--********************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity REG is
	port (CK	: in std_logic;
		  LD	: in std_logic; 					-- habilita carga
		  R_in	: in std_logic_vector(3 downto 0);  -- dados de entrada
		  R_out	: out std_logic_vector(3 downto 0)	-- dados de saída
		  ); 
end REG;
architecture behv of REG is
begin
process(CK)
begin
	if (CK'event and CK = '1') then
		if LD ='1' then
		R_out <= R_in;
		end if;
	end if;
end process;
end behv;
