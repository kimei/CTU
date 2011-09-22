----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:11 02/15/2011 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Dependencies: 
--
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;

use work.constants.all;


entity top is
  port(
    -- Inputs from the board
    FPGA100M : in std_logic;
    --   RESET    : in std_logic;

    -- output to the ROCs

    --clocks and resets
    MCLK100   : out std_logic;
    MCLK100_b : out std_logic;

    RESET_ROC_B1   : out std_logic;
    RESET_ROC_B1_b : out std_logic;

    RESET_ROC_B2   : out std_logic;
    RESET_ROC_B2_b : out std_logic;

    --Sync Trigger trigger part

    SYNC_TRIGGER_OUT   : out std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
    SYNC_TRIGGER_OUT_b : out std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
    SYNC_TRIGGER_IN    : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
    SYNC_TRIGGER_IN_b  : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

    -- on board bells and whistles
    LEDS       : out std_logic_vector(0 to 7);
    BUTTONS    : in  std_logic_vector(3 downto 0);
    DIP_SWITCH : in  std_logic_vector(7 downto 0);





    EMAC0CLIENTRXDVLD         : out std_logic;
    EMAC0CLIENTRXFRAMEDROP    : out std_logic;
    EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
    EMAC0CLIENTRXSTATSVLD     : out std_logic;
    EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;
    CLIENTEMAC0TXIFGDELAY     : in  std_logic_vector(7 downto 0);
    EMAC0CLIENTTXSTATS        : out std_logic;
    EMAC0CLIENTTXSTATSVLD     : out std_logic;
    EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;
    CLIENTEMAC0PAUSEREQ       : in  std_logic;
    CLIENTEMAC0PAUSEVAL       : in  std_logic_vector(15 downto 0);
    GTX_CLK_0                 : in  std_logic;
    GMII_TXD_0                : out std_logic_vector(7 downto 0);
    GMII_TX_EN_0              : out std_logic;
    GMII_TX_ER_0              : out std_logic;
    GMII_TX_CLK_0             : out std_logic;
    GMII_RXD_0                : in  std_logic_vector(7 downto 0);
    GMII_RX_DV_0              : in  std_logic;
    GMII_RX_ER_0              : in  std_logic;
    GMII_RX_CLK_0             : in  std_logic;
    REFCLK_100MHz             : in  std_logic;
    --  RESET                           : in  std_logic;
    PHY_RESET_0               : out std_logic;

    MII_TX_CLK_0              : in  std_logic;
    GMII_COL_0                : in  std_logic;
    GMII_CRS_0                : in  std_logic;
    -- TEMAC 1:
    CLIENTEMAC1TXIFGDELAY     : in  std_logic_vector(7 downto 0);
    CLIENTEMAC1PAUSEREQ       : in  std_logic;
    CLIENTEMAC1PAUSEVAL       : in  std_logic_vector(15 downto 0);
    GTX_CLK_1                 : in  std_logic;
    GMII_RXD_1                : in  std_logic_vector(7 downto 0);
    GMII_RX_DV_1              : in  std_logic;
    GMII_RX_ER_1              : in  std_logic;
    GMII_RX_CLK_1             : in  std_logic;
    REFCLK                    : in  std_logic;
    --RESET                     : in  std_logic;
    PHY_RESET_1               : out std_logic;
    EMAC1CLIENTRXDVLD         : out std_logic;
    EMAC1CLIENTRXFRAMEDROP    : out std_logic;
    EMAC1CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
    EMAC1CLIENTRXSTATSVLD     : out std_logic;
    EMAC1CLIENTRXSTATSBYTEVLD : out std_logic;
    EMAC1CLIENTTXSTATS        : out std_logic;
    EMAC1CLIENTTXSTATSVLD     : out std_logic;
    EMAC1CLIENTTXSTATSBYTEVLD : out std_logic;
    GMII_TXD_1                : out std_logic_vector(7 downto 0);
    GMII_TX_EN_1              : out std_logic;
    GMII_TX_ER_1              : out std_logic;
    GMII_TX_CLK_1             : out std_logic


    );
