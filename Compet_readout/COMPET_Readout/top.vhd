----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:04:03 10/08/2010 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
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

library work;
use work.constants.all;                 --! Global constants
use work.types.all;                     --! Global types
use work.functions.all;                 --! Global functions



library unisim;
use unisim.vcomponents.all;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  port(
    --switches:
    Switch    : in  std_logic_vector(3 downto 0);
    LEDs      : out std_logic_vector(7 downto 0);
    --data lines:
    fe_data_p : in  std_logic_vector(fe_NUM_DIFF_CHANNELS-1 downto 0);
    fe_data_n : in  std_logic_vector(fe_NUM_DIFF_CHANNELS-1 downto 0);
    --fe_data_p          : in  std_logic_vector(8-1 downto 0) ;
    --fe_data_n          : in  std_logic_vector(8-1 downto 0) ;
    --fe_data_SE         : in  std_logic_vector(fe_NUM_SE_CHANNELS-1 downto 0);

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

    MII_TX_CLK_0 : in std_logic;
    GMII_COL_0   : in std_logic;
    GMII_CRS_0   : in std_logic;


    -- added by kim
    -- FROM CTU
    CLK100_CTU_p   : in  std_logic;     -- differential clk input from CTU
    CLK100_CTU_n   : in  std_logic;     -- goes to CLK100_CTU after IBUFDS
    clk100m_out    : out std_logic;     -- differential clk input from CTU
    clk100m_out_b  : out std_logic;
    RST_GLOBAL_CTU : in  std_logic
    -- end added by kim         

    );

end top;

architecture Behavioral of top is

  signal GMII_TXD_0_bf : std_logic_vector(7 downto 0);

  component UDP_dcm
    port(
      CLKIN_IN        : in  std_logic;
      RST_IN          : in  std_logic;
      CLKFX_OUT       : out std_logic;
      CLKIN_IBUFG_OUT : out std_logic;
      CLK0_OUT        : out std_logic;
      CLK2X_OUT       : out std_logic;
      LOCKED_OUT      : out std_logic
      );
  end component;

  component v5_emac_v1_5_example_design
    port(

      CLIENTEMAC0TXIFGDELAY : in std_logic_vector(7 downto 0);
      CLIENTEMAC0PAUSEREQ   : in std_logic;
      CLIENTEMAC0PAUSEVAL   : in std_logic_vector(15 downto 0);
      GTX_CLK_0             : in std_logic;
      GMII_RXD_0            : in std_logic_vector(7 downto 0);
      GMII_RX_DV_0          : in std_logic;
      GMII_RX_ER_0          : in std_logic;
      GMII_RX_CLK_0         : in std_logic;
      REFCLK_200MHz         : in std_logic;
      reset_i               : in std_logic;

      EMAC0CLIENTRXDVLD         : out std_logic;
      EMAC0CLIENTRXFRAMEDROP    : out std_logic;
      EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD     : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;
      EMAC0CLIENTTXSTATS        : out std_logic;
      EMAC0CLIENTTXSTATSVLD     : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;
      GMII_TXD_0                : out std_logic_vector(7 downto 0);
      GMII_TX_EN_0              : out std_logic;
      GMII_TX_ER_0              : out std_logic;
      GMII_TX_CLK_0             : out std_logic;
      PHY_RESET_0               : out std_logic;
      fe_event_ready            : in  std_logic;
      fe_event_data_packed      : in  std_logic_vector(31 downto 0);
      mclk                      : in  std_logic;
      fe_rst_b                  : in  std_logic;
      LEDs                      : out std_logic_vector(7 downto 0);
      MII_TX_CLK_0              : in  std_logic;
      GMII_COL_0                : in  std_logic;
      GMII_CRS_0                : in  std_logic;
      cs_ila_trig0              : out std_logic_vector(cs_ILA_SIZE-1 downto 0);
      coincidence_trigger       : in  std_logic;
      temac_clk_out             : out std_logic;
      FPGA_conf                 : out FPGA_conf_type
      );
  end component;

  signal temac_clk_out : std_logic;

  signal LEDs_bf : std_logic_vector(7 downto 0);
  signal LEDs_fe : std_logic_vector(7 downto 0);


  signal reset_i       : std_logic;
  signal REFCLK_200MHz : std_logic;
  signal RESET_b       : std_logic;
  signal UDPRst_200_b  : std_logic;
  signal UDPRst_200    : std_logic;


--chipscope:
  signal cs_vio_out : std_logic_vector(cs_VIO_SIZE-1 downto 0);
--signal cs_vio_fe          : std_logic_vector( 31 downto 0 );

--     cs_clk          : in  std_logic;
  signal cs_ila_trig0  : std_logic_vector(cs_ILA_SIZE-1 downto 0);
