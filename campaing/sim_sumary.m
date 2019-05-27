function [ o3_c ] = sim_sumary(summary1,summary2,T_SYNC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 MIN=60*24;
if nargin==2
  n_min=10;  
else    
 
  n_min=T_SYNC;
end         
  [aa,bb]=findm_min(summary1(:,1),summary2(:,1),n_min/MIN);
  o3_c=[summary1(aa,1),summary2(bb,1),summary1(aa,2:end),summary2(bb,2:end)];

end

