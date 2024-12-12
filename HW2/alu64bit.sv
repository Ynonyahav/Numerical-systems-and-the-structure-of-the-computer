// 64-bit ALU template
module alu64bit (
    input logic [63:0] a,    // Input bit a
    input logic [63:0] b,    // Input bit b
    input logic cin,         // Carry in
    input logic [1:0] op,    // Operation
    output logic [63:0] s,   // Output S
    output logic cout        // Carry out
);

// Put your code here
// ------------------
logic [62:0] chainCarry;

alu1bit alu_0  (	.a(a[0]), 	.b(b[0]), 
					.cin(cin),
					.op(op), 	.s(s[0]), 
					.cout(chainCarry[0]));

genvar i;
	generate
		for (i = 0; i < 62; i++)
		begin
			alu1bit inst (	.a(a[i+1]), .b(b[i+1]), 
							.cin(chainCarry[i]),
							.op(op), 	.s(s[i+1]), 
							.cout(chainCarry[i+1]));
		end
	endgenerate

alu1bit alu_63 (	.a(a[63]), 	.b(b[63]), 
					.cin(chainCarry[62]),
					.op(op), 	.s(s[63]), 
					.cout(cout));

// End of your code

endmodule
