library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;  
-----------------------------------------------------------------------------------------------------------------------------
entity traffic_light_controller is
 port ( sensor  : in STD_LOGIC; -- night sensor 
        clk  : in STD_LOGIC; -- clock 
        rst  : in STD_LOGIC; -- reset  
        prior_way  : out STD_LOGIC_VECTOR(2 downto 0); -- light outputs of the prior way  
        way_1:out STD_LOGIC_VECTOR(2 downto 0);-- light outputs of the first way  
		way_2:out STD_LOGIC_VECTOR(2 downto 0);-- light outputs of the second way
		way_3:out STD_LOGIC_VECTOR(2 downto 0)-- light outputs of the third way
     --RED_YELLOW_GREEN 
   );
end traffic_light_controller;
------------------------------------------------------------------------------------------------------------------------------------
architecture traffic_light of traffic_light_controller is
signal counter_half: std_logic_vector(27 downto 0):= x"0000000";  -- count 0.5 second
signal clk_half_enable: std_logic; -- 0.5s clock enable when 0.5s counter done counting
signal delay_count:std_logic_vector(7 downto 0):= x"00";          -- number of time the couter_1s has already been count
signal delay_half, delay_5s, delay_20s, delay_60s, GREEN_LIGHT_ENABLE_P, GREEN_LIGHT_ENABLE_N, YELLOW_LIGHT_ENABLE, NIGHTMODE_ENABLE: std_logic:='0';

type FSM_States is (w1g, w1y, w2g, w2y, w3g, w3y, pg, py, nm1, nm2);
-- wig way number i GREEN
-- wiy way number i YELLOW 
-- i = 1 -> 3
-- pg prior way GREEN
-- py prior way YELLOW
-- nm1 nightmode 1 all light turn YELLOW
-- nm2 nightmode 2 all light turn OFF
signal current_state, next_state: FSM_States;
begin

-- next state FSM sequential logic 
process(clk,rst) 
begin
if(rst='1') then
 current_state <= pg ;
elsif(rising_edge(clk)) then 
 current_state <= next_state; 
end if; 
end process;

-- FSM combinational logic 
process(current_state, sensor, delay_5s, delay_20s, delay_60s, delay_half)
begin
case current_state is 

when w1g => -- When way_1 GREEN -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '1';-- enable Green light delay on way way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior_way way counting
 YELLOW_LIGHT_ENABLE <= '0';-- disable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '0';
 way_1 <= "001"; -- Green light on way_1
 way_2 <= "100";
 way_3 <= "100";
 prior_way <= "100"; -- Red light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_20s = '1') then
  next_state <= w1y;
 else 
  next_state <= w1g; 
  -- Otherwise, remains the current condition
 end if;
 
when w1y => -- When way_1 YELLOW -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '0';
 GREEN_LIGHT_ENABLE_P <= '0';
 YELLOW_LIGHT_ENABLE <= '1';
 NIGHTMODE_ENABLE <= '0';
 way_1 <= "010"; -- Yellow light on way_1
 way_2 <= "100";
 way_3 <= "100";
 prior_way <= "100"; -- Red light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_5s = '1') then
  next_state <= w2g;
 else 
  next_state <= w1y; 
  -- Otherwise, remains the current condition
 end if;
 
 when w2g => -- When way_2 GREEN -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '1';
 GREEN_LIGHT_ENABLE_P <= '0';
 YELLOW_LIGHT_ENABLE <= '0';
 NIGHTMODE_ENABLE <= '0';
 way_2 <= "001"; 
 way_1 <= "100";
 way_3 <= "100";
 prior_way <= "100"; -- Red light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_20s = '1') then
  next_state <= w2y;
 else 
  next_state <= w2g; 
  -- Otherwise, remains the current condition
 end if;
 
when w2y => -- When way_2 YELLOW -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '0';
 GREEN_LIGHT_ENABLE_P <= '0';
 YELLOW_LIGHT_ENABLE <= '1';
 NIGHTMODE_ENABLE <= '0';
 way_2 <= "010"; 
 way_1 <= "100";
 way_3 <= "100";
 prior_way <= "100"; -- Red light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_5s = '1') then
  next_state <= w3g;
 else 
  next_state <= w2y; 
  -- Otherwise, remains the current condition
 end if;
 
 when w3g => -- When way_3 GREEN -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '1';
 GREEN_LIGHT_ENABLE_P <= '0';
 YELLOW_LIGHT_ENABLE <= '0';
 NIGHTMODE_ENABLE <= '0';
 way_3 <= "001"; 
 way_2 <= "100";
 way_1 <= "100";
 prior_way <= "100"; -- Red light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_20s = '1') then
  next_state <= w3y;
 else 
  next_state <= w3g; 
  -- Otherwise, remains the current condition
 end if;
 
