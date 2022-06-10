function [bw,nourish_xshore,yr_new_nour,mbw]=evaluate_nourishment_future_beach_width(ACOM,M,MMT,n_interval)

t                = M.time;
t_horiz          = MMT.nourish_plan_horizon;
bw               = zeros(M.T + MMT.nourish_plan_horizon,1);
bw(1:t)          = MMT.bw(1:t); 
nourish_xshore   = [];
yr_new_nour      = [];
nourishtime      = MMT.nourishtime;

if n_interval ~= MMT.nourish_plan_horizon+1
    yr_new_nour                = t+1:n_interval:t+t_horiz;
    nourishtime(t+1:end,1)     = 0;
    nourishtime(yr_new_nour,1) = 1;
end


ind = 1;
for time = t+1:t+t_horiz+1
    bw(time) = bw(time-1) - ACOM.E_ER(t);
    if nourishtime(time,1) == 1
        bw(time)            = MMT.x0;
        nourish_xshore(ind) = MMT.x0-(bw(time-1)-ACOM.E_ER(t));
        nourish_yr(ind)     = time;
        ind=ind+1;
    end
end

bw(bw<1) = 1;
mbw      = mean(bw(t+1:t+t_horiz));
