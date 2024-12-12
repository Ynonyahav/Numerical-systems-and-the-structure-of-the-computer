//traffic system testbench

module traffic_system_tb;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Light start signal
    logic[1:0] L_out;

// Put your code here
// ------------------

    localparam TIME_UNIT = 1ps;
    localparam CLOCK_CYCLE = 2 * TIME_UNIT;
    localparam FINAL_RUN_TIME = 500 * CLOCK_CYCLE;

    traffic_system its (
        .clk(clk),
        .reset(reset),
        .start(start),
        .L_out(L_out)
    );

    // Clock
    always begin
        #(TIME_UNIT) clk = ~clk; // Chose time-unit = 5ns
    end

    initial begin
        // Initialize signals
        clk = 1'b0;
        reset = 1'b0;

        // (1) - reset: 0->1 - 5 cycles - reset: 1->0
        reset = 1'b1;
        #(5 * CLOCK_CYCLE);
        reset = 1'b0;

        // (2) - start: ?->0 - 5 time-units
        start = 1'b0;
        #(5 * TIME_UNIT);

        // (3) - start: 0->1 - 10 time-units - start: 1->0
        start = 1'b1;
        #(10 * TIME_UNIT);
        start = 1'b0;

        // (4) - Run through traffic_light run
        #(FINAL_RUN_TIME);

    end

//N
// End of your code
endmodule
