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

entity async_trigger is
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
end async_trigger;

architecture Behavioral of async_trigger is
  subtype byter is std_logic_vector(7 downto 0);
  subtype byter4 is std_logic_vector(31 downto 0);

  type data_out_8bit_array_type is array(0 to 3) of byter;
  type data_out_32bit_array_type is array(0 to 3) of byter4;

  signal rst : std_logic;

  type   states is (INIT, WAIT_FOR_WR_EN, SET_RD_ENABLE , SET_RD_ENABLE0 , COLLECT_PREAMBLE, COLLECT_BYTES, WR_32B_FIFO);
  signal state : states;

  type   states2 is (INIT, CHECK_TIMES, PULL_OLD0, PULL_OLD1, PULL_OLD2, PULL_OLD3 , PULL_OLD4, PULL_TRIGGER0, PULL_TRIGGER1, PULL_TRIGGER2, PULL_TRIGGER3);
  signal atrig_state : states2;


  type   states3 is (INIT, WAIT_TT, SEND_PRE0, SEND_PRE1, SEND_PRE2, SEND_PRE3, SEND_PRE4, SEND0, SEND1, SEND2, SEND3, SEND_FULL1, SEND_FULL2, SEND_FULL3);
  signal send_tt_state : states3;

  signal wr_en_8b_fifos    : std_logic_vector(3 downto 0);
  signal wr_en_8b_fifos_np : std_logic_vector(3 downto 0);

  signal rd_en_8b_fifos  : std_logic_vector(3 downto 0);
  signal rst_8_bit_fifos : std_logic;

  signal data_out_8bit_array : data_out_8bit_array_type;

  signal full_8b_fifos  : std_logic_vector(3 downto 0);
  signal empty_8b_fifos : std_logic_vector(3 downto 0);

  signal fifo_selector     : std_logic_vector(3 downto 0);
  signal fifo_selector_uns : integer range 0 to 4;
  signal trigger_time_uns  : std_logic_vector(31 downto 0);

  signal din_32b_fifo : std_logic_vector(31 downto 0);
  signal byte_counter : integer range 0 to 31;
  signal tt_counter   : integer range 0 to 127;

  signal rst_32b_fifos           : std_logic;
  signal wr_en_32b_fifos         : std_logic_vector(3 downto 0);
  signal rd_en_32b_fifos         : std_logic_vector(3 downto 0);
  signal full_32b_fifos          : std_logic_vector(3 downto 0);
  signal empty_32b_fifos         : std_logic_vector(3 downto 0);
  signal data_out_32bit_array    : data_out_32bit_array_type;
  signal trigger_times_array_old : data_out_32bit_array_type;

  signal wr_en_tt_fifo_and_or : std_logic;
--    signal wr_en_tt_fifo_and : std_logic;
  signal din_tt_fifo_and_or   : std_logic_vector(31 downto 0);
--    signal din_tt_fifo_and   : std_logic_vector(31 downto 0);

  signal wr_en_tt_fifo_or : std_logic;
  signal din_tt_fifo_or   : std_logic_vector(31 downto 0);

  signal wr_en_tt_fifo_rand : std_logic;
  signal din_tt_fifo_rand   : std_logic_vector(31 downto 0);

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
      --data_count : out std_logic_vector(11 downto 0)
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

  cs_trig(0)          <= en_rand_trigger;
  cs_trig(1)          <= en_or_trigger;
  cs_trig(5 downto 2) <= rd_en_32b_fifos;

  cs_trig(63 downto 32)  <= data_out_32bit_array(0);
  cs_trig(95 downto 64)  <= data_out_32bit_array(1);
  cs_trig(127 downto 96) <= std_logic_vector(late_running_counter);

  rst <= not rst_b;

  with fifo_selector select
    fifo_selector_uns <=
    0 when "0001",
    1 when "0010",
    2 when "0100",
    3 when "1000",
    4 when others;
  
  
  with sender_ip select
    wr_en_8b_fifos_np <=
    "0001" when x"22",
    "0010" when x"23",
    "0100" when x"24",
    "1000" when x"25",
    "0000" when others;

  wr_en_8b_fifos <= wr_en_8b_fifos_np when valid_data = '1' else "0000";

  -- cs_trig(3 downto 0)   <= wr_en_8b_fifos;
