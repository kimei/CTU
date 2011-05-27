----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:57:49 03/21/2011 
-- Design Name: 
-- Module Name:    IPV4_WriteUDPHeader - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity IPV4WriteUDPHeader is
  generic
    (
      DestMAC  : std_logic_vector(47 downto 0) := x"00c09fbf33b0";  --ferrari
      --DestMAC: std_logic_vector(47 downto 0):=x"000e0c333384";  --compet002
      DestIP   : std_logic_vector(31 downto 0) := x"C0A80140";  --192.168.1.64
      --DestIP: std_logic_vector(31 downto 0) :=  x"C0A80102"  --192.168.1.2
      SrcPort  : std_logic_vector(15 downto 0) := "0101010101010101";  -- for the data
      DestPort : std_logic_vector(15 downto 0) := "0101010101010100"   -- data
      );
  port (clk              : in  std_logic;
        rst              : in  std_logic;
        DSwitch          : in  std_logic_vector (7 downto 0);
        addr             : out std_logic_vector(5 downto 0);
        we               : out std_logic;
        data             : out std_logic_vector(7 downto 0);
        CheckSumTemplate : out std_logic_vector(15 downto 0)

        );
end IPV4WriteUDPHeader;


architecture Behavioral of IPV4WriteUDPHeader is

  signal CheckSumTemplate_i : std_logic_vector(15 downto 0);


  constant BaseSrcIP  : std_logic_vector(31 downto 0) := x"C0A80101";  --192.168.1.1
  constant BaseSrcMAC : std_logic_vector(47 downto 0) := x"7e7e7e7e7e00";
  signal   SrcIP      : std_logic_vector(31 downto 0);
  signal   SrcMAC     : std_logic_vector(47 downto 0);

  signal addressChanged : std_logic;    --gets high when the dip switch changes
  signal setupNow_n     : std_logic;    --
  signal setupNow_reg   : std_logic;  --is high until the ram is setup for the first
  --time
  signal DSwitch_reg    : std_logic_vector(7 downto 0);

--signal we_reg      : std_logic;
  signal addr_reg : unsigned(5 downto 0);
--signal data_reg    : std_logic;
  signal addr_i   : unsigned(5 downto 0);
  signal we_i     : std_logic;
  signal addr_n   : unsigned(5 downto 0);
  signal data_i   : std_logic_vector(7 downto 0);

  signal ChecksumTemplate_reg : unsigned(16 downto 0);  --16 bits+overflow
  signal ChecksumTemplate_n   : unsigned(16 downto 0);


  signal Checksum32_reg : unsigned(31 downto 0);
  signal Checksum32_n   : unsigned(31 downto 0);
