--! \file
--! \brief Component declarations.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;             --! For simulation
library work;
use work.constants.all;                 --! Global constants
use work.types.all;                     --! Global types, like records etc.


--! \brief Components
package components is

  component cru
    port(
      fpga_100m_clk    : in std_logic;
      fpga_cpu_reset_b : in std_logic;
      --cs_vio : IN std_logic;

      -- added by kim
      clk100m_ctu   : in std_logic;
      clk100m_ctu_b : in std_logic;
      cru_reset      : in std_logic;
      clk100m_ctu_out   : out std_logic;
      clk100m_ctu_out_b : out std_logic;
      -- end added by kim

      up_clk        : out std_logic;
      fe_clk        : out std_logic;
      mclk          : out std_logic;
      mclk0         : out std_logic;
      REFCLK_200MHz : out std_logic;
      REFCLK_125MHz : out std_logic;
      up_rst_b      : out std_logic;
      fe_rst_b      : out std_logic;
      mrst_b        : out std_logic;
      UDPRst_200_b  : out std_logic;
      UDPRst_125_b  : out std_logic
      );
  end component;

  component a2s
    generic(
      depth : positive := 2             --! Depth
      );
    port(
      arst_b : in  std_logic;           --! Synchronous  reset
      srst_b : in  std_logic;           --! Asynchronous reset
      clk    : in  std_logic;           --! Synchronisation clock
      i      : in  std_logic;           --! Asynchronous input
      o      : out std_logic            --! Synchronous  output (metafiltered)
      );
  end component;


--      COMPONENT pll_all
--      PORT(
--              CLKIN1_IN : IN std_logic;
--              RST_IN : IN std_logic;          
--              CLKOUT0_OUT : OUT std_logic;
--              CLKOUT1_OUT : OUT std_logic;
--              CLKOUT2_OUT : OUT std_logic;
--              CLKOUT3_OUT : OUT std_logic;
--              CLKOUT4_OUT : OUT std_logic;
--              LOCKED_OUT : OUT std_logic
--              );
--      END COMPONENT;

--  component pll_all
--  port(
--    CLKIN1_IN   : in  std_logic;  --! 100MHz board clock
--    RST_IN      : in  std_logic;  --! Board reset        
--    CLKOUT0_OUT : out std_logic;  --! Microblaze clock (100 MHz)
--    CLKOUT1_OUT : out std_logic;  --! Front-end clock
--    CLKOUT2_OUT : out std_logic;  --! Master clock (50 MHz)
--    LOCKED_OUT  : out std_logic   --! Indicates whether the PLL has a clock lock
--    );
--  end component;

  component fe
    port(
      mclk        : in std_logic;       --! Master clock
      mclk0       : in std_logic;       --! Master clock 40MHz
      fe_clk      : in std_logic;       --! Front-end clock
      fe_rst_in_b : in std_logic;       --! Front-end reset (active low)

      --! XGI Expansion Headers
      fe_data : in std_logic_vector(fe_NUM_CHANNELS-1 downto 0);

      coincidence_trigger : in  std_logic;  --! Recieved from Trigger Unit
      event_trigger       : out std_logic;  --! Sent to the Trigger Unit

      up_bram : out up_bram_otype;      --! The uP BRAM interface

      cs_vio_fe : in  std_logic_vector(31 downto 0);
      cs_fe     : out std_logic_vector(127 downto 0);
      LEDs      : out std_logic_vector(7 downto 0)
      );
  end component;


  component UDP_IP_Core
    port(
      rst                      : in  std_logic;
      clk_125MHz               : in  std_logic;
      transmit_start_enable    : in  std_logic;
      transmit_data_length     : in  std_logic_vector(15 downto 0);
      transmit_data_input_bus  : in  std_logic_vector(7 downto 0);
      rx_sof                   : in  std_logic;
      rx_eof                   : in  std_logic;
      input_bus                : in  std_logic_vector(7 downto 0);
      usr_data_trans_phase_on  : out std_logic;
      start_of_frame_O         : out std_logic;
      end_of_frame_O           : out std_logic;
      source_ready             : out std_logic;
      transmit_data_output_bus : out std_logic_vector(7 downto 0);
      valid_out_usr_data       : out std_logic;
      usr_data_output_bus      : out std_logic_vector(7 downto 0)
      );
  end component;


  component system
    port(
      fpga_0_RS232_Uart_1_RX_pin      : in  std_logic;
      sys_clk_pin                     : in  std_logic;
      sys_rst_pin                     : in  std_logic;
      REFCLK_P_IN_pin                 : in  std_logic;
      REFCLK_N_IN_pin                 : in  std_logic;
      transmit_data_output_busUDP_pin : in  std_logic_vector(7 downto 0);
      source_readyUDP_pin             : in  std_logic;
      end_of_frame_OUDP_pin           : in  std_logic;
      start_of_frame_OUDP_pin         : in  std_logic;
      fpga_0_RS232_Uart_1_TX_pin      : out std_logic;
      PHY_RESET_0_pin                 : out std_logic;
      GTP_READY_pin                   : out std_logic;
      input_busUDP_pin                : out std_logic_vector(7 downto 0);
      rx_eofUDP_pin                   : out std_logic;
      rx_sofUDP_pin                   : out std_logic;
      clk_125MHzUDP_pin               : out std_logic;
      rstUDP_pin                      : out std_logic
      );
  end component;

