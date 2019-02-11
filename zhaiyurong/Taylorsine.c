#include <math.h>
#include <stdio.h>
#include <csl.h>
#include <csl_chip.h>
#include <csl_i2c.h>
#include <csl_pll.h>
#include <csl_mcbsp.h>
#include <csl_emif.h>
#include <csl_emifBhal.h>
#include <stdio.h>
#include "CODEC.h"          

#define Nx0 160    //二维数组的列数
#define Nx1 1
#define Nx2 2            
#define Nx3 3
#define Nx4 4
#define Nx5 5
#define Nx6 6
#define Nx7 7
#define Nx1s 8
#define Nx2s 9
#define Nx3s 10
#define Nx4s 11
#define Nx5s 12
#define Nx6s 13
#define Nx7s 14                 //每个音符的宏定义

#pragma DATA_SECTION(output1,"data_out1");    //分配存储空间
float output1[Nx0];                          //定义数组
#pragma DATA_SECTION(output,"data_out");   
int output[15][Nx0];                  //定义二维数组 所有音符的正弦数据
#pragma DATA_SECTION(Nx,"nx");    
int Nx[15]={160,122,109,97,92,82,73,65,61,55,49,46,41,36,32}; //每个音符的抽样点数N 用公式

#undef  CODEC_ADDR
#define CODEC_ADDR 0x1A

  

 
// 定义McBSP的句柄
MCBSP_Handle hMcbsp;

 
void play(long Time,int Freq);	 //定义播放函数
/*------------------------------------------------------------------------------------*/
//
// FUNCTION: MAIN
//
/*------------------------------------------------------------------------------------*/
                  
