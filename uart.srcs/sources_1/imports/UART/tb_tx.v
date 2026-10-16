`timescale 1ns/1ps

module tb_tx;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;

UART_tx #(
    .clk_freq(50),
    .baud_rate(10)
)
uut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx)
);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'b10101010;

    #20;
    rst = 0;

    #10;
    tx_start = 1;

    #500;
    tx_start = 0;

    #200;

    $finish;

end

initial
begin

    $monitor("%0t clk=%b rst=%b start=%b tx=%b data=%b",
              $time, clk, rst, tx_start, tx, tx_data);

end
endmodule

