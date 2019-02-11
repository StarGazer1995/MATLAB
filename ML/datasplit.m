function data=datasplit(input,fliter)
[m,n]=size(input);
%[x,y]=size(fliter);
result_temp=[];result=[];
for i=1:m-2
    for j=1:n-2
    result_temp=[result_temp,sum(sum(input(i:i+2,j:j+2).*fliter))]
    end
    result=[result;result_temp]
    result_temp=[];
end
data=result;
end