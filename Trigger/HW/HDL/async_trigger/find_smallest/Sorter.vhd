library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Sorter is
  port (clk     : in  std_logic;
        rst     : in  std_logic;
        data0   : in  std_logic_vector (31 downto 0);
        en0     : in  std_logic;
        data1   : in  std_logic_vector (31 downto 0);
        en1     : in  std_logic;
        data2   : in  std_logic_vector (31 downto 0);
        en2     : in  std_logic;
        data3   : in  std_logic_vector (31 downto 0);
        en3     : in  std_logic;
        data4   : in  std_logic_vector (31 downto 0);
        en4     : in  std_logic;
        dataMin : out std_logic_vector(31 downto 0);
        chMin   : out std_logic_vector(2 downto 0)

        );

end Sorter;

architecture Behavioral of Sorter is


  function isbigger (a, b : unsigned(31 downto 0)) return std_logic is

  begin
    
    if(a(31) = '0' and b(31) = '1') then  --overflow
      return '1';
    elsif(a(31) = '1' and b(31) = '0') then
      return '0';
    elsif(a > b) then
      return '1';
    else
      return '0';
    end if;
  end isbigger;


  signal ISBIGGER01 : std_logic;



begin


  
  SortData : process (data0, data1, data2, data3, data4)
    variable udata0     : unsigned (31 downto 0);
    variable udata1     : unsigned (31 downto 0);
    variable udata2     : unsigned (31 downto 0);
    variable udata3     : unsigned (31 downto 0);
    variable udata4     : unsigned (31 downto 0);
    variable udata01    : unsigned(31 downto 0);
    variable udata23    : unsigned(31 downto 0);
    variable ch01       : integer range 0 to 1;
    variable ch23       : integer range 2 to 3;
    variable udata0123  : unsigned(31 downto 0);
    variable ch0123     : integer range 0 to 3;
    variable udata01234 : unsigned(31 downto 0);
    variable ch01234    : integer range 0 to 4;
  begin  -- process SortData
    udata0 := unsigned(data0);
    udata1 := unsigned(data1);
    udata2 := unsigned(data2);
    udata3 := unsigned(data3);
    udata4 := unsigned(data4);

    ---------------------------------------------------------------------------
    -- FIRST STEP ------------
    ---------------------------------------------------------------------------


    if en1 = '1' then
      if(isbigger(udata0, udata1) = '1') then
        udata01 := udata1;
        ch01    := 1;
      else
        udata01 := udata0;
        ch01    := 0;
      end if;
    else
      udata01 := udata0;
      ch01    := 0;
    end if;

    if en3 = '1' then                   -- both is enabled
      if(isbigger(udata2, udata3) = '1') then
        udata23 := udata3;
        ch23    := 3;
      else
        udata23 := udata2;
        ch23    := 2;
      end if;
    else                                --only 2 is enable
      udata23 := udata2;
      ch23    := 2;
    end if;





-------------------------------------------------------------------------------
-- SECOND STEP
-------------------------------------------------------------------------------

    if en2 = '1' then
      if(isbigger(udata01, udata23) = '1') then
        udata0123 := udata23;
        ch0123    := ch23;
      else
        udata0123 := udata01;
        ch0123    := ch01;
      end if;
    else
      udata0123 := udata01;
      ch0123    := ch01;
    end if;

-------------------------------------------------------------------------------
-- THIRD STEP
-------------------------------------------------------------------------------
    if en4 = '1 then
      if(isbigger(udata0123, udata4) = '1') then
        udata01234 := udata4;
        ch01234    := 4;
      else
        udata01234 := udata0123;
        ch01234    := ch0123;
      end if;
    else
      udata01234 := udata0123;
      ch01234    := ch0123;
    end if;


    dataMin <= std_logic_vector(udata01234);
    chMin   <= std_logic_vector(to_unsigned(ch01234, 3));
    

  end process SortData;


end Behavioral;
