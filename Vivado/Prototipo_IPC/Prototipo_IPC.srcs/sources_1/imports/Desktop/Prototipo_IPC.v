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


module Prototipo_IPC(
    input [1:0] Guest_ID_in,
    input clk,
    input [31:0] addr1_in,
    input [31:0] addr2_in,
    input [31:0] addr3_in,
    input [31:0] addr4_in,
    output reg [3:0] Signal_Guest,
    output reg [31:0] current_addr,
    //input rst,
    input [2048:0] Data_in,
    output [2048:0] Data_out
    );
    
    
    reg [31:0] addr1;
    reg [31:0] addr2;
    reg [31:0] addr3;
    reg [31:0] addr4;   
    
    always @ (addr1_in != 0)
    	addr1 <= addr1_in;
    	
    always @ (addr2_in != 0)
    	addr2 <= addr2_in;
    	
    always @ (addr3_in != 0)
    	addr3 <= addr3_in;
    	
    always @ (addr4_in != 0)
    	addr4 <= addr4_in;
  
    
    reg [1:0] Guest_ID; 
    
    always @ (Guest_ID_in)
    	Guest_ID <= Guest_ID_in;
    	
    
    always @ (posedge clk)
    begin
        case(Guest_ID)
        0 : current_addr <= addr1;
        1 : current_addr <= addr2;
        2 : current_addr <= addr3;
        3 : current_addr <= addr4;
        endcase
    end


    //always @ (clk)
    //    Signal_Guest =  Signal_Guest && 1 << Guest_ID;
    

	always @ (clk)
    begin
        case(Guest_ID)
        0 : Signal_Guest = 4'b0001;
        1 : Signal_Guest = 4'b0010;
        2 : Signal_Guest = 4'b0100;
        3 : Signal_Guest = 4'b1000;
        endcase
    end
    
    
endmodule
