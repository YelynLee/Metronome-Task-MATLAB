
% Bias & p_correct 분석 (demographics 합 ≥ 9 대상 + 9 미만인 피험자들)


subject_prefix = 'sub_';
nSubjects = 12;

all_bias = [];
all_pcorr = [];

for s = 1:nSubjects
    fileName = sprintf('%s%04d.mat', subject_prefix, s);
    load(fileName); 

    % calculating demographics
    %demographic이 struct array인 경우 fieldnames 함수로 이름을 추출하고
    %그 추출한 거에서 첫번째 값을 가져오면 그 값을 다시 계산가능한 수로 바꿔주고자
    %double을 취함. 아닌 경우, 바로 double 취해서 계산할 수 있도록 함.
    if isstruct(subj.demographics)
        demo_fields = fieldnames(subj.demographics);
        demo_data = subj.demographics.(demo_fields{1});
        demo = double(demo_data);
    else
    % 구조체가 아니면 바로 double로 변환
        demo = double(subj.demographics);
    end

    %이 코드를 통해 9보다 작은 경우 --> for문 나가게됨
    %이 부분이랑 plot하는 부분만 부등식 방향만 바꾸게 되면 9 이상인 경우,
    %9 미만인 경우 둘다 plot하기 가능
    if sum(demo(:)) < 9
        continue;  
    end

    sets = subj.sessions.setData;

    for i = 1:numel(sets)
        trials = sets(i).trials;
        goPos = [trials.goPos];
        chosenPos = [trials.chosenPos];

        % bias 계산 (육각형 거리 기준)
        raw_diff = abs(chosenPos - goPos);
        bias = mean(min(raw_diff, 6 - raw_diff));

        % 정확도
        pcorr = sets(i).summary.pCorrect;

        %end+1을 사용해서 python의 append처럼 누적시키기
        all_bias(end+1) = bias;
        all_pcorr(end+1) = pcorr;
    end
end

% Bar plot 시각화
figure;

subplot(1,2,1);
bar(mean(all_bias), 'FaceColor', [0.2 0.6 0.8]);
ylabel('Mean Bias');
title('Bias (demographic sum >= 9)');
ylim([0 3]);
grid on;

subplot(1,2,2);
bar(mean(all_pcorr), 'FaceColor', [0.4 0.7 0.4]);
ylabel('Mean p_{correct}');
title('Accuracy (demographic sum >= 9)');
ylim([0 1]);
grid on;

sgtitle('Bias & Accuracy (Filtered by Demographic >= 9)');
