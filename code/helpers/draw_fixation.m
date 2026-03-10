function draw_fixation(env, cfg)
% 화면 중앙에 작은 원으로 fixation을 그림
% ------------------------------------------------------------------
% 주요 변수
% cfg.fixRadius: fixation의 반지름 길이
% env.centerXY: 화면 중앙 좌표
% cfg.fixColor: fixation의 색상(검정색)

fixRect = CenterRectOnPointd([-cfg.fixRadius -cfg.fixRadius cfg.fixRadius cfg.fixRadius], ...
                              env.centerXY(1), env.centerXY(2));
Screen('FillOval', env.winPtr, cfg.fixColor, fixRect);
    
end