module UART_tx #
(
    parameter clk_freq = 50000000,
    parameter baud_rate = 115200
)
(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx
);

localparam BIT_PERIOD = clk_freq/baud_rate;
localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

reg [1:0] state;
reg [31:0] count;
reg [2:0] bit_index;
reg [7:0] tx_data_reg;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        count <= 0;
        bit_index <= 0;
    end

    else begin

        case(state)

        IDLE:
        begin
            tx <= 1'b1;
            count <= 0;
            bit_index <= 0;

            if(tx_start) begin
                tx_data_reg <= tx_data;
                state <= START;
            end
        end

        START:
        begin
            tx <= 1'b0;

            if(count < BIT_PERIOD-1)
                count <= count + 1;
            else
            begin
                count <= 0;
                state <= DATA;
            end

        end

        DATA:
        begin
            tx <= tx_data_reg[bit_index];

            if (count < BIT_PERIOD -1) begin
                count <= count + 1;
            end
            else begin 
                count <= 0;
                if(bit_index == 7)
                begin
                    bit_index <= 0;
                    state <= STOP;
                end
                else
                    bit_index <= bit_index + 1;
            end
        end

        STOP:
        begin
            tx <= 1'b1;
            if (count < BIT_PERIOD-1) begin
                count <= count + 1;
            end
            else begin 
                count <= 0;
                state <= IDLE;
            end
        end

        default:
            state <= IDLE;
        endcase
    end
end
endmodule