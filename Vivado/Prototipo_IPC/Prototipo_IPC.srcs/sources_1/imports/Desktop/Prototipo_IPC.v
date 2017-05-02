`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2017 06:42:57 PM
// Design Name: 
// Module Name: Prototipo_IPC
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

module Signal_Manager(
	input clk,
	input rst,
	input [1:0] Guest_ID_in,
	input [1:0] Guest_ID_Dest_in,
	input signal,
	output interrupt
	
);
    
    reg [3:0] Guest_Signal;
    
	always @ (signal) begin
    	case(Guest_ID_Dest_in)
        	    0 : Guest_Signal <= Guest_Signal || 4'b0001;
            	1 : Guest_Signal <= Guest_Signal || 4'b0010;
            	2 : Guest_Signal <= Guest_Signal || 4'b0100;
            	3 : Guest_Signal <= Guest_Signal || 4'b1000;
		endcase
	end

    
    assign interrupt = Guest_Signal && (1 << Guest_ID_in);  
    
    always @ (interrupt == 1)
    	Guest_Signal <= Guest_Signal && (0 << Guest_ID_in);
    

endmodule


module Prototipo_IPC(
    input clk,
	input rst,
    input [1:0] Guest_ID_in,
    input [31:0] ID_addr1_in,
    input [31:0] ID_addr2_in,
    input [31:0] ID_addr3_in,
    input [31:0] ID_addr4_in,
    output Signal_Guest,
    output [29:0] current_addr,
    input wire [2047:0] Data_in,
    output wire [2047:0] Data_out
    );
    
    
    reg [31:0] ID_addr1;
    reg [31:0] ID_addr2;
    reg [31:0] ID_addr3;
    reg [31:0] ID_addr4;
    
    reg [1:0] current_Guest_ID_dest;
    
    always @ (ID_addr1_in != 0) begin
    	ID_addr1 <= ID_addr1_in [31:0];
    end
    	
    always @ (ID_addr2_in != 0) begin
        ID_addr2 <= ID_addr2_in [31:0];
    end
    	
    always @ (ID_addr3_in != 0) begin
        ID_addr3 <= ID_addr3_in [31:0];
    end
    	
    always @ (ID_addr4_in != 0) begin
        ID_addr4 <= ID_addr4_in [31:0];
    end
  
    
    reg [1:0] Guest_ID; 
    
    always @ (Guest_ID_in)
    	Guest_ID <= Guest_ID_in;
    	
    reg [31:0] current_ID_addr;
    
    //wire [29:0] current_addr;
    wire [1:0] current_ID_dest;
    
    always @ (posedge clk) begin
        case(Guest_ID)
        0 : current_ID_addr <= ID_addr1;
        1 : current_ID_addr <= ID_addr2;
        2 : current_ID_addr <= ID_addr3;
        3 : current_ID_addr <= ID_addr4;
        endcase
    end
    
    assign current_addr = current_ID_addr [29:0];
	assign current_ID_dest = current_ID_addr [31:30];
	
	
	wire Dest_Guest_Signal;
	
	assign Dest_Guest_Signal = (Data_in != 0) ? 1 : 0;
	
	Signal_Manager Signal_Manager(
		.clk(clk),
		.rst(rst),
		.Guest_ID_in(Guest_ID),
		.Guest_ID_Dest_in(current_ID_dest),
		.signal(Dest_Guest_Signal),
		.interrupt(Signal_Guest)
	);
	
	assign Data_out = Data_in;
    
endmodule
