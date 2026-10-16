`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2026 12:26:39
// Design Name: 
// Module Name: uart_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

    module UART_tb;

    reg clk;
    reg rst;

    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire [7:0] rx_data;
    wire rx_done;

    // TX
    UART_tx #(
        .clk_freq(100),
        .baud_rate(10)
    ) transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx)
    );

    // RX
    UART_rx #(
        .clk_freq(100),
        .baud_rate(10)
    ) receiver (
        .clk(clk),
        .rst(rst),
        .rx(tx),          // TX → RX
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 50 MHz clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        tx_start = 0;
        tx_data = 8'b0;

        #10;
        rst = 0;

        // Send one byte
        tx_data = 8'b10110010;
        tx_start = 1;

        #20;
        tx_start = 0;

        // Wait for RX to finish
        #2000;

        $finish;

    end
    endmodule
