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
        var dialog;

        var SEARCH_REQUIRED_TEXT = '<spring:message code="crs.sbjct.ofring.alert.search.stdnt.required"/>'; // 검색어를 입력해 주세요.
        var USER_EMPTY_TEXT = '<spring:message code="crs.sbjct.ofring.alert.stdnt.empty"/>'; // 조회된 학생이 없습니다.
        var SELECT_ADD_TEXT = '<spring:message code="crs.sbjct.ofring.alert.select.stdnt.add"/>'; // 추가할 학생을 선택해 주세요.
        var SELECT_SAVE_TEXT = '<spring:message code="crs.sbjct.ofring.alert.select.stdnt"/>'; // 수강생을 1명 이상 등록해 주세요.
        var DUPLICATE_TEXT = '<spring:message code="crs.sbjct.ofring.alert.duplicate.stdnt"/>'; // 이미 추가된 수강생은 제외되었습니다.

        $(document).ready(function() {
            renderAtndlcRowNo();
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

        // 수강생 등록 화면으로 이동한다.
        function viewSbjctOfringStdntRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringStdntRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
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

        // 과목개설 목록으로 이동한다.
        function viewSbjctOfringList() {
            location.href = '/crs/sbjctOfring/admSbjctOfringListView.do?encParams=' + EPARAM;
        }

        // 수강생 등록용 학생을 조회한다.
        function searchStdntUserList() {
            var searchValue = $.trim($("#searchValue").val());
            if(!searchValue) {
                UiComm.showMessage(SEARCH_REQUIRED_TEXT, "warning");
                return;
            }

            ajaxCall('/crs/sbjctOfring/admSbjctOfringStdntUserList.do',
                {
                    sbjctId: SBJCT_ID,
                    searchValue: searchValue
                },
                function(res) {
                    if(res.result < 0) {
                        UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                        return;
                    }
                    renderStdntUserList(res.returnList || []);
                },
                function() {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                },
                true
            );
        }
        // 학생 후보 목록을 화면에 출력한다.
        function renderStdntUserList(list) {
            var html = "";
            var renderIndex = 0;
            $("#stdntUserChkAll").prop("checked", false);

            $.each(list, function(index, user) {
                if(isAddedStdntUser(user.userId)) {
                    return true;
                }

                renderIndex++;
                var chkId = "stdntUserChk_" + renderIndex;
                html += '<tr>';
                html += '<td data-th="<spring:message code='common.select'/>" class="text-center">'; /* 선택 */
                html += '<span class="custom-input onlychk"><input type="checkbox" id="' + chkId + '" class="stdnt-user-check"'
                    + ' data-user-id="' + escapeHtml(user.userId) + '"'
                    + ' data-stdnt-no="' + escapeHtml(user.stdntNo) + '"'
                    + ' data-usernm="' + escapeHtml(user.usernm) + '"'
                    + ' data-mbl-phn="' + escapeHtml(user.mblPhn) + '"'
                    + ' data-eml="' + escapeHtml(user.eml) + '" /><label for="' + chkId + '"></label></span>';
                html += '</td>';
                html += '<td data-th="No" class="text-center">' + renderIndex + '</td>';
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.id'/>">' + escapeHtml(user.userId) + '</td>'; /* 아이디 */
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.stdnt.no'/>">' + escapeHtml(user.stdntNo) + '</td>'; /* 학번 */
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.stdnt.name'/>">' + escapeHtml(user.usernm) + '</td>'; /* 이름 */
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.contact'/>">' + escapeHtml(user.mblPhn) + '</td>'; /* 연락처 */
                html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.email'/>">' + escapeHtml(user.eml) + '</td>'; /* 이메일 */
                html += '</tr>';
            });
            if(renderIndex == 0) {
                html += '<tr><td colspan="7" class="text-center">' + escapeHtml(USER_EMPTY_TEXT) + '</td></tr>';
            }
            $("#stdntUserListBody").html(html);
        }
        function addCheckedStdntUsers() {
            var checkedList = $("#stdntUserListBody .stdnt-user-check:checked");
            var added = 0;
            var duplicated = 0;
            if(!checkedList.length) {
                UiComm.showMessage(SELECT_ADD_TEXT, "warning");
                return;
            }

            checkedList.each(function() {
                var $check = $(this);
                if(addStdntUserByData($check.data())) {
                    $check.closest("tr").remove();
                    added++;
                } else {
                    duplicated++;
                }
            });

            if(duplicated > 0) {
                UiComm.showMessage(DUPLICATE_TEXT, "warning");
            }
            if(added > 0) {
                renderAtndlcRowNo();
                refreshStdntUserRows();
            }
        }

        // 학생 후보 목록에서 추가된 행을 제외한 뒤 순번과 선택 상태를 보정한다.
        function refreshStdntUserRows() {
            var $rows = $("#stdntUserListBody .stdnt-user-check").closest("tr");
            $("#stdntUserChkAll").prop("checked", false);
            if(!$rows.length) {
                $("#stdntUserListBody").html('<tr><td colspan="7" class="text-center">' + escapeHtml(USER_EMPTY_TEXT) + '</td></tr>');
                return;
            }

            $rows.each(function(index) {
                $(this).children("td").eq(1).text(index + 1);
                $(this).find(".stdnt-user-check").prop("checked", false);
            });
        }
        // 데이터 객체를 수강생 목록에 추가한다.
        function addStdntUserByData(data) {
            var userId = data.userId || data.userid;
            if(isAddedStdntUser(userId)) {
                return false;
            }

            var html = "";
            html += '<tr class="atndlc-row"'
                + ' data-user-id="' + escapeHtml(userId) + '"'
                + ' data-stdnt-no="' + escapeHtml(data.stdntNo || data.stdntno) + '"'
                + ' data-usernm="' + escapeHtml(data.usernm) + '">';
            html += '<td data-th="No" class="text-center atndlc-row-no"></td>';
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.user.id'/>">' + escapeHtml(userId) + '</td>'; /* 아이디 */
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.stdnt.no'/>" class="stdnt-no">' + escapeHtml(data.stdntNo || data.stdntno) + '</td>'; /* 학번 */
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.stdnt.name'/>">' + escapeHtml(data.usernm) + '</td>'; /* 이름 */
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.contact'/>">' + escapeHtml(data.mblPhn || data.mblphn) + '</td>'; /* 연락처 */
            html += '<td data-th="<spring:message code='crs.sbjct.ofring.label.email'/>">' + escapeHtml(data.eml) + '</td>'; /* 이메일 */
            html += '<td data-th="<spring:message code='button.delete'/>" class="text-center"><button type="button" class="btn basic small" onclick="removeAtndlcUser(this);"><spring:message code="button.delete"/></button></td>'; /* 삭제 */
            html += '</tr>';
            $("#atndlcListBody").append(html);
            filterAtndlcList();
            return true;
        }
        function isAddedStdntUser(userId) {
            return $("#atndlcListBody .atndlc-row").filter(function() {
                return $(this).attr("data-user-id") === String(userId || "");
            }).length > 0;
        }

        // 수강생 목록에서 학생을 삭제한다.
        function removeAtndlcUser(button) {
            $(button).closest("tr").remove();
            renderAtndlcRowNo();
        }

        // 수강생 목록 순번을 다시 표시한다.
        function renderAtndlcRowNo() {
            var rowNo = 1;
            $("#atndlcListBody .atndlc-row").each(function(index) {
                if($(this).is(":visible")) {
                    $(this).find(".atndlc-row-no").text(rowNo++);
                }
            });
        }

        // 현재 화면에 추가된 수강생 목록을 이름 기준으로 필터링한다.
        function filterAtndlcList() {
            var keyword = $.trim($("#atndlcSearchValue").val()).toLowerCase();
            $("#atndlcListBody .atndlc-row").each(function() {
                var usernm = String($(this).attr("data-usernm") || "").toLowerCase();
                $(this).toggle(!keyword || usernm.indexOf(keyword) > -1);
            });
            renderAtndlcRowNo();
        }

        // 수강생 목록 엑셀 파일을 다운로드한다.
        function selectSbjctOfringStdntListExcelDown() {
            var excelGrid = {
                colModel: [
                    {label:'No.', name:'lineNo', align:'center', width:'3000'},
                    {label:"<spring:message code='crs.sbjct.ofring.label.user.id'/>", name:'userId', align:'center', width:'6000'}, // 아이디
                    {label:"<spring:message code='crs.sbjct.ofring.label.stdnt.no'/>", name:'stdntNo', align:'center', width:'6000'}, // 학번
                    {label:"<spring:message code='crs.sbjct.ofring.label.stdnt.name'/>", name:'usernm', align:'center', width:'6000'}, // 이름
                    {label:"<spring:message code='crs.sbjct.ofring.label.contact'/>", name:'mblPhn', align:'center', width:'7000'}, // 연락처
                    {label:"<spring:message code='crs.sbjct.ofring.label.email'/>", name:'eml', align:'left', width:'9000'} // 이메일
                ]
            };

            var excelForm = $('<form/>', {method: 'post', action: '/crs/sbjctOfring/admSbjctOfringStdntListExcelDown.do'});
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctId', value: SBJCT_ID}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
            excelForm.appendTo('body');
            excelForm.submit();
            excelForm.remove();
        }

        // 수강생 엑셀 업로드 팝업 파라미터를 생성한다.
        function getSbjctOfringStdntExcelUploadParams() {
            if(!SBJCT_ID) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                return null;
            }
            return {
                sbjctId: SBJCT_ID
            };
        }

        // 수강생 엑셀 업로드 팝업을 연다.
        function openSbjctOfringStdntExcelUpload() {
            var params = getSbjctOfringStdntExcelUploadParams();
            if(!params) {
                return;
            }

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.button.excel.reg'/>", // 엑셀로 등록
                width: 620,
                height: 360,
                url: "/crs/sbjctOfring/admSbjctOfringStdntExcelUploadPop.do?" + $.param(params),
                autoresize: true
            });
        }

        // 수강생 엑셀 업로드 결과를 화면 수강생 목록에 추가한다.
        function sbjctOfringStdntExcelUploadCallback(list) {
            var duplicated = 0;
            $.each(list || [], function(index, item) {
                if(!addStdntUserByData({
                    userId: item.userId,
                    stdntNo: item.stdntNo,
                    usernm: item.usernm,
                    mblPhn: item.mblPhn,
                    eml: item.eml
                })) {
                    duplicated++;
                }
            });
            renderAtndlcRowNo();
            filterAtndlcList();
            if(duplicated > 0) {
                UiComm.showMessage(DUPLICATE_TEXT, "warning");
            }
        }

        // UiDialog 팝업을 닫는다.
        function closeDialog() {
            if(dialog) {
                dialog.close();
                dialog = null;
            }
        }

        // 수강생 목록을 저장한다.
        function onSave() {
            var params = { sbjctId: SBJCT_ID };
            var atndlcCnt = 0;

            $("#atndlcListBody .atndlc-row").each(function() {
                params["atndlcList[" + atndlcCnt + "].userId"] = $(this).attr("data-user-id");
                atndlcCnt++;
            });

            if(atndlcCnt == 0) {
                UiComm.showMessage(SELECT_SAVE_TEXT, "error");
                return;
            }

            ajaxCall('/crs/sbjctOfring/admSbjctOfringStdntRegist.do', params,
                function(res) {
                    if(res.result > 0) {
                        UiComm.showMessage(res.message || "<spring:message code='success.common.save'/>", "success") // 정상적으로 저장되었습니다.
                            .then(function() {
                                viewSbjctOfringList();
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
                            <div class="card_item">
                                <a href="javascript:void(0);" onclick="moveOfringStep(3); return false;">
                                    <span class="step-num">3</span>
                                    <spring:message code="crs.sbjct.ofring.step.manager.regist"/><%--과목 관리자 등록--%>
                                </a>
                            </div>
                            <div class="card_item active">
                                <a href="javascript:void(0);" onclick="moveOfringStep(4); return false;">
                                    <span class="step-num">4</span>
                                    <spring:message code="crs.sbjct.ofring.step.learner.regist"/><%--수강생 등록--%>
                                </a>
                            </div>
                        </div>
                    </div>

                    <form id="sbjctOfringStdntRegistForm" onsubmit="return false;" autocomplete="off">
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
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.stdnt.add"/><%--수강생 추가--%></h3>
                            </div>
                            <div class="board_top">
                                <div class="search-typeC">
                                    <input type="text" id="searchValue" class="form-control" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.stdnt.search'/>" onkeydown="if(event.keyCode == 13){searchStdntUserList(); return false;}" /><%--이름 검색--%>
                                    <button type="button" class="btn basic icon search" aria-label="검색" onclick="searchStdntUserList();"><i class="icon-svg-search"></i></button><%--검색--%>
                                </div>
                                <div class="right-area">
                                    <button type="button" class="btn basic" onclick="openSbjctOfringStdntExcelUpload();"><spring:message code="crs.sbjct.ofring.button.excel.add"/><%--엑셀로 추가--%></button>
                                    <button type="button" class="btn basic" onclick="addCheckedStdntUsers();"><spring:message code="crs.sbjct.ofring.button.stdnt.add"/><%--수강생 추가--%></button>
                                </div>
                            </div>

                            <div class="table-wrap overflow-y">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width: 60px;">
                                        <col style="width: 60px;">
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="stdntUserChkAll" onclick="$('#stdntUserListBody .stdnt-user-check').prop('checked', this.checked);" /><label for="stdntUserChkAll"></label></span>
                                        </th>
                                        <th>No</th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.id"/><%--아이디--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.stdnt.no"/><%--학번--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.stdnt.name"/><%--이름--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.contact"/><%--연락처--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.email"/><%--이메일--%></th>
                                    </tr>
                                    </thead>
                                    <tbody id="stdntUserListBody">
                                    <tr>
                                        <td colspan="7" class="text-center"><spring:message code="crs.sbjct.ofring.alert.search.stdnt.required"/><%--검색어를 입력해 주세요.--%></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.step.learner.regist"/><%--수강생 등록--%></h3>
                            </div>
                            <div class="board_top">
                                <div class="search-typeC">
                                    <input type="text" id="atndlcSearchValue" class="form-control" placeholder="<spring:message code='crs.sbjct.ofring.placeholder.stdnt.search'/>" onkeydown="if(event.keyCode == 13){filterAtndlcList(); return false;}" /><%--이름 검색--%>
                                    <button type="button" class="btn basic icon search" aria-label="검색" onclick="filterAtndlcList();"><i class="icon-svg-search"></i></button><%--검색--%>
                                </div>
                                <div class="right-area">
                                    <button type="button" class="btn type2" onclick="selectSbjctOfringStdntListExcelDown();"><spring:message code="crs.button.excel.down"/><%--엑셀 다운로드--%></button>
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
                                        <col style="width: 80px;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>No</th>
                                        <th><spring:message code="crs.sbjct.ofring.label.user.id"/><%--아이디--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.stdnt.no"/><%--학번--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.stdnt.name"/><%--이름--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.contact"/><%--연락처--%></th>
                                        <th><spring:message code="crs.sbjct.ofring.label.email"/><%--이메일--%></th>
                                        <th><spring:message code="button.delete"/><%--삭제--%></th>
                                    </tr>
                                    </thead>
                                    <tbody id="atndlcListBody">
                                    <c:forEach var="atndlc" items="${atndlcList}">
                                        <tr class="atndlc-row" data-user-id="<c:out value='${atndlc.userId}' />" data-stdnt-no="<c:out value='${atndlc.stdntNo}' />" data-usernm="<c:out value='${atndlc.usernm}' />">
                                            <td data-th="No" class="text-center atndlc-row-no"></td>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.user.id'/>"><c:out value="${atndlc.userId}" /></td><%--아이디--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.stdnt.no'/>" class="stdnt-no"><c:out value="${atndlc.stdntNo}" /></td><%--학번--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.stdnt.name'/>"><c:out value="${atndlc.usernm}" /></td><%--이름--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.contact'/>"><c:out value="${atndlc.mblPhn}" /></td><%--연락처--%>
                                            <td data-th="<spring:message code='crs.sbjct.ofring.label.email'/>"><c:out value="${atndlc.eml}" /></td><%--이메일--%>
                                            <td data-th="<spring:message code='button.delete'/>" class="text-center"><%--삭제--%>
                                                <button type="button" class="btn basic small" onclick="removeAtndlcUser(this);"><spring:message code="button.delete"/><%--삭제--%></button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>

                    <div class="btns">
                        <button type="button" class="btn basic" onclick="viewSbjctOfringAdmRegist();"><spring:message code="button.previous"/><%--이전--%></button>
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
