`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Indian Institute of Technology Gandhinagar 
// Engineer: Jinay Dagli [20110084] and Neel Shah [20110187]
// 
// Create Date: 28.08.2022 14:48:52
// Design Name: SPI Communication Protocol with One Master and Three Slaves
// Module Name: spimaster_tb
// Project Name: Assignment-2 [EE-617 VLSI Design]
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


module spi_final_tb();
parameter n=7; //Defining the parameter n=7 for 8-bits.
reg clk, ss0, ss1, ss2, load, rst; //Declaring the inputs as reg.
reg [0:7] data_inp; //Declaring the data input.
wire [0:7] master_data1; //Declaring the outputs as wire.
wire mosi;
wire [0:7] slave_data1, slave_data2, slave_data3;

//Instantiating the module!
top_spi_final uut(data_inp, load, clk, rst, ss0, ss1, ss2, mosi, master_data1, slave_data1, slave_data2, slave_data3);

initial
    begin
      forever
        #2 clk=~clk; //Setting the clock time period.
    end

//Giving the test cases.
initial begin
clk = 1;
rst = 1;
load = 0;
ss0 = 0;
ss1 = 0;
ss2 = 0;
data_inp = 8'b11111111;
#4;
rst = 0;
load = 1;
#4;
load = 0;
ss0 = 1;
ss1 = 0;
ss2 = 0;
#32;
ss0 = 0;
ss1 = 0;
ss2 = 1;
#32;
$finish;
end
endmodule
