`timescale 1ns / 1ps

module tb_dut_bit_addr;

    // Testbench signals
    reg clk;
    reg a;
    reg b;
    reg cin;
    wire Sum;
    wire cout;

    // Instantiate the DUT
    bit_addr uut (
       
       .a(a),
      .b(b),
      .cin(cin),
      .Sum(Sum),
      .cout(cout)
    );

    // Clock generation
    always begin
        clk = 0; #5; clk = 1; #5;
    end

    initial begin
        // Initialize signals
       
      $dumpfile("dump.vcd");
      //$dumpvars(1);
    $dumpvars(0, tb_dut_bit_addr);  // Dump all signals in the top-level testbench

        
        a = 1'b0;
        b = 1'b0;
      
	#10;

        a = 1'b0;  
        b = 1'b1;  
       cin=1'b0;

        #50; 
       
        #10;

        a = 1'b1;  
        b = 1'b1;  
       cin=1'b0;

        #50; 
       
        
        #10;
        a = 1'b1;  
        b = 1'b1;  
       cin=1'b1;

        #50;                   

        
        #10;
         a = 1'b1;  
        b = 1'b0;  
       cin=1'b0;
        #50;

 	                    
        
	#10;

        a = 1'b0;  
        b = 1'b1;  
       cin=1'b1;

        #50;                    

        
        #10;
        #20;

        // Finish simulation
        $finish;
    end

    // Monitor signals
    initial begin
      $monitor("Time = %0t | a = %b | b = %b | cin = %b | Sum = %b | cout = %b",  
                  $time, a, b, cin, Sum, cout);
    end

endmodule
