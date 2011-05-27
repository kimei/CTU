#define TESTAPP_GEN

/* $Id: wdttb_intr_header.h,v 1.1 2007/05/15 09:00:41 mta Exp $ */


#include "xbasic_types.h"
#include "xstatus.h"

XStatus WdtTbIntrExample(XIntc *IntcInstancePtr, \
                         XWdtTb *WdtTbInstancePtr, \
                         Xuint16 WdtTbDeviceId, \
                         Xuint16 WdtTbIntrId);

