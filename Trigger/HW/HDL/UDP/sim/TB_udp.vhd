--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:19:14 06/09/2011
-- Design Name:   
-- Module Name:   /home/kimei/VHDL/trigger/Trigger/HW/HDL/UDP/sim/TB_udp.vhd
-- Project Name:  top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: v5_emac_v1_5_example_design
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_udp IS
END TB_udp;
 
ARCHITECTURE behavior OF TB_udp IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT v5_emac_v1_5_example_design
    PORT(
         clk200 : IN  std_logic;
         rst_b : IN  std_logic;
         rate_cards : IN  std_logic_vector(1 downto 0);
         coincidence : IN  std_logic_vector(1 downto 0);
         EMAC0CLIENTRXDVLD : OUT  std_logic;
         EMAC0CLIENTRXFRAMEDROP : OUT  std_logic;
         EMAC0CLIENTRXSTATS : OUT  std_logic_vector(6 downto 0);
         EMAC0CLIENTRXSTATSVLD : OUT  std_logic;
         EMAC0CLIENTRXSTATSBYTEVLD : OUT  std_logic;
         CLIENTEMAC0TXIFGDELAY : IN  std_logic_vector(7 downto 0);
         EMAC0CLIENTTXSTATS : OUT  std_logic;
         EMAC0CLIENTTXSTATSVLD : OUT  std_logic;
         EMAC0CLIENTTXSTATSBYTEVLD : OUT  std_logic;
         CLIENTEMAC0PAUSEREQ : IN  std_logic;
         CLIENTEMAC0PAUSEVAL : IN  std_logic_vector(15 downto 0);
         GTX_CLK_0 : IN  std_logic;
         GMII_TXD_0 : OUT  std_logic_vector(7 downto 0);
         GMII_TX_EN_0 : OUT  std_logic;
         GMII_TX_ER_0 : OUT  std_logic;
         GMII_TX_CLK_0 : OUT  std_logic;
         GMII_RXD_0 : IN  std_logic_vector(7 downto 0);
         GMII_RX_DV_0 : IN  std_logic;
         GMII_RX_ER_0 : IN  std_logic;
         GMII_RX_CLK_0 : IN  std_logic;
         MII_TX_CLK_0 : IN  std_logic;
         PHY_RESET_0 : OUT  std_logic;
         GMII_COL_0 : IN  std_logic;
         GMII_CRS_0 : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk200 : std_logic := '0';
   signal rst_b : std_logic := '0';
   signal rate_cards : std_logic_vector(1 downto 0) := (others => '0');
   signal coincidence : std_logic_vector(1 downto 0) := (others => '0');
   signal CLIENTEMAC0TXIFGDELAY : std_logic_vector(7 downto 0) := (others => '0');
   signal CLIENTEMAC0PAUSEREQ : std_logic := '0';
   signal CLIENTEMAC0PAUSEVAL : std_logic_vector(15 downto 0) := (others => '0');
   signal GTX_CLK_0 : std_logic := '0';
   signal GMII_RXD_0 : std_logic_vector(7 downto 0) := (others => '0');
   signal GMII_RX_DV_0 : std_logic := '0';
   signal GMII_RX_ER_0 : std_logic := '0';
   signal GMII_RX_CLK_0 : std_logic := '0';
   signal MII_TX_CLK_0 : std_logic := '0';
   signal GMII_COL_0 : std_logic := '0';
   signal GMII_CRS_0 : std_logic := '0';

 	--Outputs
   signal EMAC0CLIENTRXDVLD : std_logic;
   signal EMAC0CLIENTRXFRAMEDROP : std_logic;
   signal EMAC0CLIENTRXSTATS : std_logic_vector(6 downto 0);
   signal EMAC0CLIENTRXSTATSVLD : std_logic;
   signal EMAC0CLIENTRXSTATSBYTEVLD : std_logic;
   signal EMAC0CLIENTTXSTATS : std_logic;
   signal EMAC0CLIENTTXSTATSVLD : std_logic;
   signal EMAC0CLIENTTXSTATSBYTEVLD : std_logic;
   signal GMII_TXD_0 : std_logic_vector(7 downto 0);
   signal GMII_TX_EN_0 : std_logic;
   signal GMII_TX_ER_0 : std_logic;
   signal GMII_TX_CLK_0 : std_logic;
   signal PHY_RESET_0 : std_logic;

   -- Clock period definitions
   constant clk200_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: v5_emac_v1_5_example_design PORT MAP (
          clk200 => clk200,
          rst_b => rst_b,
          rate_cards => rate_cards,
          coincidence => coincidence,
          EMAC0CLIENTRXDVLD => EMAC0CLIENTRXDVLD,
          EMAC0CLIENTRXFRAMEDROP => EMAC0CLIENTRXFRAMEDROP,
          EMAC0CLIENTRXSTATS => EMAC0CLIENTRXSTATS,
          EMAC0CLIENTRXSTATSVLD => EMAC0CLIENTRXSTATSVLD,
          EMAC0CLIENTRXSTATSBYTEVLD => EMAC0CLIENTRXSTATSBYTEVLD,
          CLIENTEMAC0TXIFGDELAY => CLIENTEMAC0TXIFGDELAY,
          EMAC0CLIENTTXSTATS => EMAC0CLIENTTXSTATS,
          EMAC0CLIENTTXSTATSVLD => EMAC0CLIENTTXSTATSVLD,
          EMAC0CLIENTTXSTATSBYTEVLD => EMAC0CLIENTTXSTATSBYTEVLD,
          CLIENTEMAC0PAUSEREQ => CLIENTEMAC0PAUSEREQ,
          CLIENTEMAC0PAUSEVAL => CLIENTEMAC0PAUSEVAL,
          GTX_CLK_0 => GTX_CLK_0,
          GMII_TXD_0 => GMII_TXD_0,
          GMII_TX_EN_0 => GMII_TX_EN_0,
          GMII_TX_ER_0 => GMII_TX_ER_0,
          GMII_TX_CLK_0 => GMII_TX_CLK_0,
          GMII_RXD_0 => GMII_RXD_0,
          GMII_RX_DV_0 => GMII_RX_DV_0,
          GMII_RX_ER_0 => GMII_RX_ER_0,
          GMII_RX_CLK_0 => GMII_RX_CLK_0,
          MII_TX_CLK_0 => MII_TX_CLK_0,
          PHY_RESET_0 => PHY_RESET_0,
          GMII_COL_0 => GMII_COL_0,
          GMII_CRS_0 => GMII_CRS_0
        );

   -- Clock process definitions
   clk200_process :process
   begin
		clk200 <= '0';
		wait for clk200_period/2;
		clk200 <= '1';
		wait for clk200_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process

    begin
   rate_cards <= (others => '0');
   coincidence <= (others => '0');
	   GMII_CRS_0 <= '0';

   rst_b <= '0';
   wait for 40 ns;
    rst_b         <= '1';
    wait for 80 ns;
    rate_cards(0) <= '1';
    wait for 40 ns;
    rate_cards(0) <= '0';
    rate_cards(1) <= '1';
    wait for 20 ns;
    rate_cards(1) <= '0';
    wait for 30 ns;
    coincidence   <= (others => '1');
    wait for 20 ns;
    coincidence   <= (others => '0');

   wait for 150 us;
   wait for 5 ns;
   GMII_CRS_0 <= '1';
   wait for 1290 ns;
   GMII_CRS_0 <= '0';
   
    wait;
   
   end process;

END;
