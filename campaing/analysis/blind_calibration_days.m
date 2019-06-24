%% matrix whith sync. data %% matrix whith sync. data BLIND DAYS
ref=[]; ref_std=[]; ref_sl=[]; ref_sza=[]; ref_flt=[];ref_ms9=[];
ref_time=[];  ratio_=[];ref_airm=[];ref_temp=[];ref_ms9u=[];
reftime=[];
for ii=orden
    % we removed filter#4 for initial status on brewer#066. 
    % Otherwise we do not applied any F corrs. for initial status evaluation
    % Except for reference instrument!!    
    if Cal.brw(ii)==185
       [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,ii,A,Cal.ETC_C{ii});
       summ_old=summary_old_corr;   
    else
       [summary_old_corr summary_corr]=filter_corr(summary_orig,summary_orig_old,ii,A,[0,0,0,0,0,0]);
       summ_old=summary_old_corr;  
    end
         
     blinddays=Cal.calibration_days{ii,3}; % blind days
      
     jday=findm(diaj(summ_old(:,1)),blinddays,0.5);
     summ_old=summ_old(jday,:);
     
    %redondeamos la medida cada 10 minutos
     TSYNC=10;
     time=([round(summ_old(:,1)*24*60/TSYNC)/24/60*TSYNC,summ_old(:,1)]); 
     [ref_time,iii,jj]=unique(time(:,1));
     try
       [media,sigma,ndat]=grpstats(summ_old,jj);      
     catch
       media=summ_old;
     end
     med=media(:,[1 6]); %
     meds=media(:,[1 7]); % std
     med_sl=media(:,[1 12]); %SL corrected;
     med_sza=media(:,[1,2]);
     med_flt=media(:,[1,5])/64;
     med_airm=media(:,[1,3]);
     med_temp=media(:,[1,4]);
     med_ms9=media(:,[1,8]);
     med_ms9u=media(:,[1,9]);
     
     med(:,1)= ref_time(:,1); 
     meds(:,1)=med(:,1);
     med_sl(:,1)=med(:,1);
     med(:,1)=med(:,1);
     med_sza(:,1)=med(:,1); med_flt(:,1)=med(:,1);
     med_airm(:,1)=med(:,1);    
     med_temp(:,1)=med(:,1);     
     med_ms9(:,1)=med(:,1);
     
     reftime=scan_join(reftime,time); 
     ref=scan_join(ref,med);
     ref_std=scan_join(ref_std,meds);
     ref_sl=scan_join(ref_sl,med_sl);
     ref_sza=scan_join(ref_sza,med_sza);
     ref_flt=scan_join(ref_flt,med_flt);
     ref_airm=scan_join(ref_airm,med_airm);
     ref_temp=scan_join(ref_temp,med_temp);
     ref_ms9=scan_join(ref_ms9,med_ms9);
     ref_ms9u=scan_join(ref_ms9,med_ms9u);
end 

%% general view
cab_brw=['Fecha, sza, airm, o3#185 o3,	o3#inst, o3_std#inst ,	o3_sl#inst, flt#inst ,	temp#inst, ms9#inst'];	
head=mmcellstr(cab_brw,',');
for ii=1:Cal.n_brw
    Cal.brw_name{orden(ii)}
    auxb=[ref(:,1),ref_sza(:,2),ref_airm(:,2),ref(:,2),...
     ref(:,ii+1),ref_std(:,ii+1),ref_sl(:,ii+1),ref_flt(:,ii+1),ref_temp(:,ii+1),ref_ms9(:,ii+1)];
    t=array2table(auxb,'VariableNames',varname(head),'RowNames',cellstr(datestr(auxb(:,1))));
    try
     writetable(t,['are2017_blind_','.xls'],'Filetype','spreadsheet','Sheet',Cal.brw_name{orden(ii)},'WriteRowNames',true)
    catch
    writetable(t,['are2017_blind_','.csv'],'Filetype','text','WriteRowNames',true)
    end
end

%%
aux=[ref(:,1),ref_sza(:,2),ref_airm(:,2),ref(:,2:end),ref_std(:,2:end),ref_sl(:,2:end),ref_flt(:,2:end),ref_temp(:,2:end)];
aux=sortrows(aux,1);

%Fecha	sza	airm	#006	#037	#107	#185	#006	#037	#107	#185	#006	#037	#107	#185
%cab_brw='Fecha sza airm o3#185 o3#017	o3#107	o3#185	std_o3#006	 std_o3#037   std_o3#107	std_o3#185  filt#006	filt#037	filt#107	filt#185';

l0={'Fecha','sza','airm'};
l1=cellfun(@(x) strcat('o3#',x),Cal.brw_str(orden)','UniformOutput',false);
l1b=cellfun(@(x) strcat('std_o3#',x),Cal.brw_str(orden)','UniformOutput',false);
l2=cellfun(@(x) strcat('sl#',x),Cal.brw_str(orden)','UniformOutput',false);
l3=cellfun(@(x) strcat('F#',x),Cal.brw_str(orden)','UniformOutput',false);
l4=cellfun(@(x) strcat('t#',x),Cal.brw_str(orden)','UniformOutput',false);
head=[l0,l1',l1b',l2',l3',l4'];

t_blind=array2table(aux,'VariableNames',varname(head),'RowNames',cellstr(datestr(aux(:,1))));
try
 writetable(t_blind,['table_final_','.xls'],'Filetype','spreadsheet','WriteRowNames',true)
catch
     writetable(t_blind,['table_final_','.csv'],'Filetype','text','WriteRowNames',true)
end   
xlswrite(sprintf('RBCC_brewer_%04d',Cal.Date.cal_year),head);
aux(:,1)=m2xdate(aux(:,1));
xlswrite(sprintf('RBCC_brewer_%04d',Cal.Date.cal_year),aux,'','A2');
%save ref ref
save orden orden
sumold_all=struct('ozone',ref,'ozone_sl',ref_sl,'sza',ref_sza,'flt',ref_flt,'airm',ref_airm,'temp',ref_temp,'ms9',ref_ms9,'ms9u',ref_ms9u)
save(sprintf('RBCC_brewer_%04d',Cal.Date.cal_year),'sumold_all');

%array2table(aux,'VariableNames',str2var(head))
