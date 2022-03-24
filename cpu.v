// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify the module.
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required

module CPU(input reset,       // positive reset signal
           input clk,         // clock signal
           output is_halted); // Whehther to finish simulation
  
  initial begin
    is_halted = 1'b0;
  end

  //PC
  wire [31:0] next_pc;
  wire [31:0] current_pc;
  //Instruction Memory
  wire [31:0] instruction;
  //Register File
  wire [4:0] rs1,          
  wire [4:0] rs2,          
  wire [4:0] rd,         
  wire [31:0] rd_din,     
  wire write_enable,        
  wire [31:0] rs1_dout,  
  wire [31:0] rs2_dout;
  wire [31:0] rs2_dout_temp; 
  //Control Unit

  //Immediate Generator
  wire [31:0] imm_gen_out;
  //ALU Control Unit
  wire [1:0] alu_op;
  //ALU
  wire [31:0] alu_result;
  wire [2:0] alu_bcond;
  //Data Memory
  wire mem_read;
  wire mem_write;
  //Control Unit
  wire alu_src;
  wire mem_to_reg;
  // Data Memory
  // ---------------------------------------------------------------------------
  assign next_pc = current_pc + 4; //보류
  assign rs1 = instruction[19 : 15];
  assign rs2 = instruction[24 : 20];
  assign rd = instruction[11 : 7]; 
  assign rs2_dout_temp = (alu_src == 0) ? rs2_dout : imm_gen_out; 
  assign rd_din = (mem_to_reg == 1) ? rd_din : alu_result;

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
    .rs2_dout (rs2_dout),
    .is_halted (is_halted)      // output
  );


  // // ---------- Control Unit ----------
  // ControlUnit ctrl_unit (
  //   .part_of_inst(),  // input
  //   .is_jal(),        // output
  //   .is_jalr(),       // output
  //   .branch(),        // output
  //   .mem_read(),      // output
  //   .mem_to_reg(),    // output
  //   .mem_write(),     // output
  //   .alu_src(),       // output
  //   .write_enable(),     // output
  //   .pc_to_reg(),     // output
  //   .is_ecall()       // output (ecall inst)
  // );

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
    .alu_in_2(rs2_dout_temp),    // input
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
