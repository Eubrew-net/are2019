
file_setup='arenos2019_setup';
eval(file_setup);     % configuracion por defecto
Cal.n_inst=find(Cal.brw==186);

ios_brw=~cellfun(@isempty,strfind(Cal.brw_config_files(:,2),'IOS'));
Cal.brw(ios_brw)
%change=write_excel_config(config,Cal,Cal.n_inst);
nb=find(ios_brw);
diff_t={};

for i=1:length(nb)
    Cal.n_inst=nb(i);

[config_def,TCdef,DTdef,ETCdef,A1def,ATdef,leg]      =read_icf(Cal.brw_config_files{Cal.n_inst,2});
[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});

str_leg={};
 for jj=1:size(leg,1)
     str_leg{jj,1}=leg(jj,:);
 end
rowlabels=regexprep(str_leg, '#', '\\#');
[a b c]=fileparts(Cal.brw_config_files{Cal.n_inst,1}); confini=strcat(b,c);
[a b c]=fileparts(Cal.brw_config_files{Cal.n_inst,2}); confend=strcat(b,c);
columnlabels={sprintf('%s %c%s%c','RBCCE','(',confini,')'),...
              sprintf('%s %c%s%c','IOS','(',confend,')')};
%matrix2latex_config([config_orig(2:end),config_def(2:end)],...
%                     fullfile(Cal.file_latex,['table_config_',Cal.brw_str{Cal.n_inst},'.tex']),...
%                                              'rowlabels',rowlabels(2:end),'columnlabels',columnlabels,...
%                                              'size','footnotesize');
%
cfg_t=makeHtml_Table([config_orig,config_def],[],cellstr(leg),columnlabels);

