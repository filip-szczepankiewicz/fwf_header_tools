function res = fwf_seq_from_siemens_csa(csa)
% function res = fwf_seq_from_siemens_csa(csa)
%
% csa is the private Siemens header found in:
% h.CSASeriesHeaderInfo.MrPhoenixProtocol
%
% NOTE: This function must be expanded with version control as the position
% and meaning of each field may change!


str_list = {...

    % UI parameters
    'sWipMemBlock.alFree[21]	 = 	',              'study_nr',     'enum';
    'sWipMemBlock.alFree[22]	 = 	',              'wf_nr',        'enum';
    'sWipMemBlock.alFree[23]	 = 	',              'rot_mode',     'enum';
    'sWipMemBlock.alFree[24]	 = 	',              'norm_mode',    'enum';
    'sWipMemBlock.alFree[25]	 = 	',              'post_wf_mode', 'enum';
    'sWipMemBlock.alFree[26]	 = 	',              'timing_mode',  'enum';
    'sWipMemBlock.alFree[27]	 = 	',              'pause_mode',   'enum';
    'sWipMemBlock.alFree[28]	 = 	',              'bg_on',        'enum';
    'sWipMemBlock.alFree[29]	 = 	',              'header_mode',  'enum';
    
    'sWipMemBlock.alFree[31]	 = 	',              'b_max',        'mm2/ms';
    'sWipMemBlock.alFree[32]	 = 	',              'd_pre',        '�s';
    'sWipMemBlock.alFree[33]	 = 	',              'd_post',       '�s';
    'sWipMemBlock.alFree[34]	 = 	',              'd_pause',      '�s';
    
    % sequence timing
    'sWipMemBlock.alFree[41]	 = 	',              'd_pre_max',    '�s';
    'sWipMemBlock.alFree[42]	 = 	',              'd_post_max',   '�s';
    'sWipMemBlock.alFree[43]	 = 	',              'd_pause_min',  '�s';
    'sWipMemBlock.alFree[44]	 = 	',              'd_pause_max',  '�s';
    
    % validation params
    'sWipMemBlock.alFree[45]	 = 	',              'study_nr_curr','enum';
    'sWipMemBlock.alFree[46]	 = 	',              'wf_nr_curr',   'enum';
    'sWipMemBlock.alFree[47]	 = 	',              'b_max_gamp',   'mm2/ms';
    'sWipMemBlock.alFree[48]	 = 	',              'b_max_slew',   'mm2/ms';
    'sWipMemBlock.alFree[49]	 = 	',              'b_max_requ',   'mm2/ms';
    
    % waveform info
    'sWipMemBlock.alFree[50]	 = 	',              'gamp',         'mT/m*1000';
    'sWipMemBlock.alFree[51]	 = 	',              'slew',         'T/m/s*1000';
    'sWipMemBlock.alFree[52]	 = 	',              'B_FA',         '1*1000';
    'sWipMemBlock.alFree[53]	 = 	',              'didi_norm',    '1*1000';
    
    % b-tensor
    'sWipMemBlock.alFree[54]	 = 	',              'Bxx',          'mm2/ms*1000';
    'sWipMemBlock.alFree[55]	 = 	',              'Byy',          'mm2/ms*1000';
    'sWipMemBlock.alFree[56]	 = 	',              'Bzz',          'mm2/ms*1000';
    'sWipMemBlock.alFree[57]	 = 	',              'Bxy',          'mm2/ms*1000';
    'sWipMemBlock.alFree[58]	 = 	',              'Bxz',          'mm2/ms*1000';
    'sWipMemBlock.alFree[59]	 = 	',              'Byz',          'mm2/ms*1000';
    
    % balance gradient
    'sWipMemBlock.adFree[8]	 = 	',                  'bg_ampx',      'mT/m';
    'sWipMemBlock.adFree[9]	 = 	',                  'bg_ampy',      'mT/m';
    'sWipMemBlock.adFree[10]	 = 	',              'bg_ampz',      'mT/m';
    'sWipMemBlock.adFree[11]	 = 	',              'bg_0mom',      'mTs/m';
    
    % loaded waveform in base 64
    'sWipMemBlock.tFree	 = 	',                      'wf_stored',    'structure';
    
    % Siemens imaging parameters
    'sSliceArray.asSlice[0].dPhaseFOV	 = 	',      'FOVp',         'mm';
    'sPat.lAccelFactPE	 = 	',                      'iPAT',         'int';
    'sSliceArray.asSlice[0].dThickness	 = 	',      'SliceThick',   'mm';
    };


for i = 1:size(str_list, 1)
    ind = strfind(csa, str_list{i,1});
    ind2 = ind+length(str_list{i,1});
    
    if ~strcmp('sWipMemBlock.tFree	 = 	', str_list{i,1})
        val = sscanf(csa(ind2:end), '%g', 1);
    else
        b64wf = sscanf(csa(ind2:end), '%s', 1);
        b64wf = erase(b64wf,'""');
        val = fwf_b64_to_data(b64wf);
        val.b64wf = b64wf;
    end
    
    res.(str_list{i,2}) = val;
end

for i = 1:size(str_list, 1)
    res.unit.([str_list{i,2} '_unit']) = str_list{i,3};
end
