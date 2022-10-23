`timescale 1ns/1ns

module alu_4bits #(
    parameter WIDTH = 3'd4
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input ci,
    input [WIDTH-1:0] S,
    input M,
    output wire [WIDTH-1:0] s,
    output wire co,
    output wire gm,
    output wire pm
);
    wire [WIDTH:0] c;
    wire [WIDTH-1:0] g, p;
    wire [WIDTH-1:0] G, P;

    assign gm = G[WIDTH-1];
    assign pm = P[WIDTH-1];

    genvar i;
    generate 
        for (i = 0; i < WIDTH; i=i+1) begin
            assign g[i] = ((S[3] & a[i] & b[i]) | (S[2] & a[i] & (!b[i]))) | (!M);
            assign p[i] = ~((S[3] & a[i] & b[i]) | (S[2] & a[i] & (~b[i])) | (S[1] & (~a[i]) & b[i]) | (S[0] & (~a[i]) & (~b[i])));
        end
    endgenerate
    
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
    assign s = p ^ c[WIDTH-1:0];

endmodule