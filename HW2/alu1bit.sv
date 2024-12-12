// 1-bit ALU template
module alu1bit (
    input logic a,           // Input bit a
    input logic b,           // Input bit b
    input logic cin,         // Carry in
    input logic [1:0] op,    // Operation
    output logic s,          // Output S
    output logic cout        // Carry out
);

// Put your code here
// ------------------
	logic 	fasOut, xnorAB, xorAB, orAB, norAB;
	
	// Get opposite of op[0]
	// 10 -> ADD -> Need a_ns = 1 = ~op[0], 11 -> SUB -> Need a_ns = 0 = ~op[0]
	NAND2 	#(.Tpdlh(2), .Tpdhl(2)) g1 (.A(op[0]), 	.B(op[0]), 	.Z(nLSB));
	fas 							g2 (.a(a), 		.b(b), 		.cin(cin), 
										.a_ns(nLSB),.s(fasOut), .cout(cout));
										
	// Get xor(A,B)
	XNOR2 	#(.Tpdlh(8), .Tpdhl(8)) g3 (.A(a), 		.B(b), 		.Z(xnorAB));
	NAND2 	#(.Tpdlh(2), .Tpdhl(2)) g4 (.A(xnorAB), .B(xnorAB), .Z(xorAB));
	
	// Get nor(A,B)
	OR2 	#(.Tpdlh(7), .Tpdhl(7)) g5 (.A(a), 		.B(b), 		.Z(orAB));
	NAND2 	#(.Tpdlh(2), .Tpdhl(2)) g6 (.A(norAB), 	.B(norAB), 	.Z(norAB));
	
	// Choose between the values
	mux4 							g7 (.d0(orAB), 	.d1(xnorAB),
										.d2(fasOut), .d3(fasOut), 
										.z(s), .sel(op));

// End of your code

endmodule