when w3y => -- When way_3 YELLOW -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '0';
 GREEN_LIGHT_ENABLE_P <= '0';
 YELLOW_LIGHT_ENABLE <= '1';
 NIGHTMODE_ENABLE <= '0';
 way_3 <= "010"; 
 way_2 <= "100";
 way_1 <= "100";
 prior_way <= "100"; -- Red light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_5s = '1') then
  next_state <= pg;
 else 
  next_state <= w3y; 
  -- Otherwise, remains the current condition
 end if;
 
 when pg => -- When prior_way GREEN -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '0';
 GREEN_LIGHT_ENABLE_P <= '1';
 YELLOW_LIGHT_ENABLE <= '0';
 NIGHTMODE_ENABLE <= '0';
 way_3 <= "100"; 
 way_2 <= "100";
 way_1 <= "100";
 prior_way <= "001"; -- Green light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_60s = '1') then
  next_state <= py;
 else 
  next_state <= pg; 
  -- Otherwise, remains the current condition
 end if;
 
when py => -- When prior_way YELLOW -- OTHERS RED
 GREEN_LIGHT_ENABLE_N <= '0';
 GREEN_LIGHT_ENABLE_P <= '0';
 YELLOW_LIGHT_ENABLE <= '1';
 NIGHTMODE_ENABLE <= '0';
 way_3 <= "100"; 
 way_2 <= "100";
 way_1 <= "100";
 prior_way <= "010"; -- Yellow light on the others
 if(sensor = '1') then -- nm1 activated
  next_state <= nm1; 
 elsif(delay_5s = '1') then
  next_state <= w1g;
 else 
  next_state <= py; 
  -- Otherwise, remains the current condition
 end if;
 
when nm1 => -- nm1
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on way way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior_way way counting
 YELLOW_LIGHT_ENABLE <= '0';-- enable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '1';-- enable NIGHTMODE
 way_3 <= "010"; 
 way_2 <= "010";
 way_1 <= "010";
 prior_way <= "010";
 if(sensor = '0') then 
	next_state <= pg;
 elsif(delay_half = '1') then
	next_state <= nm2;
 else 
	next_state <= nm1;
 end if;
 
 when nm2 => -- all turned off
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on way way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior_way way counting
 YELLOW_LIGHT_ENABLE <= '0';-- enable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '1';-- enable NIGHTMODE
 way_3 <= "000"; 
 way_2 <= "000";
 way_1 <= "000";
 prior_way <= "000";
 if(sensor = '0') then 
	next_state <= pg;
 elsif(delay_half = '1') then
	next_state <= nm1;
 else 
	next_state <= nm2;
 end if;

when others => next_state <= pg; 

end case;
end process;


-- Delay counts for Yellow and Green light  
process(clk)
begin

if(rising_edge(clk)) then 
if(clk_half_enable='1') then
-- GREEN_LIGHT_ENABLE_P, GREEN_LIGHT_ENABLE_N, YELLOW_LIGHT_ENABLE, NIGHTMODE_ENABLE
-- delay_half, delay_5s, delay_20s, delay_60s
 if(GREEN_LIGHT_ENABLE_P='1' or GREEN_LIGHT_ENABLE_N='1' or YELLOW_LIGHT_ENABLE='1' or NIGHTMODE_ENABLE ='1' ) then
  delay_count <= std_logic_vector(unsigned(delay_count) + x"01"); -- whenever a LIGHT_ENABLE_SIGNAL is turned on
  if((delay_count = x"77") and GREEN_LIGHT_ENABLE_P ='1') then 			-- x'77' = 119
   delay_60s <= '1';	-- transition of the current state to the next state 
   delay_20s <= '0';
   delay_5s <= '0';
   delay_half <= '0';
   delay_count <= x"00"; -- reset delay_count
  elsif((delay_count = x"27") and GREEN_LIGHT_ENABLE_N = '1') then	 	-- x'27' = 39
  delay_60s <= '0';
   delay_20s <= '1';
   delay_5s <= '0';
   delay_half <= '0';
   delay_count <= x"00";
  elsif((delay_count = x"09") and YELLOW_LIGHT_ENABLE = '1') then		-- x'09' = 9
   delay_60s <= '0';
   delay_20s <= '0';
   delay_5s <= '1';
   delay_half <= '0';
   delay_count <= x"00";
  elsif((delay_count = x"00") and NIGHTMODE_ENABLE = '1') then			-- it already count 0.5s
   delay_60s <= '0';
   delay_20s <= '0';
   delay_5s <= '0';
   delay_half <= '1';
   delay_count <= x"00";
  else
   delay_60s <= '0';
   delay_20s <= '0';
   delay_5s <= '0';
   delay_half <= '0';
   delay_count <= x"00";
  end if;
 end if;
 end if;
end if;
end process;

-- create delay 0.5s
process(clk)
begin

if(rising_edge(clk)) then 
 counter_half <= std_logic_vector(unsigned(counter_half) + x"0000001");
 if(counter_half >= x"0000001") then -- x"0000002" is for simulation and it means 2 clock cycle = 0,5s
 -- change to x"2FAF080" for 50 MHz clock running real FPGA
  counter_half <= x"0000000";
 end if;
end if;
end process;

-- the clk_half_enable inform that the 0,5s counter is done 
clk_half_enable <= '1' when counter_half = x"0000001" else '0'; --x"17D7840" = 0.5s
-- x"2FAF080" for 50Mhz clock on FPGA

end traffic_light;