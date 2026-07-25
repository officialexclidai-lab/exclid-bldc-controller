// ============================================================================
// Exclid Semiconductor Technologies - BLDC Motor Controller Core
// ============================================================================
// Target: Open-source ASIC (SkyWater 130nm) / FPGA prototype
// Author: Technical Co-founder
// Date: 2026-07-19
//
// Features:
// - PWM generation (8-bit adjustable duty cycle)
// - 6-step hall-sensor commutation
// - Over-current protection
// - Soft-start throttle response
// ============================================================================

module bldc_motor_controller (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [2:0]  hall_sensors,
    input  wire [7:0]  throttle,
    input  wire        overcurrent,
    output reg  [5:0]  phase_drivers,
    output reg         fault
);

    parameter PWM_PERIOD = 255;
    
    reg [7:0] pwm_counter;
    reg [7:0] duty_cycle;
    reg pwm_out;
    reg [2:0] hall_sync;
    reg [2:0] hall_d1, hall_d2;
    reg [2:0] commutation_state;
    reg [23:0] fault_counter;
    reg [15:0] duty_accumulator;
    
    // Hall sensor debounce
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hall_d1 <= 3'b000;
            hall_d2 <= 3'b000;
            hall_sync <= 3'b000;
        end else begin
            hall_d1 <= hall_sensors;
            hall_d2 <= hall_d1;
            if (hall_d1 == hall_d2)
                hall_sync <= hall_d2;
        end
    end
    
    // Commutation state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            commutation_state <= 3'b000;
        end else begin
            case (hall_sync)
                3'b001: commutation_state <= 3'd1;
                3'b011: commutation_state <= 3'd2;
                3'b010: commutation_state <= 3'd3;
                3'b110: commutation_state <= 3'd4;
                3'b100: commutation_state <= 3'd5;
                3'b101: commutation_state <= 3'd6;
                default: commutation_state <= commutation_state;
            endcase
        end
    end
    
    // PWM generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_counter <= 8'd0;
            pwm_out <= 1'b0;
        end else begin
            if (pwm_counter >= PWM_PERIOD)
                pwm_counter <= 8'd0;
            else
                pwm_counter <= pwm_counter + 1'b1;
            pwm_out <= (pwm_counter < duty_cycle);
        end
    end
    
    // Soft-start duty cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            duty_cycle <= 8'd0;
            duty_accumulator <= 16'd0;
        end else begin
            if (duty_accumulator >> 8 < throttle)
                duty_accumulator <= duty_accumulator + 1;
            else if (duty_accumulator >> 8 > throttle)
                duty_accumulator <= duty_accumulator - 1;
            duty_cycle <= duty_accumulator >> 8;
        end
    end
    
    // Overcurrent protection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fault_counter <= 24'd0;
            fault <= 1'b0;
        end else begin
            if (overcurrent) begin
                if (fault_counter < 16_000_000)
                    fault_counter <= fault_counter + 1'b1;
            end else begin
                if (fault_counter > 24'd0)
                    fault_counter <= fault_counter - 1'b1;
            end
            fault <= (fault_counter >= 24'd8_000_000);
        end
    end
    
    // Phase drivers (6-step commutation)
    always @(*) begin
        if (fault) begin
            phase_drivers = 6'b000000;
        end else begin
            case (commutation_state)
                3'd1: phase_drivers = {pwm_out, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
                3'd2: phase_drivers = {pwm_out, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
                3'd3: phase_drivers = {1'b0, 1'b0, 1'b0, 1'b1, pwm_out, 1'b0};
                3'd4: phase_drivers = {1'b0, 1'b1, 1'b0, 1'b0, pwm_out, 1'b0};
                3'd5: phase_drivers = {1'b0, 1'b1, pwm_out, 1'b0, 1'b0, 1'b0};
                3'd6: phase_drivers = {1'b0, 1'b0, pwm_out, 1'b0, 1'b0, 1'b1};
                default: phase_drivers = 6'b000000;
            endcase
        end
    end

endmodule