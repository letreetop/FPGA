-- sharp_control.vhd
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Marco Winzker, Hochschule Bonn-Rhein-Sieg, 22.05.2020

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is --declares an entity named control that is like a hardware block that represents inputs and outputs
  generic ( delay : integer := 7 ); -- creates a delay parameter with a default value of 7, this is how many cycles the input signals will be delayed
  port ( clk       : in  std_logic;  -- "in" is input delcaration with the varying variable names, std_logic is a digital logic signal
         reset     : in  std_logic;	
         vs_in     : in  std_logic;
         hs_in     : in  std_logic;
         de_in     : in  std_logic;
         vs_out    : out std_logic; -- "out" is output declaration with varying variable names.
         hs_out    : out std_logic;
         de_out    : out std_logic);
end control; -- ends function/entity

architecture behave of control is -- begins the archeticture declaration named "behave' for the entity control.


  type delay_array is array (1 to delay) of std_logic; -- defines an array called delay_array and has a length of 1 to delay of the std_logic signal
  signal vs_delay : delay_array; -- creates a signal that is an array like delay_array and has std_logic signal
  signal hs_delay : delay_array;
  signal de_delay : delay_array;

begin --marks start

  process --starts code that executes sequentially
  begin -- marks start
    wait until rising_edge(clk); --waits for the rising edge of "clk"

     -- first value of array is current input
     vs_delay(1) <= vs_in; -- this assigned the first element in vs_delay to vs_in
     hs_delay(1) <= hs_in; -- this assigned the first element in hs_delay to hs_in
     de_delay(1) <= de_in; -- this assigned the first element in de_delay to de_in

    -- delay according to generic
    for i in 2 to delay loop
      vs_delay(i) <= vs_delay(i-1); -- this shifts the vs_delay signal by one position
      hs_delay(i) <= hs_delay(i-1);
      de_delay(i) <= de_delay(i-1);
    end loop;

  end process;

  -- last value of array is output
  vs_out <= vs_delay(delay); -- output of the signals is the last value in the vs_delay signal.
  hs_out <= hs_delay(delay);
  de_out <= de_delay(delay);

end behave;
-- in my opinion, this just controls the clock signals that are used elsewhere in the VHDL program, unsure right now why the signals are delayed.