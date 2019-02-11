/*********************************************************************************/
/*   文件名： Taylorsine.c (将sineCODEC和sinecompute合并，实现计算并实时输出)                                                           */
/*   创建时间：10/05/2012                                                       */
/*   功能描述：利用Taylor展开式法计算正弦波，并将信号从J6端口发送出去，平台为BJTU-DSP5502板*/
/*   作者： 钱满义myqian@bjtu.edu.cn 北京交通大学电信学院电工电子教学基地           */
/*********************************************************************************/


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
//#include "E2PROM_Function.h"
#include "CODEC.h"
 
//#define Nx 360           //每周期抽取点数
#pragma DATA_SECTION(output1,"data_out1");    //存放sin数据,浮点型
float output1[360]; 
#pragma DATA_SECTION(output,"data_out");    //存放sin数据，定点型
int output[360]; 


#undef  CODEC_ADDR
#define CODEC_ADDR 0x1A

  

 
// 定义McBSP的句柄
MCBSP_Handle hMcbsp;

 
void play(long Time,int Nx);	 
/*------------------------------------------------------------------------------------*/
//
// FUNCTION: MAIN
//
/*------------------------------------------------------------------------------------*/
                  
void main(void)
{
  
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

		play(10,127);
		while(1){}		
	
}
}

/******************************************************************************/
//	No more
/******************************************************************************/
void play(long Time,int Nx)
  {
    int i;
    double j;
	int x;
    float input0=0,x1;
    float a,b,c,d,e,f,g,h,ii,step;//step为角度步长  
    step=360.0/Nx;                // Nx为360度内取样点数
 /*****************新增函数段*****************/
  
   for(i=0;i<=Nx-1;i++) 
    {
       float angle,xx;
       angle=input0+step*i;
       x1=3.1415926*angle/180; 
       xx=x1*x1;
       a=1-xx/16/17;b=1-xx/14/15*a;c=1-xx/12/13*b;d=1-xx/10/11*c;e=1-xx/8/9*d;f=1-xx/6/7*e;g=1-xx/4/5*f;h=1-xx/2/3*g;ii=x1*h;
       output1[i]= 32767*ii; //利用泰勒级数计算出正弦波的数值，存放到output1中
       output[i]=output1[i]/8;					
    }
	Time=32000*Time;  

			  for(j=0;j<Time;j=j)
	 		  {	
		    	for(i=0;i<Nx;i++)
				{
				    x=output[i];
					while(!MCBSP_xrdy(hMcbsp)) {};
					MCBSP_write16(hMcbsp, x);
					while(!MCBSP_xrdy(hMcbsp)) {};
					MCBSP_write16(hMcbsp, x);
					j=j+1;
				}    
				
		      }
  }
