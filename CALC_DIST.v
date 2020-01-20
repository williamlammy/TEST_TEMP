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


module CALC_DIST #
	(
		parameter 		SIZE				=		32,
		parameter 		V  				    =		32'b0_0000_0001_0101_0100_000000000000000
	)

	(
		input						 			  strt,
		input						              clk,
		input             	    [SIZE-1:0]        N_echo,

        output  wire            [SIZE-1:0]        dist_out,
        output  wire                              dist_rdy
    );


    wire        [SIZE-1:0]          A_nsave; 
    wire        [SIZE-1:0]          buff2;
    wire        [SIZE-1:0]          buff4;
    reg         [SIZE-1:0]          buff2_reg   =       const;
    reg         [SIZE-1:0]          buff4_reg   =       V;


    localparam const    =   32'b0000_0001_0011_0001_0010_1101_0000_0000;



    assign                          buff2       =       buff2_reg;
    assign                          buff4       =       buff4_reg;

defparam        QDIV1.Q       =       15;
defparam        QDIV1.N       =       32;

    qdiv QDIV1 
    (
        .i_dividend(N_echo),
        .i_divisor(buff2),
        .i_start(strt),
        .i_clk(clk),
        .o_quotient_out(A_nsave),
        .o_complete(dist_rdy),
        .o_overflow()
    );


defparam        QMULT1.Q       =       15;
defparam        QMULT1.N       =       32;
    qmult QMULT1 
    (
        .i_multiplicand(A_nsave),
        .i_multiplier(buff4),
        .o_result(dist_out),
        .ovr()
    );


endmodule
