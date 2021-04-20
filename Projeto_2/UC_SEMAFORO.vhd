--********************************************************************************
-- CENTRO UNIVERSITÁRIO DA FEI
-- Sistemas Digitais II  -  Projeto 2  - 2° Semestre de 2017
-- Prof. Valter F. Avelino - 10/2017
-- Componente VHDL: Unidade de Controle => UC_SEMAFORO.vhd
-- Rev. 0
-- Especificações: entradas: CK, INI, DC, IC, ST, BP, PGR, ZR, PO, NG, ES, TC
-- 		saídas:   Sel_mxa[2..0], Sel_mxb[1..0], Sel_alu[1..0],LDA, LDB, LDC, LDD, IT
--			saídas externas: LD[11..0]
-- UC para controle do fluxo de dados do sistema de semáforo adaptativo programável.
--********************************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UC_SEMAFORO is
port(	CK	: in std_logic;				-- clock de 50MHz
-- Entradas Externas:
		INI: in std_logic; 			-- sinal de reinício (ativo em '0')
		DC	: in std_logic; 			-- sinal para decremento  de TR (ativo em '1')
		IC	: in std_logic; 			-- sinal para  incremento de TR (ativo em '1')
		ST	: in std_logic; 			-- sinal de tráfego secundário (ativo em '1')
		BP	: in std_logic; 			-- sinal de solicitação de pedestre (ativo em '1')
		PGR: in std_logic; 			-- sinal de modo (0=Normal , 1=Programação de TR)
-- Sinais de Estado da ALU:
		ZR	: in std_logic;				-- resultado zero na operação (ativo em '1')
		PO	: in std_logic;				-- resultado positivo na operação (ativo em '1')
		NG	: in std_logic;				-- resultado negativo na operação (ativo em '1')
		ES	: in std_logic;				-- resultado de estouro na operação (>15)	
-- Sinais de Estado dos TIMER's:
		TC	: in std_logic;				-- término de contagem do Timer_500ms (ativo em '1')
-- Sinais de Saída para MUX:
		Sel_mxa : out std_logic_vector(2 downto 0); -- seleciona entrada de MUX_A
		Sel_mxb : out std_logic_vector(1 downto 0);	-- seleciona entrada de MUX_B
-- Sinais de Saída para ALU:
		Sel_alu : out std_logic_vector(1 downto 0);	-- seleciona operação da ALU
-- Sinais de Saída para Registradores:
		LDA	: out std_logic;		-- carrega TFP (Tempo Faltante da Fase Verde Principal)
		LDB	: out std_logic;		-- carrega TFS (Tempo Faltante da Fase Verde Secundária)
		LDC	: out std_logic;		-- carrega TFT (Tempo Faltante de Transito de Pedestre)
		LDD	: out std_logic;		-- carrega TR  (Tempo de Redução da Fase Verde Principal)
-- Sinais de Saída para TIMER's:
		IT		: out std_logic;		-- inicia temporização do Timer_500ms (ativo em '0'->'1')
-- Sinais de Saída Externos:
		LD		:  out std_logic_vector(11 downto 0)); -- estado das lâmpadas (ativos em '1')
end UC_SEMAFORO;
----------------------------------------------------------------------------------
architecture FSM of UC_SEMAFORO is
type state_type is (inicio, carrega_TR0, ajuste_TR, inc_TR, vrf_menor_TP, dec_TR, vrf_maior_0, carrega_TFP, TFP_reduzido, decresce_TFP, TFP_comp_0, ama_TAP, carrega_TFT, decresce_TFT, TFT_comp_0, carrega_TFS, decresce_TFS, TFS_comp_0, ama_TAS, tempo_TFP, tempo_TFS, tempo_TFT);
signal E: state_type;
signal SP: std_logic;										-- SP: solicitação de pedestre
signal RS: std_logic;										-- RS: reseta solicitação de pedestre

