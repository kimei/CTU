library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.components.all;
use work.constants.all;



entity rate_counter is
  port (
    clk   : in std_logic;
    rst_b : in std_logic;

    rate_cards  : in std_logic_vector(NUMBER_OF_ROCS-1 downto 0);
    coincidence : in std_logic_vector(NUMBER_OF_ROCS-1 downto 0);

    -- FIFO interface
    we         : out std_logic;
    we_others  : in  std_logic;
    fifo_empty : in  std_logic;
    din        : out std_logic_vector(7 downto 0)

    );
end rate_counter;

architecture behave of rate_counter is
  subtype tmp_type is unsigned(31 downto 0);  --natural range 0 to natural'high;
  type    rate_matrix is array(31 downto 0) of tmp_type;

  type states is (init, count, wait_for_fifo, write_fifo_udp_sel ,write_fifo1, write_fifo2, write_fifo3, write_fifo4);

  signal state       : states;
  signal counts      : rate_matrix;
  signal edge_detect : std_logic_vector(31 downto 0);

  signal en_counter : std_logic;        -- turns the counter on and off



  signal ucnt   : unsigned(31 downto 0);
  signal count1 : integer range 0 to 63;

  signal sek : std_logic;               -- this goes high for 1 clk when
                                        -- counter has counted to 200 mill.
  
  
begin

  G_edge_det : for I in 0 to NUMBER_OF_ROCS-1 generate
    edge_detect_1 : edge_detector
      port map (
        rst_b => rst_b,
        mclk  => clk,
        inp   => rate_cards(I),
        outp  => edge_detect(I));
  end generate G_edge_det;

  edge_detect(30 downto NUMBER_OF_ROCS) <= (others => '0');  -- set unused to 0

  edge_detect_coincidence : edge_detector
    port map (
      rst_b => rst_b,
      mclk  => clk,
      inp   => coincidence(0),
      outp  => edge_detect(31)
      );



  cnt : process (clk, rst_b)
  begin
    if(rst_b = '0') then
      ucnt <= (others => '0');
    elsif(rising_edge(clk)) then
      sek <= '0';
      if en_counter = '1' then
        ucnt <= ucnt +1;
      end if;

      if ucnt = 125000000 then
        ucnt <= (others => '0');
        sek  <= '1';
      end if;
    end if;
  end process;

  counter_proc : process(clk, rst_b)
  begin
    if rst_b = '0' then
      state <= init;
      we    <= '0';
      din   <= (others => '0');
      


    elsif clk'event and clk = '1' then
      en_counter <= '0';
      we         <= '0';

      case state is
        when init =>
          state  <= count;
          count1 <= 0;
          we     <= '0';
          din    <= (others => '0');
          counts <= (others => (others => '0'));

        when count =>
          en_counter <= '1';

         for index in 0 to 31 loop
           if edge_detect(index) = '1' then
              counts(index) <= counts(index) + 1;
            end if;
          end loop;  -- index
			--counts(0) <= x"AABBCCDD";
			--counts(1) <= x"AABBCCDD";
			--counts(31) <= x"AABBCCDD";
          if sek = '1' then
            state <= wait_for_fifo;
          else
            state <= count;
          end if;
          
          

        when wait_for_fifo =>
          if (we_others = '0') and (fifo_empty = '1') then  -- and fifo empty.. !!
            state <= write_fifo_udp_sel;
          else
            state <= wait_for_fifo;
          end if;
			 
			when write_fifo_udp_sel =>
				we    <= '1';
            din   <= "11111111"; -- 0 is to let the udp transmitter know that it goes to the computers
            state <= write_fifo1;

        when write_fifo1 =>
          if count1 = 32 then
            state <= init;
          else
            we    <= '1';
            din   <= std_logic_vector(counts(count1)(31 downto 24));
            state <= write_fifo2;
          end if;
          
        when write_fifo2 =>
          we    <= '1';
          din   <= std_logic_vector(counts(count1)(23 downto 16));
          state <= write_fifo3;
        when write_fifo3 =>
          we    <= '1';
			 din   <= std_logic_vector(counts(count1)(15 downto 8));
          state <= write_fifo4;
        when write_fifo4 =>
          we     <= '1';
          din    <= std_logic_vector(counts(count1)(7 downto 0));
          count1 <= count1 + 1;
          state  <= write_fifo1;
          

        when others =>
          state <= init;
      end case;

    end if;
  end process;
  
end behave;
