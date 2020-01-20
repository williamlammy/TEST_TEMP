`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: williamlammy	
// 
// Create Date: 11.01.2020 11:40:51
// Design Name: 
// Module Name: TRIG
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


module CALCULATION #
	(
		parameter 		SIZE				=		32,
		parameter 		T 				    =		32'b0_0000_0000_1111_1010_000000000000000,
		parameter 		V  				    =		32'b0_0000_0001_0101_0100_000000000000000
	)
	(
		input										echo_rdy,
		input 			[31:0]						echo_out,
		input 			[31:0]						config_N_ref,
		input 										clk,

		output wire 							 	temp_rdy,
		output wire 	[31:0]						temp_out,

		output wire 							 	dist_rdy,
		output wire 	[31:0]						dist_out
    );


		wire 								c_strt;

	EDGE_DET edge_det 
	(
		.signal_in(echo_rdy),
		.clk(clk),
		.edge_rdy(c_strt)
	);




defparam calc_temp.SIZE 		=		SIZE;
defparam calc_temp.T 			=		T;

	CALC_TEMP calc_temp 
	(
		.strt(c_strt),
		.clk(clk),
		.N_ref(config_N_ref),
		.N_echo(echo_out),
		.temp_out(temp_out),
		.temp_rdy(temp_rdy)
	);

defparam calc_dist.SIZE 		=		SIZE;
defparam calc_dist.V 			=		V;

	CALC_DIST calc_dist 
	(
		.strt(c_strt),
		.clk(clk),
		.N_echo(echo_out),
		.dist_out(dist_out),
		.dist_rdy(dist_rdy)
	);
endmodule
