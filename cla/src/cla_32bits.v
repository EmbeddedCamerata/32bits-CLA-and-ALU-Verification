`timescale 1ns/1ns

module cla_32bits #(
    parameter WIDTH = 6'd32
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input ci,
    output wire [WIDTH-1:0] s,
    output wire co
);
    wire [2:0] c;
    wire [1:0] g, p;

    assign co = c[2];

    cla_component #(
        .WIDTH(2)
    ) u_cla_component(
        .g(g),
        .p(p),
        .ci(ci),
        .G(),
        .P(),
        .c(c)
    );
    
    genvar i;
    generate
        for (i = 0; i < 2; i=i+1) begin: Instances
            cla_16bits #(
                .WIDTH(16)
            ) u_cla_16bits(
                .a(a[i*16+:16]),
                .b(b[i*16+:16]),
                .ci(c[i]),
                .s(s[i*16+:16]),
                .co(),
                .gm(g[i]),
                .pm(p[i]),
                .c_mid()
            );
        end
    endgenerate
    
endmodule