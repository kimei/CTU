#include <sys/prctl.h>
#include <boost/asio.hpp>
#include <iostream>
#include <boost/thread/thread.hpp>
#include <boost/thread/condition.hpp>
#include <boost/array.hpp>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "CConstants.h"
#include "CDataTypes.h"
#include "semaphore.h"

//using namespace std;

bounded_buffer<unsigned int> *fifo[NUMBEROFREADOUTCARDS];
sem_t mutex;


void *a_trigger(void *ptr){
  unsigned int *out_p;
  out_p = new unsigned int;  
  while(1){

    // sem_wait(&mutex);

    fifo[0]->pop_back(out_p);
    
    //fifo[1]->pop_back(out_p[1]);
    //sem_post(&mutex);
    // char *mld;
    // mld = (char*)ptr;
    //std::cout <<"HAR POOPPA!" <<std::endl;
     std::cout <<"Fra consumer 1: "<< *out_p<<std::endl;
  }
}

void *UDP_send(void *ptr)
{
  int packagecounter = 0;

  boost::asio::io_service io_service;
  boost::asio::ip::udp::socket socket(io_service); 
  boost::asio::socket_base::broadcast option(true);
  socket.set_option(option);
}


void *UDP_receive(void *ptr)
{
  int TotalPackageCounter = 0;
  boost::asio::ip::address ReceiverAdresses[NUMBEROFREADOUTCARDS];
  std::string  ipaddresses[NUMBEROFREADOUTCARDS];
  ipaddresses[0] = IPCARD0; 
  ipaddresses[1] = IPCARD1;
  for (int card=0;card<NUMBEROFREADOUTCARDS;card++)
    {
      ReceiverAdresses[card] = boost::asio::ip::address_v4::from_string(ipaddresses[card]);
    }
  try
    {
      boost::asio::io_service io_service;
      boost::asio::ip::udp::socket socket(io_service, boost::asio::ip::udp::endpoint(boost::asio::ip::udp::v4(), PORT));
      int lastpackage_counter[NUMBEROFREADOUTCARDS];
      int package_counter[NUMBEROFREADOUTCARDS];
      int package_counterMSB[NUMBEROFREADOUTCARDS];
      //Reset everything
      for (int card=0;card<NUMBEROFREADOUTCARDS;card++)
	{
	  lastpackage_counter[card]=0;
	  package_counter[card]=0;
	  package_counterMSB[card] =0;
	}
      
      while(1){
	TotalPackageCounter++;
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
	//std::cout<<size<<std::endl;
	//std::cout<<card<<std::endl;
	if (error && error != boost::asio::error::message_size)
	  throw boost::system::system_error(error);
	
	unsigned int trigger_times_tmp[100]; //change this
	
	
	std::cout << TotalPackageCounter <<" from: " << card  <<std::endl;

	sem_wait(&mutex); //Lock the mutex
	for(int i=0; i<NumberOfHitsInPackage; i++){
	  trigger_times_tmp[i] = (int)recv_buf[4*i]+(int)recv_buf[4*i+1]*256+(int)recv_buf[4*i+2]*256*256+(int)recv_buf[4*i+3]*256*256*256;

	  fifo[card]->push_front(trigger_times_tmp[i]);

	   std::cout << trigger_times_tmp[i] <<std::endl;
	}
	sem_post(&mutex);
	
	
	
      }
      
	  
    }
  catch(std::exception& e){
    std::cerr << e.what() << std::endl;
  }
}


int main()
{
  pthread_t receiver, consumer;
  int ret1, ret2;
 char *mld1 = "receiver";
 char *mld2 = "atrig";

 sem_init(&mutex, 0, 1);
  for(int i=0;i<NUMBEROFREADOUTCARDS;i++){
    fifo[i] = new bounded_buffer<unsigned int>(FIFO0_SIZE);
  }
  ret1 = pthread_create( &receiver, NULL, UDP_receive , (void*) mld1);
  ret2 = pthread_create( &consumer, NULL, a_trigger, (void*) mld2);

  pthread_join( receiver, NULL);
  pthread_join( consumer, NULL); 
  
  std::cout << NUMBEROFREADOUTCARDS << std::endl;   
  return 0;
}
