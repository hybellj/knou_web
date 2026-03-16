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
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">강의계획서 수정</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li>강의계획서</li>
                                <li><span class="current">강의계획서 수정</span></li>
                            </ul>
                        </div>
                    </div>

                    <form id="plandocSaveForm" name="plandocSaveForm" enctype="multipart/form-data">
                        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${subjectInfo.sbjctId}'/>"/>

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
                                <c:if test="${not empty coprofList}">
                                    <c:forEach var="r" items="${coprofList}">
                                        <tr>
                                            <td data-th="교수">공동교수 : <c:out value="${r.usernm}"/></td>
                                            <td data-th="소속"><c:out value="${r.deptnm}"/></td>
                                            <td data-th="연락처"><c:out value="${r.offiPhn}"/></td>
                                            <td data-th="이메일"><c:out value="${r.eml}"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>담당교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>
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
                                                <td data-th="조교"><c:out value="${r.usernm}"/></td>
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
                                <li class="head"><label class="req">교과목 개요</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="crclmnOtln"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.crclmnOtln}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label class="req">강의 목표</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="lctrGoal"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.lctrGoal}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label class="req">운영 방침</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="lctrOpGdln"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.lctrOpGdln}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label class="req">운영 계획</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="lctrOpPlan"
                                              maxLenCheck="byte,4000,true,false"
                                              required="true"><c:out value="${lctrPlandocInfo.lctrOpPlan}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>관련 과목 내용</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="rltdSbjctCts"
                                              maxLenCheck="byte,4000,true,false"><c:out value="${lctrPlandocInfo.rltdSbjctCts}"/></textarea>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>참고 사항</label></li>
                                <li>
                                    <textarea class="form-control" style="width:100%;height:90px"
                                              name="remakrs"
                                              maxLenCheck="byte,4000,true,false"><c:out value="${lctrPlandocInfo.remakrs}"/></textarea>
                                </li>
                            </ul>
                        </div>

                        <!-- 교재 -->
                        <h4 class="sub-title">교재</h4>
                        <div class="board_top">
                            <h3 class="board-title"></h3>
                            <div class="right-area">
                                <button type="button" class="btn type3" onclick="addTxtbkRow()">교재 추가</button>
                                <button type="button" class="btn type2" onclick="removeCheckedTxtbkRows()">교재 삭제</button>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type1" id="txtbkTable">
                                <colgroup>
                                    <col style="width:4%"/>
                                    <col style="width:6%"/>
                                    <col style="width:14%"/>
                                    <col style="width:36%"/>
                                    <col style="width:16%"/>
                                    <col style="width:12%"/>
                                    <col style="width:12%"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="t_center">
                                        <span class="custom-input onlychk">
                                            <input type="checkbox" id="txtbkAll">
                                            <label for="txtbkAll"></label>
                                        </span>
                                    </th>
                                    <th>No</th>
                                    <th>구분</th>
                                    <th class="req">교재명</th>
                                    <th>ISBN</th>
                                    <th>저자</th>
                                    <th>출판사</th>
                                </tr>
                                </thead>
                                <tbody id="txtbkTbody">
                                <c:choose>
                                    <c:when test="${not empty txtbkList}">
                                        <c:forEach var="r" items="${txtbkList}" varStatus="st">
                                            <tr class="txtbk-row">
                                                <td class="t_center">
                                                    <span class="custom-input onlychk">
                                                        <input type="checkbox" class="txtbkChk" id="txtbkChk_${st.index}">
                                                        <label for="txtbkChk_${st.index}"></label>
                                                    </span>
                                                    <input type="hidden" name="txtbkList[${st.index}].txtbkId" value="<c:out value='${r.txtbkId}'/>">
                                                </td>
                                                <td class="t_center txtbkNo"><c:out value="${st.count}"/></td>
                                                <td data-th="구분" class="t_center">
                                                    <select class="form-select compact" name="txtbkList[${st.index}].txtbkGbncd">
                                                        <c:forEach var="c" items="${txtbkGbncdList}">
                                                            <option value="<c:out value='${c.cd}'/>"
                                                                    <c:if test="${c.cd eq r.txtbkGbncd}">selected</c:if>>
                                                                <c:out value="${c.cdnm}"/>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td data-th="교재명" class="t_left">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].txtbknm"
                                                           value="<c:out value='${r.txtbknm}'/>"
                                                           inputmask="byte" maxLen="300" required="true">
                                                </td>
                                                <td data-th="ISBN" class="t_center">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].isbn"
                                                           value="<c:out value='${r.isbn}'/>"
                                                           inputmask="etc" mask="9{0,30}">
                                                </td>
                                                <td data-th="저자" class="t_left">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].wrtr"
                                                           value="<c:out value='${r.wrtr}'/>"
                                                           inputmask="byte" maxLen="300">
                                                </td>
                                                <td data-th="출판사" class="t_left">
                                                    <input type="text" class="form-control width-100per"
                                                           name="txtbkList[${st.index}].pblshr"
                                                           value="<c:out value='${r.pblshr}'/>"
                                                           inputmask="byte" maxLen="300">
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="no-data">
                                            <td colspan="7" class="t_center">등록된 교재가 없습니다. 교재 추가를 눌러 입력하세요.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- 첨부파일 -->
                        <div class="file-wrap">
                            <ul class="add_file">
                                <li>
                                    <div class="tit_area">
                                        <span class="tit">강의노트 :</span>
                                        <span class="text"><c:out value="${empty fileInfo.noteFileNm ? '-' : fileInfo.noteFileNm}"/></span>
                                    </div>
                                    <span class="link" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                                        <input type="file" name="noteFile">
                                        <span class="custom-input">
                                            <input type="checkbox" id="delNoteFile" name="delNoteFile" value="Y">
                                            <label for="delNoteFile">삭제</label>
                                        </span>
                                    </span>
                                </li>
                                <li>
                                    <div class="tit_area">
                                        <span class="tit">음성파일 :</span>
                                        <span class="text"><c:out value="${empty fileInfo.voiceFileNm ? '-' : fileInfo.voiceFileNm}"/></span>
                                    </div>
                                    <span class="link" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                                        <input type="file" name="voiceFile">
                                        <span class="custom-input">
                                            <input type="checkbox" id="delVoiceFile" name="delVoiceFile" value="Y">
                                            <label for="delVoiceFile">삭제</label>
                                        </span>
                                    </span>
                                </li>
                                <li>
                                    <div class="tit_area">
                                        <span class="tit">실습지도 첨부파일 :</span>
                                        <span class="text"><c:out value="${empty fileInfo.practiceFileNm ? '-' : fileInfo.practiceFileNm}"/></span>
                                    </div>
                                    <span class="link" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                                        <input type="file" name="practiceFile">
                                        <span class="custom-input">
                                            <input type="checkbox" id="delPracticeFile" name="delPracticeFile" value="Y">
                                            <label for="delPracticeFile">삭제</label>
                                        </span>
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
                        <div class="board_top">
                            <h3 class="board-title"></h3>
                            <div class="right-area">
                                <span>합계: <b id="sumRate">0</b>%</span>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type1" id="mrkTable">
                                <colgroup>
                                    <col>
                                    <c:forEach var="c" items="${mrkItmStngList}">
                                        <col style="width:10%">
                                    </c:forEach>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>평가항목</th>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <th>
                                            <c:out value="${c.mrkItmTynm}"/>
                                            <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmTycd" value="<c:out value='${c.mrkItmTycd}'/>"/>
                                            <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmStngId" value="<c:out value='${c.mrkItmStngId}'/>"/>
                                            <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmUseyn" value="<c:out value='${c.mrkItmUseyn}'/>"/>
                                        </th>
                                    </c:forEach>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th class="req" data-th="평가항목">비율 (%)</th>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <td data-th="${c.mrkItmTynm}" class="t_center">
                                            <c:choose>
                                                <c:when test="${c.mrkItmUseyn eq 'Y'}">
                                                    <input class="form-control t_center mrk-rate"
                                                           style="width:80px;display:inline-block;"
                                                           name="mrkItmStngList[${st.index}].mrkRfltrt"
                                                           value="<c:out value='${c.mrkRfltrt}'/>"
                                                           inputmask="numeric"
                                                           maxVal="100"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                                <tr>
                                    <th class="req" data-th="평가항목">성적공개여부</th>
                                    <c:forEach var="c" items="${mrkItmStngList}" varStatus="st">
                                        <td data-th="${c.mrkItmTynm}" class="t_center">
                                            <c:choose>
                                                <c:when test="${c.mrkItmUseyn eq 'Y'}">
                                                    <%--                                                    <span class="custom-input">--%>
                                                    <input type="checkbox"
                                                           id="mrkOyn_${st.index}"
                                                           class="switch yesno"
                                                           <c:if test="${c.mrkOyn eq 'Y'}">checked="checked"</c:if>>
                                                    <%--                                                    <label for="mrkOyn_${st.index}">공개</label>--%>
                                                    <%--                                                    </span>--%>
                                                    <input type="hidden"
                                                           name="mrkItmStngList[${st.index}].mrkOyn"
                                                           id="mrkOynHidden_${st.index}"
                                                           value="<c:out value='${c.mrkOyn}'/>"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>평가비율 합계는 100%여야 저장됩니다.</li>
                                <li>출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</li>
                                <li>정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</li>
                            </ul>
                        </div>

                        <!-- 주차별 강의내용 -->
                        <h4 class="sub-title">주차별 강의내용</h4>
                        <div class="table-wrap">
                            <table class="table-type1" id="wkTable">
                                <colgroup>
                                    <col style="width:8%"/>
                                    <col style="width:8%"/>
                                    <col style="width:14%"/>
                                    <col/>
                                    <col style="width:12%"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th rowspan="2">상태</th>
                                    <th rowspan="2">주차</th>
                                    <th>강의 구분</th>
                                    <th>강의 제목</th>
                                    <th rowspan="2">담당교수</th>
                                </tr>
                                <tr>
                                    <th colspan="2">강의 내용</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty lectureScheduleList}">
                                        <c:forEach var="r" items="${lectureScheduleList}" varStatus="st">
                                            <tr class="wk-head" data-wk-index="${st.index}">
                                                <td class="t_center" rowspan="2">
                                                    <span class="wkStsTxt">-</span>

                                                    <input type="hidden" name="wkList[${st.index}].wkChgyn" value="N" class="wkChgyn">
                                                    <input type="hidden" name="wkList[${st.index}].lctrWknoSchdlId" value="<c:out value='${r.lctrWknoSchdlId}'/>">
                                                    <input type="hidden" name="wkList[${st.index}].lctrWkno" value="<c:out value='${r.lctrWkno}'/>">

                                                    <input type="hidden" class="wkOrigTy" value="<c:out value='${r.lctrTycd}'/>">
                                                    <input type="hidden" class="wkOrigTitle" value="<c:out value='${r.lctrTtl}'/>">
                                                    <input type="hidden" class="wkOrigCts" value="<c:out value='${r.lctrCts}'/>">
                                                </td>

                                                <td class="t_center" rowspan="2">
                                                    <c:out value="${r.lctrWkno}"/>
                                                </td>

                                                <td class="t_center">
                                                    <select class="form-select compact wkWatch"
                                                            name="wkList[${st.index}].lctrTycd">
                                                        <c:forEach var="c" items="${lctrTycdList}">
                                                            <option value="<c:out value='${c.cd}'/>"
                                                                    <c:if test="${c.cd eq r.lctrTycd}">selected</c:if>>
                                                                <c:out value="${c.cdnm}"/>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </td>

                                                <td class="t_left">
                                                    <input type="text"
                                                           class="form-control width-100per wkWatch"
                                                           name="wkList[${st.index}].lctrTtl"
                                                           value="<c:out value='${r.lctrTtl}'/>"
                                                           inputmask="byte"
                                                           maxLen="4000">
                                                </td>

                                                <td class="t_center" rowspan="2">
                                                    <c:out value="${profInfo.usernm}"/>
                                                </td>
                                            </tr>

                                            <tr class="wk-body" data-wk-index="${st.index}">
                                                <td colspan="2" class="t_left">
                                                    <textarea class="form-control wkWatch"
                                                              name="wkList[${st.index}].lctrCts"
                                                              style="width:100%; height:80px;"
                                                              maxLenCheck="byte,4000,true,false"><c:out value="${r.lctrCts}"/></textarea>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="t_center">데이터가 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
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
                                    <td data-th="플레이어 단축키" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="plyrShrtctKeyPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.plyrShrtctKeyPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="plyrShrtctKeyPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="plyrShrtctKeyPvsnyn"
                                               id="plyrShrtctKeyPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.plyrShrtctKeyPvsnyn}'/>"/>
                                    </td>
                                    <td data-th="스크립트" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="scrptPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.scrptPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="scrptPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="scrptPvsnyn"
                                               id="scrptPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.scrptPvsnyn}'/>"/>
                                    </td>
                                    <td data-th="자막" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="sbttlsPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.sbttlsPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="sbttlsPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="sbttlsPvsnyn"
                                               id="sbttlsPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.sbttlsPvsnyn}'/>"/>
                                    </td>
                                    <td data-th="재생속도 조절" class="t_center">
                                        <span class="custom-input">
                                            <input type="checkbox" id="plyrSpdAdjstPvsnyn"
                                                   <c:if test="${lctrPlandocInfo.plyrSpdAdjstPvsnyn eq 'Y'}">checked</c:if>>
                                            <label for="plyrSpdAdjstPvsnyn">제공</label>
                                        </span>
                                        <input type="hidden" name="plyrSpdAdjstPvsnyn"
                                               id="plyrSpdAdjstPvsnynHidden"
                                               value="<c:out value='${lctrPlandocInfo.plyrSpdAdjstPvsnyn}'/>"/>
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

                        <!-- 시험 지원 -->
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>시험 지원</label></li>
                                <li>온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.</li>
                            </ul>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="savePlandoc()">저장</button>
                            <button type="button" class="btn type2"
                                    onclick="location.href='/lctr/plandoc/profLctrPlandocView.do?sbjctId=<c:out value="${subjectInfo.sbjctId}"/>'">취소
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
    </main>
