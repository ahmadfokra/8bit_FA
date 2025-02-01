module bit_addr (
    input wire a,
    input wire b,
    input wire cin,
    output reg Sum,
    output reg cout
);

    always @(*) begin
        Sum = a ^ b ^ cin;        
        cout = (a & b) | (cin & (a ^ b));
    end

endmodule


module dut_8bit_addr (
    input wire clk,
    input wire reset_n,
    input wire [7:0] Value_a,
    input wire [7:0] Value_b,
    input wire Data_val,
    output reg [7:0] Sum_result,
    output reg Sum_carry,
    output reg Data_ready
);

    // Internal signals
    wire [7:0] sum_wire;      // Combinational sum outputs
    wire [7:0] carry_wire;    // Carry signals between stages

    // Instantiate 8 full adders 
    bit_addr fa0 (.a(Value_a[0]), .b(Value_b[0]), .cin(1'b0),         .Sum(sum_wire[0]), .cout(carry_wire[0]));
    bit_addr fa1 (.a(Value_a[1]), .b(Value_b[1]), .cin(carry_wire[0]), .Sum(sum_wire[1]), .cout(carry_wire[1]));
    bit_addr fa2 (.a(Value_a[2]), .b(Value_b[2]), .cin(carry_wire[1]), .Sum(sum_wire[2]), .cout(carry_wire[2]));
    bit_addr fa3 (.a(Value_a[3]), .b(Value_b[3]), .cin(carry_wire[2]), .Sum(sum_wire[3]), .cout(carry_wire[3]));
    bit_addr fa4 (.a(Value_a[4]), .b(Value_b[4]), .cin(carry_wire[3]), .Sum(sum_wire[4]), .cout(carry_wire[4]));
    bit_addr fa5 (.a(Value_a[5]), .b(Value_b[5]), .cin(carry_wire[4]), .Sum(sum_wire[5]), .cout(carry_wire[5]));
    bit_addr fa6 (.a(Value_a[6]), .b(Value_b[6]), .cin(carry_wire[5]), .Sum(sum_wire[6]), .cout(carry_wire[6]));
    bit_addr fa7 (.a(Value_a[7]), .b(Value_b[7]), .cin(carry_wire[6]), .Sum(sum_wire[7]), .cout(carry_wire[7]));

    // Sequential block for storing outputs
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset outputs
            Sum_result <= 8'b0;
            Sum_carry <= 1'b0;
            Data_ready <= 1'b0;
        end else begin
            if (!Data_val) begin
                // If data is not valid, set Data_ready to 0
                Data_ready <= 1'b0;
            end else begin
                Sum_result <= sum_wire;
                Sum_carry <= carry_wire[7];
                Data_ready <= 1'b1;
            end
        end
    end
endmodule
