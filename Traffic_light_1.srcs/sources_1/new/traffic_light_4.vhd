----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/22/2019 02:15:22 PM
-- Design Name: 
-- Module Name: traffic_light_4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity traffic_light_4 is       
  generic( 
  -- assume that the frequency of machine is 60Hz
        t60: positive := 3600;
        t20: positive := 1200;
        t5:  positive := 300;
        t05: positive := 30;
        tmax: positive := 3600
        );
  Port (
        sensor  : in std_logic; -- night sensor 
        clk  : in STD_LOGIC; -- clock 
        g1,g2,g3,gp,y1,y2,y3,yp,r1,r2,r3,rp: out std_logic
		);
		
end traffic_light_4;

architecture Behavioral of traffic_light_4 is
    type state is (gpp, ypp, g11, y11, g22, y22, g33, y33, all_y, off);
    signal pr_state, nx_state: state;
    signal timer: integer range 0 to tmax;  
begin
    -- lower section of FSM ---
    process(clk)
		variable count: integer range 0 to tmax;
    begin
        
		if rising_edge(clk) then
			count := count + 1;
			IF (count >= timer) then
				pr_state <= nx_state;
				count := 0;
			end if;
		end if;
	end process; 
	
	-- upper section of FSM ---
	process(pr_state, sensor)
	begin	
		case pr_state is	
			when gpp =>
				gp <='1'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= ypp;
				timer <= t60;
			end if;
		
			when ypp =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='1'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= g11;
				timer <= t5;
			end if;
			-----------------------------
			when g11 =>
				gp <='0'; g1 <= '1'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= y11;
				timer <= t20;
			end if;
		
			when y11 =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '1'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= g22;
				timer <= t5;
			end if;
			--------------------------------
			when g22 =>
				gp <='0'; g1 <= '0'; g2 <= '1'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= y22;
				timer <= t20;
			end if;
		
			when y22 =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '1'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= g33;
				timer <= t5;
			end if;
			-----------------------------------
			when g33 =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '1'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= y33;
				timer <= t20;
			end if;
		
			when y33 =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '1';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if( sensor = '1') then
				nx_state <= all_y;
			else
				timer <= t5;
				nx_state <= gpp;
			end if;
			--------------------------------
			when all_y =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='1'; y1 <= '1'; y2 <= '1'; y3 <= '1';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if(sensor ='0') then
				nx_state <= gpp;
			else 
				nx_state <= off;
				timer <= t05;
			end if;
			
			when off =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
			if(sensor ='0') then
				nx_state <= gpp;
			else 
				nx_state <= all_y;
				timer <= t05;
			end if;
		end case;
	end process;
	
	-- glitch free -- 
	
	
end Behavioral;
