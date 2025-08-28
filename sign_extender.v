`timescale 1ns / 1ps

module sign_extender(
    input [11:0] in_value,
    input [3:0] in_width,
    output reg [15:0] ext_value
    );
    
    always@ (*) begin
    
        case(in_width)
            5: ext_value <= {{11{in_value[4]}}, in_value[4:0]};
            6: ext_value <= {{10{in_value[5]}}, in_value[5:0]};
            9: ext_value <= {{7{in_value[8]}}, in_value[8:0]};
            11: ext_value <= {{5{in_value[10]}}, in_value[10:0]};
            default: ext_value <= 16'h0000;
        endcase
    
    end
    
endmodule