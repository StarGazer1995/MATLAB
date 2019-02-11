function result=statistic_male(data)
%%%quiz_male1 statistic%%%%
quiz_male1.a=0;
quiz_male1.b=0;
quiz_male1.c=0;
for i=1:max(size(data))
    if data(i,2)==1
        quiz_male1.a=quiz_male1.a+1;
    elseif data(i,2)==2
        quiz_male1.b=quiz_male1.b+1;
    else 
        quiz_male1.c=quiz_male1.c+1;
    end
    quiz_male1.a(:,2)=quiz_male1.a(:,1)/max(size(data));
    quiz_male1.b(:,2)=quiz_male1.b(:,1)/max(size(data));
    quiz_male1.c(:,2)=quiz_male1.c(:,1)/max(size(data));
end
%%%quiz_male2 statistic%%%%
quiz_male2.a=0;
quiz_male2.b=0;
quiz_male2.c=0;
for i=1:max(size(data))
    if data(i,3)==1
        quiz_male2.a=quiz_male2.a+1;
    elseif data(i,3)==2
        quiz_male2.b=quiz_male2.b+1;
    else 
        quiz_male2.c=quiz_male2.c+1;
    end
    quiz_male2.a(:,2)=quiz_male2.a(:,1)/max(size(data));
    quiz_male2.b(:,2)=quiz_male2.b(:,1)/max(size(data));
    quiz_male2.c(:,2)=quiz_male2.c(:,1)/max(size(data));

end
%%%quiz_male3 statistic%%%%
quiz_male3.a=0;
quiz_male3.b=0;
quiz_male3.c=0;
for i=1:max(size(data))
    if data(i,4)==1
        quiz_male3.a=quiz_male3.a+1;
    elseif data(i,4)==2
        quiz_male3.b=quiz_male3.b+1;
    else 
        quiz_male3.c=quiz_male3.c+1;
    end
    quiz_male3.a(:,2)=quiz_male3.a(:,1)/max(size(data));
    quiz_male3.b(:,2)=quiz_male3.b(:,1)/max(size(data));
    quiz_male3.c(:,2)=quiz_male3.c(:,1)/max(size(data));
end
%%%quiz_male4 statistic%%%%
quiz_male4.a=0;
quiz_male4.b=0;
quiz_male4.c=0;
for i=1:max(size(data))
    if data(i,5)==1
        quiz_male4.a=quiz_male4.a+1;
    elseif data(i,5)==2
        quiz_male4.b=quiz_male4.b+1;
    else 
        quiz_male4.c=quiz_male4.c+1;
    end
    quiz_male4.a(:,2)=quiz_male4.a(:,1)/max(size(data));
    quiz_male4.b(:,2)=quiz_male4.b(:,1)/max(size(data));
    quiz_male4.c(:,2)=quiz_male4.c(:,1)/max(size(data));
end
%%%quiz_male5 statistic%%%%
quiz_male5.a=0;
quiz_male5.b=0;
quiz_male5.c=0;
for i=1:max(size(data))
    if data(i,6)==1
        quiz_male5.a=quiz_male5.a+1;
    elseif data(i,6)==2
        quiz_male5.b=quiz_male5.b+1;
    else 
        quiz_male5.c=quiz_male5.c+1;
    end
    quiz_male5.a(:,2)=quiz_male5.a(:,1)/max(size(data));
    quiz_male5.b(:,2)=quiz_male5.b(:,1)/max(size(data));
    quiz_male5.c(:,2)=quiz_male5.c(:,1)/max(size(data));
end
%%%quiz_male6 statistic%%%%
quiz_male6.a=0;
quiz_male6.b=0;
quiz_male6.c=0;
for i=1:max(size(data))
    if data(i,7)==1
        quiz_male6.a=quiz_male6.a+1;
    elseif data(i,7)==2
        quiz_male6.b=quiz_male6.b+1;
    else 
        quiz_male6.c=quiz_male6.c+1;
    end
    quiz_male6.a(:,2)=quiz_male6.a(:,1)/max(size(data));
    quiz_male6.b(:,2)=quiz_male6.b(:,1)/max(size(data));
    quiz_male6.c(:,2)=quiz_male6.c(:,1)/max(size(data));
end
%%%quiz_male7 statistic%%%%
quiz_male7.a=0;
quiz_male7.b=0;
quiz_male7.c=0;
for i=1:max(size(data))
    if data(i,8)==1
        quiz_male7.a=quiz_male7.a+1;
    elseif data(i,8)==2
        quiz_male7.b=quiz_male7.b+1;
    else 
        quiz_male7.c=quiz_male7.c+1;
    end
    quiz_male7.a(:,2)=quiz_male7.a(:,1)/max(size(data));
    quiz_male7.b(:,2)=quiz_male7.b(:,1)/max(size(data));
    quiz_male7.c(:,2)=quiz_male7.c(:,1)/max(size(data));
end
%%%quiz_male8 statistic%%%%
quiz_male8.a=0;
quiz_male8.b=0;
quiz_male8.c=0;
for i=1:max(size(data))
    if data(i,9)==1
        quiz_male8.a=quiz_male8.a+1;
    elseif data(i,9)==2
        quiz_male8.b=quiz_male8.b+1;
    else 
        quiz_male8.c=quiz_male8.c+1;
    end
    quiz_male8.a(:,2)=quiz_male8.a(:,1)/max(size(data));
    quiz_male8.b(:,2)=quiz_male8.b(:,1)/max(size(data));
    quiz_male8.c(:,2)=quiz_male8.c(:,1)/max(size(data));
end
%%%quiz_male9 statistic%%%%
quiz_male9.a=0;
quiz_male9.b=0;
quiz_male9.c=0;
for i=1:max(size(data))
    if data(i,10)==1
        quiz_male9.a=quiz_male9.a+1;
    elseif data(i,10)==2
        quiz_male9.b=quiz_male9.b+1;
    else 
        quiz_male9.c=quiz_male9.c+1;
    end
    quiz_male9.a(:,2)=quiz_male9.a(:,1)/max(size(data));
    quiz_male9.b(:,2)=quiz_male9.b(:,1)/max(size(data));
    quiz_male9.c(:,2)=quiz_male9.c(:,1)/max(size(data));
end
result.quiz1=quiz_male1;
result.quiz2=quiz_male2;
result.quiz3=quiz_male3;
result.quiz4=quiz_male4;
result.quiz5=quiz_male5;
result.quiz6=quiz_male6;
result.quiz7=quiz_male7;
result.quiz8=quiz_male8;
result.quiz9=quiz_male9;
end