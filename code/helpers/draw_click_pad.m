function draw_click_pad(env, cfg)
% 운동 조건시 직사각형의 클릭 패드를 화면의 중앙 하단에 그림
% ------------------------------------------------------------------
% 주요 변수
% env.padRect: 패드의 위치/크기
% cfg.padColorIdle: 패드의 기본 색상(검정색)

color = cfg.padColorIdle;
Screen('FillRect', env.winPtr, color, env.padRect);

% 패드 위에 안내 텍스트 표시
Screen('TextSize', env.winPtr, cfg.textSize-6);
msg = 'Click!';
textCol = [255 255 255]; % 흰색 텍스트
[textX, textY] = RectCenter(env.padRect); % 패드의 중앙 좌표 계산
Screen('DrawText', env.winPtr, msg, textX-60, textY-10, textCol);

end