function graceful_exit()
% 안전하게 실험을 종료하기 위한 절차 구현
% 실험 도중 에러가 발생하거나 문제가 생겨도 실험이 완전히 중단되지 않고 잘 마무리되도록 함

    try
        Screen('CloseAll');
        PsychPortAudio('Close');
    catch % 결과 오류 포착해서 무시
    end
    ListenChar(0); % 키보드 입력 제어 해제, 원래대로 복구
    ShowCursor; % 커서도 원래대로 복구

end