clear; close all;
initFig(25)

load BlueChipStockMoments

%annualize the monthly returns
AssetMean = (1 + AssetMean).^12 - 1;
MarketMean = (1 + MarketMean).^12 - 1;
AssetCovar = (1 + AssetCovar).^12 - 1;
MarketVar = (1 + MarketVar).^12 - 1;

%plot asset mean vs asset std
figure(1)
plot(diag(sqrt(AssetCovar)),AssetMean,'r.')
text(diag(sqrt(AssetCovar)), AssetMean, AssetList, 'horizontal','left', 'vertical','bottom','fontsize',18)
xlabel('Asset standard deviation [Annualized]')
ylabel('Asset mean return [Annualized]')
xlim([0 0.75])
ylim([-0.05 0.25])
saveFigures(gcf,'assets',false)

%% Markowitz procedure
clear y_out
%solve the markowitz opt problem and calculate efficient frontier
mu = linspace(min(AssetMean),max(AssetMean),20);
for i = 1:length(mu)
    cvx_begin quiet
    variable x(length(AssetMean))
    dual variable lambda;
    dual variable nu1;
    dual variable nu2;
    y = x'*AssetCovar*x;
    minimize (y);
    
    subject to
    -x <= 0 : lambda;
    mu(i) - AssetMean'*x == 0 : nu1;
    1 - ones(1,length(AssetMean))*x  == 0 : nu2;
    cvx_end
    
    x_out(:,i) = x;
    y_out(i) = y;
    
    %assertations
    z = lambda - nu1*AssetMean - nu2;
    dual_value = -1/4*(z')*AssetCovar^(-1)*z - nu1*mu(i) - nu2;

    %check the x value
    x_check = 1/2*AssetCovar^(-1)*z;

    %assert for mistakes
    assert(norm(x-x_check)<1e-3)
    assert(norm(y - dual_value)<1e-6)
    
    %lagrangian derivative == 0
    assert(max(2*AssetCovar*x-lambda+nu1*AssetMean+nu2)<1e-5)
    
    
end

cvx_begin quiet
variable x(length(AssetMean))
dual variable lambda;
dual variable nu1;
dual variable nu2;
ylow = x'*AssetCovar*x;
minimize (ylow);

subject to
-x <= 0 : lambda;
AssetMean'*x >=0 : nu1;
1 - ones(1,length(AssetMean))*x  == 0 : nu2;
cvx_end

figure(2)
plot(diag(sqrt(AssetCovar)),AssetMean,'r.')
text(diag(sqrt(AssetCovar)), AssetMean, AssetList, 'horizontal','left', 'vertical','bottom','fontsize',18)
xlabel('Asset standard deviation [Annualized]')
ylabel('Asset mean return [Annualized]')
xlim([0 0.75])
ylim([-0.05 0.25])
hold on
plot(sqrt(y_out),mu,'b--')
plot(sqrt(ylow),AssetMean'*x,'g*')
saveFigures(gcf,'asset-efficient-frontier',false)



%% Introduce the shorting problem
clear y_out
nu = 0.2:0.4:1;
mu = linspace(min(AssetMean),max(AssetMean)+0.5,20);
for j = 1:length(nu)
    for i = 1:length(mu)
        cvx_begin quiet
        variable xlong(length(AssetMean))
        variable xshort(length(AssetMean))
        y = (xlong - xshort)'*AssetCovar*(xlong - xshort);
        minimize (y);
        
        subject to
        xlong >= 0;
        xshort >= 0;
        
        ones(1,length(AssetMean))*(xlong-xshort)==1;
        AssetMean'*(xlong-xshort) == mu(i);
        ones(1,length(AssetMean))*xshort <= nu(j)*ones(1,length(AssetMean))*xlong
        cvx_end
        
        y_out(j,i) = y;
    end
end

figure(3)
hold on
colors = {'b--','k--','g--'};
for j = 1:length(nu)
    plot(sqrt(y_out(j,:)),mu,colors{j})
end
%legend('? = 0.2','? = 0.4','? = 1.0')
plot(diag(sqrt(AssetCovar)),AssetMean,'r.')
text(diag(sqrt(AssetCovar)), AssetMean, AssetList, 'horizontal','left', 'vertical','bottom','fontsize',18)
xlabel('Asset standard deviation [Annualized]')
ylabel('Asset mean return [Annualized]')
xlim([0 0.75])
ylim([-0.05 0.8])
saveFigures(gcf,'asset-shorting-efficient-frontier',false)

%% introduce linear transaction cost
clear y_out
fsell = [0,0.02,0.1];
fbuy = fsell;
mu = linspace(min(AssetMean),max(AssetMean),20);
xinit=rand(length(AssetMean),1);
xinit = xinit/sum(xinit);
for j = 1:length(fsell)
    for i = 1:length(mu)
        cvx_begin quiet
        variable ubuy(length(AssetMean))
        variable usell(length(AssetMean))
        y = (xinit + ubuy - usell)'*AssetCovar*(xinit + ubuy - usell);
        minimize (y);
        
        subject to
        ubuy >= 0;
        usell >= 0;
        
        (1-fsell(j))*ones(1,length(AssetMean))*usell==(1+fbuy(j))*ones(1,length(AssetMean))*ubuy;
        AssetMean'*(xinit + ubuy - usell) == mu(i);
        (xinit + ubuy - usell) >= 0;
        cvx_end
        
        y_out(j,i) = y;
    end
end
figure(4)
hold on
colors = {'b--','k--','g--'};
for j = 1:length(nu)
    plot(sqrt(y_out(j,:)),mu,colors{j})
end
plot(diag(sqrt(AssetCovar)),AssetMean,'r.')
text(diag(sqrt(AssetCovar)), AssetMean, AssetList, 'horizontal','left', 'vertical','top','fontsize',18)
xlabel('Asset standard deviation [Annualized]')
ylabel('Asset mean return [Annualized]')
plot(sqrt(xinit'*AssetCovar*xinit),AssetMean'*xinit,'go')
text(sqrt(xinit'*AssetCovar*xinit),AssetMean'*xinit, 'Initial portfolio', 'horizontal','left', 'vertical','bottom','fontsize',12)
xlim([0 0.75])
ylim([-0.05 0.3])
saveFigures(gcf,'asset-transaction-cost-efficient-frontier',false)

