//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Mon Jun 22 17:18:13 2026
//Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
//Command     : generate_target gpio_test_wrapper.bd
//Design      : gpio_test_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module gpio_test_wrapper
   (GPIOA,
    GPIOB,
    reset,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  inout [7:0]GPIOA;
  inout [7:0]GPIOB;
  input reset;
  input sys_clock;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire [7:0]GPIOA;
  wire [7:0]GPIOB;
  wire reset;
  wire sys_clock;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  gpio_test gpio_test_i
       (.GPIOA(GPIOA),
        .GPIOB(GPIOB),
        .reset(reset),
        .sys_clock(sys_clock),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
