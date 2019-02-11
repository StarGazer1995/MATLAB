load('gpa.mat');
credit=gpa(:,1);
grade=gpa(:,2);
sum_credit=sum(credit);
gre=gpajudge_bjtu(grade);
gpasum=gre*credit;
gpa_avg=gpasum/sum_credit;
