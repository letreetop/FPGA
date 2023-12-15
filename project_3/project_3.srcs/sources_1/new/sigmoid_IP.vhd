library ieee;
use ieee.std_logic_1164.all;

entity sigmoid_IP is
  port (
    clock   : in std_logic;
    addr  : in std_logic_vector(13 downto 0);
    dout  : out std_logic_vector(7 downto 0)
  );
end sigmoid_ip;

architecture behavioral of sigmoid_IP is

  component blk_mem_gen_0 is
    port (
      clocka  : in std_logic;
      addra : in std_logic_vector(13 downto 0);
      douta : out std_logic_vector(7 downto 0)
    );
  end component;

begin

  rom: blk_mem_gen_0
    port map (
      clocka  => clock,
      addra => addr,
      douta => dout
    );

end behavioral;