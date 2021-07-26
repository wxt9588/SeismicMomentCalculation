%wxt
%2021/5/12

dataPath=['E:\文档\震源相\实际数据\measure Mw\all_bp250_2001_2016\','xiazai_',stationname,'_bp250_resp\'];%数据路径

% fid2=fopen('LFEs_Mw_stressdrop_radius.txt','w','ieee-le'); 

model;

%%%
d1=dir(dataPath);
ld1=size(d1);
if ld1(1)<3
    error('No data in the file')
end
[in,~]=size(d1);
for i=3:in
    n1(i-2,:)=d1(i).name;
end

for i=1:in-2
    
    name1=n1(i,:);
%     % 判断是否为parkfield地区的地震
%     posr=strfind(name1,'_');
%     Lat=str2double(name1(posr(2)+1:posr(3)-1));
%     Lon=str2double(name1(posr(3)+1:posr(4)-1));
%     if (Lat>lat_max||Lat<lat_min||Lon>lon_max||Lon<lon_min)
%         continue;
%     end
    
    fid1=fopen([dataPath,name1],'r','ieee-le'); 
    A=fread(fid1,[70,1],'float32');
    B=fread(fid1,[40,1],'int32');
    C=char(fread(fid1,[1,192],'char'));
    datar=fread(fid1,'float32');
    clear A;clear B;clear C;
    fclose(fid1);
    
    if max(datar)==0 %判断是否数据为0
        name1
    end
    
    
    [N,~]=size(datar);    
    posr=strfind(name1,'-');
    start_t=name1(posr(5)+1:posr(5)+5);
    Nt=str2double(start_t)/dt+1.0/dt; % S 波到时前1s
    Et=Nt+6.0/dt; % S 波持续2s
%     datad=datar(round(Nt):round(Et));
    if (Et<=N) %检测截取的部分是否超过数据最大长度
        datad=datar(round(Nt):round(Et));
    else 
        continue
    end
    
    yy(i)=str2double(name1(posr(1)-4:posr(1)-1));
    mm=str2double(name1(posr(1)+1:posr(2)-1));
    dd=str2double(name1(posr(2)+1:posr(3)-1));
    hh=str2double(name1(posr(3)+1:posr(4)-1));
    ss1=str2double(name1(posr(4)+1:posr(5)-1));
    ss2=str2double(name1(posr(5)+1:posr(6)-9));
    rtime=(((yy(i)-2000)*365+mm*30)+dd)*24+hh+ss1/60+ss2/3600;
    
    posr=strfind(name1,'_');
    Lat=str2double(name1(posr(2)+1:posr(3)-1));
    Lon=str2double(name1(posr(3)+1:posr(4)-1));
    Dep=str2double(name1(posr(4)+1:posr(5)-1))*1000.0;
    
    calrc;
    
    Q=trapz(datad)*dt*1d-9;
    Q1=4*pi*vs2^2*(rou1*vs1+rou2*vs2)/2.0/R/c*r;
    %Q2=r*fc*pi/ ((vs1+vs2)/2.0) /Qs;
    Q2= r*pi*fc/Qs/vs1;
    Q3=exp(Q2);
    M0=abs(Q1 * Q3* Q);
    Mw(j,i,1)=2/3 *log10(M0)-6.033;
    Mw(j,i,2)=rtime;
    Mw(j,i,3)=Lat;
    Mw(j,i,4)=Lon;
    Mw(j,i,5)=Dep;
    Mw(j,i,6)=yy(i);
    Mw(j,i,7)=mm;
    Mw(j,i,8)=dd;
    Mw(j,i,9)=hh;
    Mw(j,i,10)=ss1;
    Mw(j,i,11)=ss2;
%     sdrop(j,i,1)=(miu*slip)/(2*sqrt(M0/(miu*pi*slip)));
    sdrop(j,i,1)=(7.0/16.0)*M0/(sqrt(M0/(miu*pi*slip)))^3;
    sdrop(j,i,2)=rtime;
    sl(j,i,1)=sqrt(M0/(miu*pi*slip));
    sl(j,i,2)=rtime;
    radius(j,i,1)=sqrt(M0/(miu*pi*slip));
    radius(j,i,2)=rtime;
    
%     fprintf(fid2,'%s %6.4e %6.2f %6.4e %6.2f %6.2f \n',name1,M0,Mw(j,i,1),sdrop(j,i,1),radius(j,i,1),rtime);
end
% fclose(fid2)
fclose all;