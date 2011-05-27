#define TESTAPP_GEN

/*$Id: xwdttb_intr_example.c,v 1.1.8.1 2008/02/18 12:44:42 svemula Exp $*/
/******************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2006 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xwdttb_intr_example.c
*
* This file contains a design example using the TimeBase Watchdog Timer Device
* (WdtTb) driver and hardware device using interrupt mode.
*
* This example works with a PPC processor. Refer the examples of Interrupt
* controller (XIntc) for an example of using interrupts with the MicroBlaze
* processor.
*
* @note
*
* This example assumes that the reset output of the WdtTb device is not
* connected to the reset of the processor.
*
* <pre>
*
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- ---------------------------------------------------------
* 1.00b hvm  05/10/06 First release
* 1.00b sv   05/30/06 Updated to support interrupt examples in Test App
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"
#include "xwdttb.h"
#include "xintc.h"

#ifdef __MICROBLAZE__
#include "mb_interface.h"
#else
#include "xexception_l.h"
#endif


/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are only defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#ifndef TESTAPP_GEN
#define WDTTB_DEVICE_ID             XPAR_WDTTB_0_DEVICE_ID
#define INTC_DEVICE_ID              XPAR_INTC_0_DEVICE_ID
#define WDTTB_IRPT_INTR             XPAR_INTC_0_WDTTB_0_VEC_ID
#endif


/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

XStatus WdtTbIntrExample(XIntc *IntcInstancePtr,
                         XWdtTb *WdtTbInstancePtr,
                         Xuint16 WdtTbDeviceId,
                         Xuint16 WdtTbIntrId);

static void WdtTbIntrHandler(void *CallBackRef);

static XStatus WdtTbSetupIntrSystem(XIntc *IntcInstancePtr,
                                    XWdtTb *WdtTbInstancePtr,
                                    Xuint16 WdtTbIntrId);

static void WdtTbDisableIntrSystem(XIntc *IntcInstancePtr,
                                   Xuint16 WdtTbIntrId);



/************************** Variable Definitions *****************************/

#ifndef TESTAPP_GEN
XWdtTb WdtTbInstance;            /* Instance of Time Base WatchDog Timer */
XIntc IntcInstance;              /* Instance of the Interrupt Controller */
#endif

