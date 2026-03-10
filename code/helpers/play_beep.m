function play_beep(env, cfg)
% 청각 조건시 점과 함께 짧은 신호음을 재생
% -----------------------------------------------------------------------
% 주요 변수
% env.pahandle: PsychPortAudio의 오디오 핸들
% cfg.beepFreq: beep의 주파수
% cfg.beepDur: beep의 길이
% cfg.fs: 샘플링율

% 사인파 기반 beep 생성
t = 0:1/cfg.fs:cfg.beepDur;
beep = 0.3 * sin(2*pi*cfg.beepFreq*t);

% 스테레오 채널 복제
beepStereo = [beep; beep];

% 버퍼 채우고 재생
PsychPortAudio('FillBuffer', env.pahandle, beepStereo);
PsychPortAudio('Start', env.pahandle, 1, 0, 1);

% beep가 끝날 때까지 대기, 짧은 여유(0.01s) 추가
WaitSecs(cfg.beepDur + 0.01);

% 정지 후 버퍼 비우기
PsychPortAudio('Stop', env.pahandle, 1);

end
