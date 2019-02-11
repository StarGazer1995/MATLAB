function result=statistic_female(data)
%%%quiz_female1 statistic%%%%
quiz_female1.a=0;
quiz_female1.b=0;
quiz_female1.c=0;
for i=1:max(size(data))
    if data(i,2)==1
        quiz_female1.a=quiz_female1.a+1;
    elseif data(i,2)==2
        quiz_female1.b=quiz_female1.b+1;
    else 
        quiz_female1.c=quiz_female1.c+1;
    end
    quiz_female1.a(:,2)=quiz_female1.a(:,1)/max(size(data));
    quiz_female1.b(:,2)=quiz_female1.b(:,1)/max(size(data));
    quiz_female1.c(:,2)=quiz_female1.c(:,1)/max(size(data));
end
%%%quiz_female2 statistic%%%%
quiz_female2.a=0;
quiz_female2.b=0;
quiz_female2.c=0;
for i=1:max(size(data))
    if data(i,3)==1
        quiz_female2.a=quiz_female2.a+1;
    elseif data(i,3)==2
        quiz_female2.b=quiz_female2.b+1;
    else 
        quiz_female2.c=quiz_female2.c+1;
    end
    quiz_female2.a(:,2)=quiz_female2.a(:,1)/max(size(data));
    quiz_female2.b(:,2)=quiz_female2.b(:,1)/max(size(data));
    quiz_female2.c(:,2)=quiz_female2.c(:,1)/max(size(data));
end
%%%quiz_female3 statistic%%%%
quiz_female3.a=0;
quiz_female3.b=0;
quiz_female3.c=0;
for i=1:max(size(data))
    if data(i,4)==1
        quiz_female3.a=quiz_female3.a+1;
    elseif data(i,4)==2
        quiz_female3.b=quiz_female3.b+1;
    else 
        quiz_female3.c=quiz_female3.c+1;
    end
    quiz_female3.a(:,2)=quiz_female3.a(:,1)/max(size(data));
    quiz_female3.b(:,2)=quiz_female3.b(:,1)/max(size(data));
    quiz_female3.c(:,2)=quiz_female3.c(:,1)/max(size(data));
end
%%%quiz_female4 statistic%%%%
quiz_female4.a=0;
quiz_female4.b=0;
quiz_female4.c=0;
for i=1:max(size(data))
    if data(i,5)==1
        quiz_female4.a=quiz_female4.a+1;
    elseif data(i,5)==2
        quiz_female4.b=quiz_female4.b+1;
    else 
        quiz_female4.c=quiz_female4.c+1;
    end
    quiz_female4.a(:,2)=quiz_female4.a(:,1)/max(size(data));
    quiz_female4.b(:,2)=quiz_female4.b(:,1)/max(size(data));
    quiz_female4.c(:,2)=quiz_female4.c(:,1)/max(size(data));
end
%%%quiz_female5 statistic%%%%
quiz_female5.a=0;
quiz_female5.b=0;
quiz_female5.c=0;
for i=1:max(size(data))
    if data(i,6)==1
        quiz_female5.a=quiz_female5.a+1;
    elseif data(i,6)==2
        quiz_female5.b=quiz_female5.b+1;
    else 
        quiz_female5.c=quiz_female5.c+1;
    end
    quiz_female5.a(:,2)=quiz_female5.a(:,1)/max(size(data));
    quiz_female5.b(:,2)=quiz_female5.b(:,1)/max(size(data));
    quiz_female5.c(:,2)=quiz_female5.c(:,1)/max(size(data));
end
%%%quiz_female6 statistic%%%%
quiz_female6.a=0;
quiz_female6.b=0;
quiz_female6.c=0;
for i=1:max(size(data))
    if data(i,7)==1
        quiz_female6.a=quiz_female6.a+1;
    elseif data(i,7)==2
        quiz_female6.b=quiz_female6.b+1;
    else 
        quiz_female6.c=quiz_female6.c+1;
    end
    quiz_female6.a(:,2)=quiz_female6.a(:,1)/max(size(data));
    quiz_female6.b(:,2)=quiz_female6.b(:,1)/max(size(data));
    quiz_female6.c(:,2)=quiz_female6.c(:,1)/max(size(data));
end
%%%quiz_female7 statistic%%%%
quiz_female7.a=0;
quiz_female7.b=0;
quiz_female7.c=0;
for i=1:max(size(data))
    if data(i,8)==1
        quiz_female7.a=quiz_female7.a+1;
    elseif data(i,8)==2
        quiz_female7.b=quiz_female7.b+1;
    else 
        quiz_female7.c=quiz_female7.c+1;
    end
    quiz_female7.a(:,2)=quiz_female7.a(:,1)/max(size(data));
    quiz_female7.b(:,2)=quiz_female7.b(:,1)/max(size(data));
    quiz_female7.c(:,2)=quiz_female7.c(:,1)/max(size(data));
end
%%%quiz_female8 statistic%%%%
quiz_female8.a=0;
quiz_female8.b=0;
quiz_female8.c=0;
for i=1:max(size(data))
    if data(i,9)==1
        quiz_female8.a=quiz_female8.a+1;
    elseif data(i,9)==2
        quiz_female8.b=quiz_female8.b+1;
    else 
        quiz_female8.c=quiz_female8.c+1;
    end
    quiz_female8.a(:,2)=quiz_female8.a(:,1)/max(size(data));
    quiz_female8.b(:,2)=quiz_female8.b(:,1)/max(size(data));
    quiz_female8.c(:,2)=quiz_female8.c(:,1)/max(size(data));
end
%%%quiz_female9 statistic%%%%
quiz_female9.a=0;
quiz_female9.b=0;
quiz_female9.c=0;
for i=1:max(size(data))
    if data(i,10)==1
        quiz_female9.a=quiz_female9.a+1;
    elseif data(i,10)==2
        quiz_female9.b=quiz_female9.b+1;
    else 
        quiz_female9.c=quiz_female9.c+1;
    end
    quiz_female9.a(:,2)=quiz_female9.a(:,1)/max(size(data));
    quiz_female9.b(:,2)=quiz_female9.b(:,1)/max(size(data));
    quiz_female9.c(:,2)=quiz_female9.c(:,1)/max(size(data));
end
result.quiz1=quiz_female1;
result.quiz2=quiz_female2;
result.quiz3=quiz_female3;
result.quiz4=quiz_female4;
result.quiz5=quiz_female5;
result.quiz6=quiz_female6;
result.quiz7=quiz_female7;
result.quiz8=quiz_female8;
result.quiz9=quiz_female9;
end