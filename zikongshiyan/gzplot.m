function gzplot(a,b,c,d,e,f)
global n;
figure(n);
subplot(2,1,1);
plot(a,b);
title(c);
subplot(2,1,2);
plot(d,e);
title(f);
n=n+1;
end