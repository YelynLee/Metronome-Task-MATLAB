%Easy weber fraction polyfit으로 피팅시키기 for 전체 피험자들 대상
meanRT_all = [];
weber_all = [];

for subjIdx = 1:12
    fname = sprintf('sub_%04d.mat', subjIdx);
    if exist(fname, 'file')
        load(fname); %sub_0001부터 sub_0012까지 전부 때려넣기
        sets = subj.sessions.setData;
        
        for i = 1:numel(sets)
            rt = sets(i).summary.meanRT;
            sd = sets(i).summary.stdResp;
            wf = sd / rt;    
            %append처럼 말미에 붙여서 누적시켜 집어넣기
            meanRT_all(end+1, 1) = rt;
            weber_all(end+1, 1) = wf;
        end
    end
end

%이제 밑의 코드들을 통해 scatter한 점들과 polyfit시킨 그래프 동시에 시각화하기
figure; hold on;

%scatter한 점들
scatter(meanRT_all, weber_all, 60, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8]);

% polyfit을 통해 regression 직선 보여주기, 1차 회귀 곡선줌
%100개로 쪼갠걸 이어서 부자연스럽지 않게 만들어
p = polyfit(meanRT_all, weber_all, 1);
x_fit = linspace(min(meanRT_all), max(meanRT_all), 100);
y_fit = polyval(p, x_fit);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);

% 그래프 꾸미기
xlabel('Mean RT (sec)');
ylabel('Weber Fraction (stdResp / meanRT)');
title('Weber Fraction vs Mean RT (All Subjects)');
legend('All Data Points', sprintf('Linear Fit (slope=%.3f)', p(1)), 'Location', 'best');
grid on;

%weber fraction을 통해 구한 값 보여주기
fprintf('\n[전체 피험자 회귀 결과]\n');
fprintf('기울기 (slope, p(1)) = %.4f\n', p(1));
fprintf('절편 (intercept, p(2)) = %.4f\n', p(2));
