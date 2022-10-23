`timescale 1ns/1ns

module alu_ref #(
    parameter n = 32
)(
    input wire [n-1:0]  opA,
    input wire [n-1:0]  opB,
    input wire [3:0]    S,      // work mode select
    input wire          M,      // logic operation select
    input wire          Cin,    // carry-in
    output reg [n-1:0]  DO,     // data output
    output reg          C,      // carry-out
    output reg          V,      // overflow
    output reg          N,      // DO符号位输出信号
    output reg          Z       // DO为全0指示信号
);
    wire [n:0] result_add;
    wire result_sub;
    assign result_add = opA + opB + Cin;
    assign result_sub = (opA >= opB);

    assign V = ({opA[n-1], opB[n-1], DO[n-1]} == 3'b001) | ({opA[n-1], opB[n-1], DO[n-1]} == 3'b110);
    assign N = DO[n-1];
    assign Z = ~(|DO);

    wire [5:0] op;
    
    assign op = {S, Cin, M};

    always @(*) begin
        case (op)
            6'b000010: DO <= 'b0;
            6'b000110: DO <= (~opA) & (~opB); 
            6'b001010: DO <= (~opA) & (opB);
            6'b001110: DO <= ~opA;
            6'b010010: DO <= (opA) & (~opB);

            6'b010110: DO <= ~opB;
            6'b011010: DO <= (opA & ~opB) | (~opA & opB);
            6'b011110: DO <= (~opA) | (~opB);
            6'b100010: DO <= opA & opB;
            6'b100110: DO <= (opA & opB) | (~opA & ~opB);

            6'b101010: DO <= opB;
            6'b101110: DO <= (opA & opB) | (~opA & opB) | (~opA & ~opB);
            6'b110010: DO <= opA;
            6'b110110: DO <= (opA & opB) | (opA & ~opB) | (~opA & ~opB);
            6'b111010: DO <= (opA & opB) | (opA & ~opB) | (~opA & opB);

            6'b111110: DO <= {n{1'b1}};
            6'b100101: DO <= opA + opB + Cin;
            6'b011011: DO <= opA + (~opB) + Cin;
            default: DO <= 'b1;
        endcase
    end

    always @(*) begin
        C <= (M) ? ((Cin) ? (result_sub) : result_add[n]) : 1'b1;
    end

endmodule