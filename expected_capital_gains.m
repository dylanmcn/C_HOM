function [X,SV] =expected_capital_gains(ACOM,A,M,MMT,X,OF,SV,n);
% OF = 0 ;
% X  = X_NOF;
% SV = SV_NOF;

t       = M.time;
Lmin    = 20;
Lmax    = 30;
X.lmin=Lmin;
temp=[Lmin:Lmax]'-Lmin+1;
% temp=[Lmin:Lmax]'-Lmin+1;
temp=repmat(temp,ceil(X.n/length(temp)),1);
temp=temp(1:X.n);

% temp  = randi(length(Lmin:Lmax),length(X.g_o),1);

if t>Lmax+1
    price   = X.price(1:t);
    P_e      = X.P_e(1:t);
    
    for L=Lmin:Lmax
        pricereturn_L = (price(t-1)-price(t-1-L))/price(t-1-L);
        price_return(L-(Lmin-1)) = (1 + pricereturn_L).^(1./L)-1;
        
        if price_return(L-(Lmin-1))>0.25
            price_return(L-(Lmin-1)) = 0.25
        end
        if price_return(L-(Lmin-1))<-0.25
            price_return(L-(Lmin-1)) = -0.25
        end
    end
    
    X.g_I = median(price_return);
    %     X.g_o = price_return(temp);
    X.g_o(:)=price_return(temp);
    X.expectations_index(:,t)=temp(:);
    
    
end