begin
-- Armazena valor de BP até atendimento da solicitação:
Armazena_BP: process(CK, INI, BP, RS)
begin
if INI='0' then SP<='0';									-- inicia com SP='0'
elsif rising_edge(CK) then
	if BP='1' then SP<= '1';								-- atualiza SP quando BP='1'
	elsif RS='1' then SP<= '0';							-- reseta SP quando RS='1'
	else SP<=SP;
	end if;
end if;
end process Armazena_BP;

-- Máquina de estados principal (transição de estados):
Logica_de_Estados: process(CK, INI)
begin
if INI='0' then E <= INICIO;
elsif rising_edge(CK) then
 case E is
	when inicio => E <= carrega_TR0;
	when carrega_TR0 =>
				if PGR = '0' then E <= carrega_TFP;
				else E <= ajuste_TR;
				end if;		
	when carrega_TFP  =>
				if ST = '1' then E <= TFP_reduzido;
				else E <= tempo_TFP; 							
				end if;
	when TFP_reduzido  => E <= tempo_TFP;
	when decresce_TFP => E <= TFP_comp_0;
	when tempo_TFP =>
				if TC = '1' then E <= decresce_TFP;
				else E <= tempo_TFP;
				end if;
	when TFP_comp_0 =>
				if (PO or ES) = '1' then E <= tempo_TFP;
				elsif (ZR or NG) = '1' then E <= ama_TAP;
				end if;
	when ama_TAP =>
				if (SP and TC) = '1' then E <= carrega_TFT;
				elsif (not(SP) and TC) = '1' then E <= carrega_TFS;
				else E <= ama_TAP;
				end if;
	when carrega_TFT => E <= tempo_TFT;
	when decresce_TFT => E <= TFT_comp_0;
	when tempo_TFT => 
				if TC ='1' then E <= decresce_TFT;
				else E <= tempo_TFT;
				end if;
	when TFT_comp_0 =>
				if (PO or ES) = '1' then E <= tempo_TFT;
				elsif (ZR or NG) = '1' then E <= carrega_TFS;
				end if;
	when carrega_TFS => E <= tempo_TFS;
	when decresce_TFS => E <= TFS_comp_0;
	when tempo_TFS =>
				if TC = '1' then E <= decresce_TFS;
				else E <= tempo_TFS;
				end if;
	when TFS_comp_0 =>
				if (PO or ES) = '1' then E <= tempo_TFS;
				elsif (ZR or NG) = '1' then E <= ama_TAS;
				end if;
	when ama_TAS =>
				if TC = '1' then E <= carrega_TFP;
				else E <= ama_TAS;
				end if;
	when ajuste_TR =>
				if (DC and not(IC)) = '1' then E <= dec_TR;
				elsif (IC and not(DC)) = '1' then E <= inc_TR;
				elsif PGR = '0' then E <= carrega_TFP;
				else E <= ajuste_TR;
				end if;
	when inc_TR => E <= vrf_menor_TP;
	when vrf_menor_TP =>
				if (NG and (not(IC) and not(DC))) = '1' then E <= ajuste_TR;
				elsif  ((PO or ES or ZR) and (not(IC) and not(DC))) = '1' then E <= dec_TR;
				else E <= vrf_menor_TP;
				end if;
	when dec_TR => E <= vrf_maior_0;
	when vrf_maior_0 =>
				if ((PO or ES) and (not(IC) and not(DC))) = '1' then E <= ajuste_TR;
				elsif ((ZR or NG) and (not(IC) and not(DC))) = '1' then E <= inc_TR;
				else E <= vrf_maior_0;
				end if;
	
	when others => Null;
 end case;
end if;
end process Logica_de_Estados;

