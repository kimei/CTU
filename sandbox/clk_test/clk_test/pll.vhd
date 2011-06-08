--------------------------------------------------------------------------------
-- Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 10.1.03
--  \   \         Application : xaw2vhdl
--  /   /         Filename : pll.vhd
-- /___/   /\     Timestamp : 04/29/2011 16:40:53
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-intstyle M:/MASTER/COMPET/Trigger/HW/HDL/UDP/CoreGEN/pll.xaw -st pll.vhd
--Design Name: pll
--Device: xc5vfx30t-1ff665
--
-- Module pll
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- For block PLL_ADV_INST, Estimated PLL Jitter for CLKOUT0 = 0.154 ns
-- For block PLL_ADV_INST, Estimated PLL Jitter for CLKOUT1 = 0.135 ns
-- For block PLL_ADV_INST, Estimated PLL Jitter for CLKOUT2 = 0.148 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity pll is
   port ( CLKIN1_IN   : in    std_logic; 
          RST_IN      : in    std_logic; 
          CLKOUT0_OUT : out   std_logic; 
          CLKOUT1_OUT : out   std_logic; 
          CLKOUT2_OUT : out   std_logic; 
          LOCKED_OUT  : out   std_logic);
end pll;

architecture BEHAVIORAL of pll is
   signal CLKFBOUT_CLKFBIN : std_logic;
   signal CLKIN1_IBUFG     : std_logic;
   signal CLKOUT0_BUF      : std_logic;
   signal CLKOUT1_BUF      : std_logic;
   signal CLKOUT2_BUF      : std_logic;
   signal GND_BIT          : std_logic;
   signal GND_BUS_5        : std_logic_vector (4 downto 0);
   signal GND_BUS_16       : std_logic_vector (15 downto 0);
   signal VCC_BIT          : std_logic;
begin
   GND_BIT <= '0';
   GND_BUS_5(4 downto 0) <= "00000";
   GND_BUS_16(15 downto 0) <= "0000000000000000";
   VCC_BIT <= '1';
   CLKIN1_IBUFG_INST : IBUFG
      port map (I=>CLKIN1_IN,
                O=>CLKIN1_IBUFG);
   
   CLKOUT0_BUFG_INST : BUFG
      port map (I=>CLKOUT0_BUF,
                O=>CLKOUT0_OUT);
   
   CLKOUT1_BUFG_INST : BUFG
      port map (I=>CLKOUT1_BUF,
                O=>CLKOUT1_OUT);
   
   CLKOUT2_BUFG_INST : BUFG
      port map (I=>CLKOUT2_BUF,
                O=>CLKOUT2_OUT);
   
   PLL_ADV_INST : PLL_ADV
   generic map( BANDWIDTH => "OPTIMIZED",
            CLKIN1_PERIOD => 10.000,
            CLKIN2_PERIOD => 10.000,
            CLKOUT0_DIVIDE => 10,
            CLKOUT1_DIVIDE => 5,
            CLKOUT2_DIVIDE => 8,
            CLKOUT0_PHASE => 0.000,
            CLKOUT1_PHASE => 0.000,
            CLKOUT2_PHASE => 0.000,
            CLKOUT0_DUTY_CYCLE => 0.500,
            CLKOUT1_DUTY_CYCLE => 0.500,
            CLKOUT2_DUTY_CYCLE => 0.500,
            COMPENSATION => "SYSTEM_SYNCHRONOUS",
            DIVCLK_DIVIDE => 1,
            CLKFBOUT_MULT => 10,
            CLKFBOUT_PHASE => 0.0,
            REF_JITTER => 0.000000)
      port map (CLKFBIN=>CLKFBOUT_CLKFBIN,
                CLKINSEL=>VCC_BIT,
                CLKIN1=>CLKIN1_IBUFG,
                CLKIN2=>GND_BIT,
                DADDR(4 downto 0)=>GND_BUS_5(4 downto 0),
                DCLK=>GND_BIT,
                DEN=>GND_BIT,
                DI(15 downto 0)=>GND_BUS_16(15 downto 0),
                DWE=>GND_BIT,
                REL=>GND_BIT,
                RST=>RST_IN,
                CLKFBDCM=>open,
                CLKFBOUT=>CLKFBOUT_CLKFBIN,
                CLKOUTDCM0=>open,
                CLKOUTDCM1=>open,
                CLKOUTDCM2=>open,
                CLKOUTDCM3=>open,
                CLKOUTDCM4=>open,
                CLKOUTDCM5=>open,
                CLKOUT0=>CLKOUT0_BUF,
                CLKOUT1=>CLKOUT1_BUF,
                CLKOUT2=>CLKOUT2_BUF,
                CLKOUT3=>open,
                CLKOUT4=>open,
                CLKOUT5=>open,
                DO=>open,
                DRDY=>open,
                LOCKED=>LOCKED_OUT);
   
end BEHAVIORAL;

