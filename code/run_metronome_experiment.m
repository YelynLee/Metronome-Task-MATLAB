function run_metronome_experiment()
% 메트로놈 과제의 주요 실행 함수
% -------------------------------------------------
% 주요 논리
% cfg, env로 환경 설정값을 한 곳에서 관리
% 피험자 데이터를 struct로 관리
% 연습 및 본 실험 세션 실행
% 피험자 데이터 저장 및 안전 종료

    clearvars; clc; % 작업 공간 및 명령 창 초기화
    addpath(genpath('helpers')); % helpers 폴더 경로 등록

    cfg = load_config(); % 실험 설정 가져오기
    subj = get_subject_info(cfg); % 피험자 struct 생성해서 가져오기
    rng('shuffle'); % 랜덤 시드(실험 재현성 최소화)

    try
        % 디버깅용 연습 세션 스킵 기능 추가
        skipPractice = false;
        resp = input('연습 세션을 건너뛰시겠습니까? (Y/N): ', 's'); % Y면 skip

        % 실험 시작 전 gui로 사전 설문
        if isempty(subj.demographics) % 설문은 최초 1회에만 진행
            surveyresponse = run_questionnaire();

            if isempty(surveyresponse) % 피험자가 취소하거나 답변이 유효하지 않으면 빈 배열을 반환
                error("Stop!"); % 실험 종료
            end

            subj.demographics = surveyresponse; % 설문 답변을 저장
        end         

        env = init_psychtoolbox(cfg); % 화면 및 오디오 초기화
        start_screen(env, cfg); % 시작 화면(아무 키 누르기)      

        % --- 연습 세션 건너뛰기 여부 ---
        % 이전의 질문에서 답변이 Y/Yes면 skip
        if any(strcmpi(resp, {'y','yes'}))
            skipPractice = true;
            fprintf('연습 세션을 건너뜁니다. 바로 본 실험을 시작합니다.\n');
        end

        % 답변이 Y/Yes가 아닐 경우 연습 세션 실행
        if ~skipPractice
            WaitSecs(2);
            subj = run_practice(env, cfg, subj);

            % --- 세션 간 쉬는 시간 ---
            break_screen(env, cfg, 0, 0);
            start_screen(env, cfg); % 쉬는 시간 이후 다시 시작 화면으로
        end

        % 본 실험 세션 진행
        WaitSecs(2);
        subj = run_main_blocks(env, cfg, subj);

        thank_you_screen(env, cfg); % 종료 화면
              
        save_full_data(cfg, subj); % 모든 데이터 저장
        graceful_exit(); % 안전 종료

    catch ME
        graceful_exit(); % 에러 발생시에도 원래대로 복구
        rethrow(ME); % 에러 메시지 재출력
    end

end