[row,days]=unique(diff([config_orig(2:end,1),config_def(2:end,:)]'),'rows','first');

 diff_t{i}=cfg_t(find(row)+1,:);
 diff_t{i}
end
    
%% Data evaluation with the two configs


%%  Brewer setup

Cal.Date.day0=datenum(2019,5,1);
Cal.Date.dayend=now
Date.CALC_DAYS=Cal.Date.day0:Cal.Date.dayend; Cal.Date=Date;

Cal.file_save  = 'ios_comp2019.mat';

%%  Data Read
%% READ Brewer Summaries
Cal.n_ref=Cal.n_ref;
 for i=nb'
    ozone_raw{i}={};   hg{i}={};   ozone_sum{i}={};  ozone_raw0{i}={};
    config{i}={};      sl{i}={};   ozone_ds{i}={};   sl_cr{i}={};

    
    [ozone,log_,missing_]=read_bdata_path(i,Cal,fullfile(Cal.path_root,sprintf('bdata%03d//',Cal.brw(i))));
    
    ozone_sum{i}=ozone.ozone_sum;
    config{i}=ozone.config;
    ozone_ds{i}=ozone.ozone_ds;
    ozone_raw{i}=ozone.raw;
    ozone_raw0{i}=ozone.raw0;
    sl{i}=ozone.sl;       % first calibration / bfiles
    sl_cr{i}=ozone.sl_cr; % recalc. with 2? configuration
 end
save(Cal.file_save);
%load(Cal.file_save,'ozone_sum','config','ozone_ds','ozone_raw','ozone_raw0','sl','sl_cr')

%% Configs
for i=nb'
    %% Operative
    OP_config=Cal.brw_config_files{i,1};
    try
      [a b c]=fileparts(OP_config);
      if ~strcmpi(strcat(b,c),sprintf('config%d.cfg',Cal.brw(i)))
         fprintf(strcat(1,'\rCUIDADO!! Puede que las configuraciones cargadas no sean las esperadas\n',...
                          '(Expected: %s, Loading: %s)\n'),...
                 sprintf('config%d.cfg',Cal.brw(i)),strcat(b,c));
      end
      fprintf('\nBrewer %s: Operative Config.\n',Cal.brw_name{i});
      events_cfg_op=getcfgs(Cal.Date.CALC_DAYS,OP_config);
      displaytable(events_cfg_op.data(2:end,:),cellstr(datestr(events_cfg_op.data(1,:),1))',12,'.5g',events_cfg_op.legend(2:end));
    catch exception
      fprintf('%s, brewer: %s\n',exception.message,Cal.brw_str{i});
    end
    %% Check
    ALT_config=Cal.brw_config_files{i,2};
    try
       [a b c]=fileparts(ALT_config);
       if ~strcmpi(strcat(b,c),sprintf('config%d_a.cfg',Cal.brw(i)))
          fprintf(strcat(1,'\rCUIDADO!! Puede que las configuraciones cargadas no sean las esperadas\n',...
                           '(Expected: %s, Loading: %s)\n'),...
                  sprintf('config%d_a.cfg',Cal.brw(i)),strcat(b,c));
       end
       events_cfg_chk=getcfgs(Cal.Date.CALC_DAYS,ALT_config);
       fprintf('\nBrewer %s: Second Config.\n',Cal.brw_name{i});
       displaytable(events_cfg_chk.data(2:end,:),cellstr(datestr(events_cfg_chk.data(1,:),1))',12,'.5g',events_cfg_chk.legend(2:end));
    catch exception
       fprintf('%s, brewer: %s\n',exception.message,Cal.brw_str{i});
    end
end

%% SL Report
close all;
for ii=nb'
    
    sl_mov_o{ii}={}; sl_median_o{ii}={}; sl_out_o{ii}={}; R6_o{ii}={};
    sl_mov_n{ii}={}; sl_median_n{ii}={}; sl_out_n{ii}={}; R6_n{ii}={};
    % old instrumental constants
    [sl_mov_o{ii},sl_median_o{ii},sl_out_o{ii},R6_o{ii}]=sl_report_jday(ii,sl,Cal.brw_str,...
                               'outlier_flag',0,'diaj_flag',0,...
                               'hgflag',1,'fplot',1);
    [sl_mov_n{ii},sl_median_n{ii},sl_out_n{ii},R6_n{ii}]=sl_report_jday(ii,sl_cr,Cal.brw_str,...
                               'outlier_flag',0,'diaj_flag',0,...
                               'hgflag',1,'fplot',1);

   
    close all;         
disp(ii)
end
save(Cal.file_save,'-APPEND','sl_mov_o','sl_median_o','sl_out_o','R6_o',...
                             'sl_mov_n','sl_median_n','sl_out_n','R6_n');

%% SL report plots
ix=sort(findobj('Tag','SL_R6_report'));
Width=15; Height=7;
str=Cal.brw_str(Cal.n_ref);
for i=1:length(ix)
    figure(ix(i));
    datetick('x',19,'keeplimits','keepticks');
    th=rotateticklabel(gca,45); set(th,'FontSize',9);
    set(findobj(gcf,'Type','text'),'FontSize',8); 
    set(gca,'XTicklabel','','FontSize',10); xlabel('');
    set(findobj(gca,'Marker','.'),'MarkerSize',5);
    set(findobj(gca,'Marker','o','-or','Marker','s'),'MarkerSize',4)
    if i~=2
       set(findobj(gcf,'Tag','legend'),'FontSize',8,'Location','SouthWest','LineWidth',0.3);
    else
       set(findobj(gcf,'Tag','legend'),'FontSize',8,'Location','NorthWest','LineWidth',0.3);
    end
    % Config from Operative icf
    OP_config=Cal.brw_config_files{i,1};
    events_cfg_op=getcfgs(Cal.Date.CALC_DAYS,OP_config);
    idx=group_time(R6_n{i}(:,1),events_cfg_op.data(1,:));
    stairs(gca,R6_n{i}(logical(idx),1),events_cfg_op.data(17,idx),'-b','LineWidth',3);

    printfiles_report(gcf,Cal.dir_figs,'aux_pattern',str(i),'Width',Width,'Height',Height,'LineMode','Scaled');
end

%% Creating Summaries
close all

load(Cal.file_save,'sl_mov_o','sl_median_o','sl_out_o','R6_o',...
                              'sl_mov_n','sl_median_n','sl_out_n','R6_n');
[A,ETC,SL_B,SL_R,F_corr,SL_corr_flag,cfg]=read_cal_config_new(config,Cal,{sl_median_o,sl_median_n});

% Data recalculation for summaries  and individual observations
for i=nb'
    cal{i}={}; summary_orig{i}={}; summary_orig_old{i}={};
    [cal{i},summary_orig{i},summary_orig_old{i}]=test_recalculation(Cal,i,ozone_ds,A,SL_R,SL_B,...
                                          'flag_sl',1,'plot_sl',1,'flag_sl_corr',SL_corr_flag);
    % filter correction
    [summary_old{i} summary{i}]=filter_corr(summary_orig,summary_orig_old,i,A,F_corr{i});
end
t=write_summary(Cal.brw,Cal.Date.cal_year,summary_old,summary,SL_R,SL_B);
save(Cal.file_save,'-APPEND','A','ETC','F_corr','SL_B','SL_R','SL_corr_flag','cfg',...
                             'summary_old','summary_orig_old','summary','summary_orig','t');
                         
                         
                         
                         
                         
% Outliers? Los detectamos

% %% Comparacion Operativa.
% % close all
% 
% reference_brw=[1 2]; analyzed_brewer=[1 2 ];
% osc_interval=[450,500,700,1000,1200];
% Cal.analyzed_brewer=analyzed_brewer;
% Cal.sl_c=[0,0];
% s{1}=summary{9}
% s{2}=summary_old{9}
% Cal.analyzed_brewer=[1,2];
% Cal.n_ref=[1,2];
% Cal.reference_brewer=1;
%     
% [ref,ratio_ref]=join_summary(Cal,s,1,1:2,3);
% % ratio_ref_plots
% 
% [f_hist,f_ev,f_sc,f_smooth]=ratio_ref_plots(Cal,ratio_ref,'plot_smooth',1);
% nb
% [osc_table,osc_matrix,stats,f]=osc_table(Cal,ratio_ref,osc_interval,1)    
%     
% 