end top;
architecture Behavioral of top is
  

  
  signal trig_in_se        : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_in_se_masked : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_out_se       : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_out_se_sync  : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_out_se_rand  : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

  signal mrst_from_udp_b : std_logic;
  signal en_rand_trig    : std_logic;
  signal en_or_trigger_s : std_logic;
  signal trigger_mask    : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal module_mask_s   : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);

  signal mrst_from_udp_b_us : std_logic;
  signal en_rand_trig_us    : std_logic;
  signal en_or_trigger_s_us : std_logic;
  signal trigger_mask_us    : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal module_mask_s_us   : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);

  signal mrst_from_udp_b_buf : std_logic;
  signal en_rand_trig_buf    : std_logic;
  signal en_or_trigger_s_buf : std_logic;
  signal trigger_mask_buf    : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal module_mask_s_buf   : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);



  signal trig_out_se2 : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

  signal trigled  : std_logic;
  signal trigled0 : std_logic;
  signal trigled1 : std_logic;

  signal clk125 : std_logic;
  signal clk200 : std_logic;
  signal mclk   : std_logic;            -- 100
  signal rst_b  : std_logic;
  signal rst    : std_logic;

  signal reset_roc_int_b1 : std_logic;
  signal reset_roc_int_b2 : std_logic;
  signal reset_roc_int_b  : std_logic;

  signal reset_i : std_logic;

  signal buttons_deb : std_logic_vector(3 downto 0);
  
begin

  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------

  G1 : for I in 0 to (NUMBER_OF_ROCS-1) generate
