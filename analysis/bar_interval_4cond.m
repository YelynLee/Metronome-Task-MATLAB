% ========================================
% 조건(cond)별 + interval별 p_correct 평균 시각화 (8개 bar plot)
% ========================================

nSubjects = 12;
subject_prefix = 'sub_';
cond_list = {'V', 'VA', 'VM', 'VAM'};
interval_list = [0.5, 1.0];

% p_correct로 입력된 정확도들을 cell로 저장 --> {cond_idx, interval_idx}
pcorr_data = cell(length(cond_list), length(interval_list));

for subjIdx = 1:nSubjects
    fileName = sprintf('%s%04d.mat', subject_prefix, subjIdx);
    load(fileName);  % sub_0001부터 sub_0012까지
    sets = subj.sessions.setData;

    %setData안의 trials 안에 있는 cond 조건들과 interval 조건들 추출 
    for s = 1:numel(sets)
        trials = sets(s).trials;
        for t = 1:length(trials)
            trial = trials(t);
            cond = sets(s).condName;
            interval = trial.interval;

            %대표하는 interval 하나 추출하고 각 12번의 시도 중
            %대표하는 interval에 해당하는 값만을 추출해서 활용
            cond_idx = find(strcmp(cond_list, cond));
            interval_idx = find(interval_list == interval);
            
            %위에서 만든 pcorr_data 셀에 trial안에 있는 correct 부분을 그대로 집어넣음
            %1과 0으로만 구성되서 계산하기 용이하도록
            pcorr_data{cond_idx, interval_idx}(end+1) = trial.correct;
        end
    end
end

% 0으로 구성된 행렬들을 만들어서 이번에는 평균값을 계산해서 집어넣기 
pcorr_avg = zeros(length(cond_list), length(interval_list));
for c = 1:length(cond_list)
    for i = 1:length(interval_list)
        if ~isempty(pcorr_data{c,i})
            pcorr_avg(c,i) = mean(pcorr_data{c,i});
        end
    end
end


% Bar plot, 막대그래프로 시각화하기

figure;
bar(pcorr_avg, 'grouped');
set(gca, 'XTickLabel', cond_list);
legend({'interval = 0.5', 'interval = 1.0'}, 'Location', 'northeast');
ylabel('Average p_{correct}');
xlabel('Condition');
title('p_{correct} Comparison by Condition and Interval');
ylim([0 1]);
grid on;
