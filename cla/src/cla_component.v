`timescale 1ns/1ns

module cla_component #(
    parameter WIDTH = 3'd4
)(
    input [WIDTH-1:0] g,
    input [WIDTH-1:0] p,
    input ci,
    output wire [WIDTH-1:0] G,
    output wire [WIDTH-1:0] P,
    output wire [WIDTH:0] c
);
    assign c = {G | (P & c[WIDTH-1:0]), ci};

    genvar i;
    generate
        for (i = 0; i < WIDTH; i=i+1) begin: GP_gen
            if (i == 0) begin
                assign {G[0], P[0]} = {g[0], p[0]};
            end
            else begin
                assign {G[i], P[i]} = {g[i]|(p[i] & G[i-1]), p[i] & P[i-1]};
            end
        end
    endgenerate

endmodule