//smart traffic light module

module traffic_light_smart(
    //inputs
    input logic clk, // Clock
    input logic reset, // Reset
    input logic start, // Start signal
    input logic t_flicker,
    input logic t_done,
    input logic car_present,
    input logic person_present,

    //outputs
    output logic t_start,
    output logic[4:0] t_length,
    output logic t_freeze,
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
        t_freeze = 1'b0;

        case (current_state)
            // IDLE STATE - NO LIGHT
            idle_st: begin
                L_out = 2'b00;

                // Start the traffic-light
                if (start == 1'b1) begin
                    next_state = red_st;
                    t_length = RED_DURATION;
                    t_start = 1'b1;
                end
            end

            // RED STATE - RED LIGHT - 27 Cycles
            red_st: begin
                L_out = 2'b01;

                // Timer is finished - move to yellow state
                if (t_done == 1'b1 || (person_present === 1'b0 && car_present === 1'b1)) begin
                    next_state = yellow_st;
                    t_length = YELLOW_DURATION;
                    t_start = 1'b1;
                end
                // Timer is not finished - stay in red state
                else begin
                    // Put t_freeze to 1 if there are people and no cars
                    t_freeze = (person_present === 1'b1 && car_present === 1'b0);
                    next_state = red_st;
                end
            end

            // YELLOW STATE - YELLOW LIGHT - 3 Cycles
            yellow_st: begin
                L_out = 2'b10;

                // Timer is finished - move to green state
                if (t_done == 1'b1) begin
                    next_state = green_st;
                    t_length = GREEN_DURATION;
                    t_start = 1'b1;
                end
                // Timer is not finished - stay in yellow state
                else begin
                    next_state = yellow_st;
                end
            end

            // GREEN STATE - GREEN LIGHT - 23 Cycles (5 Cycles on flickering mode)
            green_st: begin
                L_out = 2'b11;

                /** 
                 No need to address t_done, since it is on only if t_flicker is (and we assume it is not)
                 And in the impossible case we do get t_done, we want to move to yellow_to_red_st
                 */
                t_freeze = ((~person_present) && (car_present) && (~t_flicker));

                /** 
                 For all any valid runs, the following expression should be used:
                    ===>    ((person_present) && (~car_present) && (~t_flicker))
                 We will address an *impossible* case in which we have T_done=1 and current_st=green_st.
                 In that case we want t_start=1, next_state=yellow_to_red_st regardless of other parameters. 
                 */
                t_start = (((person_present) && (~car_present) && (~t_flicker)) || t_done );

                // t_done=1 or that there are cars and no people so move to yellow_to_red_st
                if (t_start == 1'b1) begin
                    next_state = yellow_to_red_st;
                    t_length = YELLOW_DURATION;
                end
                // Is in flickering mode, so move to the flicker state
                else if (t_flicker == 1'b1) begin
                    next_state = flicker_st;
                end
                // Not in flickering mode, and it is not that there are no people and are cars, so stay
                else begin
                    next_state = green_st;
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