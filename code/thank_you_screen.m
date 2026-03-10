function thank_you_screen(env, cfg)
% 실험 종료를 위한 마지막 화면 구성

    DrawFormattedText(env.winPtr, 'Thank you for your participation', 'center','center', cfg.white);
    Screen('Flip', env.winPtr);
    WaitSecs(2)
    
end