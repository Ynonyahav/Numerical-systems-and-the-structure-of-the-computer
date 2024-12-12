// 4->1 multiplexer template
module mux4 (
    input logic d0,          // Data input 0
    input logic d1,          // Data input 1
    input logic d2,          // Data input 2
    input logic d3,          // Data input 3
    input logic [1:0] sel,   // Select input
    output logic z           // Output
);

// ------------------

	logic mux_d0_d1; 
	logic mux_d2_d3;

	mux2 mux2_inst1 (
				.z(mux_d0_d1),
				.sel(sel[0]),
				.d0(d0),
				.d1(d1)
			);

	mux2 mux2_inst2 (
				.z(mux_d2_d3),
				.sel(sel[0]),
				.d0(d2),
				.d1(d3)
			);

	mux2 mux2_inst3 (
				.z(z),
				.sel(sel[1]),
				.d0(mux_d0_d1),
				.d1(mux_d2_d3)
			);

endmodule
