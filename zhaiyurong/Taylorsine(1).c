/*********************************************************************************/
/*   �ļ����� Taylorsine.c (��sineCODEC��sinecompute�ϲ���ʵ�ּ��㲢ʵʱ���)                                                           */
/*   ����ʱ�䣺10/05/2012                                                       */
/*   ��������������Taylorչ��ʽ���������Ҳ��������źŴ�J6�˿ڷ��ͳ�ȥ��ƽ̨ΪBJTU-DSP5502��*/
/*   ���ߣ� Ǯ����myqian@bjtu.edu.cn ������ͨ��ѧ����ѧԺ�繤���ӽ�ѧ����           */
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
 
//#define Nx 360           //ÿ���ڳ�ȡ����
#pragma DATA_SECTION(output1,"data_out1");    //���sin����,������
float output1[360]; 
#pragma DATA_SECTION(output,"data_out");    //���sin���ݣ�������
int output[360]; 


#undef  CODEC_ADDR
#define CODEC_ADDR 0x1A

  

 
// ����McBSP�ľ��
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
// ��Ƶ����Ϊ������IICģ�����Ҫ���õ�,Ϊ��ʹ��I2C_setup����
    PLL_setFreq(1, 0xC, 0, 1, 3, 3, 0);

    //EMIF��ʼ��
     Emif_Config(); 
  
// Open McBSP port 1 and get a McBSP type handle
	hMcbsp = MCBSP_open(MCBSP_PORT1,MCBSP_OPEN_RESET);

// Config McBSP	port 1 by use previously defined structure
	Mcbsp_Config(hMcbsp);
	
//I2C��ʼ��
	I2C_cofig(); 
    
//CODEC�Ĵ�����ʼ��
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
    float a,b,c,d,e,f,g,h,ii,step;//stepΪ�ǶȲ���  
    step=360.0/Nx;                // NxΪ360����ȡ������
 /*****************����������*****************/
  
   for(i=0;i<=Nx-1;i++) 
    {
       float angle,xx;
       angle=input0+step*i;
       x1=3.1415926*angle/180; 
       xx=x1*x1;
       a=1-xx/16/17;b=1-xx/14/15*a;c=1-xx/12/13*b;d=1-xx/10/11*c;e=1-xx/8/9*d;f=1-xx/6/7*e;g=1-xx/4/5*f;h=1-xx/2/3*g;ii=x1*h;
       output1[i]= 32767*ii; //����̩�ռ�����������Ҳ�����ֵ����ŵ�output1��
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
