
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cd C:\Users\Zack\Desktop\CHOM_manuscript_figures\model_solo\model_exp10\
cd C:\Users\Zack\Desktop\'New folder'\

clear all; close all; format compact; 
rand('state',1); randn('state',1); beep off

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%         Coastal Home Ownership Model CHOM         %%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define run times          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_initialization         = 100;              % initialization/burn-in time
time_simulation             = 180;              % main model run time
% initialization options    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initialize_model            = true;           % include a burn-in/spin-up before model simulation
nourishoff_initialize       = false;           % nourishment off ( = true), nourishment on ( = false)
beach_width_ER_initialize   = 1.25;            % beach erosion rate over duration of initialization
beach_width_t0_initialize   = 50;              % initial beach width (fixed width if beach_width_ER_initialize = 0)
dune_height_ER_initialize   = 0;               % dune erosion rate over duration of initialization
dune_height_t0_initialize   = 4;               % initial dune height (fixed height if dune_height_ER_initialize = 0)
sea_level_initialize        = 0.0;             % mean sea level over duration of initialization
% main run options          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nourishoff_main             = false;           % turn nourishment off during main simulation
beach_width_t0_main         = 50;              % beach width at startup
dune_height_t0_main         = 4;               % dune height at startup
environ_changepts           = [ 81   , 180 ];  % start and stop time for increase in ER/sea level 
ER_increase                 = 0.00;            % meters/yr
beach_width_ER_main         = [  1.25  ,  ...  % beach erosion rate (m/yr), [initial time, final time]
   1.25*1];
dune_height_ER_main         = [0  ,  0];     % dune erosion rate ,  [initial time, final time] 
sea_level_main              = [0  ,  0];      % mean sea level,     [initial time, final time]
% outside market option    %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outside_market_OF           = 5e5*[ 1, 1];  
outside_market_NOF          = 4e5*[ 1, 1];  
outside_market_changepts    = [ 81  , 180 ];   % start(1) stop(2) time for outside market change
%                                                % initialization values are column 1 only
%                                                % main simulation values start in column 1, and end at column 2
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
make_run_option
initialization_with_burn_in;  % initialize the model with values obtained after running model forward "initialization_time" years

main_loop;

print_experiment



