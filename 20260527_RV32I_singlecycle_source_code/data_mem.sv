`timescale 1ns / 1ps

`include "define.vh"

module data_mem (
    input logic clk,
    input logic [31:0] daddr,
    input logic dwe,
    input logic [2:0] mem_mode,
    input logic [31:0] dwdata,
    output logic [31:0] drdata
);


    logic [31:0] data_ram [0:63]  ;            //32bit = word 선언(SW) / 8bit = byte 선언(Riscv)(SB)

    always @(posedge clk) begin

        if (dwe) begin
            case (mem_mode)
                `SW: data_ram[(daddr[31:2])] <= dwdata;                 //daddr이 4씩 증가
                //SB, SH case문으로 추가 할 것.

                `SH: if(daddr[1]) data_ram[daddr[31:2]][31:16] <= dwdata[15:0];   
                else data_ram[daddr[31:2]][15:0] <= dwdata[15:0];       //daddr이 2씩 증가


                `SB: if(daddr[1:0] == 2'b11)  data_ram[daddr[31:2]][31:24] <= dwdata[7:0];  
                else  if(daddr[1:0] == 2'b10) data_ram[daddr[31:2]][23:16] <= dwdata[7:0];       //daddr이 1씩 증가 
                else  if(daddr[1:0] == 2'b01) data_ram[daddr[31:2]][15:8] <= dwdata[7:0];       //daddr이 1씩 증가
                else                          data_ram[daddr[31:2]][7:0] <= dwdata[7:0];       //daddr이 1씩 증가
                
            endcase
        end
    end


    always_comb begin
        drdata = 32'd0;
        case (mem_mode)
            `LW: drdata = data_ram[daddr[31:2]];        //daddr이 4씩 증가
            `LH: if(daddr[1])   drdata = {{16{data_ram[daddr[31:2]][31]}},data_ram[daddr[31:2]][31:16]};         //daddr이 2씩 증가
                 else           drdata = {{16{data_ram[daddr[31:2]][15]}},data_ram[daddr[31:2]][15:0]} ;            
            `LB: if(daddr[1:0] == 2'b11) drdata = {{24{data_ram[daddr[31:2]][31]}},data_ram[daddr[31:2]][31:24]} ;  
            else if(daddr[1:0] == 2'b10) drdata = {{24{data_ram[daddr[31:2]][23]}},data_ram[daddr[31:2]][23:16]} ;       //daddr이 1씩 증가 
            else if(daddr[1:0] == 2'b01) drdata = {{24{data_ram[daddr[31:2]][15]}},data_ram[daddr[31:2]][15:8] } ;       //daddr이 1씩 증가
            else drdata = {{24{data_ram[daddr[31:2]][7]}},data_ram[daddr[31:2]][7:0]}; 


`LHU: if(daddr[1])   drdata = {16'd0, data_ram[daddr[31:2]][31:16]};
      else           drdata = {16'd0, data_ram[daddr[31:2]][15:0]};

`LBU: if(daddr[1:0] == 2'b11) drdata = {24'd0, data_ram[daddr[31:2]][31:24]};
      else if(daddr[1:0] == 2'b10) drdata = {24'd0, data_ram[daddr[31:2]][23:16]};
      else if(daddr[1:0] == 2'b01) drdata = {24'd0, data_ram[daddr[31:2]][15:8]};
      else                         drdata = {24'd0, data_ram[daddr[31:2]][7:0]};

        endcase
    end

endmodule
