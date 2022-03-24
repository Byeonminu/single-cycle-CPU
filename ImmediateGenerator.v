`include "opcodes.v"

module ImmediateGenerator (input [31:0] part_of_inst, 
                           output reg [31:0] imm_gen_out);



always @(*) begin
    $display("ImmediateGenerator");
case(part_of_inst[6:0])
`JAL: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31],part_of_inst[19:12],part_of_inst[20],part_of_inst[30:21]};
`JALR: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:20]};
`BEQ: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31],part_of_inst[7],part_of_inst[30:25],part_of_inst[11:8]};
`BNE: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31],part_of_inst[7],part_of_inst[30:25],part_of_inst[11:8]};
`BLT: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31],part_of_inst[7],part_of_inst[30:25],part_of_inst[11:8]};
`BGE: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31],part_of_inst[7],part_of_inst[30:25],part_of_inst[11:8]};
`LW: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:20]};
`SW: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:25],part_of_inst[11:7]};
`ADDI: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:20]};
`XORI: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:20]};
`ORI: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:20]};
`ANDI: imm_gen_out <= {{20{part_of_inst[31]}},part_of_inst[31:20]};
default : imm_gen_out <= {32{1'hx}}; // ADD, SUB, SLL, XOR, SRL, OR, AND


endcase
end
endmodule