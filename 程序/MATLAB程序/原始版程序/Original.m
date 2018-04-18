clc
clear all
%原始大地坐标系下的坐标数据
%开封市11
l=[114.319441 114.319127 114.319113 114.319306 114.319809 114.31689 114.317721 114.316288 114.315753 114.315511 114.316782];
b=[34.82488 34.825387 34.825706 34.82701 34.827721 34.827387 34.825958 34.824613 34.824639 34.823639 34.823017];
%大同市12
% l=[113.288281 113.290868 113.295611 113.286556 113.291586 113.307253 113.302366 113.310127 113.316883 113.310558 113.312714 113.30984];
% b=[40.103433 40.105972 40.100674 40.094051 40.08555 40.092726 40.099349 40.099018 40.092174 40.104758 40.107186 40.112373];
%南京市12
% l=[118.819399 118.823082 118.82946 118.836215 118.839234 118.848863 118.854038 118.850445 118.847282 118.861799 118.873297 118.874303];
% b=[32.071549 32.067334 32.06139 32.056616 32.05123 32.050985 32.048414 32.056127 32.060778 32.060901 32.060656 32.063838];
%商丘市11
% l=[115.627486 115.633073 115.636379 115.636092 115.642272 115.652477 115.647878 115.653052 115.652908 115.661963 115.663257];
% b=[34.434728 34.432443 34.432085 34.42756 34.423034 34.43018 34.434467 34.438755 34.438636 34.441881 34.450097];
%上海市8
% l=[121.49069 121.47991 121.498452 121.497445 121.504776 121.513543 121.520298 121.511675];
% b=[31.192201 31.189482 31.189111 31.180214 31.172923 31.169215 31.177743 31.187505];
%苏州市8
% l=[120.542654 120.566513 120.561339 120.571257 120.548979 120.559758 120.577006 120.58448];
% b=[31.21271 31.215922 31.222345 31.226298 31.232597 31.235191 31.242107 31.227533];
%无锡市11
% l=[120.25252 120.250364 120.255394 120.242602 120.237141 120.233979 120.250076 120.23096 120.242028 120.230385 120.223055];
% b=[31.59605 31.593589 31.590883 31.589406 31.586084 31.581532 31.579317 31.57341 31.567749 31.562703 31.556303];
%西安市13
% l=[108.937751 108.930996 108.929702 108.948243 108.935451 108.953849 108.944794 108.95313 108.947956 108.94695 108.946087 108.949249 108.9458];
% b=[34.298649 34.301393 34.306999 34.311054 34.31666 34.319642 34.319284 34.330136 34.332759 34.336455 34.34802 34.350404 34.358749];
%郑州市9
% l=[113.7243 113.724444 113.717689 113.724444 113.727318 113.726743 113.728037 113.741835 113.739104];
% b=[34.758723 34.761451 34.764773 34.768806 34.774617 34.780547 34.783986 34.778531 34.773194];
%重庆市9
% l=[106.593102 106.60345 106.607043 106.611499 106.613799 106.606756 106.609199 106.621129 106.627597];
% b=[29.550648 29.546909 29.545275 29.542384 29.538362 29.537357 29.53434 29.530946 29.540373]; 
len=length(l);
L=l*2*pi/360;
B=b*2*pi/360;
a=6378.137;
b=6356.7523141;
e=sqrt(0.00669438002290);
N=a./sqrt(1-e.*sin(B).^2);
X=N.*cos(B).*cos(L);
Y=N.*cos(B).*sin(L);
Z=N.*(1-e^2).*sin(B);
X=X'
Y=Y'
Z=Z'
for i=1:len
    for j=1:len
        D(i,j)=sqrt((Y(i)-Y(j))^2+(X(i)-X(j))^2+(Z(i)-Z(j))^2);
    end
end
for i=1:len
    for j=1:len
        D2(i,j)=0;
    end
    pointsel(i)=0;
end
pointsel(1)=1;
pathnum=0;
while pathnum<len-1
    min=0;
    tempi=1;
    tempj=1;
    for i=2:len
        if D2(1,i)==0
            if pointsel(1)==0||pointsel(i)==0
                min=D(1,i);
                tempj=i;
                break;
            end
        end
        
    end
    for i=1:len
        if pointsel(i)~=0
            for j=1:len
                if pointsel(j)==0&&D(i,j)<min;
                    min=D(i,j);
                    tempi=i;
                    tempj=j;
                end
            end
        end
    end
    D2(tempi,tempj)=1;
    D2(tempj,tempi)=1;
    if pathnum~=0
        pointsel(tempi)=pointsel(tempi)+1;
    end
    pointsel(tempj)=pointsel(tempj)+1;
    pathnum=pathnum+1;
