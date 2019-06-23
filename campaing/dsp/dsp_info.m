file_setup='arenos2019_setup';

run(fullfile('..','..',file_setup)); 
startup;

dsp_quad={};
dsp_cubic={};
dsp_salida={};
dsp_sum={};
dsp_sum{Cal.n_brw}=[];

%%

label_s={'slit\#0','slit\#1','slit\#2','slit\#3','slit\#4','slit\#5'};
label_d={'WL(A)';'Res(A)';'O3abs(1/cm)';'Ray abs(1/cm)';'SO2abs(1/cm)'};
label_r={'step','O3abs','Rayabs','SO2abs','O3SO2Abs'};
label_res=['Brw','Q','year','day',label_r,'I0','Daumont','Bremen','Bodhaine'];

label_cfg={'Brw','year','day','Calc-step', 'O3abs coeff.', 'SO2abs coeff.', 'O3/SO2'};
label_d= {'Brw','year','day','Calc-step', 'O3abs coeff.', 'dO3/step', 'Dstep'};


for i=1:Cal.n_brw
    
    Cal.n_inst=i;



disp(Cal.brw_str(Cal.n_inst))
date_range=datenum(2017,5,1);
dsppath=fullfile(Cal.path_root,'dsp');

dsp_quad{Cal.n_inst}=[];
dsp_cubic{Cal.n_inst}=[];
dsp_salida{Cal.n_inst}=[];
dsp_sum{Cal.n_inst}=[];
%dsp_sum ¿?
try
[dsp_quad{Cal.n_inst}, dsp_cubic{Cal.n_inst},dsp_sum{Cal.n_inst}]=...
 read_dsp_info(dsppath,'brwid',Cal.brw_str{Cal.n_inst},'inst',Cal.n_inst,'configs',Cal.brw_config_files,'date_range',date_range);
catch 
  disp(Cal.brw_str(Cal.n_inst))
  disp('error')
end

     %     disp(Cal.brw_name{Cal.n_inst})
%     dsp_salida{Cal.n_inst}{end}.CUBIC{end-1}
%     dsp_salida{Cal.n_inst}{end}.CUBIC{end-1}.resumen
%     
% end
end
%%
dsp_r={};dsp_t=[];
table_check=[];
for i=1:Cal.n_brw
      Cal.n_inst=i;
      %round(res{t}(end-1,:,1)*10^4)/10^4
     [config_def,TCdef,DTdef,ETCdef,A1def,ATdef]=read_icf(Cal.brw_config_files{Cal.n_inst,2});
     [config_orig,TCorig,DTorig,ETCorig,A1orig,ATorig]=read_icf(Cal.brw_config_files{Cal.n_inst,1});
     dsp_ini=[Cal.brw(i),year(config_orig(1)),diaj(config_orig(1)),config_def(14),A1orig'];
     %dsp_fin=[Cal.brw(i),year(config_def(1)),diaj(config_def(1)),config_def(14),A1def'];
     dsp_t=[dsp_t;dsp_ini];
     c=[];q=[];
    try
     for j=1:length(dsp_sum{i})
%    
  
       dspx=dsp_sum{i}{j};
       do3s=median(diff(dspx.res(1:end-2,2,1)));
       ds=(dspx.res(end-1,2,1)-A1orig(1))/median(diff(dspx.res(1:end-2,2,1)));
       
       table_c=[dspx.brewnb,dspx.year,dspx.day,round([dspx.res(end-1,1:2,1),do3s]*10^4)/10^4,A1orig(1),ds];
       if dspx.year==19
           table_check=[table_check;table_c];
       end
       q=[q;[dspx.brewnb,1,dspx.year,dspx.day,round(dspx.res(end-1,:,1)*10^4)/10^4]];
       c=[c;[dspx.brewnb,2,dspx.year,dspx.day,round(dspx.res(end-1,:,2)*10^4)/10^4]];
       
     end
      dsp_r{i,1}=array2table([q],'VariableNames',str2var(label_res));
      dsp_r{i,2}=array2table([c],'VariableNames',str2var(label_res));
    catch
       disp('ERROR')
       disp(i)
    end



   


end
label_d= {'Brw','year','day','Calc-step', 'O3abs coeff.', 'dO3/step','O3abs Op','Dstep'};
array2table(dsp_t,'VariableNames',str2var(label_cfg))

table_dsp_check=array2table(table_check,'VariableNames',str2var(label_d))
writetable(table_dsp_check)
 
%% Example 5: using string data that includes LaTex code in a MATLAB table
% Clear the selected options from previous example
clear input;
% Please note: Make sure to enclose your LaTex code parts in $-environments!
% e.g if you want to have a '\pm' for plotting a plus-minus symbol your code
% should be '$\pm$'
% Set up data and store it in a MATLAB table
input.data = table_dsp_check;
% Switch transposing/pivoting your table if needed:
input.transposeTable = 0;
% Switch to generate a complete LaTex document or just a table:
input.makeCompleteLatexDocument = 0;
% Now call the function to generate LaTex code:
latex = latexTable(input);
 
 
 
Cal.brw(find(cellfun('isempty',dsp_r(:,1))))
