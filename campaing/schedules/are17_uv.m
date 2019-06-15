%%Create schedules for Absolute Caliration
clear
skd={};
szameth=3;%uses same sza calculation as Brewer (routines zeit2sza.m and sza2zeit.m)

% Arenosillo data
lats= 37.1 ;longs= -6.73;
%Arosa
%longs=9.6754;   %   /* Longitude of LKO Arosa */
%lats=46.7828;      %    /* Latitude of LKO Arosa  */
%iza?a data
%lats=28.3081  ;longs=-16.4992  ;
% sodankyla
%longs=26.6337;lats=67.3686;alts=0.179;

path{1}=fullfile(pwd(),'are17_uv','extended');
mkdir(path{1});
path{2}=fullfile(pwd(),'are17_uv','notextended');
mkdir(path{2});


% figures
figure;
orient landscape;
print -dpsc schedule_sc


% two types of instruments
instr1=1;instr2=2;
%1=#185 Izana (& Double Canada #085)
%2=single brewer

% fecha
nntag1=datenum(2017,05,31);
nntag2=datenum(2017,06,11);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% indices de las medidas
routinds=[ 1  ; 2  ; 3  ; 4  ; 5  ; 6  ; 7  ; 8  ; 9  ; 10 ; 11 ; 12 ; 13 ;...
    14 ; 15 ; 16 ; 17 ; 18 ; 19 ; 20 ; 21 ; 22 ; 23 ; 24 ; 25 ; 26 ;...
    27 ; 28 ; 29 ; 30 ;  31; 32;  33;  34; 35  ;36  ;37  ; 38 ; 39;....
    40 ; 41 ; 41 ; 42 ; 43 ; 44 ; 45 ; 46 ; 47 ; 48 ; 49    ];
%   ke','kf';kg  ;kh  ; sf ; af ;an  ;dz  ; ak ; ak ; nt
%   40 ; 41 ; 41 ; 42 ; 43 ; 44 ; 45 ; 46 ; 47 ; 48 ; 49 ];
% simbolos para el plot
routsimb=[' o';' o';' +';' +';' +';' +';' +';' x';' x';' +';' +';' o';' o';...
    ' +';' +';' o';' x';' +';' +';' +';' o';' +';' +';' o';' +';' +';...
    ' +';' +';' +';' +';' *';' *';' *';' *';' o';' o';' +';' +';' +';...
    ' +';' +';' +';' +';' o';' .';' .';' x'];
% color para el plot
routcolo=[' k';' b';' y';' y';' g';' g';' g';' r';' m';' c';' c';' m';' r';...
    ' m';' +';' m';' r';' c';' c';' y';' o';' +';' c';' o';' g';' g';...
    ' g';' g';' g';' g';' c';' c';' c';' c';' r';' r';' r';' r';' r';...
    ' r';' r';' r';' r';' b';' c';' c';' g';' c';' c';' g'];
 %   ke','kf';kg  ;kh  ; sf ; af ;an  ;dz  ; ak ; ak ; nt
 %   40 ; 41 ; 41 ; 42 ; 43 ; 44 ; 45 ; 46 ; 47 ; 48 ; 49 ];

% codigo para las medidas
 routnams=['ds';'zs';'hp';'hg';'sl';'rs';'dt';'ux';'ss';'td';'b1';'fm';'sc';...
%routinds=[ 1  ; 2  ; 3  ; 4  ; 5  ; 6  ; 7  ; 8  ; 9  ; 10 ; 11 ; 12 ; 13 ;...
         'fv';'ni';'uv';'uf';'b2';'pd';'hg';'um';'hl';'fz';'gi';'ap';'po';...
    %     14 ; 15 ; 16 ; 17 ; 18 ; 19 ; 20 ; 21 ; 22 ; 23 ; 24 ; 25 ; 26 ;...
        'ci';'fi';'hs';'w1';'ck';'ck';'te';'ck';'ua' ;'ua';'kb';'kc';'kd';...
%        27 ; 28 ; 29 ; 30 ;  31; 32;  33;  34 ; 35  ;36  ; 37 : 38 ; 39; 40];
        'ke';'kf';'kg';'kh';'sf';'af';'an';'dz';'ak';'ak';'nt'];
 %       40 ; 41 ; 41 ; 42 ; 43 ; 44 ; 45 ; 46 ; 47 ; 48 ; 49 ];
