
%% General
% Habr? que modificar a mano el directorio final: CODE, Are2011, SDK11 ...
if ispc
 Cal.path_root=fullfile(cell2mat(regexpi(pwd,'^[A-Z]:', 'match')),'CODE','campaigns','are2019');
else isunix
 Cal.path_root=fullfile('~',cell2mat(regexpi(pwd,'^[A-Z]:', 'match')),'CODE','campaigns','are2019');
  if ismac
   Cal.path_root=fullfile('/Users/aredondas/','CODE','rbcce.aemet.es','campaigns','are2019');
  else
   Cal.path_root=fullfile('~',cell2mat(regexpi(pwd,'^[A-Z]:', 'match')),'CODE','campaigns','are2019');
  end
end
addpath(genpath(fullfile(Cal.path_root,'matlab')));
Cal.file_save='arenos_2019.mat';
Cal.campaign='Arenosillo, Huelva (Spain), Jun 27th -- June 05th, 2019';
startup

%% Station
Station.OSC=680;
Station.name='ARENOS';
Station.lat=[];
Station.long=[];
Station.meanozo=[];

Cal.Station=Station;

%%  configuration  date---> Default values
day0=170;   Date.day0=day0;
dayend=190; Date.dayend=dayend;

Date.cal_year=2019; Date.cal_month=06;
Date.BLIND_DAYS=day0:dayend;
Date.CALC_DAYS=day0:dayend;
Date.FINAL_DAYS=day0:dayend;

Cal.Date=Date;

