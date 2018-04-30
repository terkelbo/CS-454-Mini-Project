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
plot(sqrt(MarketVar), MarketMean,'g.')
text(sqrt(MarketVar), MarketMean, 'Market Estimate', 'horizontal','left', 'vertical','bottom','fontsize',12)
hold on
plot(mean(sqrt(diag(AssetCovar))), mean(AssetMean),'g.')
text(mean(sqrt(diag(AssetCovar))), mean(AssetMean), 'Empirical Portfolio Mean', 'horizontal','left', 'vertical','bottom','fontsize',12)
plot(diag(sqrt(AssetCovar)),AssetMean,'r.')
text(diag(sqrt(AssetCovar)), AssetMean, AssetList, 'horizontal','left', 'vertical','bottom','fontsize',12)
xlabel('Asset standard deviation')
ylabel('Asset mean return')
xlim([0 0.75])
ylim([-0.05 0.25])

%% Markowitz procedure
%solve the markowitz opt problem
gamma = 1;
mu = linspace(min(AssetMean),max(AssetMean),20);
for i = 1:length(mu)
    cvx_begin quiet
    variable x(length(AssetMean))
    y = x'*AssetCovar*x;
    minimize (y);

    subject to
    x >= 0;
    ones(1,length(AssetMean))*x==1;
    AssetMean'*x == mu(i);
    cvx_end
    
    x_out(:,i) = x;
    y_out(i) = y;
end

plot(sqrt(y_out),mu,'b--')

%% Allow not to spend everything
%plot asset mean vs asset std
figure(2)
plot(sqrt(MarketVar), MarketMean,'g.')
text(sqrt(MarketVar), MarketMean, 'Market Estimate', 'horizontal','left', 'vertical','bottom','fontsize',12)
hold on
plot(mean(sqrt(diag(AssetCovar))), mean(AssetMean),'g.')
text(mean(sqrt(diag(AssetCovar))), mean(AssetMean), 'Empirical Portfolio Mean', 'horizontal','left', 'vertical','bottom','fontsize',12)
plot(diag(sqrt(AssetCovar)),AssetMean,'r.')
text(diag(sqrt(AssetCovar)), AssetMean, AssetList, 'horizontal','left', 'vertical','bottom','fontsize',12)
xlabel('Asset standard deviation')
ylabel('Asset mean return')
xlim([0 0.75])

%solve the markowitz opt problem
gamma = 1;
mu = linspace(min(AssetMean), 1,50);
for i = 1:length(mu)
    cvx_begin quiet
    variable x(length(AssetMean))
    y = x'*AssetCovar*x;
    minimize (y);

    subject to
    ones(1,length(AssetMean))*x<=1;
    ones(1,length(AssetMean))*x>=0;
    x >= 0;
    AssetMean'*x == mu(i);
    cvx_end
    
    x_out(:,i) = x;
    y_out(i) = y;
end

plot(sqrt(y_out),mu,'b--')