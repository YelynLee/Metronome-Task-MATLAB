function start_screen(env, cfg)
% 실험 시작을 위한 초기 화면 구성

    DrawFormattedText(env.winPtr, 'Press Any Key to Begin', 'center','center', cfg.white);
    Screen('Flip', env.winPtr);
    KbWait([], 2); % 키 입력 대기

end