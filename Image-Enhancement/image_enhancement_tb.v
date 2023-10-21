`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 29.08.2022 18:50:23
// Design Name: Image Enhancement
// Module Name: image_enhancement_tb
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

// Kindly check the other testbenches for more details.
module image_enhancement_tb();
    reg [0:7] input_img;
    reg clk;
    reg in_en;
    wire [0:7] enhanced_img;
    wire en_out;
    
    integer i, outfile, f, A;
    
    image_enhancement f1(input_img, clk, enhanced_img, en_out);
    
    initial begin
        forever #1 clk = ~clk;
    end
    
    initial begin
        i=0;
        clk = 1;
        in_en = 0;
        outfile = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/images.txt", "r");
        while (!$feof(outfile)) begin
            $fscanf(outfile, "%d\n", A);
	        in_en = 1;
            input_img = A;
            i=i+1;
            #2;
        end
        $fclose(outfile);
        
        #1;
        i=0;
        f = $fopen("C:/Users/HP/OneDrive/Desktop/Sem 5/VLSI/Assignment 2/output2.txt","w");
        while (!en_out)begin
            #1; 
        end
        while (i != 16384)begin
            $fwrite(f,"%d\n",enhanced_img);
            #2;
            i=i+1;
        end
        $fclose(f);
    end

endmodule
