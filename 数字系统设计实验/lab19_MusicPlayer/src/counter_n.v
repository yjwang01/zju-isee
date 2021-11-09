//////////////////////////////////////////////////////////////
// Company:zju 
// Engineer:qmj 
/////////////////////////////////////////////////////////////
module counter_n(clk,en,r,q,co);
  parameter  n=2; //����n��ʾ������ģ   
  parameter  counter_bits=1;//����counter_bits��ʾ������λ�� 
  input   clk,en,r ;
  output  co;
  output [counter_bits-1:0]  q;
  reg [counter_bits-1:0]  q=0;
  assign  co=(q==(n-1)) && en;//��λ
  always @(posedge clk) 
  begin
      if(r) q=0;
	  else if(en)  //en=1,�����cen=0,����
	          begin	 
                if(q==(n-1))  q=0 ;
                else q=q+1;		 
              end
        else q = q;
  end
endmodule
