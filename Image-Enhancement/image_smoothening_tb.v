`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 24.08.2022 18:27:40
// Design Name: Image Smoothening
// Module Name: image_smoothening_tb
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

// The testbench begins here!
module image_smoothening_tb();
    reg [0:7]input_img;     //Declaring the inputs and outputs (of design) as reg and wire respectively.
    reg clk;
    wire [0:7] smoothnd_img;
    wire en_out;
    
    integer i, outfile, f, A;
    
    image_smoothening f1(input_img, clk, smoothnd_img, en_out); //Instantiating the design module.
    
    initial begin
        forever #1 clk = ~clk;  //The statement ensures a clocking signal of period 2s.
    end
    
    initial begin
        clk = 1;
        outfile = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/images.txt", "r");  //Reading the file one line at a time.
        while (!$feof(outfile)) begin               //Kindly change the location of file to where it is stored for you.
            $fscanf(outfile, "%d\n", A);
	        in_en = 1;
            input_img = A;  //Since all numbers are between 0 and 255, the input_img will be 8 bits long only.
            #2;
        end
        $fclose(outfile); //Close the file.
        #1;
        i=0;
        f = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/output.txt","w");  //Kindly change the location of file to where it is stored for you.
        while (!en_out)begin
            #1; //When en_out is zero, we have to wait and NOT write.
        end
        while (i != 16384)begin
            $fwrite(f,"%d\n",smoothnd_img); //Write the number after convolution into the text file.
            #2;
            i=i+1;
        end
        $fclose(f);
    end
 
endmodule