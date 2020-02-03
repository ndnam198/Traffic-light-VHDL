library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity traffic_light_4_tb is
	generic(
          t60: positive := 3600;
          t20: positive := 1200;
          t5:  positive := 300;
          t05: positive := 30;
          tmax: positive := 3600

end;

architecture bench of traffic_light_4_tb is

  component traffic_light_4       
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
          g1,g2,g3,gp,y1,y2,y3,yp,r1,r2,r3,rp: out std_logic
  		);
  end component;

  signal sensor: STD_LOGIC:='0';
  signal clk: STD_LOGIC:='0';
  signal g1,g2,g3,gp,y1,y2,y3,yp,r1,r2,r3,rp: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: traffic_light_4 generic map ( t60       => 3600,
                                     t20       => 1200,
                                     t5        => 300,
                                     t05       => 30,
                                     tmax      => 3600)
                          port map ( sensor => sensor,
                                     clk    => clk,
                                     g1     => g1,
                                     g2     => g2,
                                     g3     => g3,
                                     gp     => gp,
                                     y1     => y1,
                                     y2     => y2,
                                     y3     => y3,
                                     yp     => yp,
                                     r1     => r1,
                                     r2     => r2,
                                     r3     => r3,
                                     rp     => rp );

    clk <= not clk after 10ns;
    sensor <= not sensor after 5000;
    run 15000ns;
end;