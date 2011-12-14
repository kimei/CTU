#include <boost/asio.hpp>
#include <iostream>
#include <sys/prctl.h>

#include "CReceiver.h"



void  CReceiver::ReceiveData()
{
  //the name of the thread:
  char thr_name[] = "COMPET_ATRIGGER\0";
  // Set the name
  prctl(PR_SET_NAME, thr_name);

  // reset package counter
  int TotalPackageCounter =0;
  
  //
  bool FirstSynchroniser = true;

  //Constructor for the adresses
  boost::asio::ip::address ReceiverAdresses[NUMBEROFREADOUTCARDS];

  // Strings to hold the ipadresses
  std::string  ipaddresses[NUMBEROFREADOUTCARDS];
  ipaddresses[0] = IPCARD0; 
  ipaddresses[1] = IPCARD1;
  //ipaddresses[2] = IPCARD2;

  //Set the ip adresses correctly (v4)
  for (int card=0;card<NUMBEROFREADOUTCARDS;card++)
    {
      ReceiverAdresses[card] = boost::asio::ip::address_v4::from_string(ipaddresses[card]);
    }

   

  //set up the UDP server:
  try
    {
      // Constructor for general io service
      boost::asio::io_service io_service;
      boost::asio::ip::udp::socket socket(io_service, boost::asio::ip::udp::endpoint(boost::asio::ip::udp::v4(), m_portno));
      int lastpackage_counter[NUMBEROFREADOUTCARDS];
      int package_counter[NUMBEROFREADOUTCARDS];
      int synchroniserPackage = 0;

      int package_counterMSB[NUMBEROFREADOUTCARDS];
      for (int card=0;card<NUMBEROFREADOUTCARDS;card++)
	{
	  lastpackage_counter[card]=0;
	  package_counter[card]=0;
	  package_counterMSB[card] =0 ;
	}
     
      bool SystemSynchronised = false; // first time we need to synchronise until all 
      bool CardSynchronised[NUMBEROFREADOUTCARDS];
      for(int card=0; card<NUMBEROFREADOUTCARDS; card++)
	CardSynchronised[card] = false;


      while(!m_exitflag)
	{
	  TotalPackageCounter++;
	  //if(TotalPackageCounter%1000 == 0)
	  //  std::cout<<"cc: "<<TotalPackageCounter<<std::endl;

	  boost::array<unsigned char, 32768> recv_buf;
	  boost::asio::ip::udp::endpoint remote_endpoint;
	  boost::system::error_code error;
	  int size = socket.receive_from(boost::asio::buffer(recv_buf),
					 remote_endpoint, 0, error);
	  //std::cout<<size<<std::endl;
	  int NumberOfHitsInPackage = (size-4)/4; //footer size is 4, 4 bytes per hit
	  int card = 0;

	  // identify the card:
	  for (card=0;card<NUMBEROFREADOUTCARDS;++card)
	    {
	      //std::cout<<remote_endpoint.address()<<" "<<ReceiverAdresses[card]<<std::endl;
	      if(remote_endpoint.address() ==  ReceiverAdresses[card])
		{
		  //std::cout<<remote_endpoint.address()<<std::endl;
		  break;

		}

	      
	    }

	  
	  //std::cout<<card<<std::endl;
	  //std::cout<<size<<std::endl;
	  if (error && error != boost::asio::error::message_size)
	    throw boost::system::system_error(error);

	  unsigned char *footer;//[FooterSize];
	  footer = (unsigned char*)(& recv_buf[size-1]);
	  unsigned char buf_foot0;
	  buf_foot0 = footer[0];

	  footer = (unsigned char*)(& recv_buf[size-2]);
	  unsigned char buf_foot1;
	  buf_foot1 = footer[0];

	  footer = (unsigned char*)(& recv_buf[size-3]);
	  unsigned char buf_foot2;
	  buf_foot2 = footer[0];

	  footer = (unsigned char*)(& recv_buf[size-4]);
	  unsigned char buf_foot3;
	  buf_foot3 = footer[0];

	  int cc =  (int)(buf_foot0)+  (int)(buf_foot1)*256 +  (int)(buf_foot2)*256*256 ;//+  (int)(buf_foot3)*256*256*256;
	  //std::cout<<card<<" "<<cc<<std::endl;
	  // std::cout<<(int)(buf_foot1)<<std::endl;
	  //std::cout<<(int)(buf_foot1)*255 + (int)(buf_foot0)<<std::endl;
	  package_counter[card] = (int)(buf_foot0)+ (int)(buf_foot1)*256 ;
	  //std::cout<<card<<" "<<package_counter[card]<<std::endl;
	  package_counterMSB[card] = (int)(buf_foot2)+ (int)(buf_foot3)*256 ;
	  //package_counter[card] =  package_counterMSB[card]/256;
	  //std::cout<<card<<" "<<package_counterMSB[card]/256<<std::endl;
	  // if(FirstSynchroniser)
	  //   {
	  //     FirstSynchroniser = false;
	  //     synchroniserPackage = package_counter[card];
	  //   }


	  
	  //the footer:
	     
	  //std::cout<<std::hex<<buf_foot0<<std::endl;
	  //std::cout<<package_counter[card]<<std::endl;
 
	  lastpackage_counter[card] = package_counter[card];

	  //CHit hit_tmp[NUMBEROFHITSINPACKAGE];
	  CPackage package_tmp;
	  package_tmp.NumberOfHitsInPackage = NumberOfHitsInPackage;
	  for(int i=0;i<NumberOfHitsInPackage; i+=1)
	    {
	      boost::array<unsigned char,4> buffer;
	      buffer[0] = recv_buf[4*i];
	      buffer[1] = recv_buf[4*i+1];
	      buffer[2] = recv_buf[4*i+2];
	      buffer[3] = recv_buf[4*i+3];
	      short event_number, ch_number, tot_start, tot_width;
	      DecodeEvent(buffer,event_number,ch_number, tot_start, tot_width);
		  

	     
	      
	      package_tmp.hits[i].ev_nr      = event_number;
	      package_tmp.hits[i].ch_nr      = ch_number;
	      package_tmp.hits[i].rel_time   = tot_start;
	      package_tmp.hits[i].ToT        = tot_width;
	      package_tmp.hits[i].card_nr        = (unsigned short)(card);
	      package_tmp.package_nr = package_counter[card];
	    }
	  //copy the package into the queue:
	  //std::cout<<"copy to queue!"<<std::endl;
	  // m_package->push_front(package_tmp);
  
	}
    }
  





  catch (std::exception& e)
    {
      std::cerr << e.what() << std::endl;
    }


  
  
}


 



void  CReceiver::DecodeEvent(boost::array<unsigned char, 4> buffer, short &event_number, short &ch_number, short &tot_start, short &tot_width)
{
  unsigned char filter;
  filter =0xFE; //111 11110 must be that..
  event_number = (short)(filter & buffer[3])>>1;
  
  filter =0x01; //0000 0001
  ch_number   = (short)(filter & buffer[3]);
  
  filter =0xFC; //1111 1100
  ch_number = (short)(ch_number<<6) + (short)((filter & buffer[2])>>2);
  
  filter = 0x03;//0000 0011
  tot_start =  (short)(filter & buffer[2]);

  filter = 0xF8;//1111 1000;
  tot_start =  (short)(tot_start<<5) + (short)((filter & buffer[1])>>3);
  
  filter = 0x07;//0000 0111
  tot_width =  (short)((filter & buffer[1]));
     
  filter = 0xFF;
  tot_width = (short)(tot_width<<8)+(short)(filter & buffer[0]);
}





