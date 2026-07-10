<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    const PAGE_INDEX = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE   = '<c:out value="${vo.listScale}" />';
    let EPARAM       = '<c:out value="${encParams}" />';
    let TOTAL_CNT    = 0;
    let rcptnAgreTable;

    const MSG_STDNT = '<spring:message code="msg.rcptnAgre.label.stdnt" text="수강생"/>';
    const MSG_PROF  = '<spring:message code="msg.rcptnAgre.label.prof" text="교직원"/>';
    const MSG_ADM  = '<spring:message code="msg.rcptnAgre.label.adm" text="관리자"/>';

    $(document).ready(function () {
        fn_initSearch();
        fn_initFilter();
        fn_loadList(PAGE_INDEX);
    });

    function fn_initSearch() {
        $("#inputSearchText").on("keydown", function(e) {
            if (e.keyCode == 13) fn_search();
        });
    }

    function fn_initFilter() {
        $('#selectOrg').on('change', function() {
            fn_loadSbjctList();
        });
    }

    function fn_loadSbjctList() {
        const $sel = $('#selectSbjct');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        const data = {
            orgId: $('#selectOrg').val()
        };

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(data)
        };
        ajaxCall('/admMsgMgrSbjctListAjax.do', param, function (res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function (v) {
                    $sel.append('<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        }, function() {});
    }

    function fn_search() {
        fn_loadList(1);
    }

    function fn_getSearchParam() {
        return {
            orgId: $('#selectOrg').val(),
            sbjctId: $('#selectSbjct').val(),
            userTycd: $('#selectUserTycd').val(),
            searchType: $('#selectSearchType').val(),
            searchText: $('#inputSearchText').val()
        };
    }

    function fn_loadList(pageIndex) {
        const extData = fn_getSearchParam();
        extData.pageIndex = pageIndex;
        extData.listScale = LIST_SCALE;

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/admMsgRcptnAgreListAjax.do', param, function (res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createListData(res.returnList, res.pageInfo);
                rcptnAgreTable.clearData();
                rcptnAgreTable.replaceData(dataList);
                rcptnAgreTable.setPageInfo(res.pageInfo);
                TOTAL_CNT = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#totalCntText').text(TOTAL_CNT);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_createListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function (v) {
            const rnum = total - v.lineNo + 1;

            dataList.push({
                no: rnum,
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                userTycd: v.userTycd === 'STDNT' ? MSG_STDNT : v.userTycd === 'PROF' ? MSG_PROF : v.userTycd === 'ADM' ? MSG_ADM : (v.userTycd || ''),
                stdntNo: v.stdntNo || '-',
                usernm: UiComm.escapeHtml(v.usernm || ''),
                pushRcvyn: fn_rcvynHtml(v.pushRcvyn),
                shrtntAlimRcvyn: fn_rcvynHtml(v.shrtntAlimRcvyn),
                emlAlimRcvyn: fn_rcvynHtml(v.emlAlimRcvyn),
                alimTalkRcvyn: fn_rcvynHtml(v.alimTalkRcvyn),
                smsRcvyn: fn_rcvynHtml(v.smsRcvyn)
            });
        });
        return dataList;
    }

    function fn_rcvynHtml(val) {
        if (val === 'N') {
            return '<span class="fcRed">N</span>';
        }
        return UiComm.escapeHtml(val || '');
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = scale;
        fn_loadList(1);
    }

    function fn_excelDown() {
        const excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: 'No', name: 'rnum', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.org" text="기관"/>', name: 'orgnm', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.sbjct" text="과목"/>', name: 'sbjctnm', align: 'left', width: '7000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.userTycd" text="사용자구분"/>', name: 'userTycd', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.stdntNo" text="학번/사번"/>', name: 'stdntNo', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.usernm" text="이름"/>', name: 'usernm', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: 'PUSH', name: 'pushRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.shrtnt"/>', name: 'shrtntAlimRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.emlNoti" text="이메일"/>', name: 'emlAlimRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.alimTalk"/>', name: 'alimTalkRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.sms" text="문자"/>', name: 'smsRcvyn', align: 'center', width: '2000'});

        const param = fn_getSearchParam();
        const form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/admMsgRcptnAgreExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'orgId', value: param.orgId }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctId', value: param.sbjctId }));
        form.append($('<input/>', { type: 'hidden', name: 'userTycd', value: param.userTycd }));
        form.append($('<input/>', { type: 'hidden', name: 'searchType', value: param.searchType }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: param.searchText }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <!-- admin -->
    <main class="common">

        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">

                <div class="sub-content">
                    <!-- page info -->
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.course" text="운영과목"/></label></span>
                            <div class="itemList">
                                <select class="form-select" id="selectOrg">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.orgAll" text="기관 전체"/></option>
                                    <c:forEach var="org" items="${filterOptions.orgList}">
                                        <option value="${org.orgId}"><c:out value="${org.orgnm}"/></option>
                                    </c:forEach>
                                </select>
                                <select class="form-select wide" id="selectSbjct" style="max-width: 200px;">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                    <c:forEach var="sbjct" items="${filterOptions.sbjctList}">
                                        <option value="${sbjct.sbjctId}"><c:out value="${sbjct.sbjctnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="selectUserTycd"><spring:message
                                    code="msg.rcptnAgre.label.userTycd" text="사용자 구분"/></label></span>
                            <div class="itemList">
                                <select class="form-select" id="selectUserTycd">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                    <option value="STDNT"><spring:message code="msg.rcptnAgre.label.stdnt"
                                                                          text="수강생"/></option>
                                    <option value="PROF"><spring:message code="msg.rcptnAgre.label.prof"
                                                                         text="교직원"/></option>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="selectSearchType"><spring:message
                                    code="msg.sndrDsctn.label.searchCond" text="검색 조건"/></label></span>
                            <div class="itemList">
                                <select class="form-select" id="selectSearchType">
                                    <option value="stdntNo"><spring:message code="msg.rcptnAgre.label.stdntNo"
                                                                            text="학번/사번"/></option>
                                    <option value="name"><spring:message code="msg.rcptnAgre.label.name"
                                                                         text="이름"/></option>
                                </select>
                                <input class="form-control wide" type="text" id="inputSearchText" value=""
                                       placeholder="<spring:message code="msg.sndrDsctn.label.searchPlaceholder" text="검색어입력"/>">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="fn_search()"><spring:message
                                    code="msg.sndrDsctn.label.search" text="검색"/></button>
                        </div>
                    </div>
                    <!-- //search typeA -->

                    <!-- 알림수신동의현황 -->
                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="msg.rcptnAgre.label.listTitle" text="알림수신동의현황"/>
                            [<spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b
                                    id="totalCntText">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]
                        </h3>
                        <div class="right-area">
                            <button type="button" class="btn basic" onclick="fn_excelDown()"><spring:message
                                    code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                            <uiex:listScale func="fn_changeListScale" value="${vo.listScale}"/>
                        </div>
                    </div>

                    <!-- 알림수신동의 그리드 -->
                    <div id="rcptnAgreList"></div>

                    <script>
                        rcptnAgreTable = UiTable("rcptnAgreList", {
                            lang: "ko",
                            pageFunc: fn_loadList,
                            columns: [
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.no' text='번호'/>",
                                    field: "no",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 50,
                                    minWidth: 40
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.org' text='기관'/>",
                                    field: "orgnm",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 225,
                                    minWidth: 60
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.sbjct' text='과목'/>",
                                    field: "sbjctnm",
                                    headerHozAlign: "center",
                                    hozAlign: "left",
                                    width: 0,
                                    minWidth: 120
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.userTycd' text='사용자구분'/>",
                                    field: "userTycd",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 110,
                                    minWidth: 60
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.stdntNo' text='학번/사번'/>",
                                    field: "stdntNo",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 100,
                                    minWidth: 70
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.usernm' text='이름'/>",
                                    field: "usernm",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 120,
                                    minWidth: 60
                                },
                                {
                                    title: "PUSH",
                                    field: "pushRcvyn",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 55,
                                    minWidth: 45
                                },
                                {
                                    title: "<spring:message code='msg.title.msg.shrtnt'/>",
                                    field: "shrtntAlimRcvyn",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 55,
                                    minWidth: 45
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.emlNoti' text='이메일'/>",
                                    field: "emlAlimRcvyn",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 55,
                                    minWidth: 45
                                },
                                {
                                    title: "<spring:message code='msg.title.msg.alimTalk'/>",
                                    field: "alimTalkRcvyn",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 55,
                                    minWidth: 45
                                },
                                {
                                    title: "<spring:message code='msg.rcptnAgre.col.sms' text='문자'/>",
                                    field: "smsRcvyn",
                                    headerHozAlign: "center",
                                    hozAlign: "center",
                                    width: 55,
                                    minWidth: 45
                                }
                            ]
                        });
                    </script>

                </div>
            </div>
        </div>
        <!-- //content -->

    </main>
    <!-- //admin -->
</div>

</body>
</html>
