#ifndef _CDATATYPES_H_
#define _CDATATYPES_H_
//typedef unsigned short int ushort;
#include "CConstants.h"
#include <iostream>
#include <boost/circular_buffer.hpp>
#include <boost/thread/mutex.hpp>
#include <boost/thread/condition.hpp>
#include <boost/thread/thread.hpp>
#include <boost/progress.hpp>
#include <boost/bind.hpp>


//some structs needed for writing the HDF5 files:

struct C5Hit{
  unsigned short ev_nr;
  unsigned short ch_nr;  
  unsigned short rel_time;
  unsigned short ToT;
  unsigned short card_nr;
};

 struct C5Event {
  int numhits;  
  struct C5Hit hits[MAXNUMHITSINSLOT];

};



class CHit
{
 public:
  unsigned short ev_nr;
  unsigned short ch_nr;  
  unsigned short rel_time;
  unsigned short ToT;
  unsigned short card_nr;

  void operator=(CHit hit) 
    {
      this->ev_nr = hit.ev_nr;
      this->ch_nr = hit.ch_nr;
      this->rel_time = hit.rel_time;
      this->ToT   = hit.ToT;
      this->card_nr   = hit.card_nr;

    }

  C5Hit copy()
    {
      C5Hit c5hit;
      
      c5hit.ev_nr = this->ev_nr;
      c5hit.ch_nr = this->ch_nr;
      c5hit.rel_time = this->rel_time;
      c5hit.ToT = this->ToT;
      c5hit.card_nr = this->card_nr;
      return c5hit;

    }

};

class CPackage
{
 public:
  int NumberOfHitsInPackage;
  int package_nr;
  CHit hits[MAXNUMBEROFHITSINPACKAGE];
  void operator=(CPackage package)
    {
      this->NumberOfHitsInPackage = package.NumberOfHitsInPackage;
      this->package_nr = package.package_nr;
      for(int i = 0; i<NumberOfHitsInPackage; i++)
	this->hits[i] = package.hits[i];

    }

};


class CEvent
{
public:
  int numhits;
  CHit hits[MAXNUMHITSINSLOT];

  void operator=(CEvent event)
    {
      for(int i = 0; i<MAXNUMHITSINSLOT; i++)
	this->hits[i] = event.hits[i];
      
    }
  C5Event copy2() //copies only the numhits entries
  {
    C5Event c5event;
     for(int i = 0; i<numhits; i++)
       c5event.hits[i] = hits[i].copy();
     c5event.numhits = numhits;
     return c5event;
  }
  C5Event copy()
  {
    C5Event c5event;
     for(int i = 0; i<MAXNUMHITSINSLOT; i++)
       c5event.hits[i] = hits[i].copy();
     c5event.numhits = numhits;
     return c5event;
  }

};






template <class T>
class bounded_buffer {
 public:
  
  typedef boost::circular_buffer<T> container_type;
  typedef typename container_type::size_type size_type;
  typedef typename container_type::value_type value_type;
  
  explicit bounded_buffer(size_type capacity) : m_unread(0), m_container(capacity) {}
  
  void push_front(const value_type& item) {
    boost::mutex::scoped_lock lock(m_mutex);
    //std::cout<<m_unread<<"/"<<m_container.capacity()<<std::endl;
    m_not_full.wait(lock, boost::bind(&bounded_buffer<value_type>::is_not_full, this));
    m_container.push_front(item);
    ++m_unread;
    lock.unlock();
    m_not_empty.notify_one();
  }
  
  void pop_back(value_type* pItem) {
    boost::mutex::scoped_lock lock(m_mutex);
    m_not_empty.wait(lock, boost::bind(&bounded_buffer<value_type>::is_not_empty, this));
    *pItem = m_container[--m_unread];
    lock.unlock();
    m_not_full.notify_one();
  }
  
 private:
  bounded_buffer(const bounded_buffer&);              // Disabled copy constructor
  bounded_buffer& operator = (const bounded_buffer&); // Disabled assign operator
  
  bool is_not_empty() const { return m_unread > 0; }
  bool is_not_full()  const { return m_unread <  m_container.capacity(); }
  
  
  size_type m_unread;
  container_type m_container;
  boost::mutex m_mutex;
  boost::condition m_not_empty;
  boost::condition m_not_full;



};



class CSlot
{
 public:
  CSlot(int SlotNumber)
    {
      m_ReadyToRead = false;
      m_entry       = 0;
      m_full        = false;
      m_SlotNumber = SlotNumber;
    }
  CHit m_hits[MAXNUMHITSINSLOT];
  bool m_ReadyToRead;
  bool m_full;
  int  m_SlotNumber;
  
  void PushHit(CHit hit)
  {
  
    boost::mutex::scoped_lock lock(m_mutex);
  
   
    m_hits[m_entry++] =  hit;
    if(m_entry == MAXNUMHITSINSLOT-1)
      {
	m_full = true;
	m_ReadyToRead = true;
      }
    lock.unlock();
    
    
   

  }

 
  int PullHits(CHit *hits)
  {
    int numentries;
    boost::mutex::scoped_lock lock(m_mutex);
    
    for(int i=0;i<m_entry;i++)
      hits[i] = m_hits[i];
    numentries = m_entry;
    m_entry = 0;
    m_full = false;
    m_ReadyToRead = false;
    lock.unlock();    
    
    return numentries;

  }

 private:
  int m_entry;
  boost::mutex m_mutex;
  boost::condition m_ReadNow;
  boost::condition m_WriteNow;


  
  




};



#endif
