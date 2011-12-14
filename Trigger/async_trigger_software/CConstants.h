#ifndef _CCONSTANTS_H
#define _CCONSTANTS_H


//#define ReadWriteBufferSize0 16384 
//#define ReadWriteBufferSize0 65536

//#define NUMBEROFHITSINPACKAGE  127
//#define MAXNUMBEROFHITSINPACKAGE 32*4 //#number of channels * number of events per package 
#define MAXNUMBEROFCHANNELSPERCARD 32 //including the empty ones!
#define NUMBEROFEVENTSINPACKAGE 20
#define MAXNUMBEROFHITSINPACKAGE MAXNUMBEROFCHANNELSPERCARD*NUMBEROFEVENTSINPACKAGE //#number of channels * number of events per package 
#define FOOTERSIZE   9

#define FIFO0_SIZE 200000


//#define FIFO1_SIZE 65536
#define FIFO1_SIZE 231072

#define MAXNUMHITSINSLOT 128


#define NUMBEROFSLOTS NUMBEROFEVENTSINPACKAGE 
//#define NUMBEROFPACKAGES 16384
#define NUMBEROFPACKAGES 16


#define MAXNUMBEROFEVENTSPERFILE  65024 //127 * 2**4

//#define NUMBEROFEVENTSPERFILE  16384
#define NUMBEROFEVENTSPERFILE  65024 //127 * 2**9
//#define NUMBEROFEVENTSPERFILE  520192 //127 * 2**12
//#define NUMBEROFEVENTSPERFILE  65024
//#define NUMBEROFEVENTSPERFILE  2040 //127 * 2**4
//#define NUMBEROFEVENTSPERFILE  2032 //127 * 2**4
//#define NUMBEROFEVENTSPERFILE  400
//#define NUMBEROFEVENTSPERFILE  40


//maximal message length to be sent out:
#define MAXMESSAGELENGTH   1998


#define NUMBEROFREADOUTCARDS 2

#define IPCARD0 "192.168.1.34"
#define IPCARD1 "192.168.1.35"
#define IPCARD2 "192.168.1.36"
#define PORT 16962




#endif