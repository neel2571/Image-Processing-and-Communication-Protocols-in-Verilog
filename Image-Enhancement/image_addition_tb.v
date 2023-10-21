`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute:  IIT Gandhinagar
// Engineer: Jinay Dagli [20110084] and Neel Shah [20110187]
// 
// Create Date: 28.08.2022 15:08:54
// Design Name: Imae Addition
// Module Name: image_addition_tb
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

// The testbench starts here!
module image_addition_tb();
    reg [0:7]input1_img;    //Declaring the inputs and outputs (of design) as reg and wire respectively.
    reg [0:7]input2_img;
    reg clk;
    wire [0:8] added_img;
    wire en_out;
    
    integer i, outfile, f, A, B;
    
    image_addition f3(input1_img, input2_img, clk, added_img, en_out);  //Instantiating the design module.
    
    initial begin
        forever #1 clk = ~clk;      //The statement ensures a clocking signal of period 2s.
    end
    
    initial begin
        i=0;
        clk = 1;
        //in_en = 0;
        outfile = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/output1.txt", "r");  //Kindly change the location of file to where it is stored for you.
        while (!$feof(outfile)) begin
            $fscanf(outfile, "%d\n", A);
//	        in_en = 1;
            input1_img = A; //This includes the sharpened image.
            i=i+1;
            if (i!=16384)
            #2;
        end
        $fclose(outfile);

        outfile = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/images.txt", "r");
        while (!$feof(outfile)) begin
            $fscanf(outfile, "%d\n", B);
            input2_img = B;     //This includes the original image.
            #2;
        end
        $fclose(outfile);
        #1;
        i =0;
        f = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/output3.txt","w");
        while (!en_out)begin
            #1;     //When en_out is zero, we have to wait and NOT write.
        end
        while (i != 16384)begin
            $fwrite(f,"%d\n",added_img);        //Write the number after convolution into the text file.
            #2;
            i=i+1;
            if (i == 16383)begin
                $fwrite(f,"%d\n",added_img);
                i=i+1;
            end
        end
        $fclose(f);
    end
endmodule