--  cs_trig(108 downto 101) <= udp_data_in;

--  cs_trig(31 downto 0)  <= trigger_time_uns;
--  cs_trig(63 downto 32)  <= data_out_32bit_array(0);
--  cs_trig(95 downto 64) <= data_out_32bit_array(1);

  -- cs_trig(99 downto 96) <=  wr_en_8b_fifos;

  --cs_trig(47 downto 40) <= data_out_8bit_array(0);
  --cs_trig(48)           <= rd_en_8b_fifos(0);

  --cs_trig(57 downto 50) <= data_out_8bit_array(1);
  --cs_trig(58)           <= rd_en_8b_fifos(1);
  --cs_trig(67 downto 60) <= data_out_8bit_array(2);
  --cs_trig(68)           <= rd_en_8b_fifos(2);
  --cs_trig(77 downto 70) <= data_out_8bit_array(3);
  --cs_trig(78)           <= rd_en_8b_fifos(3);

  -- cs_trig(100) <= wr_en_tt_fifo;
--  cs_trig(97 downto 90) <= sender_ip;



  generate_8b_fifos : for i in 0 to 3 generate
    module_1_8b_fifo : fifo_generator_v8_1_8b
      port map (
        clk   => clk,
        rst   => rocs_reset,
        din   => udp_data_in,
        wr_en => wr_en_8b_fifos(i),
        rd_en => rd_en_8b_fifos(i),
        dout  => data_out_8bit_array(i),
        full  => full_8b_fifos(i),
        empty => empty_8b_fifos(i)
        -- data_count => open
        );
  end generate generate_8b_fifos;

  generate_32b_fifos : for i in 0 to 3 generate
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
      wr_en_tt_fifo_or <= '0';
      din_tt_fifo_or   <= (others => '0');
      rst_8_bit_fifos  <= '0';
      case state is
        when INIT =>
--          rst_8_bit_fifos  <= '1';
          byte_counter     <= 0;
          tt_counter       <= 0;
          fifo_selector    <= "0000";
          trigger_time_uns <= (others => '0');
          state            <= WAIT_FOR_WR_EN;
          rd_en_8b_fifos   <= (others => '0');
          
        when WAIT_FOR_WR_EN =>
          state         <= WAIT_FOR_WR_EN;
          fifo_selector <= "0000";

          --if wr_en_8b_fifos /= "0000" then
          --  fifo_selector <= wr_en_8b_fifos;
          --  state         <= SET_RD_ENABLE0;
          --end if;
          if empty_8b_fifos /= "1111" then
            state <= SET_RD_ENABLE0;
            if empty_8b_fifos(0) = '0' then
              fifo_selector <= "0001";
            elsif empty_8b_fifos(1) = '0' then
              fifo_selector <= "0010";
            elsif empty_8b_fifos(2) = '0' then
              fifo_selector <= "0100";
            elsif empty_8b_fifos(3) = '0' then
              fifo_selector <= "1000";
            end if;
          end if;

        when SET_RD_ENABLE0 =>
          state <= SET_RD_ENABLE;
          
        when SET_RD_ENABLE =>
          rd_en_8b_fifos <= fifo_selector;
          state          <= COLLECT_PREAMBLE;

        when COLLECT_PREAMBLE =>
          state          <= COLLECT_PREAMBLE;
          rd_en_8b_fifos <= fifo_selector;
          byte_counter   <= byte_counter +1;
          if byte_counter = 0 then

          elsif byte_counter = 1 then

          elsif byte_counter = 2 then

          elsif byte_counter = 3 then
            trigger_times_received <= data_out_8bit_array(fifo_selector_uns);
            state                  <= COLLECT_BYTES;
            byte_counter           <= 0;
          end if;


        when COLLECT_BYTES =>
          state          <= COLLECT_BYTES;
          rd_en_8b_fifos <= fifo_selector;
          byte_counter   <= byte_counter +1;
          if trigger_times_received /= x"00" then
            if byte_counter = 0 then
              trigger_time_uns(7 downto 0) <= data_out_8bit_array(fifo_selector_uns);
            elsif byte_counter = 1 then
              trigger_time_uns(15 downto 8) <= data_out_8bit_array(fifo_selector_uns);
            elsif byte_counter = 2 then
              trigger_time_uns(23 downto 16) <= data_out_8bit_array(fifo_selector_uns);
            elsif byte_counter = 3 then
              wr_en_32b_fifos <= fifo_selector;
              din_32b_fifo    <= data_out_8bit_array(fifo_selector_uns)&trigger_time_uns(23 downto 0);
              tt_counter      <= tt_counter + 1;
              if tt_counter + 1 = unsigned(trigger_times_received) then
                state <= INIT;
              end if;
            end if;
          else
            state <= INIT;
          end if;

