library IEEE;
use IEEE.Std_logic_1164.all;


entity traffic_light_6_tb is

end;

architecture bench of traffic_light_6_tb is

  component traffic_light_6
      Port ( clk : in STD_LOGIC;
             sensor : in bit; 
             r1,r2,r3,rp,g1,g2,g3,gp,y1,y2,y3,yp: out std_logic);
  end component;

  signal clk: STD_LOGIC :='0';
  signal sensor: bit :='0';
  signal r1,r2,r3,rp,g1,g2,g3,gp,y1,y2,y3,yp: std_logic;

begin

  -- Insert values for generic parameters !!
  uut: traffic_light_6  port map ( clk    => clk,
                                     sensor => sensor,
                                     r1     => r1,
                                     r2     => r2,
                                     r3     => r3,
                                     rp     => rp,
                                     g1     => g1,
                                     g2     => g2,
                                     g3     => g3,
                                     gp     => gp,
                                     y1     => y1,
                                     y2     => y2,
                                     y3     => y3,
                                     yp     => yp );
    simulation_clk : process
    begin

         for i in 0 to 50000 loop
            clk <= '1';
            wait for 10 ps;
            clk <= '0';
            wait for 10 ps;         
         end loop;
         wait;
     end process simulation_clk;
     
     simulation_sensor : process
     begin 
         sensor <= '0';
         wait for 400000 ps;
         sensor <= '1';
         wait for 200000 ps;
         sensor <= '0';
         wait;
     end process simulation_sensor;

end;