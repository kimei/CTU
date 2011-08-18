library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;
use work.constants.all;

entity udp_rec is
  port(
    clk                : in     std_logic;
    rst_b              : in     std_logic;
    usr_data_input_bus : in     std_logic_vector(7 downto 0);
    valid_out_usr_data : in     std_logic;
    data_out           : out    std_logic_vector(7 downto 0);
    valid_data         : out    std_logic;
    port_number        : buffer std_logic_vector(15 downto 0));  
end udp_rec;

architecture behave of udp_rec is

  subtype byter is std_logic_vector(7 downto 0);
  type    header_arr is array(0 to 11) of byter;
  signal header : header_arr;

  signal ip_correct             : std_logic;
  signal ip_correct_hold        : std_logic;
  signal valid_out_usr_data_buf : std_logic;

  signal mongo_teller : integer range 0 to 64;


begin  -- behave
  -- Check if it is 192.168.1.63
  ip_correct <= '1' when (header(0) = X"c0" and header(1)=X"a8" and header(2)=X"01" and header(3)=X"3f") else '0';




  shift_header : process (clk, rst_b)
  begin  -- process shift_header
    if rst_b = '0' then                 -- asynchronous reset (active low)
      header          <= (others => "00000000");
      ip_correct_hold <= '0';
      data_out        <= x"00";
      mongo_teller <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge
      ip_correct_hold <= '0';
      data_out        <= x"00";
      valid_data      <= '0';

      valid_out_usr_data_buf <= valid_out_usr_data;
      header(11)             <= usr_data_input_bus;
      for i in 0 to header'length-2 loop
        header(i) <= header(i+1);
      end loop;  -- i

      if ip_correct = '1' then
        port_number <= header(6)&header(7);
      end if;

      if ((ip_correct = '1' or ip_correct_hold = '1') and valid_out_usr_data = '1') then
 
        ip_correct_hold <= '1';
        data_out        <= usr_data_input_bus;
        valid_data      <= '1';
      end if;
 
      
    end if;
  end process shift_header;

  

end behave;