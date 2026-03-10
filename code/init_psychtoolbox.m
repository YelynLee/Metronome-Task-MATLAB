function env = init_psychtoolbox(cfg)
% 실험 환경의 동적인 설정값을 관리
% -----------------------------------------------------------
% 주요 논리
% 실험 화면, 오디오, 입력 등 PTB 환경 기본 세팅
% 중앙 좌표, 점 위치 등 모든 좌표는 화면 크기에 따라 재계산됨
% cfg를 활용해서 env로 화면 및 오디오 핸들 관리

    % ----- Screen 설정 -----
    screens = Screen('Screens');
    [env.winPtr, env.winRect] = Screen('OpenWindow', max(screens), cfg.bgColor, cfg.windowRect);
    Screen('BlendFunction', env.winPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', env.winPtr, cfg.textSize);

    % ----- 화면의 중심 좌표 계산 -----
    [xc, yc] = RectCenter(env.winRect);
    env.centerXY = [xc, yc];

    % ----- Audio 설정 -----
    InitializePsychSound(1);
    env.pahandle = PsychPortAudio('Open', [], 1, 1, cfg.fs, 2); % 2채널

    % ----- 커서 숨기기 & 키보드 에코 방지 -----
    HideCursor; ListenChar(2);

    % ----- 실제 화면 중심에 맞게 점 좌표 재계산 -----
    % 즉, cfg.dotRect는 상대좌표, env.dotRect는 화면 실제좌표
    dotR = (cfg.dotRect(3,1) - cfg.dotRect(1,1))/2; % 점 반지름
    for k = 1:6
        env.dotRect(:,k) = CenterRectOnPointd([-dotR -dotR dotR dotR], ...
            env.centerXY(1) + cfg.dotXY(1,k), ...
            env.centerXY(2) + cfg.dotXY(2,k));
    end

    % ----- 클릭 패드 위치 재계산 -----
    padW = cfg.padRect(3) - cfg.padRect(1);
    padH = cfg.padRect(4) - cfg.padRect(2);
    env.padRect = CenterRectOnPointd([0 0 padW padH], env.centerXY(1), env.centerXY(2)+300);

    % ----- 기타 환경 변수 -----
    env.bgColor = cfg.bgColor;  % 배경 색상(편의상 복제)
end
