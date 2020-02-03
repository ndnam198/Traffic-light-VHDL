library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity traffic_light_7 is
	generic (
			 tmax : integer := 3000;
			 t20 : integer := 1000; 
			 t60: integer := 3000; 
			 t5 : integer := 250;
			 t05 : integer := 25);
			
    Port ( clk : in std_logic;
           inverse : in std_logic; 	-- inverse the prior direction
		   blink : in std_logic;	-- blink yellow light 
		   way_1: out std_logic_vector(2 downto 0);
           way_2: out std_logic_vector(2 downto 0);
		   way_3: out std_logic_vector(3 downto 0)
); -- RYGL
end entity traffic_light_7;

architecture Behavioral of traffic_light_7 is
    signal timer : integer range 0 to tmax;
    type state is (g1, y1, g2, y2, l3, g3, y3, yy, off);
    signal pr_state, nx_state : state;
begin
    --------- Lower section of state machine: ---------
    process (clk)
         variable count : integer range 0 to tmax;
    begin
        
        if rising_edge(clk) then
             count := count + 1;
			if (count >= timer) then
             pr_state <= nx_state;
             count := 0;      
			end if;
        end if;
    end process;
    --------- Upper section of state machine: ---------
    process(pr_state, blink, inverse)
    begin
        case pr_state is
           when g1 =>
				way_1 <= "001";
				way_2 <= "100";
				way_3 <= "1000";   
              if (blink ='1') then 
				nx_state <= yy;
				end if;
              if (inverse ='1') then 
				nx_state <= y1;
				timer <= t20;
				else
				nx_state <= y1;
				timer <= t60;
			
              end if;
                      
           when y1 =>
				way_1 <= "010";
				way_2 <= "100";
				way_3 <= "1000";                     
              	timer <= t5;    
              if (blink ='1') then 
				nx_state <= yy;
			  else 
				nx_state <= g2;
				end if;   
					
			  
			when g2 =>
                way_1 <= "100";
				way_2 <= "001";
				way_3 <= "1000";             
              if (blink ='1') then 
				nx_state <= yy;
				end if;
              if (inverse ='1') then 
				nx_state <= y2;
				timer <= t60;
				else
				nx_state <= y2;
				timer <= t20;
			
              end if;  

			when y2 =>
				way_1 <= "100";
				way_2 <= "010";
				way_3 <= "1000";                     
              	timer <= t5;    
              if (blink ='1') then 
				nx_state <= yy;
			  else 
				nx_state <= l3;
				end if;   

			when l3 =>
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "0001";           
              	timer <= t20;    
              if (blink ='1') then 
				nx_state <= yy;
              else 
				nx_state <= g3;
              end if;
			  
			 when g3 =>
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "0010";              
              	timer <= t20;    
              if (blink ='1') then 
				nx_state <= yy;
              else 
				nx_state <= y3;
              end if;
			  
			when y3 =>
				way_1 <= "100";
				way_2 <= "100";
				way_3 <= "0100";            
              	timer <= t5;    
              if (blink ='1') then 
				nx_state <= yy;
              else 
				nx_state <= g1;
              end if;
			  
		
			  
			when yy =>
				way_1 <= "010";
				way_2 <= "010";
				way_3 <= "0100";  
				timer <= t05;
			if(blink = '1') then	
				nx_state <= off;
			else 
				nx_state <= g1;
				
			end if;
			
			when off =>
				way_1 <= "000";
				way_2 <= "000";
				way_3 <= "0000";
				timer <= t05;
			if(blink = '1') then	
				nx_state <= yy;
			else 
				nx_state <= g1;
				
			end if;
         end case;  
    end process;

end Behavioral;
