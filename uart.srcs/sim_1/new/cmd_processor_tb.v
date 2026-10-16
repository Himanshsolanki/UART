`timescale 1ns / 1ps

module cmd_processor_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] rx_data;
    reg rx_done;

    // Output
    wire led;

    // Instantiate the command processor
    cmd_processor uut (
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .led(led)
    );

    // Generate clock
    always #5 clk = ~clk;

    initial begin
        
        // Initial values
        clk = 0;
        rst = 1;
        rx_data = 0;
        rx_done = 0;

        // Keep reset active for some time
        #20;
        rst = 0;

        // Send character '1'
        #20;
        rx_data = 8'h31;
        rx_done = 1;

        #10;
        rx_done = 0;

        // Wait and then send character '0'
        #40;
        rx_data = 8'h30;
        rx_done = 1;

        #10;
        rx_done = 0;

        #40;

        $finish;
        
    end

endmodule
