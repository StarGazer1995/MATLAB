function [b]=gpajudge_wes(a)
[n,~]=size(a);
b=zeros(1,n);
i=1;
while i<=n
if a(i)>=85
   b(i)=4;
elseif a(i)>=70
     b(i)=3;
elseif a(i)>=60
     b(i)=2;
else
        b(i)=1;
end 
i=i+1;
end
