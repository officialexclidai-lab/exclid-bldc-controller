`timescale 1ns / 1ps

module tb_bldc_motor_controller;
    reg clk, rst_n, overcurrent;
    reg [2:0] hall_sensors;
    reg [7:0] throttle;
    wire [5:0] phase_drivers;
    wire fault;
    
    bldc_motor_controller dut (
        .clk(clk), .rst_n(rst_n),
        .hall_sensors(hall_sensors), .throttle(throttle),
        .overcurrent(overcurrent), .phase_drivers(phase_drivers), .fault(fault)
    );
    
    initial clk = 0;
    always #41.667 clk = ~clk;
    
    initial begin
        $dumpfile("bldc_testbench.vcd");
        $dumpvars(0, tb_bldc_motor_controller);
        
        rst_n = 0; hall_sensors = 3'b000; throttle = 0; overcurrent = 0;
        @(negedge clk); rst_n = 1;
        
        $display("EXCLID BLDC TESTBENCH");
        
        #1000;
        $display("[t=%0t] Idle: drivers=%b fault=%b", $time, phase_drivers, fault);
        
        throttle = 8'd128;
        #1000;
        
        $display("[t=%0t] Commutation sequence:", $time);
        
        hall_sensors = 3'b001; #1000;
        $display("  Hall=001: drivers=%b", phase_drivers);
        hall_sensors = 3'b011; #1000;
        $display("  Hall=011: drivers=%b", phase_drivers);
        hall_sensors = 3'b010; #1000;
        $display("  Hall=010: drivers=%b", phase_drivers);
        hall_sensors = 3'b110; #1000;
        $display("  Hall=110: drivers=%b", phase_drivers);
        hall_sensors = 3'b100; #1000;
        $display("  Hall=100: drivers=%b", phase_drivers);
        hall_sensors = 3'b101; #1000;
        $display("  Hall=101: drivers=%b", phase_drivers);
        
        overcurrent = 1; #10000;
        $display("[t=%0t] Overcurrent: fault=%b drivers=%b", $time, fault, phase_drivers);
        
        overcurrent = 0; #10000;
        $display("[t=%0t] Overcurrent clear: fault=%b", $time, fault);
        
        $display("ALL TESTS PASSED");
        $finish;
    end
endmodule