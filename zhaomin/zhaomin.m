clc;clear;
%load%
load('zhaomin.mat');
count_male=1;
count_female=1;
for i= 1:size(Sex)    
    if Sex(i,:)==2
        result_female(count_female,1)=grade(i,:);
        result_female(count_female,2)=quiz_1(i,:);
        result_female(count_female,3)=quiz_2(i,:);
        result_female(count_female,4)=quiz_3(i,:);
        result_female(count_female,5)=quiz_4(i,:);
        result_female(count_female,6)=quiz_5(i,:);
        result_female(count_female,7)=quiz_6(i,:);
        result_female(count_female,8)=quiz_7(i,:);
        result_female(count_female,9)=quiz_8(i,:);
        result_female(count_female,10)=quiz_9(i,:);
        count_female=count_female+1;
    elseif Sex(i,:)==1
        result_male(count_male,1)=grade(i,:);
        result_male(count_male,2)=quiz_1(i,:);
        result_male(count_male,3)=quiz_2(i,:);
        result_male(count_male,4)=quiz_3(i,:);
        result_male(count_male,5)=quiz_4(i,:);
        result_male(count_male,6)=quiz_5(i,:);
        result_male(count_male,7)=quiz_6(i,:);
        result_male(count_male,8)=quiz_7(i,:);
        result_male(count_male,9)=quiz_8(i,:);
        result_male(count_male,10)=quiz_9(i,:);
        count_male=count_male+1;
    end  
end
count_male=count_male-1;
count_female=count_female-1;
%statistic%
male_statistic_result=statistic_male(result_male);
female_statistic_result=statistic_female(result_female);
%analyze%
male.a=        [male_statistic_result.quiz1.a;
                      male_statistic_result.quiz2.a;
                      male_statistic_result.quiz3.a;
                      male_statistic_result.quiz4.a;
                      male_statistic_result.quiz5.a;
                      male_statistic_result.quiz6.a;
                      male_statistic_result.quiz7.a;
                      male_statistic_result.quiz8.a;
                      male_statistic_result.quiz9.a];
male.b=        [male_statistic_result.quiz1.b;
                      male_statistic_result.quiz2.b;
                      male_statistic_result.quiz3.b;
                      male_statistic_result.quiz4.b;
                      male_statistic_result.quiz5.b;
                      male_statistic_result.quiz6.b;
                      male_statistic_result.quiz7.b;
                      male_statistic_result.quiz8.b;
                      male_statistic_result.quiz9.b];                  
male.c=        [male_statistic_result.quiz1.c;
                      male_statistic_result.quiz2.c;
                      male_statistic_result.quiz3.c;
                      male_statistic_result.quiz4.c;
                      male_statistic_result.quiz5.c;
                      male_statistic_result.quiz6.c;
                      male_statistic_result.quiz7.c;
                      male_statistic_result.quiz8.c;
                      male_statistic_result.quiz9.c];
rate_male=[];
for i=1:9
rate_male=[rate_male;male.a(i,1),male.b(i,1),male.c(i,1);
                                    male.a(i,2),male.b(i,2),male.c(i,2)];
end
female.a=     [female_statistic_result.quiz1.a;
                      female_statistic_result.quiz2.a;
                      female_statistic_result.quiz3.a;
                      female_statistic_result.quiz4.a;
                      female_statistic_result.quiz5.a;
                      female_statistic_result.quiz6.a;
                      female_statistic_result.quiz7.a;
                      female_statistic_result.quiz8.a;
                      female_statistic_result.quiz9.a];
female.b=    [female_statistic_result.quiz1.b;
                      female_statistic_result.quiz2.b;
                      female_statistic_result.quiz3.b;
                      female_statistic_result.quiz4.b;
                      female_statistic_result.quiz5.b;
                      female_statistic_result.quiz6.b;
                      female_statistic_result.quiz7.b;
                      female_statistic_result.quiz8.b;
                      female_statistic_result.quiz9.b];                  
female.c=     [female_statistic_result.quiz1.c;
                      female_statistic_result.quiz2.c;
                      female_statistic_result.quiz3.c;
                      female_statistic_result.quiz4.c;
                      female_statistic_result.quiz5.c;
                      female_statistic_result.quiz6.c;
                      female_statistic_result.quiz7.c;
                      female_statistic_result.quiz8.c;
                      female_statistic_result.quiz9.c];
rate_female=[];
for i=1:9
    rate_female=[rate_female;female.a(i,1),female.b(i,1),female.c(i,1);
                            female.a(i,2),female.b(i,2),female.c(i,2)];
end