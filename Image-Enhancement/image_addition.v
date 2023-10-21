`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 28.08.2022 15:08:13
// Design Name: Image Addition
// Module Name: image_addition
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

//The Image Addition module starts here!
module image_addition(input1_img, input2_img, clk, added_img, en_out);
input [0:7] input1_img, input2_img;     //Declaring input image bits, taken 8 bits at a time.
input clk;          // At every posedge of clock, 8 bits are being taken.
output reg en_out;  //An enable signal used to write into the text file whenever the 8 bits are found.
output reg [0:8] added_img; //Declaring one element of the added image matrix.
reg [0:7] twod_array1[0:127][0:127];    //The original 2D array formed after sharpening.
reg [0:7] twod_array2[0:127][0:127];    //The original 2D array given.
reg en_conv, en_conv1;      //Two enable signals that tells us when the matrices are filled with the required elements.
integer i=0,j=0;        //Some variables initialised.
integer k=0,l=0;
integer m=0,n=0;

always @(posedge clk)begin
    twod_array1[i][j] = input1_img; //This always block gets the 2D array from the image obtained after sharpening.
    j=j+1;
    if(j>=128) begin
        i=i+1;
        j=0;
    end
    if(i>=128) begin
        en_conv = 1;    //When the matrix is filled, en_conv is enabled!
    end
    else begin
        en_conv = 0; 
    end   
end

always @(posedge clk)begin
    if (en_conv == 1)begin      //This always block gets the 2D array from the original image.
        twod_array2[m][n] = input2_img;
        n=n+1;
        if(n>=128) begin
            m=m+1;
            n=0;
        end
        if(m>=128) begin
            en_conv1 = 1;
        end
        else begin
            en_conv1 = 0; 
        end 
    end
 
end

always @(posedge clk)begin
//The following few lines perform the required convolution!
    if (en_conv1 == 1)begin
        if(k==127 && l==127) begin
            added_img = (((twod_array2[k][l]) + twod_array1[k][l])-8'b00000110)*55/64;  //Handles one of the corner cases.
            en_out = 1;     //This element is written into the text file when this enable signal is ON.
            l = l + 1;
            k = k + 1;
            end
        else if ((k<127 && l<=127)||(k<=127 && l <127)) begin
            added_img = (((twod_array2[k][l]) + twod_array1[k][l])-8'b00000110)*55/64;
            l = l + 1;
            en_out = 1;       //This element is written into the text file when this enable signal is ON.
         end
        if (l>=128)begin    //When one row is being completed, increment k and set l to 0 again.
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
