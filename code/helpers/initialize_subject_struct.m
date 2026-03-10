function subj = initialize_subject_struct(subjID)
% 피험자 데이터 구조체 기본 생성
% -----------------------------------------------------------
% 주요 변수
% ID: 피험자 ID 문자열
% created: 생성 시각(datetime)
% demographics: 설문 등 피험자 정보 저장
% cfgVersion: 실험 버전 (cfg.version에서 입력 권장)
% sessions: 각 연습과 본 실험 세션에서 trial 정보를 저장하기 위한 배열

subj = struct( ...
    'ID',           subjID, ...
    'created',      datetime('now'), ...
    'demographics', [], ...
    'cfgVersion',   '', ...
    'sessions',     [] ... % 각 세션 기록용 배열
    );

end