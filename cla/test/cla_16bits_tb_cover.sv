`timescale 1ns/1ns

module cla_16bits_tb_cover;
    parameter WIDTH = 5'd16;

    logic [WIDTH-1:0] a, a_base;
    logic [WIDTH-1:0] b, b_base;
    logic ci, ci_base;
    
    logic [WIDTH-1:0] s;
    logic co;
    logic gm;
    logic pm;
    logic [WIDTH-1:0] c;
    logic [2:0] c_mid;

    // For verification
    logic [WIDTH:0] result;
    integer i;
    integer j;
    integer k;
    logic flag;
    logic [2:0] n;

    assign result = a + b + ci;

    cla_16bits u_cla_16bits(.*);

    initial begin
        $display("Verifying %d bits CLA coverage...", WIDTH);
        flag = 1'b1;
        
        for (n = 1; n <= 3; n++) begin
            a_base = 'b0;
            b_base = 'b0;
            ci_base = 1'b0;
            a = 'b0;
            b = 'b0;
            ci = 1'b0;
            
            for (i = 0; i < 2**(16-n*4); i++) begin
                a = a_base << (n * 4);
                
                for (j = 0; j < 2**(16-n*4); j++) begin
                    b = b_base << (n * 4);
                    
                    for (k = 0; k < 2; k++) begin
                        ci = ci_base << (n * 4);
                        #1
                        
                        assert (co == result[WIDTH] && s == result[WIDTH-1:0]) else begin
                            flag = 1'b0;
                            $error("Error: %d'h%h + %d'h%h + 1'h%h = %d'h%h + 1'h%h, which should be: %d'h%h + 1'h%h", 
                                WIDTH, a, WIDTH, b, ci, 
                                WIDTH, s, co, 
                                WIDTH, result[WIDTH-1:0], result[WIDTH]
                            );
                        end
                        ci_base = !ci_base;
                    end
                    b_base = b_base + 1'b1;
                end
                a_base = a_base + 1'b1;
            end

            $display("#n=%d, PASSED", n);
        end

        if (flag)
            $display("ALL PASSED");
        else
            $display("FAILED");
        
        $finish;
    end

endmodule