begin

  we   <= we_i;
  addr <= std_logic_vector(addr_i);
  data <= std_logic_vector(data_i);


  srcIP  <= std_logic_vector(unsigned(BaseSrcIP) + unsigned(DSwitch));
  srcMAC <= std_logic_vector(unsigned(BaseSrcMAC) + unsigned(DSwitch));


  WriteUDPHeaderReg : process(clk, rst)
  begin
    if(rst = '1') then
      addr_reg     <= (others => '0');
      DSwitch_reg  <= (others => '0');
      setupNow_reg <= '1';

      ChecksumTemplate_reg <= (others => '0');
      CheckSum32_reg       <= (others => '0');
    elsif(clk'event and clk = '1') then
      addr_reg     <= addr_n;
      DSwitch_reg  <= DSwitch;
      setupNow_reg <= setupNow_n;

      CheckSum32_reg       <= CheckSum32_n;
      ChecksumTemplate_reg <= ChecksumTemplate_n;
    end if;
  end process;

  addressChanged <= '1' when DSwitch /= DSwitch_reg
                    else '0';
  
  
  WriteUDPHeaderLog : process(DSwitch_reg, addr_reg, addressChanged, setupNow_reg, ChecksumTemplate_reg , CheckSum32_reg)
    variable overflow : std_logic;
    variable summand  : unsigned(15 downto 0);
    variable sum      : unsigned(16 downto 0);
  begin
    --if(addressChanged='1' or setup_now_reg = '1' or addr_reg /= 0) then
    if((setupNow_reg = '1') or (addr_reg /= 0)) then
      addr_n             <= (addr_reg+ 1);
      we_i               <= '1';
      addr_i             <= addr_reg;
      ChecksumTemplate_n <= ChecksumTemplate_n;
      CheckSum32_n       <= CheckSum32_reg;
      case addr_reg is
        when to_unsigned(0, 6) =>
          data_i             <= DestMAC(47 downto 40);
          CheckSum32_n       <= (others => '0');
          ChecksumTemplate_n <= (others => '0');
        when to_unsigned(1, 6) =>
          data_i <= DestMAC(39 downto 32);

        when to_unsigned(2, 6) =>
          data_i <= DestMAC(31 downto 24);

        when to_unsigned(3, 6) =>
          data_i <= DestMAC(23 downto 16);

        when to_unsigned(4, 6) =>
          data_i <= DestMAC(15 downto 8);

        when to_unsigned(5, 6) =>
          data_i <= DestMAC(7 downto 0);


          
        when to_unsigned(6, 6) =>
          data_i <= SrcMAC(47 downto 40);

        when to_unsigned(7, 6) =>
          data_i <= SrcMAC(39 downto 32);

        when to_unsigned(8, 6) =>
          data_i <= SrcMAC(31 downto 24);

        when to_unsigned(9, 6) =>
          data_i <= SrcMAC(23 downto 16);

        when to_unsigned(10, 6) =>
          data_i <= SrcMAC(15 downto 8);

        when to_unsigned(11, 6) =>
          data_i <= SrcMAC(7 downto 0);


          -- ethertype:
        when to_unsigned(12, 6) =>
          data_i <= "00001000";
        when to_unsigned(13, 6) =>
          data_i <= "00000000";
          --version, headerlength: --start of IP=>
        when to_unsigned(14, 6) =>
          data_i <= "01000101";
        when to_unsigned(15, 6) =>
          --differentiated services
          data_i  <= "00000000";
          summand := "0100010100000000";

          sum := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(0)xor sum(16);
          ChecksumTemplate_n(16)          <= '0';

          CheckSum32_n <= CheckSum32_reg + summand;
          -- total length:
        when to_unsigned(16, 6) =>
          data_i             <= "00000000";
          ChecksumTemplate_n <= ChecksumTemplate_reg;
          
        when to_unsigned(17, 6) =>
          data_i  <= "00000000";
          summand := "0000000000011100";  --to be checked
          -- summand := "0000000000001000";          --to be checked
          sum     := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          CheckSum32_n                    <= CheckSum32_reg + summand;


          --identification:
        when to_unsigned(18, 6) =>
          data_i             <= "00000000";
          ChecksumTemplate_n <= ChecksumTemplate_reg;
        when to_unsigned(19, 6) =>
          data_i             <= "00000000";
          ChecksumTemplate_n <= ChecksumTemplate_reg;  --nothing done, its
                                                       --0
          --flags, fragment offset:
        when to_unsigned(20, 6) =>
          data_i             <= "01000000";
          ChecksumTemplate_n <= ChecksumTemplate_reg;
        when to_unsigned(21, 6) =>
          data_i  <= "00000000";
          summand := "0100000000000000";
          sum     := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          CheckSum32_n                    <= CheckSum32_reg + summand;


          --time to live:
        when to_unsigned(22, 6) =>
          data_i             <= "01000000";
          ChecksumTemplate_n <= ChecksumTemplate_reg;

          --protocol
        when to_unsigned(23, 6) =>
          data_i  <= "00010001";
          summand := "01000000"& "00010001";

          sum := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          addr_n                          <= (addr_reg+ 3);  --jump over the checksum field
          CheckSum32_n                    <= CheckSum32_reg + summand;
          --checksum:
        when to_unsigned(24, 6) =>
          data_i             <= std_logic_vector(ChecksumTemplate_reg(15 downto 8));
          ChecksumTemplate_n <= ChecksumTemplate_reg;
          
        when to_unsigned(25, 6) =>
          data_i             <= std_logic_vector(ChecksumTemplate_reg(7 downto 0));
          ChecksumTemplate_n <= ChecksumTemplate_reg;
          addr_n             <= (others => '0');  -- jump back to 0.

          -- IP:
        when to_unsigned(26 , 6) =>
          data_i             <= SrcIP(31 downto 24);
          ChecksumTemplate_n <= ChecksumTemplate_reg;
        when to_unsigned(27 , 6) =>
          data_i  <= SrcIP(23 downto 16);
          summand := unsigned(SrcIP(31 downto 16));
          sum     := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          CheckSum32_n                    <= CheckSum32_reg + summand;

        when to_unsigned(28 , 6) =>
          data_i             <= SrcIP(15 downto 8);
          ChecksumTemplate_n <= ChecksumTemplate_reg;

        when to_unsigned(29 , 6) =>
          data_i <= SrcIP(7 downto 0);

          summand := unsigned(SrcIP(15 downto 0));
          sum     := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          CheckSum32_n                    <= CheckSum32_reg + summand;
        when to_unsigned(30 , 6) =>
          data_i             <= DestIP(31 downto 24);
          ChecksumTemplate_n <= ChecksumTemplate_reg;

        when to_unsigned(31 , 6) =>
          data_i  <= DestIP(23 downto 16);
          summand := unsigned(DestIP(31 downto 16));
          sum     := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          CheckSum32_n                    <= CheckSum32_reg + summand;
        when to_unsigned(32 , 6) =>
          data_i             <= DestIP(15 downto 8);
          ChecksumTemplate_n <= ChecksumTemplate_reg;

        when to_unsigned(33 , 6) =>
          data_i  <= DestIP(7 downto 0);
          summand := unsigned(DestIP(15 downto 0));
          sum     := ChecksumTemplate_reg + summand;

          ChecksumTemplate_n(15 downto 1) <= sum(15 downto 1);
          ChecksumTemplate_n(0)           <= sum(16) xor sum(0);
          ChecksumTemplate_n(16)          <= '0';
          CheckSum32_n                    <= CheckSum32_reg + summand;
          --src port: is 4242:
        when to_unsigned(34 , 6) =>
          --data_i                          <= "01010101";
          data_i                          <= SrcPort(15 downto 8);
          --ChecksumTemplate_n    <= not(ChecksumTemplate_reg);  --build the ones
          --CheckSum32_n <= CheckSum32_reg;                                                   --complement
          summand                         := CheckSum32_reg(15 downto 0)+ CheckSum32_reg(31 downto 16);  --build the ones
          ChecksumTemplate_n(15 downto 0) <= summand(15 downto 0);
          ChecksumTemplate_n(16)          <= '0';
        when to_unsigned(35 , 6) =>
          --data_i             <= "01010101";
          data_i             <= SrcPort(7 downto 0);
          ChecksumTemplate_n <= not(ChecksumTemplate_reg);
          --dest port:
        when to_unsigned(36 , 6) =>
          --data_i             <= "01010101";
          data_i             <= DestPort(15 downto 8);
          ChecksumTemplate_n <= ChecksumTemplate_reg;
        when to_unsigned(37 , 6) =>
          --   data_i             <= "01010100";
          data_i             <= DestPort(7 downto 0);
          ChecksumTemplate_n <= ChecksumTemplate_reg;

          
        when others =>
          data_i             <= (others => '0');
          addr_n             <= to_unsigned(24, 6);
          ChecksumTemplate_n <= ChecksumTemplate_reg;
      end case;
      

    else
      addr_n             <= (others => '0');
      addr_i             <= (others => '0');
      setupNow_n         <= '0';
      we_i               <= '0';
      data_i             <= (others => '0');
      ChecksumTemplate_n <= (others => '0');
    end if;
    

  end process;

  OutputReg : process(clk, rst)
    variable tmp : std_logic_vector(16 downto 0);
  begin
    if(rst = '1') then
      CheckSumTemplate_i <= (others => '0');

    elsif(clk'event and clk = '1') then
      if(we_i = '1') then
        tmp                := std_logic_vector(ChecksumTemplate_reg);
        CheckSumTemplate_i <= tmp(15 downto 0);
      else
        CheckSumTemplate_i <= CheckSumTemplate_i;
      end if;
    end if;
  end process;


  CheckSumTemplate <= CheckSumTemplate_i;
  
  



end Behavioral;