% tiempo de las medidas
%routinds=[ 1  ; 2  ; 3  ; 4  ; 5  ; 6  ; 7  ; 8  ; 9  ; 10 ; 11 ; 12 ; 13 ;...
 routzeit=[ 3.5 ; 5  ; 2  ; 7  ; 10 ; 10;  12 ; 8  ;  8 ;  0 ;  0 ; 16 ; 13 ;...
 %routnams=['ds';'zs';'hp';'hg';'sl';'rs';'dt';'ux';'ss';'td';'b1';'fm';'sc';...
    2   ;17 ;  6  ;  4 ;  0 ;  0 ;  9 ; 9 ; 10  ; 3  ;  4 ; 0.5; 0.5;...
  % fv';'ni';'uv' ;'uf';'b2';'pd';'hg';'um';'cz';'fz';'gi';'ap';'po';...
  % 14 ; 15 ; 16 ; 17 ; 18 ; 19 ; 20 ; 21 ; 22 ; 23 ; 24 ; 25 ; 26 ;...
    
    10 ;120  ;10  ;5   ; 0.5; 0  ; 0.5 ;1   ;9   ;5    ;5  ; 9  ; 13 ;...
%  'ci';'fi';'cz';'w1';'ck';'ck';'te';'ck';'ua' ;'ua'; kb ; kc ; kd ;...
%   27 ; 28 ; 29 ; 30 ;  31; 32;  33;  34 ; 35  ;36  ;37  ; 38 ; 39  ;...
    17 ; 27 ;35  ;42  ; 10 ;0 ;0  ; 3 ; 8  ;  4 ; 4 ];
%   ke','kf';kg  ;kh  ; sf ; af ;an  ;dz  ; ak ; ak ; nt
%   40 ; 41 ; 41 ; 42 ; 43 ; 44 ; 45 ; 46 ; 47 ; 48 ; 49 ];

%1-ozone ds,2-ozone zs, 3- fz,4-uq, 5 uv, 6-sl ,7-hg, 8-test, 9-syn  10-sc
%grupos para el plot

routgrp =[ 1   ; 2  ; 8  ; 7  ; 6  ; 8   ; 8 ; 5  ; 5  ; 9  ; 8  ; 8  ; 8  ;...
    8   ; 8  ; 5  ;   5 ; 8  ; 8  ; 7 ; 11  ; 8  ; 3  ; 4  ; 8  ; 8 ;...
    8   ; 8  ; 8  ; 8  ;  9  ; 9  ; 9 ;9    ;5   ;5   ;11  ;11 ;11  ;...
    11  ; 11 ;11  ;11 ;10; 9; 9; 3; 9; 9; 3];

routgrps=['ds  ';'zs  ';'fz  ';'uq  ';'uv  ';'sl  ';'hg  ';'test';'sy  ';'sc  ';'um  '];
routplt= ['k'   ;'b'   ;'m'   ;'m'   ;'r'   ;'b'   ;'y'   ;'c'   ;'g'   ;'g';'k'];
routgrpi=1:11;
pauszeit=1;%1min pause

skd_config=[num2cell(routinds),cellstr(routnams),num2cell(routzeit),cellstr(routgrps(routgrp,:)),...
            num2cell(routgrp),cellstr(routplt(routgrp)),cellstr(routcolo)]
% notes

% b2zssl  ---> 10 min
pulkstr_instr={};

umk_angles=[90 89 88 86.5 85 84 83 80 77 75 74 70 65 60];


%sza where pulks are changing


%linkTopAxisData(h1(1:end-1),szac(1:end-1))

%% solar zenit angle and time information


sza_test=[95:-.25:1;1:.25:95]'; % 6.3 is the solar zenith angle change for half an hour at iza?a
idx=0;
figure;
 for fecha=fix([mean([nntag1,nntag2])])
    idx=idx +1; 
    table{idx}=[];   
    [szax,sazx,tstx,snoon,sunrise,sunset,m2,m3]=sun_pos(fecha,lats,longs);
   %noon
   [szax,sazx,tstx,snoon,sunrise,sunset,m2,m3]=sun_pos(fix(fecha)+snoon/60/24,lats,longs);
 
    %szac(find(szac(:,1)<szax),1)=szax;
    %szac(find(szac(:,2)<szax),2)=szax;
 
     %szac=[95:-5:szax;szax:5:95]';
     %h1=[sza2zeit(fecha,szac(:,1),0,lats,longs,1);snoon/60;sza2zeit(fecha,szac(:,2),1,lats,longs,1)];
     %sz_=[szac(:,1);szax;szac(:,2)];
     h1=[sza2zeit(fecha,sza_test(:,1),0,lats,longs,1);sza2zeit(fecha,sza_test(:,2),1,lats,longs,1)];
     sz_=[[sza_test(:,1),-ones(size(sza_test(:,1)))];[sza_test(:,2),ones(size(sza_test(:,1)))]];
     h1(h1==-9999.0)=0;
     [h1,i]=unique(h1);
     sz_=sz_(i,:);
     
     jnan=find(h1==-9999);
     haux=h1;haux(jnan)=NaN;
     s=diff(haux); %speed of sun
     aux=(fecha+h1/24);
     [ax,bx,cx]=sza(aux,lats,-longs);
     table_=[aux,h1,sz_,[s;NaN]*60,ax,bx,cx];
     %table_(jnan,:)=NaN;
     table{idx}=unique(table_,'rows');
     gscatter(haux,sz_(:,1),sz_(:,2));hold on;
 end
 
 %%
 f1=figure
 plot(table{1}(:,2),table{1}(:,3),'.-');hold on;
  %plot(table{2}(:,2),table{2}(:,3),'r.-');
 axis('tight');
 xl=get(gca,'Xtick')
 yn=interp1(table_(:,2),table_(:,7),xl)
 linktopaxisdata(xl,round(yn*100)/100);
 %%
 f2=figure;
 h=plot(table{1}(:,1),table{1}(:,7),'.-');hold on;
 set(gca,'Xlim',fecha+[0.2,0.8]);
 set(gca,'Ylim',[1,5]);
 %axis('tight');
 datetick('keeplimits','keepticks');
 
 addtopxaxis('expression','zeit2sza(argu,lats,longs,3)','xLabStr','Huelva 2013 15 Jun Solar zenit angle');
 %h=plot(table{1}(:,2)/24+nntag1,table{1}(:,7),'r.-');
 %h=plot(table{3}(:,2)/24+nntag1,table{3}(:,7),'b.-');
 box on;
 
 xlabel('time')
 ylabel('Air mass')
%% DEFINICION DE LAS  MEDIDAS EN INTERVALOS
% Langley)
% G0 10  BEFORE 92  -test -a 
% G1 1    93-85- > test and zs no ds possible  145 min
% G2 2    82-80- > Long airmass measurements   
% G3 3/4  -13/14    80-75 low sun highair mass mesurements
% G4 -60 -> 60   
%        5 -14     grueso de las medidas with/whiout uv  
%        6 >60   -> SL
%        7 >60   -> SC
% G5   13/14 
% G6   12
% G7   11
% G0
% 8 y 9  medio dia
% 18 y 19  29 libres 
% 10 Principio y finasl del dia (test)
szac=[95,90,NaN,85,85,90,NaN,95];
% by definition include noon
%szac(5)=szac(4);
%szac(6)=szax;
% figure(f1);
% hline(szac);
% 
% j=findm(table{1}(:,3),szac,0.1);
% vline(table{1}(j,2),':b')
% j=findm(table{1}(:,3),szac,0.1);
% vline(table{1}(j,2),':r')
%disp('test')
%% usefull functions for definitions
% time s total time of the group
time_s=inline ('sum(time_rtn(rtn_def(rtn_def>0)))','time_rtn','rtn_def');
% rtn2num (string,routnames,routzeit)
%  input a normal string output  commands nums and time
figure;
for instr=instr1:instr2

    %construct measurement groups for each instrument
    npulks=19; % numero de intervalos
    pulkinds=[1:npulks]';
    pulkrout=cell(npulks,1);
    pulkadds=cell(npulks,1);

    % reference instrument

    if instr==1
        instnam='a';

        % First group am /pm
         %pulkrout{1}=[ 3    11    -16     4  8  18     -2     5   34  ];%[10,19,3,11,-23,4,42,-21];%85<sza<92
         %pulkrout{11}=[ 3    11    -16     4  8   18     -2     5  34  ];%[10,19,3,11,-23,4,42,-21];%85<sza<92
         
         %umkher
         %pulkrout{1}=[ 3    11    -16     4  37 21  18     -2     5   34  ];%85<sza<92
         %pulkrout{11}=[ 3    11    -16     4  37 21   18     -2     5  34  ];%85<sza<92
         
         %
         pulkrout{1}=[  3 4 8  3  4     18     -2     5  2  2    ];%85<sza<92
         pulkrout{11}=[ 3 4 8  3  4     18     -2     5  2  2    ];%85<sza<92
         
        straux=cellstr(routnams(abs(pulkrout{1}),:))';
        %[a,b,c]=comands2num(straux,routnams,routzeit)
        reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(1))
        
        disp(straux)
        disp(reference_time)
        
        pulkrout{2}=  [ 3 4  8  3 4    18     -2     5  2  2   ];%85<sza<92
        pulkrout{12}= [ 3 4  8  3 4    18     -2     5  2  2 ];%85<sza<92
        
        
        %pulkraout{2}=[10,19,23,23,23,3,11,-1,4,1, 34 ];
        %pulkrout{12}=[10,19,1,3,11,-1,4,23,23,23,34];

        straux=cellstr(routnams(abs(pulkrout{2}),:))';
        reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(2));
        disp(straux)
        disp(reference_time)
        
                       
        % sync uv
        % pulkrout{3}=[10,35,3,11,-1,4,1,1,1];%70<sza<60 sl
        % pulkrout{4}=[10,35,3,11,-1,4,18,-1,5,31];%70<sza<60 sl

        % Third group
        %umkher
        %pulkrout{3}=[10,19,3,11,-1,4,37,-21,1,37,-21,1,37,-21,31];%70<sza<60   sin sl pm
        %pulkrout{4}=[3,11,-1,4,1,37,-21,18,-2,5,1,31];%70<sza<60 sl
        %pulkrout{13}=[10,19,3,11,-1,4,37,-21,1,37,-21,1,37,-21,31];%70<sza<60   sin sl pm
        %pulkrout{14}=[3,11,-1,4,1,37,-21,18,-2,5,1,31];%70<sza<60 sl   
        %langley 
        pulkrout{3}=[10,45,3,11,-1,-14,4,46,1,1,1,1,1];  %langley -> ds
        pulkrout{4}=[10,45,3,11,-1,-14,4,46,18,-1,1,5,1];%   langley sl
        %pulkrout{4}=[3,11,-1,4,13,3,11,-1,4];              % langley %sza<75 sun scan
        
        pulkrout{13}=[10,45,3,1,11,-1,-14,4,1,1,1,1];%70<sza<60   sin sl pm
        pulkrout{14}=[10,45,3,11,-1,-14,4,46,18,-1,1,5,1];%70<sza<60 sl
        %pulkrout{14}=[3,11,-1,4,13,3,11,-1,4];   
        for jj=[3,4,13,14]
              straux=cellstr(routnams(abs(pulkrout{jj}),:))';
              reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(jj));
              straux=[num2str(jj),straux,num2str(reference_time)]
        end
