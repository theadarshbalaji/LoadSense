
`timescale 1ns / 1ps

module loadsensetop (
    input wire clk,
    input wire rst,
    input wire start,
    input wire signed [255:0] in_data, // flattened (16 × 16)
    input wire [1:0] user_strategy,
    input wire [7:0] current_time,
    input wire [7:0] reschedule_time,
    output wire nn_done,
    output wire [3:0] grid_power_en,
    output wire [3:0] alt_power_en
);

    wire peak_detected;

    // OPTIONAL: unpack into 16 signals (if needed)
    wire signed [15:0] data [0:15];
    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : UNPACK
            assign data[i] = in_data[i*16 +: 16];
        end
    endgenerate

    // Neural Network Module
    mlp16_4_2_1 my_nn_model (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_data(in_data),   // ?? must ALSO be flattened inside this module
        .out_class(peak_detected), 
        .done(nn_done)
    );

    // Control Logic
    shaving_logic my_shaving_logic(
        .clk(clk),
        .rst(rst),
        .peak_detected(peak_detected),
        .nn_done(nn_done),         
        .user_strategy(user_strategy),
        .current_time(current_time),
        .reschedule_time(reschedule_time),
        .grid_power_en(grid_power_en),
        .alt_power_en(alt_power_en)
    );

endmodule