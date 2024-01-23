function [X]=calculate_risk_premium(A,M,X,MMT,OF);
% 
% X = X_OF;
% A = A_OF;

% risk premium components: 1) barrier height relative to sea level (sunny day flooding)
%                          2) dune height (protection from storms) 
%                          3) risk premium for front row homes 
%                          3) heterogeneous agent risk tolerance 

a = 365;
b = 200;
c = 5;
d = 0.01;
e = 0.5*0.04;
f = 0.02;
return_interval = 0.05;
return_param = 0.1;
a2 = 0.3;
a3 = 0.7;

backg_risk = 0.005;

OF = 1;

t = M.time;
% % (1)
height_above_msl       =  (M.barr_elev-M.msl(t)); 
num_sunny_day_flood    = 365*(1-height_above_msl);
%sunny_day_flood_premium = (num_sunny_day_flood^1)/a;
sunny_day_flood_premium = a3*(1-height_above_msl)^2;

X.num_sunny_day_floods_and_premium(t,:)=[num_sunny_day_flood sunny_day_flood_premium]; % just to track 

% t = M.time;
% % % (1)
% sea_level_rel_to_barrier  = 1 - (M.barr_elev-M.msl(t)); 
% num_sunny_day_flood       = a ./ (1 + b*exp( -c * sea_level_rel_to_barrier )); % logistic function 
% sunny_day_flood_premium   = num_sunny_day_flood/a;                             % convert number of sunny day floods to risk premium 

% % (2)
%storm_risk_increases_with_sea_level = 1 + d / (M.barr_elev-M.msl(t));
storm_risk_increases_with_sea_level = (1-M.barr_elev-M.msl(t));
%dunes_reduce_storm_risk             = 1-exp(-8*(MMT.h_dune(t)/MMT.h0)^2);
dunes_reduce_storm_risk             = 1-(MMT.h_dune(t)/MMT.h0);
%dune_premium                        = e * (storm_risk_increases_with_sea_level - dunes_reduce_storm_risk);
dune_premium                        = a2 * (storm_risk_increases_with_sea_level * dunes_reduce_storm_risk);

storm_return_risk = return_interval*return_param;

% % (3)
front_row_risk = OF * f;

% % (4)
agent_risk_tolerance    = X.rp_base;
investor_risk_tolerance = 1;

for ii=1:X.n
      %X.rp_o(ii) = (sunny_day_flood_premium + dune_premium + front_row_risk) * agent_risk_tolerance(ii); Old style
      X.rp_o(ii) = backg_risk + (storm_return_risk + sunny_day_flood_premium + dune_premium + front_row_risk) * agent_risk_tolerance(ii);
end
X.rp_o(X.rp_o>1)=1;

%X.rp_I = (sunny_day_flood_premium + dune_premium + front_row_risk) * investor_risk_tolerance;
X.rp_I = backg_risk + (storm_return_risk + sunny_day_flood_premium + dune_premium + front_row_risk) * investor_risk_tolerance;

if X.rp_I > 1
    X.rp_I=1;
end


% M.msl=0:0.01:1;
% for t=1:101
%     height_above_msl(t)  =  (M.barr_elev-M.msl(t));
%     num_sunny_day_flood(t) =  365*(1-height_above_msl(t));
%     sunny_day_flood_premium(t) = num_sunny_day_flood(t)/365;
% end
% 
% subplot(311)
% plot(height_above_msl(1:101),num_sunny_day_flood(1:101))
% xlabel('height above msl')
% ylabel('num sunny day floods')
% % ylim([0 365])
% % xlim([0 1])
% subplot(312)
% plot(num_sunny_day_flood(1:101),sunny_day_flood_premium(1:101))
% xlabel('number sunny day floods')
% ylabel('r^{p} sunny day component')
% % ylim([0 1])
% subplot(313)
% plot(height_above_msl(1:101),sunny_day_flood_premium(1:101))
% xlabel('height above msl')
% ylabel('r^{p} - sunny day component')
% % ylim([0 1])
% sunny_day_flood_premium(73)


% 
% 
% 
% 
% % ref: patterns and projections of high tide flooding along the us coastline using a common impact threshold
% msl=linspace(0,1,100);
% for t=1:100
%     number_sunny_day_floods(t) = 565./(1.5+400*exp(-12*msl(t)));
% end
% close all
% plot(number_sunny_day_floods(1:80))
% % % 
% % plot(msl,number_sunny_day_floods)
% % xlabel('mean sea level')
% ylabel('numberof sunny day floods')
% 
% barr_elev=1;
% risk_prem_sunny_day = number_sunny_day_floods/365;
% rel_barr_height = barr_elev - msl;
% plot(rel_barr_height,risk_prem_sunny_day)
% xlabel('barrier height relative to sea level')
% ylabel('risk premium - sea level component')
% 
% 
% % filename='C:\Users\Zack\Desktop\riskprem3';
% % set(gcf, 'PaperPosition', [0 0 6 5]); %Position plot at left hand corner with width 5 and height 5.
% % set(gcf, 'PaperSize', [6 5]); 
% % % print('-dpdf','-painters',filename)
% % 
% 





