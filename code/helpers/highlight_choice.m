function highlight_choice(env, chosenIdx)
% 피험자가 클릭한 위치만 빨간색으로 강조
% ------------------------------------------------------
% 주요 변수
% chosenIdx: 피험자 선택 위치(1~6)
% nDot: 점의 총 개수

nDot = size(env.dotRect,2);

% 선택 위치만 빨강, 나머지는 검정
for k = 1:nDot
    if k == chosenIdx
        color = [255 0 0];
    else
        color = [0 0 0];
    end
    Screen('FillOval', env.winPtr, color, env.dotRect(:,k));
end

end

