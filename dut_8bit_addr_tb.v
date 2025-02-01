
`timescale 1ns/1ps

module dut_8bit_addr_tb;

    // signals
    reg clk;
    reg reset_n;
    reg [7:0] Value_a;
    reg [7:0] Value_b;
    reg Data_val;
    wire [7:0] Sum_result;
    wire Sum_carry;
    wire Data_ready;

    // Instantiate the DUT 
    dut_8bit_addr uut (
        .clk(clk),
        .reset_n(reset_n),
        .Value_a(Value_a),
        .Value_b(Value_b),
        .Data_val(Data_val),
        .Sum_result(Sum_result),
        .Sum_carry(Sum_carry),
        .Data_ready(Data_ready)
    );

    // Clock generate
    always #5 clk = ~clk;

    // Test
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        Value_a = 8'b0;
        Value_b = 8'b0;
        Data_val = 0;

        // Apply reset
        reset_n = 0; 
        #10;          
        reset_n = 1;  
        #10;

        // Test 1: addition
        Value_a = 8'b00001111; // 15
        Value_b = 8'b00000001; // 1
        Data_val = 1;          // Enable data
        #10;
        $display("Test 1: A = %b, B = %b, Sum = %b, Carry = %b, Data Ready = %b", 
                 Value_a, Value_b, Sum_result, Sum_carry, Data_ready);

        // Test 2: test with carry
        Value_a = 8'b11111111; // 255
        Value_b = 8'b00000001; // 1
        Data_val = 1;          // Enable data
        #10;
        $display("Test 2: A = %b, B = %b, Sum = %b, Carry = %b, Data Ready = %b", 
                 Value_a, Value_b, Sum_result, Sum_carry, Data_ready);

        // Test (Data_val = 0)
        Value_a = 8'b10101010; // 170
        Value_b = 8'b01010101; // 85
        Data_val = 0;          // Disable data
        #10;
        $display("Test 3: A = %b, B = %b, Sum = %b, Carry = %b, Data Ready = %b", 
                 Value_a, Value_b, Sum_result, Sum_carry, Data_ready);

        // Test 4: Zeros
        Value_a = 8'b00000000; // 0
        Value_b = 8'b00000000; // 0
        Data_val = 1;          // Enable data
        #10;
        $display("Test  4: A = %b, B = %b, Sum = %b, Carry = %b, Data Ready = %b", 
                 Value_a, Value_b, Sum_result, Sum_carry, Data_ready);

        // Test  5: Max values
        Value_a = 8'b11111111; // 255
        Value_b = 8'b11111111; // 255
        Data_val = 1;          // Enable data
        #10;
        $display("Test 5: A = %b, B = %b, Sum = %b, Carry = %b, Data Ready = %b", 
                 Value_a, Value_b, Sum_result, Sum_carry, Data_ready);

        // Test  5: Max values
        Value_a = 8'b10101010; // 255
        Value_b = 8'b01010101; // 255
        Data_val = 1;          // Enable data
        #10;
        $display("Test 5: A = %b, B = %b, Sum = %b, Carry = %b, Data Ready = %b", 
                 Value_a, Value_b, Sum_result, Sum_carry, Data_ready);
        // Finish simulation
        $stop;
    end
endmodule