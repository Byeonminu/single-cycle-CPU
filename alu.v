`include "opcodes.v"


module ALU (alu_op, alu_in_1, alu_in_2 ,alu_result, alu_bcond);
	input [31:0] alu_in_1;
	input [31:0] alu_in_2;
	input [1:0] alu_op;
	output reg [31:0] alu_result;
	output alu_bcond;



end
endmodule


//set alu_op by using instruction 
module ALUControlUnit (part_of_inst, alu_op);
input [31:0] part_of_inst;
output reg [1:0] alu_op;

wire [6:0] opcode = part_of_inst[6:0];

//이 부분 정확 ㄴㄴ
always @(*) begin
case(opcode)
7'b0110011 : alu_op <= 2'b10; // R-type
7'b0000011 : alu_op <= 2'b00; // lw-type
7'b0100011 : alu_op <= 2'b00; // s-type
7'b1100011 : alu_op <= 2'b01; // sb-type
7'b0010011 : alu_op <= 2'b11; // I-type
7'b1100111 : alu_op <= 2'b00; // jalr-type
7'b1101111 : alu_op <= 2'b00; // jal-type
default : alu_op    <= 2'bxx;
endcase
end


output 
    
endmodule