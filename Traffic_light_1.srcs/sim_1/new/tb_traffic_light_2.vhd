----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2019 11:01:54 AM
-- Design Name: 
-- Module Name: tb_traffic_light_2 - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_traffic_light_2 is
--  Port ( );
end tb_traffic_light_2;

architecture Behavioral of tb_traffic_light_2 is
	component traffic_light_controller is
	port ( sensor  : in STD_LOGIC; -- night sensor 
        clk  : in STD_LOGIC; -- clock 
        rst  : in STD_LOGIC; -- reset  
        prior_way  : out STD_LOGIC_VECTOR(2 downto 0); -- light outputs of the prior way  
        way_1:out STD_LOGIC_VECTOR(2 downto 0);-- light outputs of the first way  
		way_2:out STD_LOGIC_VECTOR(2 downto 0);-- light outputs of the second way
		way_3:out STD_LOGIC_VECTOR(2 downto 0)-- light outputs of the third way 
   );
end component;
	signal sensor: STD_LOGIC := '0'; -- night sensor 
    signal clk  :  STD_LOGIC := '0'; -- clock 
    signal rst  :  STD_LOGIC := '0'; -- reset  
    signal prior_way : STD_LOGIC_VECTOR(2 downto 0) ; 
    signal way_1: STD_LOGIC_VECTOR(2 downto 0) ;
	signal way_2: STD_LOGIC_VECTOR(2 downto 0) ;
	signal way_3: STD_LOGIC_VECTOR(2 downto 0) ;
begin
    uut: traffic_light_controller port map (sensor, clk, rst, prior_way, way_1, way_2, way_3);
                                          
	clk <= not clk AFTER 10ns;
	rst <= not rst AFTER 5000ns;
	sensor <= not sensor AFTER 4800ns;
end Behavioral;