/*
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A 
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR 
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION 
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE 
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO 
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT| NOT LIMITED TO 
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 */

/*
 * Xilinx EDK 10.1.03 EDK_K_SP3.6
 *
 * This file is a sample test application
 *
 * This application is intended to test and/or illustrate some 
 * functionality of your system.  The contents of this file may
 * vary depending on the IP in your system and may use existing
 * IP driver functions.  These drivers will be generated in your
 * XPS project when you run the "Generate Libraries" menu item
 * in XPS.
 *
 * Your XPS project directory is at:
 *    C:\Speedway\Fall_08\Linux_PPC440\Lab1\
 */


// Located in: ppc440_0/include/xparameters.h
#include "xparameters.h"

#include "xcache_l.h"

#include "stdio.h"

#include "xutil.h"
#include "xuartns550_l.h"

//====================================================

int main (void) {


   XCache_EnableICache(0x80000001);
   XCache_EnableDCache(0x80000001);

   /* Initialize RS232 - Set baudrate and number of stop bits */
   XUartNs550_SetBaud(XPAR_RS232_BASEADDR, XPAR_XUARTNS550_CLOCK_HZ, 9600);
   XUartNs550_mSetLineControlReg(XPAR_RS232_BASEADDR, XUN_LCR_8_DATA_BITS);
   print("-- Entering main() --\r\n");

   /* 
    * MemoryTest routine will not be run for the memory at 
    * 0xffff0000 (xps_bram_if_cntlr_1)
    * because it is being used to hold a part of this application program
    */


   /* 
    * MemoryTest routine will not be run for the memory at 
    * 0x86000000 (FLASH_8Mx16)
    * because it is a read-only memory
    */


   /* Testing Memory (DDR2_SDRAM_16Mx32)*/
   {
      XStatus status;

      print("Starting MemoryTest for DDR2_SDRAM_16Mx32:\r\n");
      print("  Running 32-bit test...");
      status = XUtil_MemoryTest32((Xuint32*)XPAR_DDR2_SDRAM_16MX32_MEM_BASEADDR, 1024, 0xAAAA5555, XUT_ALLMEMTESTS);
      if (status == XST_SUCCESS) {
         print("PASSED!\r\n");
      }
      else {
         print("FAILED!\r\n");
      }
      print("  Running 16-bit test...");
      status = XUtil_MemoryTest16((Xuint16*)XPAR_DDR2_SDRAM_16MX32_MEM_BASEADDR, 2048, 0xAA55, XUT_ALLMEMTESTS);
      if (status == XST_SUCCESS) {
         print("PASSED!\r\n");
      }
      else {
         print("FAILED!\r\n");
      }
      print("  Running 8-bit test...");
      status = XUtil_MemoryTest8((Xuint8*)XPAR_DDR2_SDRAM_16MX32_MEM_BASEADDR, 4096, 0xA5, XUT_ALLMEMTESTS);
      if (status == XST_SUCCESS) {
         print("PASSED!\r\n");
      }
      else {
         print("FAILED!\r\n");
      }
   }

   print("-- Exiting main() --\r\n");
   XCache_DisableDCache();
   XCache_DisableICache();
   return 0;
}