-- signal cs_vio_out      : std_logic_vector( 63 downto 0 );
  signal cs_ila_ToUDP  : std_logic_vector(cs_ILA_SIZE-1 downto 0);
  signal cs_fe         : std_logic_vector(127 downto 0);
  signal cs_vio        : cs_vio_type;
  signal cs_vio_packed : std_logic_vector(cs_VIO_SIZE-1 downto 0);

  signal FPGA_conf        : FPGA_conf_type;
  signal FPGA_conf_packed : std_logic_vector(FPGA_CONF_SIZE-1 downto 0);



--trigger signals:
  signal coincidence_trigger : std_logic;  -- coming from the trigger unit
  signal fe_event_trigger    : std_logic;  -- sent to the trigger unit

  signal event_trigger_delayed : std_logic;
  signal window_length         : std_logic_vector(2 downto 0) := (others => '0');

--clock:
  signal mclk   : std_logic;
  signal mclk0  : std_logic;            --40MHz
  signal fe_clk : std_logic;

  signal mrst_b   : std_logic;
  signal fe_rst_b : std_logic;


  signal fe_data              : std_logic_vector(fe_NUM_CHANNELS-1 downto 0);
  signal fe_event_ready_out   : std_logic;
  signal fe_event_data_out    : fe_ch_event_data_type;
  signal fe_event_data_packed : std_logic_vector(31 downto 0);


--signal REFCLK_125MHz: std_logic;

--signal fe_data_empty :std_logic_vector(fe_NUM_EMPTY_CHANNELS-1 downto 0);


begin
  RESET_b <= not Switch(0);
--LEDs(3 downto 0) <= Switch(3 downto 0);
  LEDs    <= LEDs_bf;
--LEDs(2 downto 0) <= fe_event_data_out.ch_no(2 downto 0);
--LEDs(3) <= fe_event_ready_out;
--LEDs(7 downto 4) <= (OTHERS => '0');

  UDPRst_200 <= not UDPRst_200_b;
--reset_ibuf : BUFG port map (I => RESET, O => reset_i);

  Inst_cru : entity work.cru port map(
    fpga_100m_clk    => REFCLK_100MHz,
    fpga_cpu_reset_b => RESET_b,

    -- added by kim
    clk100m_ctu       => CLK100_CTU_p,
    clk100m_ctu_b     => CLK100_CTU_n,
    cru_reset         => RST_GLOBAL_CTU,
    clk100m_ctu_out   => clk100m_out ,
    clk100m_ctu_out_b => clk100m_out_b ,
    -- end added by kim

    up_clk        => open,
    fe_clk        => fe_clk,
    mclk          => mclk,
    mclk0         => mclk0,
    REFCLK_200MHz => RefClk_200MHz,
    REFCLK_125MHz => open,
    up_rst_b      => open,
    fe_rst_b      => fe_rst_b,
    mrst_b        => mrst_b,
    UDPRst_200_b  => UDPRst_200_b ,
    UDPRst_125_b  => open
    --cs_vio => 
    );

  GMII_TXD_0 <= GMII_TXD_0_bf;



  foribufFE_DIFF_DATA : for i in 0 to fe_NUM_DIFF_CHANNELS-1 generate
  begin
    ibufFE_DIFF_DATA : IBUFDS generic map (DIFF_TERM => true)
      port map (O => fe_data(i) , I => fe_data_p(i) , IB => fe_data_n(i));
  end generate;
--
--foribufFE_SE_DATA: for i in 0 to fe_NUM_SE_CHANNELS-1 generate begin
--ibuf_FE_SE_DATA:     IBUF
--     port map (O => fe_data(i+fe_NUM_DIFF_CHANNELS) ,
--                I => fe_data_SE(i) );      
--end generate;


-- and the empty channels:
--fe_data_empty <= (OTHERS=> '0');

--fe_data( fe_NUM_CHANNELS-1  downto fe_NUM_SE_CHANNELS+ fe_NUM_DIFF_CHANNELS)  <= fe_data_empty;



  fe_i : entity work.fe port map(
    mclk     => mclk ,                  --! Master clock
    mclk0    => mclk0 ,                 --! Master clock 40MHz
    fe_clk   => fe_clk ,                --! Front-end clock
    fe_rst_b => fe_rst_b ,              --! Front-end reset (active low)

                                        --! XGI Expansion Headers
    fe_data => fe_data ,

    coincidence_trigger => coincidence_trigger ,  --! Recieved from Trigger Unit
    fe_event_trigger    => fe_event_trigger ,     --! Sent to the Trigger Unit

                                        --up_bram              => up_bram               , --! The uP BRAM interface

    cs_vio => cs_vio ,
    cs_fe  => cs_fe,

    fe_event_ready_out => fe_event_ready_out,
    fe_event_data_out  => fe_event_data_out,
    LEDs               => LEDs_fe,
    FPGA_conf          => FPGA_conf
    );


