
`timescale 1ns / 1ps

module mlp16_4_2_1 (
    input clk,
    input rst,
    input start,
    input signed [255:0] in_data, // flattened
    output reg out_class,               
    output reg done
);

    // Internal unpacked version (allowed in Verilog)
    wire signed [15:0] data [0:15];
    genvar gi;
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : UNPACK
            assign data[gi] = in_data[gi*16 +: 16];
        end
    endgenerate

    reg signed [15:0] hidden1 [0:3];
    reg signed [15:0] hidden2 [0:1];
    reg signed [31:0] acc;
    
    reg signed [15:0] mult_a;
    reg signed [15:0] mult_b;
    wire signed [31:0] mul_out;
    assign mul_out = mult_a * mult_b;
    
    reg signed [15:0] w1 [0:63];
    reg signed [15:0] b1 [0:3];
    reg signed [15:0] w2 [0:7];
    reg signed [15:0] b2 [0:1];
    reg signed [15:0] w3 [0:1];
    reg signed [15:0] b3; 

    integer i;

    initial begin
        b1[0] = 4165; b1[1] = 5096; b1[2] = 5162; b1[3] = -1354;
        b2[0] = 6190; b2[1] = -4797;
        b3 = 3792;

        w3[0] = -7667; w3[1] = -20018;

        w2[0] = 5231; w2[1] = 5455; w2[2] = 954; w2[3] = -11060;
        w2[4] = 8930; w2[5] = -4484; w2[6] = 12673; w2[7] = 5807;

        w1[0] = -317; w1[1] = -1016; w1[2] = 3737; w1[3] = 4847;
        w1[4] = -1146; w1[5] = 2974; w1[6] = 4285; w1[7] = -1896; 
        w1[8] = -333; w1[9] = 339; w1[10] = -2625; w1[11] = -1298;
        w1[12] = 1540; w1[13] = -3770; w1[14] = -901; w1[15] = -9675; 
        w1[16] = 2852; w1[17] = 2255; w1[18] = 3172; w1[19] = 1310;
        w1[20] = -6915; w1[21] = -10552; w1[22] = -3105; w1[23] = -4221; 
        w1[24] = 5431; w1[25] = -8611; w1[26] = -11066; w1[27] = 2453;
        w1[28] = -7830; w1[29] = -1917; w1[30] = -5743; w1[31] = 9027; 
        w1[32] = 771; w1[33] = -4273; w1[34] = -2917; w1[35] = -1740;
        w1[36] = -1176; w1[37] = -400; w1[38] = 532; w1[39] = -2747; 
        w1[40] = 1029; w1[41] = -161; w1[42] = -3470; w1[43] = -2719;
        w1[44] = 2542; w1[45] = -3556; w1[46] = 857; w1[47] = -4933; 
        w1[48] = 3033; w1[49] = 7737; w1[50] = 6086; w1[51] = -119;
        w1[52] = 2009; w1[53] = -6324; w1[54] = -3988; w1[55] = -2810; 
        w1[56] = 141; w1[57] = 2988; w1[58] = 11417; w1[59] = 4332;
        w1[60] = 2405; w1[61] = -1034; w1[62] = -1744; w1[63] = -16771;
    end

    wire signed [15:0] acc_shifted = acc >>> 12;
    reg signed [15:0] clamp_val;
    wire signed [15:0] tanh_out;
    
    tanhlut my_tanh (
        .clk(clk),
        .in_val(clamp_val),
        .out_val(tanh_out)
    );

    localparam IDLE=4'd0, 
               MAC_L1=4'd1, ACT_L1=4'd2, WAIT_L1=4'd3, READ_L1=4'd4, 
               MAC_L2=4'd5, ACT_L2=4'd6, WAIT_L2=4'd7, READ_L2=4'd8, 
               MAC_L3=4'd9, ACT_L3=4'd10, DONE=4'd11;

    reg [3:0] state;
    reg [3:0] in_idx;  
    reg [1:0] n_idx;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            acc <= 0; in_idx <= 0; n_idx <= 0; done <= 0; out_class <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin state <= MAC_L1; acc <= 0; in_idx <= 0; n_idx <= 0; end
                end

                MAC_L1: begin
                    acc <= acc + (data[in_idx] * w1[{n_idx, in_idx}]);
                    if (in_idx == 15) state <= ACT_L1;
                    else in_idx <= in_idx + 1;
                end

                ACT_L1: begin
                    if ((acc_shifted + b1[n_idx]) > 16384) clamp_val <= 16384;
                    else if ((acc_shifted + b1[n_idx]) < -16384) clamp_val <= -16384;
                    else clamp_val <= acc_shifted + b1[n_idx];
                    state <= WAIT_L1;
                end

                WAIT_L1: state <= READ_L1;

                READ_L1: begin
                    hidden1[n_idx] <= tanh_out;
                    if (n_idx == 3) begin state <= MAC_L2; n_idx <= 0; in_idx <= 0; acc <= 0; end
                    else begin state <= MAC_L1; n_idx <= n_idx + 1; in_idx <= 0; acc <= 0; end
                end

                MAC_L2: begin
                    acc <= acc + (hidden1[in_idx[1:0]] * w2[{n_idx[0], in_idx[1:0]}]);
                    if (in_idx == 3) state <= ACT_L2;
                    else in_idx <= in_idx + 1;
                end

                ACT_L2: begin
                    if ((acc_shifted + b2[n_idx[0]]) > 16384) clamp_val <= 16384;
                    else if ((acc_shifted + b2[n_idx[0]]) < -16384) clamp_val <= -16384;
                    else clamp_val <= acc_shifted + b2[n_idx[0]];
                    state <= WAIT_L2;
                end

                WAIT_L2: state <= READ_L2;

                READ_L2: begin
                    hidden2[n_idx[0]] <= tanh_out;
                    if (n_idx == 1) begin state <= MAC_L3; in_idx <= 0; acc <= 0; end
                    else begin state <= MAC_L2; n_idx <= n_idx + 1; in_idx <= 0; acc <= 0; end
                end

                MAC_L3: begin
                    acc <= acc + (hidden2[in_idx[0]] * w3[in_idx[0]]);
                    if (in_idx == 1) state <= ACT_L3;
                    else in_idx <= in_idx + 1;
                end

                ACT_L3: begin
                    if ((acc_shifted + b3) > 0) out_class <= 1;
                    else out_class <= 0;
                    state <= DONE;
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule