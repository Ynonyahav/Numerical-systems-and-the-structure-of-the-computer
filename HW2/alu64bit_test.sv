// 64-bit ALU test bench template
module alu64bit_test;

// Put your code here
// ------------------
    logic [63:0] A;
	logic [63:0] B;
	logic CIN;
	logic [1:0] OP;

	logic [63:0] S;
	logic COUT;



	alu64bit alu(.a(A), .b(B), .cin(CIN), .op(OP), .cout(COUT), .s(S));
	
	initial begin
	A = 64'h0000000000000000;
	CIN = 1'b0;
	B = ~0;
	OP = 2'b11;
	#719
	OP = 2'b10;
	#719
	OP = 2'b11;
	#719

	$stop;
	end

// End of your code

endmodule
