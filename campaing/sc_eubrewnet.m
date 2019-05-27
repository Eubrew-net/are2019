url='"http://rbcce.aemet.es/eubrewnet/data/get/SC?brewerid=163&date=2017-01-01&enddate=2017-07-07&format=text"';
[a,b]=system(['curl --user brewer:redbrewer ',url]);
if a==0
data_sc=textscan(b,'','headerlines',1,'delimiter',',TZa','commentstyle','matlab','TreatAsEmpty','None');
end
%try
%y1=reshape(cell2mat(data_sc)',24,15,2,[]); %measurements n_scan , scan up/scan dw, n sc
% error measurements
%catch
    x=cell2mat(data_sc);
    l=fix(size(x,1)/30)
    %y1=reshape(x(1:l*30,:)',24,15,2,[]);
    %ms9=ms5-0.5ms6-1.7ms7;
    ms9=x(:,20:22)*[1,-0.5,-1.7]';
    %ms8=ms4-3.2ms7;
    ms8=x(:,[19,22])*[1,-3.2]';
    % gscatter(x(:,2),ms9,x(:,1))
    x(:,3)=ms8;
    x(:,4)=ms9;
     a=fix(x(:,1)/10000);m=fix((x(:,1)-a*10000)/100);d=(x(:,1)-a*10000-m*100);
    x(:,5)=datenum(a,m,d)+x(:,8)/24/60; %date
    y1=reshape(x(1:l*30,:)',24,15,2,[]);
    
    ms91=squeeze(y1(4,:,1,:)); %scan up MS9
    ms92=squeeze(y1(4,:,2,:)); %scan dw
    ms92=ms92(end:-1:1,:); % scan are 
    fecha1=squeeze(y1(5,:,1,:));
    fecha2=squeeze(y1(5,end:-1:1,2,:)); %date of center =8
    
    % average
    %  ms9=(ms92+ms91)/2; % average 
    ms9x=[ms92-ms91];
%      [i,j]=find(abs(ms9x)>500); % too much difference up/down
     ms91(i,j)=NaN;
%      ms92(i,j)=NaN;
    ms9=[ms91,ms92];
    f=[fecha1(8,:),fecha2(8,:)];
    steps=-14:2:14;
    p=polyfic(steps,100*matdiv(matadd(ms9,-ms9(8,:)),ms9(8,:)),2);
    [m,s,c,d]=outliers_bp(p(2,:),2)
    
    
    % residuals
    y=100*matdiv(matadd(ms9,-ms9(8,:)),ms9(8,:));
    r=polyvac(q,steps);
    plot((matadd(ms9,-ms9(8,:))))
%end