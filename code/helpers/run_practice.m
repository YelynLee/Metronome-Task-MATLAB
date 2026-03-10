function subj = run_practice(env, cfg, subj)
% 연습 세션을 랜덤 조건으로 실행하고, 실시간 요약 통계를 출력
% ------------------------------------------------------------------------------
% 주요 논리
% 4조건 × 12 trials = 48 trials, 각 trial의 조건은 무작위로 섞임
% trial 단위로 interval, 방향, Go-time, 정답위치 등이 모두 랜덤화
% 각 trial 데이터(trialResult)를 trials 배열에 누적 저장
% 최종적으로 summary(정확도, 평균 RT, 편향 등)를 계산해서 practiceSession에 포함
% summary는 실험 직후 터미널에 즉시 피드백

fprintf('[run_practice] 48 practice trials\n');

% ---- 세션 구조 예시 ----
practiceSession = struct( ...
    'type',      'practice', ... % 세션 타입 구분용
    'date',      datetime('now'), ...
    'trials',    [], ... % 추후 trial 배열로 확장
    'summary',   struct() ...
    );

nConds   = numel(cfg.cond); % 4개 조건
nRepeats = 12; % 각 조건당 12회씩 반복
nTrials  = nConds * nRepeats; % 총 48 trials

% 조건별 trial index(12회씩)를 무작위로 추출
condOrder = repmat(1:nConds, 1, nRepeats); 
condOrder = condOrder(randperm(length(condOrder))); 

trials = [];
for trialIdx = 1:nTrials
    condIdx = condOrder(trialIdx);
    cond = cfg.cond(condIdx);

    % ---- interval 무작위 선택
    interval = cfg.intervals(randi(numel(cfg.intervals)));  % 0.5 or 1.0s

    % ---- Go-time 후보 목록 준비
    if interval == 1.0
        goTimeList = [0.5 1.5 2.5 3.5 4.5 5.5];
    else
        goTimeList = [0.25 0.75 1.25 1.75 2.25 2.75];
    end

    % ---- Go-time 무작위 선택
    goTimeIdx = randi(6);
    goTime = goTimeList(goTimeIdx);

    % ---- 시계/반시계 방향 무작위로 선택
    if rand < 0.5
        seqDir = 1; % 시계 방향
    else
        seqDir = -1; % 반시계 방향
    end

    syncN = 5; % 동기화 간격 개수
    contN = goTimeIdx; % 유지 간격 개수

    if seqDir == 1
        % 시계 방향 정답 index 계산
        correctIdx = mod(syncN + contN - 1, 6) + 1;
    else
        % 반시계 방향 정답 index 계산 (0일 때 6으로 처리)
        tmpIdx = mod(1 - (syncN + contN - 1), 6);
        if tmpIdx == 0
            correctIdx = 6;
        else
            correctIdx = tmpIdx;
        end
    end

    % ---- trial 실행 및 결과 누적
    trialResult = run_trial(env, cfg, cond, interval, correctIdx, contN, trialIdx, 1, seqDir);

    % 디버깅 용도로 각 trial 결과를 실시간 출력
    seqStr = '시계'; if seqDir==-1, seqStr='반시계'; end
    fprintf('[PRAC %2d] cond=%s | interval=%.2fs | seqDir=%s | goTime=%.2fs (idx=%d) | contN=%d | correctIdx=%d\n', ...
        trialIdx, cond.name, interval, seqStr, goTime, goTimeIdx, contN, correctIdx);

    % 결과 누적
    trials = [trials, trialResult];
end

% ---- summary 연산 ----
nCorrect = sum([trials.correct]); % 전체 정답 trial 수
pCorrect = mean([trials.correct]); % 정확도 (비율)
meanRT   = mean([trials.rt]); % 평균 반응시간
bias     = mean([trials.chosenPos] - [trials.goPos]); % 위치 편향(음수=빨리, 양수=늦게)
stdResp  = std([trials.chosenPos] - [trials.goPos]); % 위치 표준편차

summary = struct( ...
    'nCorrect', nCorrect, ...
    'pCorrect', pCorrect, ...
    'meanRT',   meanRT, ...
    'bias',     bias, ...
    'stdResp',  stdResp ...
    );

% ---- 세션 데이터 누적 ----
practiceSession = struct( ...
    'type',   'practice', ...
    'date',   datetime('now'), ...
    'trials', trials, ...
    'summary', summary ...
);

if ~isfield(subj,'sessions') || isempty(subj.sessions)
    subj.sessions = practiceSession;
else
    subj.sessions(end+1) = practiceSession;
end

% ---- 디버깅용 연습 결과 즉시 피드백 ----
fprintf('\n[Practice 결과]\n');
fprintf('정확도: %.1f%%\n', pCorrect*100);
fprintf('평균 반응시간: %.2fs\n', meanRT);
fprintf('평균 위치 편향: %.2f (음수=빨리, 양수=늦게)\n', bias);
fprintf('표준편차: %.2f\n\n', stdResp);

end