--            trigger_time_uns(31 downto 24) <= data_out_8bit_array(fifo_selector_uns);            
          --elsif byte_counter = 4 then
          --  wr_en_32b_fifos <= fifo_selector;
          --  din_32b_fifo    <= trigger_time_uns;
          --  byte_counter <= 0;
          --  tt_counter   <= tt_counter +1;
          --  if tt_counter = 0 then      --This will decide how many trigger
          --    state <= INIT;
          --  end if;
          --end if;

          
        when others =>
          state <= INIT;
      end case;
    end if;
  end process fill_32b_fifo;



  late_counter : process (clk100, rocs_reset_b)
  begin  -- process trigger_FSM
    if rocs_reset_b = '0' then          -- asynchronous reset (active low)
      
      late_running_counter_us <= x"FFBFFFFF";
      
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

  rand_trigger_proc : process (clk, rst_b)
  begin  -- process trigger_FSM
    if rst_b = '0' then                 -- asynchronous reset (active low)
      din_tt_fifo_rand   <= (others => '0');
      wr_en_tt_fifo_rand <= '0';
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      count_bit_buf <= late_running_counter(10);

      if count_bit_buf /= late_running_counter(10) then
        if en_rand_trigger = '1' then
          din_tt_fifo_rand   <= std_logic_vector(late_running_counter + 100000);
          wr_en_tt_fifo_rand <= '1';
        else
          din_tt_fifo_rand   <= (others => '0');
          wr_en_tt_fifo_rand <= '0';
        end if;
      else
        din_tt_fifo_rand   <= (others => '0');
        wr_en_tt_fifo_rand <= '0';
      end if;
    end if;
  end process rand_trigger_proc;


  comp_0_1 <= '1' when (unsigned(data_out_32bit_array(0)(31 downto 0))-unsigned(data_out_32bit_array(1)(31 downto 0)) + 1) < 3 else '0';
  comp_0_2 <= '1' when (unsigned(data_out_32bit_array(0)(31 downto 0))-unsigned(data_out_32bit_array(2)(31 downto 0)) +1) < 3  else '0';
  comp_0_3 <= '1' when (unsigned(data_out_32bit_array(0)(31 downto 0))-unsigned(data_out_32bit_array(3)(31 downto 0)) +1) < 3  else '0';
  comp_1_2 <= '1' when (unsigned(data_out_32bit_array(1)(31 downto 0))-unsigned(data_out_32bit_array(2)(31 downto 0)) +1) < 3  else '0';
  comp_1_3 <= '1' when (unsigned(data_out_32bit_array(1)(31 downto 0))-unsigned(data_out_32bit_array(3)(31 downto 0)) +1) < 3  else '0';
  comp_2_3 <= '1' when (unsigned(data_out_32bit_array(2)(31 downto 0))-unsigned(data_out_32bit_array(3)(31 downto 0)) +1) < 3  else '0';


  -- SWITCH BETWEEN OR TRIGGER, AND TRIGGER or RAND TRIGGER


  --din_tt_fifo   <= din_tt_fifo_or or din_tt_fifo_rand or din_tt_fifo_and;
  --wr_en_tt_fifo <= wr_en_tt_fifo_or or wr_en_tt_fifo_rand or wr_en_tt_fifo_and;

  tt_fifo_mux : process (clk, rst_b)
  begin
    if rst_b = '0' then
      din_tt_fifo   <= (others => '0');
      wr_en_tt_fifo <= '0';
    elsif clk'event and clk = '1' then
      if en_or_trigger = '1' then
        din_tt_fifo   <= din_tt_fifo_and_or;
        wr_en_tt_fifo <= wr_en_tt_fifo_and_or;
      elsif en_rand_trigger = '1' then
        din_tt_fifo   <= din_tt_fifo_rand;
        wr_en_tt_fifo <= wr_en_tt_fifo_rand;
      else
        din_tt_fifo   <= din_tt_fifo_and_or;
        wr_en_tt_fifo <= wr_en_tt_fifo_and_or;
      end if;
    end if;
  end process;

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


  async_trigger_proc : process (clk, rst_b)
  begin  -- process async_trigger_proc
    if rst_b = '0' then                 -- asynchronous reset (active low)
      atrig_state             <= INIT;
      rd_en_32b_fifos         <= (others => '0');
      trigger_times_array_old <= (others => X"00000000");
      trigger_time_tmp        <= (others => '0');
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      wr_en_tt_fifo_and_or <= '0';
      rd_en_32b_fifos      <= (others => '0');
      din_tt_fifo_and_or   <= (others => '0');


      case atrig_state is
        when INIT =>
          atrig_state <= CHECK_TIMES;

        when CHECK_TIMES =>
          trigger_time_tmp <= (others => '0');
          rd_en_32b_fifos  <= (others => '0');
          atrig_state      <= CHECK_TIMES;



          for j in 0 to 3 loop
            if data_out_32bit_array(j) = std_logic_vector(late_running_counter) then  --and empty_32b_fifos(j) = '0' then
              rd_en_32b_fifos(j) <= '1';
            end if;
          end loop;  -- j

          if en_or_trigger = '1' then   -- OR TRIGGER!
            for j in 0 to 3 loop
              if (unsigned(data_out_32bit_array(j)) = late_running_counter+2097151) and (empty_32b_fifos(j) = '0') then
                trigger_time_tmp   <= data_out_32bit_array(j);
                atrig_state        <= PULL_TRIGGER0;
                rd_en_32b_fifos(j) <= '1';
              end if;
            end loop;  -- j

            --for i in 0 to 3 loop  -- This wont work that well.. 
            --  if empty_32b_fifos(i) = '0' then
            --    atrig_state <= PULL_TRIGGER0;
            --    trigger_time_tmp <= data_out_32bit_array(i);
            --    for j in 0 to 3 loop
            --      if unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(j)) + 1 < 3 then
            --        rd_en_32b_fifos(i) <= '1';
            --      end if;
            --    end loop;  -- j
            --  end if;
            --end loop;  -- i

          end if;

          -- AND TRIGGER!
          if comp_0_1 = '1' and (empty_32b_fifos(1) = '0' and empty_32b_fifos(0) = '0') then
            if data_out_32bit_array(0) < data_out_32bit_array(1) then
              trigger_time_tmp <= data_out_32bit_array(0);
            else
              trigger_time_tmp <= data_out_32bit_array(1);
            end if;

            atrig_state <= PULL_TRIGGER0;
            for i in 0 to 3 loop
              if unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(0)) + 1 < 3 then
                rd_en_32b_fifos(i) <= '1';
              end if;
            end loop;  -- i
            
          elsif comp_0_2 = '1' and (empty_32b_fifos(0) /= '1' and empty_32b_fifos(2) /= '1') then
            if data_out_32bit_array(0) < data_out_32bit_array(2) then
              trigger_time_tmp <= data_out_32bit_array(0);
            else
              trigger_time_tmp <= data_out_32bit_array(2);
            end if;
            atrig_state <= PULL_TRIGGER0;
            for i in 0 to 3 loop
              if (unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(0)) + 1) < 3 then
                rd_en_32b_fifos(i) <= '1';
              end if;
            end loop;  -- i

          elsif comp_0_3 = '1' and (empty_32b_fifos(0) /= '1' and empty_32b_fifos(3) /= '1') then
            if data_out_32bit_array(0) < data_out_32bit_array(3) then
              trigger_time_tmp <= data_out_32bit_array(0);
            else
              trigger_time_tmp <= data_out_32bit_array(3);
            end if;
            atrig_state <= PULL_TRIGGER0;
            for i in 0 to 3 loop
              if (unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(0)) + 1) < 3 then
                rd_en_32b_fifos(i) <= '1';
              end if;
            end loop;  -- i

          elsif comp_1_2 = '1' and (empty_32b_fifos(1) /= '1' and empty_32b_fifos(2) /= '1') then
            if data_out_32bit_array(1) < data_out_32bit_array(2) then
              trigger_time_tmp <= data_out_32bit_array(1);
            else
              trigger_time_tmp <= data_out_32bit_array(2);
            end if;
            atrig_state <= PULL_TRIGGER0;
            for i in 0 to 3 loop
              if (unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(1)) + 1) < 3 then
                rd_en_32b_fifos(i) <= '1';
              end if;
            end loop;  -- i

          elsif comp_1_3 = '1' and (empty_32b_fifos(1) /= '1' and empty_32b_fifos(3) /= '1') then
            if data_out_32bit_array(1) < data_out_32bit_array(3) then
              trigger_time_tmp <= data_out_32bit_array(1);
            else
              trigger_time_tmp <= data_out_32bit_array(3);
            end if;
            atrig_state <= PULL_TRIGGER0;
            for i in 0 to 3 loop
              if (unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(1)) + 1) < 3 then
                rd_en_32b_fifos(i) <= '1';
              end if;
            end loop;  -- i

          elsif comp_2_3 = '1' and (empty_32b_fifos(2) /= '1' and empty_32b_fifos(3) /= '1') then
            if data_out_32bit_array(2) < data_out_32bit_array(3) then
              trigger_time_tmp <= data_out_32bit_array(2);
            else
              trigger_time_tmp <= data_out_32bit_array(3);
            end if;
            atrig_state <= PULL_TRIGGER0;
            for i in 0 to 3 loop
              if (unsigned(data_out_32bit_array(i)) - unsigned(data_out_32bit_array(2)) + 1) < 3 then
                rd_en_32b_fifos(i) <= '1';
              end if;
            end loop;  -- i                
          end if;


          --when PULL_OLD0 =>
          --  wr_en_tt_fifo_and <= '1';
          --  din_tt_fifo_and   <= x"ABCDABCD";

          --  atrig_state <= CHECK_TIMES;


        when PULL_TRIGGER0 =>
          wr_en_tt_fifo_and_or <= '1';
          din_tt_fifo_and_or   <= trigger_time_tmp;
          atrig_state          <= CHECK_TIMES;

        when others =>
          atrig_state <= INIT;
      end case;
    end if;
  end process async_trigger_proc;

  send_tt : process (clk, rst_b)
  begin  -- process send_tt
    if rst_b = '0' then                 -- asynchronous reset (active low)
      send_tt_state   <= INIT;
      package_counter <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      rd_en_tt_fifo     <= '0';
      send_fifo_we      <= '0';
      send_fifo_data_in <= x"00";

      bit17_lrc <= late_running_counter(16);


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

          elsif (late_running_counter(16) = '1' and bit17_lrc = '0') or (data_count_tt_fifo(7 downto 0) = x"FF") then
            trigger_times_to_send <= data_count_tt_fifo(7 downto 0);
            tt_to_send            <= dout_tt_fifo;
            send_tt_state         <= SEND_PRE0;
          end if;

          --elsif empty_tt_fifo /= '1' then
          --  tt_to_send    <= dout_tt_fifo;
          --  send_tt_state <= SEND_PRE0;
          --end if;
          
          

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

