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
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO 
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

#include "xintc.h"
#include "xexception_l.h"
#include "intc_header.h"
#include "xuartns550_l.h"
#include "xbasic_types.h"
#include "xgpio.h"
#include "gpio_header.h"
#include "gpio_intr_header.h"
#include "xlltemac.h"
#include "xlltemac_example.h"
#include "lltemac_header.h"
#include "lltemac_intr_header.h"
#include "xlldma.h"
#include "xtmrctr.h"
#include "tmrctr_header.h"
#include "tmrctr_intr_header.h"
#include "xwdttb.h"
#include "wdttb_header.h"
#include "wdttb_intr_header.h"

#define GPIO_CHANNEL1 1

//====================================================

int main (void) {


   static XIntc intc;

   XCache_EnableICache(0x80000001);
   XCache_EnableDCache(0x80000001);

   /* Initialize RS232 - Set baudrate and number of stop bits */
   XUartNs550_SetBaud(XPAR_RS232_BASEADDR, XPAR_XUARTNS550_CLOCK_HZ, 9600);
   XUartNs550_mSetLineControlReg(XPAR_RS232_BASEADDR, XUN_LCR_8_DATA_BITS);
   static XGpio DIP_Switches_8Bit_Gpio;
   static XGpio Push_Buttons_3Bit_Gpio;
   static XLlTemac Hard_Ethernet_MAC_LlTemac;
   static XLlDma  Hard_Ethernet_MAC_LlDma;


   static XTmrCtr xps_timer_1_Timer;
   static XWdtTb xps_timebase_wdt_1_Wdttb;
   print("-- Entering main() --\r\n");


   {
      XStatus status;
      
      print("\r\n Runnning IntcSelfTestExample() for xps_intc_0...\r\n");
      
      status = IntcSelfTestExample(XPAR_XPS_INTC_0_DEVICE_ID);
      
      if (status == 0) {
         print("IntcSelfTestExample PASSED\r\n");
      }
      else {
         print("IntcSelfTestExample FAILED\r\n");
      }
   } 
	
   {
       XStatus Status;

       Status = IntcInterruptSetup(&intc, XPAR_XPS_INTC_0_DEVICE_ID);
       if (Status == 0) {
          print("Intc Interrupt Setup PASSED\r\n");
       } 
       else {
         print("Intc Interrupt Setup FAILED\r\n");
      } 
   }

   /*
    * Peripheral SelfTest will not be run for RS232
    * because it has been selected as the STDOUT device
    */



   {
      Xuint32 status;
      
      print("\r\nRunning GpioOutputExample() for LEDs_8Bit...\r\n");

      status = GpioOutputExample(XPAR_LEDS_8BIT_DEVICE_ID,8);
      
      if (status == 0) {
         print("GpioOutputExample PASSED.\r\n");
      }
      else {
         print("GpioOutputExample FAILED.\r\n");
      }
   }


   {
      Xuint32 status;
      
      print("\r\nRunning GpioInputExample() for DIP_Switches_8Bit...\r\n");

      Xuint32 DataRead;
      
      status = GpioInputExample(XPAR_DIP_SWITCHES_8BIT_DEVICE_ID, &DataRead);
      
      if (status == 0) {
         xil_printf("GpioInputExample PASSED. Read data:0x%X\r\n", DataRead);
      }
      else {
         print("GpioInputExample FAILED.\r\n");
      }
   }
   {
      
      XStatus Status;
        
      Xuint32 DataRead;
      
      print(" Press button to Generate Interrupt\r\n");
      
      Status = GpioIntrExample(&intc, &DIP_Switches_8Bit_Gpio, \
                               XPAR_DIP_SWITCHES_8BIT_DEVICE_ID, \
                               XPAR_XPS_INTC_0_DIP_SWITCHES_8BIT_IP2INTC_IRPT_INTR, \
                               GPIO_CHANNEL1, &DataRead);
	
      if (Status == 0 ){
             if(DataRead == 0)
                print("No button pressed. \r\n");
             else
                print("Gpio Interrupt Test PASSED. \r\n"); 
      } 
      else {
         print("Gpio Interrupt Test FAILED.\r\n");
      }
	
   }


   {
      Xuint32 status;
      
      print("\r\nRunning GpioInputExample() for Push_Buttons_3Bit...\r\n");

      Xuint32 DataRead;
      
      status = GpioInputExample(XPAR_PUSH_BUTTONS_3BIT_DEVICE_ID, &DataRead);
      
      if (status == 0) {
         xil_printf("GpioInputExample PASSED. Read data:0x%X\r\n", DataRead);
      }
      else {
         print("GpioInputExample FAILED.\r\n");
      }
   }
   {
      
      XStatus Status;
        
      Xuint32 DataRead;
      
      print(" Press button to Generate Interrupt\r\n");
      
      Status = GpioIntrExample(&intc, &Push_Buttons_3Bit_Gpio, \
                               XPAR_PUSH_BUTTONS_3BIT_DEVICE_ID, \
                               XPAR_XPS_INTC_0_PUSH_BUTTONS_3BIT_IP2INTC_IRPT_INTR, \
                               GPIO_CHANNEL1, &DataRead);
	
      if (Status == 0 ){
             if(DataRead == 0)
                print("No button pressed. \r\n");
             else
                print("Gpio Interrupt Test PASSED. \r\n"); 
      } 
      else {
         print("Gpio Interrupt Test FAILED.\r\n");
      }
	
   }

   /* TemacPolledExample does not support SGDMA      
   {
      XStatus status;

      print("\r\n Runnning TemacPolledExample() for Hard_Ethernet_MAC...\r\n");

      status = TemacPolledExample( XPAR_HARD_ETHERNET_MAC_CHAN_0_DEVICE_ID,
                                   );

      if (status == 0) {
         print("TemacPolledExample PASSED\r\n");
      }
      else {
         print("TemacPolledExample FAILED\r\n");
      }

   }
   */

   {
      XStatus Status;

      print("\r\nRunning TemacSgDmaIntrExample() for Hard_Ethernet_MAC...\r\n");

      Status = TemacSgDmaIntrExample(&intc, &Hard_Ethernet_MAC_LlTemac,
                     &Hard_Ethernet_MAC_LlDma,
                     XPAR_HARD_ETHERNET_MAC_CHAN_0_DEVICE_ID,
                     XPAR_XPS_INTC_0_HARD_ETHERNET_MAC_TEMACINTC0_IRPT_INTR,
                     XPAR_LLTEMAC_0_LLINK_CONNECTED_DMARX_INTR,
                     XPAR_LLTEMAC_0_LLINK_CONNECTED_DMATX_INTR);

      if (Status == 0) {
         print("Temac Interrupt Test PASSED.\r\n");
      } 
      else {
         print("Temac Interrupt Test FAILED.\r\n");
      }

   }


   {
      XStatus status;
      
      print("\r\n Running TmrCtrSelfTestExample() for xps_timer_1...\r\n");
      
      status = TmrCtrSelfTestExample(XPAR_XPS_TIMER_1_DEVICE_ID, 0x0);
      
      if (status == 0) {
         print("TmrCtrSelfTestExample PASSED\r\n");
      }
      else {
         print("TmrCtrSelfTestExample FAILED\r\n");
      }
   }
   {
      XStatus Status;

      print("\r\n Running Interrupt Test  for xps_timer_1...\r\n");
      
      Status = TmrCtrIntrExample(&intc, &xps_timer_1_Timer, \
                                 XPAR_XPS_TIMER_1_DEVICE_ID, \
                                 XPAR_XPS_INTC_0_XPS_TIMER_1_INTERRUPT_INTR, 0);
	
      if (Status == 0) {
         print("Timer Interrupt Test PASSED\r\n");
      } 
      else {
         print("Timer Interrupt Test FAILED\r\n");
      }

   }


   {
      XStatus status;
      
      print("\r\n Runnning WdtTbSelfTestExample() for xps_timebase_wdt_1...\r\n");
      
      status = WdtTbSelfTestExample(XPAR_XPS_TIMEBASE_WDT_1_DEVICE_ID);
      
      if (status == 0) {
         print("WdtTbSelfTestExample PASSED\r\n");
      }
      else {
         print("WdtTbSelfTestExample FAILED\r\n");
      }
   }
        
   {
      XStatus Status;
      
      print("\r\n Running Interrupt Test  for xps_timebase_wdt_1...\r\n");
      
      Status = WdtTbIntrExample(&intc, &xps_timebase_wdt_1_Wdttb, \
                                 XPAR_XPS_TIMEBASE_WDT_1_DEVICE_ID, \
                                 XPAR_XPS_INTC_0_XPS_TIMEBASE_WDT_1_WDT_INTERRUPT_INTR);
	
      if (Status == 0) {
         print("Wdttb Interrupt Test PASSED\r\n");
      } 
      else {
         print("Wdttb Interrupt Test FAILED\r\n");
      }


   }

   print("-- Exiting main() --\r\n");
   XCache_DisableDCache();
   XCache_DisableICache();
   return 0;
}

