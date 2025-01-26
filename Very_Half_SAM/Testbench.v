`timescale 1ns/1ps // Specify time unit and time precision

module Testbench;

    // Clock and reset signals
    reg clk;
    reg rst;

    // Memory signals
    wire en;
    wire rw;
    wire [7:0] aBus;
    wire [7:0] dBus;
	 reg [7:0] dBus_reg;
	 
	 assign dBus = dBus_reg;

    // Console interface signals
    reg pause;
    reg [1:0] regSelect;
    wire [7:0] dispReg;
	
    // Memory array
    reg [7:0] Memory [0:63];

    // Instantiate the DUT
    Toplevel DUT (
        .clk(clk),
        .rst(rst),
        .En(en),
        .Rw(rw),
        .Address_Bus(aBus),
        .Data_Bus(dBus),
        .pause(pause),
        .regSelect(regSelect),
        .dispReg(dispReg)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Reset generation
    initial begin
        rst = 1;
        #20 rst = 0;
    end

    // Initialize memory
    initial begin
		  regSelect = 2'b10;
		  pause = 1'b0;
        Memory[0]  = 8'b00010111; // branch 8
        Memory[1]  = 8'b01100001; // data
        Memory[2]  = 8'b00000001; // data
        Memory[3]  = 8'b00000010; // data
        Memory[4]  = 8'b00000000; // data
        Memory[5]  = 8'b00000000; // data
        Memory[6]  = 8'b00000000; // data
        Memory[7]  = 8'b11111101; // data (-3)
        Memory[8]  = 8'b00010111; // branch 8
        Memory[9]  = 8'b00000000; // data
        Memory[10] = 8'b00000000; // data
        Memory[11] = 8'b11110110; // data (-10)
        Memory[12] = 8'b00000111; // data (7)
        Memory[13] = 8'b00000000; // register
        Memory[14] = 8'b11111111; // data
        Memory[15] = 8'b00000110; // data
        Memory[16] = 8'b00010010; // branch 3
        Memory[17] = 8'b00000000; // na
        Memory[18] = 8'b00000000; // na
        Memory[19] = 8'b01100011; // cload #3H
        Memory[20] = 8'b11000001; // andd 1H
        Memory[21] = 8'b10010100; // dstore 4H
        Memory[22] = 8'b10000010; // iload 2H
        Memory[23] = 8'b10110001; // add 1H
        Memory[24] = 8'b11000011; // andd 3H
        Memory[25] = 8'b10101111; // istore FH
        Memory[26] = 8'b10111110; // add EH
        Memory[27] = 8'b10010101; // dstore 5H
        Memory[28] = 8'b01110111; // dload 7H
        Memory[29] = 8'b00000001; // negate
        Memory[30] = 8'b10010111; // dstore 7H
        Memory[31] = 8'b10001100; // iload CH
        Memory[32] = 8'b10011101; // dtore DH
        Memory[33] = 8'b10001111; // iload FH
        Memory[34] = 8'b10111101; // add DH
        Memory[35] = 8'b10011101; // dstore DH
        Memory[36] = 8'b01111111; // dload FH
        Memory[37] = 8'b10110010; // add 2H
        Memory[38] = 8'b10011111; // dstore FH
        Memory[39] = 8'b01111100; // dload CH
        Memory[40] = 8'b10110010; // add 2H
        Memory[41] = 8'b10011100; // dstore CH
        Memory[42] = 8'b01111101; // dload DH
        Memory[43] = 8'b10101100; // istore CH
        Memory[44] = 8'b01111100; // dload CH
        Memory[45] = 8'b10111011; // add BH
        Memory[46] = 8'b00100001; // brZero 2H
        Memory[47] = 8'b01011000; // brInd 9H
        Memory[48] = 8'b01110010; // dload 2H
        Memory[49] = 8'b00110001; // brPos 2H
        Memory[50] = 8'b00000000; // halt
        Memory[51] = 8'b01111011; // dload BH
        Memory[52] = 8'b01000001; // brNeg 2H
        Memory[53] = 8'b10011001; // dstore 9H
        Memory[54] = 8'b00000000; // halt
        Memory[55] = 8'b10011000; // dstore 8H
        Memory[56] = 8'b00100001; // data
		  Memory[57] = 8'b00000000;
		  Memory[58] = 8'b00000000;
		  Memory[59] = 8'b00000000;
		  Memory[60] = 8'b00000000;
		  Memory[61] = 8'b00000000;
		  Memory[62] = 8'b00000000;
		  Memory[63] = 8'b00000000;
        end

    // Memory process
    always @(posedge clk) begin
        if (rw == 0 && en == 1) begin
            $display("Writing value: %0d to memory address: %0d", dBus_reg, aBus);
            Memory[aBus] <= dBus_reg;
        end else if (rw == 1 && en == 1) begin
            if (aBus !== 8'hZZ) begin
                dBus_reg = Memory[aBus];
            end else begin
                dBus_reg = 8'hZZ;
            end
        end
	end
 endmodule
