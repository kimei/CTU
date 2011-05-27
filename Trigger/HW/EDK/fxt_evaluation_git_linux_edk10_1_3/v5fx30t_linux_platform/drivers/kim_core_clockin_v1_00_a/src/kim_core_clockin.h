//////////////////////////////////////////////////////////////////////////////
// Filename:          M:\MASTER\COMPET\Trigger\HW\EDK\fxt_evaluation_git_linux_edk10_1_3\v5fx30t_linux_platform/drivers/kim_core_clockin_v1_00_a/src/kim_core_clockin.h
// Version:           1.00.a
// Description:       kim_core_clockin Driver Header File
// Date:              Fri Apr 08 12:07:27 2011 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////

#ifndef KIM_CORE_CLOCKIN_H
#define KIM_CORE_CLOCKIN_H

/***************************** Include Files *******************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xio.h"

/************************** Constant Definitions ***************************/


/**
 * User Logic Slave Space Offsets
 * -- SLV_REG0 : user logic slave module register 0
 */
#define KIM_CORE_CLOCKIN_USER_SLV_SPACE_OFFSET (0x00000000)
#define KIM_CORE_CLOCKIN_SLV_REG0_OFFSET (KIM_CORE_CLOCKIN_USER_SLV_SPACE_OFFSET + 0x00000000)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a KIM_CORE_CLOCKIN register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the KIM_CORE_CLOCKIN device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void KIM_CORE_CLOCKIN_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define KIM_CORE_CLOCKIN_mWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a KIM_CORE_CLOCKIN register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the KIM_CORE_CLOCKIN device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 KIM_CORE_CLOCKIN_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define KIM_CORE_CLOCKIN_mReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read 32 bit value to/from KIM_CORE_CLOCKIN user logic slave registers.
 *
 * @param   BaseAddress is the base address of the KIM_CORE_CLOCKIN device.
 * @param   RegOffset is the offset from the slave register to write to or read from.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	void KIM_CORE_CLOCKIN_mWriteSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Value)
 * 	Xuint32 KIM_CORE_CLOCKIN_mReadSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define KIM_CORE_CLOCKIN_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	XIo_Out32((BaseAddress) + (KIM_CORE_CLOCKIN_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))

#define KIM_CORE_CLOCKIN_mReadSlaveReg0(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (KIM_CORE_CLOCKIN_SLV_REG0_OFFSET) + (RegOffset))

/************************** Function Prototypes ****************************/


/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the KIM_CORE_CLOCKIN instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus KIM_CORE_CLOCKIN_SelfTest(void * baseaddr_p);

#endif // KIM_CORE_CLOCKIN_H
