function data=maxpoolling(input)
[m,n]=size(input);result_temp=[];
result=[];
for i=1:2:m-1
    for j=1:2:n-1
    result_temp=[result_temp,max(max(input(i:i+1,j:j+1)))]
    end
    result=[result;result_temp]
    result_temp=[];
end
data=result;
end
