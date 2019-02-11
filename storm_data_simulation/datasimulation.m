w=2*pi*167;
t=0:1/10000:1;
duty=5;
Voltage1=0.6*(square(w*t,duty)+1)+1;
Voltage2=(square(w*t,duty)+1)*0.5+1;
data=[Voltage1;Voltage2];
data=data';
xlswrite('data.xlsx',data);
