function save_full_data(cfg, subj)
% 전체 실험 세션(subj struct) 데이터를 .mat 파일로 저장하는 함수
% -----------------------------------------------------------
% 주요 논리
% 모든 세션 정보, 응답, 세부 trial 정보, summary까지 포함됨
% 피험자별 고유 ID로 자동 저장 (예시: sub_0001.mat)
% 저장 경로는 cfg에서 지정한 dataDir 하위에 생성됨

    % 피험자 ID 필드 생성
    subjID = subj.ID;

    % subjID를 이름으로 하는 피험자별 개별 파일 생성
    fileName = fullfile(cfg.dataDir, sprintf('sub_%s.mat', subjID));

    % 버전 정보, 저장 시점 기록 (추후 버전 관리 및 재현성 확보에 도움)
    subj.savedAt = datetime('now'); % 데이터 저장 시각
    subj.cfgVersion = cfg.version; % 실험 코드 버전

    % 실제 .mat 파일로 저장
    save(fileName, 'subj');

    % 저장 완료 메시지
    fprintf('[Saved] Data for subject %s saved to %s\n', subjID, fileName);
end
