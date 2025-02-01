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
