// Full Adder/Subtractor test bench template
module fas_test;

    // ------------------ Signal declarations ------------------
    // Gate output wires
    logic s;
    logic cout;

    // Gate inputs
    logic a;
    logic b;
    logic cin;
    logic a_ns;

    // ------------------ Gate instantiations ------------------
    fas fasI (
			.a(a),
			.b(b),
			.cin(cin),
			.a_ns(a_ns),
			.s(s),
			.cout(cout)
		);
	
	initial begin
        // ==== Longest path to S & Longest path to Cout
        a = 1'b0;
		b = 1'b0;
		cin = 1'b1;
		a_ns = 1'b0;

        // Longest path to s takes 16, but to Cout takes 29
        #29
        a = 1'b1;
		b = 1'b0;
		cin = 1'b1;
		a_ns = 1'b0;

        #29
        a = 1'b0;
		b = 1'b0;
		cin = 1'b1;
		a_ns = 1'b0;

	end

endmodule
