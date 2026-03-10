% ========================================
% 전체 파일(sub_0001~sub_0012) 조건별 육각형 bias 계산
% ========================================

%이게 진짜 bias 똑바로 계산해서 bar plot한거

% 파일 목록 생성

nSubjects = 12;
subject_prefix = 'sub_';
biasVals_all = [];
condNames_all = {};

for s = 1:nSubjects
    fileName = sprintf('%s%04d.mat', subject_prefix, s);
    load(fileName);  % sub0001부터sub0012 모아서 때려넣기
    sets = subj.sessions.setData;
    for i = 1:numel(sets)
        trials = sets(i).trials;

        goPos = [trials.goPos];
        chosenPos = [trials.chosenPos];

        %Real bias calculation, bias=0 or 1 or 2 or 3
        diff = abs(chosenPos - goPos);
        hex_dist = min(diff, 6 - diff);

        % average bias per subject
        bias = mean(hex_dist);
        biasVals_all(end+1,1) = bias;
        condNames_all{end+1,1} = sets(i).condName;
    end
end
%조건들 4개 나눈거
condList = {'V', 'VA', 'VAM', 'VM'};
avgBias = zeros(numel(condList), 1);

for i = 1:numel(condList)
    idx = strcmp(condNames_all, condList{i});
    avgBias(i) = mean(biasVals_all(idx));
end

% -------------------------------
% 결과 bar plot
% -------------------------------
figure;
bar(avgBias, 'FaceColor', [0.2 0.6 0.8]);
set(gca, 'XTick', 1:numel(condList), 'XTickLabel', condList);
ylabel('Mean Hex Distance (Bias)');
xlabel('Condition');
title('Average Bias Across Subjects (sub\_0001 ~ sub\_0012)');
grid on;