void main(void)
{
  
    Uint16  i,j=0;
   
 float x1;
 float a,b,c,d,e,f,g,h,ii,ii2,ii3,step;//step为角度步长  

 /*****************新增函数段*****************/  //存所有抽样点的过程
 for(j=1;j<15;j++)                 //第几个音符
 {
   step=360.0/Nx[j];                // 每隔几度采一个点
   for(i=0;i<=Nx[j]-1;i++)          //每个音符采样点逐个输出
   {
     float angle,xx;
     angle=step*i;                 //每个采样点对应的角度
     x1=3.1415926*angle/180;       //转化成弧度
     xx=x1*x1;
     a=1-xx/16/17;b=1-xx/14/15*a;c=1-xx/12/13*b;d=1-xx/10/11*c;e=1-xx/8/9*d;f=1-xx/6/7*e;g=1-xx/4/5*f;h=1-xx/2/3*g;ii=x1*h; //利用泰勒级数计算正弦函数展开
                                                                                                          //ii是产生的正弦波

     angle=2*(step*i);           //加二次谐波，频率是二倍
     if(angle>360)
     {
       angle=angle-360;            //角度范围判断 否则计算弧度错误
     }

     x1=3.1415926*angle/180; //second
     xx=x1*x1;
     a=1-xx/16/17;b=1-xx/14/15*a;c=1-xx/12/13*b;d=1-xx/10/11*c;e=1-xx/8/9*d;f=1-xx/6/7*e;g=1-xx/4/5*f;h=1-xx/2/3*g;ii2=x1*h;

     angle=3*(step*i);         //加三次谐波
     if(angle>720)
     {
       angle=angle-720;
     }
     else if(angle>360)
     {
       angle=angle-360;
     }
     x1=3.1415926*angle/180; //third
     xx=x1*x1;
     a=1-xx/16/17;b=1-xx/14/15*a;c=1-xx/12/13*b;d=1-xx/10/11*c;e=1-xx/8/9*d;f=1-xx/6/7*e;g=1-xx/4/5*f;h=1-xx/2/3*g;ii3=x1*h;

     ii=ii+0.5*ii2+0.2*ii3;     //基波与谐波的叠加  调整系数改变音色

     output1[i]= 32767*ii; //调节正弦波的幅度 增大音量
     output[j][i]=output1[i]/8;		//存放所有正弦波的数据  除以8防止音量太大			
   }

}

for(i=0;i<160;i++)
{
  output[0][i]=0;       //数组第一行均为0音符
}
// Initialize CSL library - This is REQUIRED !!! 
    CSL_init();
 
// The main frequency of system is 240MHz
// 该频率是为了设置IIC模块的需要设置的,为了使用I2C_setup函数
    PLL_setFreq(1, 0xC, 0, 1, 3, 3, 0);

    //EMIF初始化
     Emif_Config(); 
  
// Open McBSP port 1 and get a McBSP type handle
	hMcbsp = MCBSP_open(MCBSP_PORT1,MCBSP_OPEN_RESET);

// Config McBSP	port 1 by use previously defined structure
	Mcbsp_Config(hMcbsp);
	
//I2C初始化
	I2C_cofig(); 
    
//CODEC寄存器初始化
	inti_AIC(); 
	    	   
/*------------------------------------------------------------------------------------*/	    	        	   
// Receive the ADC output data of CODEC  
// Then output the received data to DAC of CODEC 
/*------------------------------------------------------------------------------------*/
	while(1)
	{

	          
             //tzdn
			 /* play(48000,5);
              play(48000,5);
			  play(48000,5);
			  play(16000,3);
			  play(16000,4);
			  play(16000,5);
			  play(48000,7);
			  play(48000,6);
			  play(48000,5);
              play(16000,5);
			  play(16000,2);
			  play(16000,3);

			  play(48000,4);
              play(48000,4);
			  play(40000,4);
			  play(8000,1);
			  play(48000,1);
			  play(48000,1);
			  play(48000,2);
              play(48000,2);
			  

              play(16000,5);
              play(16000,5);
			  play(16000,5);
			  play(16000,5);
			  play(16000,3);
			  play(16000,4);
			  play(48000,5);
			  play(48000,7);
			  play(16000,6);
              play(16000,6);
			  play(16000,6);
			  play(16000,6);
              play(16000,4);
			  play(16000,6);
			  play(48000,5);
			  play(48000,5);

			  play(16000,5);
              play(16000,5);
			  play(16000,5);
			  play(16000,5);
			  play(16000,7);
			  play(16000,6);
			  play(16000,5);
              play(16000,4);
			  play(16000,4);
			  play(48000,4);
			  play(16000,4);
              play(16000,4);
			  play(16000,4);
			  play(16000,4);
              play(16000,3);
			  play(16000,2);
			  play(48000,1);
			  play(48000,1);

			  play(16000,5);
              play(16000,5);
			  play(16000,5);
			  play(16000,5);
			  play(16000,3);
			  play(16000,4);
			  play(48000,5);
			  play(48000,7);
			  play(16000,6);
              play(16000,6);
			  play(16000,6);
			  play(16000,6);
              play(16000,4);
			  play(16000,6);
			  play(48000,5);
			  play(48000,5);

			  play(16000,5);
              play(16000,5);
			  play(16000,5);
			  play(16000,5);
			  play(16000,7);
			  play(16000,6);
			  play(16000,5);
              play(16000,4);
			  play(16000,4);
			  play(48000,4);
			  play(16000,4);
              play(16000,4);
			  play(16000,4);
			  play(16000,4);
              play(16000,3);
			  play(16000,2);
			  play(48000,1);
			  play(48000,1);*/

			  //wy heart will go on
			   play(48000,0);
               play(8000,Nx1s);
               play(8000,Nx2s);
			   play(48000,Nx3s);
			   play(8000,Nx2s);
               play(8000,Nx1s);
			   play(16000,Nx2s);
               play(32000,Nx5s);
			   play(8000,Nx4s);
               play(8000,Nx3s);
			   play(48000,Nx1s);
               play(16000,Nx6);

			   play(48000,Nx5);
               play(8000,Nx1s);
			   play(8000,Nx2s);
               play(8000,Nx2s);
			   play(24000,Nx3s);
               play(8000,Nx3s);
			   play(4000,Nx4s);
               play(4000,Nx3s);
			   play(8000,Nx1s);
               play(8000,Nx2s);
			   play(16000,Nx2s);
               play(32000,Nx5s);
			   play(8000,Nx3s);
               play(8000,Nx5s);
			   play(32000,Nx6s);
               play(32000,Nx5s);  
               
               play(4000,Nx2s);
               play(4000,Nx3s);  
               play(24000,Nx2s);
               play(24000,Nx2s); 
			   play(8000,0);
			  
               play(24000,Nx1s);
			   play(8000,Nx1s);
               play(16000,Nx1s);
               play(16000,Nx1s);

               play(16000,Nx7);
			   play(32000,Nx1s);
               play(16000,Nx1s);

			   play(16000,Nx7);
			   play(32000,Nx1s);
               play(16000,Nx2s);
               

			   play(32000,Nx3s);
			   play(32000,Nx2s);

               play(24000,Nx1s);
			   play(8000,Nx1s);
               play(16000,Nx1s);
               play(16000,Nx1s);

               play(16000,Nx7);
			   play(32000,Nx1s);
               play(16000,Nx1s);
 				
			   play(64000,Nx5);



			    play(32000,0);
				play(8000,Nx4);
			    play(8000,Nx5);
				play(8000,Nx6);
			    play(8000,Nx7); 
			    
			    play(24000,Nx1s);
			   play(8000,Nx1s);
               play(16000,Nx1s);
               play(16000,Nx1s);

               play(16000,Nx7);
			   play(32000,Nx1s);
               play(16000,Nx1s); 

			    play(16000,Nx7);
			   play(32000,Nx1s);
               play(16000,Nx2s);

			   play(32000,Nx3s);
			   play(4000,Nx4s);
               play(4000,Nx3s);
			   play(24000,Nx2s);
			  
                play(24000,Nx1s);
			   play(8000,Nx1s);
               play(16000,Nx1s);
               play(16000,Nx1s);

               play(16000,Nx7);
			   play(32000,Nx1s);
               play(16000,Nx1s);
 				
			   play(64000,Nx5);




			   //
			   play(64000,0);

			   play(64000,Nx1s);

			   play(48000,Nx2s);
               play(16000,Nx5);

               play(32000,Nx5s);
               play(16000,Nx4s);
			   play(16000,Nx3s);


               play(32000,Nx2s);	
			   play(16000,Nx3s);
			   play(16000,Nx4s);

			   play(32000,Nx3s);	
			   play(16000,Nx2s);
			   play(16000,Nx1s);

			   play(16000,Nx7);	
			   play(32000,Nx1s);
			   play(16000,Nx7);

			   play(64000,Nx6);	




			   play(32000,Nx5);	
			   play(8000,Nx3);
			   play(8000,Nx5);
			   play(8000,Nx6);
			   play(8000,Nx7);

			   play(64000,Nx1s);

			   play(48000,Nx2s);
               play(16000,Nx5);
			   
			   play(32000,Nx5s);
               play(16000,Nx4s);
			   play(16000,Nx3s);

			   play(32000,Nx2s);	
			   play(16000,Nx3s);
			   play(16000,Nx4s);

			   play(32000,Nx3s);	
			   play(16000,Nx2s);
			   play(16000,Nx1s);

			   play(16000,Nx7);	
			   play(32000,Nx1s);
			   play(16000,Nx7);

			   play(16000,Nx7);
			   play(32000,Nx1s);
			   play(16000,Nx2s);
               //
               play(32000,Nx3s);	
			   play(16000,Nx2s);
			   play(8000,Nx1s);
			   play(8000,Nx2s);

			   play(48000,Nx3s);
			   play(8000,Nx2s);
			   play(8000,Nx1s);

			   play(16000,Nx2s);
               play(32000,Nx5s);
			   play(8000,Nx4s);
			   play(8000,Nx3s);

			   play(48000,Nx1s);
			   play(16000,Nx6);


			   play(48000,Nx5);
			   play(8000,Nx1s);
			   play(8000,Nx2s);

			   play(8000,Nx2s);
			   play(24000,Nx3s);
			   play(8000,Nx3s);
			   play(4000,Nx4s);
			   play(4000,Nx3s);
			   play(8000,Nx2s);
			   play(8000,Nx1s);

			   play(16000,Nx2s);
			   play(32000,Nx5s);
			   play(8000,Nx3s);
			   play(8000,Nx5s);

			   play(64000,Nx6s);
			   play(64000,Nx6s);

			  
}
 
}

 void play(long Time,int Freq)
  {
    
	
	  int i;
      double j;
	  int a;  
	  
			  for(j=0;j<Time;j=j)
	 		  {	
		    	for(i=0;i<Nx[Freq];i++)
				{
				    a=output[Freq][i]*sin((j/Time)*3.1415926);  //播放二维数组所选音符的一个采样点    //正半周期正弦包络 防止拍子被截成两半
					while(!MCBSP_xrdy(hMcbsp)) {};
					MCBSP_write16(hMcbsp, a);  //a必须为int型
					while(!MCBSP_xrdy(hMcbsp)) {};
					MCBSP_write16(hMcbsp, a);   //左右声道分别输出
					j=j+1;     //time控制播放时长 内循环是音符一个周期的采样点
				}    
				
		      }
	
   }


