// 4->1 multiplexer test bench template
module mux4_test;

    // ------------------ Signal declarations ------------------
    // Gate output wires
    logic z;

    // Gate inputs
    logic d0;
    logic d1;
    logic d2;
    logic d3;
    logic [1:0] sel;

	// ------------------ Gate instantiations ------------------
    // For this gate we override the default delays with: Tpdlh=6, Tpdhl=6
    mux4 mux4_inst (
			.d0(d0),
			.d1(d1),
			.d2(d2),
			.d3(d3),
			.z(z),
			.sel(sel)
		);
	
	initial begin
		d0 = 1'b0;
		d1 = 1'b0;
		d2 = 1'b1;
		d3 = 1'b0;
		sel = 2'b10;
		
		#10
		d0 = 1'b0;
		d1 = 1'b0;
		d2 = 1'b1;
		d3 = 1'b0;
		sel = 2'b11;
		
		#10
		d0 = 1'b0;
		d1 = 1'b0;
		d2 = 1'b1;
		d3 = 1'b0;
		sel = 2'b10;
	end

endmodule