--      component fe_FIFO_toUDP
--      port (
--      din: IN std_logic_VECTOR(31 downto 0);
--      rd_clk: IN std_logic;
--      rd_en: IN std_logic;
--      rst: IN std_logic;
--      wr_clk: IN std_logic;
--      wr_en: IN std_logic;
--      dout: OUT std_logic_VECTOR(31 downto 0);
--      empty: OUT std_logic;
--      full: OUT std_logic);
--end component;





  component fe_ch
    generic(
      ch_no : natural
      );
    port(
      --  ch_no                 : in  std_logic_vector( fe_ch_LOC_SIZE-1 downto 0 );
      mclk     : in std_logic;          --! Master clock
      mclk0    : in std_logic;          --! Master clock
      fe_clk   : in std_logic;          --! Front-end clock
      fe_rst_b : in std_logic;          --! Front-end reset (active low)

      serial_data : in std_logic;  --! TOT signal from the analog electronics
      tot_test    : in std_logic_vector(fe_ch_WORD_WIDTH-1 downto 0);  --! TOT test signal


      event_no            : in  std_logic_vector(fe_EVENT_NO_SIZE-1 downto 0);  --! A coincidence trigger count
      event_trigger       : out std_logic;  --! Sent to the Trigger Unit
      coincidence_trigger : in  std_logic;  --! Event validation
      coarse_time         : in  std_logic_vector(fe_CO_TRG_SIZE-4-1 downto 0);  --! Co.trg. length

      event_ready : out std_logic;              --! Fresh event_data present? 
      event_data  : out fe_ch_event_data_type;  --! Event #, time, ch. #, tot

      up_bram : out up_bram_otype;      --! The uP BRAM interface

      cs_vio_fe         : in  std_logic;
      --cs_fe                 : out std_logic_vector( 31 downto 0 );
      ResetRateCounters : in  std_logic;
      EventRate         : out std_logic_vector(fe_EventRate_SIZE-1 downto 0)
      );   
  end component;

  component fe_ch_iserdes
    port(
      mclk     : in std_logic;          --! Master clock
      fe_clk   : in std_logic;          --! Front-end clock
      fe_rst_b : in std_logic;          --! Front-end reset (active low)

      --! XGI Expansion Headers
      serial_data   : in  std_logic;    --! Serial input data
      parallel_data : out std_logic_vector(fe_ch_WORD_WIDTH-1 downto 0)  --! Deserialised output data
      );
  end component;

  component fe_ch_pargen
    generic(
      ch_no : natural
      );
    port(
      --  ch_no                :  in  std_logic_vector( fe_ch_LOC_SIZE-1 downto 0 );
      mclk     : in std_logic;          --! Master clock
      fe_rst_b : in std_logic;  --! Front-end reset (active low)                     
      data     : in std_logic_vector(fe_ch_WORD_WIDTH-1 downto 0);

      coincidence_trigger : in  std_logic;  --! Event validation
      coarse_time         : in  std_logic_vector(fe_CO_TRG_SIZE-4-1 downto 0);  --! Co. trg. length
      event_no            : in  std_logic_vector(fe_EVENT_NO_SIZE-1 downto 0);  --! Co.trg. count
      event_trigger       : out std_logic;  --! Sent to the Trigger Unit

      event_data  : out fe_ch_event_data_type;  --! Event #, time, ch. #, tot
      event_ready : out std_logic               --! Fresh event_data present? 
      );
  end component;

  component fe_ch_fifo
    port (
      clk         : in  std_logic;      --! Common clock for read/write
      din         : in  std_logic_vector(31 downto 0);  --! Data input
      rd_en       : in  std_logic;      --! Read enable
      rst         : in  std_logic;      --! Async reset
      wr_en       : in  std_logic;      --! Write enable
      almost_full : out std_logic;      --! Only 1 data space left
      dout        : out std_logic_vector(31 downto 0);  --! Data output
      empty       : out std_logic;      --! No data
      full        : out std_logic;      --! No room for more data
      overflow    : out std_logic;      --! Write on full fifo = overflow
      valid       : out std_logic;      --! Dout valid (read-ack)
      wr_ack      : out std_logic       --! Din valid (write-ack)
      );
  end component;

  component fe_input_stimuli
    port(
      gcnt     : in  std_logic_vector(35 downto 0);  --Yep, huge.
      tot_test : out std_logic_vector(fe_ch_WORD_WIDTH-1 downto 0)
      );
  end component;

  component fe_cotrg_proc
    port(
      mclk     : in std_logic;          --! Master clock
      fe_rst_b : in std_logic;          --! Front-end reset (active low)

      coincidence_trigger : in std_logic;  --! Recieved from Trigger Unit

      event_no    : out std_logic_vector(fe_EVENT_NO_SIZE-1 downto 0);  --! Co.trg. counter
      coarse_time : out std_logic_vector(fe_CO_TRG_SIZE-4-1 downto 0)  --! Window length
      );
  end component;