%%
%% Fourth group
%
%          pulkrout{5}=[10,1,1,1,3,11,-1,-14,4,1,1,1,1,1,1];%sza<75 nomral
%          pulkrout{6}=[10,1,1,1,3,11,-1,-14,4,18,-1,5,1,1,1,1];%sza<75 sl
%          pulkrout{7}=[10,1,1,1,3,11,-1,-14,4,1,1,1,1,1,1,1];%sza<75 sc (falta)
%          
%          pulkrout{15}=[10,1,1,1,3,11,-1,-14,4,1,1,1,1,1,1,1];%sza<75 nomral
%          pulkrout{16}=[10,1,1,1,3,11,-1,-14,4,18,-1,5,1,1,1,1];%sza<75 sl
%          pulkrout{17}=[10,1,1,1,3,11,-1,-14,4,1,1,1,1,1,1,1];%sza<75 sc
% %         
%         
%
%uv 40 min       
%         pulkrout{5}=[10,19,1,1,36,11,-1,4,1,1,1,1,1,32,25];%sza<75 nomral
%         pulkrout{6}=[10,19,1,1,36,11,-1,4,1,18,-1,5,1,14,31];%sza<75 sl
%         pulkrout{7}=[1,3,11,-1,4,13,3,11,-14,4,1];%sza<75 sun scan     
%         pulkrout{15}=[10,19,1,1,36,11,-1,4,1,1,1,1,1,32,25];%sza<75 nomral
%         pulkrout{16}=[10,19,1,1,36,11,-1,4,1,18,-1,5,1,14,31];%sza<75 sl
%         pulkrout{17}=[1,3,11,-1,4,13,3,11,-14,4,1];%sza<75 sun scan
% uv 30 m
        pulkrout{5}=[10,35,3,45,11,-1,4,46,1,1,1];%sza<75 nomral
        pulkrout{6}=[10,35,3,45,11,-1,4,46,18,-1,5];%sza<75 sl
        pulkrout{7}=[3,11,-1,4,48,3,11,-14,4];%sza<75 sun scan     
        pulkrout{15}=[10,35,3,45,11,-1,46,4,1,1,1];%sza<75 nomral
        pulkrout{16}=[10,35,3,45,11,-1,46,4,18,-1,5];%sza<75 sl
        pulkrout{17}=[3,11,-1,4,48,3,11,-14,4];%sza<75 sun scan
