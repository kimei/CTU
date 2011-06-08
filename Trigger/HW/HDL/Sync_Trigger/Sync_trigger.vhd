-------------------------------------------------------------------------------
-- Title      : Sync Trigger
-- Project    : Source files in two directories, custom library name, VHDL'87
-------------------------------------------------------------------------------
-- File       : Sync_trigger.vhd
-- Author     :   <kimei@fyspc-epf02>
-- Company    : 
-- Created    : 2011-03-08
-- Last update: 2011-06-07
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Synchronous trigger part of the CTU in COMPET
-- This moduel will first detect a rising edge on trigger_in (and trigger_in_b)
-- by using edge_detect.vhd. The width of trigger_in is the same as number of
-- read-out cards. A signal is then created that gathers all the read-out cards
-- from the same module (geometricly speaking) which will be '1' if one or more
-- of the read-out cards from the same module as a leading edge.
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-03-08  1.0      kimei   Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;     --! Numeric/arithmetical logic (IEEE standard)

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.components.all;
use work.constants.all;
use work.functions.all;

entity sync_trigger is
  port (
    rst_b         : in  std_logic;
    mclk          : in  std_logic;
    trigger_in    : in  std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
    trigger_out   : out std_logic_vector(NUMBER_OF_ROCS-1 downto 0));

end sync_trigger;


architecture Behavioral of sync_trigger is
  
  subtype temp is std_logic_vector(1 downto 0);
  type    coincidence_arr is array(0 to 3) of temp;


  signal coincidence_array : coincidence_arr;
  signal coincidence_or    : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);
  signal coincidence       : std_logic;
  signal coincidence_hold  : std_logic;
  signal zeros_in_last : std_logic;


  signal trig_out_s_d : std_logic_vector(4 downto 0);
--	  signal trig_out_s : std_logic;

  signal leading_edge_module : std_logic_vector(NUMBER_OF_MODULES-1 downto 0);

  signal edge_det : std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
  

  
  
begin

  -- Sets trigger out high after four clk-cycles and holds it for three.
 -- trig_out_s <= '1' when coincidence = '1' or coincidence_hold = '1' else '0';
	trigger_out <= (others =>'1') when trig_out_s_d(0) = '1' else (others => '0');
  
  -- Not the slickest solution, but i doubt there will be more than four
  -- modules, and therefore this solution is sufficient..
  -- looks for how many modules is implemented, and makes an OR of all the
  -- signals from the leading edge detector which is from the same module.
  N : for n in 0 to NUMBER_OF_MODULES - 1 generate
    N1 : if n = 0 generate
      -- this is basically an OR of all the signals. 
      leading_edge_module(n) <= '0' when all_zeros(edge_det(ROCS_IN_M1-1 downto 0)) = '1' else '1';
    end generate N1;
    N2 : if n = 1 generate
      leading_edge_module(n) <= '0' when all_zeros(edge_det(ROCS_IN_M1+ROCS_IN_M2-1 downto ROCS_IN_M1)) = '1' else '1';
    end generate N2;

    N3 : if n = 2 generate
      leading_edge_module(n) <= '0' when all_zeros(edge_det(ROCS_IN_M1+ROCS_IN_M2+ROCS_IN_M3-1 downto ROCS_IN_M1+ROCS_IN_M2)) = '1' else '1';
    end generate N3;

    N4 : if n = 3 generate
      leading_edge_module(n) <= '0' when all_zeros(edge_det(ROCS_IN_M1+ROCS_IN_M2+ROCS_IN_M3+ROCS_IN_M4-1 downto ROCS_IN_M1+ROCS_IN_M2+ROCS_IN_M3)) = '1' else '1';
    end generate N4;
  end generate N;
  
  NN0 : if NUMBER_OF_MODULES = 1 generate
		zeros_in_last <= '1' when coincidence_array(0)(1) = '0' else '0';
  end generate NN0;
   NN1 : if NUMBER_OF_MODULES = 2 generate
		zeros_in_last <= '1' when (coincidence_array(0)(1) = '0') and (coincidence_array(1)(1) = '0')  else '0';
  end generate NN1;
  
    NN2 : if NUMBER_OF_MODULES = 3 generate
		zeros_in_last <= '1' when (coincidence_array(0)(1) = '0') and (coincidence_array(1)(1) = '0')and (coincidence_array(2)(1) = '0')  else '0';
  end generate NN2;
  
   NN3 : if NUMBER_OF_MODULES = 4 generate
		zeros_in_last <= '1' when (coincidence_array(0)(1) = '0') and (coincidence_array(1)(1) = '0') and (coincidence_array(2)(1) = '0') and (coincidence_array(3)(1) = '0') else '0';
  end generate NN3;
  
  G4 : for n in 0 to NUMBER_OF_MODULES-1 generate
    coincidence_or(n) <= coincidence_array(n)(1) or coincidence_array(n)(0);
  end generate G4;



-- Sett Denne til > 1 for ordentlig data!
  coincidence <= '1' when count_ones(coincidence_or) > 1 else '0';
  
  


  G3 : for I in 0 to NUMBER_OF_ROCS -1 generate
    edge_detect_1 : edge_detector
      port map (
        rst_b => rst_b,
        mclk  => mclk,
        inp   => trigger_in(I),
        outp  => edge_det(I));
	end generate G3;

-- This process will load the shift-register trig_out_s_d 
-- with three ones and shift them outwards. This is to create
-- the proper delay. need a delay of one if the coincidence is
-- the same clockcycle, and delay of zero if the coincidence 
-- is split between two clock cycles.
delay_output : process (mclk, rst_b)
begin
     if rst_b = '0' then
        coincidence_hold  <= '0';
		  trig_out_s_d <= (others => '0');
     elsif mclk'event and mclk = '1' then
	  	trig_out_s_d(4) <= '0';
			trig_out_s_d(3) <= trig_out_s_d(4);
				trig_out_s_d(2) <= trig_out_s_d(3);
				trig_out_s_d(1) <= trig_out_s_d(2);
				trig_out_s_d(0) <= trig_out_s_d(1);
			if coincidence = '1' and coincidence_hold = '0' then		
				coincidence_hold <= '1';
				if zeros_in_last = '1' then
					trig_out_s_d <= "01110";
				else
					trig_out_s_d <= "00111";
				end if;
			elsif coincidence = '0' and coincidence_hold = '1' then
				coincidence_hold <= '0';
			end if;
			
			
		end if;
end process delay_output;



shift_coincidence_array : process (mclk, rst_b)
    begin  -- process load_sr_leading_edge
      if rst_b = '0' then
        coincidence_array <= (others => "00");
      elsif mclk'event and mclk = '1' then
		
        L1 : for I in 0 to NUMBER_OF_MODULES -1 loop
          coincidence_array(I)(0) <= leading_edge_module(I);
          coincidence_array(I)(1) <= coincidence_array(I)(0);
        end loop L1;
		  
      end if;
end process shift_coincidence_array;




  
end Behavioral;
