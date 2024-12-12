// Smart traffic system testbench
module traffic_system_smart(
    input logic clk,
    input logic reset,
    input logic start,
    input logic person_present,
    input logic car_present,
    output logic [1:0] L_out
);

// Enter X and Y here
	localparam X = 7;
	localparam Y = 3;

// Put your code here
// ------------------

    // Outputs of timer module
    logic t_flicker;
    logic t_done;
    
    // Outputs of traffic_light module
    logic t_start;
    logic[4:0] t_length;
    logic t_freeze;

    traffic_light_smart #( 
            .RED_DURATION(5'd20 + X),
            .YELLOW_DURATION(5'd3),
            .GREEN_DURATION(5'd20 + Y)
        ) i_traffic_light (
        .clk(clk),
        .reset(reset),
        .start(start),
        .t_flicker(t_flicker),
        .t_done(t_done),
        .person_present(person_present),
        .car_present(car_present),

        .t_start(t_start),
        .t_length(t_length),
        .t_freeze(t_freeze),
        .L_out(L_out)
    );

    timer_smart i_timer (
        .clk(clk),
        .reset(reset),
        .t_start(t_start),
        .t_length(t_length),
        .t_freeze(t_freeze),

        .t_flicker(t_flicker),
        .t_done(t_done)
    );

// End of your code
endmodule
