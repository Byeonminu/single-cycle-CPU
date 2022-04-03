`include "opcodes.v"


module ALU (input [31:0] alu_in_1,
			input [31:0] alu_in_2,
			input [3:0] alu_op,
			output reg [31:0] alu_result,
			output alu_bcond);

	assign alu_bcond = (alu_result == 0) ? 1 : 0 ;

always@(*) begin
	$display("ALU");
	case(alu_op)
	4'b0000: alu_result = alu_in_1 & alu_in_2; // AND
	4'b0001: alu_result = alu_in_1 | alu_in_2; // OR
	4'b0010: alu_result = alu_in_1 + alu_in_2; // add
	4'b0110: alu_result = alu_in_1 - alu_in_2; // subtract
	4'b0011: alu_result = alu_in_1 << alu_in_2; // sll
	4'b0111: alu_result = alu_in_1 ^ alu_in_2; // xor
	4'b1000: alu_result = alu_in_1 >> alu_in_2; // srl
	default: alu_result = {32{1'bx}};
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
module ALUControlUnit (input [31:0] part_of_inst,
					   output reg [3:0] alu_op);

wire [2:0] funct3;
wire inst30;
wire [1:0] aluop;

assign funct3 = part_of_inst[14:12];
assign inst30 = part_of_inst[30];

always @(*) begin
case(part_of_inst[6:0])
7'b0110011 : aluop <= 2'b10; // R-type
7'b0000011 : aluop <= 2'b00; // lw-type
7'b0100011 : aluop <= 2'b00; // s-type
7'b1100011 : aluop <= 2'b01; // sb-type
7'b0010011 : aluop <= 2'b11; // I-type
7'b1100111 : aluop <= 2'b00; // jalr-type
7'b1101111 : aluop <= 2'b00; // jal-type
default : aluop    <= 2'bxx;
endcase
end

always @(*) begin
	case(aluop) begin
		2'b00 : Control <= 4'b0010;
		2'b01 : Control <= 4'b0110; 
		2'b10 : case({inst30,funct3})
		4'b0000 : Control <= 4'b0010; // add
		4'b1000 : Control <= 4'b0110; // sub
		4'b0111 : Control <= 4'b0000; // and
		4'b0110 : Control <= 4'b0001; // or
		4'b0001 : Control <= 4'b0011; // sll
		4'b0100 : Control <= 4'b0111; // xor
		4'b0101 : Control <= 4'b1000; // srl
		default : Control <= 4'bxxxx;
		endcase
		2'b11 : case(funct3) // 애매함 
		3'b000 : Control <= 4'b0010; // addi
		3'b100 : Control <= 4'b0111; // xori
		3'b110 : Control <= 4'b0001; // ori
		3'b111 : Control <= 4'b0000; // andi
		3'b001 : Control <= 4'b0011; // slli
		3'b101 : Control <= 4'b1000; // srli
		default : Control <= 4'bxxxx;
	endcase
endcase
end
	
end

endmodule


// always @(*) begin
// 	$display("ALUControlUnit");
// 	alu_op = (part_of_inst[6:0] == `JAL || part_of_inst[6:0] == `JALR || part_of_inst[6:0] == `LW || part_of_inst[6:0] == `SW) ? 3'b000 :  //JAL&JALR -> add
// 	(part_of_inst[30] == 1) ? 3'b010 :  //SUB -> sub
// 	part_of_inst[14:12];


// end 
// endmodule