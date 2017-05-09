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
	input [1:0] Guest_ID_i,       // Active Guest ID      
	input [1:0] Dest_Guest_ID_i,  // Destination Guest ID
	input Signal_Send_Data_i,     // When Active Guest ID send data to Dest Guest ID
	output reg Signal_Guest_o     // To signal Active Guest to read new message
);
    
    reg [3:0] Guest_Signal_r4;    // Each guest has a position in this register to save the interrupts

	always @ (posedge clk) begin
		if (rst) begin
			Guest_Signal_r4 <= 4'b0000;				
		end
		if(Signal_Guest_o) begin
			Guest_Signal_r4[Guest_ID_i] <= 0;  // Clear the bit of the active guest in the interrupt register , because it was signalized
		end
		if(Signal_Send_Data_i) begin
			Guest_Signal_r4[Dest_Guest_ID_i] <= 1'b1; // If data comes, set the bit for the Dest_Guest, for future interruption
		end
	end 
    
    always @(Guest_ID_i) begin
    	Signal_Guest_o = Guest_Signal_r4[Guest_ID_i]; // When the Active Guest changes it must check if it has an interruption in the Guest_Signal_r4    	
    end
    
endmodule


module Prototipo_IPC(
    input clk,
	input rst,
    input [1:0]  Guest_ID_i, 
    input [31:0] ID_addr1_i,
    input [31:0] ID_addr2_i,
    input [31:0] ID_addr3_i,
    input [31:0] ID_addr4_i,
    
    output Signal_Guest_o,
    output [29:0] Dest_Guest_Addr_o,
    
    input wire  [2047:0] Data_i,
    output wire [2047:0] Data_o
    );    
    
    reg [31:0] ID_addr1_r32;
    reg [31:0] ID_addr2_r32;
    reg [31:0] ID_addr3_r32;
    reg [31:0] ID_addr4_r32;
        
    // Set the possible addr for each Guest (it will be configured in the setup)
    always @ (ID_addr1_i != 0) begin
    	ID_addr1_r32 <= ID_addr1_i [31:0];
    end
    	
    always @ (ID_addr2_i != 0) begin
        ID_addr2_r32 <= ID_addr2_i [31:0];
    end
    	
    always @ (ID_addr3_i != 0) begin
        ID_addr3_r32 <= ID_addr3_i [31:0];
    end
    	
    always @ (ID_addr4_i != 0) begin
        ID_addr4_r32 <= ID_addr4_i [31:0];
    end
      
    reg [1:0] Guest_ID_r2; 
        
    always @ (Guest_ID_i)
    	Guest_ID_r2 <= Guest_ID_i;  // Save the Current/Active Guest ID
    	
    wire [31:0] Dest_Guest_ID_addr_w32;    
    wire [1:0]  Dest_Guest_ID_w2;    
    
    // Set the destination addr according to the Active Guest
    assign Dest_Guest_ID_addr_w32 = (Guest_ID_i == 0) ? ID_addr1_r32 :
    						 		(Guest_ID_i == 1) ? ID_addr2_r32 :
    						 		(Guest_ID_i == 2) ? ID_addr3_r32 :
    						 		(Guest_ID_i == 3) ? ID_addr4_r32 : 0;
     
    assign Dest_Guest_Addr_o = Dest_Guest_ID_addr_w32[29:0];
	assign Dest_Guest_ID_w2  = Dest_Guest_ID_addr_w32[31:30];  // The Destination Guest ID
		
	wire Dest_Guest_Signal;  // Signal to Signal Manager if data comes
		
	assign Dest_Guest_Signal = (Data_i != 0) ? 1 : 0;
	
	Signal_Manager Signal_Manager(
		.clk(clk),
		.rst(rst),
		.Guest_ID_i(Guest_ID_r2),
		.Dest_Guest_ID_i(Dest_Guest_ID_w2),
		.Signal_Send_Data_i(Dest_Guest_Signal),
		.Signal_Guest_o(Signal_Guest_o)
	);
		
	assign Data_o = Data_i;
    
endmodule
