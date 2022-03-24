`include "opcodes.v"


module ALU (alu_op, alu_in_1, alu_in_2 ,alu_result, alu_bcond);
	input [31:0] alu_in_1;
	input [31:0] alu_in_2;
	input [2:0] alu_op;
	output reg [31:0] alu_result;
	output reg [2:0] alu_bcond;

	alu_bcond[0] = (alu_in_1 == alu_in_2);
    alu_bcond[1] = (alu_in_1 > 0);
    alu_bcond[2] = (alu_in_1 < 0);

always@(*) begin
	case(alu_op)
	3'b000: alu_result = alu_in_1 + alu_in_2; // ADD
	3'b010: alu_result = alu_in_1 - alu_in_2; // SUB
	3'b001: alu_result = alu_in_1 << 1; // SLL
	3'b100: alu_result = alu_in_1 ^ alu_in_2; //XOR
	3'b110: alu_result = alu_in_1 | alu_in_2; // OR
	3'b111: alu_result = alu_in_1 & alu_in_2; // AND
	3'b101: alu_result = alu_in_1 >> 1; // SRL

	endcase

/* `define FUNCT3_ADD      3'b000
`define FUNCT3_SUB      3'b000
`define FUNCT3_SLL      3'b001
`define FUNCT3_XOR      3'b100
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111
`define FUNCT3_SRL      3'b101
*/

end
endmodule


//set alu_op by using instruction 
module ALUControlUnit (part_of_inst, alu_op);
input [31:0] part_of_inst;
output reg [2:0] alu_op;

always @(*) begin
	
	part_of_inst[6:0] == `JAL || part_of_inst[6:0] == `JALR || part_of_inst[6:0] == `LW || part_of_inst[6:0] == `SW ? alu_op = 3'b000 : //JAL&JALR -> add
	part_of_inst[30] == 1 ? alu_op = 3'b010 : //SUB -> sub
	alu_op = part_of_inst[14:12];


end

output 
    
endmodule