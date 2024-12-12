// traffic light module

module traffic_light(
    //inputs
    input logic clk, // Clock
    input logic reset, // Reset
    input logic start, // Start signal
    input logic t_flicker,
    input logic t_done,

    //outputs
    output logic t_start,
    output logic[4:0] t_length,
    output logic[1:0] L_out
);


// Light Duration Parameters - Defaults
// ------------------

parameter RED_DURATION = 5'd30;
parameter YELLOW_DURATION = 5'd3;
parameter GREEN_DURATION = 5'd30;

// Put your code here
// ------------------

    typedef enum {
        idle_st,
        red_st,
        yellow_st,
        green_st,
        flicker_st,
        yellow_to_red_st
    } light_st;

    light_st current_state;
    light_st next_state;

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            current_state <= idle_st;
        end
        else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        t_start = 1'b0;
        t_length = 5'b0;
        L_out = 2'b00;

        case (current_state)
            // IDLE STATE - NO LIGHT
            idle_st: begin
                L_out = 2'b00;
                if (start == 1'b1) begin // Start the traffic-light
                    next_state = red_st;
                    t_length = RED_DURATION;
                    t_start = 1'b1;
                end
            end

            // RED STATE - RED LIGHT - 27 Cycles
            red_st: begin
                L_out = 2'b01;
                if (t_done == 1'b1) begin // Timer is finished - move to yellow state
                    next_state = yellow_st;
                    t_length = YELLOW_DURATION;
                    t_start = 1'b1;
                end
                else begin // Timer is not finished - stay in red state
                    next_state = red_st;
                end
            end

            // YELLOW STATE - YELLOW LIGHT - 3 Cycles
            yellow_st: begin
                L_out = 2'b10;
                if (t_done == 1'b1) begin // Timer is finished - move to green state
                    next_state = green_st;
                    t_length = GREEN_DURATION;
                    t_start = 1'b1;
                end
                else begin // Timer is not finished - stay in yellow state
                    next_state = yellow_st;
                end
            end

            // GREEN STATE - GREEN LIGHT - 23 Cycles (5 Cycles on flickering mode)
            green_st: begin
                L_out = 2'b11;
                if (t_done == 1'b0) begin // If timer is not finished
                    if (t_flicker == 1'b1) begin // Is in flickering mode - move to the flicker state (off)
                        next_state = flicker_st;
                    end
                    else begin // Is not in flickering mode - stay in green state
                        next_state = green_st;
                    end
                end
                else begin // Is not supposed to be triggered, but implemented for possible future changes in values
                    next_state = yellow_to_red_st;
                    t_length = YELLOW_DURATION;
                    t_start = 1'b1;
                end
			end

            // FLICKER STATE - NO LIGHT - Moves back and forth from green state to this state for 5 cycles
			flicker_st: begin
                L_out = 2'b00;
                if (t_done == 1'b1) begin // If timer is finished - move to the yellow->red state
					next_state = yellow_to_red_st;
                    t_length = YELLOW_DURATION;
                    t_start = 1'b1;
				end
                else if (t_flicker == 1'b1) begin // If timer is not finished, and in flicker mode - move to green state
                    next_state = green_st;
                end
                else begin // Is not supposed to be triggered, but implemented for possible changes in values
                    next_state = yellow_to_red_st;
                    t_length = YELLOW_DURATION;
                    t_start = 1'b1;
                end
			end

            // YELLOW->RED STATE - YELLOW LIGHT - 3 Cycles
			yellow_to_red_st: begin
                L_out = 2'b10;
                if (t_done == 1'b1) begin // If timer is finished - move to the red state
                    next_state = red_st;
                    t_length = RED_DURATION;
                    t_start = 1'b1;
                end
				else begin // If timer is not finished - stay in yellow->red state
					next_state = yellow_to_red_st;
				end
			end
		endcase
	end


// end of your code
endmodule
