`timescale 1ns / 1ps


module UART_RX #

    (
        parameter       CLK_FREQ      =       50_000_000,
        parameter       BAUD_RATE     =       9600
    )

    (
        input                            clk,
        input                            RX_rst,
        input                            RX_in,

        output      wire                 RX_idle,
        output      wire                 RX_rdy,
        output      wire    [7:0]        RX_out
    );

    

    localparam          HALF_VALUE    =       (CLK_FREQ / BAUD_RATE / 2 - 1);
    localparam          HALF_SIZE     =       $clog2(HALF_VALUE);



    reg     [HALF_SIZE - 1:0]       RX_clk_cnt      =   0;   
    reg                             RX_baud_clk     =   1'b0;
    reg     [9:0]                   RX_data         =   10'h000;
    reg     [2:0]                   RX_lock         =   3'b111;


  wire        from_major;
    

    
    assign      RX_idle          =       ~RX_data[0];
    assign      RX_rdy           =       RX_data[9] & RX_idle;
    assign      RX_out[7:0]      =       RX_data[8:1];
    assign      from_major       =       (RX_lock[0] & RX_lock[1]) | (RX_lock[0] & RX_lock[2]) | (RX_lock[1] & RX_lock[2]);


  always @ (posedge clk) begin : majority
      RX_lock                  <=      {RX_in, RX_lock[2:1]};
  end // majority




    always @ (posedge RX_baud_clk or negedge RX_rst) begin : RX_recieve
        if (~RX_rst) begin
            RX_data              <=      10'h000;
        end // if (~RX_rst)
        else if (~RX_idle) begin
            RX_data              <=      {from_major, RX_data[9:1]};
        end // else if (~RX_idle)
        else if (~from_major) begin
            RX_data              <=      10'h1FF;
        end // else if (~from_major)
    end // RX_recieve


    always @ (posedge clk) begin : RX_clk_generation
        if (from_major & RX_idle) begin
            RX_clk_cnt          <=       HALF_VALUE;
            RX_baud_clk         <=       0;
        end // if (from_major & RX_idle)
        else if (RX_clk_cnt == 0) begin
            RX_clk_cnt          <=       HALF_VALUE;
            RX_baud_clk         <=       ~RX_baud_clk;
        end // else if (RX_clk_cnt == 0)
        else begin
            RX_clk_cnt          <=       RX_clk_cnt - 1;
        end // else
    end // RX_clk_generation
endmodule // UART_RX






    


           