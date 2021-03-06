-------------------------------------------------------------------------------
--
--  MYRISC project in SME052 by
--
--  Anders Wallander
--  Department of Computer Science and Electrical Engineering
--  Lule� University of Technology
--  
--  A VHDL implementation of the MIPS RISC processor described in 
--  Computer Organization and Design by Patterson/Hennessy
--
--
--  These routines are taken from the simulation files to the Wildone
--  FPGA board by Anapolis Micro Systems Inc.
--  Copyright (C) 1996-1998 Annapolis Micro Systems, Inc.
--
-------------------------------------------------------------------------------
library IEEE, STD;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

library Work;
use Work.RiscPackage.all;

package MempartPackage is	
	
	constant RAM_Access_Time : Time := 10 ns;
	constant RAM_Turnoff_Time: Time := 3 ns;
	
		
	function Equal( L,R : unsigned ) return BOOLEAN;	
	
  	--function Is_X( L : unsigned ) return BOOLEAN;
	
	procedure Skip_Over_Token ( variable L : in line; pos : inout integer );
	procedure Skip_white ( variable L : in line; pos : inout integer );
	procedure Shrink_line ( L : inout line; pos : in integer );	
	procedure Read_Hex ( L:inout line; Value: out bit_vector; GOOD : out boolean );
	procedure Read_Hex ( L:inout line; variable Value: out std_logic_vector; GOOD : out boolean );	

	procedure Load_Mem(File_Name: in String;
			Head: inout TypeArrayWord;
			Cleared_Flag: inout Boolean;
			Cleared_Val: inout TypeWord );
	
end package MempartPackage;


