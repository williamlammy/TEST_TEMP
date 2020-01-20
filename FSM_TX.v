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


module FSM_TX #
	(
		parameter 		SIZE				=		32,
		parameter 		T 				    =		32'b0_0000_0000_1111_1010_000000000000000,
		parameter 		V  				    =		32'b0_0000_0001_0101_0100_000000000000000
	)
	(
		input 			[3:0]							rx_out,
		input											echo_rdy,
		input 			[SIZE-1:0]						echo_out,
		input 			[SIZE-1:0]						config_N_ref,
		input 											control,
		input 											clk,
		input 											rst,

		
		output wire 							 		tx_rdy,
		output wire 	[SIZE-1:0]						tx_out
    );

    reg 					[1:0]		 				mux_to_tx_ctr_reg;
    wire 					[1:0] 						mux_to_tx_ctr;

    wire 							 					temp_rdy;
	wire 					[SIZE-1:0]					temp_out;

	wire 							 					dist_rdy;
	wire 					[SIZE-1:0]					dist_out;

	reg 					[2:0] 						state;

	reg 							 					rdy_default_reg				=		0;
	wire 												rdy_default;

	reg 					[SIZE-1:0] 					buff_default_reg			=		0;
	wire 					[SIZE-1:0]					buff_default;

    assign 										mux_to_tx_ctr 		=		mux_to_tx_ctr_reg;	

defparam calculator.SIZE		=	SIZE;
defparam calculator.T 			=	T;
defparam calculator.V 			=	V;

	CALCULATION calculator 
	(
		.echo_rdy(echo_rdy),
		.echo_out(echo_out),
		.config_N_ref(config_N_ref),
		.clk(clk),
		.temp_rdy(temp_rdy),
		.temp_out(temp_out),
		.dist_rdy(dist_rdy),
		.dist_out(dist_out)
	);
defparam mux_data.BUS_WIDTH 		=	SIZE;

	MUX_4_1 mux_data 
	(
		.input_1(configue),
		.input_2(dist_out),
		.input_3(temp_out),
		.input_4(buff_default),
		.select(mux_to_tx_ctr),
		.out(tx_out)
	);

defparam mux_rdy.BUS_WIDTH 		=	1;

	MUX_4_1 mux_rdy
	(
		.input_1(control),
		.input_2(dist_rdy),
		.input_3(temp_rdy),
		.input_4(rdy_default),
		.select(mux_to_tx_ctr),
		.out(tx_rdy)
	);

	localparam _idle = 3'b111, _stemp = 3'b001, _ctemp = 3'b010, _sdist = 3'b011, _cdist = 3'b100, _config = 3'b101; 


	always @ (posedge clk or negedge rst) begin
		if (~rst)
					state 		<=		_idle;
		else begin
			case (state)
				_idle: begin
					if (rx_out == 4'b0111)
						state 	<=		_config;
					else 
						state 	<=		_idle; 
				end
				_config: begin
					if ((rx_out == 4'b0001) && (control == 1))
						state 	<=		_stemp;
					else if ((rx_out == 4'b0100) && (control == 1))
						state 	<=		_ctemp;
					else if ((rx_out == 4'b0010) && (control == 1))
						state 	<=		_sdist;
					else if ((rx_out == 4'b1000) && (control == 1))
						state 	<=		_cdist;
					else if (control == 0)
						state 	<=		_idle;
					else 
						state 	<=		_config;
				end
				_stemp: begin
					if ((rx_out == 4'b0001) && (control == 1))
						state 	<=		_stemp;
					else if ((rx_out == 4'b0100) && (control == 1))
						state 	<=		_ctemp;
					else if ((rx_out == 4'b0010) && (control == 1))
						state 	<=		_sdist;
					else if ((rx_out == 4'b1000) && (control == 1))
						state 	<=		_cdist;
					else if ((rx_out == 4'b0111) && (control == 0))
						state 	<=		_config;
					else if (control == 0)
						state 	<=		_idle;
					else 
						state 	<=		_stemp;
				end
				_ctemp: begin
					if ((rx_out == 4'b0001) && (control == 1))
						state 	<=		_stemp;
					else if ((rx_out == 4'b0100) && (control == 1))
						state 	<=		_ctemp;
					else if ((rx_out == 4'b0010) && (control == 1))
						state 	<=		_sdist;
					else if ((rx_out == 4'b1000) && (control == 1))
						state 	<=		_cdist;
					else if ((rx_out == 4'b0111) && (control == 0))
						state 	<=		_config;
					else if (control == 0)
						state 	<=		_idle;
					else 
						state 	<=		_ctemp;
				end
				_sdist: begin
					if ((rx_out == 4'b0001) && (control == 1))
						state 	<=		_stemp;
					else if ((rx_out == 4'b0100) && (control == 1))
						state 	<=		_ctemp;
					else if ((rx_out == 4'b0010) && (control == 1))
						state 	<=		_sdist;
					else if ((rx_out == 4'b1000) && (control == 1))
						state 	<=		_cdist;
					else if ((rx_out == 4'b0111) && (control == 0))
						state 	<=		_config;
					else if (control == 0)
						state 	<=		_idle;
					else 
						state 	<=		_sdist;
				end
				_cdist: begin
					if ((rx_out == 4'b0001) && (control == 1))
						state 	<=		_stemp;
					else if ((rx_out == 4'b0100) && (control == 1))
						state 	<=		_ctemp;
					else if ((rx_out == 4'b0010) && (control == 1))
						state 	<=		_sdist;
					else if ((rx_out == 4'b1000) && (control == 1))
						state 	<=		_cdist;
					else if ((rx_out == 4'b0111) && (control == 0))
						state 	<=		_config;
					else if (control == 0)
						state 	<=		_idle;
					else 
						state 	<=		_cdist;
				end
				default: begin
						state 	<=		_idle;
				end
			endcase
		end
	end

	always @ (posedge clk) begin
		case (state)
			_idle:
				mux_to_tx_ctr_reg 	<=		2'b00;
			_stemp:
				mux_to_tx_ctr_reg 	<=		2'b01;
			_ctemp:
				mux_to_tx_ctr_reg 	<=		2'b01;
			_sdist:
				mux_to_tx_ctr_reg 	<=		2'b10;
			_cdist:
				mux_to_tx_ctr_reg 	<=		2'b10;
			_config:
				mux_to_tx_ctr_reg 	<=		2'b11;
			default:
				mux_to_tx_ctr_reg 	<=		2'b00;
		endcase
	end



endmodule


module MUX_4_1 #
	(
		parameter 		BUS_WIDTH 		=		32
	)
	(
		input 			[BUS_WIDTH-1:0]		input_1,
		input 			[BUS_WIDTH-1:0]		input_2,
		input 			[BUS_WIDTH-1:0]		input_3,
		input 			[BUS_WIDTH-1:0]		input_4,

		input 			[1:0] 				select,

		output 	wire 	[BUS_WIDTH-1:0] 	out
	);

	assign 		out 	=	select[1] ? (select[0] ? input_1 : input_2) : (select[0] ? input_3 : input_4);

endmodule