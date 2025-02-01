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


module expand_8bit_addr (
    input wire clk,
    input wire reset_n,
    input wire [7:0] Value_a,
    input wire [7:0] Value_b,
    input wire Data_val,
    input wire [2:0] Des_address,
    input wire [7:0] Des_value,
    input wire Des_reg_valid,
    input wire  Des_wr_rd,
    output reg [7:0] Sum_result,
    output reg Sum_carry,
    output reg Data_ready,
    output reg [7:0] Des_rd_value
);

    // Internal signals
    wire [7:0] sum_wire;      // Combinational sum outputs
    wire [7:0] carry_wire;    // Carry signals between stages
    wire [7:0] sum_wire1;      // Combinational sum outputs
    wire [7:0] carry_wire1;    // Carry signals between stages
   //registers
    reg [7:0] control_reg;    // Address 0x0: control register
    reg [7:0] offset_value;   // Address 0x1: offset_value register
    reg [7:0] general_purpose; // Address 0x2: general_purpose register
    // Instantiate 8 full adders 
    bit_addr fa0 (.a(Value_a[0]), .b(Value_b[0]), .cin(1'b0),         .Sum(sum_wire[0]), .cout(carry_wire[0]));
    bit_addr fa1 (.a(Value_a[1]), .b(Value_b[1]), .cin(carry_wire[0]), .Sum(sum_wire[1]), .cout(carry_wire[1]));
    bit_addr fa2 (.a(Value_a[2]), .b(Value_b[2]), .cin(carry_wire[1]), .Sum(sum_wire[2]), .cout(carry_wire[2]));
    bit_addr fa3 (.a(Value_a[3]), .b(Value_b[3]), .cin(carry_wire[2]), .Sum(sum_wire[3]), .cout(carry_wire[3]));
    bit_addr fa4 (.a(Value_a[4]), .b(Value_b[4]), .cin(carry_wire[3]), .Sum(sum_wire[4]), .cout(carry_wire[4]));
    bit_addr fa5 (.a(Value_a[5]), .b(Value_b[5]), .cin(carry_wire[4]), .Sum(sum_wire[5]), .cout(carry_wire[5]));
    bit_addr fa6 (.a(Value_a[6]), .b(Value_b[6]), .cin(carry_wire[5]), .Sum(sum_wire[6]), .cout(carry_wire[6]));
    bit_addr fa7 (.a(Value_a[7]), .b(Value_b[7]), .cin(carry_wire[6]), .Sum(sum_wire[7]), .cout(carry_wire[7]));

    bit_addr fa8 (.a(sum_wire[0]), .b(offset_value[0]), .cin(carry_wire[7]),         .Sum(sum_wire1[0]), .cout(carry_wire1[0]));
    bit_addr fa9 (.a(sum_wire[1]), .b(offset_value[1]), .cin(carry_wire1[0]), .Sum(sum_wire1[1]), .cout(carry_wire1[1]));
    bit_addr fa10 (.a(sum_wire[2]), .b(offset_value[2]), .cin(carry_wire1[1]), .Sum(sum_wire1[2]), .cout(carry_wire1[2]));
    bit_addr fa11 (.a(sum_wire[3]), .b(offset_value[3]), .cin(carry_wire1[2]), .Sum(sum_wire1[3]), .cout(carry_wire1[3]));
    bit_addr fa12 (.a(sum_wire[4]), .b(offset_value[4]), .cin(carry_wire1[3]), .Sum(sum_wire1[4]), .cout(carry_wire1[4]));
    bit_addr fa13 (.a(sum_wire[5]), .b(offset_value[5]), .cin(carry_wire1[4]), .Sum(sum_wire1[5]), .cout(carry_wire1[5]));
    bit_addr fa14 (.a(sum_wire[6]), .b(offset_value[6]), .cin(carry_wire1[5]), .Sum(sum_wire1[6]), .cout(carry_wire1[6]));
    bit_addr fa15 (.a(sum_wire[7]), .b(offset_value[7]), .cin(carry_wire1[6]), .Sum(sum_wire1[7]), .cout(carry_wire1[7]));


    // Sequential block for storing outputs
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset outputs
            Sum_result <= 8'b0;
            Sum_carry <= 1'b0;
            Data_ready <= 1'b0;
        end else begin
            
 		if(Des_reg_valid) begin //transaction
			if(Des_wr_rd) begin //Write
 			case (Des_address)
                	    3'b000: //control reg (Address 0x0)
                 		 control_reg <= Des_value;
                   	    3'b001:  // offser reg (Address 0x1)
                                 offset_value <= Des_value;
                            3'b010:  //  general_purpose reg (Address 0x2)
                                 general_purpose <= Des_value;
                        default: ;
                
                 endcase
                   
		         end else begin //Read
                         case (Des_address)
                	    3'b000: //control reg (Address 0x0)
                 		Des_rd_value <= control_reg;
                   	    3'b001:  // offser reg (Address 0x1)
                                 Des_rd_value <=offset_value ;
                            3'b010:  //  general_purpose reg (Address 0x2)
                                 Des_rd_value <=general_purpose ;
                        default: ;
                
                 endcase
                   
		end 
		end else begin //No transaction
                     if(!Data_val)begin//No calculation needed we can set summ and carry out to zero
			 Sum_result <= 8'b0;
                         Sum_carry <= 1'b0;
                         Data_ready <= 1'b0;
 			end else begin //For Data_val = 1 we go to calculations
				if(!control_reg[0])begin // Sum of A and B 
                                     Sum_result <= sum_wire;
                                     Sum_carry <= carry_wire[7];
                                     Data_ready <= 1'b1;
                               end else begin//when control_reg[0] =1 calculate A+B+Offset

                                     Sum_result <= sum_wire1;
                                     Sum_carry <= carry_wire1[7];
                                     Data_ready <= 1'b1;
                                     end
                          end
                        end//of Data val
                      end//reset_n end
end//alwayd end
                      

endmodule