--cs_ila_trig0(31 downto 0) <= fe_event_data_packed ;
--cs_ila_trig0(32)          <= fe_event_ready_out;
--cs_ila_trig0(67 downto 60) <= GMII_TXD_0_bf;
--cs_ila_trig0(96 downto 33) <= cs_fe(63 downto 0);
--cs_ila_trig0(104  downto 97) <= cs_fe(71 downto 64);

--cs_ila_trig0 <= cs_fe;

--LEDs <=  GMII_TXD_0_bf;
  --cs_ila_trig0(32) <= fe_event_ready_out;
  --cs_ila_trig0(31 downto 0) <= pack(fe_event_data_out);

-- Simulate the delay caused by the Trigger Unit when it calculates coincidence window

-----------------------------
-- TRIGGER UNIT SIMULATION --                   ----------------------------------------------
-----------------------------
-- Simulate the delay caused by the Trigger Unit when it calculates coincidence window

-- First, send trigger through a shift-register to delay it
-- delay_line(3) <= fe_event_trigger; -- Shift register input
  --! Delay the AND to synchronise it with coincidence trigger
  shift_event_trigger : entity work.shift
    generic map(
      depth => 3)                       --! Depth of shift-chain
    port map(
      mclk => mclk ,                    --! Clock
      i    => fe_event_trigger ,        --! Input
      s    => 2 ,                       --! Select
      o    => event_trigger_delayed);   --! Output

-- Then create a coincidence trigger window with appropriate width
  process (mclk) begin
                   if rising_edge(mclk) then
                     if(event_trigger_delayed = '1') then
                       window_length <= (others => '1');
                     else
                       window_length <= window_length(window_length'length-2 downto 0) & '0';
                     end if;
                   end if;
                 end process;
                   coincidence_trigger <= '1' when (cs_vio.cotrg_en = '0')
                                          else window_length(window_length'length-1);  -- Woila, window ready.


-- the CS stuff:
                   cs_vio <= unpack_cs_vio(cs_vio_packed);  --Okay since these are all inputs
                   cs : entity work.chipscope
                     port map(
                                        --cs_clk         =>  mclk, 
                       cs_clk       => temac_clk_out,
                       cs_ila_trig0 => cs_ila_trig0 ,
                       cs_vio_out   => cs_vio_packed
                       );

--   cs_vio_out( 63 downto 32 )  <= ( others => '0' )  ;
                   --cs cs_vio_fe   <=   cs_vio_out( 31 downto  0 )     ;








--Inst_dcm: UDP_dcm PORT MAP(
--              CLKIN_IN => REFCLK_100MHz ,
--              RST_IN => reset_i,
--              CLKFX_OUT => open,
--              CLKIN_IBUFG_OUT => open,
--              CLK0_OUT => open,
--              CLK2X_OUT => RefClk_200MHz,
--              LOCKED_OUT => open
--
--
                   Inst_v5_emac_v1_5_example_design : v5_emac_v1_5_example_design port map(

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
                     GMII_TXD_0                => GMII_TXD_0_bf,
                     GMII_TX_EN_0              => GMII_TX_EN_0,
                     GMII_TX_ER_0              => GMII_TX_ER_0,
                     GMII_TX_CLK_0             => GMII_TX_CLK_0,
                     GMII_RXD_0                => GMII_RXD_0 ,
                     GMII_RX_DV_0              => GMII_RX_DV_0,
                     GMII_RX_ER_0              => GMII_RX_ER_0,
                     GMII_RX_CLK_0             => GMII_RX_CLK_0,
                     REFCLK_200MHz             => REFCLK_200MHz,
                     reset_i                   => UDPRst_200,
                     PHY_RESET_0               => PHY_RESET_0,
                     fe_event_ready            => fe_event_ready_out,
                     fe_event_data_packed      => fe_event_data_packed,
                     mclk                      => mclk0,  --runs with 40MHz
                     fe_rst_b                  => fe_rst_b,
                     LEDs                      => LEDs_bf,
                     MII_TX_CLK_0              => MII_TX_CLK_0,
                     GMII_COL_0                => GMII_COL_0,
                     GMII_CRS_0                => GMII_CRS_0,
                     cs_ila_trig0              => cs_ila_ToUDP,
                     coincidence_trigger       => coincidence_trigger,
                     temac_clk_out             => temac_clk_out,
                     FPGA_conf                 => FPGA_conf

                     );
                   cs_ila_trig0         <= cs_ila_ToUDP;
                   fe_event_data_packed <= pack(fe_event_data_out);


                 end Behavioral;

