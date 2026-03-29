
`timescale 1ns / 1ps

// =========================================================================
// MODULE 4: PEAK SHAVING CONTROLLER (CORRECTED)
// =========================================================================
module shaving_logic (
    input wire clk,
    input wire rst,
    input wire peak_detected,
    input wire nn_done,             
    input wire [1:0] user_strategy, 
    input wire [7:0] current_time,    
    input wire [7:0] reschedule_time, 
    output reg [3:0] grid_power_en,   
    output reg [3:0] alt_power_en     
);

    localparam APP_MEDICAL = 0, APP_FRIDGE = 1, APP_WASHER = 2, APP_EV = 3;

    reg [7:0] saved_reschedule_time;
    reg is_rescheduled;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grid_power_en <= 4'b1111; 
            alt_power_en  <= 4'b0000; 
            saved_reschedule_time <= 8'd0;
            is_rescheduled <= 1'b0;
        end else begin
            
            // 1. Timer Logic: Checks every clock cycle if it's time to turn things back on
            if (is_rescheduled && (current_time >= saved_reschedule_time) && !peak_detected) begin
                is_rescheduled <= 1'b0;
                grid_power_en[APP_WASHER] <= 1'b1;
                grid_power_en[APP_EV]     <= 1'b1;
            end

            // 2. Neural Net Result Logic: Only updates when NN finishes a calculation
            if (nn_done) begin
                if (peak_detected) begin
                    // Essential loads ALWAYS stay on grid
                    grid_power_en[APP_MEDICAL] <= 1'b1;
                    grid_power_en[APP_FRIDGE]  <= 1'b1;
                    alt_power_en[APP_MEDICAL]  <= 1'b0;
                    alt_power_en[APP_FRIDGE]   <= 1'b0;

                    case (user_strategy)
                        2'b01: begin // Option 1: Shed (Turn off entirely)
                            grid_power_en[APP_WASHER] <= 1'b0;
                            grid_power_en[APP_EV]     <= 1'b0;
                            alt_power_en[APP_WASHER]  <= 1'b0;
                            alt_power_en[APP_EV]      <= 1'b0;
                        end
                        2'b10: begin // Option 2: Delay / Reschedule
                            grid_power_en[APP_WASHER] <= 1'b0;
                            grid_power_en[APP_EV]     <= 1'b0;
                            alt_power_en[APP_WASHER]  <= 1'b0;
                            alt_power_en[APP_EV]      <= 1'b0;
                            if (!is_rescheduled) begin
                                saved_reschedule_time <= reschedule_time;
                                is_rescheduled <= 1'b1;
                            end
                        end
                        default: begin // Option 3 (Default): Shift to Alt Power
                            grid_power_en[APP_WASHER] <= 1'b0;
                            grid_power_en[APP_EV]     <= 1'b0;
                            alt_power_en[APP_WASHER]  <= 1'b1;
                            alt_power_en[APP_EV]      <= 1'b1;
                        end
                    endcase
                end else begin
                    // Return to normal operation if no peak is detected (and not waiting on timer)
                    if (!is_rescheduled) begin
                        grid_power_en <= 4'b1111;
                        alt_power_en  <= 4'b0000;
                    end
                end
            end
        end
    end
endmodule