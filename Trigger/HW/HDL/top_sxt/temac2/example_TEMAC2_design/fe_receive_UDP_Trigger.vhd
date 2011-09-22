----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:15:42 03/08/2011 
-- Design Name: 
-- Module Name:    fe_receive_UDP - Behavioral 
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
use work.constants.all;
use work.types.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity fe_receive_UDP_Trigger is
  port (clk                : in  std_logic;  -- UDP clock
        rst                : in  std_logic;  -- UDP rst.
        mclk               : in  std_logic;  -- fe clock
        fe_rst_b           : in  std_logic;  -- fe reset
        valid_usr_data     : in  std_logic;
        UDP_data           : in  std_logic_vector (7 downto 0);
        LEDs               : out std_logic_vector (7 downto 0);
        --FPGA_conf      : out FPGA_conf_type;
        cs_ila_trig0       : out std_logic_vector(127 downto 0);
        TriggerTimeBack    : out std_logic_vector(31 downto 0);
        TriggerTimeBackRdy : out std_logic
        );
end fe_receive_UDP_Trigger;

architecture Behavioral of fe_receive_UDP_Trigger is
  signal LEDs_i                    : std_logic_vector(7 downto 0);
  signal source_port               : std_logic_vector(15 downto 0);
  signal dest_port                 : std_logic_vector(15 downto 0);
  signal data_length               : std_logic_vector(15 downto 0);
  signal valid_usr_data_reg        : std_logic;  --used to find the rising edge
  signal valid_usr_data_raising    : std_logic;  --used to find the rising edge
  signal valid_usr_data_falling    : std_logic;  --used to find the rising edge
  signal valid_usr_data_falling_z1 : std_logic;  --used to find the falling
                                                 --edge, delayed by one clk

  signal FPGA_conf : FPGA_conf_type;
  type   delay_line_arr_type is array (0 to 8) of std_logic_vector(7 downto 0);
  signal test      : std_logic_vector(7 downto 0);

  signal UDP_data_delay_reg  : delay_line_arr_type;
  signal UDP_data_delay_next : delay_line_arr_type;



  constant NUMBEROFTRIGGERS_IN_PACKAGE : integer := 8;

  constant MAX_MESSAGE_LENGTH : natural := NUMBEROFTRIGGERS_IN_PACKAGE*4 + 3;  -- number of bytes
  signal   counter            : integer range 0 to MAX_MESSAGE_LENGTH;

  type   data_register_type is array (0 to MAX_MESSAGE_LENGTH-1) of std_logic_vector(7 downto 0);
  signal data_register : data_register_type;


  type   TriggerRegisterType is array (0 to NUMBEROFTRIGGERS_IN_PACKAGE) of std_logic_vector(31 downto 0);
  signal TriggerRegister : TriggerRegisterType;


  --signal channel_mask : std_logic_vector(fe_NUM_CHANNELS-1 downto 0);
  --signal invert_mask  : std_logic_vector(fe_NUM_CHANNELS-1 downto 0);
  --signal WLS_mask     : std_logic_vector(fe_NUM_CHANNELS-1 downto 0);
  --signal TestPulseOn  : std_logic;
  --signal func         : std_logic_vector(7 downto 0);
  signal preambel : std_logic_vector(23 downto 0);  -- the first 3 bytes must
                                                    -- correspond to @@@


  -- signal reconfigureNow   : std_logic_vector(3 downto 0);  -- reconfigure masks 5 clock cycles after the data has arrived. keep signal high for a few clock cycles.
  --signal ReconfigureMeNow : std_logic;
  type FPGA_conf_arr_type is array (0 to 3) of FPGA_conf_type;
  --signal FPGA_conf_reg    : FPGA_conf_arr_type;
  --signal FPGA_conf_next   : FPGA_conf_arr_type;


--dummy signals:
  signal dummy1 : std_logic_vector(0 downto 0);
  signal dummy2 : std_logic_vector(0 downto 0);


--cs:
  signal cs_ila_trig0_i       : std_logic_vector(127 downto 0);
  signal TriggerTimeBack_i    : std_logic_vector(31 downto 0);
  signal TriggerTimeBackRdy_i : std_logic;

  signal TriggerCounter : integer range 0 to NUMBEROFTRIGGERS_IN_PACKAGE;

  
begin
  
  cs_ila_trig0 <= cs_ila_trig0_i;

  DelayLineReg : process(clk, rst)
  begin
    if(rst = '1') then
      UDP_data_delay_reg <= (others => (others => '0'));
      valid_usr_data_reg <= '0';
    elsif(rising_edge(clk)) then
      UDP_data_delay_reg <= UDP_data_delay_next;
      valid_usr_data_reg <= valid_usr_data;
    end if;
  end process;

  UDP_data_delay_next(0) <= UDP_data;
  test                   <= UDP_data;
  DelayLineLog : for i in 1 to 8 generate
    UDP_data_delay_next(i) <= UDP_data_delay_reg(i-1);
  end generate DelayLineLog;


