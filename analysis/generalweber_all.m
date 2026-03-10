%%%Generalize Weber fraction을 통해 plot하기
%--> 파이선으로 대체했던 걸 다시 matlab을 통해 구현하기
%--> 모든 피험자 대상으로 general weber fraciton 적용하기

meanRT_all = [];
stdResp_all = [];

for subjIdx = 1:12
    fname = sprintf('sub_%04d.mat', subjIdx);
    if exist(fname, 'file')
        load(fname);  %sub_0001부터 sub_0012까지 전부 때려넣기
        sets = subj.sessions.setData;
        
        %rt와 sd 구분해서 따로따로 축적시키기
        for i = 1:numel(sets)
            rt = sets(i).summary.meanRT;
            sd = sets(i).summary.stdResp;
            meanRT_all(end+1,1) = rt;
            stdResp_all(end+1,1) = sd;
        end
    end
end

% weber fraction에 집어넣기 위해 제곱시켜 핸들링.
x_vals = meanRT_all.^2;
y_vals = stdResp_all.^2;

%polyfit을 통해  y = k*T^2 + c 이 함수 구현하도록 하기
p = polyfit(x_vals, y_vals, 1);  
x_fit = linspace(min(x_vals), max(x_vals), 100);
y_fit = polyval(p, x_fit);

%그래프 보여주기 showing
figure; hold on;
scatter(x_vals, y_vals, 60, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8]);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
xlabel('meanRT^2 (T^2)');
ylabel('stdResp^2 (σ^2)');
title('Generalized Weber Model Fit (All Subjects)');
legend('All Data Points', sprintf('Linear Fit: σ^2 = %.3f·T^2 + %.3f', p(1), p(2)), 'Location', 'best');
grid on;
%k_est는 곧 weber 계수를 의미함.
k_est=p(1);
%결과값도 같이 보여줄 수 있도록 하기
fprintf('\n[전체 피험자 Generalized Weber 회귀 결과]\n');
fprintf('Weber slope (k) = %.4f\n', k_est);
