module traffic_system(
    input logic clk,
    input logic reset,
    input logic start,
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

    traffic_light #( 
            .RED_DURATION(5'd20 + X),
            .YELLOW_DURATION(5'd3),
            .GREEN_DURATION(5'd20 + Y)
        ) i_traffic_light (
        .clk(clk),
        .reset(reset),
        .start(start),
        .t_flicker(t_flicker),
        .t_done(t_done),

        .t_start(t_start),
        .t_length(t_length),
        .L_out(L_out)
    );

    timer i_timer (
        .clk(clk),
        .reset(reset),
        .t_start(t_start),
        .t_length(t_length),

        .t_flicker(t_flicker),
        .t_done(t_done)
    );


// end of your code
endmodule
