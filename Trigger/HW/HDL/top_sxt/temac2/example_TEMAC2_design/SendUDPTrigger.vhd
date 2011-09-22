----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:33:53 03/31/2011 
-- Design Name: 
-- Module Name:    SendUDPDData - Behavioral 
-- Project Name: 
-- Target Devices: 
-- ool versions: 
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
use ieee.numeric_std.all;  --! Numeric/arithmetical logic (IEEE standard)


--library work;
use work.constants.all;                 --! Global constants
use work.types.all;                     --! Global types
use work.functions.all;                 --! Global functions


library unisim;
use unisim.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SendUDPTrigger is
  port (mclk                    : in  std_logic;
        fe_rst_b                : in  std_logic;
        udp_clk                 : in  std_logic;
        rst                     : in  std_logic;
        transmit_start_enable   : out std_logic;
        transmit_data_length    : out std_logic_vector (15 downto 0);
        usr_data_trans_phase_on : in  std_logic;
        transmit_data_input_bus : out std_logic_vector (7 downto 0);
        fe_trigger_data_packed  : in  std_logic_vector (31 downto 0);
        fe_trigger_ready        : in  std_logic;
        coincidence_trigger     : in  std_logic;
        cs_ila_trig0            : out std_logic_vector(cs_ILA_SIZE-1 downto 0)

        );
end SendUDPTrigger;


architecture Behavioral of SendUDPTrigger is

  component FIFO_toUDP_Trigger
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      din   : in  std_logic_vector(31 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(31 downto 0);
      full  : out std_logic;
      empty : out std_logic
      );
  end component;
  component HitsCounterFIFO
    port (
      rst    : in  std_logic;
      wr_clk : in  std_logic;
      rd_clk : in  std_logic;
      din    : in  std_logic_vector(14 downto 0);
      wr_en  : in  std_logic;
      rd_en  : in  std_logic;
      dout   : out std_logic_vector(14 downto 0);
      full   : out std_logic;
      empty  : out std_logic
      );
  end component;

  signal fe_rst                    : std_logic;
  signal transmit_start_enable_i   : std_logic;
  signal transmit_data_length_i    : std_logic_vector(15 downto 0);
  signal transmit_data_input_bus_i : std_logic_vector (7 downto 0);


-- UDP fifos etc:
  signal read_fifo        : std_logic;
  signal fifo_toUDP_data  : std_logic_vector(31 downto 0);
  signal fifo_toUDP_empty : std_logic;
  signal fifo_toUDP_full  : std_logic;
  signal rd_data_count    : std_logic_vector(7 downto 0);
-- UDP sending FSM:
  type   state_type is (S_reset, S_wait , S_SendHeader0, S_SendHeader1, S_SendData, S_SendFooter);
  signal next_state       : state_type;
  signal current_state    : state_type;



  signal DataCounter   : unsigned(16 downto 0);
--  signal DataCounter_next   : unsigned(14 downto 0);
  -- signal FooterCounter_reg  : unsigned(4 downto 0);
  signal FooterCounter : integer range 0 to 7;


  signal HitsInFifoCounter_reg  : unsigned(14 downto 0);
  signal HitsInFifoCounter_next : unsigned(14 downto 0);

  signal HitsInFifoCounterDown_reg  : unsigned(14 downto 0);
  signal HitsInFifoCounterDown_next : unsigned(14 downto 0);

  signal EventsInFifoCounter_reg  : unsigned(8 downto 0);  -- counts up to 511
  signal EventsInFifoCounter_next : unsigned(8 downto 0);



--signal HitIn                : fe_ch_event_data_type;
  signal ch_nr                : std_logic_vector(fe_ch_LOC_SIZE-1 downto 0);
  signal BatchFull_reg        : std_logic;
  signal BatchFull_next       : std_logic;
  signal WriteHitsCounterFIFO : std_logic;
  signal HitsCounterEmpty     : std_logic;
  signal HitsCounterOut       : std_logic_vector(14 downto 0);
  signal HitsCounterRd        : std_logic;


  constant FOOTERSIZE     : integer := 4;
  signal   PackageCounter : unsigned(31 downto 0);


  constant TOTNumberOfEventsInFIFO : integer := 8;  --only!!
  

