`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 28.08.2022 14:40:50
// Design Name: Image Sharpening
// Module Name: image_sharpening
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

// The image sharpening module starts here!
module image_sharpening(input_img, clk, sharpend_img, en_out);
input [0:7] input_img;          //Declaring input image bits, taken 8 bits at a time.
input clk;                      // At every posedge of clock, 8 bits are being taken.
output reg en_out;              //An enable signal used to write into the text file whenever the 8 bits are found.
output reg signed [0:9] sharpend_img;   //Declaring one element (signed) of the sharpened image matrix.
reg signed [9:0] twod_array[0:129][0:129];  //The original 2D array formed after sharpening.
reg en_conv;    //An enable signal that tells us when the matrix is filled with the required elements.
integer i=1,j=1;    //Some variables initialised.
integer k=0,l=0;

always @(posedge clk)begin
//The following few lines ensures that the padding of zeros is done properly, leading to a 130x130 dimensional matrix.
    twod_array[i][0] = 10'b0;
    twod_array[0][j] = 10'b0;
    twod_array[129][j] = 10'b0;
    twod_array[i][129] = 10'b0;
    twod_array[0][0] = 10'b0;
    twod_array[0][129] = 10'b0;
    twod_array[129][0] = 10'b0;
    twod_array[129][129] = 10'b0;
    twod_array[i][j] = input_img;
    j = j + 1;
    if(j>=129) begin
        i = i + 1;
        j = 1;
    end
    if(i>=129) begin
        en_conv = 1;        //When the matrix is filled, en_conv is enabled!
    end
    else en_conv = 0;    
end

always @(posedge clk) begin
//The following few lines perform the required convolution!
    if (en_conv == 1) begin
        if (k==127 && l==127) begin
            sharpend_img = (-twod_array[k][l+1]-twod_array[k+1][l]+(4*twod_array[k+1][l+1])-twod_array[k+1][l+2]-twod_array[k+2][l+1]); //Handles one of the corner cases.
            en_out = 1;     //This element is written into the text file when this enable signal is ON.
            l = l + 1;
            k = k + 1;
        end
        else if ((k<127 && l<=127)||(k<=127 && l <127)) begin
            sharpend_img = (-twod_array[k][l+1]-twod_array[k+1][l]+(4*twod_array[k+1][l+1])-twod_array[k+1][l+2]-twod_array[k+2][l+1]);
            //This two if blocks nomalizes the output. If the number is > than 255, it is set to 255. Else, if it is < 0, it is set to 0.
            if (sharpend_img > 255)begin
                sharpend_img = 10'b0011111111;
            end
            if (sharpend_img < 0) begin
                sharpend_img = 10'b0000000000;
            end
            l=l+1;
            en_out=1;   //This element is written into the text file when this enable signal is ON.
        end
        if (l>=128) begin   //When one row is being completed, increment k and set l to 0 again.
            k=k+1;
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
