file_setup='arenos2019_setup';

run(fullfile('..',file_setup)); 

dsp_quad={};
dsp_cubic={};
dsp_salida={};

for ii=Cal.n_brw:-1:1
    
    Cal.n_inst=ii

    disp(Cal.brw_str(Cal.n_inst))
    date_range=datenum(2017,1,1);
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
if ~isempty(dsp_salida{Cal.n_inst})
    disp(Cal.brw_name{Cal.n_inst})
    try
     dsp_salida{Cal.n_inst}{end}.salida.CUBIC{end-1}
     dsp_salida{Cal.n_inst}{end}.salida.CUBIC{end-1}.resumen
     %dia=dsp_salida{1,i}{j}.day;
     %ano=dsp_salida{1,i}{1}.year;
    catch
     disp('error last dispersion')
    end
    
end
end

% addpath(genpath('..\..\matlab'));
% file_setup='arenos2017_setup.m';
% run(fullfile(file_setup))%  configuracion por defecto
dsp=dsp_salida;
%Cal.n_inst=find(Cal.brw==185);


%
Rayleigh=[];
O3absorption=[];
NO2absorption=[];
SO2absorption=[];
%brewer=[5,17,33,53,70,75,82,102,117,126,130,151,158,163,166,172,185,186,202,214,228]
brewer=Cal.brw
for i=1:Cal.n_brw
    Cal.n_inst=i;
    %[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
    % m=filter.filter{i};
    aaa=size(dsp_salida{1,i})
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
      %NO2absorption=[NO2absorption,m{1,1}.so2coeff];
%       if ~isempty(m)
%        media_fi{i}=m{1,1}.o3coeff;
%       else
%         media_fi{i}=NaN*ones(6,5);
%       end
%        snapnow();close all ;  
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
end
  
   
  

   id=fopen('DSP_Rayleight_2018.dat','w+')
   
   size(Rayleigh)
   for i=1:1:size(Rayleigh,1)
       fprintf(id,'%d %f %f %f %f %f %f\n',Rayleigh(i,1:7))
   end
   fclose(id)
   
  id=fopen('DSP_o3abosrption_2018.dat','w+')
   
   size(O3absorption)
   for i=1:1:size(O3absorption,1)
       fprintf(id,'%d %f %f %f %f %f %f\n',O3absorption(i,1:7))
   end
   fclose(id)
   
  id=fopen('DSP_SO2absorption_2018.dat','w+')
   
   size(SO2absorption)
   for i=1:1:size(SO2absorption,1)
       fprintf(id,'%d %f %f %f %f %f %f\n',SO2absorption(i,1:7))
   end
   fclose(id)