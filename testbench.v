`include "protocolo_UART.v"

module tb(
    output reg clk, clk_uart, rst,
    output reg [7:0] datain_1,
    output reg [7:0] datain_2,
    input [7:0] dataout_1,
    input [7:0] dataout_2
);

completo DUT(.clk(clk), .clk_uart(clk_uart), .rst(rst), .datain_1(datain_1), .datain_2(datain_2), .dataout_1(dataout_1), .dataout_2(dataout_2));

always #1 clk = !clk;
always #2 clk_uart = !clk_uart;

initial begin
    clk = 1;
    clk_uart = 1;
    rst = 1;
    datain_1 = 0;
    datain_2 = 0;
    #4;
    rst = 0;
    #4;
    datain_1 = 8'b10000011;
    #4;
    datain_1 = 0;
    datain_2 = 8'b00000111;
    #4;
    datain_2 = 0;
    #44;
    datain_1 = 8'b11110000;
    datain_2 = 8'b10101010;
    #4;
    datain_1 = 0;
    datain_2 = 0;
    #44;
    $finish;
end

initial begin
    $dumpfile("proyecto.vcd");
    $dumpvars;
end

endmodule