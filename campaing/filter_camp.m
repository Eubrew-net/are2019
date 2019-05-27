clear all;  
addpath(genpath('../matlab'));
file_setup='arenos2019_setup.m';
run(fullfile('..',file_setup))%  configuracion por defecto
filter=load(fullfile('..',Cal.file_save),'filter');
%Cal.n_inst=find(Cal.brw==185);


%
media_fi={}; table_filter={};
filter_by_year=[];
   for i=1:Cal.n_brw
       Cal.n_inst=i;
       filter_by_year=[];
       %[config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
       m=filter.filter{i};
      if ~isempty(m)
       media_fi{i}=m.media_fi;
       try
        fi=reshape(m.fi_avg(:,5:end),[],15,6);
        fech=datevec(m.fi_avg(:,1));
        ref=fi(:,4:2:end,2:end);
        f=[];f(6,5)=NaN;
        for j=1:6 % slits
         [fx,s,n,y]=grpstats(squeeze(ref(:,j,:)),fech(:,1));
         year=cellfun(@(x) str2num(x),y);
         s=[repmat([Cal.brw(i),0,0,365,j],size(year)),round(fx)];
         s(:,2)=year;
         filter_by_year=[filter_by_year;s];
        end
       catch
           disp('error');
           disp(Cal.brw(i));
       end
      else
        media_fi{i}=NaN*ones(6,5);
      end
      if ~isempty(filter_by_year)
       table_filter{i}=array2table(filter_by_year,'VariableNames',{'BRW','YEAR','DAY0','DAYEND','SLIT','AT_FL1','AT_FL2','AT_FL3','AT_FL4','AT_FL5'});
      else
       table_filter{i}=cell2table(cell(0,10),'VariableNames',{'BRW','YEAR','DAY0','DAYEND','SLIT','AT_FL1','AT_FL2','AT_FL3','AT_FL4','AT_FL5'});
      end
       snapnow();close all ;                 
   end
   %printfiles_append(f,gcf,'HG_2015_report');
   WN=[302.1,306.3,310.1,313.5,316.8,320.1];
   lamda=[3032.06 3063.01 3100.53 3135.07 3168.09 3199.98];
   WN=[302.1,306.3,310.1,313.5,316.8,320.1];
      for i=1:Cal.n_brw
          nhead=repmat(Cal.brw(i),1,5);       
          dlmwrite('Filter_spectral_2019.csv',[nhead;media_fi{i}],'-append','delimiter',',','precision','%.8f')  
          writetable(table_filter{i},sprintf('Filter_spectral_%03d.csv',Cal.brw(i)))
      end
