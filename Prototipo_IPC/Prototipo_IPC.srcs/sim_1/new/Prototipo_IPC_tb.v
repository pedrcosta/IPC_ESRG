`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2017 09:22:02
// Design Name: 
// Module Name: Prototipo_IPC_tb
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

module Prototipo_IPC_tb();

`define	ADDR1 'h40000000
`define ADDR2 'h80000AAA
`define ADDR3 'hC000BBBB
`define ADDR4 'h300CCCCC

`define N_GUESTS 4

reg RUN;   //Controlling the execution

// Inputs
reg clk;
reg rst;
reg [1:0] Guest_ID_in;
reg [31:0] ID_addr1_in;
reg [31:0] ID_addr2_in;
reg [31:0] ID_addr3_in;
reg [31:0] ID_addr4_in;
reg [2047:0] Data_in;

// Outputs
wire Signal_Guest;
wire [29:0] current_addr;
wire [2047:0] Data_out;

// Instantiate the Prototipo IPC
Prototipo_IPC ipc(
	// Inputs			
    .clk(clk),
	.rst(rst),
    .Guest_ID_i(Guest_ID_in),
    .ID_addr1_i(ID_addr1_in),
    .ID_addr2_i(ID_addr2_in),
    .ID_addr3_i(ID_addr3_in),
    .ID_addr4_i(ID_addr4_in),
    .Data_i(Data_in),
    
    // Outputs
    .Signal_Guest_o(Signal_Guest),
    .Dest_Guest_Addr_o(current_addr),    
    .Data_o(Data_out)
    );



initial begin
	RUN = 3;
	clk = 0;	
	rst = 0;
	rst = 1;
	#10;
	rst = 0;
	Guest_ID_in = 0;
	Data_in = 0;
	
	
	setup_ADDR_Guests(`ADDR1, `ADDR2, `ADDR3, `ADDR4);
	
	while (RUN) begin
		write_Message(1);
		#10;
		print_Info;
		write_Message(0);
		#10;
		change_Guest;
		write_Message(0);
		#20;
		change_Guest;
		print_Info;
	end
		
	$display("\nSimulation Terminated");
end

task write_Message;
input full;
begin
	Data_in = (full == 1) ? ~Data_in : 512'h0;
//	$display("Full %b\nData_in: 0x%h\n", full, Data_in);
end
endtask


task change_Guest;		
	begin
		if(Guest_ID_in == `N_GUESTS) begin
			Guest_ID_in = 0;
			RUN = 0;
		end
		else begin
			Guest_ID_in = (Guest_ID_in + 1);
		end
	end
endtask

task setup_ADDR_Guests;
	input [31:0] addr1;
	input [31:0] addr2;
	input [31:0] addr3;
	input [31:0] addr4;
	
	begin
		ID_addr1_in = addr1;
		ID_addr2_in = addr2;
		ID_addr3_in = addr3;
		ID_addr4_in = addr4;		
	end
	
endtask

task print_Info;
begin
	$display("Active ID Guest | Interrupt | Message\n",
			"%16d|  %b  | 0x%x\n\n", Guest_ID_in, Signal_Guest, Data_in);
end
endtask


always #5 clk <= ~clk;

endmodule  //End of Prototipo_IPC_tb
