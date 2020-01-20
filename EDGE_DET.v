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


module EDGE_DET 
	(
		input										signal_in,
		input 										clk,

		output wire 							 	edge_rdy
    );

	reg 		signal_delayed;

	always @ (posedge clk) begin
		signal_delayed 		<=		signal_in;
	end

	assign 		edge_rdy 	=	signal_in & ~signal_delayed;
endmodule
