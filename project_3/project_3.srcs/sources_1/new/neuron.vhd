-- neuron.vhd
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Thomas Florkowski, Hochschule Bonn-Rhein-Sieg, 21.04.2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity neuron is -- 
  generic ( w1 : integer; -- defines the values of the weights and bias from trained models in the form of integers
            w2 : integer;
            w3 : integer;
            bias : integer);
                
  port    ( clk : in std_logic; -- defines clk as a std_logic clock signal, x1-x3 as integer inputs from ther programs
            x1 : in integer;
            x2 : in integer;
            x3 : in integer;
            output : out integer := 0); -- declares output
end neuron;

architecture behave of neuron is --architecture defines behavior, "behave" is the archeticure of the "neuron"
    
    signal sum : integer; -- defines sum as a signal of type integer
    signal sumAdress : std_logic_vector(15 downto 0); -- defines sumAdress as an std_logic_vecotr signal with length 16
    signal afterActivation : std_logic_vector(7 downto 0); -- defines afterActivation as std_logic_vecotr signal with length 8
begin
    
process
begin
    wait until rising_edge(clk); -- waits for rising edge
    
    -- sum of input with factors and bias
    sum <= (w1 * x1 + w2 * x2 + w3 * x3 + bias); -- sums all of the input from the hidden layer * by the weight + bias
    
    -- limiting and invoking ROM for sigmoid
    if (sum < -32768) then
        sumAdress <= (others => '0'); 
    elsif (sum > 32767) then
        sumAdress <= (others => '1');
    else 
        sumAdress <= std_logic_vector(to_unsigned(sum + 32768, 16)); -- converst sum to an unsigned 16 bit integer
    end if;
end process;     

sigmoid : entity work.sigmoid_IP  -- calls on sigmoid_IP
    port map (clock   => clk, -- clk to clock
              address => sumAdress(15 downto 2), -- sum to address
              q       => afterActivation); --  after to Q
                  
    -- format conversion
    output <= to_integer(unsigned(afterActivation)); -- output is unsigned integer of afterActivation

end behave;