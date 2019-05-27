% AOD config table
%fieldnames(table2struct(t))
% t=readtable('aod_config_template.csv')
fields=[
    {'Brw'         }
    {'ANO'         }
    {'DIAJ0'       }
    {'DIAJ'        }
    {'SLIT'        }
    {'CALSTEP'     }
    {'WAVEL'       }
    {'FWHM'        }
    {'ETC_FL0'     }
    {'ETC_FL1'     }
    {'ETC_FL2'     }
    {'ETC_FL3'     }
    {'ETC_FL4'     }
    {'ETC_FL5'     }
    {'RAYLEIGH'    }
    {'O3_ABS'      }
    {'SO2_ABS'     }
    {'NO2_ABS'     }
    {'TC_CONST'    }
    {'TC_LIN'      }
    {'TC_QUAD'     }
    {'AT_FL1'      }
    {'AT_FL2'      }
    {'AT_FL3'      }
    {'AT_FL4'      }
    {'AT_FL5'      }
    {'STRAYL_CONST'}
    {'STRAYL_COEFF'}
    {'STRAYL_EXP'  }
    {'SL_REF'      }
    {'SL_SLOPE'    }
    {'SL_QUAD'     }
    {'AOD_EX1'     }
    {'AOD_EX2'     }
    {'AOD_EX3'     }];

cfgtable = cell2table(cell(0,35), 'VariableNames', fields);




