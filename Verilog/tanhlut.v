
`timescale 1ns / 1ps



module tanhlut (
    input clk,
    input signed [15:0] in_val,
    output reg signed [15:0] out_val
);
    wire [7:0] lut_addr = in_val[15:8]; 

    always @(posedge clk) begin
        case(lut_addr)
            
            8'b11000000: out_val <= -16'sd4093;
            8'b11000001: out_val <= -16'sd4093;
            8'b11000010: out_val <= -16'sd4092;
            8'b11000011: out_val <= -16'sd4092;
            8'b11000100: out_val <= -16'sd4091;
            8'b11000101: out_val <= -16'sd4091;
            8'b11000110: out_val <= -16'sd4090;
            8'b11000111: out_val <= -16'sd4089;
            8'b11001000: out_val <= -16'sd4089;
            8'b11001001: out_val <= -16'sd4088;
            8'b11001010: out_val <= -16'sd4086;
            8'b11001011: out_val <= -16'sd4085;
            8'b11001100: out_val <= -16'sd4084;
            8'b11001101: out_val <= -16'sd4082;
            8'b11001110: out_val <= -16'sd4080;
            8'b11001111: out_val <= -16'sd4078;
            8'b11010000: out_val <= -16'sd4076;
            8'b11010001: out_val <= -16'sd4073;
            8'b11010010: out_val <= -16'sd4070;
            8'b11010011: out_val <= -16'sd4067;
            8'b11010100: out_val <= -16'sd4063;
            8'b11010101: out_val <= -16'sd4058;
            8'b11010110: out_val <= -16'sd4053;
            8'b11010111: out_val <= -16'sd4048;
            8'b11011000: out_val <= -16'sd4041;
            8'b11011001: out_val <= -16'sd4034;
            8'b11011010: out_val <= -16'sd4026;
            8'b11011011: out_val <= -16'sd4016;
            8'b11011100: out_val <= -16'sd4006;
            8'b11011101: out_val <= -16'sd3994;
            8'b11011110: out_val <= -16'sd3981;
            8'b11011111: out_val <= -16'sd3966;
            8'b11100000: out_val <= -16'sd3949;
            8'b11100001: out_val <= -16'sd3929;
            8'b11100010: out_val <= -16'sd3908;
            8'b11100011: out_val <= -16'sd3883;
            8'b11100100: out_val <= -16'sd3856;
            8'b11100101: out_val <= -16'sd3825;
            8'b11100110: out_val <= -16'sd3790;
            8'b11100111: out_val <= -16'sd3751;
            8'b11101000: out_val <= -16'sd3707;
            8'b11101001: out_val <= -16'sd3659;
            8'b11101010: out_val <= -16'sd3604;
            8'b11101011: out_val <= -16'sd3543;
            8'b11101100: out_val <= -16'sd3475;
            8'b11101101: out_val <= -16'sd3399;
            8'b11101110: out_val <= -16'sd3315;
            8'b11101111: out_val <= -16'sd3222;
            8'b11110000: out_val <= -16'sd3119;
            8'b11110001: out_val <= -16'sd3007;
            8'b11110010: out_val <= -16'sd2883;
            8'b11110011: out_val <= -16'sd2748;
            8'b11110100: out_val <= -16'sd2602;
            8'b11110101: out_val <= -16'sd2443;
            8'b11110110: out_val <= -16'sd2272;
            8'b11110111: out_val <= -16'sd2088;
            8'b11111000: out_val <= -16'sd1893;
            8'b11111001: out_val <= -16'sd1686;
            8'b11111010: out_val <= -16'sd1468;
            8'b11111011: out_val <= -16'sd1240;
            8'b11111100: out_val <= -16'sd1003;
            8'b11111101: out_val <= -16'sd759;
            8'b11111110: out_val <= -16'sd509;
            8'b11111111: out_val <= -16'sd256;
            8'b00000000: out_val <= 16'sd0;
            8'b00000001: out_val <= 16'sd256;
            8'b00000010: out_val <= 16'sd509;
            8'b00000011: out_val <= 16'sd759;
            8'b00000100: out_val <= 16'sd1003;
            8'b00000101: out_val <= 16'sd1240;
            8'b00000110: out_val <= 16'sd1468;
            8'b00000111: out_val <= 16'sd1686;
            8'b00001000: out_val <= 16'sd1893;
            8'b00001001: out_val <= 16'sd2088;
            8'b00001010: out_val <= 16'sd2272;
            8'b00001011: out_val <= 16'sd2443;
            8'b00001100: out_val <= 16'sd2602;
            8'b00001101: out_val <= 16'sd2748;
            8'b00001110: out_val <= 16'sd2883;
            8'b00001111: out_val <= 16'sd3007;
            8'b00010000: out_val <= 16'sd3119;
            8'b00010001: out_val <= 16'sd3222;
            8'b00010010: out_val <= 16'sd3315;
            8'b00010011: out_val <= 16'sd3399;
            8'b00010100: out_val <= 16'sd3475;
            8'b00010101: out_val <= 16'sd3543;
            8'b00010110: out_val <= 16'sd3604;
            8'b00010111: out_val <= 16'sd3659;
            8'b00011000: out_val <= 16'sd3707;
            8'b00011001: out_val <= 16'sd3751;
            8'b00011010: out_val <= 16'sd3790;
            8'b00011011: out_val <= 16'sd3825;
            8'b00011100: out_val <= 16'sd3856;
            8'b00011101: out_val <= 16'sd3883;
            8'b00011110: out_val <= 16'sd3908;
            8'b00011111: out_val <= 16'sd3929;
            8'b00100000: out_val <= 16'sd3949;
            8'b00100001: out_val <= 16'sd3966;
            8'b00100010: out_val <= 16'sd3981;
            8'b00100011: out_val <= 16'sd3994;
            8'b00100100: out_val <= 16'sd4006;
            8'b00100101: out_val <= 16'sd4016;
            8'b00100110: out_val <= 16'sd4026;
            8'b00100111: out_val <= 16'sd4034;
            8'b00101000: out_val <= 16'sd4041;
            8'b00101001: out_val <= 16'sd4048;
            8'b00101010: out_val <= 16'sd4053;
            8'b00101011: out_val <= 16'sd4058;
            8'b00101100: out_val <= 16'sd4063;
            8'b00101101: out_val <= 16'sd4067;
            8'b00101110: out_val <= 16'sd4070;
            8'b00101111: out_val <= 16'sd4073;
            8'b00110000: out_val <= 16'sd4076;
            8'b00110001: out_val <= 16'sd4078;
            8'b00110010: out_val <= 16'sd4080;
            8'b00110011: out_val <= 16'sd4082;
            8'b00110100: out_val <= 16'sd4084;
            8'b00110101: out_val <= 16'sd4085;
            8'b00110110: out_val <= 16'sd4086;
            8'b00110111: out_val <= 16'sd4088;
            8'b00111000: out_val <= 16'sd4089;
            8'b00111001: out_val <= 16'sd4089;
            8'b00111010: out_val <= 16'sd4090;
            8'b00111011: out_val <= 16'sd4091;
            8'b00111100: out_val <= 16'sd4091;
            8'b00111101: out_val <= 16'sd4092;
            8'b00111110: out_val <= 16'sd4092;
            8'b00111111: out_val <= 16'sd4093;
            8'b01000000: out_val <= 16'sd4093;
                    
            default: out_val <= 0;
        endcase
    end
endmodule
