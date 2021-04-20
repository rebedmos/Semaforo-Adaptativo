--*****************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 09/2017
-- Componente VHDL: FI=LIP FLOP D => FF_D.vhd
-- Rev. 0
-- Especificações: Entradas: D, CK, SET, RST
-- 				      Saídas:   Q, NQ
-- Esse código é um exemplo de descrição VHDL de um sincronizador de sinais
-- externos (FF tipo D) para sincronização de sinais assíncronos dos projetos da 
-- disciplina de Sistemas Digitais II do Centro Universitário da FEI.
--****************************************************************************
library ieee;
use ieee.std_logic_1164.all;

entity FF_D is
	port 
	(D, CK, SET, RST: 	in std_logic; 	-- Q<= D (quando FF é habilitado pelo sinal de relógio)
	 Q, NQ: 			out std_logic);		-- saídas Q e not(Q) 
end FF_D;

architecture comportamental of FF_D is
begin
	process (CK, SET, RST)  	-- processo é ativado com a alteração de "CK" ou "SET" ou "RST"
	 	begin
		if (RST='0') then Q <='0'; NQ <= '1'; 	-- prioriza "RST", independente de "SET" ou "CK" 
		elsif (SET='0') then Q <='1'; NQ <= '0';-- prioriza "SET", independente de "CK"
		elsif (CK'event and CK='1') then  		-- detecta a borda de subida de "CK"
			Q <= D;	NQ <= not(D);	        	-- atualiza "Q" e "/Q" na borda de subida de "CK"
		end if;	 
	end process;
end comportamental;
