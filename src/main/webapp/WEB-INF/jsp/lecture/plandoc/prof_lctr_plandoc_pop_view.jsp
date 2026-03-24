<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>

<body class="home colorA ${bodyClass}">
<div id="wrap" class="main">

    <main class="common">

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">강의계획서</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li><span class="current">강의계획서</span></li>
                            </ul>
                        </div>
                    </div>
                    <div class="board_top">
                        <h3 class="board-title">강의계획서 상세정보</h3>
                    </div>

                    <!-- 과목 정보 -->
                    <h4 class="sub-title">과목 정보</h4>
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>과목번호</label></li>
                            <li><c:out value="${subjectInfo.crclmnNo}"/></li>
                            <li class="head"><label>분반</label></li>
                            <li><c:out value="${subjectInfo.dvclasNo}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>과목명 (한글)</label></li>
                            <li><c:out value="${subjectInfo.sbjctnm}"/></li>
                            <li class="head"><label>과목명 (영문)</label></li>
                            <li><c:out value="${subjectInfo.sbjctEnnm}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>학과</label></li>
                            <li><c:out value="${subjectInfo.deptnm}"/></li>
                            <li class="head"><label>학점</label></li>
                            <li><c:out value="${subjectInfo.crdts}"/></li>
                        </ul>
                    </div>

                    <!-- 교수 정보 -->
                    <h4 class="sub-title">교수 정보</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>교수</th>
                                <th>소속</th>
                                <th>연락처</th>
                                <th>이메일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td data-th="교수">담당교수 : <c:out value="${profInfo.usernm}"/></td>
                                <td data-th="소속"><c:out value="${profInfo.deptnm}"/></td>
                                <td data-th="연락처"><c:out value="${profInfo.offiPhn}"/></td>
                                <td data-th="이메일"><c:out value="${profInfo.eml}"/></td>
                            </tr>

                            <c:choose>
                                <c:when test="${not empty coprofList}">
                                    <c:forEach var="r" items="${coprofList}">
                                        <tr>
                                            <td data-th="교수">공동교수 : <c:out value="${r.usernm}"/></td>
                                            <td data-th="소속"><c:out value="${r.deptnm}"/></td>
                                            <td data-th="연락처"><c:out value="${r.offiPhn}"/></td>
                                            <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <div class="msg-box basic">
                        <ul class="list-asterisk">
                            <li>담당교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>
                            <li>개발교수 : 강의 콘텐츠(학습 동영상)를 제작하는 교수</li>
                            
                        </ul>
                    </div>

                    <!-- 튜터 정보 -->
                    <h4 class="sub-title">튜터 정보</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>튜터</th>
                                <th>연락처</th>
                                <th>핸드폰</th>
                                <th>이메일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty tutList}">
                                    <c:forEach var="r" items="${tutList}">
                                        <tr>
                                            <td data-th="튜터"><c:out value="${r.usernm}"/></td>
                                            <td data-th="연락처"><c:out value="${r.homePhn}"/></td>
                                            <td data-th="핸드폰"><c:out value="${r.mblPhn}"/></td>
                                            <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="t_center">데이터가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- 조교 정보 -->
                    <h4 class="sub-title">조교 정보</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>조교</th>
                                <th>연락처</th>
                                <th>핸드폰</th>
                                <th>이메일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty assiList}">
                                    <c:forEach var="r" items="${assiList}">
                                        <tr>
                                            <td data-th="튜터"><c:out value="${r.usernm}"/></td>
                                            <td data-th="연락처"><c:out value="${r.homePhn}"/></td>
                                            <td data-th="핸드폰"><c:out value="${r.mblPhn}"/></td>
                                            <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="t_center">데이터가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>


                    <!-- 강의 개요 -->
                    <h4 class="sub-title">강의 개요</h4>
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>교과목 개요</label></li>
                            <li><c:out value="${lctrPlandocInfo.crclmnOtln}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>강의 목표</label></li>
                            <li><c:out value="${lctrPlandocInfo.lctrGoal}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>운영 방침</label></li>
                            <li><c:out value="${lctrPlandocInfo.lctrOpGdln}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>운영 계획</label></li>
                            <li><c:out value="${lctrPlandocInfo.lctrOpPlan}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>관련 과목 내용</label></li>
                            <li><c:out value="${lctrPlandocInfo.rltdSbjctCts}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>참고 사항</label></li>
                            <li><c:out value="${lctrPlandocInfo.remakrs}"/></li>
                        </ul>
                    </div>

                    <!-- 교재 -->
                    <h4 class="sub-title">교재</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:7%">
                                <col style="width:10%">
                                <col style="">
                                <col style="width:20%">
                                <col style="width:21%">
                                <col style="width:16%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>No</th>
                                <th>구분</th>
                                <th>교재명</th>
                                <th>ISBN</th>
                                <th>저자</th>
                                <th>출판사</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${empty txtbkList}">
                                <tr>
                                    <td colspan="6" class="t_center">데이터가 없습니다.</td>
                                </tr>
                            </c:if>
                            <c:forEach var="row" items="${txtbkList}" varStatus="st">
                                <tr>
                                    <td data-th="번호"><c:out value="${st.count}"/></td>
                                    <td data-th="구분"><c:out value="${row.txtbkGbnnm}"/></td>
                                    <td data-th="교재명"><c:out value="${row.txtbknm}"/></td>
                                    <td data-th="ISBN"><c:out value="${row.isbn}"/></td>
                                    <td data-th="저자"><c:out value="${row.wrtr}"/></td>
                                    <td data-th="출판사"><c:out value="${row.pblshr}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 제공파일(강의노트/음성파일/실습지도) : 값 없으면 '-' -->
                    <div class="file-wrap">
                        <ul class="add_file">
                            <li>
                                <div class="tit_area">
                                    <span class="tit">강의노트 :</span>
                                    <c:choose>
                                        <c:when test="${not empty fileInfo.noteFileId}">
                                            <a href="javascript:void(0);" class="file_down" onclick="downloadFile('${fileInfo.noteFileId}')">
                                                <span class="text"><c:out value="${fileInfo.noteFileNm}"/></span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="link">
                                    <c:if test="${not empty fileInfo.noteFileId}">
                                        <button type="button" class="btn s_basic down" onclick="downloadFile('${fileInfo.noteFileId}')">다운로드</button>
                                    </c:if>
                                </span>
                            </li>

                            <li>
                                <div class="tit_area">
                                    <span class="tit">음성파일 :</span>
                                    <c:choose>
                                        <c:when test="${not empty fileInfo.voiceFileId}">
                                            <a href="javascript:void(0);" class="file_down" onclick="downloadFile('${fileInfo.voiceFileId}')">
                                                <span class="text"><c:out value="${fileInfo.voiceFileNm}"/></span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="link">
                                    <c:if test="${not empty fileInfo.voiceFileId}">
                                        <button type="button" class="btn s_basic down" onclick="downloadFile('${fileInfo.voiceFileId}')">다운로드</button>
                                    </c:if>
                                </span>
                            </li>

                            <li>
                                <div class="tit_area">
                                    <span class="tit">실습지도 첨부파일 :</span>
                                    <c:choose>
                                        <c:when test="${not empty fileInfo.practiceFileId}">
                                            <a href="javascript:void(0);" class="file_down" onclick="downloadFile('${fileInfo.practiceFileId}')">
                                                <span class="text"><c:out value="${fileInfo.practiceFileNm}"/></span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="link">
                                    <c:if test="${not empty fileInfo.practiceFileId}">
                                        <button type="button" class="btn s_basic down" onclick="downloadFile('${fileInfo.practiceFileId}')">다운로드</button>
                                    </c:if>
                                </span>
                            </li>
                        </ul>
                    </div>

                    <div class="msg-box basic">
                        <ul class="list-asterisk">
                            <li>주교재 선정된 경우나 과목 특성에 따라 강의노트가 제공되지 않을 수 있습니다.</li>
                            <li>과목의 특성에 따라 제공여부가 변경/취소 혹은 일부 차시만 제공될 수 있습니다.</li>
                        </ul>
                    </div>

                    <!-- 평가방법 -->
                    <h4 class="sub-title">평가방법</h4>
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>평가방법</label></li>
                            <li>
                                <c:choose>
                                    <c:when test="${empty mrkEvlInfo}">-</c:when>
                                    <c:otherwise>
                                        <c:out value="${mrkEvlInfo.cdnm}"/> : <c:out value="${mrkEvlInfo.cdExpln}"/>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </div>

                    <!-- 평가비율 -->
                    <h4 class="sub-title">평가비율</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <col style="width:10%">
                                </c:forEach>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>평가항목</th>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <th><c:out value="${c.mrkItmTynm}"/></th>
                                </c:forEach>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <th data-th="평가항목">비율 (%)</th>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <td data-th="${c.mrkItmTynm}">
                                        <c:choose>
                                            <c:when test="${c.mrkItmUseyn eq 'Y'}">
                                                <c:out value="${c.mrkRfltrt}"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                            <tr>
                                <th data-th="평가항목">성적공개여부</th>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <td data-th="${c.mrkItmTynm}">
                                        <c:choose>
                                            <c:when test="${c.mrkItmUseyn ne 'Y'}">-</c:when>
                                            <c:when test="${c.mrkOyn eq 'Y'}">공개</c:when>
                                            <c:otherwise>비공개</c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="msg-box basic">
                        <ul class="list-asterisk">
                            <li>출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</li>
                            <li>정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</li>
                        </ul>
                    </div>

                    <!-- 주차별 강의내용 -->
                    <h4 class="sub-title">주차별 강의내용</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:10%">
                                <col>
                                <col style="width:15%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>주차</th>
                                <th>강의 내용</th>
                                <th>담당교수</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${empty lectureScheduleList}">
                                <tr>
                                    <td colspan="3" class="t_center">데이터가 없습니다.</td>
                                </tr>
                            </c:if>
                            <c:forEach var="row" items="${lectureScheduleList}">
                                <tr>
                                    <td data-th="주차"><c:out value="${row.lctrWkno}"/></td>
                                    <td data-th="강의 내용" class="t_left"><c:out value="${row.lctrTtl}"/></td>
                                    <td data-th="담당교수"><c:out value="${profInfo.usernm}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="msg-box basic">
                        <ul class="list-asterisk">
                            <li>강의 내용은 사정에 따라 변경될 수 있습니다.</li>
                        </ul>
                    </div>

                    <!-- 장애인/고령자 지원 -->
                    <h4 class="sub-title">장애인/고령자 지원</h4>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:25%">
                                <col style="width:25%">
                                <col style="width:25%">
                                <col style="width:25%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th colspan="4">콘텐츠 내 학습지원 기능</th>
                            </tr>
                            <tr>
                                <th>플레이어 단축키</th>
                                <th>스크립트</th>
                                <th>자막</th>
                                <th>재생속도 조절</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td data-th="플레이어 단축키">
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.plyrShrtctKeyPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.plyrShrtctKeyPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-th="스크립트">
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.scrptPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.scrptPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-th="자막">
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.sbttlsPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.sbttlsPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                                <td data-th="재생속도 조절">
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.plyrSpdAdjstPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.plyrSpdAdjstPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="msg-box basic">
                        <ul class="list-asterisk">
                            <li>개발 방식에 따라 일부 주차 혹은 페이지는 제공되지 않을 수 있습니다.</li>
                            <li>미디어 플레이어 단축키</li>
                        </ul>
                        <ul class="list-bullet">
                            <li>미디어 일시정지/재생 : Space Bar</li>
                            <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li>
                            <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li>
                            <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>
                            <li>전체 화면 : F</li>
                        </ul>
                    </div>

                    <%-- 시험 지원--%>
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>시험 지원</label></li>
                            <li>온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.</li>
                        </ul>
                    </div>
                </div>
            </div>
            <button onclick="document.getElementById('lecturePlanDoc').style.display='none'" style="float:right;color: #fff; margin: auto;">닫기</button>
        </div>
    </main>
</div>
</body>
</html>