begin

  fe_rst <= not fe_rst_b;

  transmit_start_enable <= transmit_start_enable_i;
  transmit_data_length  <= transmit_data_length_i;


  transmit_data_input_bus <= transmit_data_input_bus_i when usr_data_trans_phase_on = '1' else (others => '0');


  cs_ila_trig0(31 downto 0) <= (fe_trigger_data_packed);
  cs_ila_trig0(32)          <= fe_trigger_ready;

  --HitIn <= unpack_event(fe_trigger_data_packed);
  --ch_nr <= HitIn.ch_no;
  -- count the number of hits going into the FIFO:


  inst_FIFO_toUDP_Trigger : entity work.FIFO_toUDP_Trigger
    port map (
      din    => fe_trigger_data_packed,
      rd_clk => udp_clk,
      rd_en  => read_fifo,
      rst    => rst,
      wr_clk => mclk,
      wr_en  => fe_trigger_ready,
      dout   => fifo_toUDP_data,
      empty  => fifo_toUDP_empty,
      full   => fifo_toUDP_full);
  --rd_data_count => rd_data_count);


  hits_counter_reg : process (mclk, fe_rst_b)
  begin
    if(fe_rst_b = '0') then
      HitsInFifoCounter_reg   <= (others => '0');
      EventsInFifoCounter_reg <= (others => '0');
      BatchFull_reg           <= '0';
    elsif(rising_edge(mclk)) then
      HitsInFifoCounter_reg   <= HitsInFifoCounter_next;
      EventsInFifoCounter_reg <= EventsInFifoCounter_next;
      BatchFull_reg           <= BatchFull_next;
    end if;
  end process;

  cs_ila_trig0(47 downto 33)   <= std_logic_vector(HitsInFifoCounter_reg);
  cs_ila_trig0(56 downto 48)   <= std_logic_vector(EventsInFifoCounter_reg);
  cs_ila_trig0(57)             <= WriteHitsCounterFIFO;
  cs_ila_trig0(65 downto 58)   <= transmit_data_input_bus_i;
  cs_ila_trig0(73 downto 66)   <= transmit_data_input_bus_i;
  cs_ila_trig0(74)             <= read_fifo;
  cs_ila_trig0(91 downto 75)   <= std_logic_vector(DataCounter);
  cs_ila_trig0(106 downto 92)  <= HitsCounterOut;
  cs_ila_trig0(107)            <= HitsCounterEmpty;
  cs_ila_trig0(127 downto 108) <= fifo_toUDP_data(19 downto 0);
  --cs_ila_trig0(155 downto 140) <= transmit_data_length_i;




  hits_counter_log : process(HitsInFifoCounter_reg, fe_trigger_ready, BatchFull_reg)
  begin
    if(fe_trigger_ready = '1' and WriteHitsCounterFIFO = '0') then
      HitsInFifoCounter_next <= HitsInFifoCounter_reg + 1;
    elsif(fe_trigger_ready = '1' and WriteHitsCounterFIFO = '1') then
      HitsInFifoCounter_next <= (0 => '1', others => '0');
    elsif(fe_trigger_ready = '0' and WriteHitsCounterFIFO = '1') then
      HitsInFifoCounter_next <= (others => '0');
    else
      HitsInFifoCounter_next <= HitsInFifoCounter_reg;
    end if;
  end process;


  --and produce the batch full signal:


  batch_full_emitter : process(EventsInFifoCounter_reg, EventsInFifoCounter_next, fe_trigger_ready)
  begin
    
    if EventsInFifoCounter_reg = TOTNumberOfEventsInFIFO then
      BatchFull_next <= '1';
    else
      BatchFull_next <= '0';
    end if;

    if fe_trigger_ready = '1' and EventsInFifoCounter_reg < TOTNumberOfEventsInFIFO then
      EventsInFifoCounter_next <= EventsInFifoCounter_reg + 1;
    elsif fe_trigger_ready = '1' and EventsInFifoCounter_reg = TOTNumberOfEventsInFIFO then
      EventsInFifoCounter_next <= (0 => '1', others => '0');
    elsif fe_trigger_ready = '0' and EventsInFifoCounter_reg = TOTNumberOfEventsInFIFO then
      EventsInFifoCounter_next <= (others => '0');
    else
      EventsInFifoCounter_next <= EventsInFifoCounter_reg;
      
    end if;
  end process;


  writeHitsCounterFIFONOw : process (mclk, fe_rst_b)
  begin
    if(fe_rst_b = '0') then
      WriteHitsCounterFIFO <= '0';
    elsif(rising_edge(mclk)) then
      if BatchFull_next = '1' and BatchFull_reg = '0' then
        WriteHitsCounterFIFO <= '1';
      else
        WriteHitsCounterFIFO <= '0';
      end if;

      
    end if;

  end process;



  inst_HitsCounterFIFO : HitsCounterFIFO
    port map (
      rst    => fe_rst,
      wr_clk => mclk,
      rd_clk => udp_clk,
      din    => std_logic_vector(HitsInFifoCounter_reg),
      wr_en  => WriteHitsCounterFIFO,
      rd_en  => HitsCounterRd,
      dout   => HitsCounterOut,
      full   => open,
      empty  => HitsCounterEmpty
      );



  --the udp sending unit
  state_reg_transmit : process(udp_clk, rst)
  begin
    if rst = '1' then
      current_state <= S_reset;
    elsif rising_edge(udp_clk) then
      current_state <= next_state;
    end if;
  end process;

  output_logic_transmit : process(udp_clk, rst)
    variable tmp_data                   : std_logic_vector(7 downto 0);
    variable address                    : integer range 0 to 3;
    variable address_tmp                : integer range 0 to 3;
    variable DataCounterStd             : std_logic_vector(16 downto 0);
    variable transmit_data_length_i_std : std_logic_vector(29 downto 0);
  begin
    if rst = '1' then
      transmit_start_enable_i    <= '0';
      transmit_data_length_i     <= (others => '0');
      transmit_data_input_bus_i  <= (others => '0');
      HitsCounterRd              <= '0';
      PackageCounter             <= (others => '0');
      tmp_data                   := (others => '0');
      transmit_data_length_i_std := (others => '0');
      DataCounter                <= (others => '0');
      DataCounterStd             := (others => '0');
      read_fifo                  <= '0';
      FooterCounter              <= 0;
    elsif rising_edge(udp_clk) then
      transmit_start_enable_i    <= '0';
      transmit_data_length_i_std := (others => '0');
      transmit_data_length_i     <= (others => '0');
      transmit_data_input_bus_i  <= (others => '0');
      HitsCounterRd              <= '0';
      PackageCounter             <= PackageCounter;
      tmp_data                   := (others => '0');
      DataCounter                <= DataCounter;
      DataCounterStd             := (others => '0');
      read_fifo                  <= '0';
      FooterCounter              <= FOOTERSIZE;
      case current_state is
        when S_reset =>
          PackageCounter <= (others => '0');
        when S_wait        =>
                                        -- do nothing
        when S_SendHeader0 =>
          HitsCounterRd              <= '1';
          DataCounterStd             := HitsCounterOut&"00";  -- multiply by 4.
          DataCounter                <= unsigned(DataCounterStd(16 downto 0));
          transmit_start_enable_i    <= '1';
          --transmit_data_length_i_std(18 downto 2)  := DataCounterStd;
          --transmit_data_length_i_std(1 downto 0)   := (others => '0');
          --transmit_data_length_i_std(29 downto 19) := (others => '0');
          transmit_data_length_i_std := std_logic_vector(unsigned(HitsCounterOut)*4 + FOOTERSIZE + 1);
          --transmit_data_length_i_std               := std_logic_vector(unsigned(transmit_data_length_i_std) + FOOTERSIZE);
          transmit_data_length_i     <= transmit_data_length_i_std(15 downto 0);
          PackageCounter             <= PackageCounter+1;
        when S_SendHeader1 =>
          DataCounter               <= DataCounter;  -- just wait until you can send data!
          transmit_data_input_bus_i <= fifo_toUDP_data(7 downto 0);  --already
                                                                     --send the
                                        --first byte...
        when S_SendData =>
          if(DataCounter(1 downto 0)) = "11" then    --check!!
            read_fifo <= '1';           -- its first word fall through!
          else
            read_fifo <= '0';           -- its first word fall through!
          end if;
          address := to_integer(unsigned(DataCounter(1 downto 0)));

          if address = 0 then           --must count up...
            address_tmp := 1;
          elsif address = 1 then
            address_tmp := 0;
          elsif address = 2 then
            address_tmp := 3;
          elsif address = 3 then
            address_tmp := 2;
          end if;

          tmp_data                  := fifo_toUDP_data((address_tmp+1)*8-1 downto address_tmp*8);
          transmit_data_input_bus_i <= tmp_data;
          DataCounter               <= DataCounter - 1;
        when S_SendFooter =>
          FooterCounter             <= FooterCounter -1;
          transmit_data_input_bus_i <= std_logic_vector(PackageCounter((FooterCounter)*8-1 downto (FooterCounter-1)*8));
          -- transmit_data_input_bus_i <= std_logic_vector(PackageCounter(7 downto 0));
        when others =>
                                        -- do nothing
      end case;
    end if;

  end process;



  comb_logic_transmit : process(current_state, usr_data_trans_phase_on, HitsCounterOut, HitsCounterEmpty, DataCounter, FooterCounter)
  begin
    case current_state is
      when S_reset => next_state <= S_wait;
      when S_wait  =>
        if(HitsCounterEmpty = '1') then
          next_state <= S_wait;
        else
          next_state <= S_SendHeader0;
        end if;

      when S_SendHeader0 =>
        next_state <= S_SendHeader1;
      when S_SendHeader1 =>
        if(usr_data_trans_phase_on = '1') then
          next_state <= S_SendData;
        else
          next_state <= S_SendHeader1;
        end if;
      when S_SendData =>
        if(DataCounter /= 1) then
          next_state <= S_SendData;
        else
          next_state <= S_SendFooter;
        end if;
      when S_SendFooter =>
        if(FooterCounter /= 1) then
          next_state <= S_SendFooter;
        else
          next_state <= S_wait;
        end if;
      when others =>
        next_state <= S_wait;
    end case;
    

  end process;

end Behavioral;

