<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="EUC-KR">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>온라인 교육 동영상 강의</title> 
    <style>
        body { margin: 0; padding: 20px; background: #f4f4f4; font-family: sans-serif; }
        
        /* 💡 가로 800px 팝업창에 맞춰 컨텐츠 폭을 760px로 시원하게 늘렸습니다 */
        .video-container { width: 100%; max-width: 760px; margin: 0 auto; background: #000; }
        
        /* 💡 가로가 커진 만큼 16:9 비율에 맞게 영상 높이도 428px로 최적화했습니다 */
        iframe { width: 100%; height: 428px; border: none; display: block; }
        
        /* 퀴즈/문제 영역 스타일 스타일 */
        .quiz-container { max-width: 760px; margin: 20px auto; padding: 20px; background: white; border-radius: 6px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); box-sizing: border-box; }
        .quiz-title { font-size: 18px; margin-top: 0; margin-bottom: 15px; color: #333; border-bottom: 2px solid #28a745; padding-bottom: 8px; }
        .quiz-item { margin-bottom: 20px; }
        .quiz-item p { font-weight: bold; font-size: 15px; margin-bottom: 12px; color: #111; }
        .quiz-item label { display: block; margin-bottom: 8px; font-size: 14px; cursor: pointer; padding: 6px; border-radius: 4px; transition: background 0.2s; }
        .quiz-item label:hover { background: #f0f0f0; }
        
        /* 버튼 스타일 */
        .btn-submit { background: #28a745; color: white; border: none; padding: 12px 15px; border-radius: 4px; cursor: pointer; width: 100%; font-size: 15px; font-weight: bold; }
        .btn-submit:hover { background: #218838; }
    </style>
</head>
<body>

    <div class="video-container">
	    <c:choose>
	        <c:when test="${empty param.wkno or param.wkno eq 'undefined'}">
	            <iframe src="https://v.kr.kollus.com/nf8sE0Rq?" allow="local-network-access" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
	        </c:when>
	
	        <c:when test="${(param.wkno % 2) != 0}">
	            <iframe src="https://v.kr.kollus.com/nf8sE0Rq?" allow="local-network-access" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
	        </c:when>
	
	        <c:otherwise>
	            <iframe src="https://v.kr.kollus.com/x3hvE1T6?" allow="local-network-access" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
	        </c:otherwise>
	    </c:choose>
	</div>

    <div class="quiz-container">
        <h3 class="quiz-title">✏️ 강의 확인 퀴즈</h3>
        
        <form id="quizForm" onsubmit="submitQuiz(event)">
            <div class="quiz-item">
                <p>Q1. 오늘 배운 핵심 내용으로 올바른 것은?</p>
                <label><input type="radio" name="q1" value="1"> 1) 1번 선택지 내용</label>
                <label><input type="radio" name="q1" value="2"> 2) 2번 선택지 내용</label>
                <label><input type="radio" name="q1" value="3"> 3) 3번 선택지 내용</label>
            </div>
            
            <button type="submit" class="btn-submit">정답 제출</button>
        </form>
    </div>

    <script>
        // 정답 제출 시 실행될 함수
        function submitQuiz(event) {
            event.preventDefault(); // 폼 기본 제출 막기
            
            // 라디오 버튼 선택 값 가져오기
            const selectedValue = document.querySelector('input[name="q1"]:checked')?.value;
            
            if (!selectedValue) {
                alert("정답을 선택해 주세요!");
                return;
            }
            
            alert("제출되었습니다. 선택한 답안: " + selectedValue);
            // 여기에 나중에 DB로 결과를 보내는 Ajax 코드를 작성하시면 됩니다.
        }
    </script>

</body>
</html>