module Contador(SW, CLOCK_50, HEX4);
input wire [17:0] SW;
input wire CLOCK_50;
output wire [0:6] HEX4;
	
wire clk;
wire [3:0] sm;
	
DivFreq df(.Clock(CLOCK_50), .Saida_DivFreq(clk));
Moore m(.Up(SW[1]), .Down(SW[0]), .Reset(SW[17]), .Clock(clk), .SaidaMoore(sm));
BCD b(.entrada(sm), .segmentos(HEX4));
endmodule


module DivFreq(Clock, Saida_DivFreq);
input Clock;
output reg Saida_DivFreq;
reg [25:0] OUT;
always @ (posedge Clock)
    if (OUT == 26'd50000000)
    begin
	    OUT <= 26'd0;
	    Saida_DivFreq <= 1;
    end
    else
    begin
	    OUT<= OUT+1;
	    Saida_DivFreq <= 0;
    end
endmodule


module Moore(Up, Down, Reset, Clock, SaidaMoore);
input Up, Down, Reset, Clock;
output reg [3:0]SaidaMoore;

reg [3:0] estadoAtual; 
reg [3:0] proxEstado;

parameter A= 4'b0000, B= 4'b0001, C= 4'b0010, D= 4'b0011, E= 4'b0100, F= 4'b0101, G= 4'b0110, H= 4'b0111, I= 4'b1000, J= 4'b1001;

always @(estadoAtual or Up or Down)
    begin
    case(estadoAtual)
    	A:
	    	if(Up==0 & Down==0)
		   	begin
			    proxEstado=A;
		    end
		    else if(Up==0 & Down==1)
			begin
    			proxEstado=I;
			end
    		else if(Up==1 & Down==0)
			begin
    			proxEstado=B;
			end
    		else if(Up==1 & Down==1)
			begin
    			proxEstado=J;
			end
    	B:
    		if(Up==0 & Down==0)
			begin
    			proxEstado=B;
			end
    		else if(Up==0 & Down==1)
			begin
    			proxEstado=A;
			end
    		else if(Up==1 & Down==0)
			begin
    			proxEstado=C;
			end
    		else if(Up==1 & Down==1)
			begin
    			proxEstado=J;
			end
    	C:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=C;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=B;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=D;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end
    	D:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=D;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=C;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=E;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end
    	E:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=E;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=D;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=F;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end	
    	F:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=F;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=E;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=G;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end
    	G:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=G;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=F;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=H;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end
    	H:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=H;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=G;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=I;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end
    	I:
    		if(Up==0 & Down==0)
    		begin
    			proxEstado=I;
    		end
    		else if(Up==0 & Down==1)
    		begin
    			proxEstado=H;
    		end
    		else if(Up==1 & Down==0)
    		begin
    			proxEstado=A;
    		end
    		else if(Up==1 & Down==1)
    		begin
    			proxEstado=J;
    		end
    	J:
    		if(Up==0 & Down==0)
			begin
    			proxEstado=J;
			end
    		else if(Up==0 & Down==1)
			begin
    			proxEstado=A;
			end
    		else if(Up==1 & Down==0)
			begin
    			proxEstado=A;
			end
    		else if(Up==1 & Down==1)
			begin
    			proxEstado=J;
			end
    	endcase
    end
    
always @(posedge Clock or posedge Reset) // Reset
begin	
	if(Reset == 1)
		estadoAtual <= A;
	else
		estadoAtual <= proxEstado;
end
    
always @(estadoAtual) // saida de acordo com o estado atual
begin
	case(estadoAtual)
    	A: SaidaMoore = 4'b1001;
    	B: SaidaMoore = 4'b0100;
    	C: SaidaMoore = 4'b0110;
    	D: SaidaMoore = 4'b0101;
    	E: SaidaMoore = 4'b1000;
    	F: SaidaMoore = 4'b0010;
    	G: SaidaMoore = 4'b0001;
    	H: SaidaMoore = 4'b0000;
    	I: SaidaMoore = 4'b0101;
    	J: SaidaMoore = 4'b1111;
    endcase
end
endmodule


module BCD (entrada, segmentos);
input wire [3:0] entrada;
output reg [0:6] segmentos;
always @ (*)
    case (entrada)
		4'b0000: segmentos=7'b0000001;
		4'b0001: segmentos=7'b1001111;
		4'b0010: segmentos=7'b0010010;
		4'b0011: segmentos=7'b0000110;
		4'b0100: segmentos=7'b1001100;
		4'b0101: segmentos=7'b0100100;
		4'b0110: segmentos=7'b0100000;
		4'b0111: segmentos=7'b0001111;
		4'b1000: segmentos=7'b0000000;
		4'b1001: segmentos=7'b0000100;
		default: segmentos = 7'b1111111;
	endcase
endmodule

