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
use work.components.all;
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



    --Communication
    --uart



    -- memory

    -- from system.vhi


--    fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin  : in std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin : in std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin  : in std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin    : in std_logic_vector(7 downto 0);
--    fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin  : in std_logic;


--    fpga_0_FLASH_8Mx16_Mem_DQ_pin       : inout std_logic_vector(0 to 15);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS   : inout std_logic_vector(3 downto 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N : inout std_logic_vector(3 downto 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ    : inout std_logic_vector(31 downto 0);
--    fpga_0_Hard_Ethernet_MAC_MDIO_0_pin : inout std_logic;


--    fpga_0_FLASH_8Mx16_Mem_A_pin                : out std_logic_vector(7 to 31);
--    fpga_0_FLASH_8Mx16_Mem_WEN_pin              : out std_logic;
--    fpga_0_FLASH_8Mx16_Mem_OEN_pin              : out std_logic_vector(0 to 0);
--    fpga_0_FLASH_8Mx16_Mem_CEN_pin              : out std_logic_vector(0 to 0);
--    fpga_0_FLASH_8Mx16_rpn_dummy_pin            : out std_logic;
--    fpga_0_FLASH_8Mx16_byte_dummy_pin           : out std_logic;
--    fpga_0_FLASH_8Mx16_adv_dummy_pin            : out std_logic;
--    fpga_0_FLASH_8Mx16_clk_dummy_pin            : out std_logic;
--    fpga_0_FLASH_8Mx16_wait_dummy_pin           : out std_logic;
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin       : out std_logic_vector(0 to 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin         : out std_logic_vector(12 downto 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin        : out std_logic_vector(1 downto 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin     : out std_logic;
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin       : out std_logic;
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin      : out std_logic;
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin     : out std_logic;
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin      : out std_logic;
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin        : out std_logic_vector(3 downto 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin        : out std_logic_vector(1 downto 0);
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin      : out std_logic_vector(1 downto 0);
--    fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin : out std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin     : out std_logic_vector(7 downto 0);
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin   : out std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin  : out std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin   : out std_logic;
--    fpga_0_Hard_Ethernet_MAC_MDC_0_pin          : out std_logic;
--    fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin    : out std_logic


    -- PHY interface
    EMAC0CLIENTRXDVLD         : out std_logic;
    EMAC0CLIENTRXFRAMEDROP    : out std_logic;
    EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
    EMAC0CLIENTRXSTATSVLD     : out std_logic;
    EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;

    -- Client Transmitter Interface - EMAC0
    CLIENTEMAC0TXIFGDELAY     : in  std_logic_vector(7 downto 0);
    EMAC0CLIENTTXSTATS        : out std_logic;
    EMAC0CLIENTTXSTATSVLD     : out std_logic;
    EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;

    -- MAC Control Interface - EMAC0
    CLIENTEMAC0PAUSEREQ : in std_logic;
    CLIENTEMAC0PAUSEVAL : in std_logic_vector(15 downto 0);


    -- Clock Signals - EMAC0
    GTX_CLK_0 : in std_logic;

    -- GMII Interface - EMAC0
    GMII_TXD_0    : out std_logic_vector(7 downto 0);
    GMII_TX_EN_0  : out std_logic;
    GMII_TX_ER_0  : out std_logic;
    GMII_TX_CLK_0 : out std_logic;
    GMII_RXD_0    : in  std_logic_vector(7 downto 0);
    GMII_RX_DV_0  : in  std_logic;
    GMII_RX_ER_0  : in  std_logic;
    GMII_RX_CLK_0 : in  std_logic;

    MII_TX_CLK_0 : in  std_logic;
    PHY_RESET_0  : out std_logic;
    GMII_COL_0   : in  std_logic;
    GMII_CRS_0   : in  std_logic

    );
end top;
architecture Behavioral of top is

  signal trig_in_se       : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_out_se      : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_out_se_sync : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  signal trig_out_se_rand : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

  signal en_rand_trig_buf0 : std_logic;
  signal en_rand_trig      : std_logic;

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

  signal reset : std_logic;

  signal buttons_deb : std_logic_vector(3 downto 0);
  
begin

  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------

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


  Inst_CRU : CRU port map(
    fpga_100m_clk  => FPGA100M,
    fpga_cpu_reset => RESET ,
    clk200         => clk200,
    clk125         => clk125,
    mclk           => MCLK100,
    mclk_b         => MCLK100_b ,
    gclk           => mclk,
    mrst_b         => reset_roc_int_b1,
    lrst_b         => rst_b
    );


  sync_trigger_1 : sync_trigger
    port map (
      rst_b       => rst_b,
      mclk        => mclk,
      trigger_in  => trig_in_se,
      trigger_out => trig_out_se_sync);



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

  EMAC_1 : v5_emac_v1_5_example_design
    port map (
      --input for sending data
      rate_cards  => trig_in_se,
      coincidence => trig_out_se,


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
  -----------------------------------------------------------------------------
  -- COMBINATORICAL
  -----------------------------------------------------------------------------
  rst             <= not rst_b;
  trig_out_se2    <= (others => '1') when (trig_out_se(0) = '1') or (buttons_deb(1) = '1') else (others => '0');
  reset_roc_int_b <= reset_roc_int_b1 and reset_roc_int_b2;


  trigled0 <= trig_out_se2(0);

  LEDS(1) <= trigled;

  reset <= BUTTONS(0);

  LEDS(2 to 6) <= (others => '0');


  reset_roc_int_b2 <= not buttons_deb(2);

  trig_out_se <= trig_out_se_sync when en_rand_trig = '0' else trig_out_se_rand;
  LEDS(0)     <= en_rand_trig;

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
      if ((trigled0 = '1)' and (trigled1 = '0')) then
        trigled <= not trigled;
      else
        trigled <= trigled;
      end if;
    end if;
  end process triggerled;


  triggerswitch : process (mclk, rst_b)
  begin
    if rst_b = '0' then
      en_rand_trig      <= '0';
      en_rand_trig_buf0 <= '0';
    elsif mclk'event and mclk = '1' then
      en_rand_trig_buf0 <= buttons_deb(3);
      if en_rand_trig_buf0 = '0' and buttons_deb(3) = '1' then
        en_rand_trig <= not en_rand_trig;
      end if;
      
    end if;
  end process triggerswitch;







  -- PPC.. not used yet..
--  Inst_system : system port map(
--    sys_clk_pin => mclk ,
--    sys_rst_pin => rst,

--    fpga_0_RS232_sin_pin  => rx ,
--    fpga_0_RS232_sout_pin => tx,

--    fpga_0_LEDs_8Bit_GPIO_d_out_pin      => uc_leds ,
--    fpga_0_DIP_Switches_8Bit_GPIO_in_pin => DIP_SWITCH ,
--    fpga_0_Push_Buttons_3Bit_GPIO_in_pin => uc_buttons ,

--    fpga_0_FLASH_8Mx16_Mem_DQ_pin  => fpga_0_FLASH_8Mx16_Mem_DQ_pin,
--    fpga_0_FLASH_8Mx16_Mem_A_pin   => fpga_0_FLASH_8Mx16_Mem_A_pin,
--    fpga_0_FLASH_8Mx16_Mem_WEN_pin => fpga_0_FLASH_8Mx16_Mem_WEN_pin ,
--    fpga_0_FLASH_8Mx16_Mem_OEN_pin => fpga_0_FLASH_8Mx16_Mem_OEN_pin ,
--    fpga_0_FLASH_8Mx16_Mem_CEN_pin => fpga_0_FLASH_8Mx16_Mem_CEN_pin ,

--    fpga_0_FLASH_8Mx16_rpn_dummy_pin  => fpga_0_FLASH_8Mx16_rpn_dummy_pin ,
--    fpga_0_FLASH_8Mx16_byte_dummy_pin => fpga_0_FLASH_8Mx16_byte_dummy_pin ,
--    fpga_0_FLASH_8Mx16_adv_dummy_pin  => fpga_0_FLASH_8Mx16_adv_dummy_pin,
--    fpga_0_FLASH_8Mx16_clk_dummy_pin  => fpga_0_FLASH_8Mx16_clk_dummy_pin ,
--    fpga_0_FLASH_8Mx16_wait_dummy_pin => fpga_0_FLASH_8Mx16_wait_dummy_pin,

--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin       => fpga_0_DDR2_SDRAM_16Mx32_DDR2_ODT_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin         => fpga_0_DDR2_SDRAM_16Mx32_DDR2_A_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin        => fpga_0_DDR2_SDRAM_16Mx32_DDR2_BA_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin     => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CAS_N_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin       => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CKE_pin,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin      => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CS_N_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin     => fpga_0_DDR2_SDRAM_16Mx32_DDR2_RAS_N_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin      => fpga_0_DDR2_SDRAM_16Mx32_DDR2_WE_N_pin,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin        => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DM_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS           => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N         => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQS_N ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ            => fpga_0_DDR2_SDRAM_16Mx32_DDR2_DQ ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin        => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_pin ,
--    fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin      => fpga_0_DDR2_SDRAM_16Mx32_DDR2_CK_N_pin ,
--    fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin => fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin ,
--    fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin     => fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin   => fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin,
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin  => fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin,
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin   => fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin   => fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin  => fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin   => fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin,
--    fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin     => fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin   => fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_MDC_0_pin          => fpga_0_Hard_Ethernet_MAC_MDC_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_MDIO_0_pin         => fpga_0_Hard_Ethernet_MAC_MDIO_0_pin ,
--    fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin    => fpga_0_Hard_Ethernet_MAC_PHY_MII_INT_pin
--    );


end Behavioral;




