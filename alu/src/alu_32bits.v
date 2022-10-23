`timescale 1ns/1ns

module alu_32bits #(
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
    wire [2:0] c;
    wire [1:0] g, p;
    wire [1:0] G, P;

    assign C = c[2];
    assign V = ({opA[n-1], opB[n-1], DO[n-1]} == 3'b001) | ({opA[n-1], opB[n-1], DO[n-1]} == 3'b110);
    assign N = DO[n-1];
    assign Z = ~(|DO);

    cla_component #(
        .WIDTH(2)
    ) u_cla_component(
        .g(g),
        .p(p),
        .ci(Cin),
        .G(G),
        .P(P),
        .c(c)
    );

    genvar i;
    generate
        for (i = 0; i < 2; i=i+1) begin: Instances
            alu_16bits #(
                .WIDTH(16)
            ) u_alu_16bits(
                .a(opA[i*16+:16]),
                .b(opB[i*16+:16]),
                .ci(c[i]),
                .S(S),
                .M(M),
                .s(DO[i*16+:16]),
                .co(),
                .gm(g[i]),
                .pm(p[i])
            );
        end
    endgenerate

endmodule