`timescale 1ns / 1ps

module Testbench;
    // Parameters
    parameter KERNEL_SIZE = 8;
    parameter STRIDE = 1;
    
    // Inputs
    reg [31:0] Data_in;
    reg [1:0] Kernel_Serial_Input;
    reg Last_Data_In, Clk, Rst;
    
    // Outputs
    wire [31:0] Data_Out;
    wire Last_Data_Out; 
	 integer i = 0;

    // Instantiate the module
    SAM_Con #(KERNEL_SIZE, STRIDE) uut (
        .Data_in(Data_in),
        .Data_Out(Data_Out),
        .Kernel_Serial_Input(Kernel_Serial_Input),
        .Last_Data_In(Last_Data_In),
        .Last_Data_Out(Last_Data_Out),
        .Clk(Clk),
        .Rst(Rst)
    );
    
    // Clock generation
    always #5 Clk = ~Clk;
    
    initial begin
        // Initialize Inputs
        Clk = 0;
        Rst = 1;
        Data_in = 0;
        Kernel_Serial_Input = 0;
        Last_Data_In = 0;
        // Reset pulse
        #10;
        Rst = 0;
        #5;
        // Apply test inputs
        for (i = 0; i < 16; i = i + 1) begin
            Data_in = i;
            Kernel_Serial_Input = i % 2;
            Last_Data_In = (i == 15) ? 1 : 0;
            #10;
        end
        
        // Wait for processing to complete
        #100;
        
        // Stop simulation
        $stop;
    end
    
endmodule
