// Smart traffic system testbench
module traffic_system_smart_tb;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Light start signal
	logic person_present;	  // Is there a person trying to enter
	logic car_present;		  // Is there a car trying to enter
    logic[1:0] L_out;

// Put your code here
// ------------------

    localparam TIME_UNIT = 1ps;
    localparam CLOCK_CYCLE = 2 * TIME_UNIT;
    localparam FINAL_RUN_TIME = 500 * CLOCK_CYCLE;

    traffic_system_smart its (
        .clk(clk),
        .reset(reset),
        .start(start),
        .person_present(person_present),
        .car_present(car_present),
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

        // (1) - reset: 0->1, start: ?->0 - 5 cycles - reset: 1->0
        reset = 1'b1;
        start = 1'b0;
        #(5 * CLOCK_CYCLE);
        reset = 1'b0;

        // (2) - start: 0->1 - 10 time-units - start: 1->0
        start = 1'b1;
        #(10 * TIME_UNIT); // = 5 * CLOCK_CYCLE
        start = 1'b0;

        // (3) - person_present: ?->1, car_present: ?->0 - 5 time-units
        person_present = 1'b1;
        car_present = 1'b0;
        #(5 * TIME_UNIT)

        // (4) - person_present: 1->0, car_present: 0->1 - until state is green_st - car_present: 1->0
        car_present = 1'b1;
        person_present = 1'b0;
        #(5 * TIME_UNIT);
        while (its.i_traffic_light.current_state != its.i_traffic_light.green_st) begin
            @(its.i_traffic_light.current_state);
        end
        car_present = 1'b0;
        

        // (5) - Run through traffic_light run
        #(FINAL_RUN_TIME);

    end

// End of your code
endmodule
