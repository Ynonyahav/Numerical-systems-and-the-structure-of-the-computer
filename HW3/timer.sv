// Timer module

module timer(
    input logic clk,
    input logic reset,
    input logic t_start,
    input logic[4:0] t_length,

    output logic t_flicker,
    output logic t_done
);

// Put your code here
// ------------------

    logic[4:0] decounter; // Starts from t_length and counts to 0
    logic[4:0] counter; // Starts from 0 and counts to t_length

    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin // Reset timer
            decounter <= 5'd0;
            counter <= 5'd0;
        end
        else begin // Run timer
            if (t_start == 1'b1) begin // Start new timer
                decounter <= t_length;
                counter <= 5'd1;
            end
            else if (5'd0 >= decounter) begin // Disable clock
                decounter <= 5'd0;
                counter <= 5'd0;
            end
            else begin // Count
                decounter <= decounter - 1;
                counter <= counter + 1;
            end
        end
    end

    always_comb begin
        t_flicker = 1'b0;
        t_done = 1'b0;

        // If decounter did not finish the count, and is in flicker range
        if (decounter > 5'd0 && decounter <= 5'd6) begin
            t_flicker = 1'b1;

            // If also at last cycle
            if (decounter == 5'd1) begin
                t_done = 1'b1;
            end
        end
    end

//N
// End of your code
endmodule