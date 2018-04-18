clc;
clear all;
tic;
%��γ��������ռ�ֱ���������ת��
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
%��γ��������ռ�ֱ���������ת��
x=X;
y=Y;
% x=[264 258 274 264 254 257 260 262 268 270];
% y=[715 719 728 728 728 733 731 733 733 739];
% x=[150  374 164 454 557 360 662 868 970];
% y=[457 989 728 428 828 233 531 633 933 139];


xlen = length(x);        %����Ŀ��������
stt=0;                   %�Ѿ��ҵ���������
tag(xlen)=0;             %��i�����Ƿ��Ѿ���ȷ��������1���Ǳ�ȷ���ˣ�����0���ǻ�û��ȷ��,����һ��xlen���ȵı�ǩ���飬��ʼֵ��Ϊ0
result(xlen)=0;          %�������ߵĽڵ���˳��
%����������
     for i=1:xlen
         for j=1:xlen
          ptps(i,j)= sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);%ptps��i��j����ʾi�㵽j��ľ���
         end
     end
     
 %�ҵ������߶γ���ֵ����С���Ǹ��߶�
 min=ptps(1,2);%��min����ֵ
 tagi=1;%�߶γ�����Сʱ����Ӧ�ĵ�
 tagj=2;%�߶γ�����Сʱ����Ӧ�ĵ㣬tagi=1��tagj=2��ʾ��һ���еڶ���
    for i=1:xlen
        for j=i+1:xlen
            if(min>ptps(i,j))
                min=ptps(i,j);
                tagi=i;
                tagj=j;
            end
        end
    end
    %�ҵ������߶γ���ֵ����С���Ǹ��߶�
   
	stt = 2;%��ʼ��stt
	result(1) = tagi;
	result(2) = tagj;
    %tagi��tagj���������Ѿ��ҵ������Ը�ֵΪ1
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
xlabel('x����');
ylabel('y����');
title( { '���˻���Ŀ��Ⱥ�е����Ź켣', ['��̾��룺 ', num2str(s,'%.2f'), 'ǧ��   ','���ʱ�䣺',num2str(s/200,'%.2f'),'Сʱ'] } )

xlswrite('ex',ptps);
t=toc


