--------------------------------------------------------------------------------
-- Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 10.1.03
--  \   \         Application : xaw2vhdl
--  /   /         Filename : PLL_ALL.vhd
-- /___/   /\     Timestamp : 01/25/2011 13:20:52
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-intstyle M:/MASTER/COMPET/Trigger/HW/HDL/CRU/COREgen/PLL_ALL.xaw -st PLL_ALL.vhd
--Design Name: PLL_ALL
--Device: xc5vlx50t-1ff1136
--
-- Module PLL_ALL
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- For block PLL_ADV_INST, Estimated PLL Jitter for CLKOUT0 = 0.160 ns
-- For block PLL_ADV_INST, Estimated PLL Jitter for CLKOUT1 = 0.160 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity PLL_ALL is
   port ( CLKIN1_IN   : in    std_logic; 
          RST_IN      : in    std_logic; 
          CLKOUT0_OUT : out   std_logic; 
          CLKOUT1_OUT : out   std_logic; 
          LOCKED_OUT  : out   std_logic);
end PLL_ALL;

architecture BEHAVIORAL of PLL_ALL is
   signal CLKFBOUT_CLKFBIN : std_logic;
   signal CLKIN1_IBUFG     : std_logic;
   signal CLKOUT0_BUF      : std_logic;
   signal CLKOUT1_BUF      : std_logic;
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
   
   PLL_ADV_INST : PLL_ADV
   generic map( BANDWIDTH => "OPTIMIZED",
            CLKIN1_PERIOD => 10.000,
            CLKIN2_PERIOD => 10.000,
            CLKOUT0_DIVIDE => 8,
            CLKOUT1_DIVIDE => 8,
            CLKOUT0_PHASE => 90.000,
            CLKOUT1_PHASE => 0.000,
            CLKOUT0_DUTY_CYCLE => 0.500,
            CLKOUT1_DUTY_CYCLE => 0.750,
            COMPENSATION => "SYSTEM_SYNCHRONOUS",
            DIVCLK_DIVIDE => 1,
            CLKFBOUT_MULT => 8,
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
                CLKOUT2=>open,
                CLKOUT3=>open,
                CLKOUT4=>open,
                CLKOUT5=>open,
                DO=>open,
                DRDY=>open,
                LOCKED=>LOCKED_OUT);
   
end BEHAVIORAL;


