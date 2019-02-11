function gzplot(e,t)
[~,n]=size(e);
for j=1:n
    subplot(n,1,j)
    plot(t,e(:,j));
    legend(['衰减到0的时间为' num2str(max(find(abs(e(:,j))>0.01))/100) 's']);
end
end