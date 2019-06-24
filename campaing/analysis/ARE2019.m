% options_pub.outputDir=fullfile(pwd,'html'); options_pub.showCode=false;
% close all; publish(fullfile(pwd,'ARE2019.m'),options_pub);

%% Brewer Evaluation
clear all;  
file_setup='arenos2019_setup.m';
run(fullfile('..','..',file_setup))%  configuracion por defecto

Cal.n_inst=find(Cal.brw==185);
orden=[Cal.n_inst,1:Cal.n_brw];
orden(Cal.n_inst+1)=[];
%orden(orden==13)=[];
disp(Cal.brw_str(orden)')
Cal.dir_figs=fullfile('.','figures');
%day0=147; dayend=157; Cal.Date.CALC_DAYS=day0:dayend;

Cal.file_save='report_are2017.mat';
save(Cal.file_save);

%% READ Brewer Summaries

 for i=1:Cal.n_brw
     dsum{i}={};    ozone_sum{i}={};  ozone_ds{i}={};
     config{i}={};    com{i}={};     ds{i}={};
     sl{i}={};     sl_cr{i}={};     hg{i}={};     bhg{i}={};
    missing{i}=[] ;logx{i}={};
    
    [ozone,log_,missing_]=read_bdata(i,Cal);
    
    dsum{i}=ozone.dsum;
    ozone_sum{i}=ozone.ozone_sum;
    config{i}=ozone.config;
    ozone_ds{i}=ozone.ozone_ds;
    ozone_raw{i}=ozone.raw;
    hg{i}=ozone.hg;
    bhg{i}=ozone.bhg;
    sl{i}=ozone.sl; %first calibration/ bfiles
    sl_cr{i}=ozone.sl_cr; %recalculated with 2? configuration
    logx{i}=cat(1,log_{:});
    missing{i}=missing_';

    
 end
 save(Cal.file_save);
logx{:}
 
%% Configs: Initial
% fprintf('\nArenosillo 2017, Initial Config.\n');
% displaytable(cfg_ini(:,2:end)',Cal.brw_name,9,'.5g',events_cfg_ini.legend(2:end));
% t_config_ini=array2table(cfg_ini(:,2:end)','VariableNames',str2var(Cal.brw_name),...
%              'RowNames',events_cfg_ini.legend(:,2:end)); 

cfg_ini=NaN*ones(Cal.n_brw,21);
for i=orden
    ORG_config =Cal.brw_config_files{i,2};
    try
       events_cfg_ini=getcfgs(datenum(Cal.Date.cal_year,1,Cal.calibration_days{i,3}),ORG_config);  
       cfg_ini(i,:)=events_cfg_ini.data(:,end)';             
    catch exception
       fprintf('%s, brewer: %s\n',exception.message,Cal.brw_str{i});
    end
end
fprintf('\nArenosillo 2017, Initial Config.\n');
%displaytable(cfg_ini(:,2:end)',Cal.brw_name,9,'.5g',events_cfg_ini.legend(2:end));
t_config_ini=array2table(cfg_ini(:,2:end)','VariableNames',str2var(Cal.brw_name),...
             'RowNames',events_cfg_ini.legend(:,2:end))


%% Configs: Final
cfg_fin=NaN*ones(Cal.n_brw,21);
for i=orden
    ALT_config =Cal.brw_config_files{i,2};
    try
       events_cfg_fin=getcfgs(datenum(Cal.Date.cal_year,1,Cal.calibration_days{i,3}),ALT_config);  
       cfg_fin(i,:)=events_cfg_fin.data(:,end)';             
    catch exception
       fprintf('%s, brewer: %s\n',exception.message,Cal.brw_str{i});
    end
end
fprintf('\nArenosillo 2017, Final Config.\n');
display_table(cfg_fin(:,2:end)',Cal.brw_name,9,'.5g',events_cfg_fin.legend(2:end));
t_config_fin=array2table(cfg_fin(:,2:end)','VariableNames',str2var(Cal.brw_name),...
             'RowNames',events_cfg_ini.legend(:,2:end))

%% SL Report
sl_sum_new=[]; sl_sum_old=[]; 
for ii=1:Cal.n_brw
       slf{ii}={}; sl_s{ii}={}; sl_out{ii}={}; R6_{ii}={};

      [slf{ii},sl_s{ii},sl_out{ii},R6_{ii}]=sl_report_jday(ii,sl,Cal.brw_str,...
                               'date_range',datenum(Cal.Date.cal_year,1,1),...
                               'outlier_flag',0,'fplot',0);
      [slf_n{ii},sl_s_n{ii},sl_out_n{ii},R6_n{ii}]=sl_report_jday(ii,sl_cr,Cal.brw_str,...
                               'date_range',datenum(Cal.Date.cal_year,1,1),...
                               'outlier_flag',0,'fplot',0);
                 
      sl_sum_old=scan_join(sl_sum_old,[fix(sl_s{ii}(:,1)),sl_s{ii}(:,2)]);
      sl_sum_new=scan_join(sl_sum_new,[fix(sl_s_n{ii}(:,1)),sl_s_n{ii}(:,2)]);                                 
end

%% reevaluation 
close all
[A,ETC,SL_B,SL_R,F_corr,SL_corr_flag,cfg]=read_cal_config_new(config,Cal,{sl_s,sl_s_n});

for i=1:Cal.n_brw
      cal{i}={}; summary{i}={}; summary_old{i}={};
     [cal{i},summary{i},summary_old{i}]=test_recalculation(Cal,i,ozone_ds,A,SL_R,SL_B,'flag_sl',1);
end
summary_orig=summary; summary_orig_old=summary_old;

save(Cal.file_save,'-append','A','ETC','SL_B','SL_R','F_corr','SL_corr_flag','cfg','summary_orig','summary_orig_old','summary','summary_old')




%%
blind_calibration_days


%% Blinddays
close all


%%
sl_old_idx=zeros(size(sl_sum_old,1),size(sl_sum_old,2));
for ii=1:Cal.n_brw
    %if ii==3
    %    Cal.calibration_days{ii,2}=195:198;
    %end
    [t,l]=ismember(diaj(sl_sum_old(:,1)),Cal.calibration_days{ii,2});
%     sl_old_idx(l(l~=0),ii+1)=1;
    sl_old_idx(t,ii+1)=1;
end
sl_old=sl_sum_old; sl_old(sl_old_idx==0)=NaN; sl_old(:,1)=sl_sum_old(:,1);

%

table_blind_sl=array2table([Cal.brw',Cal.SL_OLD_REF,nanmean(sl_old(:,2:end))',Cal.SL_OLD_REF-nanmean(sl_old(:,2:end))'],...
'VariableNames',{'brw','SL_OLD_REF','meanSL','Diff'})

%%


figure; set(gcf,'Tag','SL_blind')
subplot(5,1,1:2)
h=boxplot(matadd(sl_old(:,2:end),-Cal.SL_OLD_REF'),'labels',Cal.brw_str); 
set(gca,'YLim',[-100 100]); set(findobj(gca,'Type','text'),'FontSize',11); 
set(h,'LineWidth',2);  
grid; box on; hline([-10 10],'-r');
ylabel('R6 units','FontSize',11); title({Cal.campaign,' SL - SL ref (Original constants)'},'FontSize',11);

subplot(5,1,3:5)
patch([min(diaj(sl_old(:,1)))-1 max(diaj(sl_old(:,1)))+1 max(diaj(sl_old(:,1)))+1 min(diaj(sl_old(:,1)))-1],...
     [repmat( -10,1,2) repmat( 10,1,2)], ...
     [.953,.953,.953],'LineStyle',':'); hold on;
h=ploty([diaj(sl_old(:,1)),matadd(sl_old(:,2:end),-Cal.SL_OLD_REF')]); set(h,'LineWidth',2);  
set(gca,'XLim',[min(diaj(sl_old(:,1)))-1.02,max(diaj(sl_old(:,1)))+1.02],'FontSize',12,'YLim',[-150 125]); grid; box on
%set(h([1 5 6]),'LineWidth',3);
legendflex(h,Cal.brw_name,'fontsize',7,'xscale',0.5,'anchor',[3 3],'buffer',[53 20]);
% lg=legend(h,Cal.brw_name,'Location','SouthEast'); set(lg,'FontSize',7);interactivelegend(h); 
ylabel('R6 [log_{10}(cnts/s)*10^4]'); xlabel('Day of year'); 
% title({Cal.campaign,' SL - SL ref (Blind days)'});

%%
printfiles_report(findobj('Tag','SL_blind'),Cal.dir_figs,'Width',15,'Height',12,'Format','jpeg');
close all

%% Finaldays
close all
sl_new_idx=zeros(size(sl_sum_new,1),size(sl_sum_new,2));
% La l?nea que sigue es debida al foll?n que hay con la calibraci?n: en la matriz 
% (que es la que aparece en el setup, se usan nuevos TC's, pero se mantienen los 
% originales en la calibraci?n final, icf20014.156)
sl_sum_new(:,5)=sl_sum_old(:,5);
for ii=1:Cal.n_brw
    [t,l]=ismember(diaj(sl_sum_new(:,1)),Cal.calibration_days{ii,3});
    sl_new_idx(t,ii+1)=1;
end
sl_new=sl_sum_new; sl_new(sl_new_idx==0)=NaN; sl_new(:,1)=sl_sum_new(:,1);

table_final_sl=array2table([Cal.brw',Cal.SL_NEW_REF,nanmean(sl_new(:,2:end))',Cal.SL_NEW_REF-nanmean(sl_new(:,2:end))'],...
'VariableNames',{'brw','SL_NEW_REF','meanSL','Diff'})

figure;  set(gcf,'Tag','SL_final');
% figure; set(gcf,'Tag','SLDiff_final')
subplot(5,1,1:2)
h=boxplot(matadd(sl_new(:,2:end),-Cal.SL_NEW_REF'),'labels',Cal.brw_str);
set(gca,'YLim',[-10 20]); set(findobj(gca,'Type','text'),'FontSize',11); set(h,'LineWidth',2);  
grid; box on; hline([-5 5],'-r');
ylabel('R6 units','FontSize',11); title({Cal.campaign,' SL - SL ref (Final constants)'},'FontSize',11);

subplot(5,1,3:5)
patch([min(diaj(sl_new(:,1)))-1 max(diaj(sl_new(:,1)))+1 max(diaj(sl_new(:,1)))+1 min(diaj(sl_new(:,1)))-1],...
     [repmat( -5,1,2) repmat( 5,1,2)], ...
     [.973,.973,.973],'LineStyle',':'); hold on;
h=ploty([diaj(sl_new(:,1)),matadd(sl_new(:,2:end),-Cal.SL_NEW_REF')]); set(h,'LineWidth',2);   
set(gca,'XLim',[min(diaj(sl_new(:,1)))-1.02,max(diaj(sl_new(:,1)))+1.02],'FontSize',11); grid; box on
legendflex(h,Cal.brw_name,'fontsize',7,'xscale',0.5,'anchor',[3 3],'buffer',[53 20]);
ylabel('R6 [log_{10}(cnts/s)*10^4]'); xlabel('Day of year'); 

%%
printfiles_report(findobj('Tag','SL_final'),Cal.dir_figs,'Width',15,'Height',12,'Format','png');
% printfiles_report(findobj('Tag','SLDiff_final'),Cal.dir_figs,'Width',13,'Height',5);
close all

%%
close all
[A,ETC,SL_B,SL_R,F_corr,SL_corr_flag,cfg]=read_cal_config_new(config,Cal,{sl_s,sl_s_n});

for i=1:Cal.n_brw
      cal{i}={}; summary{i}={}; summary_old{i}={};
     [cal{i},summary{i},summary_old{i}]=test_recalculation(Cal,i,ozone_ds,A,SL_R,SL_B,'flag_sl',1);
end

save(Cal.file_save,'-append','A','ETC','SL_B','SL_R','F_corr','SL_corr_flag','cfg')

% id_out=find(diajul(summary{Cal.brw==66}(:,1))>201.39 & diajul(summary{Cal.brw==66}(:,1))<201.41);
% disp(unique(diaj(summary{Cal.brw==66}(id_out,1))));
% summary{Cal.brw==66}(id_out,:)=[]; summary_old{Cal.brw==66}(id_out,:)=[];
% 
% id_out=find(diajul(summary{Cal.brw==66}(:,1))>208.41 & diajul(summary{Cal.brw==66}(:,1))<208.46);
% disp(unique(diaj(summary{Cal.brw==66}(id_out,1))));
% summary{Cal.brw==66}(id_out,:)=[]; summary_old{Cal.brw==66}(id_out,:)=[]; 

summary_orig=summary; summary_orig_old=summary_old;
save(Cal.file_save);

%% Oveview of campaign
close all
figure; p(1)=plot(summary{2}(diaj(summary{2}(:,1))>day0,1),summary{2}(diaj(summary{2}(:,1))>day0,6),'xk','MarkerSize',5); hold on
        p(2)=plot(summary{17}(diaj(summary{17}(:,1))>day0,1),summary{17}(diaj(summary{17}(:,1))>day0,6),'or','MarkerSize',5); 
        p(3)=plot(summary{16}(diaj(summary{16}(:,1))>day0,1),summary{16}(diaj(summary{16}(:,1))>day0,6),'sg','MarkerSize',5);
set(gca,'YLim',[300 360],'XLim',datenum(Cal.Date.cal_year,1,[day0 dayend])); 

title(Cal.campaign,'FontSize',12); ylabel('Total Ozone Content [DU]','FontSize',12); 
datetick('x',6,'KeepLimits','KeepTicks');
grid; legendflex(p,Cal.brw_name([2 17 16]),'anchor',{'se','se'},'buffer',[-5 5],...
                                         'nrow',1,'fontsize',8,'xscale',.5);

%%
printfiles_report(gcf,Cal.dir_figs,'aux_pattern',{'overview'},'Width',13,'Height',6.5,'Format','png');

%% All days: General view of the campaign
close all
ref=[]; ref_std=[]; ref_sl=[]; ref_sza=[]; ref_flt=[];ref_ms9=[];
ref_time=[];  ratio_=[];ref_airm=[];ref_temp=[];ref_ms9u=[]; ref_nosl=[];
for ii=1:length(orden)
     summ=[];
     caldays=Cal.calibration_days{ii,1}; % blind days

     % filter corr    
     [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,orden(ii),A,Cal.ETC_C{orden(ii)});
     summ=summary_corr(diaj(summary_corr(:,1))>day0,:);  

               
     % redondeamos la medida cada Tsync minutos
     med=[]; TSYNC=5;  
     time=([round(summ(:,1)*24*60/TSYNC)/24/60*TSYNC,summ(:,1)]); 
     ref_time=time; media=summ;

     med=[ref_time(:,1) media(:,6)];  meds=[ref_time(:,1) media(:,7)];

%      
%      % filter corr    
%      [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,orden(ii),A,Cal.ETC_C{orden(ii)});
%      jday=findm(diaj(summary_old_corr(:,1)),caldays,0.5);
%      summ=summary_old_corr(jday,:);
%                
%      % redondeamos la medida cada Tsync minutos
%      med=[]; TSYNC=10;  
%      time=([round(summ(:,1)*24*60/TSYNC)/24/60*TSYNC,summ(:,1)]);      
%      [ref_time,iii,jj]=unique(time(:,1));
%      [media,sigma,ndat]=grpstats(summ,jj);      


%      med=media(:,[1 6]);  meds=media(:,[1 7]);
     med_ms9= [med(:,1) media(:,8)];  med_ms9u=[med(:,1) media(:,9)];
     med_sza= [med(:,1) media(:,2)];  med_flt=       [med(:,1) media(:,5)/64];
     med_airm=[med(:,1) media(:,3)];  med_temp=      [med(:,1) media(:,4)];     
     
     %ref_time=scan_join(ref_time,time); 
     ref=scan_join(ref,med);                 ref_std=scan_join(ref_std,meds);
     ref_ms9=scan_join(ref_ms9,med_ms9);     ref_ms9u=scan_join(ref_ms9u,med_ms9u);
     ref_sza=scan_join(ref_sza,med_sza);     ref_flt=scan_join(ref_flt,med_flt);
     ref_airm=scan_join(ref_airm,med_airm);  ref_temp=scan_join(ref_temp,med_temp);
end

%%
% Numero total de medidas simult?neas
n_sim=sum(~isnan(ref)); stacked(1,:)=sum(~isnan(ref(diaj(ref(:,1))>day0,:)));
figure; set(gcf,'Tag','Nmeasurements');
h=bar(1:length(orden),n_sim(2:end));
set(gca,'XTick',1:length(orden),'XTicklabel',Cal.brw_str(orden),'xlim',[0 Cal.n_brw+1],'FontSize',8); grid;
th=rotateticklabel(gca,-90); set(th,'FontSize',8);
ylabel('Ocurrences','FontSize',10);% xlabel('Brewer serial No.'); 
title(sprintf('Near-simultaneous measurements\r\n (within 10 minutes)'),'FontSize',10);

%% Temperature 
figure;  set(gcf,'Tag','Temperature');
boxplot(ref_temp(:,2:end),'labels',Cal.brw_str(orden)) 
title('Temperature'); xlabel('Brewer serial No.'); ylabel('Temperature');
% Temperature vs Time 
figure; set(gcf,'Tag','Temperature_vs_day');
[td,stemp]=grpstats(ref_temp(:,2:end),diaj(ref_temp(:,1)),{'mean','std'});
h=errorbar(repmat(unique(diaj(ref_temp(:,1))),1,length(orden)), td, stemp); grid 
set(gca,'XLim',[day0 dayend],'YLim',[10 50],'XTick',day0:dayend,'XTicklabel',day0:dayend,'FontSize',8); set(h,'LineWidth',1);  
legendflex(gca,Cal.brw_str(orden),'nrow',2,'FontSize',7,'xscale',.5,'anchor',{'ne','ne'},'buffer',[-5 -5]);
xlabel('Day','FontSize',10);  ylabel('Temperature [{\circ}C]','FontSize',10);
title('Internal temperature','FontSize',10);

%% osc range
figure; set(gcf,'Tag','OSC_Hist'); 
h1=matmul(ref(:,2),ref_airm(:,2:end));
hist(h1); set(gca,'XLim',[300 2300],'FontSize',8); set(gca,'XLim',[300 1900]); grid
legendflex(gca,Cal.brw_str(orden),'nrow',4,'fontsize',8,'xscale',.3,'title','Serial No.');
title('OSC measurements by instrument','FontSize',10);
xlabel('Ozone Slant Column (DU)','FontSize',10); ylabel('Ocurrences','FontSize',10);

%%
  printfiles_report(findobj('Tag','Nmeasurements'),Cal.dir_figs,'Width',8,'Height',6,'Format','tiff');

  printfiles_report(findobj('Tag','Temperature_vs_day'),Cal.dir_figs,'Width',14,'Height',6.5,'Format','png');

  printfiles_report(findobj('Tag','OSC_Hist'),Cal.dir_figs,'Width',7.5,'Height',6,'Format','png');
  
  close all

%% process of all data with the original configuration
 blind_calibration_days
 stacked(2,:)=sum(~isnan(ref(diaj(ref(:,1))>day0,:)));

%%
ix=sort(findobj('Type','figure'));
printfiles_report(ix',Cal.dir_figs); 

close all

%% Table Statistics (blind)
osc=ref_airm(:,2).*ref(:,2);
dref=sortrows([osc,ref]);
dref_sl=sortrows([osc,ref_sl]);
rpsl=100*matdiv(matadd(dref_sl(:,3:end),-dref(:,3)),dref(:,3));
rp=100*matdiv(matadd(dref(:,3:end),-dref(:,3)),dref(:,3)); 

fprintf('\r\nRatios as: %s\r\nBlind Days\r\n',cell2mat(cellfun(@(x) strcat(x,','),Cal.brw_name(orden),'UniformOutput',0)));
indx=dref(:,1)<=900;

for id=1:length(orden)
%     if Cal.brwM(id)==3
%        % No SL
%        blind_NoSL(id)=nanmean(rp(:,id),1); blind_NoSL_std(id)=nanstd(rp(:,id),1);
%        % SL
%        blind_SL(id)=nanmean(rpsl(:,id),1); blind_SL_std(id)=nanstd(rpsl(:,id),1);
%     else
       % No SL
       blind_NoSL(id)=nanmean(rp(indx,id),1); 
       blind_NoSL_std(id)=nanstd(rp(indx,id),1);
       % SL
       blind_SL(id)=nanmean(rpsl(indx,id),1);
       blind_SL_std(id)=nanstd(rpsl(indx,id),1);
%     end
end
% The best from both
blind_best=[]; blind_best_std=[];
%Cal.sl_c_blind= [0  ,1  ,1  ,1  ,0  ,0  ,0  ,1  ,0  ,0  ,1  ,1  ,0  ,1  ,1  ,0  ,0  ,0  ,1  ,1  ,0  ];
for j=1:length(orden)
    if Cal.sl_c_blind(orden(j))
       blind_best(:,j)=blind_SL(j); 
       blind_best_std(:,j)=blind_SL_std(j);
    else
       blind_best(:,j)=blind_NoSL(j); 
       blind_best_std(:,j)=blind_NoSL_std(j);       
    end
end
tablblind_are2017=cat(2,Cal.brw(orden)',repmat(datenum(Cal.Date.cal_year,1,median(Cal.Date.CALC_DAYS)),length(orden),1),blind_NoSL',blind_SL',blind_best');
tablblind_are2017_std=cat(2,Cal.brw(orden)',repmat(datenum(Cal.Date.cal_year,1,median(Cal.Date.CALC_DAYS)),length(orden),1),blind_NoSL_std',blind_SL_std',blind_best_std');

displaytable(cellfun(@(x,y) strcat(num2str(x,'%.1f'),'+/- ',num2str(y,'%.2f')),...
             num2cell(tablblind_are2017(:,3:end)),num2cell(tablblind_are2017_std(:,3:end)),'UniformOutput',0),...
             {'No SL corr.','SL corr.','The best'},12,'.2f',Cal.brw_name(orden));
save('tabl_are2017','tablblind_are2017','tablblind_are2017_std');

%%
plot_brewer_report

%%
 printfiles_report(findobj('Tag','deviations'),Cal.dir_figs,'aux_pattern',{'blind'},'Width',13,'Height',6,'LineWidth',2);
 printfiles_report(findobj('-regexp','Tag','ratio*\w+'),Cal.dir_figs,'aux_pattern',{'blind'},'Width',20,'Height',15,'LineWidth',2);
 
%  ix=sort(findobj('-regexp','Tag','ratio*\w+'));
%  ix=double(ix);
%  for ff=ix(1):ix(end)
% %      printfiles_report(ff',Cal.dir_figs,'aux_pattern',{'blind'},'Width',13,'Height',5);
%      printfiles_report(ff,Cal.dir_figs,'aux_pattern',{'blind'},'Width',9,'Height',7,'Format','png');
%  end 
%  close all

%% process final days
 final_calibration_days
 stacked(3,:)=sum(~isnan(ref(ref(:,1)>datenum(2014,1,195),:)));
  
%%
ix=sort(findobj('Type','figure'));
printfiles_report(ix',Cal.dir_figs); 

close all
%%
plot_brewer_report
 %%
%  figure; set(gcf,'Tag','Sync_bar');
%  ba=bar(stacked(2:end,2:end)',.91,'BarWidth',.8);
%  set(gca,'FontSize',9,'XTickLabel',Cal.brw_name(orden)); r=rotateticklabel(gca,25); 
%  set(r,'FontSize',8); grid on 
%  lg=legend('Blind Days','Final Days','Location','NorthEast'); set(lg,'FontSize',7);
%  title('Sync. Measurements (within 10 min.)'); ylabel('Ocurrences'); 
%  printfiles_report(gcf,Cal.dir_figs,'Width',7,'Height',6,'Format','png');
%%
 close all
 
%% Table Statistics (final)
osc=ref_airm(:,2).*ref(:,2);
dref=sortrows([osc,ref]); dref_sl=sortrows([osc,ref_sl]);
rpsl=100*matdiv(matadd(dref_sl(:,3:end),-dref(:,3)),dref(:,3));
rp=100*matdiv(matadd(dref(:,3:end),-dref(:,3)),dref(:,3));

fprintf('\r\nRatios as: %s\r\nFinal Days\r\n',cell2mat(cellfun(@(x) strcat(x,','),Cal.brw_name(orden),'UniformOutput',0)));
indx=dref(:,1)<=1800;
for id=1:length(orden)
%     if Cal.brwM(id)==3
%        % No SL
%        final_NoSL(id)=nanmean(rp(:,id),1); final_NoSL_std(id)=nanstd(rp(:,id),1);
%        % SL
%        final_SL(id)=nanmean(rpsl(:,id),1); final_SL_std(id)=nanstd(rpsl(:,id),1);
%     else
       % No SL
       final_NoSL(id)=nanmean(rp(indx,id),1); final_NoSL_std(id)=nanstd(rp(indx,id),1);
       % SL
       final_SL(id)=nanmean(rpsl(indx,id),1); final_SL_std(id)=nanstd(rpsl(indx,id),1);
%     end
end
% The best from both
final_best=[]; final_best_std=[];
for j=1:length(orden)
    if Cal.sl_c(orden(j))
       final_best(:,j)=final_SL(j); final_best_std(:,j)=final_SL_std(j);
    else
       final_best(:,j)=final_NoSL(j); final_best_std(:,j)=final_NoSL_std(j);       
    end
end
tablfinal_aro2014=cat(2,Cal.brw(orden)',repmat(datenum(Cal.Date.cal_year,1,median(Cal.Date.CALC_DAYS)),length(orden),1),final_NoSL',final_SL',final_best');
tablfinal_aro2014_std=cat(2,Cal.brw(orden)',repmat(datenum(Cal.Date.cal_year,1,median(Cal.Date.CALC_DAYS)),length(orden),1),final_NoSL_std',final_SL_std',final_best_std');

display_table(cellfun(@(x,y) strcat(num2str(x,'%.1f'),'+/- ',num2str(y,'%.2f')),...
             num2cell(tablfinal_aro2014(:,3:end)),num2cell(tablfinal_aro2014_std(:,3:end)),'UniformOutput',0),...
             {'No SL corr.','SL corr.','The best'},12,'.2f',Cal.brw_name(orden))
save('tabl_are2017','-APPEND','tablfinal_aro2014','tablfinal_aro2014_std');

%%
plot_brewer_report

%%
 printfiles_report(findobj('Tag','deviations'),Cal.dir_figs,'aux_pattern',{'final'},'Width',13,'Height',6,'LineWidth',2);
 printfiles_report(findobj('-regexp','Tag','ratio*\w+'),Cal.dir_figs,'aux_pattern',{'final'},'Width',20,'Height',15,'LineWidth',2);

%  ix=sort(findobj('-regexp','Tag','ratio*\w+'));
% ix=double(ix)
%  for ff=ix(1):ix(end)
% %      printfiles_report(ff,Cal.dir_figs,'aux_pattern',{'final'},'Width',13,'Height',5);
%      printfiles_report(ff,Cal.dir_figs,'aux_pattern',{'final'},'Width',9,'Height',7,'Format','png');
%  end 
%  close all

%%
% rel_diffs=100*matdiv(matadd(aux_fin(:,4:12),-aux_fin(:,4)),aux_fin(:,4));
rel_diffs_sl=100*matdiv(matadd(ref_sl(:,2:end),-ref(:,2)),ref(:,2));
rel_diffs_nosl=100*matdiv(matadd(ref(:,2:end),-ref(:,2)),ref(:,2));

%% Boxplots
% [mean_o3 std_o3]=grpstats([ref(:,1),aux(:,[3 4:12])],fix(aux(:,1)),{'nanmean','nanstd'});
%     x=orden
%     f=figure;  set(f,'Tag','final_comp_all');
%     p=patch([.5 8.5 8.5 .5],[-1 -1 1 1],[.93 .93 .93]);
%     h1=boxplotCsub(rel_diffs_nosl(:,2:end),1,'o',1,1,'r',true,1,true,[1 1],1.5,0.005,false);
%     h2=boxplotCsub(rel_diffs_sl(:,2:end),1,'*',1,1,'g',true,1,true,[1 1],1.25,0.05,false);
%     set(gca,'YLim',[-4 4],'XTickLabel',Cal.brw_str(x(2:end)));
%     ylabel('Ozone Relative Difference (%)'); xlabel('Brewer serial No.');  hline(0,'-.k');  grid;
%     title(sprintf('Relative differences (%%) to %s\r\n %s. Final days', Cal.brw_name(Cal.n_ref), Cal.campaign));
%     legend([h1(end,1),h2(end,1)],{'No SL corrected','SL corrected'},'Location','NorthEast','Orientation','Horizontal');   

%%
Width=14; Height=7.5;
printfiles_report(gcf,Cal.dir_figs,'Width',Width,'Height',Height,'FontMode','fixed','FontSize',8);
% printfiles_report(gcf,Cal.dir_figs,'Format','tiff','Width',Width,'Height',Height,'FontMode','fixed','FontSize',8);
%close all

%% Lo mejor de cada periodo
% % final:
% ref_final=[]; ref_std_final=[]; ref_time=[]; ref_airm_final=[];
% 
% for ii=orden
%     % Now we applied filters corr.
%      [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,ii,A,Cal.ETC_C{ii});
%      summ=summary_corr;
%          
%      finaldays=Cal.calibration_days{ii,3}; % blind days
%       
%      jday=findm(diaj(summ(:,1)),finaldays,0.5);
%      summ=summ(jday,:);
%      
%     %redondeamos la medida cada 15 minutos
%      TSYNC=15;
%      time=([round(summ(:,1)*24*60/TSYNC)/24/60*TSYNC,summ(:,1)]); 
%      [ref_time,iii,jj]=unique(time(:,1));
%      [media,sigma,ndat]=grpstats(summ,jj);      
%      
%      med=media(:,[1 6]); %
%      meds=media(:,[1 7]); % std
%      med_airm=media(:,[1,3]);
%      
%      med(:,1)= ref_time(:,1); 
%      meds(:,1)=med(:,1);
%      med_airm(:,1)=med(:,1);    
%      
%      %ref_time=scan_join(ref_time,time); 
%      ref_final=scan_join(ref_final,med);
%      ref_std_final=scan_join(ref_std_final,meds);
%      ref_airm_final=scan_join(ref_airm_final,med_airm);
% end 
% 
% 
% % initial: 
% ref_blind=[]; ref_std_blind=[]; ref_time=[]; ref_airm_blind=[];
% 
% for ii=orden
%     % we removed filter#4 for initial status on brewer#066. 
%     % Otherwise we do not applied any F corrs. for initial status evaluation
%     % Except for reference instrument!!    
%     if Cal.brw(ii)==185
%        [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,ii,A,Cal.ETC_C{ii});
%        summ_old=summary_old_corr;  
%     else
%        [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,ii,A,[0,0,0,0,0,0]);
%        summ_old=summary_old_corr;  
%     end
%          
%      blinddays=Cal.calibration_days{ii,2}; % blind days
%       
%      jday=findm(diaj(summ_old(:,1)),blinddays,0.5);
%      summ_old=summ_old(jday,:);
%      
%     %redondeamos la medida cada 10 minutos
%      TSYNC=15;
%      time=([round(summ_old(:,1)*24*60/TSYNC)/24/60*TSYNC,summ_old(:,1)]); 
%      [ref_time,iii,jj]=unique(time(:,1));
%      [media,sigma,ndat]=grpstats(summ_old,jj);      
%      
%      % El mejor (sin / con SL corr.) 
%      if Cal.sl_c_blind(ii)
%         med=media(:,[1 12]);  meds=media(:,[1 13]); 
%      else
%         med=media(:,[1 12]);  meds=media(:,[1 13]); 
%      end
%      med_airm=media(:,[1,3]);
%      
%      med(:,1)= ref_time(:,1); 
%      meds(:,1)=med(:,1);
%      med_airm(:,1)=med(:,1);    
%      
%      %ref_time=scan_join(ref_time,time); 
%      ref_blind=scan_join(ref_blind,med);
%      ref_std_blind=scan_join(ref_std_blind,meds);
%      ref_airm_blind=scan_join(ref_airm_blind,med_airm);
% end 
% 
% %%
% close all
% osc=ref_airm_blind(:,2).*ref_blind(:,2);
% dref=sortrows([osc,ref_blind]);
% osc=ref_airm_blind(:,2).*ref_blind(:,2);
% rp=100*matdiv(matadd(dref(:,3:end),-dref(:,3)),dref(:,3));
% %osc_lim=2000;
% %jo=(osc<osc_lim) ;
% 
% % boxplot osc< .9
% figure; set(gcf,'Tag','deviations');
% h=errorbar(1:7,nanmean(rp(:,3:end)),nanstd(rp(:,3:end)),'bo','linewidth',3);
% hold on;
% 
% osc=ref_airm_final(:,2).*ref_final(:,2);
% dref=sortrows([osc,ref_final]);
% osc=ref_airm_final(:,2).*ref_final(:,2);
% rp=100*matdiv(matadd(dref(:,3:end),-dref(:,3)),dref(:,3));
% h=errorbar(1:7,nanmean(rp(:,3:end)),nanstd(rp(:,3:end)),'ro','linewidth',3);
% 
% set(gca,'Xtick',1:7,'XtickLabel',Cal.brw_str(orden(3:end)));
% set(gca,'Ylim',[-4,4],'Ytick',-3:3); grid;
% xlabel('Brewer Serial No.'); ylabel('Relative differences (%)'); title('Ozone differences relatives to IZO#185 (%)');
% legend({'Initial Status','Final Status'}); 
%%
% NumStacksPerGroup = 3;
% NumGroupsPerAxis = 6;
% NumStackElements = 4;
% 
% % labels to use on tick marks for groups
% groupLabels = { 'Test'; 2; 4; 6; 8; -1; };
% stackData = rand(NumGroupsPerAxis,NumStacksPerGroup,NumStackElements); 
% 
% BarStack(st, groupLabels);
% set(gca,'FontSize',18)
% set(gcf,'Position',[100 100 720 650])
% grid on
% set(gca,'Layer','top') % put grid lines on top of stacks 
