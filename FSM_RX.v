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


module FSM_RX 
	(
		input										rx_rdy,
		input 			[3:0]						rx_out,
		input 										clk,
		input										rst,

		output wire 							 	out
    );

	
	reg 		[2:0] 			state;
	reg 						d_rdy;
	reg 		[9:0]			cnt;
	reg 		[9:0]			ccnt;
	reg 		[27:0]			cccnt;
	wire						rdy;
	reg 						trig;

	always @ (posedge clk) begin
		d_rdy 		<=		rx_rdy;
	end	

	assign 		rdy 		=	rx_rdy & ~d_rdy;
	assign 		out 		=	trig;
	assign 		out_state 	=	state;

	localparam 		_idle = 3'b111, _stup = 3'b001, _stdown = 3'b010, _wait = 3'b011, _ctup = 3'b100, _cwait = 3'b101, _ctdown = 3'b000, _ccwait = 3'b110;

	always @ (posedge clk or negedge rst) begin : state_transfer
		if (~rst) 
						state 			<=			_idle;
		else begin
			case (state)
				_idle: begin
					if ((rdy == 1) && ((rx_out == 4'b0001) || (rx_out == 4'b0010) || (rx_out == 4'b0111)))
						state 		<=		_stup;
					else if ((rdy == 1) && ((rx_out == 4'b0100) || (rx_out == 4'b1000)))
						state 		<=		_ctup;
					else 
						state 		<= 		_idle;
				end
				_stup: begin
						state 		<=		_wait;
				end
				_wait: begin
					if (cnt == 0)
						state 		<=		_stdown;
					else 
						state 		<=		_wait;
				end
				_stdown: begin
						state 		<=		_idle;
				end
				_ctup: begin
					if ((rdy == 1) && (rx_out == 4'b0000))
						state 		<=		_idle;
					else if ((rdy == 1) && ((rx_out == 4'b0001) || (rx_out == 4'b0010) || (rx_out == 4'b0111)))
						state 		<=		_stup;
					else  
						state 		<=		_cwait;
				end
				_cwait: begin
					if ((rdy == 1) && (rx_out == 4'b0000))
						state 		<=		_idle;
					else if ((rdy == 1) && ((rx_out == 4'b0001) || (rx_out == 4'b0010) || (rx_out == 4'b0111)))
						state 		<=		_stup;
					else if (ccnt == 0)
						state 		<=		_ctdown;
					else  
						state 		<=		_cwait;
				end
				_ctdown: begin
					if ((rdy == 1) && (rx_out == 4'b0000))
						state 		<=		_idle;
					else if ((rdy == 1) && ((rx_out == 4'b0001) || (rx_out == 4'b0010) || (rx_out == 4'b0111)))
						state 		<=		_stup;
					else  
						state 		<=		_ccwait;
				end
				_ccwait: begin
					if ((rdy == 1) && (rx_out == 4'b0000))
						state 		<=		_idle;
					else if ((rdy == 1) && ((rx_out == 4'b0001) || (rx_out == 4'b0010) || (rx_out == 4'b0111)))
						state 		<=		_stup;
					else if (cccnt == 0)
						state 		<=		_ctup;
					else  
						state 		<=		_ccwait;
				end
				default:
						state 		<=		_idle;
			endcase
		end
	end

	always @ (posedge clk) begin : output_logic
		case (state)
			_idle: begin
				trig 		<=		0;
				cnt 		<=		10'b1111_1111_11;
				ccnt 		<=		10'b1111_1111_11;
				cccnt 		<=		28'b1111_1111_1111_1111_1111_1111_1111;
			end
			_stup: begin
				trig 		<=		1;
			end
			_wait: begin
				cnt 		<= 		cnt - 1'b1;
			end
			_stdown: begin
				trig 		<=		0;
			end
			_ctup:	begin
				trig 		<=		1;
			end
			_cwait: begin
				ccnt 		<=		ccnt - 1'b1;
			end
			_ctdown: begin
				trig 		<=		0; 	
			end
			_ccwait: begin
				cccnt 		<= 		cccnt - 1'b1;
			end
			default: begin
				trig 		<=		0;
				cnt 		<=		10'b1111_1111_11;
				ccnt 		<=		10'b1111_1111_11;
				cccnt 		<=		28'b1111_1111_1111_1111_1111_1111_1111;
			end
		endcase
	end
endmodule
