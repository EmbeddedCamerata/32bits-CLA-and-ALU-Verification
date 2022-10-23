`timescale 1ns/1ns

module cla_4bits_tb;
    parameter WIDTH = 3'd4;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic ci;
    
    logic [WIDTH-1:0] s;
    logic co;
    logic gm;
    logic pm;

    // For verification
    logic [WIDTH:0] result;
    integer i;
    integer j;
    integer k;
    logic flag;

    assign result = a + b + ci;

    cla_4bits u_cla_4bits(.*);

    initial begin
        $display("Verifying %d bits CLA...", WIDTH);
        a = 'b0;
        b = 'b0;
        ci = 1'b0;
        flag = 1'b1;

        for (i = 0; i < 2**WIDTH; i++) begin
            for (j = 0; j < 2**WIDTH; j++) begin
                for (k = 0; k < 2; k++) begin 
                    #1
                    assert (co == result[WIDTH] && s == result[WIDTH-1:0]) else begin
                        flag = 1'b0;
                        $error("Error: %d'h%h + %d'h%h + 1'h%h = %d'h%h + 1'h%h, which should be: %d'h%h + 1'h%h", 
                            WIDTH, a, WIDTH, b, ci, 
                            WIDTH, s, co, 
                            WIDTH, result[WIDTH-1:0], result[WIDTH]
                        );
                    end
                    ci = ~ci;
                end
                b = b + 1'b1;
            end
            a = a + 1'b1;
        end
        
        if (flag)
            $display("PASSED");
        else
            $display("FAILED");
        
        $finish;
    end

endmodule