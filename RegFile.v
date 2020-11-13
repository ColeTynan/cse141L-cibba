// Module Name:    RegFile 
// Project Name:   CSE141L
//
// Revision Fall 2020
// Based on SystemVerilog source code provided by John Eldon
// Comment:
// This module is your register file.
// If you have more or less bits for your registers, update the value of D.
// Ex. If you only supports 8 registers. Set D = 3

/* parameters are compile time directives 
       this can be an any-size reg_file: just override the params!
*/
module RegFile (clk,write_en,RaddrA,RaddrB,Waddr,data_in,data_out_a,data_out_b);
	parameter W=8, D=4;  // W = data path width (Do not change); D = pointer width (You may change)
	input                clk,
						 write_en;
	input        [D-1:0] RaddrA,				  // address pointers
						 RaddrB,
						 Waddr;
	input        [W-1:0] data_in;
	output reg   [W-1:0] data_out_a;			  
	output reg   [W-1:0] data_out_b;				

// W bits wide [W-1:0] and 2**4 registers deep 	 
reg [W-1:0] Registers[(2**D)-1:0];	  // or just registers[16-1:0] if we know D=4 always



// NOTE:
// READ is combinational
// WRITE is sequential

always@*
begin
 data_out_a = Registers[RaddrA];	  
 data_out_b = Registers[RaddrB];    
end

// sequential (clocked) writes 
always @ (posedge clk)
  if (write_en)	                             // works just like data_memory writes
    Registers[Waddr] <= data_in;

endmodule
