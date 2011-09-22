library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.constants.all;

entity udp_rec is
  port(
    clk                : in  std_logic;
    rst_b              : in  std_logic;
    usr_data_input_bus : in  std_logic_vector(7 downto 0);
    valid_out_usr_data : in  std_logic;
    dswitch : in std_logic_vector(7 downto 0);
    data_out           : inout std_logic_vector(7 downto 0);
    valid_data         : inout std_logic;
    sender_ip          : inout std_logic_vector(7 downto 0);
    port_number        : out std_logic_vector(15 downto 0));  
end udp_rec;

architecture behave of udp_rec is

  subtype byter is std_logic_vector(7 downto 0);
  -- type    header_arr is array(0 to 11) of byter;
  type    header_arr is array(0 to 15) of byter;
  signal  header : header_arr;

  signal ip_correct             : std_logic;
  signal ip_correct_hold        : std_logic;
  signal valid_out_usr_data_buf : std_logic;

  signal mongo_teller : integer range 0 to 64;

  signal sender_ip_i   : std_logic_vector(7 downto 0);
  signal port_number_i : std_logic_vector(15 downto 0);

  signal dswitch_p1 : std_logic_vector(7 downto 0);


begin  -- behave

  dswitch_p1 <= std_logic_vector(unsigned(dswitch)+1);
 

  -- Check if it is 192.168.1.63
  ip_correct <= '1' when (header(4) = X"c0" and header(5) = X"a8" and header(6) = X"01" and header(7) = dswitch_p1) else '0';

  --sender_ip <= sender_ip_i; -- when ((ip_correct = '1' or ip_correct_hold = '1') and valid_out_usr_data = '1') else x"00";
  --port_number <= port_number_i; -- when ((ip_correct = '1' or ip_correct_hold = '1') and valid_out_usr_data = '1') else x"0000";


  shift_header : process (clk, rst_b)
  begin  -- process shift_header
    if rst_b = '0' then                 -- asynchronous reset (active low)
      header          <= (others => "00000000");
      ip_correct_hold <= '0';
      data_out        <= x"00";
      mongo_teller    <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge
      ip_correct_hold <= '0';
      data_out        <= x"00";
      valid_data      <= '0';


      valid_out_usr_data_buf <= valid_out_usr_data;
      header(15)             <= usr_data_input_bus;
      for i in 0 to header'length-2 loop
        header(i) <= header(i+1);
      end loop;  -- i

      if ip_correct = '1' then
        sender_ip   <= header(3);
        port_number <= header(10)&header(11);
      end if;

      if ((ip_correct = '1' or ip_correct_hold = '1') and valid_out_usr_data = '1') then
        ip_correct_hold <= '1';
        data_out        <= usr_data_input_bus;
        valid_data      <= '1';
      end if;
      
      
    end if;
  end process shift_header;

  

end behave;
