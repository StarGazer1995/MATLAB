function [b]=gpajudge(a)
[n,~]=size(a);
b=zeros(1,n);
i=1;
while i<=n
if a(i)>=90
   b(i)=4;
elseif a(i)>=85
     b(i)=3.7;
elseif a(i)>=81
     b(i)=3.5;
elseif a(i)>=78
         b(i)=3;
elseif  a(i)>=75
       b(i)=3.0;
elseif  a(i)>=72
       b(i)=2.3;
elseif  a(i)>=69
       b(i)=2.0;
elseif  a(i)>=66
       b(i)=1.5;
elseif  a(i)>=63
       b(i)=1.3;
elseif  a(i)>=60 
       b(i)=1.0;
else
        b(i)=0;
end 
i=i+1;
end
