% AOD config table
%fieldnames(table2struct(t))
% t=readtable('aod_config_template.csv')





fields=[
    {'Brw'         }
    {'ANO'         }
    {'DIAJ0'       }
    {'DIAJ'        }
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

addpath(genpath('../matlab'));
file_setup='arenos2019_setup.m';
run(fullfile('..',file_setup))%  configuracion por defecto
cfgtable = cell2table(cell(0,35), 'VariableNames', fields);
Cal.n_inst=find(Cal.brw==185)

%empty table

cfgtable{1:6,1}=Cal.brw(Cal.n_inst)

%%filter
f=load(fullfile('..',Cal.file_save),'filter');
media=f.filter{Cal.n_inst}.media_fi';
cfgtable{1:6,22:26}=media'
disp('media')

filter_by_year=[repmat([Cal.brw(Cal.n_inst),0,0,365,1],6,1),media'];
filter_by_year(:,5)=1:6
filter_by_year(:,2)=2019

table_filter=array2table(filter_by_year,'VariableNames',{'BRW','YEAR','DAY0','DAYEND','SLIT','AT_FL1','AT_FL2','AT_FL3','AT_FL4','AT_FL5'});
writetable(table_filter,sprintf('Filter_spectral_%03d_%04d.csv',Cal.brw(Cal.n_inst),2019))



%% dispersion
disp(Cal.brw_str(Cal.n_inst))
date_range=datenum(2019,5,1);
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
aaa=size(dsp_salida{1,Cal.n_inst})
table_aod=[];
if aaa(1,1)>0
    for j=1:size(aaa,2) % number of dispersion
          try
              % BRW YEAR DIA0 DIAF SLIT	CALSTEP	WAVEL	FWHM RAYLEIGH	O3_ABS	SO2_ABS	NO2_ABS
           dia=dsp_salida{1,i}{j}.day;
           ano=dsp_salida{1,i}{1}.year;
           aa=size(dsp_salida{1,i}{1,1}.salida.CUBIC)
           m=dsp_salida{1,i}{1,1}.salida.CUBIC(1,aa(1,2)-1);
           Rayleigh=[Rayleigh;[brewer(1,i),ano,dia,m{1,1}.raycoeff]]
           O3absorption=[O3absorption;[brewer(1,i),ano,dia,m{1,1}.o3coeff]];
           SO2absorption=[SO2absorption;[brewer(1,i),ano,dia,m{1,1}.so2coeff]];
           ms=[m{1}.thiswl',m{1}.fwhmwl',round(-log(m{1}.raycoeff')*10^4),m{1}.o3coeff',m{1}.so2coeff'];
           ms=[repmat([Cal.brw(i),ano+2000,dia,365,1,m{1}.ozone_pos-m{1}.cal_ozonepos],6,1),ms];
           ms(:,5)=1:6;
           t=array2table(ms,'VariableNames',{'BRW' 'YEAR' 'DAY0' 'DAYEND' 'SLIT'	'CALSTEP'	'WAVEL'	'FWHM' 'RAYLEIGH'	'O3_ABS'	'SO2_ABS'});
           table_aod=[table_aod;t];
           writetable(t,sprintf('Table_DSP_%03d_%02d_%03d.csv',Cal.brw(i),ano,dia));
           catch
                disp(Cal.brw_name(Cal.n_inst))
                disp('Error')
          end
    end   
end

try
    t1=readtable(sprintf('Filter_spectral_%03d.csv',Cal.brw(i)));
    tf=t1(t1.YEAR==2018,:);
    table_aod=[t,tf(:,6:end)]  % elegimos el último
    writetable(table_aod,sprintf('Table_AOD_%03d.csv',Cal.brw(i)));
catch
      disp(Cal.brw_name(Cal.n_inst))
     disp('Error');
end