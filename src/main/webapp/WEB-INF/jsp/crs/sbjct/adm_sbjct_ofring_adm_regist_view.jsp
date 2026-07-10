<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- 관리자 공통 head -->
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        var EPARAM = '<c:out value="${encParams}" />';
        var SBJCT_ID = '<c:out value="${sbjctId}" />';
        var SEARCH_REQUIRED_TEXT = '<spring:message code="crs.sbjct.ofring.alert.search.adm.user.required"/>'; // 검색어를 입력해 주세요.
        var USER_EMPTY_TEXT = '<spring:message code="crs.sbjct.ofring.alert.adm.user.empty"/>'; // 조회된 사용자가 없습니다.
        var SELECT_PROF_ADM_TEXT = '<spring:message code="crs.sbjct.ofring.alert.select.prof.adm"/>'; // 담당교수를 1명 이상 등록해 주세요.
        var DUPLICATE_ADM_TEXT = '<spring:message code="crs.sbjct.ofring.alert.duplicate.adm"/>'; // 이미 추가된 사용자입니다.
        var SBJCT_ADM_TYPE_OPTIONS = [
            <c:forEach var="code" items="${sbjctAdmTycdList}" varStatus="status">
            {cd: '<c:out value="${code.cd}" />', cdnm: '<c:out value="${code.cdnm}" />'}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        $(document).ready(function() {
            renderAdmRowNo();
        });

        // HTML 특수문자를 화면 출력용으로 변환한다.
        function escapeHtml(value) {
            return String(value || "")
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        // 과목개설 정보등록 화면으로 이동한다.
        function viewSbjctOfringRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 주차 기간 설정 화면으로 이동한다.
        function viewSbjctOfringSchdlRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringSchdlRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 과목관리자 등록 화면으로 이동한다.
        function viewSbjctOfringAdmRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringAdmRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 수강생 등록 화면으로 이동한다.
        function viewSbjctOfringStdntRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringStdntRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }

        // 다음 단계로 이동한다.
        function onNext() {
            viewSbjctOfringStdntRegist();
        }

        // 과목개설 목록으로 이동한다.
        function viewSbjctOfringList() {
            location.href = '/crs/sbjctOfring/admSbjctOfringListView.do?encParams=' + EPARAM;
        }

        // 과목개설 단계 화면으로 이동한다.
        function moveOfringStep(stepNo) {
            if(stepNo == 1) {
                viewSbjctOfringRegist();
            } else if(stepNo == 2) {
                viewSbjctOfringSchdlRegist();
            } else if(stepNo == 3) {
                viewSbjctOfringAdmRegist();
            } else if(stepNo == 4) {
                viewSbjctOfringStdntRegist();
            }
        }

        // 과목관리자 등록용 사용자를 조회한다.
        function searchAdmUserList() {
            var searchValue = $.trim($("#searchValue").val());
            if(!searchValue) {
                UiComm.showMessage(SEARCH_REQUIRED_TEXT, "warning");
                return;
            }

            ajaxCall('/crs/sbjctOfring/admSbjctOfringAdmUserList.do',
                {
                    sbjctId: SBJCT_ID,
                    searchValue: searchValue
                },
                function(res) {
                    if(res.result < 0) {
                        UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                        return;
                    }
                    renderUserList(res.returnList || []);
                },
                function() {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                },
                true
            );
        }

        // 사용자 후보 목록을 화면에 출력한다.
        function renderUserList(list) {
            var html = "";
            var renderIndex = 0;

            $.each(list, function(index, user) {
                if(isAddedAdmUser(user.userId)) {
                    return true;
                }

                renderIndex++;
                html += '<tr>';
                html += '<td data-th="No" class="text-center">' + renderIndex + '</td>';
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.id'/>">' + escapeHtml(user.userId) + '</td>'; // 아이디
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.employee.no'/>">' + escapeHtml(user.stdntNo) + '</td>'; // 사번
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.type'/>">' + escapeHtml(user.userTycdnm || user.userTycd) + '</td>'; // 사용자유형
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.name'/>">' + escapeHtml(user.usernm) + '</td>'; // 이름
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.contact'/>">' + escapeHtml(user.mblPhn) + '</td>'; // 연락처
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.email'/>">' + escapeHtml(user.eml) + '</td>'; // 이메일
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.add'/>" class="text-center">'; // 추가
                html += '<button type="button" class="btn basic small" onclick="addAdmUser(this);"'
                    + ' data-user-id="' + escapeHtml(user.userId) + '"'
                    + ' data-stdnt-no="' + escapeHtml(user.stdntNo) + '"'
                    + ' data-user-tycd="' + escapeHtml(user.userTycd) + '"'
                    + ' data-user-tycdnm="' + escapeHtml(user.userTycdnm || user.userTycd) + '"'
                    + ' data-usernm="' + escapeHtml(user.usernm) + '"'
                    + ' data-mbl-phn="' + escapeHtml(user.mblPhn) + '"'
                    + ' data-eml="' + escapeHtml(user.eml) + '"><spring:message code="crs.sbjct.ofring.label.add"/></button>'; // 추가
                html += '</td>';
                html += '</tr>';
            });
            if(renderIndex == 0) {
                html += '<tr><td colspan="8" class="text-center">' + escapeHtml(USER_EMPTY_TEXT) + '</td></tr>';
            }
            $("#admUserListBody").html(html);
        }

        // 선택한 사용자를 과목관리자 목록에 추가한다.
        function addAdmUser(button) {
            var $button = $(button);
            var userId = $button.attr("data-user-id");
            var stdntNo = $button.attr("data-stdnt-no");
            if(isAddedAdmUser(userId)) {
                UiComm.showMessage(DUPLICATE_ADM_TEXT, "warning");
                return;
            }

            var html = "";
            html += '<tr class="adm-row" data-user-id="' + escapeHtml(userId) + '">';
            html += '<td data-th="No" class="text-center adm-row-no"></td>';
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.id'/>" class="adm-user-id">' + escapeHtml(userId) + '</td>'; // 아이디
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.employee.no'/>">' + escapeHtml(stdntNo) + '</td>'; // 사번
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.type'/>">' + escapeHtml($button.attr("data-user-tycdnm")) + '<input type="hidden" class="adm-user-tycd" value="' + escapeHtml($button.attr("data-user-tycd")) + '" /></td>'; // 사용자유형
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.name'/>">' + escapeHtml($button.attr("data-usernm")) + '</td>'; // 이름
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.contact'/>">' + escapeHtml($button.attr("data-mbl-phn")) + '</td>'; // 연락처
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.email'/>">' + escapeHtml($button.attr("data-eml")) + '</td>'; // 이메일
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.manager.type'/>">' + buildAdmTypeSelect("") + '</td>'; // 관리자 구분
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.delete'/>" class="text-center"><button type="button" class="btn basic small" onclick="removeAdmUser(this);"><spring:message code="crs.sbjct.ofring.label.delete"/></button></td>'; // 삭제
            html += '</tr>';

            $("#admListBody").append(html);
            renderAdmRowNo();
        }

        // 사용자가 이미 과목관리자 목록에 추가되어 있는지 확인한다.
        function isAddedAdmUser(userId) {
            return $("#admListBody .adm-row").filter(function() {
                return $(this).attr("data-user-id") === String(userId || "");
            }).length > 0;
        }

        // 과목관리자 유형 선택박스를 생성한다.
        function buildAdmTypeSelect(selectedValue) {
            var html = '<select class="adm-tycd" required="true">';
            $.each(SBJCT_ADM_TYPE_OPTIONS, function(index, code) {
                html += '<option value="' + escapeHtml(code.cd) + '"' + (code.cd == selectedValue ? ' selected' : '') + '>' + escapeHtml(code.cdnm) + '</option>';
            });
            html += '</select>';
            return html;
        }

        // 과목관리자 목록에서 사용자를 삭제한다.
        function removeAdmUser(button) {
            $(button).closest("tr").remove();
            renderAdmRowNo();
        }

        // 과목관리자 목록 순번을 다시 표시한다.
        function renderAdmRowNo() {
            $("#admListBody .adm-row").each(function(index) {
                $(this).find(".adm-row-no").text(index + 1);
            });
        }

        // 과목관리자 목록에 담당교수가 포함되어 있는지 확인한다.
        function hasProfAdm() {
            var hasProf = false;
            $("#admListBody .adm-row .adm-tycd").each(function() {
                if($(this).val() == "PROF") {
                    hasProf = true;
                    return false;
                }
            });
            return hasProf;
        }

        // 과목관리자를 저장한다.
        function onSave() {
            var params = { sbjctId: SBJCT_ID };
            var admCnt = 0;

            $("#admListBody .adm-row").each(function() {
                var $row = $(this);
                var sbjctAdmTycd = $row.find(".adm-tycd").val();
                params["admList[" + admCnt + "].userId"] = $row.attr("data-user-id");
                params["admList[" + admCnt + "].sbjctAdmTycd"] = sbjctAdmTycd;
                admCnt++;
            });

            if(admCnt == 0 || !hasProfAdm()) {
                UiComm.showMessage(SELECT_PROF_ADM_TEXT, "error");
                return;
            }

            ajaxCall('/crs/sbjctOfring/admSbjctOfringAdmRegist.do', params,
                function(res) {
                    if(res.result > 0) {
                        UiComm.showMessage(res.message || "<spring:message code='success.common.save'/>", "success") // 정상적으로 저장되었습니다.
                            .then(function() {
                                viewSbjctOfringStdntRegist();
                            });
                    } else {
                        UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                    }
                },
                function() {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                },
                true
            );
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
            <div class="admin_sub">
                <div class="cont">

                    <!-- 페이지 타이틀 -->
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 현재 메뉴명 --%>
                        <uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>

                    <!-- 과목 개설 과정 -->
                    <div class="step-process-wrap mb40">
                        <div class="board_card_list">
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(1); return false;">
                                    <span class="step-num">1</span>
                                    <spring:message code="crs.sbjct.ofring.step.info.regist"/><%--개설과목 정보등록--%>
                                </a>
                            </div>
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(2); return false;">
                                    <span class="step-num">2</span>
                                    <spring:message code="crs.sbjct.ofring.step.week.setting"/><%--주차 기간 설정--%>
                                </a>
                            </div>
                            <div class="card_item active">
                                <a href="javascript:void(0);" onclick="moveOfringStep(3); return false;">
                                    <span class="step-num">3</span>
                                    <spring:message code="crs.sbjct.ofring.step.manager.regist"/><%--과목 관리자 등록--%>
                                </a>
                            </div>
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(4); return false;">
                                    <span class="step-num">4</span>
                                    <spring:message code="crs.sbjct.ofring.step.learner.regist"/><%--수강생 등록--%>
                                </a>
                            </div>
                        </div>
                    </div>

                    <form id="sbjctOfringAdmRegistForm" onsubmit="return false;" autocomplete="off">
                        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${sbjctId}' />" />

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.course.info"/><%--개설 과목 정보--%></h3>
                            </div>

                            <div class="table-wrap mb20">
                                <table class="table-type5">
                                    <colgroup>
                                        <col style="width: 160px;">
                                        <col>
                                        <col style="width: 160px;">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><spring:message code="crs.label.crecrs"/><%--과목--%></th>
                                        <td><c:out value="${sbjctVO.sbjctnm}" /></td>
                                        <th><spring:message code="crs.label.subject.code"/><%--과목코드--%></th>
                                        <td><c:out value="${sbjctVO.sbjctCd}" /></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.manager.add"/><%--과목관리자 추가--%></h3>
                            </div>
                            <div class="board_top">
                                <div class="search-typeC">
                                    <input type="text" id="searchValue" class="form-control" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.user.search'/>" onkeydown="if(event.keyCode == 13){searchAdmUserList(); return false;}" /><%--이름 검색--%>
                                    <button type="button" class="btn basic icon search" aria-label="검색" onclick="searchAdmUserList();"><i class="icon-svg-search"></i></button><%--검색--%>
                                </div>
                            </div>

                            <div class="table-wrap overflow-y">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width: 60px;">
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col style="width: 80px;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>No</th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.id"/><%--아이디--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.employee.no"/><%--사번--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.type"/><%--사용자유형--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.name"/><%--이름--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.contact"/><%--연락처--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.email"/><%--이메일--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.add"/><%--추가--%></th>
                                    </tr>
                                    </thead>
                                    <tbody id="admUserListBody">
                                    <tr>
                                        <td colspan="8" class="text-center"><spring:message code="crs.sbjct.ofring.alert.search.adm.user.required"/><%--검색어를 입력해 주세요.--%></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.step.manager.regist"/><%--과목 관리자 등록--%></h3>
                            </div>
                            <div class="table-wrap overflow-y">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width: 60px;">
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col style="width: 200px;">
                                        <col style="width: 80px;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>No</th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.id"/><%--아이디--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.employee.no"/><%--사번--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.type"/><%--사용자유형--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.name"/><%--이름--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.contact"/><%--연락처--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.email"/><%--이메일--%></th>
                                        <th class="req"><spring:message code="crs.sbjct.ofring.label.manager.type"/><%--관리자 구분--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.delete"/><%--삭제--%></th>
                                    </tr>
                                    </thead>
                                    <tbody id="admListBody">
                                    <c:forEach var="adm" items="${admList}">
                                        <tr class="adm-row" data-user-id="<c:out value='${adm.userId}' />">
                                            <td data-th="No" class="text-center adm-row-no"></td>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.user.id'/>" class="adm-user-id"><c:out value="${adm.userId}" /></td><%--아이디--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.employee.no'/>"><c:out value="${adm.stdntNo}" /></td><%--사번--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.user.type'/>"><c:out value="${adm.userTycdnm}" /><input type="hidden" class="adm-user-tycd" value="<c:out value='${adm.userTycd}' />" /></td><%--사용자유형--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.user.name'/>"><c:out value="${adm.usernm}" /></td><%--이름--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.contact'/>"><c:out value="${adm.mblPhn}" /></td><%--연락처--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.email'/>"><c:out value="${adm.eml}" /></td><%--이메일--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.manager.type'/>"><%--관리자 구분--%>
                                                <select class="adm-tycd nochosen" required="true">
                                                    <c:forEach var="code" items="${sbjctAdmTycdList}">
                                                        <option value="<c:out value='${code.cd}' />" <c:if test="${code.cd == adm.sbjctAdmTycd}">selected</c:if>><c:out value="${code.cdnm}" /></option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.delete'/>" class="text-center"><%--삭제--%>
                                                <button type="button" class="btn basic small" onclick="removeAdmUser(this);"><spring:message code="crs.sbjct.ofring.label.delete"/><%--삭제--%></button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>

                    <div class="btns">
                        <button type="button" class="btn basic" onclick="viewSbjctOfringSchdlRegist();"><spring:message code="button.previous"/><%--이전--%></button>
                        <button type="button" class="btn basic" onclick="onNext();"><spring:message code="button.next"/><%--다음--%></button>
                        <button type="button" class="btn type1" onclick="onSave();"><spring:message code="button.save"/><%--저장--%></button>
                        <button type="button" class="btn type2" onclick="viewSbjctOfringList();"><spring:message code="button.list"/><%--목록--%></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
