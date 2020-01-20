`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2020 18:40:09
// Design Name: 
// Module Name: CALC
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


module CALC_TEMP #
	(
		parameter 		SIZE				=		32,
		parameter 		T 				    =		32'b0_0000_0000_0001_1001_000000000000000
	)

	(
		input						 			  strt,
		input						              clk,
		//input							       	  rst,
		input             	    [SIZE-1:0]        N_ref,
		input    	            [SIZE-1:0]        N_echo,

        output  wire            [SIZE-1:0]        temp_out,
        output  wire                              temp_rdy
    );

    reg         [SIZE-1:0]          temp        =       T;
    wire        [SIZE-1:0]          multiplier;
    wire        [SIZE-1:0]          A_nsave; 
    wire        [SIZE-1:0]          out_sqv;

    assign                          multiplier  =       temp;

defparam        QDIV.Q       =       15;
defparam        QDIV.N       =       32;
    qdiv QDIV 
    (
        .i_dividend(N_ref),
        .i_divisor(N_echo),
        .i_start(strt),
        .i_clk(clk),
        .o_quotient_out(A_nsave),
        .o_complete(temp_rdy),
        .o_overflow()
    );



defparam        QMULT1.Q       =       15;
defparam        QMULT1.N       =       32;
    qmult QMULT1 
    (
        .i_multiplicand(A_nsave),
        .i_multiplier(A_nsave),
        .o_result(out_sqv),
        .ovr()
    );

defparam        QMULT2.Q       =       15;
defparam        QMULT2.N       =       32;
    qmult QMULT2 
    (
        .i_multiplicand(out_sqv),
        .i_multiplier(multiplier),
        .o_result(temp_out),
        .ovr()
    );

endmodule
