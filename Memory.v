module InstMemory #(parameter MEM_DEPTH = 1024) (input reset,
                                                 input clk,
                                                 input [31:0] addr,   // address of the instruction memory
                                                 output [31:0] dout); // instruction at addr
  integer i;
  // Instruction memory
  reg [31:0] mem[0:MEM_DEPTH - 1];
  // Do not touch imem_addr
  wire [31:0] imem_addr;
  assign imem_addr = {2'b00, addr >> 2};

  // TODO
  // Asynchronously read instruction from the memory 
  // (use imem_addr to access memory)
  assign dout = mem[imem_addr];
  
  // Initialize instruction memory (do not touch except path)
  always @(posedge clk) begin
    if (reset) begin
      for (i = 0; i < MEM_DEPTH; i = i + 1)
          mem[i] = 32'b0;
      // Provide path of the file including instructions with binary format
       $readmemh("student_tb/loop_mem.txt", mem);
    end
  end

endmodule

module DataMemory #(parameter MEM_DEPTH = 16384) (input reset,
                                                  input clk,
                                                  input [31:0] addr,    // address of the data memory
                                                  input [31:0] din,     // data to be written
                                                  input mem_read,       // is read signal driven?
                                                  input mem_write,      // is write signal driven?
                                                  output reg [31:0] dout);  // output of the data memory at addr
  integer i;
  // Data memory
  reg [31:0] mem[0: MEM_DEPTH - 1];
  // Do not touch dmem_addr
  wire [31:0] dmem_addr;
  assign dmem_addr = {2'b00, addr >> 2};

  // TODO
  // Asynchrnously read data from the memory
  // Synchronously write data to the memory
  // (use dmem_addr to access memory)
  always @(*) begin
    if(mem_read == 1'b1) begin
      dout <= mem[dmem_addr];
     //$display("memory read %x <= %x",dout , mem[dmem_addr]);
    end
  end
  
  // Initialize data memory (do not touch)
  always @(posedge clk) begin
    if (reset) begin
      for (i = 0; i < MEM_DEPTH; i = i + 1)
        mem[i] = 32'b0;
    end
    else begin 
      if(mem_write == 1'b1) begin
        //$display("memory write %x(address) = %x",addr , din);
        mem[dmem_addr] = din;
         
      end
    end
  end

  // always @(addr) begin
  //   $display("DataMemory addr %x", addr);
  // end
endmodule





 // mem[0] = 32'hfe010113; 
        // mem[1] = 32'h00112e23; 
        // mem[2] = 32'h00812c23;
        // mem[3] = 32'h02010413;
        // mem[4] = 32'h01300793;
        // mem[5] = 32'hfef42623;
        // mem[6] = 32'h00e00793;
        // mem[7] = 32'hfef42423;
        // mem[8] = 32'hfe842583;
        // mem[9] = 32'hfec42503;
        // mem[10] = 32'hfea42223;
        // mem[11] = 32'hfe442703;
        // mem[12] = 32'hfec42783;
        // mem[13] = 32'h00f707b3;
        // mem[14] = 32'h00a06813;
        // mem[15] = 32'h00200893;
        // mem[16] = 32'h011818b3;
        // mem[17] = 32'h00300593;
        // mem[18] = 32'h00b8f6b3;
        // mem[19] = 32'hfff8c613;
        // mem[20] = 32'h41088833;
        // mem[21] = 32'h0038d893;
        // mem[22] = 32'h00f766b3;
        // mem[23] = 32'h01c12083;
        // mem[24] = 32'h01812403;
        // mem[25] = 32'h02010113;
        // mem[26] = 32'h00a00893;
        // mem[27] = 32'h00000073;