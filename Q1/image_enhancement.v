`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT Gandhinagar 
// Engineer(s): Jinay Dagli [20110084] and Neel Shah [20110187] 
// 
// Create Date: 29.08.2022 18:46:49
// Design Name: Image Enhancement
// Module Name: image_enhancement
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


module image_enhancement(input_img, clk, enhanced_img, en_out);
input [0:7] input_img; // Initialising all the required arrays and variables.
input clk;
output reg en_out;
output reg [0:7] enhanced_img;
reg [7:0] twod_array1[0:129][0:129];
reg [7:0] twod_array_inp[0:127][0:127];
reg signed [9:0] twod_array2[0:129][0:129];
reg [7:0] twod_array3[0:127][0:127];
reg en_out1, en_out2;
reg [0:7] smoothnd_img [0:127][0:127]; 
reg signed [0:7] sharpend_img [0:127][0:127];
//reg [0:7] added_img [0:127][0:127];
reg en_conv1, en_conv2, en_conv3;
integer i=1,j=1,k=0,l=0;
integer m=1,n=1,o=0,p=0;
integer q=0,r=0,s=0,t=0;



// smoothening
//Kindly check the smoothening code for more details.
always @(posedge clk)begin
    twod_array1[i][0] = 8'b0; //Padding
    twod_array1[0][j] = 8'b0;
    twod_array1[129][j] = 8'b0;
    twod_array1[i][129] = 8'b0;
    twod_array1[0][0] = 8'b0;
    twod_array1[0][129] = 8'b0;
    twod_array1[129][0] = 8'b0;
    twod_array1[129][129] = 8'b0;
    twod_array1[i][j] = input_img;
    twod_array_inp[i-1][j-1] = input_img;
    j=j+1;
    if(j>=129) begin
        i=i+1;
        j=1;
    end
    if(i>=129) begin
        en_conv1 = 1;
    end
    else en_conv1 = 0;    
end

always @(posedge clk) begin
    if (en_conv1 == 1) begin
        if(k==127 && l==127) begin
            smoothnd_img[k][l] = (twod_array1[k][l]+twod_array1[k][l+2]+twod_array1[k][l+1]+twod_array1[k+1][l]+twod_array1[k+1][l+1]+twod_array1[k+1][l+2]+ twod_array1[k+2][l]+ twod_array1[k+2][l+1]+ twod_array1[k+2][l+2])*7/64;
            en_out1 = 1;
            l=l+1;
            k=k+1;
            end
        else if ((k<127 && l<=127)||(k<=127 && l<127)) begin
            smoothnd_img[k][l] = (twod_array1[k][l]+twod_array1[k][l+2]+twod_array1[k][l+1]+twod_array1[k+1][l]+twod_array1[k+1][l+1]+twod_array1[k+1][l+2]+ twod_array1[k+2][l]+ twod_array1[k+2][l+1]+ twod_array1[k+2][l+2])*7/64;
            l=l+1;
        end
        if (l>=128)begin
            k=k+1;
            if (k>=128)begin
                en_conv1=0;
            end
            l=0;
        end
    end
    else begin
        en_out1 = 0;
    end
end




// sharpening
//Kindly check the sharpening code for more details.
always @(posedge clk)begin
    if (en_out1 == 1)begin
        twod_array2[m][0] = 10'b0;
        twod_array2[0][n] = 10'b0;
        twod_array2[129][n] = 10'b0;
        twod_array2[m][129] = 10'b0;
        twod_array2[0][0] = 10'b0;
        twod_array2[0][129] = 10'b0;
        twod_array2[129][0] = 10'b0;
        twod_array2[129][129] = 10'b0;
        twod_array2[m][n] = smoothnd_img[m-1][n-1];
        n=n+1;
        if(n>=129) begin
            m=m+1;
            n=1;
        end
        if(m>=129) begin
            en_conv2 = 1;
        end
        else en_conv2 = 0;
    end    
end

always @(posedge clk) begin
    if (en_conv2 == 1) begin
        if(o==127 && p==127) begin
            sharpend_img[o][p] = (-twod_array2[o][p+1]-twod_array2[o+1][p]+(4*twod_array2[o+1][p+1])-twod_array2[o+1][p+2]-twod_array2[o+2][p+1]);
            en_out2 = 1;
            p=p+1;
            o=o+1;
            end
        else if ((o<127 && p<=127)||(o<=127 && p<127)) begin
            sharpend_img[o][p] = (-twod_array2[o][p+1]-twod_array2[o+1][p]+(4*twod_array2[o+1][p+1])-twod_array2[o+1][p+2]-twod_array2[o+2][p+1]);
            if (sharpend_img[o][p] > 255)begin
                sharpend_img[o][p] = 8'b11111111;
            end
            if (sharpend_img[o][p] < 0) begin
                sharpend_img[o][p] = 8'b00000000;
            end
            p=p+1;
            end
        if (p>=128)begin
            o=o+1;
            if (o>=128)begin
                en_conv2=0;
            end
            p=0;
        end
    end
    else begin
        en_out2 = 0;
    end
end



// addition and normalization
//Kindly check the addition code for more details.
always @(posedge clk)begin
    if (en_out2 == 1)begin
            twod_array3[q][r] = sharpend_img[q][r];
            r=r+1;
            if(r>=128) begin
                q=q+1;
                r=0;
            end
            if(q>=128) begin
                en_conv3 = 1;
            end
            else begin
                en_conv3 = 0; 
            end 
    end
end

always @(posedge clk)begin
    if (en_conv3 == 1)begin
        if(s==127 && t==127) begin
            enhanced_img = (((twod_array_inp[s][t]) + twod_array3[s][t])-8'b00000110)*55/64;
            en_out = 1;
            t=t+1;
            s=s+1;
            end
        else if ((s<127 && t<=127)||(s<=127 && t<127)) begin
            enhanced_img = (((twod_array_inp[s][t]) + twod_array3[s][t])-8'b00000110)*55/64;
            t=t+1;
            en_out=1;
         end
        if (t>=128)begin
            s=s+1;
            if (s>=128)begin
                en_conv3=0;
            end
            t=0;
        end
    end
    else begin
        en_out = 0;
    end
end


endmodule
