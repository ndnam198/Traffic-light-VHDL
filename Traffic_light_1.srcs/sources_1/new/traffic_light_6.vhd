library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity traffic_light_6 is
	
			
    Port ( clk : in std_logic;
           sensor : in bit; 
           r1: out std_logic;
           r2: out std_logic;
           r3: out std_logic;
           rp: out std_logic;
           g1: out std_logic;
           g2: out std_logic;
           g3: out std_logic;
           gp: out std_logic;
           y1: out std_logic;
           y2: out std_logic;
           y3: out std_logic;
           yp: out std_logic);
end entity traffic_light_6;

tarchitecture Behavioral of traffic_light_6 is
    
    
	constant tmax : integer := 3600;
  	constant t20 : integer := 1200; 
	constant t60: integer := 3600; 
	constant t5 : integer := 300;
	constant t05 : integer := 30;
	signal timer : integer range 0 to tmax;
    
    type state is (prior_g, prior_y, way1_g, way1_y, way2_g,way2_y, way3_g, way3_y, all_y, all_off);
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
    process(pr_state, sensor)
    begin
        case pr_state is
           when prior_g =>
              gp <='1'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';    
				timer <= t60;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= prior_y;
              end if;
                      
           when prior_y =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='1'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';                     
              	timer <= t5;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= way1_g;
              end if;         
			  
			when way1_g =>
              gp <='0'; g1 <= '1'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';                 
              	timer <= t20;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= way1_y;
              end if;    

			when way1_y =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '1'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';               
              	timer <= t5;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= way2_g;
              end if;   

			when way2_g =>
              gp <='0'; g1 <= '0'; g2 <= '1'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';             
              	timer <= t20;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= way2_y;
              end if;
			  
			 when way2_y =>
              gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
              yp <='0'; y1 <= '0'; y2 <= '1'; y3 <= '0';
              rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';              
              	timer <= t5;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= way3_g;
              end if;
			  
			when way3_g =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '1'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';           
              	timer <= t20;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= way3_y;
              end if;
			  
			when way3_y =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '1';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';            
              	timer <= t5;    
              if (sensor ='1') then 
				nx_state <= all_y;
              else 
				nx_state <= prior_g;
              end if;
			  
			when all_y =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='1'; y1 <= '1'; y2 <= '1'; y3 <= '1';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
				timer <= t05;
			if(sensor = '1') then	
				nx_state <= all_off;
			else 
				nx_state <= way_g;
				
			end if;
			
			when all_off =>
				gp <='0'; g1 <= '0'; g2 <= '0'; g3 <= '0'; 
				yp <='0'; y1 <= '0'; y2 <= '0'; y3 <= '0';
				rp <= '0';r1 <= '0'; r2 <= '0'; r3 <= '0';
				timer <= t05;
			if(sensor = '1') then	
				nx_state <= all_off;
			else 
				nx_state <= way1_g;
				
			end if;
         end case;  
    end process;

end Behavioral;
