                                      

                    Core name: Xilinx Virtex-5 Embedded Tri-Mode 
                               Ethernet MAC Wrapper
                    Version: 1.5
                    Release Date: September 19, 2008


================================================================================

This document contains the following sections: 

1. Introduction
2. New Features
3. Resolved Issues
4. Known Issues 
5. Technical Support
6. Core Release History
 
================================================================================
 
1. INTRODUCTION

For the most recent updates to the IP installation instructions for this core,
please go to:

   http://www.xilinx.com/ipcenter/coregen/ip_update_install_instructions.htm

 
For system requirements:

   http://www.xilinx.com/ipcenter/coregen/ip_update_system_requirements.htm 



This file contains release notes for the Xilinx LogiCORE IP Virtex-5 Embedded
Tri-Mode Ethernet MAC Wrapper  v1.5 solution. 
For the latest core updates, see the product page at:
 
  <<<www.xilinx.com/products/ipcenter/V5_Embedded_TEMAC_Wrapper.htm>>>

2. NEW FEATURES  
 
   - Support added for Virtex-5 TXT devices

 
3. RESOLVED ISSUES 

   - GUI settings not acted on correctly.
   - See AR #30816
      - When the user selects one of:
         - EMAC0 RX In-band FCS enable, 
         - EMAC0 RX Half-Duplex enable,
         - EMAC1 TX In-band FCS enable,
         - EMAC1 TX Half-Duplex enable,
         - EMAC1 RX Disable Length,
         - EMAC1 TX VLAN enable. 
      - the XCO file and/or wrapper HDL code may not be updated correctly.
 
4. KNOWN ISSUES 
   
   The most recent information, including known issues, workarounds, and
     resolutions for this version is provided in the IP Release Notes Guide located at 

    http://www.xilinx.com/support/documentation/user_guides/xtp025.pdf

5. TECHNICAL SUPPORT 

   To obtain technical support, create a WebCase at www.xilinx.com/support.
   Questions are routed to a team with expertise using this product.  
     
   Xilinx provides technical support for use of this product when used
   according to the guidelines described in the core documentation, and
   cannot guarantee timing, functionality, or support of this product for
   designs that do not follow specified guidelines.


6. CORE RELEASE HISTORY 

Date        By            Version      Description
================================================================================
10/23/2006  Xilinx, Inc.  1.1      First Release
02/15/2007  Xilinx, Inc.  1.2      Release for ISE 9.1i
08/08/2007  Xilinx, Inc.  1.3      Release for ISE 9.2i
03/24/2008  Xilinx, Inc.  1.4      Release for ISE 10.1i
09/19/2008  Xilinx, Inc.  1.5      Release for Virtex-5 TXT
================================================================================

(c) 2002-2008 Xilinx, Inc. All Rights Reserved. 


XILINX, the Xilinx logo, and other designated brands included herein are
trademarks of Xilinx, Inc. All other trademarks are the property of their
respective owners.

Xilinx is disclosing this user guide, manual, release note, and/or
specification (the Documentation) to you solely for use in the development
of designs to operate with Xilinx hardware devices. You may not reproduce, 
distribute, republish, download, display, post, or transmit the Documentation
in any form or by any means including, but not limited to, electronic,
mechanical, photocopying, recording, or otherwise, without the prior written 
consent of Xilinx. Xilinx expressly disclaims any liability arising out of
your use of the Documentation.  Xilinx reserves the right, at its sole 
discretion, to change the Documentation without notice at any time. Xilinx
assumes no obligation to correct any errors contained in the Documentation, or
to advise you of any corrections or updates. Xilinx expressly disclaims any
liability in connection with technical support or assistance that may be
provided to you in connection with the information. THE DOCUMENTATION IS
DISCLOSED TO YOU AS-IS WITH NO WARRANTY OF ANY KIND. XILINX MAKES NO 
OTHER WARRANTIES, WHETHER EXPRESS, IMPLIED, OR STATUTORY, REGARDING THE
DOCUMENTATION, INCLUDING ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE, OR NONINFRINGEMENT OF THIRD-PARTY RIGHTS. IN NO EVENT 
WILL XILINX BE LIABLE FOR ANY CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, OR
INCIDENTAL DAMAGES, INCLUDING ANY LOSS OF DATA OR LOST PROFITS, ARISING FROM
YOUR USE OF THE DOCUMENTATION.

