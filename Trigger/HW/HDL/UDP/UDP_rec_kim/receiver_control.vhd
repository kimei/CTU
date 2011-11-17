library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.constants.all;

entity receiver_control is
  
  port (
    clk         : in std_logic;
    rst_b       : in std_logic;
    udp_data_in : in std_logic_vector(7 downto 0);
    valid_data  : in std_logic;
    port_number : in std_logic_vector(15 downto 0);

    --control_signals_out
    mrst_from_udp_b   : out std_logic;
    en_random_trigger : out std_logic;
    en_or_trigger     : out std_logic;
    trigger_mask        : out std_logic_vector(NUMBER_OF_ROCs-1 downto 0);
    module_mask         : out std_logic_vector(NUMBER_OF_MODULES-1 downto 0);

    -- udp sender fifo signals
    send_fifo_we        : out std_logic;
    send_fifo_we_others : in  std_logic;
    send_fifo_empty     : in  std_logic;
    send_fifo_data_in   : out std_logic_vector(7 downto 0)
    );

end receiver_control;

architecture behave of receiver_control is
  --signal trigger_mask : std_logic_vector(NUMBER_OF_ROCs-1 downto 0);


  signal rd_en_fifo          : std_logic;
  signal dout_fifo           : std_logic_vector(7 downto 0);
  signal full_fifo           : std_logic;
  signal empty_fifo          : std_logic;
  signal rst_fifo            : std_logic;
  signal data_count          : std_logic_vector(9 downto 0);
  signal valid_data_and_port : std_logic;

  signal trigger_mask_s : std_logic_vector(23 downto 0);
  signal mask_counter   : integer range 0 to 15;
  signal module_mask_s  : std_logic_vector(7 downto 0);


  --FSM signals

  type   states is (INIT, WAIT_FOR_PACKAGE, WAIT_FOR_FALLING_WR_EN, READ_INSTRUCTION, SET_MASK, SET_MASK2, SET_MODULE_MASK, SET_MODULE_MASK2 , SEND_HEADER, SEND_HEADER2 , NOTIFY_RESET, R_T_ON, AND_TRIGGER_ON, OR_TRIGGER_ON , RESET_ROCS, RESET_ROCS2);
  signal state           : states;
  signal instruction     : std_logic_vector(7 downto 0);
  signal instruction_buf : std_logic_vector(7 downto 0);

  component fifo_generator_v8_1
    port (
      clk        : in  std_logic;
      rst        : in  std_logic;
      din        : in  std_logic_vector(7 downto 0);
      wr_en      : in  std_logic;
      rd_en      : in  std_logic;
      dout       : out std_logic_vector(7 downto 0);
      full       : out std_logic;
      empty      : out std_logic;
      data_count : out std_logic_vector(9 downto 0)
      );
  end component;

 
 
