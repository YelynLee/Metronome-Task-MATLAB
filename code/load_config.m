function cfg = load_config()
% 실험 환경의 정적인 설정값을 관리
% 전체 실험 파라미터를 한 곳에서 처리함으로써 공통적으로 설정 및 수정 가능

    % ---------- 기본 실험 정보 설정 ----------
    cfg.expName  = 'InternalMetronome';
    cfg.version  = '2025‑06‑20‑final';  % 버전 표기(필요시 업데이트)

    % ---------- visual 설정 ----------
    PsychDefaultSetup(2);
    cfg.windowRect = [0 0 1920/2 + 100 1080/2 + 100];
    cfg.bgColor   = [128 128 128]; % 화면 배경색(0~255)
    cfg.white     = WhiteIndex(max(Screen('Screens'))); % 최대 밝기
    cfg.textSize  = 32; % 텍스트 크기

    % ---------- 좌표 설정 ----------
    % PTB 좌표계 기준 중심 좌표
    cfg.centerXY  = [0 0];

    % 6-choice 점 위치(정육각형 기준, 1시 방향부터 시계방향)
    radius = 160; % 점 반지름
    theta = deg2rad((0:5)*60) - deg2rad(60); % 1시방향 시작
    cfg.dotXY = [radius*cos(theta); radius*sin(theta)]; % 각 점의 상대좌표(2x6)
    dotR = 22; % 각 점의 크기

    for k = 1:6
        cfg.dotRect(:,k) = CenterRectOnPointd([-dotR -dotR dotR dotR], ...
                         cfg.centerXY(1)+cfg.dotXY(1,k), ...
                         cfg.centerXY(2)+cfg.dotXY(2,k));
    end

    % ---------- fixation point 설정 ----------
    cfg.fixRadius = 7; % 반지름 길이
    cfg.fixColor  = [0 0 0]; % 점 색상과 동일한 검정

    % ---------- 운동 조건 클릭 패드 설정 ----------
    padW = 140;  padH = 60;
    padYOffset = 120; % 화면 중앙에서 아래로 내릴 거리(조절 가능)
    screenBottom = cfg.windowRect(4);

    % 패드 중앙 Y좌표 결정(최하단을 넘지 않게)
    padCenterY = cfg.centerXY(2) + padYOffset;
    if (padCenterY + padH/2) > screenBottom - 20 % 하단 여유 20픽셀
        padCenterY = screenBottom - padH/2 - 20; % 화면 내에서만 있도록
    end

    cfg.padRect = CenterRectOnPointd([0 0 padW padH], ...
                 cfg.centerXY(1), padCenterY);
    cfg.padColorIdle  = [0 0 0]; % 패드 기본 색상(검정)

    % ---------- 응답 모드 ----------
    cfg.responseMode = 'mouse'; % 마우스 기반 응답

    % ---------- 조건(4가지, 각 조건의 audio/motor 여부) ----------
    cfg.cond = struct( ...
        'name',     { 'V', 'VA', 'VM', 'VAM' }, ...
        'hasAudio', {  0 ,   1 ,   0 ,    1  }, ...
        'hasMotor', {  0 ,   0 ,   1 ,    1  }  ...
    );
    % V  : 시각만, VA : 시각+청각, VM : 시각+운동, VAM : 셋다

    % ---------- timing 설정 ----------
    cfg.intervals   = [0.5 1.0]; % 메트로놈 템포
    cfg.nSyncDots   = 5; % 동기화 단계의 점 개수
    cfg.breakDur    = 3*60; % 휴식 시간 3분
    cfg.breakTrials = [98 196]; % 휴식이 필요한 trial 인덱스

    % ---------- audio 설정 ----------
    cfg.fs       = 44100; % 샘플링율
    cfg.beepFreq = 880; % beep 주파수(Hz)
    cfg.beepDur  = 0.05; % beep 지속(초)

    % ---------- keys 설정 ----------
    KbName('UnifyKeyNames');
    cfg.escapeKey = KbName('ESCAPE'); % ESC 키

    % ---------- data 저장경로 설정 ----------
    cfg.dataDir = fullfile(pwd,'data');
    if ~exist(cfg.dataDir,'dir'); mkdir(cfg.dataDir); end
    
end
