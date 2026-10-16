`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2026 11:37:20
// Design Name: 
// Module Name: cmd_processor
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


module cmd_processor(
    input clk,
    input rst,

    input [7:0] rx_data,
    input rx_done,

    output reg led
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 1'b0;
        end
        else begin
            if (rx_done) begin

                case (rx_data)

                    8'h31: led <= 1'b1; // ASCII '1'

                    8'h30: led <= 1'b0; // ASCII '0'

                    default: led <= led;

                endcase

            end
        end
    end

endmodule