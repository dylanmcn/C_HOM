
price_flag=0;

for t = 2: run_option_main.time
    t
    if( t == 810)
        MMT.nourish_subsidy = 0.5;
    end
    if price_flag==0
        M.time = t;
        
        [MMT,ACOM] = ...
            evolve_environment(...
            ACOM,M,MMT,run_option_main);
        
        [X_NOF] = ...
            calculate_risk_premium(...
            A_NOF,M,X_NOF,MMT,0);
        
        [X_OF] = ...
            calculate_risk_premium(...
            A_OF,M,X_OF,MMT,1);
        
        [BPC, MMT] = ...
            calculate_nourishment_plan_cost(...
            ACOM,M,MMT,X_NOF,X_OF);
        
        [BPB,BPC] = ...
            calculate_nourishment_plan_ben(...
            A_NOF,A_OF,ACOM,BPC,M,MMT,X_NOF,X_OF);
        
        [A_NOF,A_OF,MMT,ACOM,X_NOF,X_OF] = ...
            evaluate_nourishment_plans(...
            A_NOF,A_OF,ACOM,BPB,BPC,M,MMT,X_NOF,X_OF,run_option_main);
        
        [A_NOF,A_OF,MMT] = ...
            calculate_evaluate_dunes(...
            ACOM,M,MMT,X_NOF,X_OF,A_NOF,A_OF);
        
        [X_NOF,SV_NOF] = ...
            expected_capital_gains(...
            ACOM,A_NOF,M,MMT,X_NOF,0,SV_NOF,ACOM.n_NOF);
        
        [X_OF,SV_OF] = ...
            expected_capital_gains(...
            ACOM,A_OF,M,MMT,X_OF,1,SV_OF,ACOM.n_OF);
        
        [X_NOF,SV_NOF]= ...
            calculate_user_cost(...
            M,X_NOF,X_NOF.WTP{t},A_NOF.tau_prop(t),SV_NOF);
        
        [X_OF,SV_OF] = ...
            calculate_user_cost(...
            M,X_OF,X_OF.WTP{t},A_OF.tau_prop(t),SV_OF);
        
%         if parm(2)==1
if(1)%Flux
            [A_NOF,X_NOF,SV_NOF] = ...
                agent_distribution_adjust(...
                ACOM,A_NOF,X_NOF,M,SV_NOF,0,MMT,1);
            [A_OF,X_OF,SV_OF] = ...
                agent_distribution_adjust(...
                ACOM,A_OF,X_OF,M,SV_OF,1,MMT,1);
end
%         end
        
        [ACOM] = ...
            agent_assign_properties(...
            ACOM,X_OF,X_NOF,M);
        
        save_dynamic_var;
        
        if X_OF.price(t) > 1e7 | X_OF.price(t) < 0 | X_NOF.price(t) > 1e7 | X_NOF.price(t) < 0
            disp('price out of bounds')
            price_flag=1;
        end
        
        if  t == 2
            X_OF.price(1)=X_OF.price(2);
            X_NOF.price(1)=X_NOF.price(2);
        end
        
        if numel(find(MMT.nourishtime==2))>0
            pause
        end
        
        if t>100 & sum(MMT.nourishtime(:,1))==0
            disp('still no nourish')
            pause
        end
        
    end
    
end


