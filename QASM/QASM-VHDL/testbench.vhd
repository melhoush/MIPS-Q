library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.complex_pkg.all;
use work.quantum_systems.all;

use work.txt_util.all;

entity testbench is
  generic
  (
    mem_file: string  :=  "program.mem";
    log_file: string  :=  "res.log"
  );
end;

architecture test of testbench is
  file stimulus: TEXT open read_mode is mem_file;
  file l_file: TEXT open append_mode is log_file;
  
  signal qopcode : unsigned(5 downto 0);
  signal address1, address2: unsigned(4 downto 0);
  signal parameter1: signed(4 downto 0);
  signal clock:std_logic;
  signal reset: std_logic := '1';
  signal exec: std_logic := '0';
  signal counter: integer := 0;
  signal number_of_instructions: integer := 0;
  signal measurement_reg : unsigned(qubit_memory_length-1 downto 0);
  
  type inst_vector  is array (natural range<>) of std_logic_vector(31 downto 0);
  signal inst_memory: inst_vector(0 to 20);
    
begin
  qprocessor1:entity work.qprocessor port map(qopcode, parameter1, address1, address2, clock, reset, exec, measurement_reg);  
   
  process
    variable l: line;
    variable count: integer := 0;
    variable instruction: std_logic_vector(31 downto 0);
  begin
    while not endfile(stimulus) loop
      readline(stimulus, l);
      hread(l, instruction); 
      inst_memory(count) <= instruction;
      count := count + 1;
    end loop;
    number_of_instructions <= count;
    wait;
  end process;
  
  process(clock,reset) is
    variable pc: integer := 0;
  begin
    if(rising_edge(clock)) then
      if(reset='1') then      
      else
        counter <= counter + 1;
        if pc < number_of_instructions then
          if(counter mod 5 = 0) then
            exec <= '1';
            qopcode <= unsigned(inst_memory(pc)(31 downto 26));
            parameter1 <= signed(inst_memory(pc)(25 downto 21));
            address1 <= unsigned(inst_memory(pc)(20 downto 16));
            address2 <= unsigned(inst_memory(pc)(15 downto 11));
            pc := pc + 1;
          else
            exec <= '0';
          end if;
        else
          exec <= '0';
        end if;
      end if;
    end if;
  end process;
  
  process
  begin
      clock <= '0';
       wait for 30 ns;
       clock <= '1';
       wait for 30 ns;
   end process;
   
   process
   begin
     reset <= '1';
     wait for 100 ns;
     reset <= '0';
     wait;
   end process;
   
   process
   variable l: line;
   begin
      wait for 2000 ns;
      write(l, str(std_logic_vector(measurement_reg)));
      writeline(l_file, l);
  end process;
              
end;