end
for i=1:len
    while pointsel(i)>2
        k=i;
        for j=1:len
            if D2(i,j)==1&&D(i,j)>D(i,k)
                k=j;
            end
        end
        D2(i,k)=0;
        D2(k,i)=0;
        pointsel(i)=pointsel(i)-1;
        pointsel(k)=pointsel(k)-1;
        pathnum=pathnum-1;
    end
end
while pathnum<len-1
    min=0;
    tempi=1;
    tempj=1;
    for i=1:len
        if pointsel(i)<2
            for j=1:len
                if D2(i,j)==0&&i~=j&&pointsel(j)<2
                    if D(i,j)>min
                        min=D(i,j);
                        tempj=j;
                    end
                end
            end
            break;
        end
    end
    for i=1:len
        if pointsel(i)<2
            for j=1:len
                if pointsel(j)<2
                    if pointsel(j)==0||pointsel(i)==0
                        if D2(i,j)==0&&D(i,j)<min&&i~=j
                            min=D(i,j);
                            tempi=i;
                            tempj=j;
                        end
                    else
                        if D2(i,j)==0&&D(i,j)<min&&i~=j
                            tempinti=1;
                            tempintj=1;
                            for k=1:len
                                if D2(i,k)==1
                                    tempinti=i;
                                    tempintj=k;
                                    break;
                                end
                            end
                            while pointsel(tempintj)==2
                                for k=1:len
                                    if D2(tempintj,k)==1&&k~=tempinti
                                        tempinti=tempintj;
                                        tempintj=k;
                                        break;
                                    end
                                end
                            end
                            if tempintj~=j
                                min=D(i,j);
                                tempi=i;
                                tempj=j;
                            end
                        end
                    end
                end
            end
        end
    end
    D2(tempi,tempj)=1;
    D2(tempj,tempi)=1;
    if pathnum~=0
        pointsel(tempi)=pointsel(tempi)+1;
    end
    pointsel(tempj)=pointsel(tempj)+1;
    pathnum=pathnum+1;
end
tempii=1;
tempjj=1;
pathlength=0;
for i=1:len
    if pointsel(i)==1
        tempii=i;
        result=num2str(i);
        result=strcat(result,',');
        break;
    end
end
for i=1:len
    if D2(tempii,i)==1
        tempjj=i;
        pathlength=pathlength+D(tempii,tempjj);
        result=strcat(result,num2str(i));
        result=strcat(result,',');
        break;
    end
end
while pointsel(tempjj)==2
for k=1:len
    if D2(tempjj,k)==1&&k~=tempii
        tempii=tempjj;
        tempjj=k;
        pathlength=pathlength+D(tempii,tempjj);
        result=strcat(result,num2str(k));
        result=strcat(result,',');
    end
end
end

result1=[1 2 3 7 8 9 10 11];

result2=[3,4,5];
result3=[7,6];
for i_d=1:8
X1(i_d)=X(result1(i_d));
Y1(i_d)=Y(result1(i_d));
end
for i_d=1:3
X2(i_d)=X(result2(i_d));
Y2(i_d)=Y(result2(i_d));
end
for i_d=1:2
X3(i_d)=X(result3(i_d));
Y3(i_d)=Y(result3(i_d));
end
figure()

% % plot3(X1,Y1,Z1,'-');
grid on;
hold on
plot(X1,Y1,'o-r');
plot(X1,Y1,'o-r',X2,Y2,'o-r',X3,Y3,'o-r')%
axis equal;

for i_s=1:3
x2=[X1(i_s) X1(i_s+1)];
y2=[Y1(i_s) Y1(i_s+1)];
end
pathle=1.4302;
xlabel('x');
ylabel('y');
title( {'\fontsize{12} Path Planning Results Obtained by Original  algorithm  ',['Total Length： ', num2str(pathle,'%.4f'), 'km   ']} )
for i_i=1
x3=[X2(i_s) X2(i_s+1)];
y3=[Y2(i_s) Y2(i_s+1)];
end
hold on;
line(x2,y2,'linewidth',1,'color','r');
line(x3,y3,'linewidth',1,'color','r');

hold on 



