function subj = run_main_blocks(env, cfg, subj)
% 본 실험 세션을 랜덤 조건으로 실행하고, 실시간 요약 통계를 출력
% --------------------------------------------------------------------
% 주요 논리
% 총 24 sets × 12 trials = 288 trials, 4조건 × 6세트 씩 counterbalanced random 순서
% trial 단위로 interval, 방향, Go-time, 정답위치 등이 모두 랜덤화
% 각 블록별 summary (정확도, RT, 편향 등) 즉시 계산 및 출력

fprintf('[run_main_blocks] Starting main experimental session.\n');

nSets = 24; % 총 세트 수
trialsPerSet = 12; % 한 세트당 trial 수

% ---- 세션 구조 예시 ----
mainSession = struct( ...
    'type',    'main', ...
    'date',    datetime('now'), ...
    'setData', [] ... % set별 trial 저장용
);

trialIdx = 0; % 전체 trial 인덱스 (break/진행 관리용)

condOrder = repmat(1:4, 1, 6); % 각 조건 6번씩 (총 24개)
condOrder = condOrder(randperm(length(condOrder))); % 각 조건을 랜덤하게 배정

for setIdx = 1:nSets
    setTrials = [];
    condIdx = condOrder(setIdx); % 랜덤 순서지만 각 조건의 할당량은 유지
    cond = cfg.cond(condIdx);

    for t = 1:trialsPerSet
        trialIdx = trialIdx + 1;

        % ---- interval/Go-time 랜덤화, 방향 랜덤화, 정답계산 ----
        % trial 세부 로직은 run_trial에서 처리

        interval = cfg.intervals(randi(numel(cfg.intervals)));  % 0.5 or 1.0s

        % ---- Go-time 후보 목록 준비
        if interval == 1.0
            goTimeList = [0.5 1.5 2.5 3.5 4.5 5.5];
        else % interval == 0.5
            goTimeList = [0.25 0.75 1.25 1.75 2.25 2.75];
        end

        % ---- Go-time 무작위 선택
        goTimeIdx = randi(6);
        goTime    = goTimeList(goTimeIdx);

        % ---- 시계/반시계 방향 무작위로 선택
        if rand < 0.5 % 호출할 때마다 0~1 사이의 uniform random distribution 난수 하나 반환
            seqDir = 1;
        else
            seqDir = -1;
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
        trialResult = run_trial(env, cfg, cond, interval, correctIdx, contN, trialIdx, setIdx, seqDir);
        
        % 디버깅 용도로 각 trial 결과를 실시간 출력
        seqStr = '시계'; if seqDir==-1, seqStr='반시계'; end
        fprintf('[TRIAL %d] cond=%s | interval=%.2fs | seqDir=%s | goTime=%.2fs (idx=%d) | contN=%d | correctIdx=%d\n', ...
            trialIdx, cond.name, interval, seqStr, goTime, goTimeIdx, contN, correctIdx);

        % 결과 누적
        setTrials = [setTrials, trialResult];

        % 블록 중간 휴식 조건: 98회, 196회일 때
        if ismember(trialIdx, cfg.breakTrials)
            break_screen(env, cfg);
            start_screen(env, cfg);
        end
    end

    % ---- summary 연산 -----
    nCorrect = sum([setTrials.correct]);
    pCorrect = mean([setTrials.correct]);
    meanRT   = mean([setTrials.rt]);
    bias     = mean([setTrials.chosenPos] - [setTrials.goPos]);
    stdResp  = std([setTrials.chosenPos] - [setTrials.goPos]);

    blockSummary = struct( ...
        'nCorrect', nCorrect, ...
        'pCorrect', pCorrect, ...
        'meanRT',   meanRT, ...
        'bias',     bias, ...
        'stdResp',  stdResp ...
    );

    % ---- 세션 데이터 누적 ----
    mainSession.setData(setIdx).condName = cond.name;
    mainSession.setData(setIdx).trials   = setTrials;
    mainSession.setData(setIdx).summary  = blockSummary;

    % ---- 디버깅용 본 실험 결과 즉시 피드백 ----
    fprintf('\n[Block %d 결과]\n', setIdx);
    fprintf('정확도: %.1f%%\n', pCorrect*100);
    fprintf('평균 반응시간: %.2fs\n', meanRT);
    fprintf('평균 위치 편향: %.2f\n', bias);
    fprintf('위치 표준편차: %.2f\n\n', stdResp);

end

% ---- 세션 데이터 누적, 전체 세션 데이터(subject 구조체)에 추가 ----
if ~isfield(subj,'sessions') || isempty(subj.sessions)
    subj.sessions = mainSession;
else
    subj.sessions(end+1) = mainSession;
end

end
