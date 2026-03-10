function subj = get_subject_info(cfg)
% 피험자 정보 입력 및 데이터 파일 생성
% ----------------------------------------------------------------------
% 주요 논리
% 사용자에게 피험자 ID(숫자 또는 문자) 입력 요청
% 기존 ID 데이터 파일(.mat)이 있으면 ID 재입력
% 재입력했거나 없으면 새로운 subj이라는 struct 생성, subj.ID에 피험자 ID 저장

    % ID 입력 (빈 입력 방지)
    while true
        subjID = input('Subject ID (e.g., 0001): ', 's'); % 사용자로부터 문자열 입력
        subjID = strtrim(subjID); % 앞뒤 공백 제거

        if isempty(subjID)
            disp('ID를 반드시 입력해야 합니다!');
            continue;
        end % 입력이 있으면 루프 탈출

        % 피험자 데이터 파일 경로 생성
        fileName = fullfile(cfg.dataDir, sprintf('sub_%s.mat', subjID));

        % 파일 경로로 검색했을 때 기존 피험자 데이터가 있으면 재입력
        if exist(fileName, 'file')
            fprintf('[경고] 해당 ID (%s) 파일이 이미 존재합니다. 다른 번호를 입력하세요.\n', subjID);
            continue;
        end
        break; % 새 ID일 때만 루프 탈출
    end

    subj = initialize_subject_struct(subjID); % 새로운 struct 생성
    subj.cfgVersion = cfg.version; % 버전 정보 기록 (추후 분석 시 참고)
    subj.ID = subjID;
    fprintf('[New] Created subject %s\n', subjID);

end
