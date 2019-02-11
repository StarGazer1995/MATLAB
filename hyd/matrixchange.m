function [output]=matrixchange[input1,start1,end1];
slope=(end1(1,2)-start1(1,2))/(end1(1,1)-start1(1,1));
y=start1(1,2)+0.5;
step=0.1;
 for i=start1(1,1):step:end1(1,1)
 y=y+slope*step;
 y1=int8(y);
 x1=int8(i);
 input1(x1,y1)=1;
 end
end
