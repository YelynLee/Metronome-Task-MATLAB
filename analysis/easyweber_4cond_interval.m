%%%Easy weber fraction으로 interval까지 구분해서 총 8개 직선 그리기
%--> scatter 한거 있으면 보기에 불편함.


condList = {'V', 'VA', 'VAM', 'VM'};
colors = lines(numel(condList));
lineStyles = {'-', '--'};    
% interval 0.5 = 실선, 1.0 = 점선

%For the every subjeact data!!!
all_meanRT = [];
all_stdResp = [];
all_weber = [];
all_condNames = {};
all_intervals = [];

for subjIdx = 1:12
    fname = sprintf('sub_%04d.mat', subjIdx);
    if exist(fname, 'file')
        load(fname); %sub_0001부터 sub_0012까지 전부 때려넣기
        sets = subj.sessions.setData;

        for i = 1:numel(sets)
            rt = sets(i).summary.meanRT;
            sd = sets(i).summary.stdResp;
            cond = sets(i).condName;
            %interval은 mode값으로 대표값으로 치환해서 그려내기
            trial_int = mode([sets(i).trials.interval]);

            if rt > 0
                wf = sd / rt;
            end

            all_meanRT(end+1,1) = rt;
            all_stdResp(end+1,1) = sd;
            all_weber(end+1,1) = wf;
            all_condNames{end+1,1} = cond;
            all_intervals(end+1,1) = trial_int;
        end
    end
end

%지금부터 polyfit으로 그려내기
figure; hold on;
legend_entries = {};

for c = 1:numel(condList)
    for intVal = [0.5, 1.0]
        %조건과 interval이 부합한지에 대해 구분하도록
        %조건과 interval이 정확히 우리가 원하는 대로 8가지 경우를 만족하도록
        %strcmp를 활용.
        idx = strcmp(all_condNames, condList{c});
        x = all_meanRT(idx);
        y = all_weber(idx);

        % polyfit으로 1차식 구성하기, 마찬가지로 100개로 쪼개서 부자연스럽지 않도록
        p = polyfit(x, y, 1);
        x_fit = linspace(min(x), max(x), 100);
        y_fit = polyval(p, x_fit);
        
        %실선과 점선으로 interval 구분해서 plot하기
        styleIdx = find([0.5, 1.0] == intVal);
        plot(x_fit, y_fit, lineStyles{styleIdx}, 'Color', colors(c,:), 'LineWidth', 2);

        legend_entries{end+1} = sprintf('%s (int %.1f)', condList{c}, intVal);
    end
end
%그래프 꾸미기
xlabel('Mean RT (sec)');
ylabel('Weber Fraction');
title('Weber Fraction vs Mean RT – All Subjects (Lines Only)');
legend(legend_entries, 'Location', 'best');
grid on;
