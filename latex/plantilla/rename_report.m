function rename_report(brw)

% 11/11/2009 Juanjo: Cambio en el modo de trabajo. Ahora el directorio
%                    de trabajo ser? el de cada brewer (.../latex/###)
%                    La funci?n pasa a estar en /plantilla, y desde ah? se la llama 
% 
%                    Un s?lo input: el n?mero de brewer con el que se trabajar? 
% 

brewer_0='xxx';

if ~ischar(brw)
    brw=sprintf('%03d',brw);
end

 %  todos los archivos .tex
 s=dir(['*',brewer_0,'.tex']); s_tcp=dir(['*',brewer_0,'.bbl']);
 mkdir(fullfile('..',filesep(),brw));   mkdir(fullfile('..',filesep(),brw),[brw,'_figures']);
 copyfile('*.tex',['..',filesep(),brw]);  copyfile('*.bbl',['..',filesep(),brw]);   
%  copyfile('*.eps',fullfile('..',brw,[brw,'_figures'])); % copiamos tambi?n logos, pero al directorio de figuras

 latexFindReplace(fullfile('..',brw,['CALIBRATION_',brewer_0,'.tex']),brewer_0,brw);
      for i=1:length(s)
          sn=strrep(s(i).name,brewer_0,brw);
          movefile(fullfile('..',brw,s(i).name),fullfile('..',brw,sn));
      end
 latexFindReplace(fullfile('..',brw,['CALIBRATION_',brewer_0,'.bbl']),brewer_0,brw);
          sn_tcp=strrep(s_tcp.name,brewer_0,brw); [a b c]=fileparts(sn_tcp);
          movefile(fullfile('..',brw,s_tcp.name),fullfile('..',brw,[b,'.tcp']));
 latexFindReplace_graphs(['..',filesep(),brw,filesep(),'CALIBRATION_',brw,'.tex'],3,...
                         ['.',filesep(),brw,'_figures',filesep()]);               
 latexFindReplace_graphs(['..',filesep(),brw,filesep(),'FRONTPAGE','.tex'],3,...
                         ['..',filesep(),'plantilla',filesep()]);               

fclose all;
 
%cd ../..
