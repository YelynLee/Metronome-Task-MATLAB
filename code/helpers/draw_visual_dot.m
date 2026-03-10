function draw_visual_dot(env, cfg, activeIdx)
% 6개 점 중 하나만 검정으로 표시하거나, 모두 숨기거나, 모두 표시함
% ------------------------------------------------------------------
% 주요 논리
% activeIdx == 0: 6개 점 모두 검정(go-cue 이후)
% activeIdx == -1: 6개 점 모두 배경색으로 숨김, fixation만 표시(유지)
% activeIdx == 1~6: 해당 번호의 점만 검정/나머지는 숨김, fixation 항상 표시(동기화)

nDot = size(env.dotRect,2);

if activeIdx == 0
    for k = 1:nDot
        Screen('FillOval', env.winPtr, [0 0 0], env.dotRect(:,k)); % 모두 검정
    end

elseif activeIdx == -1
    draw_fixation(env, cfg);

    for k = 1:nDot
        Screen('FillOval', env.winPtr, cfg.bgColor, env.dotRect(:,k)); % 모두 배경색
    end

else
    draw_fixation(env, cfg);

    for k = 1:nDot
        if k == activeIdx
            color = [0 0 0]; % 해당 번호의 점만 검정
        else
            color = cfg.bgColor; % 나머지는 배경색/숨김
        end
        Screen('FillOval', env.winPtr, color, env.dotRect(:,k));
    end

end

end
