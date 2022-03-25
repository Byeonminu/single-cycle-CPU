// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify the module.
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required

`include "pc.v"
`include "alu.v"
`include "ImmediateGenerator.v"
`include "RegisterFile.v"
`include "opcodes.v"
`include "Memory.v"
`include "control_unit.v"


module CPU(input reset,       // positive reset signal
           input clk,         // clock signal
           output is_halted); // Whehther to finish simulation
  

  //PC
  wire [31:0] next_pc;
  wire [31:0] current_pc;
  wire [31:0] jump_pc;
  //Instruction Memory
  wire [31:0] instruction;
  //Register File
  wire [4:0] rs1;          
  wire [4:0] rs2;          
  wire [4:0] rd;        
  wire [31:0] rd_din;     
  wire reg_write;        
  wire [31:0] rs1_dout;  
  wire [31:0] rs2_dout;
  wire [31:0] rs2_dout_mux1;
  wire [31:0] rd_din_mux1;
  wire [31:0] rd_din_mux0;
  //Control Unit

  //Immediate Generator
  wire [31:0] imm_gen_out;
  //ALU Control Unit
  wire [3:0] alu_op;
  //ALU
  wire [31:0] alu_result;
  wire [2:0] alu_bcond;
  //Data Memory
  wire mem_read;
  wire mem_write;
  wire [31:0] read_data;
  //Control Unit
  wire is_jal;
  wire is_jalr;
  wire branch;
  wire alu_src;
  wire mem_to_reg;
  wire pc_to_reg;
  // Data Memory
  // ---------------------------------------------------------------------------
  assign jump_pc = current_pc + 4; 
  assign rs1 = instruction[19 : 15];
  assign rs2 = instruction[24 : 20];
  assign rd = instruction[11 : 7]; 
  assign rs2_dout_mux1 = (alu_src == 0) ? rs2_dout : imm_gen_out;

  // pc_to_reg 
  MUX rd_din_low(
                 .a(alu_result),
                 .b(read_data),
                 .condition(mem_to_reg),
                 .out(rd_din_mux0) );
  MUX rd_din_high(
                 .a(rd_din_mux0),
                 .b(rd_din_mux1),
                 .condition(pc_to_reg),
                 .out(rd_din) );
  assign rd_din_mux1 = jump_pc;
  
  // always @(current_pc) begin
  //   $display("current_pc %x --------------------------", current_pc);
  // end
  
  // branch
  wire alu_bcond_temp;
  wire pc_src1; 
  // wire pc_src2;
  //assign pc_src1 = (branch & (alu_bcond[0] == 1 | alu_bcond[0] == 0 | alu_bcond[1] == 1 | (alu_bcond[0] == 1 | alu_bcond[2] == 1))) | is_jal;
  assign alu_bcond_temp = (instruction[14:12] == 3'b000 & alu_bcond[0] == 1) ? 1: 
  (instruction[14:12] == 3'b001 & alu_bcond[0] == 0) ? 1 :
  (instruction[14:12] == 3'b100 & alu_bcond[1] == 1) ? 1 : 
  (instruction[14:12] == 3'b101 & (alu_bcond[0] == 1 | alu_bcond[2] == 1 )) ? 1 : 1'b0;
 
  assign pc_src1 = (branch & alu_bcond_temp) | is_jal;
  

  assign next_pc = (is_jalr == 1) ? alu_result : ( (pc_src1 == 1) ? (imm_gen_out + current_pc) : jump_pc );
  
  // always @(pc_src1 or imm_gen_out) begin
  //   $display("pc_src1 %b imm_gen_out %x", pc_src1, imm_gen_out);
    
  // end
  
  // always @(alu_bcond) begin
  //   $display("alu_bcond %b %b %b", alu_bcond[0], alu_bcond[1], alu_bcond[2]);
  //   $display("alu_bcond_temp %b", alu_bcond_temp);
  // end

  // always @(mem_to_reg or read_data) begin
  //   $display("mem_to_reg %b read_data %x", mem_to_reg, read_data);

  // end

  assign is_halted = (reg_file.rf[17] == 10 & instruction[6:0] == 7'b1110011) ? 1 : 0;
 
  // always @(reg_file.rf[0]) begin
  //   $display("reg_file.rf[17] is %x", reg_file.rf[17]);
  // end
  

  
  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  PC pc(
    .reset(reset),       // input (Use reset to initialize PC. Initial value must be 0)
    .clk(clk),         // input
    .next_pc(next_pc),     // input
    .current_pc(current_pc)   // output
  );
  
  // ---------- Instruction Memory ----------
  InstMemory imem(
    .reset(reset),   // input
    .clk(clk),     // input
    .addr(current_pc),    // input
    .dout(instruction)     // output
  );

  // ---------- Register File ----------
  RegisterFile reg_file (
    .reset (reset),        // input
    .clk (clk),          // input
    .rs1 (rs1),          // input
    .rs2 (rs2),          // input
    .rd (rd),           // input
    .rd_din (rd_din),       // input
    .reg_write (reg_write),    // input
    .rs1_dout (rs1_dout),     // output
    .rs2_dout (rs2_dout)    // output
  );


  // ---------- Control Unit ----------
  ControlUnit ctrl_unit (
    .part_of_inst(instruction),  // input
    .is_jal(is_jal),        // output
    .is_jalr(is_jalr),       // output
    .branch(branch),        // output
    .mem_read(mem_read),      // output
    .mem_to_reg(mem_to_reg),    // output
    .mem_write(mem_write),     // output
    .alu_src(alu_src),       // output
    .reg_write(reg_write),     // output
    .pc_to_reg(pc_to_reg)     // output
  );

  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen(
    .part_of_inst(instruction),  // input
    .imm_gen_out(imm_gen_out)    // output
  );

  // ---------- ALU Control Unit ----------
  ALUControlUnit alu_ctrl_unit (
    .part_of_inst(instruction),  // input
    .alu_op(alu_op)         // output
  );

  // ---------- ALU ----------
  ALU alu (
    .alu_op(alu_op),      // input
    .alu_in_1(rs1_dout),    // input  
    .alu_in_2(rs2_dout_mux1),    // input
    .alu_result(alu_result),  // output
    .alu_bcond(alu_bcond)     // output
  );

  // ---------- Data Memory ----------
  DataMemory dmem(
    .reset (reset),      // input
    .clk (clk),        // input
    .addr (alu_result),       // input
    .din (rs2_dout),        // input
    .mem_read (mem_read),   // input
    .mem_write (mem_write),  // input
    .dout (read_data)        // output
  );
endmodule






        // assign next_pc = 32'b0;
        
        // assign jump_pc = 32'b0;
        // //Instruction Memory
        // assign instruction =32'b0;
        // //Register File
        // assign rs1 = 5'b0;        
        // assign rs2 = 5'b0;   
        // assign rd = 5'b0;      
        // assign rd_din = 32'b0;     
        // assign reg_write = 1'b0;        
        // assign   rs1_dout = 32'b0;  
        //  assign  rs2_dout = 32'b0;  
        //  assign  rs2_dout_mux1 = 32'b0;  
        //  assign  rd_din_mux1 = 32'b0;  
        //  assign  rd_din_mux0 = 32'b0;  
        // //Control Unit

        // //Immediate Generator
        //  assign imm_gen_out = 32'b0;
        // //ALU Control Unit
        //  assign alu_op =4'b0;
        // //ALU
        // assign alu_result =32'b0;
        // assign  alu_bcond = 1'b0;
        // //Data Memory
        // assign mem_read = 1'b0;
        // assign  mem_write = 1'b0;
        // //Control Unit
        //  assign is_jal = 1'b0;
        //  assign  is_jalr= 1'b0;
        //  assign branch = 1'b0;
        //  assign alu_src = 1'b0;
        //  assign mem_to_reg = 1'b0;
        //  assign pc_to_reg = 1'b0;