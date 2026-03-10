function break_screen(env, cfg)
% 세션 간, 그리고 본 실험 세션 내의 쉬는 시간을 구현

    % 화면 메시지 설정
    message = sprintf(['It''s break time. Press Enter when you are ready.']);

    % 텍스트 출력
    Screen('TextSize', env.winPtr, 40);
    Screen('TextFont', env.winPtr, 'Arial');
    DrawFormattedText(env.winPtr, message, 'center', 'center', cfg.white);
    Screen('Flip', env.winPtr);

    % 엔터키 설정
    KbName('UnifyKeyNames');
    enterKey = KbName('Return');
    keyPressed = false;

    % 시간 측정 시작
    startTime = GetSecs();

    % 엔터키 입력 또는 최대 3분까지 대기
    while ~keyPressed
        [keyIsDown, ~, keyCode] = KbCheck;

        if keyIsDown && keyCode(enterKey)
            keyPressed = true;
        elseif GetSecs() - startTime >= cfg.breakDur % 최대 3분 간 대기
            keyPressed = true;
        end
    end
    
end
