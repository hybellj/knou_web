<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    const PAGE_INDEX = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE   = '<c:out value="${vo.listScale}" />';
    let EPARAM       = '<c:out value="${encParams}" />';
    let TOTAL_CNT    = 0;
    let rcptnAgreTable;

    $(document).ready(function() {
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
        $('#selectSbjctYr').on('change', function() { fn_loadSmstrList(); });
        $('#selectOrg').on('change', function() {
            fn_loadSbjctList();
        });
    }

    function fn_loadSmstrList() {
        const $sel = $('#selectSbjctSmstr');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        const sbjctYr = $('#selectSbjctYr').val();

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ sbjctYr: sbjctYr })
        };
        ajaxCall('/msgMgrSmstrListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + (v.dgrsSmstrChrt || '') + '">' + UiComm.escapeHtml(v.smstrChrtnm || '') + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        }, function() {});
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
        ajaxCall('/msgMgrSbjctListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
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
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            sbjctId: $('#selectSbjct').val(),
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
        ajaxCall('/msgRcptnAgreListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createListData(res.returnList, res.pageInfo);
                rcptnAgreTable.clearData();
                rcptnAgreTable.replaceData(dataList);
                rcptnAgreTable.setPageInfo(res.pageInfo);
                TOTAL_CNT = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
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

        list.forEach(function(v) {
            const rnum = total - v.lineNo + 1;

            dataList.push({
                no: rnum,
                sbjctYr: v.sbjctYr || '',
                sbjctSmstr: v.sbjctSmstr || '',
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: v.dvclasNo || '',
                stdntNo: v.stdntNo || '-',
                usernm: UiComm.escapeHtml(v.usernm || ''),
                mblPhn: UiComm.escapeHtml(v.mblPhn || ''),
                eml: UiComm.escapeHtml(v.eml || ''),
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
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.no" text="번호"/>', name: 'rnum', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.year" text="년도"/>', name: 'sbjctYr', align: 'center', width: '2500'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.smstr" text="학기"/>', name: 'sbjctSmstr', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.org" text="기관"/>', name: 'orgnm', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.sbjct" text="운영과목"/>', name: 'sbjctnm', align: 'left', width: '7000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.dvclas" text="분반"/>', name: 'dvclasNo', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.stdntNo" text="학번"/>', name: 'stdntNo', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.usernm" text="이름"/>', name: 'usernm', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.mblPhn" text="휴대폰번호"/>', name: 'mblPhn', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.eml" text="이메일"/>', name: 'eml', align: 'left', width: '6000'});
        excelGrid.colModel.push({label: 'PUSH', name: 'pushRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.shrtnt"/>', name: 'shrtntAlimRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.emlNoti" text="이메일"/>', name: 'emlAlimRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.alimTalk"/>', name: 'alimTalkRcvyn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.sms" text="문자"/>', name: 'smsRcvyn', align: 'center', width: '2000'});

        const param = fn_getSearchParam();
        const form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgRcptnAgreExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'sbjctYr', value: param.sbjctYr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctSmstr', value: param.sbjctSmstr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctId', value: param.sbjctId }));
        form.append($('<input/>', { type: 'hidden', name: 'searchType', value: param.searchType }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: param.searchText }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }
</script>

<body class="home ${uiex:getTheme()} ${bodyClass}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="main"/>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.yearSmstr" text="학사년도/학기"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSbjctYr">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                        <c:forEach var="yr" items="${filterOptions.yrList}">
                                            <option value="${yr.sbjctYr}" <c:if test="${yr.sbjctYr eq vo.sbjctYr}">selected</c:if>>${yr.sbjctYr}<spring:message code="msg.rcptnAgre.label.year" text="년"/></option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="selectSbjctSmstr">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                    </select>
                                </div>
                            </div>
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
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.searchCond" text="검색 조건"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearchType">
                                        <option value="name"><spring:message code="msg.rcptnAgre.label.name" text="이름"/></option>
                                    </select>
                                    <input class="form-control wide" type="text" id="inputSearchText" value="" placeholder="<spring:message code="msg.sndrDsctn.label.searchPlaceholder" text="검색어입력"/>">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="fn_search()"><spring:message code="msg.sndrDsctn.label.search" text="검색"/></button>
                            </div>
                        </div>
                        <!-- //search typeA -->

                        <!-- 알림수신동의현황 -->
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="msg.rcptnAgre.label.listTitle" text="알림수신동의현황"/></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_excelDown()"><spring:message code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                                <span class="list-card-button"></span>
                                <uiex:listScale func="fn_changeListScale" value="${vo.listScale}" />
                            </div>
                        </div>

                        <!-- 알림수신동의 그리드 -->
                        <div id="rcptnAgreList"></div>

                        <!-- 알림수신동의 카드 폼 -->
                        <div id="rcptnAgreList_cardForm" style="display:none">
                            <div class="card-header">
                                #[sbjctYr] #[sbjctSmstr]
                                <div class="card-title">#[usernm] (#[stdntNo])</div>
                            </div>
                            <div class="card-body">
                                <div class="desc">
                                    <p><label class="label-title"><spring:message code='msg.rcptnAgre.col.sbjct' text='운영과목'/></label><strong>#[sbjctnm]</strong></p>
                                </div>
                                <div class="etc">
                                    <p><label class="label-title">PUSH</label><strong>#[pushRcvyn]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.title.msg.shrtnt'/></label><strong>#[shrtntAlimRcvyn]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.rcptnAgre.col.emlNoti' text='이메일'/></label><strong>#[emlAlimRcvyn]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.title.msg.alimTalk'/></label><strong>#[alimTalkRcvyn]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.rcptnAgre.col.sms' text='문자'/></label><strong>#[smsRcvyn]</strong></p>
                                </div>
                            </div>
                        </div>

                        <script>
                        rcptnAgreTable = UiTable("rcptnAgreList", {
                            lang: "ko",
                            pageFunc: fn_loadList,
                            columns: [
                                {title:"<spring:message code='msg.rcptnAgre.col.no' text='번호'/>",         field:"no",              headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.rcptnAgre.col.year' text='년도'/>",       field:"sbjctYr",         headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                                {title:"<spring:message code='msg.rcptnAgre.col.smstr' text='학기'/>",      field:"sbjctSmstr",      headerHozAlign:"center", hozAlign:"center", width:160,  minWidth:40},
                                {title:"<spring:message code='msg.rcptnAgre.col.org' text='기관'/>",        field:"orgnm",           headerHozAlign:"center", hozAlign:"center", width:180, minWidth:60},
                                {title:"<spring:message code='msg.rcptnAgre.col.sbjct' text='운영과목'/>",   field:"sbjctnm",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:120},
                                {title:"<spring:message code='msg.rcptnAgre.col.dvclas' text='분반'/>",     field:"dvclasNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.rcptnAgre.col.stdntNo' text='학번'/>",    field:"stdntNo",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:70},
                                {title:"<spring:message code='msg.rcptnAgre.col.usernm' text='이름'/>",     field:"usernm",          headerHozAlign:"center", hozAlign:"center", width:110,  minWidth:60},
                                {title:"<spring:message code='msg.rcptnAgre.col.mblPhn' text='휴대폰번호'/>", field:"mblPhn",          headerHozAlign:"center", hozAlign:"center", width:130, minWidth:90},
                                {title:"<spring:message code='msg.rcptnAgre.col.eml' text='이메일'/>",      field:"eml",             headerHozAlign:"center", hozAlign:"left",   width:160, minWidth:100},
                                {title:"PUSH",                                                             field:"pushRcvyn",       headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:45},
                                {title:"<spring:message code='msg.title.msg.shrtnt'/>",                    field:"shrtntAlimRcvyn", headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:45},
                                {title:"<spring:message code='msg.rcptnAgre.col.emlNoti' text='이메일'/>",   field:"emlAlimRcvyn",    headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:45},
                                {title:"<spring:message code='msg.title.msg.alimTalk'/>",                  field:"alimTalkRcvyn",   headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:45},
                                {title:"<spring:message code='msg.rcptnAgre.col.sms' text='문자'/>",        field:"smsRcvyn",        headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:45}
                            ]
                        });
                        </script>

                    </div>

                </div>
            </div>
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>