% uv 60 m
      %  pulkrout{5} =[10,35,45,11,-1,-14,4,46,1,1,1,1,1,1,1,1,1,1,1,1];%sza<75 nomral
      %  pulkrout{6} =[10,35,45,11,-1,-14,4,1,18,-1,5,46,1,1,1,1,1,1,1,1];%sza<75 sl
      %  pulkrout{7} =[10,35,45,11,-1,-14,4,13,3,11,-14,4,46,1,1,1,1,1,1];%sza<75 sun scan     
      %  pulkrout{15}=[10,35,45,11,-1,-14,4,46,1,1,1,1,1,1,1,1,1,1,1,1];%sza<75 nomral
      %  pulkrout{16}=[10,35,45,11,-1,-14,4,1,18,-1,5,46,1,1,1,1,1,1,1,1];%sza<75 sl
      %  pulkrout{17}=[10,35,45,11,-1,-14,4,13,3,11,-14,4,46,1,1,1,1,1,1];%sza<75 sun scan

      for jj=[5,6,7,15,16,17]
              straux=cellstr(routnams(abs(pulkrout{jj}),:))';
              reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(jj));
              straux=[num2str(jj),straux,num2str(reference_time)]
      end
        
        
       
        % fiveth group -> moon measurements
        pulkrout{8}=[3,11,-1,4,48,3,11,-14,4];
        pulkrout{18}=[];
        
        pulkrout{9}=[];
        pulkrout{19}=[];
        
        % Begining and end
        pulkrout{10}=[19,31,10,3,4,5,7,6,25,26,18,30,27,29,10,19,15,28,31,33];%beginning and end
        elap_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(10)) 
        straux=cellstr(routnams(abs(pulkrout{10}),:))' 

        reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout);
        c=cellfun(@(x) cellstr(routnams(abs(x),:))',pulkrout,'UniformOutput',0);
        %comandos de cada grupo
        reference_time2{instr}=reference_time;
        table_deff{instr}=c;
        time_reference_am_pm{instr}=reference_time(1:9)-reference_time(11:19);





    end;
    %reference


    if instr==2
        instnam='b';
        % First group am /pm
        %pulkrout{1}=[     11    -16     4  17  18     -2     5  2  ];%[10,19,3,11,-23,4,42,-21];%85<sza<92
        %pulkrout{11}=[    11    -16     4  17  18     -2     5  2  ];%[10,19,3,11,-23,4,42,-21];%85<sza<92
        %umkher
        % pulkrout{1}=[ 3    11    -16     4  37 21  18     -2     5   34  ];%85<sza<92
        % pulkrout{11}=[ 3    11    -16     4  37 21   18     -2     5  34  ];%85<sza<92
        
         %
         pulkrout{1}=[ 4    17  11  4  18 -2  5  2  2 2 14 ];%85<sza<92
         pulkrout{11}=[ 4   17  11  4  18 -2  5  2  2 2 14 ];%85<sza<92
         
        straux=cellstr(routnams(abs(pulkrout{1}),:))';
        %[a,b,c]=comands2num(straux,routnams,routzeit)
        reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(1))
        
        disp(straux)
        disp(reference_time)
        
        pulkrout{2}=  [ 4  17  11        4    18     -2     5 2 2 2 14  ];%85<sza<92
        pulkrout{12}= [ 4  17  11       4    18     -2     5  2 2 2  14 ];%85<sza<92
        
        
        
        straux=cellstr(routnams(abs(pulkrout{2}),:))';
        reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(2));
        disp(straux)
        disp(reference_time-reference_time2{1}(2))
        
        
        % sync uv
        % pulkrout{3}=[10,35,3,11,-1,4,1,1,1];%70<sza<60 sl
        % pulkrout{4}=[10,35,3,11,-1,4,18,-1,5,31];%70<sza<60 sl
        
%%        % Third group
%ds  %langley 
        pulkrout{3}=[10,11,-1,14,4,1,1,1,1,1];  %langley -> ds
        pulkrout{4}=[10,3,11,-1,-14,4,18,-1,1,5,1];%   langley sl
        %pulkrout{4}=[11,-1,14,4,13,11,-1,14,4];              % langley %sza<75 sun scan
        
        pulkrout{13}=[10,1,11,-1,14,4,1,1,1,1];%70<sza<60   sin sl pm
        pulkrout{14}=[10,3,11,-1,-14,4,18,-1,1,5,1];%70<sza<60 sl
        %pulkrout{14}=[11,-1,14,4,13,11,-1,14,4];   
        
%%        
        for jj=[1,11,2,12,3,4,13,14]
              straux=cellstr(routnams(abs(pulkrout{jj}),:))';
              reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(jj));
              straux=[num2str(jj),straux,num2str(reference_time)]
        end
%%
disp('t');
%umkher
        %pulkrout{3}=[10,19,3,11,-1,4,37,-21,1,37,-21,1,37,-21,31];%70<sza<60   sin sl pm
        %pulkrout{4}=[3,11,-1,4,1,37,-21,18,-2,5,1,31];%70<sza<60 sl
        %pulkrout{13}=[10,19,3,11,-1,4,37,-21,1,37,-21,1,37,-21,31];%70<sza<60   sin sl pm
        %pulkrout{14}=[3,11,-1,4,1,37,-21,18,-2,5,1,31];%70<sza<60 sl
        
%         %langley
%         pulkrout{3}=[10,19,1,11,-1,4,1,1,1,1,1];  %langley -> ds
%         pulkrout{4}=[10,19,1,11,-1,4,1,18,-1,1,5,1];%   langley sl
%         %pulkrout{8}=[3,11,-1,4,13,3,11,-1,4];              % langley %sza<75 sun scan
%         
%         pulkrout{13}=[10,19,1,1,11,-1,4,1,1,1,1];%70<sza<60   sin sl pm
%         pulkrout{14}=[10,19,1,11,-1,4,1,18,-1,1,5,1];%70<sza<60 sl
%         %pulkrout{18}=[3,11,-1,4,13,3,11,-1,4];
%         for jj=[3,4,13,14]
%            straux=cellstr(routnams(abs(pulkrout{jj}),:))';
%            reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(jj))-reference_time2{1}(jj);
%            straux=[num2str(jj),straux,num2str(reference_time)]
%        end
        
        %% Fourth group
%          pulkrout{5}=[10,19,1,1,1,3,11,-1,-14,4,1,1,1,1];%sza<75 nomral
%          pulkrout{6}=[10,19,1,1,1,3,11,-1,-14,4,18,-1,5,1];%sza<75 sl
%          pulkrout{7}=[10,19,1,1,1,3,11,-1,-14,4,1,1,1,1];%sza<75 sc (falta)
%          
%          pulkrout{15}=[10,19,1,1,1,3,11,-1,-14,4,1,1,1,1];%sza<75 nomral
%          pulkrout{16}=[10,19,1,1,1,3,11,-1,-14,4,18,-1,5,1];%sza<75 sl
%          pulkrout{17}=[10,19,1,1,1,3,11,-1,-14,4,1,1,1,1];%sza<75 sc
%            
         
        %
        %uv 40 min
%                 pulkrout{5}=[10,19,1,1,36,11,-1,4,1,1,1,1,1,32,25];%sza<75 nomral
%                 pulkrout{6}=[10,19,1,1,36,11,-1,4,1,18,-1,5,1,14,31];%sza<75 sl
%                 pulkrout{7}=[1,3,11,-1,4,13,3,11,-14,4,1];%sza<75 sun scan
%                 pulkrout{15}=[10,19,1,1,36,11,-1,4,1,1,1,1,1,32,25];%sza<75 nomral
%                 pulkrout{16}=[10,19,1,1,36,11,-1,4,1,18,-1,5,1,14,31];%sza<75 sl
%                 pulkrout{17}=[1,3,11,-1,4,13,3,11,-14,4,1];%sza<75 sun scan
%         % uv 30 m
        pulkrout{5}=[10,36,11,-1,4,1,1,1,1,1,32,25];%sza<75 nomral
        pulkrout{6}=[10,36,11,-1,4,1,18,-1,5,1,-1,31];%sza<75 sl
        pulkrout{7}=[3,11,-1,4,13,3,11,-14,4];%sza<75 sun scan
        pulkrout{15}=[10,36,11,-1,4,1,1,1,1,1,32,25];%sza<75 nomral
        pulkrout{16}=[10,36,11,-1,4,1,18,-1,5,1,-1,31];%sza<75 sl
        pulkrout{17}=[11,-1,4,13,11,-14,4,1,33];%sza<75 sun scan

