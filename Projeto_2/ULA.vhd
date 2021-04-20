--********************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 09/2017
-- Componente VHDL: Unidade Aritmética e Lógica => ALU.vhd
-- Rev. 0
-- Especificações: entradas: A[3..0], B[3..0], Op[1..0]
--				       saidas :  ALU_out[3..0], ZR, PO, NG, ES
-- ALU realiza as operações: Passa A (Op=00), NOT(A) (OP=01), B+A (Op=10) e B-A (Op=11)
-- ALU gera quatro sinais de status:
--  		Resultado igual a zero (ZR=1)
--       Resultado maior que zero (PO=1)
--			Resultado menor que zero (NG=1)
--			Resultado maior que 15 (ES=1)
-- Essa ALU é assíncrona. 
--********************************************************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity ULA is
   port
   (  A, B		: in std_logic_vector(3 downto 0); -- vetores de entrada
      Op			: in std_logic_vector(1 downto 0); -- código de operação
      Alu_out	: out std_logic_vector(3 downto 0);-- vetor de saída
      ZR			: out std_logic; 			           -- resultado igual a zero 
      PO			: out std_logic; 						  -- resultado positivo 
      NG			: out std_logic; 						  -- resultado negativo
      ES			: out std_logic 						  -- resultado maoir que 15
   );
end entity ULA;
 
architecture Behavioral of ULA is

 begin
   process(A,B,Op) is		     				-- ALU assíncrona
   
   variable Temp: std_logic_vector(5 downto 0);	-- registrador temporário 
												-- de 4 bits + bit de estouro + bit de sinal 
   begin
    case Op is
         when "00" =>       					-- Passa A
			Temp := std_logic_vector((unsigned("00" & A)));
		 when "01" =>       					   -- NOT(A)
			Temp := std_logic_vector((unsigned("00" & NOT(A))));
         when "10" => 							-- B + A
            Temp(4 downto 0) := std_logic_vector(unsigned("0" & B) + unsigned("0" & A));
            Temp(5) := '0';					-- resultado positivo
         when "11" => 							
           if (B = A) then						-- B=A, NG=0, ES=0, ZR=1
			   Temp :="000000";					-- resultado zero
           elsif (B > A) then					-- B > A, NG=0
				Temp(4 downto 0) := std_logic_vector(unsigned("0" & B) - unsigned("0" & A));
				Temp(5) := '0';					-- resultado positivo
			  else 									-- B < A, NG=1, ES=0
            Temp(3 downto 0) := std_logic_vector(unsigned(B) - unsigned(A));
				Temp(4) := '0';					-- sem estouro
            Temp(5) := '1';					-- resultado negativo
            end if;
          when others => null;				-- não faz nada com operando incorreto
    end case;
	if (Temp = "000000" ) then  				-- verifica se resultado é igual a zero
		ZR <= '1';
		PO <= '0';
		NG <= '0';
		ES <= '0';
	elsif Temp(4) = '1' then  					-- verifica se resultado é maior que 15
		ZR <= '0';
		PO <= '0';
		NG <= '0';
		ES <= '1';
	elsif Temp(5) = '1' then					-- verifica se resultado é negativo 
		ZR <= '0';
		PO <= '0';
		NG <= '1';
		ES <= '0';
    else 									   	-- resultado é positivo
		ZR <= '0';
		PO <= '1';
		NG <= '0';
		ES <= '0';
    end if;     
    
   Alu_out  <= Temp(3 downto 0); 			-- atualiza saída da ALU
         
   end process;
end architecture Behavioral;