package body MempartPackage is


	
	-- This function was taken from the DLX project
	
	function Equal( L,R : unsigned ) return BOOLEAN is
		alias LV : unsigned ( 1 to L'length ) is L;
		alias RV : unsigned ( 1 to R'length ) is R;
		variable Result : BOOLEAN := true;
	begin
		if( L'length /= R'length ) then
			assert false
			report "arguments of 'Equal' function are not of the same length"
			severity failure;
		else
			for i in LV'range loop
				if Result = true then
					if LV(i) /= RV(i) then
						Result := false;
					end if;
				else return false; end if;
			end loop;
		end if;
		return Result;
	end Equal;
	
--  function Is_X( L : unsigned ) return BOOLEAN is
--    alias LV : unsigned ( 1 to L'length ) is L;		
--    variable Result : BOOLEAN := true;
--  begin
--    for i in LV'range loop
--      if Result = true then
--        if LV(i) /= '0' or LV(i) /= '1' then
--          Result := false;
--        end if;
--      else return false; end if;
--    end loop;		
--    return Result;
--  end Is_X;
		--  procedure to skip over non-white space
	procedure Skip_Over_Token ( variable L : in line; pos : inout integer ) is
	begin
		while ( pos <= L'high ) loop
			case L(pos) is
				when ' ' | HT  =>
					exit;
				when others =>
					pos := pos + 1;
			end case;
		end loop;
	end;

	-- procedure to read over white space between data bits and tag bits
	procedure Skip_White(variable L : in line; pos : inout integer) is
	begin
		while ( pos <= L'high ) loop
			case L ( pos ) is
				when ' ' | HT  =>
					pos := pos + 1;
				when others =>
					exit;
			end case;
		end loop;
	end;
	
	-- procedure to dealocate space for a line type
	procedure Shrink_Line ( L : inout line; pos : in integer ) is 
		variable old_L : line := L;
	begin
		if pos > 1 then
			L := new string'( old_L ( pos to old_L'high ) );
			Deallocate ( old_L );
		end if;
	end;
	
	-- Hex number reading
	procedure Read_Hex(
	                   L:inout line; 
	                   Value: out bit_vector; 
	                   GOOD : out boolean
	                  ) is
		alias    val  : bit_vector ( 1 to Value'length ) is Value;
		variable vpos : integer := 0; -- Index of last valid bit in val.
		variable lpos : integer; -- Index of next unused char in L.

	begin

		if ( L /= NULL ) then
			lpos := L'left;
			Skip_white ( L, lpos );
			while ( ( lpos <= L'right ) and ( vpos < ( Value'length / 4 ) ) ) loop
				vpos := vpos + 1;
				case L ( lpos ) is
					when '0' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0000";
					when '1' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0001";
					when '2' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0010";
					when '3' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0011";
					when '4' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0100";
					when '5' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0101";
					when '6' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0110";
					when '7' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0111";
					when '8' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1000";
					when '9' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1001";
					when 'a' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1010";
					when 'A' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1010";
					when 'b' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1011";
					when 'B' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1011";
					when 'c' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1100";
					when 'C' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1100";
					when 'd' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1101";
					when 'D' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1101";
					when 'e' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1110";
					when 'E' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1110";
					when 'f' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1111";
					when 'F' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1111";
					when others =>
						exit;
				end case; 
				lpos := lpos + 1;
			end loop;
		end if;

		if vpos = (Value'length / 4) then
			GOOD := TRUE;
			Shrink_line(L, lpos);
		else
			GOOD := FALSE;
		end if;

	end;

	-- Hex number reading
	procedure Read_Hex(
	                   L:inout line; 
	                   variable Value: out std_logic_vector; 
	                   GOOD : out boolean
	                  ) is
		alias    val  : std_logic_vector ( 1 to Value'length ) is Value;
		variable vpos : integer := 0; -- Index of last valid bit in val.
		variable lpos : integer; -- Index of next unused char in L.

	begin

		if ( L /= NULL ) then
			lpos := L'left;
			Skip_white ( L, lpos );
			while ( ( lpos <= L'right ) and ( vpos < ( Value'length / 4 ) ) ) loop
				vpos := vpos + 1;
				case L ( lpos ) is
					when '0' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0000";
					when '1' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0001";
					when '2' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0010";
					when '3' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0011";
					when '4' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0100";
					when '5' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0101";
					when '6' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0110";
					when '7' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "0111";
					when '8' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1000";
					when '9' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1001";
					when 'a' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1010";
					when 'A' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1010";
					when 'b' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1011";
					when 'B' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1011";
					when 'c' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1100";
					when 'C' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1100";
					when 'd' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1101";
					when 'D' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1101";
					when 'e' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1110";
					when 'E' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1110";
					when 'f' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1111";
					when 'F' =>
						val ( ( ( vpos * 4 ) - 3 ) to ( vpos * 4 ) ) := "1111";
					when others =>
						exit;
				end case; 
				lpos := lpos + 1;
			end loop;
		end if;

		if vpos = (Value'length / 4) then
			GOOD := TRUE;
			Shrink_line(L, lpos);
		else
			GOOD := FALSE;
		end if;

	end;
	
		------------------------------------
	--
	--  load_mem
	--
	--  This procedure initializes the
	--  memory array pointed to by Head
	--  with the contents of File_Name.
	--  The "cleared" status us returned
	--  in the variable Cleared_Flag.
	--
	------------------------------------
	procedure Load_Mem(File_Name: in String;
			Head: inout TypeArrayWord;
			Cleared_Flag: inout Boolean;
			Cleared_Val: inout TypeWord ) is
	
		variable Input_Line: LINE;
		file input_file : TEXT open READ_MODE is File_Name;
		variable lpos: Integer := 0;
		variable Address: Integer := 0;
		variable Data: std_logic_vector(32-1 downto 0) := (others => '0');
		variable Good: Boolean;

	begin
		while ( not ( endfile ( input_file ) ) ) loop

			readline ( input_file, Input_Line );

			-- Skip blank line 
			next when ( Input_Line'length < 1 );

			-- Skip comment line 
			next when ( ( Input_Line'length > 1 )
				and Input_Line ( 1 to 2 ) = "--" ); 

			lpos := Input_Line'left;
			Skip_White ( Input_Line, lpos );

			-- Look for the key word "fill"
			if ( ( Input_Line'length > lpos + 2 ) and
					( Input_Line ( lpos to lpos + 3 ) = "fill" ) ) then
				Cleared_Flag := True;
				Skip_Over_Token(Input_Line, lpos);
				Skip_White(Input_Line, lpos);
				Shrink_Line(Input_Line, lpos);
				if (Input_Line'length < 8) then
					assert false report "Error in fill statement"
						severity ERROR;
				else
					Read_Hex(Input_Line, Data, Good);
					for i in Head'range loop
						Head(i) := unsigned(Data);
					end loop;
				end if;

			-- Look for the key word "clear"
			elsif ( ( Input_Line'length > lpos + 3 ) and
					( Input_Line ( lpos to lpos + 4 ) = "clear" ) ) then
				Cleared_Flag := True;
					for i in Head'range loop
						Head(i) := (others => '0');
					end loop;
 
				-- The base address follows the word "address"
			elsif ((Input_Line'Length > lpos + 5) and
					(Input_Line(lpos to lpos+3) = "addr")) then
				Skip_Over_Token(Input_Line, lpos);
				Skip_White(Input_Line, lpos);
				Shrink_Line(Input_Line, lpos);
				read(Input_Line, Address, Good);
				assert Good
					report "Error in address statement"
					severity ERROR;
			else
				Read_Hex(Input_Line, Data, Good);
				while (Good = True) loop
  
				-- Good data, write it to memory
				Head(Address) := unsigned(Data);

				-- Increment counter and see if there's more data on the line
				Address := Address + 1;
				Read_Hex(Input_Line, Data, Good);
				end loop;

			end if;

		end loop;

	end Load_Mem;
	
end package body;


