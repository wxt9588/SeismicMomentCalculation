clear all;
clc
filestation=fopen('BP.txt');
fi=textscan(filestation,'%s');

%parkfield
lon_min=-121.25;
lon_max=-119.75;
lat_min=35.48;
lat_max=36.5;


sname(1,:)='FROB';
sname(2,:)='CCRB';
sname(3,:)='LCCB';
sname(4,:)='MMNB';
sname(5,:)='RMNB';
sname(5,:)='SCYB';
sname(6,:)='SMNB';
sname(7,:)='VCAB';
sname(8,:)='EADB';
sname(9,:)='JCNB';
sname(10,:)='JCSB';
sname(11,:)='VARB';

for j=1:length(sname(:,1)) 
    fi1=fi{1,1};
    c1=ismember(fi1,sname(j,:));
    for i=1:length(c1)
        if c1(i)
            zi=i;
        end
    end
    stationname=sname(j,:);
    lonr=str2double(fi1{zi+3,1});%台站位置
    latr=str2double(fi1{zi+2,1});%台站位置
    main_bp250;
end
%% 

M_all=Mw;
clear Mw
Mw=M_all(:,:,1:2);
% year=M_all(:,:,6); %年份
Iw=reshape(Mw,length(Mw)*length(sname(:,1)),2);
It=unique(Iw(:,2));
for j=2:length(It)
    intw=find(Iw(:,2)==It(j));
    for k=1:length(intw)
        mI(k)=Iw(intw(k),1);
    end
    M(j-1)=median(mI);
%     M(j-1,1)=median(mI);
%     M(j-1,2)=It(j);
    clear intw mI;
end
clear Iw Is

Iw=reshape(sdrop,length(sdrop)*length(sname(:,1)),2);
It=unique(Iw(:,2));
for j=2:length(It)
% for j=3034:3034
    intw=find(Iw(:,2)==It(j));
    for k=1:length(intw)
        mI(k)=Iw(intw(k),1);
    end
    stressdrop(j-1)=median(mI);
    clear intw mI;
end
clear Iw Is

Iw=reshape(sl,length(sl)*length(sname(:,1)),2);
It=unique(Iw(:,2));
for j=2:length(It)
    intw=find(Iw(:,2)==It(j));
    for k=1:length(intw)
        mI(k)=Iw(intw(k),1);
    end
    L(j-1)=median(mI);
    clear intw mI;
end
clear Iw Is

Iw=reshape(radius,length(radius)*length(sname(:,1)),2);
It=unique(Iw(:,2));
for j=2:length(It)
    intw=find(Iw(:,2)==It(j));
    for k=1:length(intw)
        mI(k)=Iw(intw(k),1);
    end
    rad(j-1)=median(mI);
    clear intw mI;
end
clear Iw Is

%保存到文件
% fid2=fopen('LFEs_Mw_stressdrop_radius.txt','w','ieee-le'); 
% fprintf(fid2,'%s %6.4e %6.2f %6.4e %6.2f %6.2f \n',name1,M0,Mw(j,i,1),sdrop(j,i,1),radius(j,i,1),rtime);
% fclose(fid2);

Iw=reshape(M_all,length(M_all)*length(sname(:,1)),11);
It=unique(Iw(:,2));
for j=2:length(It)
    intw=find(Iw(:,2)==It(j));
    for k=1:length(intw)
        mI(k)=Iw(intw(k),1);
    end
%     M_latlon(j-1,1)=median(mI);
    M_latlon(j-1,1)=median(mI);
    M_latlon(j-1,2)=Iw(intw(1),3);
    M_latlon(j-1,3)=Iw(intw(1),4);
    M_latlon(j-1,4)=Iw(intw(1),5);
    M_latlon(j-1,5)=Iw(intw(1),2);
    M_latlon(j-1,6)=Iw(intw(1),6);
    M_latlon(j-1,7)=Iw(intw(1),7);
    M_latlon(j-1,8)=Iw(intw(1),8);
    M_latlon(j-1,9)=Iw(intw(1),9);
    M_latlon(j-1,10)=Iw(intw(1),10);
    M_latlon(j-1,11)=Iw(intw(1),11);
%     yy(j-1)=Iw(intw(1),6); %将时间赋值给time
%     mm(j-1)=Iw(intw(1),7);
%     dd(j-1)=Iw(intw(1),8);
%     hh(j-1)=Iw(intw(1),9);
%     min(j-1)=Iw(intw(1),10);
%     sec(j-1)=Iw(intw(1),11);
    time(j-1,1)=Iw(intw(1),6); 
    time(j-1,2)=Iw(intw(1),7);
    time(j-1,3)=Iw(intw(1),8);
    time(j-1,4)=Iw(intw(1),9);
    time(j-1,5)=Iw(intw(1),10);
    time(j-1,6)=Iw(intw(1),11);
    clear intw mI;