--    diff_in : work.components.IBUFDS port map (
    diff_in : IBUFDS generic map (DIFF_TERM => true)
      port map (
        I  => SYNC_TRIGGER_IN(I),
        IB => SYNC_TRIGGER_IN_b (I),
        O  => trig_in_se(I));
  end generate G1;

  G2 : for I in 0 to (NUMBER_OF_MODULES-1) generate
    --diff_out : work.components.OBUFDS port map (
    diff_out : OBUFDS
      generic map (
        SLEW => "FAST"
        )
      port map (
        O  => SYNC_TRIGGER_OUT(I),
        OB => SYNC_TRIGGER_OUT_b(I),
        I  => trig_out_se2(I));
  end generate G2;


  Inst_SwitchDebouncer : entity work.SwitchDebouncer
    generic map(
      CLK_FREQ     => 100000000,
      NUM_SWITCHES => 4) 
    port map(
      clk         => mclk,
      reset       => rst_b,
      switchesIn  => BUTTONS,
      switchesOut => buttons_deb
      );


  Inst_CRU : entity work.CRU port map(
    fpga_100m_clk  => FPGA100M,
    fpga_cpu_reset => reset_i ,
    clk200         => clk200,
    clk125         => clk125,
    mclk           => MCLK100,
    mclk_b         => MCLK100_b ,
    gclk           => mclk,
    mrst_b         => reset_roc_int_b1,
    lrst_b         => rst_b
    );


  sync_trigger_1 : entity work.sync_trigger
    port map (
      rst_b         => rst_b,
      mclk          => mclk,
      en_or_trigger => en_or_trigger_s,
      module_mask   => module_mask_s,
      trigger_in    => trig_in_se_masked,
      trigger_out   => trig_out_se_sync);



  





  Inst_rand_trigger : entity work.rand_trigger
    port map(
      rst_b       => rst_b,
      mclk        => mclk,
      trigger_out => trig_out_se_rand);

  --MCLK_DIFF_OUT : work.components.OBUFDS port map (
  MCLK_DIFF_OUT1 : OBUFDS port map(
    O  => RESET_ROC_B1,
    OB => RESET_ROC_B1_b,
    I  => reset_roc_int_b);

  --    MCLK_DIFF_OUT2 : work.components.OBUFDS port map (
  MCLK_DIFF_OUT2 : OBUFDS port map(
    O  => RESET_ROC_B2,
    OB => RESET_ROC_B2_b,
    I  => reset_roc_int_b);


  

  EMAC_0 : entity work.v5_emac_v1_5_example_design
    port map (
      --input for sending data
      rate_cards  => trig_in_se_masked,
      coincidence => trig_out_se,

      rst_b_from_rocs_to_async_trigger => reset_roc_int_b,
      clk100                           => mclk,

      mrst_from_udp_b_ent   => mrst_from_udp_b_us,
      en_random_trigger_ent => en_rand_trig_us,
      en_or_trigger         => en_or_trigger_s_us,
      trigger_mask          => trigger_mask_us,
      module_mask           => module_mask_s_us,

      clk200                    => clk200,
      rst_b                     => rst_b,
      EMAC0CLIENTRXDVLD         => EMAC0CLIENTRXDVLD,
      EMAC0CLIENTRXFRAMEDROP    => EMAC0CLIENTRXFRAMEDROP,
      EMAC0CLIENTRXSTATS        => EMAC0CLIENTRXSTATS,
      EMAC0CLIENTRXSTATSVLD     => EMAC0CLIENTRXSTATSVLD,
      EMAC0CLIENTRXSTATSBYTEVLD => EMAC0CLIENTRXSTATSBYTEVLD,
      CLIENTEMAC0TXIFGDELAY     => CLIENTEMAC0TXIFGDELAY,
      EMAC0CLIENTTXSTATS        => EMAC0CLIENTTXSTATS,
      EMAC0CLIENTTXSTATSVLD     => EMAC0CLIENTTXSTATSVLD,
      EMAC0CLIENTTXSTATSBYTEVLD => EMAC0CLIENTTXSTATSBYTEVLD,
      CLIENTEMAC0PAUSEREQ       => CLIENTEMAC0PAUSEREQ,
      CLIENTEMAC0PAUSEVAL       => CLIENTEMAC0PAUSEVAL,
      GTX_CLK_0                 => GTX_CLK_0,
      GMII_TXD_0                => GMII_TXD_0,
      GMII_TX_EN_0              => GMII_TX_EN_0,
      GMII_TX_ER_0              => GMII_TX_ER_0,
      GMII_TX_CLK_0             => GMII_TX_CLK_0,
      GMII_RXD_0                => GMII_RXD_0,
      GMII_RX_DV_0              => GMII_RX_DV_0,
      GMII_RX_ER_0              => GMII_RX_ER_0,
      GMII_RX_CLK_0             => GMII_RX_CLK_0,
      MII_TX_CLK_0              => MII_TX_CLK_0,
      PHY_RESET_0               => PHY_RESET_0,
      GMII_COL_0                => GMII_COL_0,
      GMII_CRS_0                => GMII_CRS_0);

  
  Inst_TEMAC2_example_design : entity work.TEMAC2_example_design port map(
    EMAC1CLIENTRXDVLD         => EMAC1CLIENTRXDVLD,
    EMAC1CLIENTRXFRAMEDROP    => EMAC1CLIENTRXFRAMEDROP,
    EMAC1CLIENTRXSTATS        => EMAC1CLIENTRXSTATS,
    EMAC1CLIENTRXSTATSVLD     => EMAC1CLIENTRXSTATSVLD,
    EMAC1CLIENTRXSTATSBYTEVLD => EMAC1CLIENTRXSTATSBYTEVLD,
    CLIENTEMAC1TXIFGDELAY     => CLIENTEMAC1TXIFGDELAY,
    EMAC1CLIENTTXSTATS        => EMAC1CLIENTTXSTATS,
    EMAC1CLIENTTXSTATSVLD     => EMAC1CLIENTTXSTATSVLD,
    EMAC1CLIENTTXSTATSBYTEVLD => EMAC1CLIENTTXSTATSBYTEVLD,
    CLIENTEMAC1PAUSEREQ       => CLIENTEMAC1PAUSEREQ,
    CLIENTEMAC1PAUSEVAL       => CLIENTEMAC1PAUSEVAL,
    GTX_CLK_1                 => GTX_CLK_1,
    GMII_TXD_1                => GMII_TXD_1,
    GMII_TX_EN_1              => GMII_TX_EN_1,
    GMII_TX_ER_1              => GMII_TX_ER_1,
    GMII_TX_CLK_1             => GMII_TX_CLK_1,
    GMII_RXD_1                => GMII_RXD_1,
    GMII_RX_DV_1              => GMII_RX_DV_1,
    GMII_RX_ER_1              => GMII_RX_ER_1,
    GMII_RX_CLK_1             => GMII_RX_CLK_1,
    REFCLK                    => clk200,
    RESET                     => rst,
    PHY_RESET_1               => PHY_RESET_1,


-- fe_trigger_ready          => fe_trigger_ready,  -- change to trigger information!!
    --  fe_trigger_data_packed    => fe_trigger_data,
    --  TriggerTimeBack           => TriggerTimeBack,
    --   TriggerTimeBackRdy        => TriggerTimeBackRdy,
    mclk                             => mclk,  -- needs to run with
                                               -- 100MHz!! Trigger time
                                               -- packages run with this speed.
    rst_b_from_rocs_to_async_trigger => reset_roc_int_b,
    en_or_trigger                    => en_or_trigger_s_us,
    en_rand_trigger                  => en_rand_trig_us,
    rst_b                            => rst_b
    --  coincidence_trigger       => coincidence_trigger_i,

    --FPGA_conf => FPGA_conf,

    --cs_ila_trig0 => cs_ila_ToUDP2
    --  cs_ila_trig0 => open
    );










  -----------------------------------------------------------------------------
  -- COMBINATORICAL
  -----------------------------------------------------------------------------
  rst             <= not rst_b;
  trig_out_se2    <= (others => '1') when (trig_out_se(0) = '1') or (buttons_deb(1) = '1') else (others => '0');
  reset_roc_int_b <= reset_roc_int_b1 and reset_roc_int_b2;


  trigled0 <= trig_out_se2(0);

  LEDS(1) <= trigled;

  reset_i <= BUTTONS(0);

  LEDS(2 to 7) <= (others => '1');


  reset_roc_int_b2 <= (not buttons_deb(2)) and mrst_from_udp_b;

  trig_out_se <= trig_out_se_sync when en_rand_trig = '0' else trig_out_se_rand;
  LEDS(0)     <= en_rand_trig;

  trig_in_se_masked <= trig_in_se and trigger_mask;

-------------------------------------------------------------------------------
-- Processes
-------------------------------------------------------------------------------

  triggerled : process (mclk, rst_b)
  begin
    if rst_b = '0' then
      trigled1 <= '0';
      trigled  <= '0';
    elsif mclk'event and mclk = '1' then
      trigled1 <= trigled0;
      if ((trigled0 = '1') and (trigled1 = '0')) then
        trigled <= not trigled;
      else
        trigled <= trigled;
      end if;
    end if;
  end process triggerled;


  sync_contr_signals : process(mclk, rst_b)
  begin
    if rst_b = '0' then
      en_rand_trig_buf    <= '0';
      en_or_trigger_s_buf <= '0';
      trigger_mask_buf    <= (others => '1');
      module_mask_s_buf   <= (others => '1');
    elsif mclk'event and mclk = '1' then
      en_rand_trig_buf    <= en_rand_trig_us;
      en_or_trigger_s_buf <= en_or_trigger_s_us;
      trigger_mask_buf    <= trigger_mask_us;
      module_mask_s_buf   <= module_mask_s_us;
      mrst_from_udp_b_buf <= mrst_from_udp_b_us;

      mrst_from_udp_b <= mrst_from_udp_b_buf;
      en_rand_trig    <= en_rand_trig_buf;
      en_or_trigger_s <= en_or_trigger_s_buf;
      trigger_mask    <= trigger_mask_buf;
      module_mask_s   <= module_mask_s_buf;

    end if;
  end process sync_contr_signals;


end Behavioral;




