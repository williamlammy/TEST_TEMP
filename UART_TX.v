`timescale 1ns / 1ps

module UART_TX #

    (
        parameter       CLK_FREQ      =       50_000_000,
        parameter       BAUD_RATE     =       9600
    )

    (
        input                   clk,
        input                   TX_rst,
        input       [7:0]       TX_in,
        input                   TX_ctr,
        
        output      wire        TX_idle,
        output      wire        TX_rdy,
        output      wire        TX_out
    );

    

    localparam          HALF_VALUE    =       (CLK_FREQ / BAUD_RATE / 2 - 1);
    localparam          HALF_SIZE     =       $clog2(HALF_VALUE);



    reg     [HALF_SIZE - 1:0]       TX_clk_cnt      =   0;   
    reg                             TX_baud_clk     =   1'b0;
    reg     [9:0]                   TX_data         =   10'h001;
    reg     [3:0]                   TX_data_cnt     =   4'h0;



    assign      TX_rdy      =       !TX_data_cnt[3:1];
    assign      TX_idle     =       TX_rdy & (~TX_data_cnt[0]);
    assign      TX_out      =       TX_data[0];


    always @ (posedge TX_baud_clk or negedge TX_rst) begin : TX_transsmition
        if (~TX_rst) begin
            TX_data_cnt         <=      4'h0;
            TX_data[0]          <=      1'b1;
        end
        else if (~TX_rdy) begin
            TX_data             <=      {1'b0, TX_data[9:1]};
            TX_data_cnt         <=      TX_data_cnt - 1'b1;
        end
        else if (TX_ctr) begin
            TX_data             <=      {1'b1, TX_in[7:0], 1'b0};
            TX_data_cnt         <=      4'hA;
        end
        else begin
            TX_data_cnt         <=      4'h0; 
        end
    end

    always @(posedge clk) begin : TX_clk_generation
        if (TX_idle & (~TX_ctr)) begin
            TX_clk_cnt          <=      0;
            TX_baud_clk         <=      1'b0;      
        end
        else if (TX_clk_cnt == 0) begin
            TX_clk_cnt          <=      HALF_VALUE;
            TX_baud_clk         <=      ~TX_baud_clk;
        end
        else begin
            TX_clk_cnt          <=      TX_clk_cnt - 1'b1;
        end
    end

endmodule//UART_TX

