function [tau_o,WTP_base,rp_base,WTP_alph]=agent_distribution(rcov,range_WTP_base,range_WTP_alph,range_tau_o,range_rp_base,beta_x,n,distribution_peakiness)

% % for debug
% beta_x   = A_OF.beta_x;
% range_tau_o    = A_OF.range_tau_o
% range_WTP_base = A_OF.range_WTP_base
% range_WTP_alph = A_OF.range_WTP_alph
% range_rp_base  = A_OF.range_rp_base


%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% method 1
%%%%%%%%%%%%%%%%%%%%%%%%%%

beta_min = .01;

bline2   = -(distribution_peakiness-beta_min)*beta_x+distribution_peakiness;
bline1   =  (distribution_peakiness-beta_min)*beta_x+beta_min;

% covariances 
r12 = rcov;
r13 = rcov;
r14 = rcov;
r23 = rcov;
r24 = rcov;
r34 = rcov;

Rho =  [1 r12 r13 r14;
        r12 1 r23 r24;
        r13 r23 1 r34;
        r14 r24 r34 1];
    
U = copularnd('Gaussian',Rho,n);
X = [betainv(U(:,1),bline1,bline2) betainv(U(:,2),bline1,bline2) betainv(U(:,3),bline1,bline2) betainv(U(:,4),bline1,bline2)];
% X = [betainv(U(:,1),bline1,bline2) betainv(U(:,2),bline1,bline2) betainv(U(:,3),bline1,bline2) betainv(U(:,4),2,2)];

tau_o    = X(:,1);
WTP_base = X(:,2);
WTP_alph = X(:,3);
rp_base  = 1-X(:,4); % rp is currently fixed and while correlated with WTP/tau_inc, does not adjust with the outside market

% rescale to property intervals
tau_o=tau_o*(range_tau_o(2)-range_tau_o(1));
tau_o=tau_o+range_tau_o(1);

WTP_base=WTP_base*(range_WTP_base(2)-range_WTP_base(1));
WTP_base=WTP_base+range_WTP_base(1);

WTP_alph=WTP_alph*(range_WTP_alph(2)-range_WTP_alph(1));
WTP_alph=WTP_alph+range_WTP_alph(1);

rp_base=rp_base*(range_rp_base(2)-range_rp_base(1));
rp_base=rp_base+range_rp_base(1);

