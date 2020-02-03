library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;  
-----------------------------------------------------------------------------------------------------------------------------
entity traffic_light_controller is
 port ( sensor  : in STD_LOGIC; -- night sensor 
        clk  : in STD_LOGIC; -- clock 
        rst  : in STD_LOGIC; -- reset  
        prior  : out STD_LOGIC_VECTOR(2 downto 0); -- light outputs of prior way RYG
        normal:    out STD_LOGIC_VECTOR(2 downto 0)-- light outputs of normal way
     --RED_YELLOW_GREEN 
   );
end traffic_light_controller;
------------------------------------------------------------------------------------------------------------------------------------
architecture traffic_light of traffic_light_controller is
signal counter_half: std_logic_vector(27 downto 0):= x"0000000";  -- count 1 second
signal delay_count:std_logic_vector(7 downto 0):= x"00";         -- number of time the couter_1s is count
signal delay_half, delay_5s, delay_20s, delay_60s, GREEN_LIGHT_ENABLE_P, GREEN_LIGHT_ENABLE_N, YELLOW_LIGHT_ENABLE, NIGHTMODE_ENABLE: std_logic:='0';
signal clk_half_enable: std_logic; -- 1s clock enable 
type FSM_States is (nGpR, nYpR, nRpG, nRpY, nightmode1, nightmode2);
-- nGpR normal way GREEN -- prior way RED 
-- nYpR normal way YELLOW -- prior way RED
-- nRpG normal way RED -- prior way GREEN
-- nRpY normal way RED -- prior way YELLOW
-- nightmode1 YELLOW on both lane
-- nightmode2 turn off all
signal current_state, next_state: FSM_States;
begin

-- next state FSM sequential logic 
process(clk,rst) 
begin
if(rst='1') then
 current_state <= nRpG ;
elsif(rising_edge(clk)) then 
 current_state <= next_state; 
end if; 
end process;

-- FSM combinational logic 
process(current_state,sensor, delay_5s, delay_20s, delay_60s, delay_half)
begin
case current_state is 

when nGpR => -- When normal way GREEN -- prior way RED 
 GREEN_LIGHT_ENABLE_N <= '1';-- enable Green light delay on normal way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior way counting
 YELLOW_LIGHT_ENABLE <= '0';-- disable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '0';
 normal <= "001"; -- Green light on normal way RYG
 prior <= "100"; -- Red light on Farm way 
 if(sensor = '1') then -- if nightmode1 activated
  next_state <= nightmode1; 
 elsif(delay_20s = '1') then
  next_state <= nYpR;
 else 
  next_state <= nGpR; 
  -- Otherwise, remains the current condition
 end if;
 
when nYpR => -- When normal way YELLOW -- prior way RED 
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on normal way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior way counting
 YELLOW_LIGHT_ENABLE <= '1';-- enable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '0';
 normal <= "010"; -- yellow light on normal way RYG
 prior <= "100"; -- Red light on Farm way 
 if(sensor = '1') then -- if nightmode1 activated
  next_state <= nightmode1; 
 elsif(delay_5s = '1') then
  next_state <= nRpG;
 else 
  next_state <= nYpR; 
  -- Otherwise, remains the current condition
 end if;
 
when nRpG => -- When normal way RED -- prior way GREEN 
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on normal way counting
 GREEN_LIGHT_ENABLE_P <= '1';-- enable Green light delay on prior way counting
 YELLOW_LIGHT_ENABLE <= '0';-- disable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '0';
 normal <= "100"; -- red light on normal way RYG
 prior <= "001"; -- green light on Farm way 
 if(sensor = '1') then -- if nightmode1 activated
  next_state <= nightmode1; 
 elsif(delay_60s = '1') then
  next_state <= nRpY;
 else 
  next_state <= nRpG; 
  -- Otherwise, remains the current condition
 end if;
 
when nRpY => -- When normal way RED -- prior way YELLOW 
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on normal way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior way counting
 YELLOW_LIGHT_ENABLE <= '1';-- enable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '0';
 normal <= "100"; -- red light on normal way RYG
 prior <= "010"; -- green light on Farm way 
 if(sensor = '1') then -- if nightmode1 activated
  next_state <= nightmode1; 
 elsif(delay_5s = '1') then
  next_state <= nGpR;
 else 
  next_state <= nRpY; 
  -- Otherwise, remains the current condition
 end if;
 
 when nightmode1 => -- YELLOW on both lane
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on normal way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior way counting
 YELLOW_LIGHT_ENABLE <= '0';-- enable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '1';-- enable NIGHTMODE
 normal <= "010";	-- YELLOW on both lane
 prior <= "010";
 if(sensor = '0') then 
	next_state <= nGpR;
 elsif(delay_half = '1') then
	next_state <= nightmode2;
 else 
	next_state <= nightmode1;
 end if;
 
 when nightmode2 => -- all turned off
 GREEN_LIGHT_ENABLE_N <= '0';-- disable Green light delay on normal way counting
 GREEN_LIGHT_ENABLE_P <= '0';-- disable Green light delay on prior way counting
 YELLOW_LIGHT_ENABLE <= '0';-- enable YELLOW light delay counting
 NIGHTMODE_ENABLE <= '1';-- enable NIGHTMODE
 normal <= "000";	-- YELLOW on both lane
 prior <= "000";
 if(sensor = '0') then 
	next_state <= nGpR;
 elsif(delay_half = '1') then
	next_state <= nightmode1;
 else 
	next_state <= nightmode2;
 end if;

when others => next_state <= nGpR; -- Green on normal,red on prior

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
 if(counter_half >= x"17D7840") then -- x"0004" is for simulation
 -- change to x"2FAF080" for 50 MHz clock running real FPGA
  counter_half <= x"0000000";
 end if;
end if;
end process;
-- the clk_half_enable inform that the 0,5s counter is done 
clk_half_enable <= '1' when counter_half = x"17D7840" else '0'; --x"17D7840" = 0.5s
-- x"2FAF080" for 50Mhz clock on FPGA

end traffic_light;