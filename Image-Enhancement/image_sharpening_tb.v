`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 28.08.2022 14:41:55
// Design Name: Image Sharpening
// Module Name: image_sharpening_tb
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
module image_sharpening_tb();
    reg [0:7]input_img;     //Declaring the inputs and outputs (of design) as reg and wire respectively.
    reg clk;
    wire signed [0:9] sharpend_img;
    wire en_out;
    
    integer i, outfile, f, A;
    
    image_sharpening f2(input_img, clk, sharpend_img, en_out);  //Instantiating the design module.
    
    initial begin
        forever #1 clk = ~clk;      //The statement ensures a clocking signal of period 2s.
    end
    
    initial begin
        i=0;
        clk = 1;
        outfile = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/output.txt", "r");   //Kindly change the location of file to where it is stored for you.
        while (!$feof(outfile)) begin       //Reading the file one line at a time.
            $fscanf(outfile, "%d\n", A);
            input_img = A;      //Since all numbers are between 0 and 255, the input_img will be 8 bits long only.
            #2;
        end
        $fclose(outfile); //Close the file.
        
        
        #1;
//        i =0;
        f = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/output1.txt","w");     //Kindly change the location of file to where it is stored for you.
        while (!en_out)begin
            #1;     //When en_out is zero, we have to wait and NOT write.
        end
        while (i != 16384)begin
            $fwrite(f,"%d\n",sharpend_img); //Write the number after convolution into the text file.
            #2;
            i=i+1;
        end
        $fclose(f);
    end
endmodule