%         % uv 60 m
  %      pulkrout{5}=[10,36,11,-1,-14,4,1,1,1,1,1,1,1,1,1,1,1,1,1];%sza<75 nomral
  %      pulkrout{6}=[10,36,11,-1,-14,4,1,18,-1,5,1,-1,1,1,1,1,1,1,1,1];%sza<75 sl
  %      pulkrout{7}=[10,36,11,-1,-14,4,13,3,11,-14,4,1,1,1,1,1,1,1];%sza<75 sun scan
  %      pulkrout{15}=[10,36,11,-1,-14,4,46,1,1,1,1,1,1,1,1,1,1,1,1,1];%sza<75 nomral
  %      pulkrout{16}=[10,36,11,-1,-14,4,1,18,-1,5,1,-1,1,1,1,1,1,1,1,1];%sza<75 sl
  %      pulkrout{17}=[10,36,11,-1,-14,4,13,11,14,4,1,1,1,1,1,1,1];%sza<75 sun scan
%%       
        for jj=[1,11,2,12,3,4,13,14,5,6,7,15,16,17]
            straux=cellstr(routnams(abs(pulkrout{jj}),:))';
             elap_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(jj));
            reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout(jj))-reference_time2{1}(jj);
            straux=[num2str(jj),straux,num2str(elap_time),num2str(reference_time)]
        end
        
        
        
