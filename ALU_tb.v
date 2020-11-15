`timescale 1ns/ 1ps



//Test bench
//Arithmetic Logic Unit
/*
* INPUT: A, B
* op: 00, A PLUS B
* op: 01, A AND B
* op: 10, A OR B
* op: 11, A XOR B
* OUTPUT A op B
* equal: is A == B?
* even: is the output even?
*/


module ALU_tb;
reg [ 7:0] INPUTA;     	  // data inputs
reg [ 7:0] INPUTB;
reg [ 2:0] op;		// ALU opcode, part of microcode
wire[ 7:0] OUT;		  

  wire zero;    
 
 reg [ 7:0] expected;
 
// CONNECTION
ALU uut(
  .INPUTA(INPUTA),      	  
  .INPUTB(INPUTB),
  .OP(op),				  
  .Out(OUT),		  			
  .zero(zero)
    );
	 
initial begin


	INPUTA = 8'b00101101;
	INPUTB = 8'b10110100;  //expected 0100 0010
	op= 'b011; // NOR
	test_alu_func; // void function call
	#5;
	
	
	INPUTA = 8'b01011100;
	INPUTB = 8'b00000100; //shift left by 4, expected = 1100 0000
	op= 'b001; // shift
	test_alu_func; // void function call
	#5;
	
	INPUTA = 8'b01011100;
	INPUTB = 8'b00001100; //right shift by 4, expected = 0000 0101
	op= 'b001; // shift
	test_alu_func; // void function call
	#5;
	
	INPUTA = 8'b01011100; //92
	INPUTB = 8'b00001001; // expected = 0
	op= 'b010; // bneg
	test_alu_func; // void function call
	#5;
	
	INPUTA = 8'b11011100; //-36
	INPUTB = 8'b00001001; // expected = 0
	op= 'b010; // bneg
	test_alu_func; // void function call
	#5;
	
	INPUTA = 8'b00011100; //28
	INPUTB = 8'b00001001; //9 expected = 10 0101
	op= 'b010; // add
	test_alu_func; // void function call
	#5;
	
	INPUTA = 8'b00011100; //28
	INPUTB = 8'b10001001; //-119 expected = (-91) 1010 0101
	op= 'b010; // add
	test_alu_func; // void function call
	#5;
	end
	
	
	/*
		3'b1xx: out = INPUTA + INPUTB; 	// All R-type operations (besides shift)
		3'b011: out = !(INPUTA | INPUTB); // Nor
		3'b001: out = (INPUTB[3] == 1'b0) ? INPUTA << INPUTB[3:0] : INPUTA >>> INPUTB[3:0]  ;				// Shift 
		3'b010: out = (INPUTA < 8'b0) ? 8'b0 : 8'b1;	//bneg
	*/
	task test_alu_func;
	begin
	  case (op)
		'b001: begin
			expected = (INPUTB[3:0] > 0) ? INPUTA << INPUTB[3:0] : INPUTA >>> INPUTB[3:0];
		end
		'b011: expected = !(INPUTA | INPUTB); // Nor;
		'b010: expected = (INPUTA < 8'b0) ? 8'b0 : 8'b1;	//bneg
		'b100: expected = INPUTA + INPUTB;
	  endcase
	  #1; if(expected == OUT)
		begin
			$display("%t YAY!! inputs = %b %b, opcode = %b, zero %b, out = %b",$time, INPUTA,INPUTB,op, zero, out);
		end
	    else begin $display("%t FAIL! inputs = %b %b, opcode = %b, zero = %b, out = %b ",$time, INPUTA,INPUTB,op, zero, out);end
		
	end
	endtask



endmodule