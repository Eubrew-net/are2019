%plot_brewer_report
%%
data_size=length(orden);

close all
for i=1:length(orden)
 h(1)=plot(diaj2(ref(:,1)),ref(:,i+1));
 hold all
end
legend(gca,Cal.brw_str(orden),'Location','SouthEastOutside');
%interactivelegend(h)
%set(gca,'XLim',[200.15,200.75]);
%set(h(1),'LineWidth',3);

%%
% figure;
% h=plot(diaj2(ref(:,1)),ref(:,2:end));
% legend(gca,Cal.brw_str(orden),'Location','SouthEastOutside');interactivelegend(h)
% set(gca,'XLim',[198.5,diaj(now)+1],'Ylim',[270,340]);
%set(h([3,4]),'Visible','off');
%%
% idx=NaN*ones(size(ref,1),Cal.n_brw);
% idx=[];
% ref_blind=NaN*ones(size(ref,1),Cal.n_brw+1);  ref_blind(:,1)=ref(:,1);
% for ii=1:length(orden)
%     idx=ismember(diaj(ref(:,1)),Cal.calibration_days{orden(ii),2});
%     ref_blind(idx,ii+1)=ref(idx,ii+1);
% end
close all
figure;
patch([min(diaj(ref_sl(:,1))) max(diaj(ref_sl(:,1)))+1 max(diaj(ref_sl(:,1)))+1 min(diaj(ref_sl(:,1)))],...
     [repmat( -1,1,2) repmat( 1,1,2)], ...
     [.953,.953,.953],'LineStyle',':'); hold on;
h=plot(diaj2(ref_sl(:,1)),100*matdiv(matadd(ref_sl(:,3:end),-ref_sl(:,2)),ref_sl(:,2)));
set(gca,'FontSize',9); 
hline(0,'--k'); box on;
legendflex(h,Cal.brw_str(orden(2:end)),'fontsize',8,'xscale',0.5,'anchor',[4 4],'buffer',[55 0]);
%set(gca,'Ylim',[-10,10],'Ytick',-10:10,'XLim',[195 206]); grid on;
ylabel('Ozone relative differences (%)','FontSize',12); title('Ozone deviation with respect to IZO#185','FontSize',12);

%%
printfiles_report(gcf,Cal.dir_figs,'aux_pattern',{'O3_blind'},'Width',16,'Height',10,'Format','tiff');

%% 
osc=ref_airm(:,2).*ref(:,2);
dref=sortrows([osc,ref]);
osc=ref_airm(:,2).*ref(:,2);
dref_sl=sortrows([osc,ref_sl]);
rpsl=100*matdiv(matadd(dref_sl(:,3:end),-dref(:,3)),dref(:,3));
rp=100*matdiv(matadd(dref(:,3:end),-dref(:,3)),dref(:,3));

%% boxplot osc< .9
osc_lim=900;
jo=(osc<osc_lim) ;

close all
figure; set(gcf,'Tag','deviations');
patch([0.02 Cal.n_brw+1 Cal.n_brw+1 0.02],[repmat( -1,1,2) repmat( 1,1,2)],[.953,.953,.953],'LineStyle','None');hold on; 
h1=errorbar(1:data_size,nanmean(rp(jo,:)),nanstd(rp(jo,:)),'bo','linewidth',3);
h2=errorbar(1:data_size,nanmean(rpsl(jo,:)),nanstd(rpsl(jo,:)),'rp','linewidth',3);
set(gca,'Xtick',1:Cal.n_brw,'XtickLabel',Cal.brw_str(orden),'Layer','top'); box on;
%h=boxplot(100*matdiv(matadd(ref_sl(:,2:end),-ref(:,2)),ref(:,2)),Cal.brw_str(orden));
set(gca,'Ylim',[-4,7],'XLim',[0 Cal.n_brw+1]); grid;
xlabel('Brewer Serial No.'); ylabel('Ozone Deviations [%]'); 
title('Ozone Deviations to Brewer IZO#185');
lg=legend([h1,h2],{'No SL correction','SL corrected'},'Location','NorthWest'); 
set(lg,'Box','on','FontSize',8);

%%
printfiles_report(gcf,Cal.dir_figs,'aux_pattern',{'O3_blind_bars'},'Width',16,'Height',7,'Format','tiff');

%%
figure
% we remove 158
plx=[2:length(orden),1];
%plx(plx==14)=[]
for i=plx
 %figure;
 
 subplot(4,5,find(i==plx))
 set(gcf,'Tag','ratio_general_');
 plot(dref(:,1),rp(:,2:end),'.','Color',[.7,.7,.7]);
 hold on;
 h1=plot(dref(:,1),rp(:,i),'o','Color','b','MarkerSize',1);
 h2=plot(dref_sl(:,1),rpsl(:,i),'x','Color','r','MarkerSize',1);
 lg=legend([h1,h2],{'no sl', 'sl cor'},'orientation','vertical');
 set(lg,'FontSize',5); set(gca,'Ylim',[-16,16],'FontSize',8);
 hline(0,':r');
 %legend(Cal.brw_str{orden(i)})
 title(sprintf('%s vs IZO#185',Cal.brw_name{orden(i)}));
 ylabel('Ozone Deviations [%]');
 xlabel('Ozone Slant Column [DU]');
 grid on;
end
printfiles_report(gcf,Cal.dir_figs,'aux_pattern',{'blind'},'Width',30,'Height',18);