%%        % fiveth group -> moon measurements
        pulkrout{8}=[];
        pulkrout{18}=[];
        
        pulkrout{9}=[];
        pulkrout{19}=[];
        
        % Begining and end
        pulkrout{10}=[19,31,10,3,4,5,7,6,25,26,18,30,27,29,10,19,15,28,31,33];%beginning and end
        
        
        
        reference_time=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout);
        c=cellfun(@(x) cellstr(routnams(abs(x),:))',pulkrout,'UniformOutput',0);
        %comandos de cada grupo
        reference_time2{instr}=reference_time;
        table_deff{instr}=c;
        time_reference_am_pm{instr}=reference_time(1:9)-reference_time(11:19);
        
        disp('');
        % beginind and end
        %         pulkrout{10}=[19,31,10,3,4,5,7,6,25,26,18,30,27,29,10,19,15,28,18,30,15,31,33];%beginning and end
        %
        %
        %
        %         reference_time2=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout);
        %         diff_time{instr}=cellfun(@(x) sum(routzeit(x(x>0))),pulkrout)-reference_time;
        %         c_s=cellfun(@(x) cellstr(routnams(abs(x),:))',pulkrout,'UniformOutput',0);
        %         table_deff{instr}=c_s;
        %         disp(diff_time);
        %         time_reference_am_pm{instr}=reference_time2(1:9)-reference_time2(11:19);
       disp(reference_time2{1}-reference_time2{2})
    end;
    


    %% inicializa
    pulkzeit=zeros(npulks,1);
    pulkstr=cell(npulks,1);

    for i=1:length(pulkinds)
        hstr='';
        h=pulkrout{i};
        s=[routnams(abs(h),1:2)'];
        hstr=sprintf('%c',s);
        iu=h<0;
        pulkstr{i}=hstr;
        pulkzeit(i)=sum(routzeit(h(~iu)))+pauszeit;
    end;
    pulkstr_instr{instr}=pulkstr;
    

    for nntag=nntag1:nntag2
        %[nntag1,mean([nntag1,nntag2]),nntag2]

        flagsc=0; %enventually number of SC
        flagsl=0;

        %fecha
        disp(datestr(nntag));
        [yy,mm,dd]=datevec(nntag);

        minuts=[0:24*60]';
        stus=minuts/60;
        nn=datenum(yy,mm,dd,stus,0,0);

        [h,h,sza]=zeit2sza(nn,lats,longs,szameth);

        plot(stus,90-sza,'b');grid on
        hold on;
        szanoon=min(sza);
        hline(90-szanoon);

        noonind=18;
        %1=szanoon>85,2=szanoon>80,3=szanoon>85,4=szanoon>75
        if szac(2)<szanoon
            szac(2)=szanoon+0.1;
            szac(3:4)=NaN;
            noonind=1;
        end;
        if szac(3)<szanoon szac(3)=szanoon+0.1;szac(4)=NaN;noonind=2;end;
        if szac(4)<szanoon szac(4)=szanoon+0.1;noonind=3;end;


        %construct schedule step by step

        a=zeros(1000,7);%1=minuts,2=routinds,3=sza,4=am/pm,5=pulkindex
        ;% repetition   % 7 airmass % 8 real time for syncronized measuremetns
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %0: before 92, am

        ind=10; % antes y despues de las medidas
        szalim=szac(1);   %angulo limite
        h=pulkrout{ind};  %  rutinas
        hz=routzeit(abs(h)); % tiempo que tardan
        iu=h<0;hz(iu)=0;h=abs(h); % quitamos las medidas que no tardan por calentamiento
        % tiempo to sza -A dia, angulo zenital , latitud ,longitud metodo
        startz=round(60*sza2zeit(nntag,szalim,0,lats,longs,szameth));
        startz=startz-pulkzeit(ind)-10;%give it 10min break

        zehl=1;
        a(zehl,1)=startz;
        a(zehl,2)=h(1);
        a(zehl,5)=pulkinds(ind);

        for i=2:length(h) %rellenamos las medidas
            zehl=zehl+1;
            a(zehl,2)=h(i);
            a(zehl,1)=a(zehl-1,1)+hz(i-1);
        end;
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %1: from 92-81, AM   
        
        ind=1;
        szalim1=szac(1);
        szalim2=szac(2);
        h=pulkrout{ind};
        hz=routzeit(abs(h));
        iu=h<0;hz(iu)=0;h=abs(h);

        startz=round(60*sza2zeit(nntag,szalim1,0,lats,longs,szameth));
        endz=round(60*sza2zeit(nntag,szalim2,0,lats,longs,szameth));
        reps=ceil((endz-startz)/pulkzeit(ind));
        for i=1:reps
            zehl=zehl+1;a(zehl,2)=h(1);a(zehl,1)=startz;a(zehl,5)=pulkinds(ind);
            a(zehl,6)=i;
            for j=2:length(h)
                zehl=zehl+1;
                a(zehl,2)=h(j);
                a(zehl,1)=a(zehl-1,1)+hz(j-1);
            end;
            startz=startz+pulkzeit(ind);
            
        end;
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        %2: from 80-75, am
        ind=2;
        szalim=szac(3);
        h=pulkrout{ind};
        hz=routzeit(abs(h));
        iu=h<0;hz(iu)=0;h=abs(h);
        if ~isnan(szalim)
            endz=round(60*sza2zeit(nntag,szalim,0,lats,longs,szameth));
            reps=round((endz-startz)/pulkzeit(ind)); %repetitions
            
            for i=1:reps
                zehl=zehl+1;
                a(zehl,2)=h(1);
                a(zehl,1)=startz;
                a(zehl,5)=pulkinds(ind);
                a(zehl,6)=i;
                for j=2:length(h)
                    zehl=zehl+1;
                    a(zehl,2)=h(j);
                    a(zehl,1)=a(zehl-1,1)+hz(j-1);
                end;
                startz=startz+pulkzeit(ind);

            end;
        end;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %3: from 70-60, am
        ind=[3,4];
        szalim=szac(4);
        hr={};hzr={};
        if ~isnan(szalim)

            for j=1:length(ind)
                hr{j}=pulkrout{ind(j)};
                hzr{j}=routzeit(abs(hr{j}));
                iu=hr{j}<0;
                hzr{j}(iu)=0;
                hr{j}=abs(hr{j});
            end
            endz=round(60*sza2zeit(nntag,szalim,0,lats,longs,szameth));
            reps=round((endz-startz)/pulkzeit(ind(1)));

            for i=1:reps
                if i==1 || mod(i,4)==1
                    h=hr{2};
                    hz=hzr{2};
                    ind=4;
                    flagsl=flagsl+1;
%                 elseif flagsc<2 && i>2 && i<3 %%&& round(rand(x))
%                     h=hr{3};
%                     hz=hzr{3};
%                     ind=8;
%                     flagsc=flagsc+1;
                 else
                    h=hr{1};
                    hz=hzr{1};
                    ind=3;
                    flagsl=0;
                end


                zehl=zehl+1;
                a(zehl,2)=h(1);
                a(zehl,1)=startz;
                a(zehl,5)=pulkinds(ind);
                a(zehl,6)=i;
                for j=2:length(h)
                    zehl=zehl+1;a(zehl,2)=h(j);a(zehl,1)=a(zehl-1,1)+hz(j-1);
                end;
                startz=startz+pulkzeit(ind);
               
            end;
        end;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        %4: -75 to 75 noon, am
        ind=5:7;
        szalim=szac(5);
        hr={};hzr={};

        if ~isnan(szalim)
            for j=1:length(ind)
                hr{j}=pulkrout{ind(j)};
                hzr{j}=routzeit(abs(hr{j}));

                iu=hr{j}<0;
                hzr{j}(iu)=0;
                hr{j}=abs(hr{j});
            end
            endz=round(60*sza2zeit(nntag,szalim,1,lats,longs,szameth));
            reps=ceil((endz-startz)/30) ; %pulkzeit(ind(j)));

            for i=1:reps
                % calculo de la masa optica
                % sun scan determination
                 [aux,aux,sza]=zeit2sza(nntag+startz/60/24,lats,longs,szameth);
                 airm=floor((1./cos(deg2rad(sza)))*10)/10;
                 
                if 0 %airm>=1.25  & airm<=4 % & mod(flagsc,2)==0 % no sun scan
                      h=hr{3};
                      hz=hzr{3};
                      ind=7;
                      flagsc=flagsc+1;
                
                elseif mod(i,6)==0 && i<reps% or number of sl
                    h=hr{2};
                    hz=hzr{2};
                    ind=6; %sl
                    flagsl=flagsl+1;
                else
                    h=hr{1};
                    hz=hzr{1};
                    ind=5;
                    
                end
                zehl=zehl+1;
                a(zehl,2)=h(1);
                
                % For sincronized scan
                if h(1)==35 || h(1)==36 ||  h(2)==35 || h(2)==36 % ua
                    %ua
                    a(zehl,8)=startz;  % real time
                    startz=round(startz/30)*30-1.5 ; %ua must start 1 minute before
                    a(zehl,1)=startz;
                    if a(zehl,8)>startz
                        warning(' error in synchronized')
                        disp(startz/60)
                        disp((a(zehl,1)-a(zehl,8)))
                    end
                else
                  a(zehl,1)=startz;
                end
                a(zehl,5)=pulkinds(ind);
                a(zehl,6)=i;

                for j=2:length(h)
                    zehl=zehl+1;a(zehl,2)=h(j);a(zehl,1)=a(zehl-1,1)+hz(j-1);
                end;
                startz=startz+pulkzeit(ind);
            end;
        end;
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %5: from 60-70, pm

        ind=[13,14];
        szalim=szac(6);
        hr={};hzr={};
        if ~isnan(szalim)

            for j=1:length(ind)
                hr{j}=pulkrout{ind(j)};
                hzr{j}=routzeit(abs(hr{j}));
                iu=hr{j}<0;
                hzr{j}(iu)=0;
                hr{j}=abs(hr{j});
            end
            endz=round(60*sza2zeit(nntag,szalim,1,lats,longs,szameth));
            reps=round((endz-startz)/pulkzeit(ind(1)));
            if reps==0 reps=1; end

            for i=1:reps
                if i==1 || mod(i,4)==1 % do sl
                    h=hr{2};
                    hz=hzr{2};
                    ind=14;
                    flagsl=flagsl+1;
%                 elseif i<3 & flagsc<8 % & round(rand(i))
%                     h=hr{3};
%                     hz=hzr{3};
%                     ind=18;
%                     flagsc=flagsc+1;
                else

                    h=hr{1};
                    hz=hzr{1};
                    ind=13;
                    flagsl=0;
                end


                zehl=zehl+1;
                a(zehl,2)=h(1);
                a(zehl,1)=startz;
                a(zehl,5)=pulkinds(ind);
                a(zehl,6)=i;
                for j=2:length(h)
                    zehl=zehl+1;a(zehl,2)=h(j);a(zehl,1)=a(zehl-1,1)+hz(j-1);
                end;
                startz=startz+pulkzeit(ind);
            end;
        end;
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 6: from 70-80, pm
        

        ind=12;
        szalim=szac(7);
        hr={};hzr={};
        if ~isnan(szalim)

            for j=1:length(ind)
                hr{j}=pulkrout{ind(j)};
                hzr{j}=routzeit(abs(hr{j}));
                iu=hr{j}<0;
                hzr{j}(iu)=0;
                hr{j}=abs(hr{j});
            end
            endz=round(60*sza2zeit(nntag,szalim,1,lats,longs,szameth));
            reps=round((endz-startz)/pulkzeit(ind(j)));
            if reps==0 reps=1; end 
            for i=1:reps
                
                     h=hr{1};
                     hz=hzr{1};
                     ind=12;
                
%                 if i==12;
%                     h=hr{2};
%                     hz=hzr{2};
%                     ind=11;
%                 else
% 
%                     h=hr{1};
%                     hz=hzr{1};
%                     ind=2;
%                 end


                zehl=zehl+1;
                a(zehl,2)=h(1);
                a(zehl,1)=startz;
                a(zehl,5)=pulkinds(ind);
                a(zehl,6)=i;
                for j=2:length(h)
                    zehl=zehl+1;a(zehl,2)=h(j);a(zehl,1)=a(zehl-1,1)+hz(j-1);
                end;
                startz=startz+pulkzeit(ind);
                for j=2:length(h)
                    zehl=zehl+1;a(zehl,2)=h(j);a(zehl,1)=a(zehl-1,1)+hz(j-1);
                end;
                startz=startz+pulkzeit(ind);
            end;
        end;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %7: from 85-92, pm

        ind=[11,1];szalim=szac(8);
        for j=1:length(ind)
                hr{j}=pulkrout{ind(j)};
                hzr{j}=routzeit(abs(hr{j}));
                iu=hr{j}<0;
                hzr{j}(iu)=0;
                hr{j}=abs(hr{j});
            end
            
        %h=pulkrout{ind};hz=routzeit(abs(h));iu=h<0;hz(iu)=0;h=abs(h);
        endz=round(60*sza2zeit(nntag,szalim,1,lats,longs,szameth));
        reps=floor((endz-startz)/pulkzeit(ind(1)));
        for i=1:reps
            if i==2 
                h=hr{1};  hz=hzr{1}; ind=11;
            else
                h=hr{2};  hz=hzr{2}; ind=1;
            end
                
            
            zehl=zehl+1;a(zehl,2)=h(1);a(zehl,1)=startz;a(zehl,5)=pulkinds(ind);
            a(zehl,6)=i;
            for j=2:length(h)
                zehl=zehl+1;a(zehl,2)=h(j);a(zehl,1)=a(zehl-1,1)+hz(j-1);
            end;
            startz=startz+pulkzeit(ind);
        end;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %13: after 92, nachm
        ind=10;szalim=szac(1);
        h=pulkrout{ind};hz=routzeit(abs(h));iu=h<0;hz(iu)=0;h=abs(h);
        zehl=zehl+1;
        a(zehl,1)=startz;a(zehl,2)=h(1);a(zehl,5)=pulkinds(ind);
        for i=2:length(h)
            zehl=zehl+1;a(zehl,2)=h(i);a(zehl,1)=a(zehl-1,1)+hz(i-1);
        end;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %reduce a
        a=a(1:zehl,:);
        stus=a(:,1)/60;
        %jj=find(a(:,8));
        %stus(jj)=a(jj,8)/60;
        [yy,mm,dd]=datevec(nntag);
        nn=datenum(yy,mm,dd,stus,0,0);
        [h,h,sza,pm]=zeit2sza(nn,lats,longs,szameth);
        a(:,3:4)=[sza,pm];
        %airmass aprox
        a(:,7)=1./cos(deg2rad(a(:,3)));

        skd{nntag-nntag1+1,instr}=a;

        % plot
        G=cellstr(routnams(a(:,2),:));
        gscatter(a(:,1)/60,90-a(:,3),G,'','')

        ig=a(:,5)>0; %indice
        af=a(ig,:);

        str=datestr(nntag,6);
        skc_char='uv';
        fname=fullfile(path{instr},[skc_char,str([1,2,4,5]),instnam,'.skd']);

        f=fopen(fname,'w');
        for i=1:length(af(:,1))

            szastr=num2str(af(i,3),'%5.2f');

            %aqui falla
            if af(i,4)==0 szastr=['-',szastr];end;
            %if af(i,5)==8 szastr=['0'];end;
            str=szastr; % try to avoid waiting time
            fprintf(f,[str,'\r\n']);
            %str=[pulkstr{af(i,5)},'2'];
            str=[pulkstr{af(i,5)}];
            fprintf(f,[str,'\r\n']);
        end;
        fprintf(f,['180\r\n']);str=datestr(nntag+1,6);
        fprintf(f,[skc_char,str([1,2,4,5]),instnam,'\r\n']);fclose(f);


    end

end

 
        
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h=[];
for nntag=nntag1:nntag2%fix(mean([nntag1,nntag2]))
      idx=nntag-nntag1+1;
      a=skd{idx,1};
      b=skd{idx,2};
    f=figure;
    hold on;
   
    a=skd{idx,1};
    b=skd{idx,2};
    % G=cellstr(routnams);
    % ploteamos solo  los grupos
    saux=[];h=[];
    for i=1:length(routgrps)
        aux=a(routgrp(a(:,2))==i,[1,3]);
        saux(i,1)=size(aux,1);
        if ~isempty(aux)
            h(i)=plot(aux(:,1)/60,90-aux(:,2),['x',routplt(i)]);
        else
            h(i)=0;
        end
        
        %axis([-Inf,Inf,-10,Inf]);
        %xx=get(gca,'Xtick');
        %[jj,ii]=findm_min(a(:,1)/60,xx,0.1);
        %yy=NaN*xx;yy(ii)=a(jj,7)
        %hx=LinkTopAxisData(xx,yy,'air mass')
        
        auxb=b(routgrp(b(:,2))==i,[1,3]);
        saux(i,2)=size(auxb,1);
        [si,sj]=findm(aux(:,1),auxb(:,1),1.5);
        saux(i,3)=length(sj);
        if ~isempty(auxb)
            plot(auxb(:,1)/60,90-auxb(:,2),['o',routplt(i)]);
        end
        
        
        
        if i==5

            if ~isempty(auxb)
                st(5)=stem(auxb(:,1)/60,90-auxb(:,2),['-o',routplt(i)]);
            end
            if ~isempty(aux)
                st(5)=stem(aux(:,1)/60,90-aux(:,2),['-x',routplt(i)],'Linewidth',2);
            end
        end
        if i==6

            if ~isempty(auxb)
                st(6)=stem(auxb(:,1)/60,90-auxb(:,2),['-s',routplt(i)]);
            end
            if ~isempty(aux)
                st(6)=stem(aux(:,1)/60,90-aux(:,2),['-',routplt(i)],'Linewidth',2);
            end
        end

        if i==1

            if ~isempty(auxb)
                st(1)=stem(auxb(:,1)/60,90-auxb(:,2),'-c');
            end
            if ~isempty(aux)
                st(1)=stem(aux(:,1)/60,90-aux(:,2),'-c','Linewidth',1);
            end
        end
        
         if i==10

            if ~isempty(auxb)
                st(10)=stem(auxb(:,1)/60,90-auxb(:,2),'-g');
            end
            if ~isempty(aux)
                st(10)=stem(aux(:,1)/60,90-aux(:,2),'-g','Linewidth',3);
            end
            
        end
        if i==11 % UMK

            
            if ~isempty(auxb)
            jend=find(abs(b(:,2))==21);
            jstart=find(abs(b(:,2))>36);
           
            

            x=[b(jstart,1)/60,b(jend,1)/60,90-b(jstart,3),90-b(jend,3)];
            aux=[];for i=1:size(x,1) , aux=[aux;[x(i,1),x(i,3);x(i,2),x(i,4);NaN,NaN]]; end
            st(11)=ploty(aux,'-');
            set(st(11),'linewidth',3)
                %st=stairs(auxb(:,1)/60,90-auxb(:,2),['-o',routplt(i)]);
            end
            if ~isempty(aux)
                jend=find(abs(a(:,2))==21);
                jstart=find(abs(a(:,2))>36);
                % no umkher
                x=[a(jstart,1)/60,a(jend,1)/60,90-a(jstart,3),90-a(jend,3)];
                
                aux=[];for i=1:size(x,1) , aux=[aux;[x(i,1),x(i,3);x(i,2),x(i,4);NaN,NaN]]; end
                st(i)=ploty(aux,'-');
                set(st(i),'linewidth',3)
                %st=stairs(aux(:,1)/60,90-aux(:,2),['-x',routplt(i)],'Linewidth',3);
               
              end
        end

        disp(routgrps(i,:));
    end
    
    
    %G=cellstr(routgrps);
    G2=cellstr([routgrps,num2str(saux)])
    
    axis([-Inf,Inf,-10,Inf]);
    %xx=get(gca,'Xtick');
    %[jj,ii]=findm_min(a(:,1)/60,xx,0.1);
    %yy=NaN*xx;yy(ii)=a(jj,7)
    %LinkTopAxisData(xx,yy,'air mass')
    suptitle(['3^r^d RBCC-E Campaign UMKEHR ', datestr(nntag)]);
    title(' x-> uv 365 o-> uv 325 ');
    %legend(h,G2);%,'location','BestOutside');
    legend boxoff;
    xlabel('hour');
    ylabel('solar altitude');
    grid;
    box on;
    orient landscape;
    print -dpsc -append schedule_rand

    %close(f)
    % sun scan

    j=find(abs(a(:,2))==21);a(j,7)
    printmatrix([a(j,1)/60,a(j,[3,7])],1)

    %% resumen
    i=find(a(:,5));
    spc=char(ones(size(a(i,1)))*32);
    command{1}=[num2str(a(i,5)),spc,datestr(nntag+a(i,1)/60/24),spc,num2str(a(i,3)),spc,num2str(a(i,7)),spc,char(pulkstr_instr{1}(a(i,5)))];
    disp(command{1});

    i=find(b(:,5));
    spc=char(ones(size(b(i,1)))*32);
    command{2}=[num2str(b(i,5)),spc,datestr(nntag+b(i,1)/60/24),spc,num2str(b(i,3)),spc,num2str(b(i,7)),spc,char(pulkstr_instr{2}(b(i,5)))];
    disp(command{2});
