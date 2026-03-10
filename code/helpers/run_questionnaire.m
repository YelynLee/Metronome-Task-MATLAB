function responses = run_questionnaire()
% 사전 설문을 위한 질문 제공 및 답변 반환

    prompts = {
        '1. 악기를 전문적으로 배워온 기간이 어느정도인가? (1: 없음, 2: 1년 이하, 3: 1년 이상)';
        '2. 평소에 음악을 즐겨 듣는가? (1: 거의 아님, 2: 어느정도, 3: 자주 즐겨 들음)';
        '3. 음악에 관련된 직업에 종사하는가? (1: 아님, 2: 어느정도, 3: 그렇다)';
        '4. 박자를 잘 맞추는 편인가? (1: 아님, 2: 어느정도, 3: 그렇다)';
        '5. 이러한 음악 관련 행동 실험에 참여한 적이 있는가? (1: 아님, 2: 어느정도, 3: 자주)'
    };

    dlgTitle = '음악 관련 사전 질문';
    numLines = 1;
    defaultAns = {'', '', '', '', ''};

    answer = inputdlg(prompts, dlgTitle, numLines, defaultAns);

    % 사용자가 취소한 경우
    if isempty(answer)
        errordlg('설문이 취소되었습니다.', '취소됨');
        responses = []; % 반환값은 빈 배열
        return;
    end

    % 숫자로 변환 및 유효성 검사
    responses = str2double(answer);
    if any(isnan(responses)) || any(~ismember(responses, [1 2 3]))
        errordlg('모든 항목에 대해 1, 2, 3 중 하나의 숫자를 입력해야 합니다.', '입력 오류');
        responses = []; % 오류 발생 시 빈 배열
        return;
    end

    % 사용자가 취소하지 않고, 답변이 유효했을 경우에만 설문 완료 메시지 박스를 표시
    msgbox('응답이 정상적으로 저장되었습니다. 감사합니다!', '설문 완료');

end
