<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>

<body class="home colorA">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">

                <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">강의계획서 상세정보</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li>강의계획서</li>
                                <li><span class="current">강의계획서 상세정보</span></li>
                            </ul>
                        </div>
                    </div>

                    <!-- 과목 정보 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">과목 정보</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-15per"/>
                                <col class="width-35per"/>
                                <col class="width-15per"/>
                                <col class="width-35per"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>과목번호</th>
                                <td>
                                    <c:out value="${subjectInfo.crclmnNo}"/>
                                </td>
                                <th>분반</th>
                                <td>
                                    <c:out value="${subjectInfo.dvclasNo}"/>
                                </td>
                            </tr>
                            <tr>
                                <th>과목명(한글)</th>
                                <td><c:out value="${subjectInfo.sbjctnm}"/></td>
                                <th>과목명(영문)</th>
                                <td><c:out value="${subjectInfo.sbjctEnnm}"/></td>
                            </tr>
                            <tr>
                                <th>학과</th>
                                <td><c:out value="${subjectInfo.deptnm}"/></td>
                                <th>학점</th>
                                <td><c:out value="${subjectInfo.crdts}"/></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 교수 정보 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">교수 정보</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-10per"/>
                                <col class="width-10per"/>
                                <col class="width-10per"/>
                                <col class="width-15per"/>
                                <col class="width-10per"/>
                                <col class="width-15per"/>
                                <col class="width-10per"/>
                                <col class="width-15per"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>담당교수</th>
                                <td><c:out value="${profInfo.usernm}"/></td>
                                <th>소속</th>
                                <td><c:out value="${profInfo.deptnm}"/></td>
                                <th>연락처</th>
                                <td><c:out value="${profInfo.offiPhn}"/></td>
                                <th>이메일</th>
                                <td><c:out value="${profInfo.eml}"/></td>
                            </tr>
                            <c:choose>
                                <c:when test="${not empty coprofList}">
                                    <c:forEach var="r" items="${coprofList}">
                                        <tr>
                                            <th>공동교수</th>
                                            <td><c:out value="${r.usernm}"/></td>
                                            <th>소속</th>
                                            <td><c:out value="${r.deptnm}"/></td>
                                            <th>연락처</th>
                                            <td><c:out value="${r.offiPhn}"/></td>
                                            <th>이메일</th>
                                            <td><c:out value="${r.eml}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <th>공동교수</th>
                                        <td colspan="7" class="t_center">데이터가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>

                        <small class="note2 flex margin-top-2">
                            ! 담당교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수
                        </small>
                    </div>

                    <!-- 튜터 정보 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">튜터 정보</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-20per"/>
                                <col class="width-25per"/>
                                <col class="width-25per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>튜터</th>
                                <th>연락처</th>
                                <th>핸드폰</th>
                                <th>이메일</th>
                            </tr>
                            <c:choose>
                                <c:when test="${not empty tutList}">
                                    <c:forEach var="r" items="${tutList}">
                                        <tr>
                                            <td><c:out value="${r.usernm}"/></td>
                                            <td><c:out value="${r.homePhn}"/></td>
                                            <td><c:out value="${r.mblPhn}"/></td>
                                            <td><c:out value="${r.eml}"/></td>
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
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">조교 정보</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-20per"/>
                                <col class="width-25per"/>
                                <col class="width-25per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>조교</th>
                                <th>연락처</th>
                                <th>핸드폰</th>
                                <th>이메일</th>
                            </tr>
                            <c:choose>
                                <c:when test="${not empty assiList}">
                                    <c:forEach var="r" items="${assiList}">
                                        <tr>
                                            <td><c:out value="${r.usernm}"/></td>
                                            <td><c:out value="${r.homePhn}"/></td>
                                            <td><c:out value="${r.mblPhn}"/></td>
                                            <td><c:out value="${r.eml}"/></td>
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
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">강의 개요</h3>
                        </div>
                        <table class="table-type2">
                            <colgroup>
                                <col class="width-15per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>교과목 개요</th>
                                <td class="t_left"><c:out value="${lctrPlandocInfo.crclmnOtln}"/></td>
                            </tr>
                            <tr>
                                <th>강의 목표</th>
                                <td class="t_left"><c:out value="${lctrPlandocInfo.lctrGoal}"/></td>
                            </tr>
                            <tr>
                                <th>운영 방침</th>
                                <td class="t_left"><c:out value="${lctrPlandocInfo.lctrOpGdln}"/></td>
                            </tr>
                            <tr>
                                <th>운영 계획</th>
                                <td class="t_left"><c:out value="${lctrPlandocInfo.lctrOpPlan}"/></td>
                            </tr>
                            <tr>
                                <th>관련 과목 내용</th>
                                <td class="t_left"><c:out value="${lctrPlandocInfo.rltdSbjctCts}"/></td>
                            </tr>
                            <tr>
                                <th>참고 사항</th>
                                <td class="t_left"><c:out value="${lctrPlandocInfo.remakrs}"/></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 교재 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">교재</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col style="width:6%"/>
                                <col style="width:14%"/>
                                <col style="width:38%"/>
                                <col style="width:18%"/>
                                <col style="width:12%"/>
                                <col style="width:12%"/>
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
                                    <td class="t_center"><c:out value="${st.count}"/></td>
                                    <td class="t_center"><c:out value="${row.txtbkGbnnm}"/></td>
                                    <td class="t_left"><c:out value="${row.txtbknm}"/></td>
                                    <td class="t_center"><c:out value="${row.isbn}"/></td>
                                    <td class="t_left"><c:out value="${row.wrtr}"/></td>
                                    <td class="t_left"><c:out value="${row.pblshr}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 제공파일(강의노트/음성파일/실습지도) : 값 없으면 '-' -->
                    <div class="table-wrap margin-top-4">
                        <table class="table-type2">
                            <colgroup>
                                <col class="width-20per"/>
                                <col/>
                                <col class="width-15per"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>강의노트</th>
                                <td><c:out value="${fileInfo.noteFileNm}"/></td>
                                <td class="t_right">
                                    <c:if test="${not empty fileInfo.noteFileId}">
                                        <button type="button" class="btn type3"
                                                onclick="downloadFile('${fileInfo.noteFileId}')">다운로드
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>음성 파일</th>
                                <td><c:out value="${fileInfo.voiceFileNm}"/></td>
                                <td class="t_right">
                                    <c:if test="${not empty fileInfo.voiceFileId}">
                                        <button type="button" class="btn type3"
                                                onclick="downloadFile('${fileInfo.voiceFileId}')">다운로드
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>실습지도 첨부파일</th>
                                <td><c:out value="${fileInfo.practiceFileNm}"/></td>
                                <td class="t_right">
                                    <c:if test="${not empty fileInfo.practiceFileId}">
                                        <button type="button" class="btn type3"
                                                onclick="downloadFile('${fileInfo.practiceFileId}')">다운로드
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                            </tbody>
                        </table>

                        <div class="margin-top-2">
                            <small class="note2 flex">* 주교재 선정된 경우나 과목 특성에 따라 강의노트가 제공되지 않을 수 있습니다.</small>
                            <small class="note2 flex">* 과목의 특성에 따라 제공여부가 변경/취소 혹은 일부 차시만 제공될 수 있습니다.</small>
                        </div>
                    </div>

                    <!-- 평가방법 -->

                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">평가방법</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-20per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>평가방법</th>
                                <td class="t_left">
                                    <c:choose>
                                        <c:when test="${empty mrkEvlInfo}">-</c:when>
                                        <c:otherwise>
                                            <c:out value="${mrkEvlInfo.cdnm}"/> :
                                            <c:out value="${mrkEvlInfo.cdExpln}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 평가비율 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">평가비율</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-15per"/>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <col/>
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
                                <th>비율(%)</th>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <td class="t_center">
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
                                <th>성적공개여부</th>
                                <c:forEach var="c" items="${mrkItmStngList}">
                                    <td class="t_center">
                                        <c:choose>
                                            <%--항목 미사용이면 항상 '-' --%>
                                            <c:when test="${c.mrkItmUseyn ne 'Y'}">-</c:when>
                                            <%--사용(Y) + 값 존재--%>
                                            <c:when test="${c.mrkOyn eq 'Y'}">공개</c:when>
                                            <c:otherwise>비공개</c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:forEach>
                            </tr>
                            </tbody>
                        </table>
                        <div class="margin-top-2">
                            <small class="note2 flex">* 평가비율 합계는 100%여야 저장됩니다.</small>
                            <small class="note2 flex">* 출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</small>
                            <small class="note2 flex">* 정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</small>
                        </div>
                    </div>

                    <!-- 주차별 강의내용 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">주차별 강의내용</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col style="width:10%"/>
                                <col/>
                                <col style="width:10%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>주차</th>
                                <th>강의 제목</th>
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
                                    <td class="t_center"><c:out value="${row.lctrWkno}"/></td>
                                    <td class="t_left"><c:out value="${row.lctrTtl}"/></td>
                                    <td class="t_center"><c:out value="${profInfo.usernm}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <small class="note2 flex margin-top-2">
                            * 강의 내용은 사정에 따라 변경될 수 있습니다.
                        </small>
                    </div>

                    <!-- 장애인/고령자 지원 -->
                    <div class="table-wrap margin-top-4">
                        <div class="board_top">
                            <h3 class="board-title">장애인/고령자 지원</h3>
                        </div>

                        <table class="table-type2">
                            <colgroup>
                                <col class="width-15per"/>
                                <col/>
                                <col/>
                                <col/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th rowspan="2">콘텐츠 내<br/>학습지원 기능</th>
                                <th>플레이어 단축키</th>
                                <th>스크립트</th>
                                <th>자막</th>
                                <th>재생속도 조절</th>
                            </tr>
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.plyrShrtctKeyPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.plyrShrtctKeyPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.scrptPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.scrptPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.sbttlsPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.sbttlsPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty lctrPlandocInfo.plyrSpdAdjstPvsnyn}">-</c:when>
                                        <c:when test="${lctrPlandocInfo.plyrSpdAdjstPvsnyn eq 'Y'}">제공</c:when>
                                        <c:otherwise>미제공</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                        <small class="note2 flex margin-top-2">
                            * 개발 방식에 따라 일부 주차 혹은 페이지는 제공되지 않을 수 있습니다.<br>
                            * 미디어 플레이어 단축키<br>
                            - 미디어 일시정지/재생 : Space Bar<br>
                            - 재생 속도 : Z (1배속), X (느리게), C (빠르게)<br>
                            - 볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)<br>
                            - 이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)<br>
                            - 전체 화면 : F
                        </small>

                    </div>
                    <%-- 시험 지원--%>
                    <div class="table-wrap margin-top-4">
                        <table class="table-type2">
                            <colgroup>
                                <col class="width-15per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>시험 지원</th>
                                <td class="t_left">온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 버튼 -->
                    <div class="btns">
                        <button type="button" class="btn type1" onclick="location.href='/lctr/plandoc/profLctrPlandocModifyView.do?sbjctId=<c:out value='${subjectInfo.sbjctId}'/>'">수정</button>
                        <button type="button" class="btn gray1" onclick="location.href='/lctr/plandoc/profLctrPlandocListView.do'">목록</button>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
    </main>
</div>
</body>
</html>