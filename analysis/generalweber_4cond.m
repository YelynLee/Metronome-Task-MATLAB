%%%Generalized weber fraction에 집어넣기
%--> 발표에선 파이썬으로 구현했던걸 matlab으로 구현하기
%--> 조건 4개 상황 모두 달리에서 구하기

conds = {'V', 'VA', 'VM', 'VAM'};
cond_colors = lines(numel(conds));

% 조건 4개마다 빈 구조물을 만들어 정보를 적립시킬 공간을 만든다.
data_by_cond = struct();
for c = 1:numel(conds)
    data_by_cond.(conds{c}).meanRT = [];
    data_by_cond.(conds{c}).stdResp = [];
end

for subjIdx = 1:12
    fname = sprintf('sub_%04d.mat', subjIdx);
    if exist(fname, 'file')
        load(fname);  %sub_0001부터 sub_0012까지 전부 때려넣기
        sets = subj.sessions.setData;

        for i = 1:numel(sets)
            cond = sets(i).condName;
           
            %weber fraction에서 활용할 정보들 핸들링할 준비
            rt = sets(i).summary.meanRT;
            sd = sets(i).summary.stdResp;

            %마찬가지로 말미에 append해서 데이터 축적시키기
            data_by_cond.(cond).meanRT(end+1,1) = rt;
            data_by_cond.(cond).stdResp(end+1,1) = sd;
        end
    end
end

%Polyfit을 활용해서 시각화할 준비
figure; hold on;

for c = 1:numel(conds)
    cond = conds{c};
    rt_vals = data_by_cond.(cond).meanRT;
    sd_vals = data_by_cond.(cond).stdResp;
    
    %공식 대입을 위한 제곱하기
    x = rt_vals .^ 2;
    y = sd_vals .^ 2;
    
    % polyfit을 통해 시각화하기, 100개로 쪼개서 보기 편하도록 만들기
    p = polyfit(x, y, 1);  % σ² = k·T² + c
    x_fit = linspace(min(x), max(x), 100);
    y_fit = polyval(p, x_fit);

    % 그래프 showing
    scatter(x, y, 60, 'filled', 'MarkerFaceColor', cond_colors(c,:), ...
        'DisplayName', sprintf('%s data', cond));
    plot(x_fit, y_fit, '-', 'Color', cond_colors(c,:), 'LineWidth', 2, ...
        'DisplayName', sprintf('%s fit: k=%.3f, σ₀²=%.3f', cond, p(1), p(2)));

    % 결과물도 같이 제시하도록 구성
    fprintf('\n[%s 조건 회귀 결과]\n', cond);
    fprintf('Weber slope (k) = %.4f\n', p(1));
    fprintf('σ_indep (time-independent std) = %.4f\n', sqrt(p(2)));
end
%그래프 꾸미기
xlabel('meanRT² (T²)');
ylabel('stdResp² (σ²)');
title('Generalized Weber Model Fit by Condition');
legend('Location', 'best');
grid on;
