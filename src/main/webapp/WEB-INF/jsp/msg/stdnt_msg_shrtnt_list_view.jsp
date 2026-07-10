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
    const PAGE_INDEX  = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let EPARAM     = '<c:out value="${encParams}" />';
    let shrtntTable;

    $(document).ready(function() {
        fn_initSearch();
        fn_initFilter();
        fn_initTable();
        fn_loadList(PAGE_INDEX);
    });

    function fn_initSearch() {
        $("#inputSearchText").on("keydown", function(e) {
            if (e.keyCode == 13) fn_search();
        });
    }

    function fn_initFilter() {
        $('#selectSbjctYr').on('change', function() { fn_loadSmstrList(); });
        $('#selectOrg').on('change', function() { fn_loadSbjctList(); });
    }

    function fn_loadSmstrList(callback) {
        const $sel = $('#selectSbjctSmstr');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        const sbjctYr = $('#selectSbjctYr').val();

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ sbjctYr: sbjctYr })
        };
        ajaxCall('/stdntMsgMgrSmstrListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + (v.dgrsSmstrChrt || '') + '">' + UiComm.escapeHtml(v.smstrChrtnm || '') + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
            if (typeof callback === 'function') callback();
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            if (typeof callback === 'function') callback();
        });
    }

    function fn_loadSbjctList(callback) {
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
        ajaxCall('/stdntMsgMgrSbjctListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
            if (typeof callback === 'function') callback();
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            if (typeof callback === 'function') callback();
        });
    }

    function fn_initTable() {
        const columns = [
            {title:"<spring:message code='msg.common.col.no' text='번호'/>",            field:"no",          headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
            {title:"<spring:message code='msg.common.col.sbjctYr' text='년도'/>",       field:"sbjctYr",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
            {title:"<spring:message code='msg.common.col.sbjctSmstr' text='학기'/>",    field:"sbjctSmstr",  headerHozAlign:"center", hozAlign:"center", width:160,  minWidth:35},
            {title:"<spring:message code='msg.common.col.orgnm' text='기관'/>",         field:"orgnm",       headerHozAlign:"center", hozAlign:"center", width:180,  minWidth:50},
            {title:"<spring:message code='msg.shrtnt.label.rcvSbjct' text='수강과목'/>", field:"sbjctnm",     headerHozAlign:"center", hozAlign:"center", width:180, minWidth:60},
            {title:"<spring:message code='msg.common.col.dvclasNo' text='분반'/>",      field:"dvclasNo",    headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
            {title:"<spring:message code='msg.common.col.sndngnm' text='발신자'/>",     field:"sndngnm",     headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:50},
            {title:"<spring:message code='msg.common.col.ttl' text='제목'/>",           field:"ttl",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:150, formatter:"html"},
            {title:"<spring:message code='msg.common.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",   headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110},
            {title:"<spring:message code='msg.shrtnt.col.fileCnt' text='파일'/>",       field:"fileCnt",     headerHozAlign:"center", hozAlign:"center", width:40,  minWidth:30, formatter:"html"},
            {title:"<spring:message code='msg.common.col.readYn' text='읽음'/>",        field:"readYn",      headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:40, formatter:"html"}
        ];

        $('#shrtntList_cardForm').html($('#rcvnCardForm').html());

        shrtntTable = UiTable("shrtntList", {
            lang: "ko",
            selectRow: "checkbox",
            pageFunc: fn_loadList,
            columns: columns
        });
    }

    function fn_search() {
        fn_loadList(1);
    }

    function fn_loadList(pageIndex) {
        const extData = {
              orgId        : $('#selectOrg').val()
            , sbjctYr      : $('#selectSbjctYr').val()
            , sbjctSmstr   : $('#selectSbjctSmstr').val()
            , sbjctId      : $('#selectSbjct').val()
            , sndngSdttm   : $('#sndngSdate').val()
            , sndngEdttm   : $('#sndngEdate').val()
            , searchType   : $('#selectSearchType').val()
            , searchText   : $('#inputSearchText').val()
            , pageIndex    : pageIndex
            , listScale    : LIST_SCALE
            , listType     : 'RCVN'
        };

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/msgShrtntRcvnListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createRcvnListData(res.returnList, res.pageInfo);
                shrtntTable.clearData();
                shrtntTable.replaceData(dataList);
                shrtntTable.setPageInfo(res.pageInfo);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_createRcvnListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v) {
            const rnum = total - v.lineNo + 1;
            const readYnHtml = v.readYn === 'Y' ? 'O' : '<span class="txt-blue"><strong>X</strong></span>';
            const ttlHtml = '<a href="javascript:fn_rcvnDetail(\'' + v.msgShrtntSndngId + '\')" class="title link">' + UiComm.escapeHtml(v.sndngTtl || '') + '</a>';

            dataList.push({
                no: rnum,
                sbjctYr: v.sbjctYr || '-',
                sbjctSmstr: v.sbjctSmstr || '-',
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: v.dvclasNo || '-',
                sndngnm: UiComm.escapeHtml(v.sndngnm || ''),
                ttl: ttlHtml,
                sndngDttm: UiComm.formatDate(v.sndngDttm, 'datetime2'),
                fileCnt: v.fileCnt > 0 ? '<i class="xi-paperclip"></i>' : '',
                readYn: readYnHtml,
                msgShrtntSndngId: v.msgShrtntSndngId
            });
        });
        return dataList;
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = scale;
        fn_loadList(1);
    }

    function fn_rcvnDetail(msgShrtntSndngId) {
        location.href = '/stdntMsgShrtntRcvnSelectView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({ msgShrtntSndngId: msgShrtntSndngId });
    }

    function fn_deleteSelected() {
        const selectedIds = shrtntTable.getSelectedData('msgShrtntSndngId');
        if (!selectedIds || selectedIds.length === 0) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }

        UiComm.showMessage('<spring:message code="msg.shrtnt.msg.confirmDelete"/>', 'confirm').then(function(result) {
            if (!result) return;
            fn_shrtntDeleteSequential(selectedIds, 0, { failCnt: 0 });
        });
    }

    function fn_shrtntDeleteSequential(ids, index, state) {
        if (index >= ids.length) {
            if (state.failCnt > 0) {
                UiComm.showMessage("<spring:message code='fail.common.delete'/>", "error");
            } else {
                UiComm.showMessage('<spring:message code="msg.common.msg.deleteSuccess"/>', 'success');
            }
            fn_loadList(1);
            return;
        }
        const delData = { listType: 'RCVN', msgShrtntSndngId: ids[index] };
        ajaxCall('/msgShrtntDeleteAjax.do',
            { encParams: EPARAM, addParams: UiComm.makeEncParams(delData) },
            function(res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result !== 1) state.failCnt++;
                fn_shrtntDeleteSequential(ids, index + 1, state);
            },
            function() {
                state.failCnt++;
                fn_shrtntDeleteSequential(ids, index + 1, state);
            });
    }
