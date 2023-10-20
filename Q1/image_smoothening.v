`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 24.08.2022 18:27:40
// Design Name: Image Smoothening
// Module Name: image_smoothening
// Project Name: Image Enhancement
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

// The image smoothening module starts here!
module image_smoothening(input_img, clk, smoothnd_img, en_out);
input [0:7] input_img;  //Declaring input image bits, taken 8 bits at a time.
input clk;              // At every posedge of clock, 8 bits are being taken.
output reg en_out;      //An enable signal used to write into the text file whenever the 8 bits are found.
output reg [0:7] smoothnd_img;              //Declaring one element of the smoothened image matrix.
reg [7:0] twod_array[0:129][0:129];         //The original 2D array formed after smoothening.
reg en_conv;            //An enable signal that tells us when the matrix is filled with the required elements.
integer i=1, j=1;       //Some variables initialised.
integer k=0, l=0;

always @(posedge clk)begin
//The following few lines ensures that the padding of zeros is done properly, leading to a 130x130 dimensional matrix.
    twod_array[i][0] = 8'b0;
    twod_array[0][j] = 8'b0;
    twod_array[129][j] = 8'b0;
    twod_array[i][129] = 8'b0;
    twod_array[0][0] = 8'b0;
    twod_array[0][129] = 8'b0;
    twod_array[129][0] = 8'b0;
    twod_array[129][129] = 8'b0;
    twod_array[i][j] = input_img;
    j = j + 1;
    if (j>=129) begin
        i = i + 1;
        j = 1;
    end
    if (i>=129) begin
        en_conv = 1;        //When the matrix is filled, en_conv is enabled!
    end
    else en_conv = 0;    
end

always @(posedge clk) begin
//The following few lines perform the required convolution!
    if (en_conv == 1) begin
        if(k==127 && l==127) begin
            smoothnd_img = (twod_array[k][l]+twod_array[k][l+2]+twod_array[k][l+1]+twod_array[k+1][l]+twod_array[k+1][l+1]+twod_array[k+1][l+2]+ twod_array[k+2][l]+ twod_array[k+2][l+1]+ twod_array[k+2][l+2])*7/64; //Handles one of the corner cases.
            en_out = 1; //This element is written into the text file when this enable signal is ON.
            l = l + 1;
            k = k + 1;
        end
        else if ((k<127 && l<=127)||(k<=127 && l <127)) begin
            smoothnd_img = (twod_array[k][l]+twod_array[k][l+2]+twod_array[k][l+1]+twod_array[k+1][l]+twod_array[k+1][l+1]+twod_array[k+1][l+2]+ twod_array[k+2][l]+ twod_array[k+2][l+1]+ twod_array[k+2][l+2])*7/64;
            l = l + 1;
            en_out = 1; //This element is written into the text file when this enable signal is ON.
        end
        if (l>=128) begin //When one row is being completed, increment k and set l to 0 again. 
            k = k + 1;
            if (k>=128) begin
                en_conv = 0; //When the values of k and l exceed the matrix dimension, we need to stop writing into the text file.
            end
            l = 0;
        end
    end
    else begin
        en_out = 0;
    end
end
endmodule
