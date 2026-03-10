%%%쉬운 버전의 weber fraction polyfitting 하기



%cond 4개 구분하고 각 조건마다 색깔 배분하기 + 빈 struct 만들어두기
conds = {'V', 'VA', 'VM', 'VAM'};
cond_colors = lines(numel(conds)); 
data_by_cond = struct();

% 4가지 조건별로 데이터 축적시킬 struct 안에 빈 공간 만들어두기
for c = 1:numel(conds)
    data_by_cond.(conds{c}).meanRT = [];
    data_by_cond.(conds{c}).stdResp = [];
    data_by_cond.(conds{c}).WF = [];
end

% 데이터 수집 12명어치 집어넣기
for subjIdx = 1:12
    fname = sprintf('sub_%04d.mat', subjIdx);
    
    if exist(fname, 'file')
        load(fname);  %sub_0001부터 sub_0012까지 집어넣기
        sets = subj.sessions.setData;
        for i = 1:numel(sets)
            cond = sets(i).condName;         
            rt = sets(i).summary.meanRT;
            %다음과 같이 빈 구조물에 만든 cond로 구분한 공간에 하나씩 말미에 집어넣기
            if rt > 0 && rt <= 4
                data_by_cond.(cond).meanRT(end+1,1) = rt;
                data_by_cond.(cond).stdResp(end+1,1) = sd;
                data_by_cond.(cond).WF(end+1,1) = wf;
            end
            
        end
    end
end

% 그래프 나타낼 준비하기
figure; hold on;
legend_labels = {};

% 조건4개 마다 polyfit + plot
for c = 1:numel(conds)
    cond = conds{c};
    meanRT = data_by_cond.(cond).meanRT;
    WF = data_by_cond.(cond).WF;
    
    % polyfit 이용해서 함수 구현하기 
    %1차 직선을 피팅시키는거라 1을 표기
    %피팅시킬때의 x값은 100개로 쪼개서 연속적인 모습으로 최대한 그려지도록 함.
    p = polyfit(meanRT, WF, 1);
    x_fit = linspace(min(meanRT), max(meanRT), 100);
    y_fit = polyval(p, x_fit);

    % 점들을 산개하여 피팅함을 보여주었고, 그걸 plot을 통해 시각화한다.
    scatter(meanRT, WF, 60, cond_colors(c,:), 'filled', 'DisplayName', [cond ' data']);
    plot(x_fit, y_fit, '-', 'Color', cond_colors(c,:), 'LineWidth', 2,'DisplayName', sprintf('%s fit (slope=%.3f)', cond, p(1)));
    
end

% 그래프 꾸미기
xlabel('Mean RT (sec)');
ylabel('Weber Fraction (stdResp / meanRT)');
title('Weber Fraction vs Mean RT by Condition (RT <= 4 sec)');
legend('Location', 'best');
grid on;
