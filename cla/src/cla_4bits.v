`timescale 1ns/1ns

module cla_4bits #(
    parameter WIDTH = 3'd4
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input ci,
    output wire [WIDTH-1:0] s,
    output wire co,
    output wire gm,
    output wire pm
);
    wire [WIDTH:0] c;
    wire [WIDTH-1:0] g, p;
    wire [WIDTH-1:0] G, P;

    assign g = a & b;
    assign p = a ^ b;
    assign gm = G[WIDTH-1];
    assign pm = P[WIDTH-1];

    cla_component #(
        .WIDTH(WIDTH)
    ) u_cla_component(
        .g(g),
        .p(p),
        .ci(ci),
        .G(G),
        .P(P),
        .c(c)
    );

    assign co = c[WIDTH];
    assign c = {G | (P & c[WIDTH-1:0]), ci};
    assign s = p ^ c[WIDTH-1:0];

endmodule