end

%年月日变为时间序列
time(:,7)=datenum(time(:,1:6));



%% draw
% xrange=2601;
xrange=6660;
%xrange=3658;
stat_t=time(1,7)-40;
end_t=time(xrange,7)+40;

%Mw range
%去掉Mw中的离群数据点
% M1=filloutliers(M,'nearest','median');
figure 
x1=[stat_t,stat_t,end_t,end_t];
y2=[0.7022,2.003,2.003,0.7022];
fill_area=fill(x1',y2','red');
fill_area.FaceColor=[0.5 0.5 0.5];
fill_area.EdgeColor=[1 1 1];
fill_area.FaceAlpha=0.15;
hold on
plot(time(:,7),M,'o','Markersize',4,'MarkerEdgeColor',[0 0 0],'Markerfacecolor',[144 215 114]/255);
dateaxis('x',10);
ylim([0,2.8]);
xlim([stat_t end_t]);
xlabel('Year');
ylabel('Mw');
title('Mw range for LFEs');
aver_Mw=mean(M)
grid on
box on

%M0 range
for i=1:xrange
    M0(i)=10^((3.0/2.0)*(M(1,i)+6.033));
end

figure
h1=semilogy((0:0.01:1),(0:0.01:1)); %设置为对数坐标
delete(h1); 
hold on
x1=[stat_t,stat_t,end_t,end_t];
y2=[10^((3.0/2.0)*(0.7022+6.033)),10^((3.0/2.0)*(2.003+6.033)),10^((3.0/2.0)*(2.003+6.033)),10^((3.0/2.0)*(0.7022+6.033))];
fill_area=fill(x1',y2','red');
fill_area.FaceColor=[0.5 0.5 0.5];
fill_area.EdgeColor=[1 1 1];
fill_area.FaceAlpha=0.15;
hold on
plot(time(:,7),M0,'o','Markersize',4,'MarkerEdgeColor',[0 0 0],'Markerfacecolor',[144 215 114]/255);
dateaxis('x',10);
ylim([10^8.9,10^14]);
xlim([stat_t end_t]);
xlabel('Year');
ylabel('M_0');
title('M_0 range for LFEs');
aver_M0=mean(M0)
grid on
box on

%stress drop range
%去掉stress drop中的离群数据点
% stressdrop1=filloutliers(stressdrop,'nearest','median');
figure
h1=semilogy((0:0.01:1),(0:0.01:1));
delete(h1); 
hold on
x2=[stat_t,stat_t,end_t,end_t];
y2=[8733,8.373*1e4,8.373*1e4,8733];
fill_area=fill(x2',y2','red');
fill_area.FaceColor=[0.5 0.5 0.5];
fill_area.EdgeColor=[1 1 1];
fill_area.FaceAlpha=0.15;
hold on
plot(time(:,7),stressdrop,'o','Markersize',4,'MarkerEdgeColor',[0 0 0],'Markerfacecolor',[244 164 96]/255);
dateaxis('x',10);
xlim([stat_t end_t]);
ylim([1e3,2*1e6]);
xlabel('Year');
ylabel('Stress drop (Pa)');
title('Stress drop range for LFEs');
aver_stressdrop=mean(stressdrop)
grid on
box on



%radius range
figure
%去掉stress drop中的离群数据点
% rad1=filloutliers(rad,'nearest','median');
% x1=[0,0,332,332];
% y2=[0.6,2.14,2.14,0.6];
% fill_area=fill(x1',y2','red');
% fill_area.FaceColor=[0.5 0.5 0.5];
% fill_area.EdgeColor=[1 1 1];
% fill_area.FaceAlpha=0.15;
hold on
plot(time(:,7),rad,'o','Markersize',4,'MarkerEdgeColor',[0 0 0],'Markerfacecolor',[200 143 143]/255);
dateaxis('x',10);
xlim([stat_t end_t]);
ylim([0 500]);
xlabel('Year');
ylabel('Radius (m)');
title('Radius range for LFEs');
aver_rad=mean(rad)
grid on
box on

M_latlonall=[M_latlon,reshape(stressdrop,[xrange,1]),reshape(M0,[xrange,1]),reshape(rad,[xrange,1])];

