// 2->1 multiplexer template
module mux2 (
    input logic d0,          // Data input 0
    input logic d1,          // Data input 1
    input logic sel,         // Select input
    output logic z           // Output
);

	logic sel_t, sel_d0, sel_d1;

	NAND2 #(.Tpdlh(2), 
			.Tpdhl(2)
			) nand2_inst1 (
				.Z(sel_t),
				.A(sel),
				.B(sel)
			);
	
	NAND2 #(.Tpdlh(2),
			.Tpdhl(2)
			) nand2_inst2 (
				.Z(sel_d0),
				.A(sel_t),
				.B(d0)
			);

	NAND2 #(.Tpdlh(2),
			.Tpdhl(2)
			) nand2_inst3 (
				.Z(sel_d1),
				.A(sel),
				.B(d1)
			);

	NAND2 #(.Tpdlh(2),
			.Tpdhl(2)
			) nand2_inst4 (
				.Z(z),
				.A(sel_d0),
				.B(sel_d1)
			);

endmodule
