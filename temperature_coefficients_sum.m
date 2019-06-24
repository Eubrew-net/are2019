 arenos2017_setup
 load('arenos_2017.mat','temperature')
  tc=nan*ones(7,4,Cal.n_brw);
  for i=1:21,
      try 
          tc(:,:,i)=temperature{i}.ajuste{2}.new;
      catch
          disp(i);
      end,
  end
  label1= {'slit#2','slit#3','slit#4','slit#5','slit#6','R5','R6'};
  label2={'a','a SE','b','b SE'};
  TC_are=array2table([Cal.brw',squeeze(tc(:,3,:))',squeeze(tc(:,4,:))'],...
     'VariableNames',varname([{'brw'},strcat(label1,{'TC'}),strcat(label1,{'TC_SE'})]),... 
     'RowNames',varname(Cal.brw_name));
 writetable(TC_are,'temperature_huelva2017.xls','WriteRowNames',1);
 writetable(TC_are,'temperature_huelva2017.csv','WriteRowNames',0);