--as soon as there is a valid usr data raising edge, register the port numbers:
  valid_usr_data_raising <= '1' when (valid_usr_data_reg = '0' and valid_usr_data = '1') else '0';
-- when the message is here, we want to interpret it.
  valid_usr_data_falling <= '1' when (valid_usr_data_reg = '1' and valid_usr_data = '0') else '0';

  RegisterPortNumber : process(clk, rst)
  begin
    if(rst = '1') then
      source_port <= (others => '0');
      dest_port   <= (others => '0');
    elsif(rising_edge(clk)) then
      if valid_usr_data_raising = '1' then
        source_port <= UDP_data_delay_reg(7)&UDP_data_delay_reg(6);
        dest_port   <= UDP_data_delay_reg(5)&UDP_data_delay_reg(4);
      else
        source_port <= source_port;
        dest_port   <= dest_port;
      end if;
      
    end if;
  end process;

--  cs_ila_trig0_i(15 downto 00) <= source_port;
--  cs_ila_trig0_i(31 downto 16) <= dest_port;
-- register the data to be analysed at valid_usr_data_falling:
-- first need a counter enabled by valid_usr_data. The counter is the address
-- of the data registers.

  AdressCounter : process(clk, rst)
  begin
    if(rst = '1') then
      counter       <= 0;
      data_register <= (others => (others => '0'));
    elsif(rising_edge(clk)) then
      data_register <= data_register;
      if(valid_usr_data = '1' and counter < MAX_MESSAGE_LENGTH) then  --enable the counter
        counter                <= counter+1;
        data_register(counter) <= UDP_data;
      elsif valid_usr_data = '0' then
        counter <= 0;
      else
        counter <= counter;
      end if;
    end if;
  end process;



--on the falling  valid_usr_data_falling interpret the message:
  --func     <= data_register(3);
  preambel <= data_register(0)&data_register(1)&data_register(2);

  --cs_ila_trig0_i(59)           <= valid_usr_data_falling;
  --cs_ila_trig0_i(67 downto 60) <= func;
  --cs_ila_trig0_i(77 downto 70) <= data_register(4);

  InterpretMessage : process(clk, rst)
    --constant MaxByte : integer := (fe_NUM_DIFF_CHANNELS-1)/8;
  begin
    if(rst = '1') then
      TriggerRegister           <= (others => (others => '0'));
      valid_usr_data_falling_z1 <= '0';
    elsif(rising_edge(clk)) then
    

      if valid_usr_data_falling = '1' then
        if preambel = x"404040" then
          if source_port = x"4242" and dest_port = x"4241" then
            valid_usr_data_falling_z1 <= valid_usr_data_falling;
            for i in 0 to NUMBEROFTRIGGERS_IN_PACKAGE-1 loop
              for j in 0 to 3 loop
                
                TriggerRegister(i)(8*(j+1)-1 downto 8*j) <= data_register(4*i+j + 3);
              end loop;  --j
              
            end loop;  -- i
            else
            valid_usr_data_falling_z1 <= '0';
          end if;

          
        end if;
      end if;
    end if;
  end process;

  SendTriggerTimesBack : process(clk, rst)

  begin
    if(rst = '1') then
      TriggerTimeBack_i    <= (others => '0');
      TriggerTimeBackRdy_i <= '0';
      TriggerCounter       <= NUMBEROFTRIGGERS_IN_PACKAGE;
    elsif(rising_edge(clk)) then
      TriggerTimeBack_i    <= (others => '0');
      TriggerTimeBackRdy_i <= '0';
      if valid_usr_data_falling_z1 = '1' then
        TriggerCounter <= 0;
        
      elsif(TriggerCounter < NUMBEROFTRIGGERS_IN_PACKAGE) then
        TriggerTimeBack_i    <= TriggerRegister(TriggerCounter);
        TriggerTimeBackRdy_i <= '1';
        TriggerCounter       <= TriggerCounter + 1;

      else
        TriggerCounter <= NUMBEROFTRIGGERS_IN_PACKAGE;
      end if;
      
    end if;
  end process;

  TriggerTimeBack    <= TriggerTimeBack_i;
  TriggerTimeBackRdy <= TriggerTimeBackRdy_i;



  -- cs debug:
  cs_ila_trig0_i(31 downto 0)  <= TriggerTimeBack_i;
  cs_ila_trig0_i(32)           <= TriggerTimeBackRdy_i;
  cs_ila_trig0_i(39)           <= valid_usr_data_falling;
  cs_ila_trig0_i(47 downto 40) <= data_register(3);

end Behavioral;

