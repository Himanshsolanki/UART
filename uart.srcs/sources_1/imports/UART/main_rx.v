`timescale 1ns / 1ps
module UART_rx
#(
    parameter clk_freq = 50000000,
    parameter baud_rate = 115200
)
(
    input clk,
    input rst,
    input rx,
    output reg [7:0] rx_data,
    output reg [7:0] rx_shift_reg,
    output reg rx_done
);
    localparam BIT_PERIOD = clk_freq/baud_rate;
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [31:0] count =0;
    reg [2:0] bit_index;

    always @(posedge clk or posedge rst) begin 

        if (rst) begin 
            state <= IDLE;
            rx_done <= 1'b0;
            count <= 0;
            bit_index <= 0;
            rx_shift_reg <= 0;
            rx_data <= 0;
        end

        else begin 
            case (state) 

                IDLE : begin 
                    rx_done <= 0;
                    bit_index <=0;
                    count <= 0;

                    if (!rx) begin 
                        state <= START;
                        count <= 0;
                    end
                end
            
                START : begin 

                    if(count < BIT_PERIOD/2 -1)
                        count <= count + 1;
                    else begin 
                        count <= 0;
                        if (!rx) begin 
                            state <= DATA;
                        end
                        else begin 
                            count <= 0;
                            state <= IDLE;
                        end
                    end
                end

                DATA : begin

                    rx_shift_reg[bit_index] <= rx;  

                    if (count < BIT_PERIOD -1) begin
                        count <= count + 1;
                    end

                    else begin 
                        if (bit_index < 7) begin 
                            count <= 0;                            
                            bit_index <= bit_index + 1;
                        end

                        else begin 
                            count <= 0;
                            state <= STOP;
                        end
                    end
                end

                STOP : begin
                    if (count < BIT_PERIOD-1) begin
                        count <= count + 1;
                    end
                    else begin 
                        count <= 0;
                        rx_data <= rx_shift_reg;
                        rx_done <= 1'b1;
                        state <= IDLE;
                    end
                end

                default : 
                    state <= IDLE;
                
            endcase
        end
    end

endmodule            