/*****************************************************************************/
/**
* Main function to call the WdtTb interrupt example.
*
* @param    None.
*
* @return   XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note     None.
*
******************************************************************************/
#ifndef TESTAPP_GEN
int main(void)
{
    XStatus Status;

    /*
     * Call the WdtTb interrupt example, specify the parameters generated in
     * xparameters.h
     */
    Status = WdtTbIntrExample(&IntcInstance,
                              &WdtTbInstance,
                              WDTTB_DEVICE_ID,
                              WDTTB_IRPT_INTR);
    if (Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}
#endif


/*****************************************************************************/
/**
*
* This function tests the functioning of the TimeBase WatchDog Timer module
* in the Interrupt mode.
*
* After one expiration of the timeout interval, an interrupt is generated and
* the WDT state bit is set to one in the status register. If the state bit is
* not cleared (by writing a 1 to the state bit) before the next expiration of
* the timeout interval, a WDT reset is generated.
* A WDT reset sets the WDT reset status bit in the status register so that
* the application code can determine if the last system reset was a WDT reset
*
* This function assumes that the reset output of the WdtTb device is not
* connected to the reset of the processor. The function allows the watchdog
* timer to timeout such that a reset will occur if it is connected.
*
* @param    IntcInstancePtr is a pointer to the instance of the INTC component.
* @param    WdtTbInstancePtr is a pointer to the instance of WdtTb component.
* @param    WdtTbDeviceId is the Device ID of the WdtTb Device and is typically
*           XPAR_<TIMEBASE_WDT_instance>_DEVICE_ID value from xparameters.h.
* @param    WdtTbIntrId is the Interrupt Id of the WatchDog and is typically
*           XPAR_<INTC_instance>_<TIMEBASE_WDT_instance>_WDT_INTERRUPT_INTR
*           value from xparameters.h.
*
* @return   XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note     None.
*
******************************************************************************/
XStatus WdtTbIntrExample(XIntc *IntcInstancePtr,
                         XWdtTb *WdtTbInstancePtr,
                         Xuint16 WdtTbDeviceId,
                         Xuint16 WdtTbIntrId)
{
    XStatus Status;
    Xuint32 StartTime;
    Xuint32 Timebase;
    Xuint32 ExpiredTimeDelta;


    /*
     * Initialize the WdtTb driver
     */
    Status = XWdtTb_Initialize(WdtTbInstancePtr, WdtTbDeviceId);
    if (Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }


    /*
     * Perform a self-test to ensure that the hardware was built correctly
     */
    Status = XWdtTb_SelfTest(WdtTbInstancePtr);
    if (Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }

    /*
     * Start the WdtTb device
     */
    XWdtTb_Start(WdtTbInstancePtr);

    /*
     * Determine how long it takes for the watchdog timer to expire
     * for later processing, use the TimeBase register to measure it.
     * If the reset output of the device is connected to the processor,
     * the following code will cause a reset.
     */
    while (1)
    {
        if (XWdtTb_IsWdtExpired(WdtTbInstancePtr))
        {
            ExpiredTimeDelta = XWdtTb_GetTbValue(WdtTbInstancePtr);
            break;
        }
    }

    /*
     * Get the current time base for measurement in the next test
     */
    StartTime = XWdtTb_GetTbValue(WdtTbInstancePtr);

    /*
     * Stop the timer to start the test for interrupt mode
     */
    XWdtTb_Stop(WdtTbInstancePtr);

    /*
     * Connect the WdtTb to the interrupt subsystem so that interrupts can occur
     */
    Status = WdtTbSetupIntrSystem(IntcInstancePtr,
                                  WdtTbInstancePtr,
                                  WdtTbIntrId);
    if (Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }

    /*
     * Start the WdtTb device
     */
    XWdtTb_Start(WdtTbInstancePtr);

    /*
     * Verify that the watchdog timer does not timeout when restarted
     * all the time, wait more than the amount of time it took for it
     * to expire in the previous test
     */
    while (1)
    {
        /*
         * If more time has gone past than it took for it to expire
         * when not restarted in the previous test, then stop as the
         * restarting worked
         */
        Timebase = XWdtTb_GetTbValue(WdtTbInstancePtr);
        if (Timebase > (StartTime + ExpiredTimeDelta))
        {
            break;
        }

        /*
         * If the watchdog timer expired, then the test failed
         */
        if (XWdtTb_IsWdtExpired(WdtTbInstancePtr))
        {
            /*
             * Disable and disconnect the interrupt system
             */
            WdtTbDisableIntrSystem(IntcInstancePtr, WdtTbIntrId);
            return XST_FAILURE;
        }
    }

    /*
     * Disable and disconnect the interrupt system
     */
    WdtTbDisableIntrSystem(IntcInstancePtr, WdtTbIntrId);

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function setups the interrupt system such that interrupts can occur
* for the WdtTb. This function is application specific since the actual
* system may or may not have an interrupt controller. The WdtTb device could be
* directly connected to a processor without an interrupt controller. The
* user should modify this function to fit the application.
*
* @param    IntcInstancePtr is a pointer to the instance of the INTC component.
* @param    WdtTbInstancePtr is a pointer to the instance of WdtTb component.
* @param    WdtTbIntrId is the Interrupt Id of the WatchDog and is typically
*           XPAR_<INTC_instance>_<TIMEBASE_WDT_instance>_WDT_INTERRUPT_INTR
*           value from xparameters.h.
*
* @return   XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note     None.
*
******************************************************************************/
static XStatus WdtTbSetupIntrSystem(XIntc *IntcInstancePtr,
                                    XWdtTb *WdtTbInstancePtr,
                                    Xuint16 WdtTbIntrId)
{
    XStatus Status;

#ifndef TESTAPP_GEN
    /*
     * Initialize the interrupt controller driver so that
     * it's ready to use. Specify the device ID that is generated in
     * xparameters.h
     */
    Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
    if(Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }
#endif

    /*
     * Connect a device driver handler that will be called when an interrupt
     * for the device occurs, the device driver handler performs the specific
     * interrupt processing for the device
     */
    Status = XIntc_Connect(IntcInstancePtr, WdtTbIntrId,
                           (XInterruptHandler)WdtTbIntrHandler,
                           (void *)WdtTbInstancePtr);
    if(Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }

#ifndef TESTAPP_GEN
    /*
     * Start the interrupt controller such that interrupts are enabled for
     * all devices that cause interrupts.
     */
    Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
    if(Status != XST_SUCCESS)
    {
        return XST_FAILURE;
    }
#endif

    /*
     * Enable the WDT interrupt of the WdtTb Device
     */
    XIntc_Enable(IntcInstancePtr, WdtTbIntrId);

#ifndef TESTAPP_GEN

    /*
     * Initialize the PPC405 exception table
     */
    XExc_Init();

    /*
     * Register the interrupt controller handler with the exception table
     */
    XExc_RegisterHandler(XEXC_ID_NON_CRITICAL_INT,
                         (XExceptionHandler)XIntc_InterruptHandler,
                         IntcInstancePtr);

    /*
     * Enable non-critical exceptions
     */
    XExc_mEnableExceptions(XEXC_NON_CRITICAL);

#endif /* TESTAPP_GEN */

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function is the Interrupt handler for the WDT Interrupt of the
* WdtTb device. It is called on the expiration of the WDT period and is called
* from an interrupt context.
*
* This function provides an example of how to handle WDT interrupt of the
* WdtTb device.
*
* @param    CallBackRef is a pointer to the callback function.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
static void WdtTbIntrHandler(void *CallBackRef)
{
    XWdtTb *WdtTbInstancePtr = (XWdtTb *)CallBackRef;

    /*
     * Restart the watchdog timer as a normal application would
     */
    XWdtTb_RestartWdt(WdtTbInstancePtr);
}


/*****************************************************************************/
/**
*
* This function disables the interrupts that occur for the WdtTb.
*
* @param    IntcInstancePtr is the pointer to the instance of INTC component.
* @param    WdtTbIntrId is the Interrupt Id and is typically
*           XPAR_<INTC_instance>_<TIMEBASE_WDT_instance>_WDT_INTERRUPT_INTR
*           value from xparameters.h.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
static void WdtTbDisableIntrSystem(XIntc *IntcInstancePtr,
                                   Xuint16 WdtTbIntrId)
{

    /*
     * Disconnect and disable the interrupt for the WdtTb
     */
    XIntc_Disconnect(IntcInstancePtr, WdtTbIntrId);

}

