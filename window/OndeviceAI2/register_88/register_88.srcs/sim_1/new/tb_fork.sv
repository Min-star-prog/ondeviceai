`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/11 09:29:02
// Design Name: 
// Module Name: tb_fork
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_fork();



initial begin
    #1 $display("%t : start fork - join", $time);

    fork
        #10 A_thread();
        #20 B_thread();
        #15 C_thread();
    join_any

    #10 $display("%t : end fork_join", $time);
end


task A_thread();
$display("%t : A thread", $time);
endtask

task B_thread();
$display("%t : B thread", $time);
endtask

task C_thread();
$display("%t : C thread", $time);
endtask

endmodule
