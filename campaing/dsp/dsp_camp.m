file_setup='arenos2019_setup';

run(fullfile('..','..',file_setup)); 

dsp_quad={};
dsp_cubic={};
dsp_salida={};

for ii=1:Cal.n_brw
    
    Cal.n_inst=ii

disp(Cal.brw_str(Cal.n_inst))
date_range=datenum(2015,5,1);
dsppath=fullfile(Cal.path_root,'dsp');

dsp_quad{Cal.n_inst}=[];
dsp_cubic{Cal.n_inst}=[];
dsp_salida{Cal.n_inst}=[];

[dsp_quad{Cal.n_inst}, dsp_cubic{Cal.n_inst},dsp_salida{Cal.n_inst}]=...
 read_dsp_info(dsppath,'brwid',Cal.brw_str{Cal.n_inst},'inst',Cal.n_inst,'configs',Cal.brw_config_files,'date_range',date_range);
if ~isempty(dsp_salida{Cal.n_inst})
    disp(Cal.brw_name{Cal.n_inst})
    dsp_salida{Cal.n_inst}{end}.CUBIC{end-1}
    dsp_salida{Cal.n_inst}{end}.CUBIC{end-1}.resumen
    
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
brewer=[5,17,33,53,70,75,82,102,117,126,130,151,158,163,166,172,185,186,202,214,228]
   for i=1:Cal.n_brw
       Cal.n_inst=i;
       %[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
      % m=filter.filter{i};
      aaa=size(dsp_salida{1,i})
      if aaa(1,1)>0
          aa=size(dsp_salida{1,i}{1,1}.CUBIC)
          m=dsp_salida{1,i}{1,1}.CUBIC(1,aa(1,2)-1)
          Rayleigh=[Rayleigh;[brewer(1,i),m{1,1}.raycoeff]]
          O3absorption=[O3absorption;[brewer(1,i),m{1,1}.o3coeff]];
          SO2absorption=[SO2absorption;[brewer(1,i),m{1,1}.so2coeff]];
      %NO2absorption=[NO2absorption,m{1,1}.so2coeff];
%       if ~isempty(m)
%        media_fi{i}=m{1,1}.o3coeff;
%       else
%         media_fi{i}=NaN*ones(6,5);
%       end
%        snapnow();close all ;  
      end
   end
  
   id=fopen('DSP_Rayleight_2017.dat','w+')
   
   size(Rayleigh)
   for i=1:1:size(Rayleigh,1)
       fprintf(id,'%d %f %f %f %f %f %f\n',Rayleigh(i,1:7))
   end
   fclose(id)
   
  id=fopen('DSP_o3abosrption_2017.dat','w+')
   
   size(O3absorption)
   for i=1:1:size(O3absorption,1)
       fprintf(id,'%d %f %f %f %f %f %f\n',O3absorption(i,1:7))
   end
   fclose(id)
   
  id=fopen('DSP_SO2absorption_2017.dat','w+')
   
   size(SO2absorption)
   for i=1:1:size(SO2absorption,1)
       fprintf(id,'%d %f %f %f %f %f %f\n',SO2absorption(i,1:7))
   end
   fclose(id)