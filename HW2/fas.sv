// Full Adder/Subtractor template
module fas (
    input logic a,           // Input bit a
    input logic b,           // Input bit b
    input logic cin,         // Carry in
    input logic a_ns,        // A_nS (add/not subtract) control
    output logic s,          // Output S
    output logic cout        // Carry out
);

// ------------------

	logic 	Sum1, 	nSum1, 
			tA, 	nand_tA_B, 		Carry1, 
			tSum1, 	nand_tSum1_cin, Carry2;
	
	// Sum calc
	XNOR2 #(.Tpdlh(8), .Tpdhl(8)) g1 (.A(a), 		.B(b), 		.Z(nSum1));
	XNOR2 #(.Tpdlh(8), .Tpdhl(8)) g2 (.A(nSum1), 	.B(cin), 	.Z(s));
	
	// Carry1 calc
	XNOR2 #(.Tpdlh(8), .Tpdhl(8)) g3 (.A(a), 			.B(a_ns), 		.Z(tA));
	NAND2 #(.Tpdlh(2), .Tpdhl(2)) g4 (.A(tA), 			.B(b), 			.Z(nand_tA_B));
	NAND2 #(.Tpdlh(2), .Tpdhl(2)) g5 (.A(nand_tA_B), 	.B(nand_tA_B), 	.Z(Carry1));
	
	// Carry2 calc
	NAND2 #(.Tpdlh(2), .Tpdhl(2)) g6 (.A(nSum1), 			.B(nSum1), 			.Z(Sum1));
	XNOR2 #(.Tpdlh(8), .Tpdhl(8)) g7 (.A(Sum1), 			.B(a_ns), 			.Z(tSum1));
	NAND2 #(.Tpdlh(2), .Tpdhl(2)) g8 (.A(tSum1), 			.B(cin), 			.Z(nand_tSum1_cin));
	NAND2 #(.Tpdlh(2), .Tpdhl(2)) g9 (.A(nand_tSum1_cin), 	.B(nand_tSum1_cin), .Z(Carry2));
	
	//Carry calc
	OR2 #(.Tpdlh(7), .Tpdhl(7)) g10 (.A(Carry1), .B(Carry2), .Z(cout));

// End of your code

endmodule
