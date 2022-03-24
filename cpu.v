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
  wire write_enable;        
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
  wire alu_bcond;
  //Data Memory
  wire mem_read;
  wire mem_write;
  //Control Unit
  wire is_jal;
  wire is_jalr;
  wire branch;
  wire alu_src;
  wire mem_to_reg;
  wire pc_to_reg;
  // Data Memory
  // ---------------------------------------------------------------------------
  assign jump_pc = current_pc + 4; //보류
  assign rs1 = instruction[19 : 15];
  assign rs2 = instruction[24 : 20];
  assign rd = instruction[11 : 7]; 
  assign rs2_dout_mux1 = (alu_src == 0) ? rs2_dout : imm_gen_out;

  // pc_to_reg 
  assign rd_din_mux0 = (mem_to_reg == 1) ? rd_din : alu_result;
  assign rd_din_mux1 = jump_pc;
  assign rd_din = (pc_to_reg == 1) ? rd_din_mux1 : rd_din_mux0;

  // branch
  wire pc_src1; 
  wire pc_src2;

  assign pc_src1 = (branch & alu_bcond ) | is_jal;
  assign pr_src2 = is_jalr;
  
  assign next_pc = (pc_src2 == 1) ? alu_result : ( (pc_src1 == 1) ? (imm_gen_out + current_pc) : jump_pc );


  assign is_halted = (reg_file.rf[17] == 10 & instruction[6:0] == 7'b1110011) ? 1 : 0;
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
    .write_enable (write_enable),    // input
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
    .write_enable(write_enable),     // output
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
    .dout (rd_din)        // output
  );
endmodule
