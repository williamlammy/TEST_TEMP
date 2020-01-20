`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: williamlammy	
// 
// Create Date: 11.01.2020 11:40:51
// Design Name: 
// Module Name: ECHO
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


module ECHO #
	(
		parameter 		LENGTH		=	32
	)
	
	(
		input								in_pulse,
		input 								clk,
		input								rst,

		output wire 						rdy,
		output wire 	[LENGTH-1:0] 		pulse_width
    );

	reg			[1:0]				isync;
	reg			[LENGTH-1:0]		pw_cnt;
	reg			[LENGTH-1:0]		pw_save;
	reg								pw_rdy;

	assign 							rdy 	=		pw_rdy;
	assign 							pulse_width	=	pw_save;
	
	always @ (posedge clk or negedge rst) begin
		if (~rst)
			isync 		<=		0;
		else
			isync 		<=		{isync[0],in_pulse};
	end

	always @ (posedge clk or negedge rst) begin
		if (~rst) begin
			pw_cnt 		<=		0;
			pw_save		<=		0;
			pw_rdy		<=		0;
		end
		else begin
			case (isync[1])
				1'b0: begin
					pw_save		<=		pw_cnt;
					pw_rdy 		<=		1;
				if (isync[0]	==	1) begin
					pw_cnt		<=		0;
					pw_rdy		<=		0;
				end
				end
				1'b1: begin
					pw_cnt		<=		pw_cnt + 1'b1;
				end
			endcase
		end
	end
 
endmodule
