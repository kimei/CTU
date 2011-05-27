#include<stdio.h>
#include<stdlib.h>



typedef unsigned short u16;
typedef unsigned long u32;



u16 ip_sum_calc(u16 len_ip_header, u16 buff[])
{
u16 word16;
u32 sum=0;
u16 i;
    
	// make 16 bit words out of every two adjacent 8 bit words in the packet
	// and add them up
	for (i=0;i<len_ip_header;i=i+2){
		word16 =((buff[i]<<8)&0xFF00)+(buff[i+1]&0xFF);
		sum = sum + (u32) word16;	
	}
	
	// take only 16 bits out of the 32 bit sum and add up the carries
	while (sum>>16)
	  sum = (sum & 0xFFFF)+(sum >> 16);

	// one's complement the result
	sum = ~sum;
	
return ((u16) sum);
}




int main(){

  u16 length = 10;
  u16 header[10] = {0x4500,0x2400,0x0000,0x6000,0x6011,0xA7c0,0xA801,0x01C0,0xA801,0x0402  };
  
  /*             {01000101, */
/* 		  00000000, */
/* 		  00100100, */
/* 		  00000000, */
/* 		  00000000, */
/* 		  00000000, */
/* 		  01000000, */
/* 		  00000000, */
/* 		  01000000, */
/* 		  00010001, */
/* 		  10110111, */
/* 		  11000000, */
/* 		  
		  10101000, */
/* 		  00000001, */
/* 		  00000001, */
/* 		  11000000, */
/* 		  10101000, */
/* 		  00000001, */
/* 		  00000100, */
/* 		  00000010}; */
  u16 sum;
  sum = ip_sum_calc(length, header);

   printf("%x" "\n", sum);
  return 0;
}

