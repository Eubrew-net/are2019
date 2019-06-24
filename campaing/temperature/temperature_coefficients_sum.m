 run('../../arenos2019_setup.m')
 s=load('temperature.mat','tmp')
 temperature=s.tmp
  tc=nan*ones(7,4,Cal.n_brw);
  for i=1:20,
      try 
          tc(:,:,i)=temperature{i}.ajuste{2}.new;
           Cal.n_inst=i;   
          slope_old{i}=round(temperature{Cal.n_inst}.ajuste{2}.orig(end,2),1);
          slope_new{i}=round(temperature{Cal.n_inst}.ajuste{2}.new(end,2),1);

         subplot(5,4,i)
         [c,t]=hist(temperature{Cal.n_inst}.sl_raw(:,4),10);
         bar(t,c/sum(c));
         set(gca,'Ylim',[0,0.8])
         set(gca,'Xlim',[0,50])
         title(Cal.brw_str(i))

         t_range=range(t);
         t_int{i}=num2str(round([t(1),t(end)]));


          
          
          
          
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
 
 
 
 