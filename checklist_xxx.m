
%% Brewer Evaluation
clear all;
file_setup='arenos2019_setup';

eval(file_setup);     % configuracion por defecto
Cal.n_inst=find(Cal.brw==xxx);
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
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [5 5],{Date.BLIND_DAYS(1),Date.BLIND_DAYS(end)});

if Date.BLIND_DAYS(end)+1<Date.FINAL_DAYS(1)
   mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [6 5],{Date.BLIND_DAYS(end)+1,Date.FINAL_DAYS(1)-1});
else
    mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [6 5],{'NA','NA'});
end
            
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [7 5],{Date.FINAL_DAYS(1),Date.FINAL_DAYS(end)});

%% Load configuration files & avg report
[config_def,TCdef,DTdef,ETCdef,A1def,ATdef,leg]=read_icf(Cal.brw_config_files{Cal.n_inst,2});
[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig,leg]=read_icf(Cal.brw_config_files{Cal.n_inst,1});

%latexcmd(fullfile(Cal.file_latex,['cal_config_',Cal.brw_str{Cal.n_inst}]),...
%                     DTref,'\ETCref',ETCref(1),'\Aref',A1ref(1),...
%                     DTdef,'\ETCdef',ETCdef(1),'\Adef',A1def(1),...
%                     DTorig,'\ETCorig',ETCorig(1),'\Aorig',A1orig(1));

load(Cal.file_save,'avg_report') 

%% AVG report

avg=avg_report{Cal.n_inst}

%% RS AVG
% 13
% 13, 7  Check avg.rs_data for all slits

[m,s]=grpstats(avg.rs_data,avg.rs_data(:,2));
ctrl=m(end,[4:9])+s(end,[4:9])*3>1.003 | m(end,[4:9])-s(end,[4:9])*3<0.997;
if sum(ctrl)==0
    msg='All slits below threshold limit (0.003)';
else
    slitname=[0,2,3,4,5,6];
    msg=sprintf('%.0f,' , slitname(1,find(ctrl)));
    msg = msg(1:end - 1);
    msg=sprintf('Slits out of limits: %s',msg);
end

mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [13 6],{msg});
%% DT AVG
% 14
% 14, 5  DTAVG
% 14, 8  DTAVG-DTorig
% 14, 9  DTorig
% 14, 10 DTAVG
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [14 5],str2double(avg.DTAVG)*10^9);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [14 10],str2double(avg.DTAVG)*10^9);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [14 9],avg.DTorig*10^9);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [14 8],str2double(avg.DTAVG)*10^9-avg.DTorig*10^9); 
[m,s]=grpstats(avg.dt_data,avg.dt_data(:,2));            
dt_std=sprintf('dt_low=%.1f +/- %.2f %c dt_high=%.1f +/- %.2f',m(end,4),s(end,4),char(10),m(end,5),s(end,5))            
            
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [14 6],{dt_std});
%% SL AVG
% SL_R6 15
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [15 5],avg.RseisAVG);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [15 10],avg.RseisAVG);

mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [15 6],Cal.SL_OLD_REF(Cal.n_inst));
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [15 9],Cal.SL_OLD_REF(Cal.n_inst));

mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [15 8],avg.RseisAVG-Cal.SL_OLD_REF(Cal.n_inst));
% R6 temp 16
% 
[b,bi]=regress(avg.sl_data(:,12),[ones(size(avg.sl_data(:,5))),avg.sl_data(:,5)]);            
sl_temp=sprintf('R6 =%.1f [%.2f,%.2f] + T  %.1f  [%.2f,%.2f]',b(1),bi(1,1),bi(1,2),b(2),bi(2,1),bi(2,2))            
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [16 5],round(b(2),2));
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [16 6],{sl_temp});

% SL_R5 17
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [17 5],avg.RcincoAVG);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [17 10],avg.RcincoAVG);
% R5 temp 18
% 
[b,bi]=regress(avg.sl_data(:,11),[ones(size(avg.sl_data(:,5))),avg.sl_data(:,5)]);            
sl_temp=sprintf('R5 =%.1f [%.2f,%.2f] + T  %.1f  [%.2f,%.2f]',b(1),bi(1,1),bi(1,2),b(2),bi(2,1),bi(2,2))            
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [18 5],round(b(2),2));
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                [18 6],{sl_temp});

