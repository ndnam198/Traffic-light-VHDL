library IEEE;
use IEEE.Std_logic_1164.all;

entity traffic_light_7_tb is
  
end entity traffic_light_7_tb;

architecture bench of traffic_light_7_tb is

  component traffic_light_7
  	generic (
  			 tmax : integer := 3000;
  			 t20 : integer := 1000; 
  			 t60: integer := 3000; 
  			 t5 : integer := 250;
  			 t05 : integer := 25);
      Port ( clk : in std_logic;
             inverse : in std_logic;
  		     blink : in std_logic;
  		     way_1: out std_logic_vector(2 downto 0);
             way_2: out std_logic_vector(2 downto 0);
  		     way_3: out std_logic_vector(3 downto 0)
  );
  end component;

  signal clk: std_logic :='0';
  signal inverse: std_logic :='0';
  signal blink: std_logic :='0';
  signal way_1: std_logic_vector(2 downto 0);
  signal way_2: std_logic_vector(2 downto 0);
  signal way_3: std_logic_vector(3 downto 0) ;

begin

  -- Insert values for generic parameters !!
  uut: traffic_light_7 generic map ( tmax    => 3000,
                                     t20     => 1000,
                                     t60     => 3000,
                                     t5      => 250,
                                     t05     => 25)
                          port map ( clk     => clk,
                                     inverse => inverse,
                                     blink   => blink,
                                     way_1   => way_1,
                                     way_2   => way_2,
                                     way_3   => way_3 );

    clk <= not clk after 10ns;
    blink <= not blink after 10000ns;
    inverse <= not inverse after 20000ns;
end;