`timescale 1ns/1ns

module alu_32bits_tb;
    parameter WIDTH = 6'd32;

    logic [WIDTH-1:0] opA;
    logic [WIDTH-1:0] opB;
    logic [3:0] S;
    logic M;
    logic Cin;
    logic [WIDTH-1:0] DO, DO_ref;
    logic C, C_ref;
    logic V, V_ref;
    logic N, N_ref;
    logic Z, Z_ref;

    // For verification
    integer i;
    integer j;
    integer k;
    integer n;
    logic flag;
    logic [5:0] cmd_list[18];

    alu_32bits #(
        .n(WIDTH)
    ) u_alu_32bits(
        .opA(opA),
        .opB(opB),
        .S(S),
        .M(M),
        .Cin(Cin),
        .DO(DO),
        .C(C),
        .V(V),
        .N(N),
        .Z(Z)
    );

    alu_ref #(
        .n(WIDTH)
    ) u_alu_ref(
        .opA(opA),
        .opB(opB),
        .S(S),
        .M(M),
        .Cin(Cin),
        .DO(DO_ref),
        .C(C_ref),
        .V(V_ref),
        .N(N_ref),
        .Z(Z_ref)
    );

    initial begin
        cmd_list[0] = 6'b000010;
        cmd_list[1] = 6'b000110;
        cmd_list[2] = 6'b001010;
        cmd_list[3] = 6'b001110;
        cmd_list[4] = 6'b010010;
        cmd_list[5] = 6'b010110;
        cmd_list[6] = 6'b011010;
        cmd_list[7] = 6'b011110;
        cmd_list[8] = 6'b100010;
        cmd_list[9] = 6'b100110;
        cmd_list[10] = 6'b101010;
        cmd_list[11] = 6'b101110;
        cmd_list[12] = 6'b110010;
        cmd_list[13] = 6'b110110;
        cmd_list[14] = 6'b111010;
        cmd_list[15] = 6'b111110;
        cmd_list[16] = 6'b100101;
        cmd_list[17] = 6'b011011;
    end

    initial begin
        $display("Verifying %d bits ALU...", WIDTH);
        opA = 'b0;
        opB = 'b0;
        Cin = 1'b0;
        flag = 1'b1;
        
        // Spend too much time if you set 2**WIDTH
        for (i = 0; i < 2**10; i++) begin
            for (j = 0; j < 2**10; j++) begin
                foreach (cmd_list[n]) begin
                    {S, Cin, M} = cmd_list[n];
                    #1
                    assert ((DO == DO_ref) && (C == C_ref) && (V == V_ref) && (N == N_ref) && (Z == Z_ref)) else begin
                        flag = 1'b0;
                        $error("Error #%d: CMD: 6'b%b, opA=%d'h%h, opB=%d'h%h, DO=%d'h%h[%d'h%h], C=1'b%b[1'b%b], V=1'b%b[1'b%b], N=1'b%b[1'b%b], Z=1'b%b[1'b%b]", 
                            n+1, cmd_list[n], 
                            WIDTH, opA, WIDTH, opB,
                            WIDTH, DO, WIDTH, DO_ref, C, C_ref, V, V_ref, N, N_ref, Z, Z_ref
                        );
                    end
                end
                opB = opB + 1'b1;
            end
            opA = opA + 1'b1;
        end
        
        if (flag)
            $display("PASSED");
        else
            $display("FAILED");
        
        $finish;
    end

endmodule