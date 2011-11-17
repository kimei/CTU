-- Constants for the CTU
-- Kim-Eigard Hines

--! Standard library
library ieee;
use ieee.std_logic_1164.all;            --! Standard logic
use ieee.numeric_std.all;     --! Numeric/arithmetical logic (IEEE standard)


--! \brief Constants
package constants is
--Constants associated with the CRU

-- Since each read-oust card needs to be reset to accept the new clock coming
-- CTU, and since it is daisy chained, we have to send a reset signal around
-- every 200 us. The pll needs at least 100 us to be a trustworthy source of clk.
  constant NUMBER_OF_ROCS    : positive := 5;
  constant NUMBER_OF_MODULES : positive := 2;
  
  constant computer_ip : std_logic_vector(7 downto 0) := X"40";
  constant computer_mac : std_logic_vector(7 downto 0) := X"3f";
                                                       

  constant ROCS_IN_M1 : integer := 4;   -- channel 0 to rocs in m1-1
  constant ROCS_IN_M2 : integer := 1;   -- channel ROCS_IN_M1 to ROCS_IN_M2-1,
  constant ROCS_IN_M3 : integer := 0;   -- etc.. 
  constant ROCS_IN_M4 : integer := 0;

  constant TRIGGER_WINDOW_LENGTH : positive := 3;  -- Trigger window in clk cycles
  constant TRIGGER_DELAY         : positive := 5;  -- delay of data before it is sent                                                  -- to the ROC
  constant TRIGGER_HOLD          : positive := 3;
  -- the trigger window is closed

  constant WAIT_PERIODS_1 : positive := 10000;
  constant WAIT_PERIODS_2 : positive := 50000;  -- it will wait twice as many
                                                -- clockcycles as this.. 

  
end package constants;
