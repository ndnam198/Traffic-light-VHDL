library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity traffic_light_3_tb is
	generic(
          t60: positive := 3600;
          t20: positive := 1200;
          t5:  positive := 300;
          t05: positive := 30;
          tmax: positive := 3600
          );
end;

architecture bench of traffic_light_3_tb is

  component traffic_light_3       
    generic(
          t60: positive := 3600;
          t20: positive := 1200;
          t5:  positive := 300;
          t05: positive := 30;
          tmax: positive := 3600
          );
    Port (
          sensor  : in STD_LOGIC;
          clk  : in STD_LOGIC;
          prior_way, way_1, way_2, way_3 : buffer std_logic_vector(2 downto 0);
  		prior_way_out, way_1_out, way_2_out, way_3_out : out std_logic_vector(2 downto 0)
  );
  end component;

  signal sensor: STD_LOGIC;
  signal clk: STD_LOGIC;
  signal prior_way, way_1, way_2, way_3: std_logic_vector(2 downto 0);
  signal prior_way_out, way_1_out, way_2_out, way_3_out: std_logic_vector(2 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: traffic_light_3 generic map ( t60       => 3600,
                                     t20       => 1200,
                                     t5        => 300,
                                     t05       => 30,
                                     tmax      => 3600)
                          port map ( sensor        => sensor,
                                     clk           => clk,
                                     prior_way     => prior_way,
                                     way_1         => way_1,
                                     way_2         => way_2,
                                     way_3         => way_3,
                                     prior_way_out => prior_way_out,
                                     way_1_out     => way_1_out,
                                     way_2_out     => way_2_out,
                                     way_3_out     => way_3_out );

  stimulus: process
  begin
  
    -- Put initialisation code here
		wait for 100ns;
		
		sensor <= '0';
		wait for 500ns;
		
		sensor <= '1';
		wait for 500ns;


    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;
end;