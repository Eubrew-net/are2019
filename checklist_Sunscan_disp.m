
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


% Cargamos variable sunscan
load(Cal.file_save,'sunscan') 
%At station
sun=round(sunscan{Cal.n_inst,1}.cal_step{1,1}(1,2))
error_inf=sunscan{Cal.n_inst,1}.cal_step{1,1}(1,3)
error_sup=sunscan{Cal.n_inst,1}.cal_step{1,1}(1,4)
% 
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [53 5],sun);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [53 7],sprintf('[%.3f - %.3f]',error_inf,error_sup);
%At campaign
sun=round(sunscan{Cal.n_inst,1}.cal_step{1,2}(1,2))
error_inf=sunscan{Cal.n_inst,1}.cal_step{1,2}(1,3)
error_sup=sunscan{Cal.n_inst,1}.cal_step{1,2(1,4)
% 
 mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [54 5],sun);
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [54 7],sprintf('[%.3f - %.3f]',error_inf,error_sup);
             

%Dispersion.
load(Cal.file_save,'dsp_summary') 

dsp=dsp_summary{Cal.n_inst,end}.res{1,end}(end-1,2);
dsp_quad=dsp(end-2,2,1)
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [61 5],dsp_quad);
dsp_cubic=dsp(end-2,2,2)
mat2sheets_jls('1WBzxK6bPrkD6mKIzkG8BbhlQgx0zLpsvvSmhllwDCiw',sprintf('Brewer#%03d',Cal.brw(Cal.n_inst)),...
                 [61 3],dsp_cubic); 
disp('fin')             
