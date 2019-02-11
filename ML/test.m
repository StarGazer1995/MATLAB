clear all; clc
data=[3,0,1,2,7,4;
      1,5,8,9,3,1;
      2,7,2,5,1,3;
      0,1,3,1,7,8;
      4,2,1,6,2,8;
      2,4,5,2,3,9];
 fliter=[1,0,-1;
         1,0,-1;
         1,0,-1];
result=datasplit(data,fliter);
maxpoolling=maxpoolling(result);

