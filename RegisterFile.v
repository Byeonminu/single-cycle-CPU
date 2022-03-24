module RegisterFile(input	reset,
                    input clk,
                    input [4:0] rs1,          // source register 1
                    input [4:0] rs2,          // source register 2
                    input [4:0] rd,           // destination register
                    input [31:0] rd_din,      // input data for rd
                    input write_enable,        // RegWrite signal
                    output [31:0] rs1_dout,   // output of rs 1
                    output [31:0] rs2_dout,
                    output reg is_halted);  // output of rs 2
  integer i;
  // Register file
  reg [31:0] rf[0:31];

  // TODO
  // Asynchronously read register file
  // Synchronously write data to the register file
  assign rs1_dout = rf[rs1];
  assign rs2_dout = rf[rs2];
  
  // ecall instruction & is_halted
  always @(*) begin
    $display("registerfile");

    if(rs1 == 5'b00000 & rs2 == 5'b00000 & rf[17] == 10) begin
      is_halted = 1;
    end
    else begin
      is_halted = 0;
    end
  end

  // Initialize register file (do not touch)
  always @(posedge clk) begin
    // Reset register file
    if (reset) begin
      for (i = 0; i < 32; i = i + 1)
        rf[i] = 32'b0;
      rf[2] = 32'h2ffc; // stack pointer
    end
    else begin
      if(write_enable == 1) begin 
        rf[rd] <= rd_din;
      end
    end
  end
endmodule
