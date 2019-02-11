function [ z ] = thefunction( x,y )  
%UNTITLED2 此处显示有关此函数的摘要  
%   此处显示详细说明  
z = 0;  
if x>=0 && x<30   
    if y>=0 && y<30  
    z = 30*x-y;      
    else if y>=30 && y<=60  
            z = 30*y-x;  
        end  
    end      
end  
     
if x>=30 && x<=60  
    if y>=0 && y<=30  
        z = x*x-y/2;  
    else if y>=30 && y<=60  
            z = 20*y*y-500*x;  
        end  
    end  
end  
  
  
end 