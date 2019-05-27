%url='"http://rbcce.aemet.es/eubrewnet/data/get/SCP?brewerid=XXX&date=2015-01-03&enddate=2017-07-18&format=text"';
mean_slope=[]; mean_step=[];
std_slope=[];  std_step=[];
for ii=1:Cal.n_brw
    url='"http://rbcce.aemet.es/eubrewnet/data/get/SCP?brewerid=XXX&date=2017-01-03&enddate=2017-07-18&format=text"';
    url=strrep(url,'XXX',Cal.brw_str{ii})
    try
        [a,b]=system(['curl -s --user brewer:redbrewer ',url]);
        if a==0
            data_sc=textscan(b,'','headerlines',1,'delimiter',',TZa','commentstyle','matlab','TreatAsEmpty','None');
        else
            disp('error');
            disp(b)
        end
        %[["gmt", "filter", "nd_filter_position", "mmmm", "mmmm_gmt", "lower_slit",
        % "upper_slit", "cycles", "raw_counts_w0", "dark_count", "raw_counts_w1",
        %"raw_counts_w2", "raw_counts_w3", "raw_counts_w4", "raw_counts_w5",
        %"single_ratio1", "single_ratio2", "single_ratio3", "single_ratio4",
        %"temp", "hg_cor", "airmass", "step"]
        % hg_cor,hg_start_time,hg_end_time,
        %try
        %y1=reshape(cell2mat(data_sc)',24,15,2,[]); %measurements n_scan , scan up/scan dw, n sc
        % error measurements
        %catch
        x=cell2mat(data_sc);
        l=size(x,1)/30;
        if l==fix(size(x,1)/30)
            
            ms9=x(:,20:22)*[1,-0.5,-1.7]';
            ms8=x(:,[19,22])*[1,-3.2]';
            
            % gscatter(x(:,25),ms9,x(:,1))
            x(:,3)=ms8;
            x(:,4)=ms9;
            
            %datenum(cellstr(num2str(x(:,1))),'yyyymmdd')
            a=fix(x(:,1)/10000);m=fix((x(:,1)-a*10000)/100);
            d=(x(:,1)-a*10000-m*100);
            x(:,5)=datenum(a,m,d)+x(:,8)/24/60; %date
            
            y1=reshape(x(1:l*30,:)',32,15,2,[]);
            
            ms91=squeeze(y1(4,:,1,:)); %scan up MS9
            ms92=squeeze(y1(4,:,2,:)); %scan dw
            ms92=ms92(end:-1:1,:); % scan are
            fecha1=squeeze(y1(5,:,1,:));
            fecha2=squeeze(y1(5,end:-1:1,2,:)); %date of center =8
            
            % average
            %  ms9=(ms92+ms91)/2; % average
            ms9x=[ms92-ms91];
            [i,j]=find(abs(ms9x)>500); % too much difference up/down
            ms91(i,j)=NaN;
            ms92(i,j)=NaN;
            
            ms9=[ms91,ms92];
            f=[fecha1(8,:),fecha2(8,:)];
            steps=-14:2:14;
            %p=polyfic(steps,100*matdiv(matadd(ms9,-ms9(8,:)),ms9(8,:)),2);
            y=matadd(ms9,-ms9(8,:));
            figure
            confplot(steps,nanmean(y,2),nanstd(y,1,2),nanstd(y,1,2))
            grid
            title(['Ozone Ratio MS9 - MS9(calc step) ',Cal.brw_name{ii}])
            grid
            xlabel('step')
            ylabel('MS9 diff')
            title(['Ozone Ratio MS9 - MS9(calc step) ',Cal.brw_name{ii}]);%Cal.brw_name(17)])
            
            p=polyfic(steps,y,2);
            [mean_slope(ii),std_slope(ii),outliers,outliers_idex]=outliers_bp(p(2,:),2)
            [mean_step(ii),std_step(ii),outliers_p,outliers_p_index]=outliers_bp(p(3,:),2)
            se_step(ii)=std_step(ii)/sqrt(size(ms9,2));
            
            
            % porcentual
            yr=100*matdiv(matadd(ms9,-ms9(8,:)),ms9(8,:));
            figure;
            confplot(steps,nanmean(yr,2),2*nanstd(yr,1,2),2*nanstd(yr,1,2));
            hold on;
            plot(steps,yr,':')
            title(['Ozone Ratio : MS9 - MS9(calc step) /MS9(calc step)',Cal.brw_name{ii}])
            grid
            xlabel('step')
            ylabel(' % MS9 relative')
            title(['Ozone Ratio MS9 - MS9(calc step) ',Cal.brw_name{ii}])
            
            pr=polyfic(steps,y,2);
            [mean_p_slope(ii),std_p_slope(ii),outliers_p,outliers_p_index]=outliers_bp(pr(2,:),2)
            
            data_sc_huelva{ii}=y1;
            
        end
        catch
        disp(Cal.brw_name{ii})
        mean_slope(ii)=NaN;
        std_slope(ii)=NaN;
        mean_step(ii)=NaN;
        std_step(ii)=NaN;
    end
    
end

figure
confplot(1:21,mean_slope,std_slope)
set(gca,'Xtick',1:21,'XtickLabel',Cal.brw_str,'Xlim',[0 22])
grid
title(['Ozone Ratio:  MS9 slope  '])
xlabel('Brw #')
ylabel('MS9 step Slope ')
print -clipboard -dbitmap

figure
errorbar(1:21,mean_step,se_step)
set(gca,'Xtick',1:21,'XtickLabel',Cal.brw_str,'Xlim',[0 22])
grid
title(['Ozone Ratio:  MS9 - MS9(calc step) '])
xlabel('Brw #')
ylabel('Slope vs step')
print -clipboard -dbitmap

