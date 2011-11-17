----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:28:21 08/22/2011 
-- Design Name: 
-- Module Name:    async_trigger - Behavioral 
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
use ieee.numeric_std.all;

library work;
use work.constants.all;
use work.functions.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity async_trigger_2 is
  port(
    clk          : in std_logic;
    clk100       : in std_logic;
    rst_b        : in std_logic;
    rocs_reset_b : in std_logic;
    udp_data_in  : in std_logic_vector(7 downto 0);
    valid_data   : in std_logic;
    port_number  : in std_logic_vector(15 downto 0);
    sender_ip    : in std_logic_vector(7 downto 0);

    en_or_trigger   : in std_logic;
    en_rand_trigger : in std_logic;

    send_fifo_we        : out std_logic;
    send_fifo_we_others : in  std_logic;
    send_fifo_empty     : in  std_logic;
    send_fifo_data_in   : out std_logic_vector(7 downto 0)
    );
end async_trigger_2;

architecture Behavioral of async_trigger_2 is

  subtype byter4 is std_logic_vector(31 downto 0);
  subtype integ is integer range 0 to 19;


  type data_out_32bit_array_type is array(0 to 19) of byter4;
  type first_event_time_module_type is array(0 to NUMBER_OF_MODULES) of byter4;
  type first_time_position_type is array (0 to NUMBER_OF_ROCS) of integ;


  signal first_time_position : first_time_position_type;
  signal rst                 : std_logic;

  type   states is (INIT, WAIT_FOR_WR_EN, SET_RD_ENABLE , SET_RD_ENABLE0 , COLLECT_PREAMBLE, COLLECT_BYTES, WR_32B_FIFO);
  signal state : states;

  type   states2 is (INIT, SET_ACTIVE);
  signal active_fsm : states2;
  signal active     : std_logic;

  type   states3 is (INIT, WAIT_TT, SEND_PRE0, SEND_PRE1, SEND_PRE2, SEND_PRE3, SEND_PRE4, SEND0, SEND1, SEND2, SEND3, SEND_FULL1, SEND_FULL2, SEND_FULL3);
  signal send_tt_state : states3;

  signal wr_en_8b_fifo : std_logic;


  signal rd_en_8b_fifo  : std_logic;
  signal rst_8_bit_fifo : std_logic;

  signal data_out_8bit : std_logic_vector(7 downto 0);

  signal full_8b_fifo  : std_logic;
  signal empty_8b_fifo : std_logic;


  signal fifo_selector     : std_logic_vector(31 downto 0);
  signal fifo_selector_uns : integer range 0 to 20;
  signal trigger_time_uns  : std_logic_vector(31 downto 0);

  signal din_32b_fifo : std_logic_vector(31 downto 0);
  signal byte_counter : integer range 0 to 31;
  signal tt_counter   : integer range 0 to 511;

  signal rst_32b_fifos           : std_logic;
  signal wr_en_32b_fifos         : std_logic_vector(31 downto 0);
  signal rd_en_32b_fifos         : std_logic_vector(19 downto 0);
  signal full_32b_fifos          : std_logic_vector(19 downto 0);
  signal empty_32b_fifos         : std_logic_vector(19 downto 0);
  signal data_out_32bit_array    : data_out_32bit_array_type;
  signal trigger_times_array_old : data_out_32bit_array_type;

  signal first_event_time_latch : first_event_time_module_type;

 





  signal wr_en_tt_fifo      : std_logic;
  signal rd_en_tt_fifo      : std_logic;
  signal full_tt_fifo       : std_logic;
  signal empty_tt_fifo      : std_logic;
  signal din_tt_fifo        : std_logic_vector(31 downto 0);
  signal dout_tt_fifo       : std_logic_vector(31 downto 0);
  signal data_count_tt_fifo : std_logic_vector(8 downto 0);


  signal trigger_time_tmp         : std_logic_vector(31 downto 0);
  signal late_running_counter     : unsigned(31 downto 0);
  signal late_running_counter_buf : unsigned(31 downto 0);
  signal late_running_counter_us  : unsigned(31 downto 0);
  signal package_counter          : unsigned(7 downto 0);

  signal tt_to_send : std_logic_vector(31 downto 0);

  signal send_tt_counter : unsigned(7 downto 0);

  signal comp_0_1 : std_logic;
  signal comp_0_2 : std_logic;
  signal comp_0_3 : std_logic;
  signal comp_1_2 : std_logic;
  signal comp_1_3 : std_logic;
  signal comp_2_3 : std_logic;

  signal rocs_reset     : std_logic;
  signal rocs_reset_buf : std_logic;

  signal count_bit_buf : std_logic;

  signal en_or_buf : std_logic;
  signal bit17_lrc : std_logic;

  signal trigger_times_to_send  : std_logic_vector(7 downto 0);
  signal trigger_times_received : std_logic_vector(7 downto 0);


  component fifo_generator_v8_1_8b
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      din   : in  std_logic_vector(7 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(7 downto 0);
      full  : out std_logic;
      empty : out std_logic
      );
  end component;

  component fifo_generator_v8_1_32b
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      din   : in  std_logic_vector(31 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(31 downto 0);
      full  : out std_logic;
      empty : out std_logic
      -- data_count : out std_logic_vector(10 downto 0)
      );
  end component;

  component trigger_time_fifo
    port (
      clk        : in  std_logic;
      rst        : in  std_logic;
      din        : in  std_logic_vector(31 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(31 downto 0);
      full       : out std_logic;
      empty      : out std_logic;
      data_count : out std_logic_vector(8 downto 0)
      );
  end component;


  component cs_controller
    port (
      CONTROL0 : inout std_logic_vector(35 downto 0));
  end component;

  signal CONTROL0 : std_logic_vector(35 downto 0);

  component ila_cs
    port (
      CONTROL : inout std_logic_vector(35 downto 0);
      CLK     : in    std_logic;
      TRIG0   : in    std_logic_vector(127 downto 0));
  end component;

  signal cs_trig : std_logic_vector(127 downto 0);
  
  
begin
  --rocs_reset <= not rocs_reset_b; this is done with the counter synchronizer

  cs_contr : cs_controller
    port map (
      CONTROL0 => CONTROL0);
  your_instance_name : ila_cs
    port map (
      CONTROL => CONTROL0,
      CLK     => clk,
      TRIG0   => cs_trig);

  rst <= not rst_b;

  wr_en_8b_fifo <= '1' when valid_data = '1' and port_number = x"4242" else '0';



  module_1_8b_fifo : fifo_generator_v8_1_8b
    port map (
      clk   => clk,
      rst   => rocs_reset,
      din   => udp_data_in,
      wr_en => wr_en_8b_fifo,
      rd_en => rd_en_8b_fifo,
      dout  => data_out_8bit,
      full  => full_8b_fifo,
      empty => empty_8b_fifo
      -- data_count => open
      );

  generate_32b_fifos : for i in 0 to 19 generate
    module_1_32b_fifo : fifo_generator_v8_1_32b
      port map (
        clk   => clk,
        rst   => rst_32b_fifos,
        din   => din_32b_fifo,
        wr_en => wr_en_32b_fifos(i),
        rd_en => rd_en_32b_fifos(i),
        dout  => data_out_32bit_array(i),
        full  => full_32b_fifos(i),
        empty => empty_32b_fifos(i)
        --data_count => open
        );
  end generate generate_32b_fifos;
  b32_fifo_rst : process (clk, rst_b)
  begin
    if rst_b = '0' then
      rst_32b_fifos <= '1';
    elsif clk'event and clk = '1' then
      rst_32b_fifos <= rocs_reset;
      en_or_buf     <= en_or_trigger;
      if en_or_buf /= en_or_trigger then
        rst_32b_fifos <= '1';
      end if;
    end if;
  end process;


  trigger_time_fifo_inst : trigger_time_fifo
    port map (
      clk        => clk,
      rst        => rocs_reset,
      din        => din_tt_fifo,
      wr_en      => wr_en_tt_fifo,
      rd_en      => rd_en_tt_fifo,
      dout       => dout_tt_fifo,
      full       => full_tt_fifo,
      empty      => empty_tt_fifo,
      data_count => data_count_tt_fifo
      );


  fill_32b_fifo : process (clk, rst_b)
  begin  -- process fill_32b_fifo
    if rst_b = '0' then                 -- asynchronous reset (active low)
      state <= INIT;
    elsif clk'event and clk = '1' then  -- rising clock edge
      wr_en_32b_fifos  <= (others => '0');
      din_32b_fifo     <= (others => '0');


      rst_8_bit_fifo  <= '0';

      case state is
        when INIT =>
          fifo_selector    <= (others => '0');
          rst_8_bit_fifo   <= '1';
          byte_counter     <= 0;
          tt_counter       <= 0;
          trigger_time_uns <= (others => '0');
          state            <= WAIT_FOR_WR_EN;
          rd_en_8b_fifo   <= '0';
          
        when WAIT_FOR_WR_EN =>
          state <= WAIT_FOR_WR_EN;

          if empty_8b_fifo /= '1' then
            state             <= SET_RD_ENABLE0;
            fifo_selector_uns <= to_integer(unsigned(sender_ip))-34;  --This will give
                                                             ----the first card
                                                             ----0
          end if;

        when SET_RD_ENABLE0 =>
          fifo_selector(fifo_selector_uns) <= '1';
          state                            <= SET_RD_ENABLE;
          
        when SET_RD_ENABLE =>
          rd_en_8b_fifo <= '1';
          state         <= COLLECT_PREAMBLE;

        when COLLECT_PREAMBLE =>
          state          <= COLLECT_PREAMBLE;
          rd_en_8b_fifo <= '1';
          byte_counter   <= byte_counter +1;
          if byte_counter = 0 then

          elsif byte_counter = 1 then

          elsif byte_counter = 2 then

          elsif byte_counter = 3 then
            trigger_times_received <= data_out_8bit;
            state                  <= COLLECT_BYTES;
            byte_counter           <= 0;
          end if;

        when COLLECT_BYTES =>
          state          <= COLLECT_BYTES;
          rd_en_8b_fifo <= '1';
          byte_counter   <= byte_counter +1;
          if trigger_times_received /= x"00" then
            if byte_counter = 0 then
              trigger_time_uns(7 downto 0) <= data_out_8bit;
            elsif byte_counter = 1 then
              trigger_time_uns(15 downto 8) <= data_out_8bit;
            elsif byte_counter = 2 then
              trigger_time_uns(23 downto 16) <= data_out_8bit;
            elsif byte_counter = 3 then
              byte_counter    <= 0;
              wr_en_32b_fifos <= fifo_selector;
              din_32b_fifo    <= data_out_8bit & trigger_time_uns(23 downto 0);
              tt_counter      <= tt_counter + 1;
              if tt_counter + 1 = unsigned(trigger_times_received) then
                state <= INIT;
              end if;
            end if;
          else
            state <= INIT;
          end if;
          
        when others =>
          state <= INIT;
      end case;
    end if;
  end process fill_32b_fifo;


  -- Set if active if all has received data, and not active if all is empty again.
  set_active_fsm : process (clk, rst_b)
  begin  -- process set_active_fsm
    if rst_b = '0' then                 -- asynchronous reset (active low)
      active_fsm <= INIT;
    elsif clk'event and clk = '1' then  -- rising clock edge
      case active_fsm is
        when INIT =>
          active <= '0';
          if all_zeros(empty_32b_fifos(NUMBER_OF_ROCS-1 downto 0)) = '1' then
            active_fsm <= SET_ACTIVE;
          end if;
        when SET_ACTIVE =>
          active <= '1';
          if all_ones(empty_32b_fifos(NUMBER_OF_ROCS-1 downto 0)) = '1' then
            active_fsm <= INIT;
          end if;
        when others => null;
      end case;
    end if;
  end process set_active_fsm;

  fill_latches : process(clk, rst_b)
  begin
    if rst_b = '0' then
      first_event_time_latch <= (others => x"00000000");
    elsif clk'event and clk = '1' then
      if active = '1' then
        for i in 0 to NUMBER_OF_MODULES-1 loop
          first_event_time_latch(i) <= data_out_32bit_array(first_time_position(i));
        end loop;  -- i
      end if;
    end if;
  end process fill_latches;

  find_first : process(clk, rst_b)
    variable small0 : integer range 0 to 19;
    variable small1 : integer range 0 to 19;
    variable small2 : integer range 0 to 19;
    variable small3 : integer range 0 to 19;
    
  begin
    if rst_b = '0' then
      first_time_position <= (others => 0);
    elsif clk'event and clk = '1' then
      
      
    end if;
  end process find_first;

























  late_counter : process (clk100, rocs_reset_b)
  begin  -- process trigger_FSM
    if rocs_reset_b = '0' then          -- asynchronous reset (active low)
      
      late_running_counter_us <= x"FFFF3CAF";  -- 50000 behind (0.5 ms)
      
    elsif clk100'event and clk100 = '1' then  -- rising clock edge
      late_running_counter_us <= late_running_counter_us + 1;
    end if;
  end process late_counter;
  late_counter_synchroniser : process (clk, rst_b)
  begin  -- process trigger_FSM
    if rst_b = '0' then                 -- asynchronous reset (active low)
      late_running_counter     <= (others => '0');
      late_running_counter_buf <= (others => '0');
      rocs_reset               <= '0';
      rocs_reset_buf           <= '0';
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      rocs_reset_buf           <= not rocs_reset_b;
      rocs_reset               <= rocs_reset_buf;
      late_running_counter_buf <= late_running_counter_us;
      late_running_counter     <= late_running_counter_buf;
    end if;
  end process late_counter_synchroniser;

  send_tt : process (clk, rst_b)
  begin  -- process send_tt
    if rst_b = '0' then                 -- asynchronous reset (active low)
      send_tt_state   <= INIT;
      package_counter <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      rd_en_tt_fifo     <= '0';
      send_fifo_we      <= '0';
      send_fifo_data_in <= x"00";

      bit17_lrc <= late_running_counter(13);

      case send_tt_state is
        when INIT =>
          rd_en_tt_fifo <= '0';
          tt_to_send    <= (others => '0');
          send_tt_state <= WAIT_TT;

        when WAIT_TT =>
          send_tt_state   <= WAIT_TT;
          send_tt_counter <= (others => '0');
          if rocs_reset = '1' then
            package_counter <= (others => '0');

          elsif (late_running_counter(13) = '1' and bit17_lrc = '0') or (data_count_tt_fifo(7 downto 0) = x"FF") then
            trigger_times_to_send <= data_count_tt_fifo(7 downto 0);
            tt_to_send            <= dout_tt_fifo;
            send_tt_state         <= SEND_PRE0;
          end if;
          
        when SEND_PRE0 =>
          if(send_fifo_we_others = '0' and send_fifo_empty = '1') then
            send_fifo_data_in <= x"00";
            send_fifo_we      <= '1';
            send_tt_state     <= SEND_PRE1;
          else
            send_tt_state <= SEND_PRE0;
          end if;

        when SEND_PRE1 =>
          send_fifo_data_in <= x"24";
          send_fifo_we      <= '1';
          send_tt_state     <= SEND_PRE2;

        when SEND_PRE2 =>
          send_fifo_data_in <= x"29";
          send_fifo_we      <= '1';
          send_tt_state     <= SEND_PRE3;
          

        when SEND_PRE3 =>
          send_fifo_data_in <= std_logic_vector(package_counter);
          package_counter   <= package_counter+1;
          send_fifo_we      <= '1';
          send_tt_state     <= SEND_PRE4;

        when SEND_PRE4 =>
          send_fifo_data_in <= trigger_times_to_send;
          send_fifo_we      <= '1';
          send_tt_state     <= SEND0;

        when SEND0 =>
          if std_logic_vector(send_tt_counter) /= trigger_times_to_send then  --decides how many trigger times is sent
            send_fifo_data_in <= tt_to_send(31 downto 24);
            send_fifo_we      <= '1';
            send_tt_state     <= SEND1;
            rd_en_tt_fifo     <= '1';
          else
            send_tt_state <= WAIT_TT;
          end if;

        when SEND1 =>
          send_fifo_data_in <= tt_to_send(23 downto 16);
          send_fifo_we      <= '1';
          send_tt_state     <= SEND2;

        when SEND2 =>
          send_fifo_data_in <= tt_to_send(15 downto 8);
          send_fifo_we      <= '1';
          send_tt_state     <= SEND3;

        when SEND3 =>
          send_fifo_data_in <= tt_to_send(7 downto 0);
          send_fifo_we      <= '1';
          tt_to_send        <= dout_tt_fifo;
          send_tt_counter   <= send_tt_counter + 1;
          send_tt_state     <= SEND0;
          
          
          
        when others =>
          send_tt_state <= INIT;
      end case;
    end if;
  end process send_tt;

end Behavioral;

