
clear all;
file_setup='arenos2019_setup';
run(fullfile('..',file_setup));     % configuracion por defecto

for ii=1:Cal.n_brw-1
    disp(ii)
    Cal.n_inst=ii;
    disp(Cal.brw_str(ii))
    
    
    [config_def,TCdef,DTdef,ETCdef,A1def,ATdef]=read_icf(Cal.brw_config_files{Cal.n_inst,2});
    [config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
    
    Station.OSC=680;
    Station.name='';
    Station.lat=67;
    Station.long=50;
    Station.meanozo=350;
    
    cal_step{ii}={}; sc_avg{ii}={}; sc_raw{ii}={}; Args{ii}={};
    
    %% Sun_scan: Before Campaign
    try
    disp('Station')
     close all
         [cal_step{ii,1},sc_avg{ii,1},sc_raw{ii,1},Args{ii,1}]=sc_report(Cal.brw_str{Cal.n_inst},Cal.brw_config_files{Cal.n_inst,1},...
         'date_range',datenum(Cal.Date.cal_year,1,[1,Cal.calibration_days{Cal.n_inst,1}([1])]),...
         'CSN_orig',config_orig(14),'OSC',Station.OSC,...
         'control_flag',0,'residual_limit',55,...
         'hg_time',45,'one_flag',0,'data_path',fullfile(Cal.path_root,['bdata',Cal.brw_str{ii}]));


%% campaing   
          disp('Campaing')
          [cal_step{ii,2},sc_avg{ii,2},sc_raw{ii,2},Args{ii,2}]=sc_report(Cal.brw_str{Cal.n_inst},Cal.brw_config_files{Cal.n_inst,2},...
         'date_range',datenum(Cal.Date.cal_year,1,Cal.calibration_days{Cal.n_inst,1}([1 end])),...
         'CSN_orig',config_def(14),'OSC',Station.OSC,...
         'control_flag',0,'residual_limit',55,...
         'hg_time',35,'one_flag',0);
    catch
        disp('Error')
    end


end
%% testing for data analisys
n_brw=20
res=NaN*ones(n_brw,3);

for ii=1:n_brw

x=cell2mat([sc_raw{ii,:}]);
disp(Cal.brw_str(ii))
%
try
y1=reshape(x',37,15,2,[]); % columnas,scan, scan up/scan dow, n obs
stp1=squeeze(y1(3,:,1,:)); %steps
stp2=squeeze(y1(3,:,2,:));
ms91=squeeze(y1(23,:,1,:)); %scan up MS9
ms92=squeeze(y1(23,:,2,:)); %scan dw
fecha=squeeze(y1(1,:,2,:));
%up/dow
figure
h1=plot(matadd(stp2,-stp2(8,:)),matadd(ms92,-ms92(8,:)),'-');
hold on
h2=plot(matadd(stp1,-stp1(8,:)),matadd(ms91,-ms91(8,:)),':');
xlabel('step')
title([Cal.brw_name{ii}, ': Ozone Ratio MS9 - MS9(ref) '])
ylabel('Log counts/sec')
legend([h1(1),h2(1)],{'up scan','dw scan'})
% average
ms9=(ms92(end:-1:1,:)+ms91)/2; % average (steps are inverted)
ms9x=[ms92(end:-1:1,:)-ms91];
[i,j]=find(abs(ms9x)>500);
ms9(i,j)=NaN;

     figure
     plot(matadd(stp1(:,:),-stp1(8,:)),100*matdiv(matadd(ms9(:,:),-ms9(8,:)),ms9(8,:)),'o')
     xlabel('step')
     title([Cal.brw_name{ii}, ': Ozone Ratio  MS9 % vs MS9(ref) '])
     ylabel('%')
     grid
     
j=abs(matadd(stp1(:,1),-stp1(8,1)))<7;
figure
%plot(matadd(stp1(j,:),-stp1(8,:)),100*matdiv(matadd(ms9(j,:),-ms9(8,:)),ms9(8,:)),'o')
%[r,p]=rline;
%idx=p(3,:)>0.8
%plot(matadd(stp1(j,:)),100*matdiv(matadd(ms9(j,:),-ms9(8,:)),ms9(8,:)),'o')
plot(stp1(j,:),100*matdiv(matadd(ms9(j,:),-ms9(8,:)),ms9(8,:)),'o')
[r,p]=rline;
%idx=abs(p(2,:))<0.8
% quadratic
q=polyfic(stp1(:,1)-stp1(8,1),100*matdiv(matadd(ms9(:,:),-ms9(8,:)),ms9(8,:)),2);
hold off
%figure
plot(p(1,:));
hold on
plot(q(2,:),'x');

grid
title([Cal.brw_name{ii},...
    sprintf(':  MS9(%%)/step m=%.2f 2*(sigma) %.3f',mean(p(1,:)),2*std(p(1,:)))]);
res(ii,:)=[mean(p(1,:)),2*std(p(1,:)),2*nanstd(q(2,:))]
catch
    disp(Cal.brw_str(ii))
    disp('ERROR')

end
end

%%
cal_step{cellfun(@isempty,cal_step)}=NaN*(ones(1,5))

%%
t_sc_before=array2table(cat(1,cal_step{:,1}),'Variablenames',{'Date','Calc_step','Calc_step_C1','Calc_step_C2','Calc_Step_set'},'Rownames',Cal.brw_str)

%%
t_sc_after=array2table(cat(1,cal_step{:,2}),'Variablenames',{'Date','Calc_step','Calc_step_C1','Calc_step_C2','Calc_Step_set'},'Rownames',Cal.brw_str)