// Code your design here
`timescale 1ns/1ps

module tb_mac;

reg clk;
reg rst_n;
reg valid_in;
reg [15:0] A;
reg [15:0] B;
reg clear_acc;

wire [31:0] acc_single;
wire [31:0] acc_pipe;

wire valid_single;
wire valid_pipe;

/* Single Cycle MAC */

mac_single_cycle U1 (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .A(A),
    .B(B),
    .clear_acc(clear_acc),
    .acc_out(acc_single),
    .valid_out(valid_single)
);

/* Pipelined MAC */

mac_pipelined U2 (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .A(A),
    .B(B),
    .clear_acc(clear_acc),
    .acc_out(acc_pipe),
    .valid_out(valid_pipe)
);

/* Clock */

always #5 clk = ~clk;

initial begin

    $dumpfile("wave.vcd");
    $dumpvars(0, tb_mac);

    clk = 0;
    rst_n = 0;
    valid_in = 0;
    clear_acc = 0;
    A = 0;
    B = 0;

    #20;
    rst_n = 1;

    // 3 x 4 = 12
    #10;
    valid_in = 1;
    A = 3;
    B = 4;

    // 5 x 2 = 10
    #10;
    A = 5;
    B = 2;

    // stop input
    #10;
    valid_in = 0;

    #30;

    $display("--------------------------------");
    $display("Single Cycle Output = %0d", acc_single);
    $display("Pipelined Output    = %0d", acc_pipe);
    $display("--------------------------------");

    $finish;

end

endmodule