-- Atualização das saídas:
Logica_de_Saidas: process(E)
begin
 case E is
	when inicio => 				 
				Sel_mxa <= "000"; Sel_mxb <= "XX"; Sel_alu <= "00";
				LDD <= '1'; LDC <= '1'; LDB <= '1'; LDA <= '1'; IT <= '0'; RS <= '0';
				LD <= "100000001111";
	when carrega_TR0 => 
				Sel_mxa <= "101"; Sel_mxb <= "XX"; Sel_alu <= "00";
				LDD <= '1'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000001111";
	when ajuste_TR =>
				Sel_mxa <= "XXX"; Sel_mxb <= "XX"; Sel_alu <= "XX";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000001111";
	when inc_TR =>
				Sel_mxa <= "001"; Sel_mxb <= "11"; Sel_alu <= "10";
				LDD <= '1'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000001111";
	when vrf_menor_TP =>
				Sel_mxa <= "010"; Sel_mxb <= "11"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000001111";
	when dec_TR =>
				Sel_mxa <= "001"; Sel_mxb <= "11"; Sel_alu <= "11";
				LDD <= '1'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000001111";
	when vrf_maior_0 =>
				Sel_mxa <= "000"; Sel_mxb <= "11"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000001111";
	when carrega_TFP =>
				Sel_mxa <= "010"; Sel_mxb <= "XX"; Sel_alu <= "00";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '1'; IT <= '0';
				LD <= "100110000011";
	when TFP_reduzido  =>
				Sel_mxa <= "110"; Sel_mxb <= "00"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '1'; IT <= '0'; 
				LD <= "100110000011";
	when decresce_TFP  =>
				Sel_mxa <= "001"; Sel_mxb <= "00"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '1'; IT <= '0'; 
				LD <= "100110000011";
	when tempo_TFP =>
			Sel_mxa <= "XXX"; Sel_mxb <= "XX"; Sel_alu <= "XX";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '1'; 
				LD <= "100110000011";
	when TFP_comp_0  =>
				Sel_mxa <= "000"; Sel_mxb <= "00"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100110000011";
	when ama_TAP  =>
				Sel_mxa <= "XXX"; Sel_mxb <= "XX"; Sel_alu <= "XX";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '1'; 
				LD <= "101000000011";	
	when carrega_TFT  =>
				Sel_mxa <= "100"; Sel_mxb <= "XX"; Sel_alu <= "00";
				LDD <= '0'; LDC <= '1'; LDB <= '0'; LDA <= '0'; IT <= '0'; RS <= '1';
				LD <= "010000001111";				
	when decresce_TFT  =>
				Sel_mxa <= "001"; Sel_mxb <= "10"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '1'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "010000001111";
	when tempo_TFT =>
			Sel_mxa <= "XXX"; Sel_mxb <= "XX"; Sel_alu <= "XX";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '1'; 
				LD <= "010000001111";				
	when TFT_comp_0  =>
				Sel_mxa <= "000"; Sel_mxb <= "10"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; RS <= '0';
				LD <= "010000001111";
	when carrega_TFS  =>
				Sel_mxa <= "011"; Sel_mxb <= "XX"; Sel_alu <= "00";
				LDD <= '0'; LDC <= '0'; LDB <= '1'; LDA <= '0'; IT <= '0'; 
				LD <= "100000111100";
	when decresce_TFS  =>
				Sel_mxa <= "001"; Sel_mxb <= "01"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '1'; LDA <= '0'; IT <= '0'; 
				LD <= "100000111100";
	when tempo_TFS =>
			Sel_mxa <= "XXX"; Sel_mxb <= "XX"; Sel_alu <= "XX";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '1'; 
				LD <= "100000111100";	
	when TFS_comp_0  =>
				Sel_mxa <= "000"; Sel_mxb <= "01"; Sel_alu <= "11";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '0'; 
				LD <= "100000111100";
	when ama_TAS  =>
				Sel_mxa <= "XXX"; Sel_mxb <= "XX"; Sel_alu <= "XX";
				LDD <= '0'; LDC <= '0'; LDB <= '0'; LDA <= '0'; IT <= '1'; 
				LD <= "100001001100";				
	
	when others => Null;
 end case;
end process Logica_de_Saidas;
end FSM;
