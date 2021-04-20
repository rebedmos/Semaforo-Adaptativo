--********************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 09/2017
-- Componente VHDL: Timer de 500 milissegundos => TIMER_500ms.vhd
-- Rev. 0
-- Especificações: entradas: CK, IT
--				   saidas : TC
-- TIMER é um contador decrescente de 25.000.000 a zero.
-- TIMER possui um sinal de saída que vai para '1', quando a contagem chega no valor zero.
-- 	 Quando o sinal de Início de Timer vai a zero (IT=0) o TIMER reinicia 
--		 o contador com o valor com máximo (enquanto IT=0).
--		 Para disparar o TIMER deve ocorrer IT=1, fazendo o contador do TIMER
--		 iniciar a contagem decrescente. Enquanto a contagem não atingir o valor
--		 mínimo (zero) a saída de Término de Comtagem (TC) é mantidda em zero. Quando a
--     contagem chega a zero a saída TC=1.
--		 Com clock de 50MHz o sinal TC permanece em zero por 500 milissegundos. 
--********************************************************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY TIMER IS PORT(
   CK		: IN std_logic;	-- Clock de 50MHz
 	IT		: IN std_logic; 	-- Reseta e inicia temporização 
	TC		: OUT std_logic 	-- Término de contagem (final de temporização) 
    );
END TIMER;
   
ARCHITECTURE COMPORTAMENTAL OF TIMER IS
SIGNAL count: std_logic_vector( 25 DOWNTO 0 );  -- registro para contar pulsos de clock
BEGIN

PROCESS( CK, IT )  			 -- processo que conta número de pusos de clock
	BEGIN
		IF  IT ='0' THEN
		count <= "01011111010111100001000001";  -- carrega valor inicial: 25.000.001
--		count <= "00000000000000000000000010";  -- carrega valor 2 (usado para simulação)		
		ELSIF rising_edge(CK) THEN					
			IF count /= "00000000000000000000000000" THEN -- contagem decrescente
			count(0) <= NOT count(0);
			count(1) <= count(0) XNOR count(1);
			count(2) <= ( count(0) OR count(1) ) XNOR count(2);
 			count(3) <= ( count(0) OR count(1) OR count(2) ) XNOR count(3);
			count(4) <= ( count(0) OR count(1) OR count(2) OR count(3)) XNOR count(4);
			count(5) <= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4))
						XNOR count(5);
			count(6) <= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5))XNOR count(6);
			count(7) <= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6)) XNOR count(7);			
			count(8) <= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7)) XNOR count(8);
			count(9) <= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8)) XNOR count(9);
			count(10)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)) 
						XNOR count(10);
			count(11)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10)) XNOR count(11);
			count(12)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11)) XNOR count(12);
			count(13)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12)) XNOR count(13);
			count(14)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)) 
						XNOR count(14);
			count(15)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13) 
						OR count(14)) XNOR count(15);
			count(16)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13) 
						OR count(14) OR count(15)) XNOR count(16);
			count(17)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16)) XNOR count(17);
			count(18)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)) 
						XNOR count(18);
			count(19)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18)) XNOR count(19);
			count(20)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18) OR count(19)) XNOR count(20);
			count(21)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18) OR count(19) OR count(20)) XNOR count(21);
			count(22)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18) OR count(19) OR count(20) OR count(21))
						XNOR count(22);
			count(23)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18) OR count(19) OR count(20) OR count(21)
						OR count(22)) XNOR count(23);
			count(24)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18) OR count(19) OR count(20) OR count(21)
						OR count(22) OR count(23)) XNOR count(24);
			count(25)<= ( count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17)
						OR count(18) OR count(19) OR count(20) OR count(21)
						OR count(22) OR count(23) OR count(24)) XNOR count(25);
			END IF; 
		END IF;
END PROCESS; 

-- Atualiza saída
			TC <= NOT(count(0) OR count(1) OR count(2) OR count(3) OR count(4)
						OR count(5) OR count(6) OR count(7) OR count(8) OR count(9)
						OR count(10) OR count(11) OR count(12) OR count(13)
						OR count(14) OR count(15) OR count(16) OR count(17) 
						OR count(18) OR count(19) OR count(20) OR count(21)
						OR count(22) OR count(23) OR count(24) OR count(25));
 
END COMPORTAMENTAL;