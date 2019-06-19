
file_setup='arenos2019_setup';
eval(file_setup);     % configuracion por defecto

Cal.n_inst=9

[azimut zenit]=analyze_FV(fullfile(Cal.path_root,['bdata',Cal.brw_str{Cal.n_inst}],['FV*.',Cal.brw_str{Cal.n_inst}]),...
                         'date_range',datenum(Cal.Date.cal_year,1,Cal.calibration_days{Cal.n_inst,1}([1 end])),...
                         'plot_flag',0);