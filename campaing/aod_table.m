% AOD config table
%fieldnames(table2struct(t))
% t=readtable('aod_config_template.csv')
% fields=fieldnames(table2struct(t))




fields=[
    {'BRW'         }
    {'YEAR'        }
    {'DAY0'        }
    {'DAYEND'      }
    {'SLIT'        }
    {'CALSTEP'     }
    {'WAVEL'       }
    {'FWHM'        }
    {'ETC_FL0'     }
    {'ETC_FL1'     }
    {'ETC_FL2'     }
    {'ETC_FL3'     }
    {'ETC_FL4'     }
    {'ETC_FL5'     }
    {'RAYLEIGH'    }
    {'O3_ABS'      }
    {'SO2_ABS'     }
    {'NO2_ABS'     }
    {'TC_CONST'    }
    {'TC_LIN'      }
    {'TC_QUAD'     }
    {'AT_FL1'      }
    {'AT_FL2'      }
    {'AT_FL3'      }
    {'AT_FL4'      }
    {'AT_FL5'      }
    {'STRAYL_CONST'}
    {'STRAYL_COEFF'}
    {'STRAYL_EXP'  }
    {'SL_REF'      }
    {'SL_SLOPE'    }
    {'SL_QUAD'     }
    {'AOD_EX1'     }
    {'AOD_EX2'     }
    {'AOD_EX3'     }];


%% Setup de la campaña
addpath(genpath('../matlab'));
file_setup='arenos2019_setup.m';
run(fullfile('..',file_setup))%  configuracion por defecto
cfgtable = cell2table(cell(0,35), 'VariableNames', fields);

%% Setup del equipo
Cal.n_inst=find(Cal.brw==185)

%% Choose day and date of validity of the calibraton
% Calibration date
year_=Cal.Date.cal_year;
% Julian day since calibration is valid
dayj=Cal.Date.day0
dayj=100
%% load previous files
try
    cfgtable=readtable(sprintf('Table_AOD_%03d_%02d_%03d.csv',Cal.brw(Cal.n_inst),year_,dayj))
catch
     disp(Cal.brw_name(Cal.n_inst))
     disp('Calibration do not exist creating a new empty one');
     cfgtable{1:6,1}=Cal.brw(Cal.n_inst);
end

%% Temperture dependence from Cal_report_a2
t=load(fullfile('..',Cal.file_save),'temperature');
t=t.temperature{Cal.n_inst};
t=ajuste{2}.new;
fields(19:20)'
cfgtable{2:6,[19:20]}=t(1:5,1:2);


%% filter attenuation form Cal_report_a2
% Average filter repsonse from FIOAVG
% TODO: save period of the analysis (average)
f=load(fullfile('..',Cal.file_save),'filter');

media=f.filter{Cal.n_inst}.media_fi';

filter_by_year=[repmat([Cal.brw(Cal.n_inst),0,dayj,365,1],6,1),media'];
filter_by_year(:,5)=1:6 ;
filter_by_year(:,2)=year_;
table_filter=array2table(filter_by_year,'VariableNames',fields([1:5,22:26]));
cfgtable(:,[1:5,22:26])=table_filter;



%% Waveleng calibration from Cal_report_b
disp(Cal.brw_str(Cal.n_inst))
% date to find the calibration
date_range=datenum(year_,5,1)
dsppath=fullfile(Cal.path_root,'dsp');
dsp_quad{Cal.n_inst}=[];
dsp_cubic{Cal.n_inst}=[];
dsp_salida{Cal.n_inst}=[];
try 
    [dsp_quad{Cal.n_inst}, dsp_cubic{Cal.n_inst},dsp_salida{Cal.n_inst}]=...
    read_dsp_report(dsppath,'brwid',Cal.brw_str{Cal.n_inst},'inst',Cal.n_inst,'configs',Cal.brw_config_files,'date_range',date_range);
catch
    dsp_quad{Cal.n_inst}=[];
    dsp_cubic{Cal.n_inst}=[];
    dsp_salida{Cal.n_inst}=[];
    disp('Error')
    disp(Cal.n_inst);
 end

dsp=dsp_salida;
Rayleigh=[];
O3absorption=[];
NO2absorption=[];
SO2absorption=[];
Cal.n_inst;

%[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
aaa=size(dsp_salida{Cal.n_inst},2)
table_aod=[];
if aaa(1,1)>0
    for j=1:size(aaa,2) % number of dispersion
          try
              % BRW YEAR DIA0 DIAF SLIT	CALSTEP	WAVEL	FWHM RAYLEIGH	O3_ABS	SO2_ABS	NO2_ABS
           dia=dsp_salida{Cal.n_inst}{j}.day
           dia=dayj
           ano=dsp_salida{Cal.n_inst}{1}.year
           ano=year_
           
           aa=size(dsp_salida{Cal.n_inst}{1,1}.salida.CUBIC)
           m=dsp_salida{Cal.n_inst}{1,1}.salida.CUBIC(1,aa(1,2)-1);
           Rayleigh=[Rayleigh;[Cal.brw(Cal.n_inst),ano,dia,m{1,1}.braycoeff]];
           O3absorption=[O3absorption;[Cal.brw(Cal.n_inst),ano,dia,m{1,1}.o3coeff]];
           SO2absorption=[SO2absorption;[Cal.brw(Cal.n_inst),ano,dia,m{1,1}.so2coeff]];
           ms=[m{1}.thiswl',m{1}.fwhmwl'/2,m{1}.braycoeff',m{1}.o3coeff',m{1}.so2coeff'];
           ms=[repmat([Cal.brw(Cal.n_inst),ano+2000,dia,365,1,m{1}.ozone_pos-m{1}.cal_ozonepos],6,1),ms];
           ms(:,5)=1:6;
           t=array2table(ms,'VariableNames',fields([1:8,15:17]));
           table_aod=[table_aod;t];
           cfgtable(:,[1:8,15:17])=table_aod;
           writetable(cfgtable,sprintf('Table_AOD_%03d_%02d_%03d.csv',Cal.brw(Cal.n_inst),ano,dia));
           catch
                disp(Cal.brw_name(Cal.n_inst))
                disp('Error')
          end
    end   
end

