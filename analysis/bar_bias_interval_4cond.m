
% 조건별 * interval bias 평균 시각화, 8개 시각화하기


nSubjects = 12;
subject_prefix = 'sub_';
cond_list = {'V', 'VA', 'VM', 'VAM'};
interval_list = [0.5, 1.0];

% bias 저장: cell 구조로 만들어서 총 8가지 종류의 데이터 공간을 만듬
bias_data = cell(length(cond_list), length(interval_list));

for subjIdx = 1:nSubjects
    fileName = sprintf('%s%04d.mat', subject_prefix, subjIdx);
    load(fileName);  % 변수: sub_0001부터 sub_0012까지
    sets = subj.sessions.setData;
    
    %setData안의 trials 안에 있는 cond 조건들과 interval 조건들 추출 
    for s = 1:numel(sets)
        trials = sets(s).trials;
        for t = 1:length(trials)
            trial = trials(t);
            cond = sets(s).condName;
            interval = trial.interval;

            % real bias calculation
            diff = abs(trial.chosenPos - trial.goPos);
            hex_dist = min(diff, 6 - diff);

            %대표하는 interval 하나 추출하고 각 12번의 시도 중
            %대표하는 interval에 해당하는 값만을 추출해서 활용
            cond_idx = find(strcmp(cond_list, cond));
            interval_idx = find(interval_list == interval);

            bias_data{cond_idx, interval_idx}(end+1) = hex_dist;
            %추출한 것들을 다음과 같이 처음 설정한 셀에 저장시킴
        end
    end
end

%그렇게 모인 것들을 평균 계산을 위해 0으로 구성된 행렬 만들고 집어넣기
%총 8가지 조건에 대해서 평균값을 계산하고 bias_avg에 집어넣기 
bias_avg = zeros(length(cond_list), length(interval_list));
for c = 1:length(cond_list)
    for i = 1:length(interval_list)
        if ~isempty(bias_data{c,i})
            bias_avg(c,i) = mean(bias_data{c,i});
        end
    end
end


% Bar plot 막대그래프로 시각화하기 

figure;
bar(bias_avg, 'grouped');
set(gca, 'XTickLabel', cond_list);
legend({'interval = 0.5', 'interval = 1.0'}, 'Location', 'northeast');
ylabel('Average Bias (Hex Distance)');
xlabel('Condition');
title('Bias Comparison by Condition and Interval');
grid on;
