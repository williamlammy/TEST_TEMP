`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: williamlammy	
// 
// Create Date: 11.01.2020 11:40:51
// Design Name: 
// Module Name: TOP
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


module TOP #
	(
		parameter       CLK_FREQ        =       100_000_000,
        parameter       BAUD_RATE     	=       115_200,
        parameter 		DISTANSE 		=		32'b0000_0000_0001_1000_0000_1101_1111_0011
	)
	
	(
		input 								clk,
		//input 								ctr,
		input								rst,
		input 								RX_in,
		input 								echo,

		//output wire 				 		out,
		//output 	wire 		[3:0] 			out_state,
		output 	wire 						tx_out,
		output 	wire 						triger
    );

    assign 						nrst = !rst;
    wire 		[7:0] 			rx_out; 
    wire 		[3:0]			rx_out_red;
    wire 						rx_rdy;
    wire 		[31:0]			data;
    wire 		[7:0] 			to_tx;
    reg 						conf_reg 		=		1'b1;
    wire 						conf;
    reg 		[31:0] 			N_conf_reg 		=		DISTANSE;
    wire 		[31:0] 			N_conf;		
    wire 						e_rdy;
    wire 		[31:0] 			e_pulse;
    wire 						ctr;	

    assign 						rx_out_red 		=		{rx_out[3:0]};
    assign 						to_tx 			=		{data[22:15]};
    assign 						N_conf 			=		N_conf_reg;
    assign 						conf 			=		conf_reg;

		
    reg 								ctr_dly_1;
    reg 								ctr_dly_2;
    reg 								ctr_dly_3;

    always @ (posedge clk) begin
    	ctr_dly_1 		<=		ctr;
    	ctr_dly_2		<=		ctr_dly_1;
    	ctr_dly_3 		<=		ctr_dly_2; 
    end

    wire 						ctr_n;

    assign 						ctr_n 		=		ctr & ~ctr_dly_3;


defparam uart_rx.CLK_FREQ 		=		CLK_FREQ;
defparam uart_rx.BAUD_RATE 		=		BAUD_RATE;

UART_RX uart_rx 
	(
		.clk(clk),
		.RX_rst(nrst),
		.RX_in(RX_in),
		.RX_out(rx_out),
		.RX_rdy(rx_rdy)
	);

defparam uart_tx.CLK_FREQ 		=		CLK_FREQ;
defparam uart_tx.BAUD_RATE 		=		BAUD_RATE;

UART_TX uart_tx 
	(
		.clk(clk),
		.TX_rst(nrst),
		.TX_in(to_tx),
		.TX_ctr(ctr_n),
		.TX_out(tx_out)
	);


FSM_RX fsm_rx 
	(
		.rx_rdy(rx_rdy),
		.rx_out(rx_out_red),
		.clk(clk),
		.rst(nrst),
		.out(triger)
	);



defparam fsm_tx.SIZE 		=			32;
defparam fsm_tx.T 			=			32'b0_0000_0000_1111_1010_000000000000000;
defparam fsm_tx.V 			=			32'b0_0000_0001_0101_0100_000000000000000;

FSM_TX fsm_tx 
	(
		.rx_out(rx_out_red),
		.echo_rdy(e_rdy),
		.echo_out(e_pulse),
		.config_N_ref(N_conf),
		.control(conf),
		.clk(clk),
		.rst(nrst),
		.tx_rdy(ctr),
		.tx_out(data)
	);

defparam echo.LENGTH 		=			32;

ECHO echo 
	(
		.in_pulse(echo),
		.clk(clk),
		.rst(nrst),
		.rdy(e_rdy),
		.pulse_width(e_pulse)
	);

endmodule