begin  -- behave

 
  
  

  trigger_mask <= trigger_mask_s(NUMBER_OF_ROCs-1 downto 0);
  module_mask  <= module_mask_s(NUMBER_OF_MODULES-1 downto 0);

  valid_data_and_port <= '1' when ((valid_data = '1') and (port_number = x"138d")) else '0';
  -- port 5005

  udp_receive_fifo : fifo_generator_v8_1
    port map (
      clk        => clk,
      rst        => rst_fifo,
      din        => udp_data_in,
      wr_en      => valid_data_and_port,
      rd_en      => rd_en_fifo,
      dout       => dout_fifo,
      full       => full_fifo,
      empty      => empty_fifo,
      data_count => data_count
      );

  read_udp_fsm : process (clk, rst_b)
  begin  -- process read_udp_fsm
    if rst_b = '0' then                 -- asynchronous reset (active low)
      state             <= INIT;
      mrst_from_udp_b   <= '1';
      rd_en_fifo        <= '0';
      en_random_trigger <= '0';
      trigger_mask_s    <= (others => '1');
      module_mask_s     <= (others => '1');
      instruction       <= (others => '0');
      mask_counter      <= 0;
      en_or_trigger     <= '0';
      
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      rd_en_fifo        <= '0';
      mrst_from_udp_b   <= '1';
      rst_fifo          <= '0';
      send_fifo_we      <= '0';
      send_fifo_data_in <= "00000000";

      case state is
        when INIT =>
          rst_fifo        <= '1';
          state           <= WAIT_FOR_PACKAGE;
          mask_counter    <= 0;
          instruction_buf <= (others => '1');
          
        when WAIT_FOR_PACKAGE =>
          
          state <= WAIT_FOR_PACKAGE;
          if empty_fifo = '0' then
            state <= READ_INSTRUCTION;
          end if;


        when READ_INSTRUCTION =>
          instruction     <= dout_fifo;
          state           <= READ_INSTRUCTION;
          instruction_buf <= instruction;

          if instruction /= X"00" then
            state <= SEND_HEADER;
          elsif empty_fifo = '1' then
            state <= WAIT_FOR_PACKAGE;
          elsif instruction = instruction_buf then
            state <= INIT;
          end if;

        when SEND_HEADER =>
          if send_fifo_we_others = '1' or send_fifo_empty = '0' then
            state <= SEND_HEADER;
          else
            send_fifo_we      <= '1';
            send_fifo_data_in <= x"FF";
            state             <= SEND_HEADER2;
          end if;

        when SEND_HEADER2 =>
          instruction_buf   <= (others => '0');
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"02";
          if instruction_buf = x"72" then
            state <= NOTIFY_RESET;
          elsif instruction_buf = x"73" then
            state <= R_T_ON;
          elsif instruction_buf = x"74" then
            state <= AND_TRIGGER_ON;
          elsif instruction_buf = x"6d" then
            rd_en_fifo <= '1';
            state      <= SET_MASK;
          elsif instruction_buf = x"6f" then
            state <= OR_TRIGGER_ON;
          elsif instruction_buf = x"6e" then
            rd_en_fifo <= '1';
            state      <= SET_MODULE_MASK;
          else
            state <= INIT;
          end if;

        when SET_MASK =>
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"6d";
          rd_en_fifo        <= '1';
          state             <= SET_MASK2;

        when SET_MASK2 =>
          rd_en_fifo   <= '1';
          mask_counter <= mask_counter+1;
          if mask_counter = 0 then
            trigger_mask_s(7 downto 0) <= dout_fifo;
            send_fifo_we               <= '1';
            send_fifo_data_in          <= dout_fifo;
          elsif mask_counter = 1 then
            trigger_mask_s(15 downto 8) <= dout_fifo;
            send_fifo_we                <= '1';
            send_fifo_data_in           <= dout_fifo;
          elsif mask_counter = 2 then
            trigger_mask_s(23 downto 16) <= dout_fifo;
            send_fifo_we                 <= '1';
            send_fifo_data_in            <= dout_fifo;
          elsif mask_counter = 3 then
            state <= INIT;
          end if;

        when SET_MODULE_MASK =>
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"6e";
          rd_en_fifo        <= '1';
          state             <= SET_MODULE_MASK2;
          
        when SET_MODULE_MASK2 =>
          rd_en_fifo        <= '1';
          module_mask_s     <= dout_fifo;
          send_fifo_we      <= '1';
          send_fifo_data_in <= dout_fifo;
          state             <= INIT;
          

        when NOTIFY_RESET =>
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"72";
          state             <= RESET_ROCS;

        when AND_TRIGGER_ON =>
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"74";
          en_random_trigger <= '0';
          en_or_trigger     <= '0';
          state             <= INIT;

        when OR_TRIGGER_ON =>
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"6f";
          en_random_trigger <= '0';
          en_or_trigger     <= '1';
          state             <= INIT;
          
        when R_T_ON =>
          send_fifo_we      <= '1';
          send_fifo_data_in <= x"73";
          en_random_trigger <= '1';
          state             <= INIT;

        when RESET_ROCS =>
          mrst_from_udp_b <= '0';
          state           <= RESET_ROCS2;

        when RESET_ROCS2 =>
          mrst_from_udp_b <= '0';
          state           <= INIT;

        when others =>
          state <= INIT;
      end case;
    end if;
  end process read_udp_fsm;
end behave;
