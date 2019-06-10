
%% Brewer Evaluation
clear all;
file_setup='arenos2019_setup';

eval(file_setup);     % configuracion por defecto
Cal.n_inst=find(Cal.brw==005);
Cal.file_latex=fullfile('.','latex',Cal.brw_str{Cal.n_inst});
Cal.dir_figs=fullfile('latex',filesep(),Cal.brw_str{Cal.n_inst},...
                              filesep(),[Cal.brw_str{Cal.n_inst},'_figures'],filesep());
mkdir(Cal.dir_figs);
try
      save(Cal.file_save,'-Append','Cal'); %sobreescribimos la configuracion guardada.
catch exception
      fprintf('Error: %s\n Initializing data for Brewer %s\n',exception.message,Cal.brw_name{Cal.n_inst});
      save(Cal.file_save);
end

%% Brewer setup
Station.OSC=680;
Station.name='';
Station.lat=67;
Station.long=50;
Station.meanozo=350;

Date.CALC_DAYS=Cal.calibration_days{Cal.n_inst,1};
if ~isempty(Cal.calibration_days{Cal.n_inst,2})
   Date.BLIND_DAYS=Cal.calibration_days{Cal.n_inst,2};
else
   Date.BLIND_DAYS=[NaN,NaN];
end
Date.FINAL_DAYS=Cal.calibration_days{Cal.n_inst,3};

Cal.Date=Date;


% latexcmd(fullfile(Cal.file_latex,['cal_setup_',Cal.brw_str{Cal.n_inst}]),...
%                     '\CALINI',Date.CALC_DAYS(1),'\CALEND',Date.CALC_DAYS(end),...
%                     '\calyear',Date.cal_year,'\calyearold',Date.cal_year-2,...
%                     '\slrefOLD',Cal.SL_OLD_REF(Cal.n_inst),'\slrefNEW',Cal.SL_NEW_REF(Cal.n_inst),...
%                     '\BLINDINI',Date.BLIND_DAYS(1),'\BLINDEND',Date.BLIND_DAYS(end),...
%                     '\FINALINI',Date.FINAL_DAYS(1),'\FINALEND',Date.FINAL_DAYS(end),...
%                     '\caldays',length(Date.FINAL_DAYS),'\Tsync',Cal.Tsync,...
%                     '\brwname',Cal.brw_name(Cal.n_inst),'\brwref',Cal.brw_name(Cal.n_ref(2)),...
%                     '\BRWSTATION',Station.name,'\STATIONOSC',Station.OSC,...%'\DCFFILE',Cal.FCal.DCFFILE,'\LFFILE',Cal.FCal.LFFILE,...
%                     '\campaign',Cal.campaign);

%% Calibration days
%5 Blind days
%6 Maintenace days
%7 Calibration days
%mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                [5 5],{Date.BLIND_DAYS(1),Date.BLIND_DAYS(end)});
%            
%mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                [7 5],{Date.FINAL_DAYS(1),Date.FINAL_DAYS(end)});

%% Load configuration files & avg report
[config_def,TCdef,DTdef,ETCdef,A1def,ATdef,leg]=read_icf(Cal.brw_config_files{Cal.n_inst,2});
[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig,leg]=read_icf(Cal.brw_config_files{Cal.n_inst,1});

%latexcmd(fullfile(Cal.file_latex,['cal_config_',Cal.brw_str{Cal.n_inst}]),...
%                     DTref,'\ETCref',ETCref(1),'\Aref',A1ref(1),...
%                     DTdef,'\ETCdef',ETCdef(1),'\Adef',A1def(1),...
%                     DTorig,'\ETCorig',ETCorig(1),'\Aorig',A1orig(1));

load(Cal.file_save,'temperature') 
load(Cal.file_save,'filter') 


% 
% %%temperature report historic
% 
% temp=temperature{Cal.n_inst}
% 
% %% 
% % 42  Slope
% % 43, T range
% % 44, New TC
figure
i=Cal.n_inst    
%try    
 Cal.n_inst=i;   
 slope_old=round(temperature{Cal.n_inst}.ajuste{2}.orig(end,2),1);
 slope_new=round(temperature{Cal.n_inst}.ajuste{2}.new(end,2),1);

