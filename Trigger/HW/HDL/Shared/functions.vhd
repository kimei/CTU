-----------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package functions is


  function all_ones(s1 : std_logic_vector) return std_logic;
  --This function returns if the input vector has all ones and no zeros

  function all_zeros(s1 : std_logic_vector) return std_logic;

  function count_ones(s : std_logic_vector) return integer;

  FUNCTION zshr(s1:std_logic_vector) return std_logic_vector;

 


end functions;
package body functions is
--Function Declaration Section

  function all_ones(s1 : std_logic_vector) return std_logic is
    --returns z='1' if all bits in a vector are '1'
    variable Z : std_logic;
  begin
    Z := s1(s1'low);
    for i in (s1'low+1) to s1'high loop
      Z := Z and s1(i);
    end loop;
    return Z;
  end all_ones;  -- end function

  function all_zeros(s1 : std_logic_vector) return std_logic is
    --returns z='1' if all bits in a vector are '0'
    variable Z : std_logic;
  begin
    Z := '0';
    for i in (s1'low) to s1'high loop
      Z := Z or s1(i);
    end loop;
    return not(Z);
  end all_zeros;  -- end function

  function count_ones(s : std_logic_vector) return integer is
    variable temp : natural := 0;
  begin
    for i in s'range loop
      if s(i) = '1' then temp := temp + 1;
      end if;
    end loop;

    return temp;
  end function count_ones;

    FUNCTION zshr(s1:std_logic_vector) return std_logic_vector is 
    variable r : std_logic_vector(s1'high downto s1'low); 
  begin 
    r(r'high) := '0'; 
    r(r'high -1 downto 0) := s1(s1'high downto 1); 
    return r; 
  end zshr;


end functions;