end    
%     % report de umkher
%     %singles
%     j=find(abs(b(:,2))==21);
%     printmatrix([b(j,1)/60,b(j,[3,7])],1)
%     % doubles
%     j=find(routgrp(a(:,2))==11);
%     printmatrix([a(j,1)/60,a(j,[3,7])],1)
%     
%     
%     % doubles
% 
% 
%     
%     figure
%      plot(a(:,1)/60,90-a(:,3),':')
%      hold on;
%      jend=find(abs(a(:,2))==21);
%      jstart=find(abs(a(:,2))>36);
%      j=find(routgrp(a(:,2))==11);
%      jds=find(routgrp(a(:,2))==1);
% 
%      hline(90-umk_angles,'k:');%cellstr(num2str(umk_angles')));
%      x=[a(jstart,1)/60,a(jend,1)/60,90-a(jstart,3),90-a(jend,3)];
%      aux=[];for i=1:size(x,1) , aux=[aux;[x(i,1),x(i,3);x(i,2),x(i,4);NaN,NaN]]; end
%      if ~isempty(aux)
%          h=ploty(aux,'-'); 
%          set(h,'linewidth',3)
%      end
%      plot(a(jds,1)/60,90-a(jds,3),'o');
%     %figure
%      %plot(b(:,1)/60,90-b(:,3),':')
%      hold on;
%      jend=find(abs(b(:,2))==21);
%      jstart=find(abs(b(:,2))>36);
%      j=find(routgrp(b(:,2))==11);
%      jds=find(routgrp(b(:,2))==1);
% 
% 
%      xb=[b(jstart,1)/60,b(jend,1)/60,90-b(jstart,3),90-b(jend,3)];
%      aux=[];for i=1:size(x,1) , aux=[aux;[x(i,1),x(i,3);x(i,2),x(i,4);NaN,NaN]]; end
%      if ~isempty(aux)
%       h=ploty(aux,'b:');
%       set(h,'linewidth',3)
%      end
%       plot(b(jds,1)/60,90-b(jds,3),'bx');
%      title('3^n^d RBCC-E Campaign UMKEHR ');
%      legend('solar altitude','umk extended','ds extended','umk noext','ds noext',-1);
%      set(gca,'Ylim',[-5,35]);
%      xlabel('Time (Hour GMT)');
%      ylabel('Solar Altitude');
% end
% 
% 


