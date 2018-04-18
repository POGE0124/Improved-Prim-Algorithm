clc;
clear all;
tic;
%经纬度坐标与空间直角坐标进行转化
% l=[114.31481,114.314092,114.346431,114.352755,114.358935,114.361091,114.375895,...
%     114.345281,114.318978,114.348874,114.376182];
% b=[34.823526,34.802899,34.813687,34.807523,34.81511,34.822341,34.817362,34.799461,...
%     34.815347,34.806337,34.822933];
l=[114.361163 114.356707 114.359079 114.362744 114.367235 114.359474 114.352862 114.34873 114.338238 114.346395];
b=[34.822311 34.818162 34.815169 34.812131 34.802277 34.803581 34.807463 34.806648 34.809375 34.813539];
L=l*2*pi/360;
B=b*2*pi/360;
a=6378.137;
b=6356.7523141;
e=sqrt(0.00669438002290);
N=a./sqrt(1-e.*sin(B).^2);
X=N.*cos(B).*cos(L);
Y=N.*cos(B).*sin(L);
Z=N.*(1-e^2).*sin(B);
for i=1:9
D=sqrt((Y(i+1)-Y(i))^2+(X(i+1)-X(i))^2+(Z(i+1)-Z(i))^2);
end
%经纬度坐标与空间直角坐标进行转化
x=X;
y=Y;
% x=[264 258 274 264 254 257 260 262 268 270];
% y=[715 719 728 728 728 733 731 733 733 739];
% x=[150  374 164 454 557 360 662 868 970];
% y=[457 989 728 428 828 233 531 633 933 139];


xlen = length(x);        %测量目标点的数量
stt=0;                   %已经找到几个点了
tag(xlen)=0;             %第i个点是否已经被确定，等于1就是被确定了，等于0就是还没有确定,定义一个xlen长度的标签数组，初始值均为0
result(xlen)=0;          %最终连线的节点标号顺序
%计算距离矩阵
     for i=1:xlen
         for j=1:xlen
          ptps(i,j)= sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);%ptps（i，j）表示i点到j点的距离
         end
     end
     
 %找到所有线段长度值中最小的那个线段
 min=ptps(1,2);%给min赋初值
 tagi=1;%线段长度最小时所对应的点
 tagj=2;%线段长度最小时所对应的点，tagi=1和tagj=2表示第一个行第二列
    for i=1:xlen
        for j=i+1:xlen
            if(min>ptps(i,j))
                min=ptps(i,j);
                tagi=i;
                tagj=j;
            end
        end
    end
    %找到所有线段长度值中最小的那个线段
   
	stt = 2;%初始化stt
	result(1) = tagi;
	result(2) = tagj;
    %tagi和tagj这两个点已经找到，所以赋值为1
	tag(tagi) = 1;
	tag(tagj) = 1;
    for i=1:xlen-2
        for j=1:xlen
            if(tag(j)==0)
                min=ptps(result(1),j);
                tagi=result(1);
                tagj=j;
                break
            end
        end
        for j=1:xlen
            if(tag(j)==0)
                temp=ptps(result(1),j);
                if(min>temp)
                min=ptps(result(1),j);
                tagi=result(1);
                tagj=j;
                end
            end
        end
        for j=1:xlen
            temp=ptps(result(stt),j);
            if(tag(j)==0&&min>temp)
                min=ptps(result(stt),j);
                tagi=result(stt);
                tagj=j;
            end
        end
        if(tagi==result(1))
            for j=stt:-1:1
                result(j+1)=result(j);
            end
            result(1)=tagj;
        else
            result(stt+1) = tagj;
        end
        tag(tagj)=1;
        stt=stt+1;
    end
    result
    result1=[10,9,3,4,8,7,6,5,2,1];
for i_d=1:xlen
x1(i_d)=x(result(i_d));
y1(i_d)=y(result(i_d));

end
figure()
plot(x1,y1,'+');

axis equal;
s=0;
for i_s=1:xlen-1
x2=[x1(i_s) x1(i_s+1)];
y2=[y1(i_s) y1(i_s+1)];

hold on;
line(x2,y2);
% line(x21,y21);
dis=sqrt((x1(i_s+1)-x1(i_s))^2+(y1(i_s+1)-y1(i_s))^2);
s=s+dis;
end
xlabel('x方向');
ylabel('y方向');
title( { '无人机在目标群中的最优轨迹', ['最短距离： ', num2str(s,'%.2f'), '千米   ','最短时间：',num2str(s/200,'%.2f'),'小时'] } )

xlswrite('ex',ptps);
t=toc