</script>
<body class="home ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <!-- dashboard -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp"/>

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
                                        <option value="<c:out value='${yr.sbjctYr}'/>" <c:if test="${yr.sbjctYr eq vo.sbjctYr}">selected</c:if>><c:out value="${yr.sbjctYr}"/><spring:message code="msg.rcptnAgre.label.year" text="년"/></option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" id="selectSbjctSmstr">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                    <c:forEach var="s" items="${filterOptions.smstrList}">
                                        <option value="<c:out value='${s.dgrsSmstrChrt}'/>" <c:if test="${s.dgrsSmstrChrt eq vo.sbjctSmstr}">selected</c:if>><c:out value="${s.smstrChrtnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label><spring:message code="msg.shrtnt.label.rcvSbjct" text="수강과목"/></label></span>
                            <div class="itemList">
                                <select class="form-select" id="selectOrg" autocomplete="off">
                                    <option value="" <c:if test="${empty vo.orgId}">selected</c:if>><spring:message code="msg.sndrDsctn.label.orgAll" text="기관 전체"/></option>
                                    <c:forEach var="org" items="${filterOptions.orgList}">
                                        <option value="<c:out value='${org.orgId}'/>" <c:if test="${org.orgId eq vo.orgId}">selected</c:if>><c:out value="${org.orgnm}"/></option>
                                    </c:forEach>
                                </select>
                                <select class="form-select wide" id="selectSbjct" style="max-width: 200px;">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                    <c:forEach var="sbjct" items="${filterOptions.sbjctList}">
                                        <option value="<c:out value='${sbjct.sbjctId}'/>" <c:if test="${sbjct.sbjctId eq vo.sbjctId}">selected</c:if>><c:out value="${sbjct.sbjctnm}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.sndngDate" text="발신 일시"/></label></span>
                            <div class="itemList">
                                <div class="date_area">
                                    <input type="text" placeholder="<spring:message code='msg.common.label.startDate' text='시작일'/>" id="sndngSdate" name="sndngSdate" class="datepicker" toDate="sndngEdate" value="<c:out value='${vo.sndngSdttm}'/>">
                                    <span class="txt-sort">~</span>
                                    <input type="text" placeholder="<spring:message code='msg.common.label.endDate' text='종료일'/>" id="sndngEdate" name="sndngEdate" class="datepicker" fromDate="sndngSdate" value="<c:out value='${vo.sndngEdttm}'/>">
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label><spring:message code="msg.common.label.searchCond" text="검색 조건"/></label></span>
                            <div class="itemList">
                                <select class="form-select" id="selectSearchType">
                                    <option value="sndngnm" <c:if test="${vo.searchType eq 'sndngnm'}">selected</c:if>><spring:message code="msg.common.label.searchSndngnm" text="발신자"/></option>
                                    <option value="sndngrId" <c:if test="${vo.searchType eq 'sndngrId'}">selected</c:if>><spring:message code="msg.common.label.searchSndngrId" text="발신자아이디"/></option>
                                    <option value="ttl" <c:if test="${vo.searchType eq 'ttl'}">selected</c:if>><spring:message code="msg.common.label.searchTtl" text="제목"/></option>
                                    <option value="cts" <c:if test="${vo.searchType eq 'cts'}">selected</c:if>><spring:message code="msg.common.label.searchCts" text="내용"/></option>
                                </select>
                                <input class="form-control wide" type="text" id="inputSearchText" value="<c:out value='${vo.searchText}'/>" placeholder="<spring:message code="msg.common.label.searchPlaceholder" text="검색어입력"/>">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="fn_search()"><spring:message code="msg.sndrDsctn.label.search" text="검색"/></button>
                        </div>
                    </div>
                    <!-- //search typeA -->

                    <!-- 목록 -->
                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="msg.shrtnt.label.rcvnListTitle" text="쪽지 수신 목록"/></h3>
                        <div class="right-area">
                            <button type="button" class="btn basic icon" aria-label="<spring:message code='msg.common.label.refresh' text='새로고침'/>" onclick="fn_search()"><i class="xi-refresh"></i></button>
                            <button type="button" class="btn basic" onclick="fn_deleteSelected()"><spring:message code="msg.common.label.delete" text="삭제"/></button>
                            <span class="list-card-button"></span>
                            <uiex:listScale func="fn_changeListScale" value="${vo.listScale}" />
                        </div>
                    </div>

                    <!-- 쪽지 그리드 -->
                    <div id="shrtntList"></div>

                    <!-- 쪽지 카드 폼 -->
                    <div id="shrtntList_cardForm" style="display:none"></div>

                    <!-- 수신 카드 폼 -->
                    <div id="rcvnCardForm" style="display:none">
                        <div class="card-header">
                            <div class="card-title">#[ttl]</div>
                        </div>
                        <div class="card-body">
                            <div class="desc">
                                <p><label class="label-title"><spring:message code='msg.common.col.sndngnm' text='발신자'/></label><strong>#[sndngnm]</strong></p>
                                <p><label class="label-title"><spring:message code='msg.common.col.sndngDttm' text='발신일시'/></label><strong>#[sndngDttm]</strong></p>
                                <p><label class="label-title"><spring:message code='msg.shrtnt.label.rcvSbjct' text='수강과목'/></label><strong>#[sbjctnm]</strong></p>
                            </div>
                            <div class="etc">
                                <p><label class="label-title"><spring:message code='msg.common.col.readYn' text='읽음'/></label><strong>#[readYn]</strong></p>
                                <p><label class="label-title"><spring:message code='msg.shrtnt.col.fileCnt' text='파일'/></label><strong>#[fileCnt]</strong></p>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
        <!-- //content -->

        <!-- common footer -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>

    </main>
    <!-- //dashboard-->

</div>

</body>
</html>
