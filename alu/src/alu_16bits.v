`timescale 1ns/1ns

module alu_16bits #(
    parameter WIDTH = 5'd16
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input ci,
    input [3:0] S,
    input M,
    output wire [WIDTH-1:0] s,
    output wire co,
    output wire gm,
    output wire pm
);
    wire [4:0] c;
    wire [3:0] g, p;
    wire [3:0] G, P;

    assign co = c[4];
    assign gm = G[3];
    assign pm = P[3];

    cla_component #(
        .WIDTH(4)
    ) u_cla_component(
        .g(g),
        .p(p),
        .ci(ci),
        .G(G),
        .P(P),
        .c(c)
    );
    
    genvar i;
    generate
        for (i = 0; i < 4; i=i+1) begin: Instances
            alu_4bits #(
                .WIDTH(4)
            ) u_alu_4bits(
                .a(a[i*4+:4]),
                .b(b[i*4+:4]),
                .ci(c[i]),
                .S(S),
                .M(M),
                .s(s[i*4+:4]),
                .co(),
                .gm(g[i]),
                .pm(p[i])
            );
        end
    endgenerate

endmodule