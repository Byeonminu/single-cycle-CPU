module ControlUnit (input [31:0] part_of_inst,
                    output  alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, is_jal, is_jalr, pc_to_reg);


reg [8:0] control;

assign {alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, is_jal, is_jalr, pc_to_reg} = control;

always @(*) begin
case(part_of_inst[6:0])
7'b0110011 : control <= 9'b001000000; // R-type
7'b0000011 : control <= 9'b111100000; // lw-type
7'b0100011 : control <= 9'b1x0010000; // s-type
7'b1100011 : control <= 9'b0x0001000; // sb-type
7'b0010011 : control <= 9'b101000000; // I-type
7'b1100111 : control <= 9'b111xx0011; // jalr-type
7'b1101111 : control <= 9'b111xx0101; // jal-type
7'b1110011 : control <= 9'bxxxxx000x; // ecall
default : control    <= 9'bxxxxxxxxx;
endcase

end

// always @(part_of_inst) begin
//  $display("ControlUnit %x", part_of_inst);

// end
 

endmodule



module MUX (input [31 : 0] a, b,
            input  condition,
            output reg [31 : 0] out);

always @(condition or a or b) begin

  out = (condition == 1'b0) ? a : b;
end 
endmodule
