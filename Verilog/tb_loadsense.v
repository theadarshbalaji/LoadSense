
`timescale 1ns / 1ps

module tb_loadsense();

    // 1. Signals
    reg clk;
    reg rst;
    reg start;
    reg signed [255:0] in_data; // 16 * 16 = 256 bits (flattened)
    reg [1:0] user_strategy;
    reg [7:0] current_time;      
    reg [7:0] reschedule_time;   
    
    // Outputs
    wire [3:0] grid_power_en;
    wire [3:0] alt_power_en;
    wire nn_done;                 

    integer i;

    // 2. Instantiate DUT
    loadsensetop uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_data(in_data),
        .user_strategy(user_strategy),
        .current_time(current_time),      
        .reschedule_time(reschedule_time),
        .grid_power_en(grid_power_en),
        .alt_power_en(alt_power_en),
        .nn_done(nn_done)               
    );

    // 3. Clock generation
    always #5 clk = ~clk;

    // 4. Test script
    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        start = 0;
        user_strategy = 2'b10;  
        current_time = 8'd10;    
        reschedule_time = 8'd50; 
        in_data = 0;

        // Release reset
        #100;
        rst = 0;
        #20;
        
        // TEST 1: Normal Load
        #2 
        in_data[15:0]   = 16'd500;
        #2
        in_data[31:16]  = 16'd200;

        start = 1; #10; start = 0;
        #2000;
        
        
        // TEST 2: Peak Load
        for (i = 0; i < 16; i = i + 1) begin
            #2
            in_data[i*16 +: 16] = 16'd5000;
        end

        #20;
        start = 1; #10; start = 0;
        #2000;

        // TEST 3: Normal Load again
        #2
        in_data = 0;
        #2
        in_data[15:0]  = 16'd500;
        #2
        in_data[31:16] = 16'd200;

        start = 1; #10; start = 0;
        #2000;

        // TEST 4: Timer check
        current_time = 8'd60;
        #500;

        $stop;
    end

endmodule