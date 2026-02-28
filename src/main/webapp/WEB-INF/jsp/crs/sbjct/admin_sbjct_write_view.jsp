<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- 관리자 공통 head -->
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>

    <script type="text/javascript">
        /************************************************************
         * 과목 등록(프론트 테스트용) - 화면 이벤트만 구성
         *  - 저장/목록/중복확인/행추가/삭제 등은 알럿 또는 DOM 처리만
         ************************************************************/

        /* 상단 버튼: 저장 */
        function onSave() {
            alert("저장(프론트 테스트)");
            // 예: UiComm.messageBox 등 프로젝트 공통 메시지 함수가 있으면 여기에서 호출
        }

        /* 상단 버튼: 목록 */
        function onGoList() {
            alert("목록 이동(프론트 테스트)");
            // location.href = "<c:url value='/crs/crsMgr/crsListMain.do'/>";
        }

        /* 과목명 중복확인 */
        function checkSbjctNameDup() {
            var v = document.getElementById("sbjctNm").value || "";
            if (!v.trim()) { alert("과목명을 입력하세요."); return; }
            alert("과목명 중복확인(프론트 테스트) : " + v);
        }

        /* 과목코드 중복확인 */
        function checkSbjctCodeDup() {
            var v = document.getElementById("sbjctCd").value || "";
            if (!v.trim()) { alert("과목코드를 입력하세요."); return; }
            alert("과목코드 중복확인(프론트 테스트) : " + v);
        }

        /* 재생시간(분/초) → 총 초 표기 */
        function updateTotalSec() {
            var mm = parseInt(document.getElementById("playMin").value || "0", 10);
            var ss = parseInt(document.getElementById("playSec").value || "0", 10);
            if (isNaN(mm)) mm = 0;
            if (isNaN(ss)) ss = 0;
            if (ss >= 60) { mm += Math.floor(ss / 60); ss = ss % 60; }
            document.getElementById("playMin").value = mm;
            document.getElementById("playSec").value = ss;
            document.getElementById("totalSecText").innerText = (mm * 60 + ss);
        }

        /***********************
         * 돌발퀴즈 행 추가/삭제
         ***********************/
        var clipQuizSeq = 0;

        function addClipQuizRow(secVal) {
            clipQuizSeq++;

            var tbody = document.getElementById("clipQuizTbody");
            var tr = document.createElement("tr");

            tr.innerHTML =
                '<td data-th="초" style="white-space:nowrap;">' +
                '  <input class="form-control mr5" type="text" name="clipSec" value="' + (secVal || '') + '" style="width:90px;" placeholder="초" />' +
                '  <span>초</span>' +
                '</td>' +
                '<td data-th="퀴즈" class="t_left">' +
                '  <select class="form-select" name="clipQuiz" style="min-width:260px;">' +
                '    <option value="">돌발퀴즈 시점/문항 선택</option>' +
                '    <option value="Q1">문항 예시 1</option>' +
                '    <option value="Q2">문항 예시 2</option>' +
                '  </select>' +
                '</td>' +
                '<td data-th="검색" style="white-space:nowrap;">' +
                '  <button type="button" class="btn gray1" onclick="alert(\'퀴즈 검색(프론트 테스트)\');">검색</button>' +
                '</td>' +
                '<td data-th="관리" style="white-space:nowrap;">' +
                '  <button type="button" class="btn gray1" onclick="removeRow(this);">삭제</button>' +
                '</td>';

            tbody.appendChild(tr);
        }

        /***************************
         * 다국어 자막 행 추가/삭제
         ***************************/
        var srtSeq = 0;

        function addSrtRow(langVal) {
            srtSeq++;

            var tbody = document.getElementById("srtTbody");
            var tr = document.createElement("tr");

            tr.innerHTML =
                '<td data-th="언어코드" style="white-space:nowrap;">' +
                '  <select class="form-select" name="srtLang" style="width:140px;">' +
                '    <option value="en"' + (langVal === 'en' ? ' selected' : '') + '>영어</option>' +
                '    <option value="ko"' + (langVal === 'ko' ? ' selected' : '') + '>한국어</option>' +
                '    <option value="ja"' + (langVal === 'ja' ? ' selected' : '') + '>일본어</option>' +
                '    <option value="zh"' + (langVal === 'zh' ? ' selected' : '') + '>중국어</option>' +
                '  </select>' +
                '</td>' +
                '<td data-th="SRT 자막 첨부파일" class="t_left">' +
                '  <div class="form-inline">' +
                '    <input class="form-control mr5" type="file" name="srtFile" />' +
                '    <button type="button" class="btn gray1" onclick="alert(\'찾아보기는 file input으로 대체됨\');">찾아보기</button>' +
                '  </div>' +
                '</td>' +
                '<td data-th="관리" style="white-space:nowrap;">' +
                '  <button type="button" class="btn gray1" onclick="removeRow(this);">삭제</button>' +
                '</td>';

            tbody.appendChild(tr);
        }

        /* 공통: 행 삭제 */
        function removeRow(btn) {
            var tr = btn.closest("tr");
            if (tr) tr.remove();
        }

        document.addEventListener("DOMContentLoaded", function() {
            updateTotalSec();

            // 화면정의서처럼 샘플 초기 표시
            addClipQuizRow("2426");
            addClipQuizRow("3250");

            addSrtRow("en");
        });
        
        // 목록이동
        function viewSbjctList() {
            /*var kvArr = [];
            kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});*/

            document.location.href = 'redirect:/crs/sbjct/adminSbjctListView.do';
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">

    <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
    <form id="moveForm" method="post"></form>

    <%-- 관리자 상단 헤더 --%>
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <main class="common">
        <%-- 관리자 좌측 메뉴(aside) --%>
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <div id="content" class="content-wrap common">

            <!-- 상단(주차/기간): 기존 관리자 화면 규격 유지 -->
            <div class="admin_sub_top">
                <div class="date_info">
                    <i class="icon-svg-calendar" aria-hidden="true"></i>
                    <c:choose>
                        <c:when test="${not empty weekInfo}">
                            ${weekInfo}
                        </c:when>
                        <c:otherwise>
                            2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="admin_sub">
                <div class="sub-content">

                    <!-- 페이지 타이틀 -->
                    <div class="page-info">
                        <h2 class="page-title">과목 등록</h2>
                    </div>

                    <!-- 등록 영역 -->
                    <div class="box">

                        <!-- 타이틀 + 우측 버튼(저장/목록) -->
                        <div class="board_top">
                            <h3 class="board-title">등록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type1" onclick="onSave();">저장</button>
                                <button type="button" class="btn type2" onclick="viewSbjctList();">목록</button>
                            </div>
                        </div>

                        <!-- 입력 폼 -->
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col />
                                </colgroup>
                                <tbody>

                                <!-- 기관* -->
                                <tr>
                                    <th><label for="orgSel" class="req">기관</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select class="form-select" id="orgSel" name="orgSel" style="min-width:260px;">
                                                <option value="">선택</option>
                                                <option value="M1" selected>대학원</option>
                                                <option value="M2">평생교육</option>
                                                <option value="M3">학위과정</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 년도/학기/기수* -->
                                <tr>
                                    <th><label for="yearSel" class="req">년도/학기/기수</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select class="form-select mr5" id="yearSel" name="yearSel" style="width:120px;">
                                                <option value="2026">2026년</option>
                                                <option value="2025" selected>2025년</option>
                                                <option value="2024">2024년</option>
                                            </select>
                                            <select class="form-select" id="termSel" name="termSel" style="width:120px;">
                                                <option value="1">1학기</option>
                                                <option value="2" selected>2학기</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 학과* -->
                                <tr>
                                    <th><label for="deptSel" class="req">학과</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select class="form-select" id="deptSel" name="deptSel" style="min-width:260px;">
                                                <option value="" selected>선택</option>
                                                <option value="D1">국어국문학과</option>
                                                <option value="D2">회계트랙</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 과목명* + 중복확인 -->
                                <tr>
                                    <th><label for="sbjctNm" class="req">과목명</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control mr5" type="text" id="sbjctNm" name="sbjctNm"
                                                   placeholder="과목명 입력" style="width:320px;" />
                                            <button type="button" class="btn gray1" onclick="checkSbjctNameDup();">중복확인</button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 과목코드* + 중복확인 -->
                                <tr>
                                    <th><label for="sbjctCd" class="req">과목코드</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control mr5" type="text" id="sbjctCd" name="sbjctCd"
                                                   placeholder="과목코드 입력" style="width:220px;" />
                                            <button type="button" class="btn gray1" onclick="checkSbjctCodeDup();">중복확인</button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 과목 분류* -->
                                <tr>
                                    <th class="req">과목 분류</th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="sbjctType" id="sbjctType1" value="CREDIT" checked />
                                                <label for="sbjctType1">학점제</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="sbjctType" id="sbjctType2" value="TERM" />
                                                <label for="sbjctType2">기수제</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="sbjctType" id="sbjctType3" value="OPEN" />
                                                <label for="sbjctType3">공개강좌</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="sbjctType" id="sbjctType4" value="PARALLEL" />
                                                <label for="sbjctType4">병행교육</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 강의형태* -->
                                <tr>
                                    <th class="req">강의형태</th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="lectureType" id="lecType1" value="ONLINE" checked />
                                                <label for="lecType1">온라인</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="lectureType" id="lecType2" value="OFFLINE" />
                                                <label for="lecType2">오프라인</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="lectureType" id="lecType3" value="MIX" />
                                                <label for="lecType3">혼합</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 사용여부* -->
                                <tr>
                                    <th class="req">사용여부</th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="useYn" id="useY" value="Y" checked />
                                                <label for="useY">사용</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="useYn" id="useN" value="N" />
                                                <label for="useN">사용 안 함</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 과목설명(에디터 영역은 프로젝트별로 교체 가능) -->
                                <tr>
                                    <th><label for="sbjctDesc">과목설명</label></th>
                                    <td>
                                        <div class="form-row">
                                            <textarea id="sbjctDesc" name="sbjctDesc"
                                                      class="form-control resize-none"
                                                      style="height:220px;"
                                                      placeholder="내용을 입력하세요"></textarea>
                                            <%-- 프로젝트에 HtmlEditor(사이냅 등) 함수가 있으면 여기에서 초기화
                                            <script>
                                                if (typeof HtmlEditor === 'function') {
                                                    HtmlEditor('sbjctDesc', THEME_MODE, "/crs");
                                                }
                                            </script>
                                            --%>
                                        </div>
                                    </td>
                                </tr>

                                <!-- 저화질 업로드* -->
                                <tr>
                                    <th><label for="lowFile" class="req">저화질 업로드</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control" type="file" id="lowFile" name="lowFile" />
                                        </div>
                                        <small class="note">* 프론트 테스트용(실제 업로더는 백/컴포넌트 연동 시 교체)</small>
                                    </td>
                                </tr>

                                <!-- 고화질 업로드* -->
                                <tr>
                                    <th><label for="highFile" class="req">고화질 업로드</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input class="form-control" type="file" id="highFile" name="highFile" />
                                        </div>
                                    </td>
                                </tr>

                                <!-- 재생시간* -->
                                <tr>
                                    <th><label class="req">재생시간</label></th>
                                    <td>
                                        <div class="form-inline">
                                            <div class="input_btn mr5">
                                                <input class="form-control sm" type="text" id="playMin" name="playMin" maxlength="3"
                                                       style="width:80px;" onkeyup="updateTotalSec();" />
                                                <label>분</label>
                                            </div>
                                            <div class="input_btn mr5">
                                                <input class="form-control sm" type="text" id="playSec" name="playSec" maxlength="2"
                                                       style="width:80px;" onkeyup="updateTotalSec();" />
                                                <label>초</label>
                                            </div>
                                            <span>(총 <b id="totalSecText">0</b> 초)</span>
                                        </div>
                                    </td>
                                </tr>

                                </tbody>
                            </table>
                        </div>

                        <!-- 돌발퀴즈 -->
                        <div class="board_top" style="margin-top:10px;">
                            <h3 class="board-title">돌발퀴즈</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="addClipQuizRow('');">추가</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:18%">
                                    <col style="">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>시간(초)</th>
                                    <th>돌발퀴즈</th>
                                    <th>검색</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="clipQuizTbody">
                                <%-- JS로 행 생성 --%>
                                </tbody>
                            </table>
                        </div>

                        <!-- 다국어 자막 -->
                        <div class="board_top" style="margin-top:10px;">
                            <h3 class="board-title">다국어 자막</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="addSrtRow('');">추가</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:18%">
                                    <col style="">
                                    <col style="width:12%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>언어코드</th>
                                    <th>SRT 자막 첨부파일</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="srtTbody">
                                <%-- JS로 행 생성 --%>
                                </tbody>
                            </table>
                        </div>

                        <!-- 하단 중앙 버튼(등록/상세 페이지 공통 패턴) -->
                        <div class="btns" style="margin-top:20px;">
                            <button type="button" class="btn type1" onclick="onSave();">저장</button>
                            <button type="button" class="btn type2" onclick="onGoList();">목록</button>
                        </div>

                    </div><!-- //box -->
                </div>
            </div>

        </div>
    </main>
</div>
</body>
</html>
