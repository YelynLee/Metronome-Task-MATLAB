function trial = run_trial(env, cfg, cond, interval, correctIdx, contN, trialIdx, setIdx, seqDir)
% 동기화/학습, 유지, go-cue, 응답, 피드백 단계까지 하나의 trial 전체를 담당
% trial의 모든 세부 정보와 결과는 trial struct로 반환
% ------------------------------------------------------------------------------
% 주요 입력 변수
% cond: 해당 trial의 조건(struct, 예: V/VA/VM/VAM)
% interval: 각 점 간 시간 간격(0.5s 또는 1.0s)
% correctIdx: 해당 trial에서 정답이 되는 점 위치(1~6)
% contN: 유지 단계의 반복 횟수(1~6)
% trialIdx, setIdx: 인덱스 정보
% seqDir: 시계(1) 또는 반시계(-1) 방향

% 결과를 저장하기 위한 trial struct 초기화
trial = struct();
trial.cond     = cond.name;
trial.interval = interval;
trial.goPos    = correctIdx;
trial.trialIdx = trialIdx;
trial.setIdx   = setIdx;

% ----------- 1. 동기화 단계 (5 intervals) -----------

% dotOrder: 동기화 단계에서 점이 나타나는 순서 (시계/반시계 방향 지정)
if seqDir == 1
    dotOrder = [1 2 3 4 5]; % 시계 방향
else
    dotOrder = [1 6 5 4 3]; % 반시계 방향
end

% ---- 운동 조건: 패드 생성 및 커서 노출 ----
if cond.hasMotor
    ShowCursor;
    [xc, yc] = RectCenter(env.padRect);
    padCenter = [xc, yc];
    SetMouse(padCenter(1), padCenter(2), env.winPtr); % 커서를 패드 중앙에 위치

    % 패드만 단독으로 2초간 먼저 표시 (준비 안내)
    draw_click_pad(env, cfg);
    Screen('Flip', env.winPtr);
    WaitSecs(2.0);

    % 5회 동기화 반복 (점과 패드를 동시에 표시)
    for i = 1:cfg.nSyncDots
        % 패드 그리기
        draw_click_pad(env, cfg);

        % 점 그리기
        activeIdx = dotOrder(i);
        draw_visual_dot(env, cfg, activeIdx);

        Screen('Flip', env.winPtr);

        % 청각 조건: beep 추가
        if cond.hasAudio
            play_beep(env, cfg);
        end

        % interval 대기
        WaitSecs(interval);
    end

    % 패드 숨기기 (종료)
    Screen('FillRect', env.winPtr, cfg.bgColor, env.padRect);
    Screen('Flip', env.winPtr);
    HideCursor;

else
    % ---- 운동 조건이 아닐 때: 점만 표시, 패드 없음
    for i = 1:cfg.nSyncDots
        activeIdx = dotOrder(i);
        draw_visual_dot(env, cfg, activeIdx);
        Screen('Flip', env.winPtr);

        if cond.hasAudio
            play_beep(env, cfg);
        end

        WaitSecs(interval);
    end  
end

% ----------- 2. 유지 단계 (1~6 intervals) -----------
% 디버깅 용도로 activeIdx 계산하고 출력
for i = 1:contN
    syncN = 5;

    if seqDir == 1 % 시계 방향: 6개 점을 순환
        activeIdx = mod(syncN + i - 1, 6) + 1;
    else % 반시계 방향: 6개 점을 역순환 (0이면 6번 dot)
        tmpIdx = mod(1 - (syncN + i - 1), 6);
        if tmpIdx == 0
            activeIdx = 6;
        else
            activeIdx = tmpIdx;
        end
    end

    fprintf('[CONT] interval #%d → activeIdx(dot #%d)\n', i, activeIdx);

    % 모두 숨김(-1) 상태로 그리기
    draw_visual_dot(env, cfg, -1);
    Screen('Flip', env.winPtr);
    % interval 대기
    WaitSecs(interval);
end

% ----------- 3. go-cue 및 응답 -----------
% (1) 응답 준비
% 모든 점을 검정색으로 표시(0)
draw_visual_dot(env, cfg, 0);
Screen('Flip', env.winPtr);
   
% 커서를 화면 중앙에 노출
ShowCursor;
SetMouse(env.centerXY(1), env.centerXY(2), env.winPtr);

% (2) 응답 대기
% 선택한 점의 위치 및 반응 시간을 반환
[tResp, chosenPos] = collect_response(env);

% 응답 직후 커서 숨김
HideCursor;

% (3) 응답 표시
highlight_choice(env, chosenPos); % 선택한 위치만 빨간색으로 1초 간 강조
Screen('Flip', env.winPtr);
disp('Highlight 표시 완료'); % 디버깅 용도
WaitSecs(1);

% (4) 피드백을 위한 스페이스바 입력 대기
KbName('UnifyKeyNames');
disp('스페이스바 대기 진입'); % 디버깅 용도

while true
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && keyCode(KbName('space'))
        disp('스페이스바 감지!'); % 디버깅 용도
        break;
    end
end

% ----------- 4. 피드백 -----------
% 실제 정답 위치를 흰색으로 강조
give_feedback(env, cfg, correctIdx);

% ----------- trial 결과 저장 -----------
trial.chosenPos = chosenPos; % 피험자 선택 위치(1~6)
trial.rt        = tResp; % 반응 시간
trial.correct   = (chosenPos == correctIdx); % 정오 여부
trial.timestamp = now; % 현재 시간

% ----------- 모든 점/패드를 숨기고 2초 간 대기 -----------
Screen('FillRect', env.winPtr, cfg.bgColor);
Screen('Flip', env.winPtr);
WaitSecs(3.0);

end