%% NUEVA DEFINICON POR INSTRUMENTO en minusculas
% cal-days, blind-days, final-days
% cal-days=arrival:campaign end  
% blind-days=arrival: (to) maintenance or, if no changes, campaign end)
% final-days=((maintenance or, if no changes, arrival): campaign end
Cal.calibration_days={
   day0:dayend,day0:dayend   ,149:157 %day0:dayend       %005  
   day0:dayend,day0:dayend   ,day0:dayend       %017 
   day0:dayend,day0:153      ,156:dayend       %033  <-Calc Step
   day0:dayend,day0:154      ,155:158          %053  change SL/Hg lamps
   day0:dayend, day0:dayend  ,day0:dayend       %070  
   day0:dayend, 150:dayend   ,150:dayend       %075  
   day0:dayend, 151:dayend   ,152:dayend        %082  
   152:dayend,149:155        ,152:dayend        %102  
   day0:152   ,152:155       ,155:dayend        %117  
   day0:dayend,day0:155      ,156:dayend        %126 %day155 CAL 296-->286
   day0:152   ,152:152       ,153:dayend        %150  
   day0:dayend,day0:153      ,154:dayend       %151  %see sl
   day0:dayend,day0:dayend   ,day0:dayend       %158 
   day0:dayend,day0:dayend   ,day0:dayend       %163  
   day0:151   ,152:154       ,154:dayend        %166  
   day0:dayend,day0:dayend   ,day0:dayend       %172  
   day0:dayend,day0:dayend   ,day0:dayend       %185  
   day0:dayend,day0:155      ,156:dayend        %186  
   day0:dayend,day0:dayend   ,152:dayend       %202  
   day0:dayend,day0:dayend   ,day0:dayend       %214
   day0:dayend,day0:dayend   ,150:dayend       %228
                                 };

Cal.blind_days=Cal.calibration_days(:,2);
Cal.final_days=Cal.calibration_days(:,3);

%% CALIBRATION INFO
Cal.brw       = [005,017,033,053,070,075,082,102,117,126,150,151,158,163,166,172,185,186,202,214,228];
Cal.brwM      = [2  ,2  ,2  ,2  ,4  ,4  ,4  ,4  ,4  ,4  ,3  ,4  ,3  ,3  ,4  ,3  ,3  ,3  ,3  ,3  ,3  ];
Cal.sl_c      = [0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,1  ,1  ,1  ,1  ,1  ];
Cal.sl_c_blind= [0  ,1  ,1  ,1  ,0  ,0  ,0  ,1  ,0  ,0  ,1  ,1  ,0  ,1  ,1  ,0  ,0  ,0  ,1  ,1  ,0  ];
Cal.no_maint   =[1  ,1  ,1  ,0  ,0  ,0  ,1  ,0  ,1  ,0  ,1  ,0  ,1  ,1  ,0  ,1  ,1  ,0  ,1  ,1  ,1  ];
Cal.plt       = {'o','+','*','h','x','s','d','v','>','<','p','+','x','p','*','x','s','d','v','>','<'};


Cal.n_brw=length(Cal.brw);
Cal.brw_name={'TSK#005','IOS#017','SCO#033','DNK#053','MAD#070','UM#075','DNK#082','POR#102','MUR#117','UM#126',...
              'ARE#150','COR#151','K&Z#158','WRC#163','ZAR#166','UM#172','IZO#185','MAD#186',...
              'DNK#202','SDK#214','DNK#228'
             };
Cal.brw_str=mmcellstr(sprintf('%03d|',Cal.brw));

Cal.Tsync=3.5;


Cal.brewer_ref=find(Cal.brw==185); % can be several []
Cal.n_ref=[find(Cal.brw==185),find(Cal.brw==185)];

%Cal.n_ref=[find(Cal.brw==017),find(Cal.brw==185)];

Cal.brw_name(Cal.brewer_ref)

% for each brewer, 1 if no changes in maintenance, 0 otherwise
% check
% {Cal.brw_name,Cal.brw,Cal.sl_c,Cal.brw_str}



%% initial setup

  brw_config_files={
    '..\005\ICF14815.005' ,   '..\005\ICF15117.005'  ,'1857',  '1838'; % 
    '..\017\ICF15315.017' ,   '..\017\ICF15315.017'  ,'2170',  '2097'; % 
    '..\033\config033.cfg' ,  '..\033\ICF15617.033'  ,'2329',  '2325'; % 
    '..\053\ICF15316.053' ,   '..\053\ICF15517.053'  ,'1845',  '1850'; % 
    '..\070\ICF15617.070' ,   '..\070\ICF15617.070'  ,'1700',  '1700'; %
    '..\075\ICF14615.075' ,   '..\075\ICF15017.075'  ,'1769',  '1714'; %   New TC and DT
    '..\082\ICF15316.082' ,   '..\082\ICF15017.082'  ,'1615',  '1666'; %
    '..\102\ICF25107.102' ,   '..\102\ICF15517.102'  ,'2350',  '2713'; %
    '..\117\icf14915.117' ,   '..\117\ICF14915.117'  ,'1536',  '1612'; % 
    '..\126\icf15215.126' ,   '..\126\ICF15517.126'  ,'2093',  '2075'; % 
    '..\150\Icf14915.150' ,   '..\150\ICF15617.150'  ,'0322',  '0325'; % 
    '..\151\icf15315.151' ,   '..\151\icf15315.151'  ,'1198',  '1835'; %
    '..\158\icf20514.158' ,   '..\158\icf15315.158'  ,'0468',  '0521'; % 
    '..\163\ICF17016.163' ,   '..\163\ICF15017.163'  ,'0270',  '0270'; % ->to updated from arosa
    '..\166\icf15215.166' ,   '..\166\ICF15215.166'  ,'1952',  '1975'; %
    '..\172\ICF15115.172' ,   '..\172\ICF15117.172'  ,'0444',  '0444'; %
    '..\185\icf12017.185' ,   '..\185\icf12217.185'   ,'0335',  '0335'; % new temperature coeff
    '..\186\ICF14915.186' ,   '..\186\ICF14915.186'  ,'0317',  '0317'; % 
    '..\202\ICF15215.202' ,   '..\202\ICF15017.202'  ,'0283',  '0270'; %
    '..\214\ICF15015.214' ,   '..\214\ICF15017.214'  ,'0234',  '0216'; % 
    '..\228\ICF22416.228' ,   '..\228\ICF15017.228'  ,'0242',  '0242'; %
    };

%% Brewer configuration files from configuration tables
icf_op=cell(1,length(Cal.n_brw));  %old, operative
icf_a=cell(1,length(Cal.n_brw));   %new, alternative

events_n=cell(1,length(Cal.n_brw)); events_raw=cell(1,length(Cal.n_brw));
events_text=cell(1,length(Cal.n_brw)); incidences_text=cell(1,length(Cal.n_brw));
warning('off', 'MATLAB:xlsread:Mode');
for iz=1:Cal.n_brw
 try   
    if iz==find(Cal.brw==185) %reference
       icf_op{iz}=xlsread(fullfile(Cal.path_root,'configs',['icf',Cal.brw_str{iz},'.xls']),...
                         ['icf.',Cal.brw_str{iz}],'','basic');      
       icf_a{iz}=xlsread(fullfile(Cal.path_root,'configs',['icf',Cal.brw_str{iz},'.xls']),...
                         ['icf_a.',Cal.brw_str{iz}],'','basic');                     
       [events_n{iz},events_text{iz},events_raw{iz}]=xlsread(fullfile(Cal.path_root,'configs',['icf',Cal.brw_str{iz},'.xls']),...
                                                             ['Eventos.',Cal.brw_str{iz}],'','basic');
       [inc_n{iz},incidences_text{iz},incidences_raw{iz}]=xlsread(fullfile(Cal.path_root,'configs',['icf',Cal.brw_str{iz},'.xls']),...
                                                             ['Incidencias.',Cal.brw_str{iz}],'','basic');
    else % not reference. Go to bfiles
      if exist(fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},['icf',Cal.brw_str{iz},'.xls']),'file')
         icf_op{iz}=xlsread(fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},['icf',Cal.brw_str{iz},'.xls']),...
                           ['icf.',Cal.brw_str{iz}],'','basic');
         [events_n{iz},events_text{iz},events_raw{iz}]=xlsread(fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},['icf',Cal.brw_str{iz},'.xls']),...
                                                               ['Eventos.',Cal.brw_str{iz}],'','basic');
        %  icf_a{iz}=xlsread(fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},['icf',Cal.brw_str{iz},'.xls']),...
        %                    ['icf_a.',Cal.brw_str{iz}],'','basic');                               
         [inc_n{iz},incidences_text{iz}]=xlsread(fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},['icf',Cal.brw_str{iz},'.xls']),...
                                                 ['Incidencias.',Cal.brw_str{iz}],'','basic');         
      else
          continue
      end
    end   
    
    if size(icf_op{iz},1)==54  % ??
       cfg=icf_op{iz}(2:end-1,3:end); 
       save('config.cfg', 'cfg', '-ASCII','-double');
    else
       cfg=icf_op{iz}(1:end-1,3:end); 
       save('config.cfg', 'cfg', '-ASCII','-double');
    end
    tmp_file=sprintf('config%s.cfg',Cal.brw_str{iz});       
    copyfile('config.cfg',fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},tmp_file));
    delete('config.cfg');
  
  if iz==find(Cal.brw==185) %reference  
     if size(icf_a{iz},1)==54 %??
        cfg=icf_a{iz}(2:end-1,3:end);
        save('config_a.cfg', 'cfg', '-ASCII','-double');
     else
        cfg=icf_a{iz}(1:end-1,3:end);
        save('config_a.cfg', 'cfg', '-ASCII','-double');
     end             
     tmp_file=sprintf('config%s_a.cfg',Cal.brw_str{iz});
     copyfile('config_a.cfg',fullfile(Cal.path_root,'bfiles',Cal.brw_str{iz},tmp_file));
     delete('config_a.cfg');
   end
 
  catch exception
        fprintf('%s Brewer%s\n',exception.message,Cal.brw_name{iz}); 
        icf_op{iz}=[]; icf_a{iz}=[]; events_n{iz}=[]; events_raw{iz}=[];
        events_text{iz}=[]; incidences_text{iz}=[];
  end
  Cal.events{iz}=events_n{iz}(:,2:end);
  Cal.events_n{iz}=events_n{iz};
  Cal.events_text{iz}=events_text{iz};
  Cal.events_raw{iz}=events_raw{iz};
  Cal.incidences_text{iz}=incidences_text{iz};
