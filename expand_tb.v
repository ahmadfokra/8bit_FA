`timescale 1ns/1ps

module tb_expand_8bit_addr;

    // Inputs
    reg clk;
    reg reset_n;
    reg [7:0] Value_a;
    reg [7:0] Value_b;
    reg Data_val;
    reg [2:0] Des_address;
    reg [7:0] Des_value;
    reg Des_reg_valid;
    reg Des_wr_rd;

    // Outputs
    wire [7:0] Sum_result;
    wire Sum_carry;
    wire Data_ready;
    wire [7:0] Des_rd_value;

    // Instantiate DUT
    expand dut (
        .clk(clk),
        .reset_n(reset_n),
        .Value_a(Value_a),
        .Value_b(Value_b),
        .Data_val(Data_val),
        .Des_address(Des_address),
        .Des_value(Des_value),
        .Des_reg_valid(Des_reg_valid),
        .Des_wr_rd(Des_wr_rd),
        .Sum_result(Sum_result),
        .Sum_carry(Sum_carry),
        .Data_ready(Data_ready),
        .Des_rd_value(Des_rd_value)
    );

    // Clock 
    initial begin
        clk = 0;
        
    end
// Clock generate
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        reset_n = 0;
        Value_a = 0;
        Value_b = 0;
        Data_val = 0;
        Des_address = 0;
        Des_value = 0;
        Des_reg_valid = 0;
        Des_wr_rd = 0;

        // for negedge triger the design is of when reset_n is high
        #10 reset_n = 1;

        // Write to control register 
        #10 Des_reg_valid = 1; Des_wr_rd = 1; Des_address = 3'b000; Des_value = 8'b00000001;
        #10 Des_reg_valid = 0;

        // Write to offset_value register
        #10 Des_reg_valid = 1; Des_wr_rd = 1; Des_address = 3'b001; Des_value = 8'b00000010; 
        #10 Des_reg_valid = 0;

        // Write  to the general-purpose register
        #10 Des_reg_valid = 1; Des_wr_rd = 1; Des_address = 3'b010; Des_value = 8'b11110000;
        #10 Des_reg_valid = 0;

        // Read the control register
        #10 Des_reg_valid = 1; Des_wr_rd = 0; Des_address = 3'b000; 
        #10 Des_reg_valid = 0;
        // Read the offset_value register
        #10 Des_reg_valid = 1; Des_wr_rd = 0; Des_address = 3'b001; 
        #10 Des_reg_valid = 0;
         // Read the general-purpose register
        #10 Des_reg_valid = 1; Des_wr_rd = 0; Des_address = 3'b010; 
        #10 Des_reg_valid = 0;
        // addition with control_reg[0] = 0
        #10 Value_a = 8'b00001010; Value_b = 8'b00000101; Data_val = 1; 
        #20 Data_val = 0;

        // addition with control_reg[0] = 1
        #10 Des_reg_valid = 1; Des_wr_rd = 1; Des_address = 3'b000; Des_value = 8'b00000001; // Enable offset
        #10 Des_reg_valid = 0;
        #10 Value_a = 8'b00001100; Value_b = 8'b00000110; Data_val = 1; 
        #20 Data_val = 0;

     #50 $finish;
    end

    // Monitor signals 
    initial begin
        $monitor("Time=%0t | A=%b | B=%b | Sum=%b | Carry=%b | Ready=%b | Read_Value=%b",
                 $time, Value_a, Value_b, Sum_result, Sum_carry, Data_ready, Des_rd_value);
    end

endmodule




