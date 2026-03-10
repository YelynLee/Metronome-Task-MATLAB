function [rt, chosenPos] = collect_response(env)
% 6개 점 중 사용자가 정답을 선택할 때까지 대기하고, 클릭 위치와 반응시간 반환
% -----------------------------------------------------------
% 주요 논리
% env.dotRect: 화면상의 6개 점 영역 좌표(각각 사각형, 클릭판정 용도)
% GetMouse: 현재 마우스 좌표 및 클릭 상태 읽어옴
% 클릭 시점의 좌표가 dotRect 중 어디(몇 번째)에 들어가는지 판단
% chosenPos: 1~6 중 선택된 dot index, 'rt': 클릭까지 걸린 시간(초)
% 디바운스(짧게 여러번 눌림 방지)도 포함됨

nDot = size(env.dotRect,2); % 점의 총 개수
chosenPos = NaN; rt = NaN; % 초기값

tStart = GetSecs; % 반응 시작 시간

while isnan(chosenPos)
    [x, y, buttons] = GetMouse(env.winPtr); % 마우스 위치 및 클릭 상태 읽기

    if any(buttons)  % 마우스 버튼이 눌렸다면

        for k = 1:nDot
            inRect = IsInRect(x, y, env.dotRect(:,k)); % 각 점과 비교

            if inRect
                chosenPos = k; % 클릭된 dot index
                disp(['chosenPos set to: ' num2str(chosenPos)]);
                rt = GetSecs - tStart;  % 반응시간 계산

                % 디바운스: 클릭 후 0.1초 이내 중복입력 무시
                timeout = GetSecs + 0.1; % 1초 디바운스 제한
                while any(GetMouse(env.winPtr))
                    if GetSecs > timeout
                        break;
                    end
                    WaitSecs(0.01);
                end
                break;
            end

        end

    end

end

end