end
%%
Cal.ETC_C={
          [0,0,0,0,0,0]         %005
          [0,0,0,0,0,0]         %017
          [0,0,0,0,0,0]         %033
          [0,0,15,0,0,0]         %053  -> with new dsp need correction
          [0,0,0,0,0,0]         %070
          [0,0,0,15,20,0]       %075  % confirmed 2017
          [0,0,0,0,0,0]         %082
          [0,0,0,0,0,0]         %102
          [0,0,0,0,0,0]         %117
          [0,0,0,0,0,0]         %126 
          [0,0,0,0,0,0]         %150
          [0,0,0,0,0,0]         %151
          [0,0,0,0,0,0]         %158 
          [0,0,0,0,0,0]         %163
          [0,0,0,0,0,0]         %166 
          [0,0,0,0,NaN,0]       %172 -> replace filter#4 very noisy
          [0,0,0,-13,-18,0]        %185
          [0,0,0,-15,-10,0];    %186
          [0,0,0,0,0,0]         %202
          [0,0,0,0,0,0]         %214
          [0,0,0,0,0,0]         %228
                };

%% Calibration instrument
% Brewer configuration files
pa=repmat(cellstr([Cal.path_root,filesep(),'bfiles']),Cal.n_brw,2);
pa=cellfun(@fullfile,pa,[mmcellstr(sprintf('%03d|',Cal.brw)),mmcellstr(sprintf('%03d|',Cal.brw))],'UniformOutput',0);
brw_config_files(:,1:2)=cellfun(@fullfile,pa,upper(brw_config_files(:,1:2)),'UniformOutput',0);
if isunix
   brw_config_files=strrep(brw_config_files,'\',filesep());
%   brw_config_files=cellfun(@upper,brw_config_files,'UniformOutput',0);
end

SL_OLD_REF=str2num(cat(1,brw_config_files{:,3}));
SL_NEW_REF=str2num(cat(1,brw_config_files{:,4}));
brw_config_files_old=brw_config_files(:,1);
brw_config_files_new=brw_config_files(:,2);

Cal.brw_config_files=brw_config_files;
Cal.brw_config_files_old=brw_config_files(:,1);
Cal.brw_config_files_new=brw_config_files(:,2);
Cal.SL_OLD_REF=cellfun(@(x) str2double(x), brw_config_files(:,3));
Cal.SL_NEW_REF=cellfun(@(x) str2double(x), brw_config_files(:,4));

%%
for i=1:Cal.n_brw
 for jj=1:2   
    if (exist(Cal.brw_config_files{i,jj},'file'))
        f=fileread(Cal.brw_config_files{i,jj});
        
%         fmt_icf=[
% '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f mk%3c',...
% ' %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s %s'];
%         config=sscanf(f',fmt_icf);
%         type=char(config(23:25)')
%         fecha=char(config(54:end)')
%         disp(Cal.brw_config_files{i,2});
    else
       disp('->ERROR'); 
       disp(jj);
       disp(Cal.brw_config_files{i,jj});
    end
 end
end

%% anonymous definitions

maxf=@(x) x(end);
minf=@(x) x(1);
nunique=@(x) unique(x(~isnan(x)));
n1=@(x,y) unique(x(~isnan(x(:,y+1)),y+1));

