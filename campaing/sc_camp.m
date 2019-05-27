clear all;  
addpath(genpath('..\..\matlab'));
file_setup='arenos2019_setup.m';
run(fullfile('..',file_setup))%  configuracion por defecto
sunscan=load(fullfile('..',Cal.file_save),'sunscan')
%Cal.n_inst=find(Cal.brw==185);
%sunscan{Cal.n_inst}.cal_step=cal_step;
%sunscan{Cal.n_inst}.cal_step_error=cal_step_error;
%sunscan{Cal.n_inst}.sc_avg=sc_avg; sunscan{Cal.n_inst}.sc_raw=sc_raw;
%sunscan{Cal.n_inst}.info=Args;
%save(Cal.file_save,'-APPEND','sunscan');

%% missing
brw=Cal.brw(~cellfun(@isempty,sunscan.sunscan))
[a,index]=ismember(brw,Cal.brw)
cs=[]
    
res=NaN*ones(20,3);
for ii=index
    sc_raw{ii}=sunscan.sunscan{ii}.sc_raw;
    cal_step{ii}=sunscan.sunscan{ii}.cal_step;
    cs=[cs;[Cal.brw(ii),cal_step{ii}{1},cal_step{ii}{2}]];
    x=[sc_raw{ii}{1};sc_raw{ii}{2}];
    disp(Cal.brw_str(ii))
    %
    try
        %%
        y1=reshape(x(~isnan(x(:,4)),:)',23,15,2,[]); % columnas,scan, scan up/scan dow, n obs
        stp1=squeeze(y1(3,:,1,:)); %steps
        stp2=squeeze(y1(3,:,2,:));
        ms91=squeeze(y1(22,:,1,:)); %scan up MS9
        ms92=squeeze(y1(22,:,2,:)); %scan dw
        fecha=squeeze(y1(1,:,2,:));
        %up/dow
        figure
        h1=plot(matadd(stp2,-stp2(8,:)),matadd(ms92,-ms92(8,:)),'-');
        hold on
        h2=plot(matadd(stp1,-stp1(8,:)),matadd(ms91,-ms91(8,:)),':');
        xlabel('step')
        title([Cal.brw_name{ii}, ': Ozone Ratio MS9 - MS9(ref) '])
        ylabel('Log counts/sec')
        legend([h1(1),h2(1)],{'up scan','dw scan'})
        % average
        ms9=(ms92(end:-1:1,:)+ms91)/2; % average (steps are inverted)
        ms9x=[ms92(end:-1:1,:)-ms91];
        [i,j]=find(abs(ms9x)>500);
        ms9(i,j)=NaN;
        
        figure
        plot(matadd(stp1(:,:),-stp1(8,:)),100*matdiv(matadd(ms9(:,:),-ms9(8,:)),ms9(8,:)),'o')
        xlabel('step')
        title([Cal.brw_name{ii}, ': Ozone Ratio  MS9 % vs MS9(ref) '])
        ylabel('%')
        grid
        
        j=abs(matadd(stp1(:,1),-stp1(8,1)))<7;
        figure
        %plot(matadd(stp1(j,:),-stp1(8,:)),100*matdiv(matadd(ms9(j,:),-ms9(8,:)),ms9(8,:)),'o')
        %[r,p]=rline;
        %idx=p(3,:)>0.8
        %plot(matadd(stp1(j,:)),100*matdiv(matadd(ms9(j,:),-ms9(8,:)),ms9(8,:)),'o')
        plot(stp1(j,:),100*matdiv(matadd(ms9(j,:),-ms9(8,:)),ms9(8,:)),'o')
        [r,p]=rline;
        %idx=abs(p(2,:))<0.8
        % quadratic
        q=polyfic(stp1(:,1)-stp1(8,1),100*matdiv(matadd(ms9(:,:),-ms9(8,:)),ms9(8,:)),2);
        hold off
        %figure
        plot(p(1,:));
        hold on
        plot(q(2,:),'x');
        
        grid
        title([Cal.brw_name{ii},...
            sprintf(':  MS9(%%)/step m=%.2f 2*(sigma) %.3f',mean(p(1,:)),2*std(p(1,:)))]);
        res(ii,:)=[mean(p(1,:)),2*std(p(1,:)),2*nanstd(q(2,:))]
        
        %%
    catch
        disp(Cal.brw_str(ii))
        disp('ERROR')
        
    end
end

%%

%cal_step{cellfun(@isempty,cal_step)}=NaN*(ones(1,5))
figure
errorbar(1:length(index),cs(:,3)-cs(:,6),cs(:,4)-cs(:,3),cs(:,5)-cs(:,3),'o')
set(gca,'YLim',[-10,10]);
grid
set(gca,'Xtick',1:length(index),'XtickLabel',Cal.brw_str(index));
xtickangle(30)
hline([-2,0,2],'k-')
title('Sun Scan at Station ARE 2019')
ylabel('Cal-Step difference')
xlabel('Brw')
boldify

%%

array2table(cs(:,[1,3,4,5,6]),'VariableNames',str2var({'Brw','cal','ci1','ci2','original'}))


%%
% label={'Brw','Date','Calc_step','Calc_step_C1','Calc_step_C2','Calc_Step_set'};
% label2={'Date_c','Calc_step_c','Calc_step_C1_c','Calc_step_C2_c','Calc_Step_set_c'};
% lx=[label,label2];
% t_sc_=array2table(cs,'Variablenames',lx,'Rownames',Cal.brw_str)
%
%t_sc_after=array2table(cat(1,cal_step{:,2}),'Variablenames',{'Date','Calc_step','Calc_step_C1','Calc_step_C2','Calc_Step_set'},'Rownames',Cal.brw_str)



% media_fi={};
%    for i=1:Cal.n_brw
%        Cal.n_inst=i;
%        %[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
%        m=filter.filter{i};
%       if ~isempty(m)
%        media_fi{i}=m.media_fi;
%       else
%         media_fi{i}=NaN*ones(6,5);
%       end
%        snapnow();close all ;
%    end
%    %printfiles_append(f,gcf,'HG_2015_report');
%    WN=[302.1,306.3,310.1,313.5,316.8,320.1];
%    lamda=[3032.06 3063.01 3100.53 3135.07 3168.09 3199.98];
%    WN=[302.1,306.3,310.1,313.5,316.8,320.1];
%       for i=1:Cal.n_brw
%           nhead=repmat(Cal.brw(i),1,5);
%           dlmwrite('Filter_spectral_2017.csv',[nhead;media_fi{i}],'-append','delimiter',',','precision','%.8f')
%       end
