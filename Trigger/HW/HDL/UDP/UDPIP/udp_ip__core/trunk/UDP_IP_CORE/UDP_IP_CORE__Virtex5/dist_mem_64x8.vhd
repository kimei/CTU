--------------------------------------------------------------------------------
-- Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: K.39
--  \   \         Application: netgen
--  /   /         Filename: dist_mem_64x8.vhd
-- /___/   /\     Timestamp: Fri Apr 29 15:42:21 2011
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -w -sim -ofmt vhdl M:\MASTER\COMPET\Trigger\HW\HDL\UDP\UDPIP\udp_ip__core\trunk\UDP_IP_CORE\UDP_IP_CORE__Virtex5\tmp\_cg\dist_mem_64x8.ngc M:\MASTER\COMPET\Trigger\HW\HDL\UDP\UDPIP\udp_ip__core\trunk\UDP_IP_CORE\UDP_IP_CORE__Virtex5\tmp\_cg\dist_mem_64x8.vhd 
-- Device	: 5vfx30tff665-1
-- Input file	: M:/MASTER/COMPET/Trigger/HW/HDL/UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/tmp/_cg/dist_mem_64x8.ngc
-- Output file	: M:/MASTER/COMPET/Trigger/HW/HDL/UDP/UDPIP/udp_ip__core/trunk/UDP_IP_CORE/UDP_IP_CORE__Virtex5/tmp/_cg/dist_mem_64x8.vhd
-- # of Entities	: 1
-- Design Name	: dist_mem_64x8
-- Xilinx	: C:\Xilinx\10.1\ISE
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Development System Reference Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------


-- synthesis translate_off
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity dist_mem_64x8 is
  port (
    clk : in STD_LOGIC := 'X'; 
    a : in STD_LOGIC_VECTOR ( 5 downto 0 ); 
    qspo : out STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end dist_mem_64x8;

architecture STRUCTURE of dist_mem_64x8 is
  signal N0 : STD_LOGIC; 
  signal N1 : STD_LOGIC; 
  signal a_2 : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal qspo_3 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_rom_rom_inst_spo_int : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_qdpo : STD_LOGIC_VECTOR ( 0 downto 0 ); 
begin
  a_2(5) <= a(5);
  a_2(4) <= a(4);
  a_2(3) <= a(3);
  a_2(2) <= a(2);
  a_2(1) <= a(1);
  a_2(0) <= a(0);
  qspo(7) <= qspo_3(7);
  qspo(6) <= qspo_3(6);
  qspo(5) <= qspo_3(5);
  qspo(4) <= qspo_3(4);
  qspo(3) <= qspo_3(3);
  qspo(2) <= qspo_3(2);
  qspo(1) <= qspo_3(1);
  qspo(0) <= qspo_3(0);
  VCC_0 : VCC
    port map (
      P => N1
    );
  GND_1 : GND
    port map (
      G => N0
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom0000111 : LUT6
    generic map(
      INIT => X"0011003201110010"
    )
    port map (
      I0 => a_2(2),
      I1 => a_2(5),
      I2 => a_2(0),
      I3 => a_2(4),
      I4 => a_2(3),
      I5 => a_2(1),
      O => BU2_U0_gen_rom_rom_inst_spo_int(1)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000041 : LUT6
    generic map(
      INIT => X"0006180600061004"
    )
    port map (
      I0 => a_2(1),
      I1 => a_2(2),
      I2 => a_2(3),
      I3 => a_2(4),
      I4 => a_2(5),
      I5 => a_2(0),
      O => BU2_U0_gen_rom_rom_inst_spo_int(4)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000071 : LUT6
    generic map(
      INIT => X"2101220621002222"
    )
    port map (
      I0 => a_2(3),
      I1 => a_2(5),
      I2 => a_2(4),
      I3 => a_2(1),
      I4 => a_2(2),
      I5 => a_2(0),
      O => BU2_U0_gen_rom_rom_inst_spo_int(7)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000031 : LUT6
    generic map(
      INIT => X"090001030A0A0302"
    )
    port map (
      I0 => a_2(3),
      I1 => a_2(4),
      I2 => a_2(5),
      I3 => a_2(1),
      I4 => a_2(0),
      I5 => a_2(2),
      O => BU2_U0_gen_rom_rom_inst_spo_int(3)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000021 : LUT6
    generic map(
      INIT => X"0010060200180614"
    )
    port map (
      I0 => a_2(1),
      I1 => a_2(2),
      I2 => a_2(4),
      I3 => a_2(5),
      I4 => a_2(3),
      I5 => a_2(0),
      O => BU2_U0_gen_rom_rom_inst_spo_int(2)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000011 : LUT6
    generic map(
      INIT => X"0061014802420340"
    )
    port map (
      I0 => a_2(1),
      I1 => a_2(3),
      I2 => a_2(4),
      I3 => a_2(5),
      I4 => a_2(0),
      I5 => a_2(2),
      O => BU2_U0_gen_rom_rom_inst_spo_int(0)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000051 : LUT6
    generic map(
      INIT => X"090A000B0103010E"
    )
    port map (
      I0 => a_2(3),
      I1 => a_2(4),
      I2 => a_2(5),
      I3 => a_2(2),
      I4 => a_2(1),
      I5 => a_2(0),
      O => BU2_U0_gen_rom_rom_inst_spo_int(5)
    );
  BU2_U0_gen_rom_rom_inst_Mrom_spo_int_rom000061 : LUT6
    generic map(
      INIT => X"0054034100240C04"
    )
    port map (
      I0 => a_2(0),
      I1 => a_2(2),
      I2 => a_2(3),
      I3 => a_2(5),
      I4 => a_2(4),
      I5 => a_2(1),
      O => BU2_U0_gen_rom_rom_inst_spo_int(6)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_7 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(7),
      Q => qspo_3(7)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_6 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(6),
      Q => qspo_3(6)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_5 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(5),
      Q => qspo_3(5)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_4 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(4),
      Q => qspo_3(4)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_3 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(3),
      Q => qspo_3(3)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_2 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(2),
      Q => qspo_3(2)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_1 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(1),
      Q => qspo_3(1)
    );
  BU2_U0_gen_rom_rom_inst_qspo_int_0 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_rom_rom_inst_spo_int(0),
      Q => qspo_3(0)
    );
  BU2_XST_GND : GND
    port map (
      G => BU2_qdpo(0)
    );

end STRUCTURE;

-- synthesis translate_on