subplot(5,4,i)
[c,t]=hist(temperature{Cal.n_inst}.sl_raw(:,4),10);
bar(t,c/sum(c));
set(gca,'Ylim',[0,0.8])
set(gca,'Xlim',[0,50])
title(Cal.brw_str(i))

t_range=range(t);
t_int=num2str(round([t(1),t(end)]));

% Columns: Y=3, N=4, V1=5, V2=6
% Temperature Coeff & Filter section

% Temperature Section:
% SL temperature dep Linear 38 Eval

% SL temperature dep (of campaign) 39 V1
% SL temperature dep (of campaign) 39 V2
% SL temperature dep (of campaign) 39 Eval

% SL temperature range (of campaign) 40 V1 (range)
% SL temperature range (of campaign) 40 V2 (interval)
% SL temperature range (of campaign) 40 Eval

% SL temperature dep (historic) 42 V1
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [42 5],slope_old*10);
% SL temperature dep (historic) 42 V2 (is always 5)
%slope_old_limit=5.0
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [42 6],slope_old_limit);
% SL temperature dep (historic) 42 Eval
%  if slope_old*10 < slope_old_limit
%       mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                       [42 3],'Y');
%       mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                       [42 4],'');
%  else
%       mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                       [42 3],'');
%       mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                       [42 4],'N');
%  end
             
% temperature range 43 V1(temperature range)
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [43 5],t_range);
% temperature range 43 V2(temperature interval)
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [43 6],t_int);


% New TC 44 V1: from icf            
orig_tc=num2str(TCorig');            
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [44 5],cellstr(orig_tc));

% New TC 44 V2:          
 new_tc=num2str(table2array(temperature{Cal.n_inst}.coeff_table));            
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [44 6],cellstr(new_tc));
             

% Filters Section

% change vs nominal 47 V1:   
nominal=[5000,10000,15000,20000,25000];
v2_change=num2str(diff(round(100*(mean(filter{Cal.n_inst}.media_fi)-nominal) ./nominal)))
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                  [47 5],cellstr(v2_change));


% Filter Ozone Correction 49 V2
filt_o3_corr=num2str(filter{1,Cal.n_inst}.ETC_FILTER_COR);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [49 6],cellstr(filt_o3_corr));

 disp(Cal.brw_str(i))
%catch
% disp('Error');   
 disp(Cal.brw_str(i))
%end
%end             
disp('fin')             
%             
% [m,s]=grpstats(avg.dt_data,avg.dt_data(:,2));            
% dt_std=sprintf('dt_low=%.1f +/- %.2f %c dt_high=%.1f +/- %.2f',m(end,4),s(end,4),char(10),m(end,5),s(end,5))            
%             
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [14 7],{dt_std});
% %% SL AVG
% % SL_R6 15
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [15 5],avg.RseisAVG);
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [15 6],Cal.SL_OLD_REF(Cal.n_inst));
%             
% % R6 temp 16
% % 
% [b,bi]=regress(avg.sl_data(:,12),[ones(size(avg.sl_data(:,5))),avg.sl_data(:,5)]);            
% sl_temp=sprintf('R6 =%.1f [%.2f,%.2f] + T  %.1f  [%.2f,%.2f]',b(1),bi(1,1),bi(1,2),b(2),bi(2,1),bi(2,2))            
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [16 5],round(b(2),2));
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [16 7],{sl_temp});
% 
% % SL_R5 17
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [17 5],avg.RcincoAVG);
% %mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
% %                [17 6],Cal.SL_OLD_REF(Cal.n_inst));
%             
% % R5 temp 18
% % 
% [b,bi]=regress(avg.sl_data(:,11),[ones(size(avg.sl_data(:,5))),avg.sl_data(:,5)]);            
% sl_temp=sprintf('R5 =%.1f [%.2f,%.2f] + T  %.1f  [%.2f,%.2f]',b(1),bi(1,1),bi(1,2),b(2),bi(2,1),bi(2,2))            
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [18 5],round(b(2),2));
% mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
%                 [18 6],{sl_temp});
% 
% 
