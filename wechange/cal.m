n=1;
number=[];
while(1)
    if mod(10^(n)-1,7)==0
    number=[number,(10^(n)-1)/7];
    
    end
    n=n+1;
    if max(size(number))==9
        break
    end
end