</div>

<script type="text/javascript">
    $(function () {
        renumberTxtbk();
        bindTxtbkEvents();
        calcRateSum();
        bindMrkEvents();
        bindWkChangeDetect();
        bindSupportYnEvents();

        syncAllMrkOynHidden();
        syncSupportYnHidden();
    });

    /* =========================
     * 교재
     * ========================= */

    /**
     * 교재 영역 이벤트를 바인딩한다.
     * - 전체선택
     */
    function bindTxtbkEvents() {
        $("#txtbkAll").on("change", function () {
            $("#txtbkTbody .txtbkChk").prop("checked", $(this).is(":checked"));
        });
    }

    /**
     * 교재 번호(No) 컬럼을 재정렬한다.
     * - no-data 행은 제외
     */
    function renumberTxtbk() {
        const $rows = $("#txtbkTbody tr").not(".no-data");
        $rows.each(function (idx) {
            $(this).find(".txtbkNo").text(idx + 1);
        });
    }

    /**
     * 교재 리스트 인덱스(txtbkList[x].필드)를 재정렬한다.
     * - 삭제 후 인덱스가 비면 Spring 바인딩이 꼬일 수 있어 저장 직전에 한 번 정리하는 방식
     */
    function renumberTxtbkNames() {
        const $rows = $("#txtbkTbody tr").not(".no-data");

        $rows.each(function (idx) {
            const $tr = $(this);
            const chkId = "txtbkChk_" + idx;

            $tr.find(".txtbkChk").attr("id", chkId);
            $tr.find("label[for^='txtbkChk_']").attr("for", chkId);

            $tr.find("input, select").each(function () {
                const $el = $(this);
                const name = $el.attr("name") || "";
                if (!name) return;
                if (name.indexOf("txtbkList[") !== 0) return;

                $el.attr("name", name.replace(/txtbkList\[\d+]/, "txtbkList[" + idx + "]"));
            });
        });
    }

    /**
     * 교재 행을 추가한다.
     * - 신규행은 마지막 인덱스로 생성
     */
    function addTxtbkRow() {
        $("#txtbkTbody .no-data").remove();

        const optionsHtml = (() => {
            let html = "";
            <c:forEach var="c" items="${txtbkGbncdList}">
            html += "<option value='${c.cd}'>${fn:escapeXml(c.cdnm)}</option>";
            </c:forEach>
            return html;
        })();

        const idx = $("#txtbkTbody tr").not(".no-data").length;

        let tr = "";
        tr += "<tr class='txtbk-row'>";
        tr += "  <td class='t_center'>";
        tr += "    <span class='custom-input onlychk'>";
        tr += "      <input type='checkbox' class='txtbkChk' id='txtbkChk_" + idx + "'>";
        tr += "      <label for='txtbkChk_" + idx + "'></label>";
        tr += "    </span>";
        tr += "    <input type='hidden' name='txtbkList[" + idx + "].txtbkId' value=''>";
        tr += "  </td>";
        tr += "  <td class='t_center txtbkNo'></td>";
        tr += "  <td class='t_center'><select class='form-select compact' name='txtbkList[" + idx + "].txtbkGbncd'>" + optionsHtml + "</select></td>";
        tr += "  <td class='t_left'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].txtbknm' inputmask='byte' maxLen='300' required='true'></td>";
        tr += "  <td class='t_center'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].isbn' inputmask='etc' mask='9{0,30}'></td>";
        tr += "  <td class='t_left'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].wrtr' inputmask='byte' maxLen='300'></td>";
        tr += "  <td class='t_left'><input type='text' class='form-control width-100per' name='txtbkList[" + idx + "].pblshr' inputmask='byte' maxLen='300'></td>";
        tr += "</tr>";

        $("#txtbkTbody").append(tr);
        $("#txtbkAll").prop("checked", false);
        renumberTxtbk();
    }

    /**
     * 선택된 교재 행을 삭제한다.
     * - 화면에서 제거만 하고 저장 시 "전체 삭제 후 재등록" 정책으로 서버에서 처리
     */
    function removeCheckedTxtbkRows() {
        const $checked = $("#txtbkTbody .txtbkChk:checked");

        if ($checked.length === 0) {
            UiComm.showMessage("삭제할 교재를 선택하세요.", "info");
            return;
        }

        UiComm.showMessage("선택한 교재를 삭제하시겠습니까?", "confirm").then(function (ok) {
            if (!ok) return;

            $checked.closest("tr").remove();
            $("#txtbkAll").prop("checked", false);

            const left = $("#txtbkTbody tr").not(".no-data").length;
            if (left === 0) {
                $("#txtbkTbody").append("<tr class='no-data'><td colspan='7' class='t_center'>등록된 교재가 없습니다. 교재 추가를 눌러 입력하세요.</td></tr>");
            }

            renumberTxtbk();
        });
    }

    /* =========================
     * 평가비율
     * ========================= */

    /**
     * 평가비율 영역 이벤트를 바인딩한다.
     * - 비율 입력 시 합계 자동 계산
     * - 성적공개여부 switch -> hidden 동기화
     */
    function bindMrkEvents() {
        $(document).on("blur change input", ".mrk-rate", function () {
            calcRateSum();
        });

        $(document).on("change", "input[id^='mrkOyn_']", function () {
            const idx = $(this).attr("id").split("_")[1];
            $("#mrkOynHidden_" + idx).val($(this).is(":checked") ? "Y" : "N");
        });
    }

    /**
     * 성적공개여부 hidden을 전체 초기 동기화한다.
     * - 공개여부 체크박스가 존재하는 항목만 처리
     */
    function syncAllMrkOynHidden() {
        $("input[id^='mrkOyn_']").each(function () {
            const idx = $(this).attr("id").split("_")[1];
            $("#mrkOynHidden_" + idx).val($(this).is(":checked") ? "Y" : "N");
        });
    }

    /**
     * 평가비율 합계를 계산하여 화면에 표시한다.
     * 빈 값은 미평가로 처리하므로 합계에 포함하지 않는다.
     * 숫자가 아닌 입력은 합계에 포함하지 않는다.
     * @returns {number} 합계(숫자)
     */
    function calcRateSum() {
        let sum = 0;

        $(".mrk-rate").each(function () {
            const raw = ($(this).val() || "").toString().trim();
            if (raw === "") return;
            if (!/^\d+$/.test(raw)) return;

            const v = parseInt(raw, 10);
            if (isNaN(v)) return;

            sum += v;
        });

        $("#sumRate").text(sum);
        return sum;
    }

    /* =========================
     * 주차별 강의내용 변경감지
     * ========================= */

    /**
     * 주차 인덱스(data-wk-index)로 주차 대표행(.wk-head)을 조회한다.
     * @param wkIndex 주차 인덱스
     * @returns {*} jQuery object (.wk-head)
     */
    function getWkHeadRowByIndex(wkIndex) {
        return $("#wkTable .wk-head[data-wk-index='" + wkIndex + "']");
    }

    /**
     * 주차 변경 여부를 head row에 표시한다.
     * - 상태 텍스트 변경
     * - hidden(wkChgyn) 변경
     * @param $wkHeadTr 주차 대표행(.wk-head)
     * @param changed   변경 여부(true/false)
     */
    function markWeekChanged($wkHeadTr, changed) {
        $wkHeadTr.find(".wkStsTxt").text(changed ? "변경" : "-");
        $wkHeadTr.find(".wkChgyn").val(changed ? "Y" : "N");
    }

    /**
     * 주차 변경 여부를 판단한다.
     * - 원본값(wkOrig*)과 현재 입력값 비교
     * @param $wkHeadTr 주차 대표행(.wk-head)
     * @returns {boolean} 변경 여부
     */
    function isWeekChanged($wkHeadTr) {
        const wkIndex = $wkHeadTr.data("wk-index");
        const $wkBodyTr = $("#wkTable .wk-body[data-wk-index='" + wkIndex + "']");

        const origTy = ($wkHeadTr.find(".wkOrigTy").val() || "").toString().trim();
        const origTitle = ($wkHeadTr.find(".wkOrigTitle").val() || "").toString().trim();
        const origCts = ($wkHeadTr.find(".wkOrigCts").val() || "").toString().trim();

        const curTy = ($wkHeadTr.find("select.wkWatch").val() || "").toString().trim();
        const curTitle = ($wkHeadTr.find("input.wkWatch").val() || "").toString().trim();
        const curCts = ($wkBodyTr.find("textarea.wkWatch").val() || "").toString().trim();

        return (origTy !== curTy) || (origTitle !== curTitle) || (origCts !== curCts);
    }

    /**
     * 주차별 입력 변경 이벤트를 바인딩한다.
     * - 변경 시 해당 주차의 wkChgyn만 Y로 처리
     */
    function bindWkChangeDetect() {
        $("#wkTable").on("change input", ".wkWatch", function () {
            const $tr = $(this).closest("tr");
            const wkIndex = $tr.data("wk-index");
            const $wkHeadTr = $tr.hasClass("wk-head") ? $tr : getWkHeadRowByIndex(wkIndex);

            markWeekChanged($wkHeadTr, isWeekChanged($wkHeadTr));
        });
    }

    /* =========================
     * 학습지원기능
     * ========================= */


    function bindSupportYnEvents() {
        $("#plyrShrtctKeyPvsnyn, #scrptPvsnyn, #sbttlsPvsnyn, #plyrSpdAdjstPvsnyn").on("change", function () {
            syncSupportYnHidden();
        });
    }

    /**
     * 학습지원 기능(checkbox) 상태를 hidden에 강제 동기화한다.
     */
    function syncSupportYnHidden() {
        const map = [
            {chk: "plyrShrtctKeyPvsnyn", hid: "plyrShrtctKeyPvsnynHidden"},
            {chk: "scrptPvsnyn", hid: "scrptPvsnynHidden"},
            {chk: "sbttlsPvsnyn", hid: "sbttlsPvsnynHidden"},
            {chk: "plyrSpdAdjstPvsnyn", hid: "plyrSpdAdjstPvsnynHidden"}
        ];

        map.forEach(function (x) {
            const $chk = $("#" + x.chk);
            const $hid = $("#" + x.hid);
            if ($chk.length === 0 || $hid.length === 0) return;

            $hid.val($chk.is(":checked") ? "Y" : "N");
        });
    }

    /* =========================
     * 저장
     * ========================= */

    /**
     * 저장 처리
     * - validate
     */
    function savePlandoc() {
        const validator = UiValidator("plandocSaveForm");

        validator.then(function (result) {
            if (!result) return;

            const $rates = $(".mrk-rate");
            if ($rates.length > 0) {
                const sum = calcRateSum();
                if (sum !== 100) {
                    UiComm.showMessage("평가비율 합계는 100%여야 합니다. (현재: " + sum + "%)", "warning");
                    return;
                }
            }

            renumberTxtbkNames();
            syncAllMrkOynHidden();
            syncSupportYnHidden();

            UiComm.showMessage("저장하시겠습니까?", "confirm").then(function (ok) {
                if (!ok) return;

                const form = document.getElementById("plandocSaveForm");
                const formData = new FormData(form);

                $.ajax({
                    url: "/lctr/plandoc/profLctrPlandocModifyAjax.do",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (res) {
                        if (res.result > 0) {
                            UiComm.showMessage('<spring:message code="success.common.save" />', "success");
                        } else {
                            UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");
                        }

                        const sbjctId = $("#sbjctId").val();
                        location.href = "/lctr/plandoc/profLctrPlandocView.do?sbjctId=" + sbjctId;
                    },
                    error: function () {
                        UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");
                    }
                });
            });
        });
    }
</script>
</body>
</html>