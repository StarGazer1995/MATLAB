figure(1);
fplot('variable.*sin(10*pi*variable)+2',[-1,2])
NIND=40;
MAXGEN=25;
PRECI=20;
GGAP=0.9;
trace=zeros(2,MAXGEN);
FieldD=[20;-1;2;1;0;1;1];
Chrom=crtbp(NIND,PRECI);
gen=0;
variable=bs2rv(Chrom,FieldD);
ObjV=variable.*sin(10*pi*variable)+2;
while gen<=MAXGEN
    FitnV=ranking(-ObjV);
    SelCh=select('sus',Chrom,FitnV,GGAP);
    SelCh=recombin('xovsp',SelCh,0.7);
    SelCh=mut(SelCh);
    variable=bs2rv(SelCh,FieldD);
    ObjVSel=variable.*sin(10*pi*variable)+2;
    [Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
    gen=gen+1;
    [Y,I]=max(ObjV),hold on;
   plot(ObjV(I),Y,'r^')
    trace(1,gen)=max(ObjV);
    trace(2,gen)=sum(ObjV)/length(ObjV);
end
variable=bs2rv(Chrom,FieldD);
hold on,grid;
plot(variable',ObjV','r^')
figure(2);
plot(trace(1,:)')
hold on;
plot(trace(2,:)')
grid;