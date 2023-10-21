`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: Indian Institute of Technology Gandhinagar 
// Engineer: Jinay Dagli [20110084] and Neel Shah [20110187]
// 
// Create Date: 28.08.2022 17:31:08
// Design Name: SPI Communication Protocol with One Master and Three Slaves
// Module Name: spi_final
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


module top_spi_final(data_inp, load, clk, rst, ss0, ss1, ss2, mosi, master_data1, slave_data1, slave_data2, slave_data3);
input clk, ss0, ss1, ss2, load, rst; //Declaring the required inputs: Clock, select ports for the three slaves, a load, and reset.
input [0:7] data_inp; //Input to be loaded to the master.
output reg mosi; //MOSI is the output taken as the last bit of master that gets transferred to the slave.
//wire [0:7] master_data; 
output reg [0:7] master_data1, slave_data1, slave_data2, slave_data3; //Defining the data in master and the three slaves as the output of 8 bits.

always@(posedge clk)
begin
    if(rst) begin
        master_data1 <= 8'b0; //On reset, set everything to zero!
        slave_data1 <= 8'b0;
        slave_data2 <= 8'b0;
        slave_data3 <= 8'b0;
        mosi <= 0;
        end
    if(load) begin
        master_data1 <= data_inp; //On loading, load the input data to the master.
        mosi <= master_data1[7];
        end
    if(ss0 == 1) begin //When ss0 is high, it right-shifts the master data and slave data until clock edge is found and ss0 is high.
        slave_data1[0] <= master_data1[7];
        master_data1[0] <= slave_data1[7];
        master_data1[1:7] <= master_data1[0:6];
        slave_data1[1:7] <= slave_data1[0:6];
        mosi <= master_data1[7];
    end
    else if(ss1 == 1) begin //When ss1 is high, it right-shifts the master data and slave data until clock edge is found and ss1 is high.
        slave_data2[0] <= master_data1[7];
        master_data1[0] <= slave_data2[7];
        master_data1[1:7] <= master_data1[0:6];
        slave_data2[1:7] <= slave_data2[0:6];
        mosi <= master_data1[7];
    end
    else if(ss2 == 1) begin //When ss1 is high, it right-shifts the master data and slave data until clock edge is found and ss2 is high.
        slave_data3[0] <= master_data1[7];
        master_data1[0] <= slave_data3[7];
        master_data1[1:7] <= master_data1[0:6];
        slave_data3[1:7] <= slave_data3[0:6];
        mosi <= master_data1[7];
    end
end

endmodule