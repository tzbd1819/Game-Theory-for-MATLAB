close all;
clear all;
clc;
%%%%%%%%%%%%%%系统初始化%%%%%%%%%%%%%%%
n=100;   %n表示普通参与者用户的个数
round_time=100; %表示测试的总的次数
k=1;   %间谍的个数
agent_strategy=zeros(n+k,round_time); %表示博弈者的策略矩阵
agent_result=zeros(size(agent_strategy)); %表示博弈者的结果矩阵
agent_gain=zeros(size(agent_strategy)); %表示博弈者的增益矩阵
Y=zeros(size(agent_strategy)); %监视矩阵
A=zeros(n,round_time);  %用来判断间谍的策略值，对间谍策略进行赋值
gain_row=zeros(1,n);
gain_normal=zeros(1,n);
gain_jian=zeros(1,n);
gain_spy=zeros(1,n);
%%%%%%%%%%%%%以下用于给博弈者的策略赋值%%%%%%%%%%%%%%%%
for m=1:n   % m表示spyer的监视用户的个数，可以用连接度的概念来定义；
     I=randperm(n);
  for j=1:round_time
    for i=1:n
         agent_strategy(i,j)=round(rand); % 完成对博弈策略的赋值，每次赋予该轮的博弈策略值。按照四舍五入的方式赋值；
    end     
        for l=1:m
         Y(l,j)=agent_strategy(I(l),j); % 随着m值的不同，生成对应的矩阵，用于存储对应的监视用户策略的矩阵；   
        end
        A(m,j)=sum(Y(:,j)); % 对监视矩阵求和
    if A(m,j)>=(m+1)/2   % 选择1的人数多
           agent_strategy(n+k,j)=0;
    else      
            agent_strategy(n+k,j)=1;
    end
    %%%%%%%%%%%%%%%%%以下用于给博弈者的胜负赋值%%%%%%%%%%%%%%%%%%
    for i=1:n+k
    if sum(agent_strategy(:,j))>(k+n)/2  %选0获胜
           if agent_strategy(i,j)==0
                agent_result(i,j)=1;
            else
               agent_result(i,j)=0;
           end
    else   %选一获胜
           if agent_strategy(i,j)==0;
                   agent_result(i,j)=0;
            else
                   agent_result(i,j)=1;
           end
   end
%%%%%%%%%%%%%%%%%%%%%以下用于给博弈者的增益赋值%%%%%%%%%%%%%%%%%%%%%%
     if agent_result(i,j)==1
           agent_gain(i,j)=1;
     else
            agent_gain(i,j)=-1;
     end
  end
end
      gain_jian(m)=mean(agent_gain(I(l),:));
      gain_row(m)=mean(agent_gain(:));
      gain_spy(m)=mean(agent_gain(n+k,:));
      gain_normal(m)=gain_row(m)-gain_spy(m)- gain_jian(m);
end
figure('name','三类增益均值');
plot(gain_spy,'k:+')
hold on
plot(gain_jian,'g:o')
hold on
plot(gain_normal,'b:*')
%figure('name','参与者者益均值');
hold on
plot(gain_row,'m:.')
xlabel('连接度(间谍监视人数)')
ylabel('增益均值')
%figure('name','没被监视者益和');