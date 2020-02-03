 --------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY traffic_light_5 IS
GENERIC (
      t60: positive := 3600;
      t20: positive := 1200;
      t5:  positive := 300;
      t05: positive := 30;
      tmax: positive := 3600
      );
PORT (
      sensor  : in std_logic; -- night sensor 
      clk  : in STD_LOGIC; -- clock 
      g1,g2,g3,gp,y1,y2,y3,yp,r1,r2,r3,rp: out std_logic);
END traffic_light_5;
--------------------------------------------------------
ARCHITECTURE fsm OF traffic_light_5 IS
   TYPE state IS (gpp, ypp, g11, y11, g22, y22, g33, y33, all_y, all_off);
   SIGNAL pr_state, nx_state: state;
   SIGNAL timer: INTEGER RANGE 0 TO tmax;
BEGIN
----Lower section of FSM:-----------
  PROCESS (clk, sensor)
      VARIABLE count : INTEGER RANGE 0 TO tmax;
      BEGIN
          IF (sensor='1') THEN
               pr_state <= all_y;
               count := 0;
          ELSIF (clk'EVENT AND clk='1') THEN
              count := count + 1;
              IF (count>=timer) THEN
                  pr_state <= nx_state;
                  count := 0;
              END IF;
      END IF;
  END PROCESS;
----Upper section of FSM:-----------
PROCESS (pr_state)
begin    
      case pr_state is    
          when gpp =>
              gp <='1'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
              nx_state <= ypp;
              timer <= t60;
          
      
          when ypp =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='1'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
              nx_state <= g11;
              timer <= t5;
          
          -----------------------------
          when g11 =>
              gp <='0'; g1 <= '1'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= y11;
              timer <= t20;
          
      
          when y11 =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '1'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= g22;
              timer <= t5;
          
          --------------------------------
          when g22 =>
              gp <='0'; g1 <= '0'; g2 <= '1'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= y22;
              timer <= t20;
          
      
          when y22 =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '1'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= g33;
              timer <= t5;
          
          -----------------------------------
          when g33 =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '1'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= y33;
              timer <= t20;
          
          when y33 =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '1';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              timer <= t5;
              nx_state <= gpp;
          ---------------------
          when all_y =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='1'; y1 <= '1'; y2 <= '1'; y3 <= '1';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= all_off;
              timer <= t05;
          
          when all_off =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
          
              nx_state <= all_y;
              timer <= t05;
          
      end case;
  end process;
END fsm;