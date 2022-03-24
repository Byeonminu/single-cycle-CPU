`include "opcodes.v"

module PC(reset, clk, next_pc, current_pc);
input clk;
input reset;
input [31: 0] next_pc;
output reg [31: 0] current_pc;

    initial begin
      current_pc <= 32'h0000;
    end

    always@(negedge clk) begin
        if(!reset)
            current_pc <= 32'h0000;
        else begin
            $display("pc");
            current_pc <= next_pc;
        end
    end
endmodule