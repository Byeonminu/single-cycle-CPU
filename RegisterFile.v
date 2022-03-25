module RegisterFile(input	reset,
                    input clk,
                    input [4:0] rs1,          // source register 1
                    input [4:0] rs2,          // source register 2
                    input [4:0] rd,           // destination register
                    input [31:0] rd_din,      // input data for rd
                    input reg_write,        // RegWrite signal
                    output [31:0] rs1_dout,   // output of rs 1
                    output [31:0] rs2_dout);
  // Register file
  integer i ;
  reg [31:0] rf[0:31];

  // TODO
  // Asynchronously read register file
  // Synchronously write data to the register file
  assign rs1_dout = rf[rs1];
  assign rs2_dout = rf[rs2];
  
 

  // Initialize register file (do not touch)
  always @(posedge clk) begin
    // Reset register file
    if (reset) begin
      for (i = 0; i < 32; i = i + 1)
        rf[i] = 32'b0;
      rf[2] = 32'h2ffc; // stack pointer
    end
    else begin
      if(reg_write == 1) begin 
        if(rd != 0) 
        rf[rd] <= rd_din;
        $display("register %x<= %x, rd = %d", rf[rd], rd_din, rd);
      end
    end
  end

  // always @(rs1 or rs2 or rd_din or reg_write) begin
  //   $display("RegisterFile rs1 %x rs2 %x rd_din %x reg_write %b", rs1, rs2, rd_din, reg_write);
  // end
endmodule
