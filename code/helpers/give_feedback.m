function give_feedback(env, cfg, correctIdx)
% 실제 정답 위치만 흰색으로 강조
% --------------------------------------------------------------------------
% 주요 변수
% correctIdx: 실제 정답 위치(1~6)
% chosenIdx: 피험자 응답 위치(1~6 또는 NaN) → 현재 표시엔 사용되지 않음
% nDot: 점의 총 개수

nDot = size(env.dotRect,2);

% 정답 위치만 흰색, 나머지는 검정
for k = 1:nDot
    if k == correctIdx
        color = [255 255 255];
    else
        color = [0 0 0];
    end
    Screen('FillOval', env.winPtr, color, env.dotRect(:,k));
end
Screen('Flip', env.winPtr);
WaitSecs(1); % 피드백 1초 간 표시
end