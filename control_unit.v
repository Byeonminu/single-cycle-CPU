module ControlUnit (input [31:0] part_of_inst,
                    output alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, is_jal, is_jalr, write_enable, pc_to_reg);


reg [9:0] control;

assign {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, is_jal, is_jalr, write_enable, pc_to_reg} = control;

always @(*) begin
case(part_of_inst[6:0])
7'b0110011 : control <= 10'b0010000010; // R-type
7'b0000011 : control <= 10'b1111000010; // lw-type
7'b0100011 : control <= 10'b1x00100000; // s-type
7'b1100011 : control <= 10'b0x00010000; // sb-type
7'b0010011 : control <= 10'b1010000010; // I-type
7'b1100111 : control <= 10'b111xx00101; // jalr-type
7'b1101111 : control <= 10'b111xx01001; // jal-type
default : control    <= 10'bxxxxxxxxxx;
endcase

end
endmodule