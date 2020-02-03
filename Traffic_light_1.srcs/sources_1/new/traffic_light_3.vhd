----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/22/2019 02:15:22 PM
-- Design Name: 
-- Module Name: traffic_light_3 - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity traffic_light_3 is       
  generic( 
  -- assume that the frequency of machine is 60Hz
        t60: positive := 3600;
        t20: positive := 1200;
        t5:  positive := 300;
        t05: positive := 30;
        tmax: positive := 3600
        );
  Port (
        sensor  : in STD_LOGIC; -- night sensor 
        clk  : in STD_LOGIC; -- clock 
        prior_way, way_1, way_2, way_3 : buffer std_logic_vector(2 downto 0);
		prior_way_out, way_1_out, way_2_out, way_3_out : out std_logic_vector(2 downto 0)
		
);
end traffic_light_3;

architecture Behavioral of traffic_light_3 is
    type state is (gp, yp, g1, y1, g2, y2, g3, y3, all_y, off);
    signal pr_state, nx_state: state;
    signal timer: integer range 0 to tmax;  
begin
    -- lower section of FSM ---
    process(clk, sensor)
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
			when gp =>
				prior_way <= "001";
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "100";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= yp;
				timer <= t60;
			end if;
		
			when yp =>
				prior_way <= "010";
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "100";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= g1;
				timer <= t5;
			end if;
			-----------------------------
			when g1 =>
				prior_way <= "100";
				way_1 <= "001";
				way_2 <= "100";
				way_3 <= "100";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= y1;
				timer <= t20;
			end if;
		
			when y1 =>
				prior_way <= "100";
				way_1 <= "010";
				way_2 <= "100";
				way_3 <= "100";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= g2;
				timer <= t5;
			end if;
			--------------------------------
			when g2 =>
				prior_way <= "100";
				way_1 <= "100";
				way_2 <= "001";
				way_3 <= "100";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= y2;
				timer <= t20;
			end if;
		
			when y2 =>
				prior_way <= "100";
				way_1 <= "100";
				way_2 <= "010";
				way_3 <= "100";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= g3;
				timer <= t5;
			end if;
			-----------------------------------
			when g3 =>
				prior_way <= "100";
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "001";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				nx_state <= y3;
				timer <= t20;
			end if;
		
			when y3 =>
				prior_way <= "100";
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "010";
			if( sensor = '1') then
				nx_state <= all_y;
			else
				timer <= t5;
				nx_state <= gp;
			end if;
			--------------------------------
			when all_y =>
				prior_way <= "010";
				way_1 <= "010";
				way_2 <= "010";
				way_3 <= "010";
			if(sensor ='0') then
				nx_state <= gp;
			else 
				nx_state <= off;
				timer <= t05;
			end if;
			
			when off =>
				prior_way <= "000";
				way_1 <= "000";
				way_2 <= "000";
				way_3 <= "000";
			if(sensor ='0') then
				nx_state <= gp;
			else 
				nx_state <= all_y;
				timer <= t05;
			end if;
		end case;
	end process;
	
	-- glitch free -- 
	process(clk)
	begin
		if rising_edge(clk) then 
			prior_way_out <= prior_way;
			way_1_out <= way_1;
			way_2_out <= way_2;
			way_3_out <= way_3;
		end if;
	end process;
	
end Behavioral;
