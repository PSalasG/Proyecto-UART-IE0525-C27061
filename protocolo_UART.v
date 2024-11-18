module UART1(
    input clk, rst,
    input [7:0] datain_1,
    input data_reciev_1,
    output reg data_transm_1,
    output reg [7:0] dataout_1
);

reg [7:0] parallel_in;
reg [3:0] cant_unos;
reg [4:0] state_transm;
reg [4:0] counter_transm;
reg [4:0] state_reciev;
reg [4:0] counter_reciev;

always @(posedge clk) begin
    if (rst) begin
        data_transm_1 <= 1;
        dataout_1 <= 0;
        parallel_in <= 0;
        cant_unos <= 0;
        state_transm <= 0;
        counter_transm <= 0;
        state_reciev <= 0;
        counter_reciev <= 0;
    end else begin
        case (state_transm)
            0 : begin
                if (datain_1 != 0) begin
                    data_transm_1 <= 0; //Start bit
                    parallel_in <= datain_1;
                    state_transm <= 1;
                end
            end
            1 : begin
                if (counter_transm < 4'd8) begin
                    data_transm_1 <= parallel_in[0];
                    cant_unos <= parallel_in[0] ? cant_unos + 1 : cant_unos;
                    parallel_in <= parallel_in >> 1;
                    counter_transm <= counter_transm + 1;
                end
                else begin
                    if (cant_unos % 2) data_transm_1 <= 1; //Bit de paridad
                    else data_transm_1 <= 0;
                    cant_unos <= 0;
                    counter_transm <= 0;
                    state_transm <= 2;
                end
            end
            2 : begin
                data_transm_1 <= 1; //Stop bit
                state_transm <= 0;
            end
        endcase
        case (state_reciev)
            0 : begin
                if (!data_reciev_1) state_reciev <= 1;
            end
            1 : begin
                if (counter_reciev < 4'd8) begin
                    dataout_1 <= dataout_1 >> 1;
                    dataout_1[7] <= data_reciev_1;
                    counter_reciev <= counter_reciev + 1;
                end
                else begin
                    dataout_1 <= 0;
                    counter_reciev <= 0;
                    state_reciev <= 0; //Aqui ignora bit de paridad y el bit de parada es 1 por lo que quedaría en espera de otro bit de inicio
                end
            end
        endcase
    end
end

endmodule

module UART2(
    input clk, rst,
    input [7:0] datain_2,
    input data_reciev_2,
    output reg data_transm_2,
    output reg [7:0] dataout_2
);

reg [7:0] parallel_in;
reg [3:0] cant_unos;
reg [4:0] state_transm;
reg [4:0] counter_transm;
reg [4:0] state_reciev;
reg [4:0] counter_reciev;

always @(posedge clk) begin
    if (rst) begin
        data_transm_2 <= 1;
        dataout_2 <= 0;
        parallel_in <= 0;
        cant_unos <= 0;
        state_transm <= 0;
        counter_transm <= 0;
        state_reciev <= 0;
        counter_reciev <= 0;
    end else begin
        case (state_transm)
            0 : begin
                if (datain_2 != 0) begin
                    data_transm_2 <= 0;
                    parallel_in <= datain_2;
                    state_transm <= 1;
                end
            end
            1 : begin
                if (counter_transm < 4'd8) begin
                    data_transm_2 <= parallel_in[0];
                    cant_unos <= parallel_in[0] ? cant_unos + 1 : cant_unos;
                    parallel_in <= parallel_in >> 1;
                    counter_transm <= counter_transm + 1;
                end
                else begin
                    if (cant_unos % 2) data_transm_2 <= 1;
                    else data_transm_2 <= 0;
                    cant_unos <= 0;
                    counter_transm <= 0;
                    state_transm <= 2;
                end
            end
            2 : begin
                data_transm_2 <= 1;
                state_transm <= 0;
            end
        endcase
        case (state_reciev)
            0 : begin
                if (!data_reciev_2) state_reciev <= 1;
            end
            1 : begin
                if (counter_reciev < 4'd8) begin
                    dataout_2 <= dataout_2 >> 1;
                    dataout_2[7] <= data_reciev_2;
                    counter_reciev <= counter_reciev + 1;
                end
                else begin
                    dataout_2 <= 0;
                    counter_reciev <= 0;
                    state_reciev <= 0;
                end
            end
        endcase
    end
end

endmodule