--  component system
--  port(
--    --! The BRAM interface between Microblaze and Front-end.
--    up_bram_din                                     : IN std_logic_vector(0 to 31);
--    up_bram_a                                       : IN std_logic_vector(0 to 31);
--    up_bram_we                                      : IN std_logic_vector(0 to 3);
--    up_bram_en                                      : IN std_logic;
--    up_bram_clk                                     : IN std_logic;
--    up_bram_com                                     : IN std_logic_vector(0 to 1);
--
--    fpga_0_Hard_Ethernet_MAC_PHY_MII_INT            : IN    std_logic;
--    fpga_0_RS232_Uart_1_RX_pin                      : IN    std_logic;
--    fpga_0_SysACE_CompactFlash_SysACE_CLK_pin       : IN    std_logic;
--    fpga_0_SysACE_CompactFlash_SysACE_MPIRQ_pin     : IN    std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_ER_0_pin       : IN    std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_CLK_0_pin      : IN    std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RX_DV_0_pin       : IN    std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_RXD_0_pin         : IN    std_logic_vector(7 downto 0);
--    fpga_0_Hard_Ethernet_MAC_MII_TX_CLK_0_pin       : IN    std_logic;
--    sys_clk_pin                                     : IN    std_logic;
--    sys_rst_pin                                     : IN    std_logic;    
--    fpga_0_LEDs_8Bit_GPIO_IO_pin                    : INOUT std_logic_vector(0 to 7);
--    fpga_0_LEDs_Positions_GPIO_IO_pin               : INOUT std_logic_vector(0 to 4);
--    fpga_0_Push_Buttons_5Bit_GPIO_IO_pin            : INOUT std_logic_vector(0 to 4);
--    fpga_0_DIP_Switches_8Bit_GPIO_IO_pin            : INOUT std_logic_vector(0 to 7);
--    fpga_0_IIC_EEPROM_Scl_pin                       : INOUT std_logic;
--    fpga_0_IIC_EEPROM_Sda_pin                       : INOUT std_logic;
--    fpga_0_FLASH_Mem_DQ_pin                         : INOUT std_logic_vector( 0   to  15);
--    fpga_0_DDR2_SDRAM_DDR2_DQS                      : INOUT std_logic_vector( 7 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_DQS_n                    : INOUT std_logic_vector( 7 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_DQ                       : INOUT std_logic_vector(63 downto 0);
--    fpga_0_SysACE_CompactFlash_SysACE_MPD_pin       : INOUT std_logic_vector(15 downto 0);
--    fpga_0_Hard_Ethernet_MAC_MDIO_0_pin             : INOUT std_logic;      
--    fpga_0_RS232_Uart_1_TX_pin                      : OUT   std_logic;
--    fpga_0_FLASH_Mem_A_pin                          : OUT   std_logic_vector( 7 to 30);
--    fpga_0_FLASH_Mem_ADV_LDN_pin                    : OUT   std_logic;
--    fpga_0_FLASH_Mem_WEN_pin                        : OUT   std_logic;
--    fpga_0_FLASH_Mem_OEN_pin                        : OUT   std_logic;
--    fpga_0_FLASH_Mem_CEN_pin                        : OUT   std_logic;
--    fpga_0_DDR2_SDRAM_DDR2_ODT_pin                  : OUT   std_logic_vector( 1 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_Addr_pin                 : OUT   std_logic_vector(12 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin             : OUT   std_logic_vector( 1 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin                : OUT   std_logic;
--    fpga_0_DDR2_SDRAM_DDR2_CE_pin                   : OUT   std_logic_vector( 1 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_CS_n_pin                 : OUT   std_logic_vector( 1 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin                : OUT   std_logic;
--    fpga_0_DDR2_SDRAM_DDR2_WE_n_pin                 : OUT   std_logic;
--    fpga_0_DDR2_SDRAM_DDR2_Clk_pin                  : OUT   std_logic_vector( 1 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin                : OUT   std_logic_vector( 1 downto 0);
--    fpga_0_DDR2_SDRAM_DDR2_DM_pin                   : OUT   std_logic_vector( 7 downto 0);
--    fpga_0_SysACE_CompactFlash_SysACE_MPA_pin       : OUT   std_logic_vector( 6 downto 0);
--    fpga_0_SysACE_CompactFlash_SysACE_CEN_pin       : OUT   std_logic;
--    fpga_0_SysACE_CompactFlash_SysACE_OEN_pin       : OUT   std_logic;
--    fpga_0_SysACE_CompactFlash_SysACE_WEN_pin       : OUT   std_logic;
--    fpga_0_Hard_Ethernet_MAC_TemacPhy_RST_n_pin     : OUT   std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_TXD_0_pin         : OUT   std_logic_vector( 7 downto 0);
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_EN_0_pin       : OUT   std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_CLK_0_pin      : OUT   std_logic;
--    fpga_0_Hard_Ethernet_MAC_GMII_TX_ER_0_pin       : OUT   std_logic;
--    fpga_0_Hard_Ethernet_MAC_MDC_0_pin              : OUT   std_logic
--    );
--  end component;

  --! To make XST suppress "black box" messages (AR #9838)
--   attribute box_type : string;
--   attribute box_type of system : component is "black_box";

  component fe_FIFO_toUDP
    port (
      din           : in  std_logic_vector(31 downto 0);
      rd_clk        : in  std_logic;
      rd_en         : in  std_logic;
      rst           : in  std_logic;
      wr_clk        : in  std_logic;
      wr_en         : in  std_logic;
      dout          : out std_logic_vector(31 downto 0);
      empty         : out std_logic;
      full          : out std_logic;
      rd_data_count : out std_logic_vector(7 downto 0));
  end component;


-- Synplicity black box declaration
  attribute syn_black_box                  : boolean;
  attribute syn_black_box of fe_FIFO_toUDP : component is true;

  component fe_ch_buf
    port(
      mclk              : in  std_logic;
      mclk0             : in  std_logic;
      fe_rst_b          : in  std_logic;
      event_data        : in  std_logic;
      event_ready       : in  std_logic;
      fe_ch_fifo_rd     : in  std_logic;
      ResetRateCounters : in  std_logic;
      fe_ch_fifo_out    : out std_logic;
      EventRate         : out std_logic_vector(fe_EventRate_SIZE-1 downto 0)
      );
  end component;

  component chipscope
    port(
      cs_clk       : in  std_logic;
      cs_ila_trig0 : in  std_logic_vector(127 downto 0);
      cs_vio_out   : out std_logic_vector(63 downto 0)
      );
  end component;
--   end component;

--   function chk_par(indata : std_logic_vector(15 downto 0)) return std_logic is
--     variable parity : std_logic;
--   begin
--     parity := '0';
--     for i in indata'range loop
--       if indata(i) = '1' then
--         parity := not parity;
--       end if;
--     end loop;
--     return parity;
--   end chk_par;

  component BuildEventsToShipOut
    port(
      mclk              : in  std_logic;
      mclk0             : in  std_logic;
      fe_rst_b          : in  std_logic;
      send_trigger      : in  std_logic;
      fe_event_ready    : in  std_logic;
      fe_event_data     : in  std_logic;
      fe_EventRateArray : in  std_logic_vector(7 downto 0);
      fe_data           : out std_logic;
      fe_data_ready     : out std_logic
      );
  end component;




end package components;
