module UART1(
    input clk, rst,
    input [7:0] data_in,
    output reg data_out
);

reg [7:0] parallel_in;
reg [3:0] cant_unos;
reg [4:0] state;
reg [4:0] counter;

always @(posedge clk) begin
    if (rst) begin
        data_out <= 1;
        parallel_in <= 0;
        cant_unos <= 0;
        state <= 0;
        counter <= 0;
    end else begin
        case (state)
            0 : begin
                data_out <= 0; //Start bit
                parallel_in <= data_in;
                state <= 1;
            end
            1 : begin
                if (counter < 4'd8) begin
                    data_out <= parallel_in[0];
                    cant_unos <= parallel_in[0] ? cant_unos + 1 : cant_unos;
                    parallel_in <= parallel_in >> 1;
                    counter <= counter + 1;
                end
                else begin
                    if (cant_unos % 2) data_out <= 1;
                    else data_out <= 0;
                    state <= 2;
                end
            end
            2 : begin
                data_out <= 1; //Stop bit
            end
        endcase
    end
end


endmodule