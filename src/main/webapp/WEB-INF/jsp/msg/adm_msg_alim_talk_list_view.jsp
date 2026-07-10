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
    const PAGE_INDEX  = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let ACTIVE_TAB = '<c:out value="${vo.listType}" />' || 'RCVN';
    let EPARAM     = '<c:out value="${encParams}" />';
    let alimTalkTable;

    $(document).ready(function() {
        fn_initSearch();
        fn_initFilter();
        fn_initTabs();
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


    function fn_initTabs() {
        $('.tab_btn a').on('click', function(e) {
            e.preventDefault();
            $('.tab_btn a').removeClass('current');
            $(this).addClass('current');
            ACTIVE_TAB = $(this).data('tab');
            fn_updateBoardTitle();
            fn_initTable();
            fn_search();
        });
        if (ACTIVE_TAB === 'SNDNG') {
            $('.tab_btn a').removeClass('current');
            $('.tab_btn a[data-tab="SNDNG"]').addClass('current');
        }
        fn_updateBoardTitle();
    }

    function fn_updateBoardTitle() {
        const titleKey = ACTIVE_TAB === 'SNDNG'
            ? '<spring:message code="msg.alimTalk.label.sndngListTitle" text="알림톡 발신 목록"/>'
            : '<spring:message code="msg.alimTalk.label.rcvnListTitle" text="알림톡 수신 목록"/>';
        $('#boardTitle').text(titleKey);
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
        ajaxCall('/admMsgMgrSmstrListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + (v.dgrsSmstrChrt || '') + '">' + UiComm.escapeHtml(v.smstrChrtnm || '') + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
            if (typeof callback === 'function') callback();
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error");
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
        ajaxCall('/admMsgMgrSbjctListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
            if (typeof callback === 'function') callback();
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error");
            if (typeof callback === 'function') callback();
        });
    }

    function fn_initTable() {
        if (alimTalkTable) {
            alimTalkTable.destroy();
            $('#alimTalkList').parent().css({'width': '', 'max-width': ''});
            $('.list-card-button').empty();
        }

        let columns;
        let cardFormId;

        if (ACTIVE_TAB === 'RCVN') {
            columns = [
                {title:"<spring:message code='msg.common.col.no' text='번호'/>",            field:"no",          headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                {title:"<spring:message code='msg.common.col.sbjctYr' text='년도'/>",       field:"sbjctYr",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                {title:"<spring:message code='msg.common.col.sbjctSmstr' text='학기'/>",    field:"sbjctSmstr",  headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.common.col.orgnm' text='기관'/>",         field:"orgnm",       headerHozAlign:"center", hozAlign:"center", width:180,  minWidth:50},
                {title:"<spring:message code='msg.common.col.sbjctnm' text='운영과목'/>",   field:"sbjctnm",     headerHozAlign:"center", hozAlign:"center", width:180,  minWidth:60},
                {title:"<spring:message code='msg.common.col.dvclasNo' text='분반'/>",      field:"dvclasNo",    headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.common.col.sndngnm' text='발신자'/>",     field:"sndngnm",     headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:50},
                {title:"<spring:message code='msg.common.col.cts' text='내용'/>",           field:"cts",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:150, formatter:"html"},
                {title:"<spring:message code='msg.common.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",   headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110},
                {title:"<spring:message code='msg.common.col.readYn' text='읽음'/>",        field:"readYn",      headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:40, formatter:"html"}
            ];
            cardFormId = 'rcvnCardForm';
        } else {
            columns = [
                {title:"<spring:message code='msg.common.col.no' text='번호'/>",            field:"no",            headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                {title:"<spring:message code='msg.common.col.sbjctYr' text='년도'/>",       field:"sbjctYr",       headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                {title:"<spring:message code='msg.common.col.sbjctSmstr' text='학기'/>",    field:"sbjctSmstr",    headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.common.col.orgnm' text='기관'/>",         field:"orgnm",         headerHozAlign:"center", hozAlign:"center", width:180,  minWidth:50},
                {title:"<spring:message code='msg.common.col.sbjctnm' text='운영과목'/>",   field:"sbjctnm",       headerHozAlign:"center", hozAlign:"center", width:180,  minWidth:60},
                {title:"<spring:message code='msg.common.col.dvclasNo' text='분반'/>",      field:"dvclasNo",      headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.common.col.sndngnm' text='발신자'/>",     field:"sndngnm",       headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:50},
                {title:"<spring:message code='msg.common.col.cts' text='내용'/>",           field:"cts",           headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:150, formatter:"html"},
                {title:"<spring:message code='msg.alimTalk.col.rcvrCnt' text='수신자'/>",     field:"rcvrCnt",       headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:40},
                {title:"<spring:message code='msg.common.col.sndngSuccCnt' text='성공'/>",  field:"sndngSuccCnt",  headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:35},
                {title:"<spring:message code='msg.alimTalk.col.sndngYn' text='발신'/>",       field:"sndngYn",       headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.common.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",     headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110, formatter:"html"},
                {title:"<spring:message code='msg.common.col.rsrvCnclDttm' text='예약취소일시'/>", field:"rsrvCnclDttm", headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110, formatter:"html"},
                {title:"<spring:message code='msg.common.col.rsrvCncl' text='예약취소'/>",  field:"rsrvCncl",      headerHozAlign:"center", hozAlign:"center", width:84,  minWidth:84, formatter:"html"}
            ];
            cardFormId = 'sndngCardForm';
        }

        $('#alimTalkList_cardForm').html($('#' + cardFormId).html());

        alimTalkTable = UiTable("alimTalkList", {
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
            , listType     : ACTIVE_TAB
        };

        const url = ACTIVE_TAB === 'RCVN' ? '/admMsgAlimTalkRcvnListAjax.do' : '/admMsgAlimTalkSndngListAjax.do';

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall(url, param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = ACTIVE_TAB === 'RCVN' ? fn_createRcvnListData(res.returnList, res.pageInfo) : fn_createSndngListData(res.returnList, res.pageInfo);
                alimTalkTable.clearData();
                alimTalkTable.replaceData(dataList);
                alimTalkTable.setPageInfo(res.pageInfo);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_createRcvnListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            const rnum = total - v.lineNo + 1;
            const readYnHtml = v.readYn === 'Y' ? 'O' : '<span class="txt-blue"><strong>X</strong></span>';
            const ctsHtml = '<a href="javascript:fn_rcvnDetail(\'' + v.msgMblSndngId + '\')" class="title link">' + UiComm.escapeHtml(v.sndngCts || '') + '</a>';

            dataList.push({
                no: rnum,
                sbjctYr: v.sbjctYr || '-',
                sbjctSmstr: v.sbjctSmstr || '-',
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: v.dvclasNo || '-',
                sndngnm: UiComm.escapeHtml(v.sndngnm || ''),
                cts: ctsHtml,
                sndngDttm: UiComm.formatDate(v.sndngDttm, 'datetime2'),
                readYn: readYnHtml,
                msgMblSndngId: v.msgMblSndngId
            });
        });
        return dataList;
    }

    function fn_createSndngListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            const rnum = total - v.lineNo + 1;
            const ctsHtml = '<a href="javascript:fn_sndngDetail(\'' + v.msgId + '\')" class="title link">' + UiComm.escapeHtml(v.txtCts || '') + '</a>';
            const sndngDttmHtml = v.sndngYn === 'N'
                ? '<span class="txt-blue">' + UiComm.formatDate(v.efctvSndngDttm, 'datetime2') + '</span>'
                : UiComm.formatDate(v.efctvSndngDttm, 'datetime2');
            const rsrvCnclDttmHtml = v.rsrvSndngCnclDttm
                ? '<span class="txt-red">' + UiComm.formatDate(v.rsrvSndngCnclDttm, 'datetime2') + '</span>'
                : '-';
            const rsrvCnclHtml = (v.rsrvYn === 'Y' && !v.rsrvSndngCnclDttm)
                ? '<button class="btn basic small" data-msg-id="' + (v.msgId || '') + '" data-ttl="' + UiComm.escapeHtml(v.txtCts || '') + '" data-dttm="' + UiComm.formatDate(v.efctvSndngDttm, 'datetime2') + '" data-rcvr-cnt="' + (v.rcvrCnt || 0) + '" onclick="fn_openRsrvCnclFromBtn(this)"><spring:message code="msg.common.label.rsrvCncl" text="예약취소"/></button>'
                : '-';

            dataList.push({
                no: rnum,
                sbjctYr: v.sbjctYr || '-',
                sbjctSmstr: v.sbjctSmstr || '-',
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: v.dvclasNo || '-',
                sndngnm: UiComm.escapeHtml(v.sndngnm || ''),
                cts: ctsHtml,
                rcvrCnt: v.rcvrCnt || 0,
                sndngSuccCnt: v.sndngYn === 'Y' ? (v.sndngSuccCnt || 0) : '-',
                sndngYn: v.sndngYn || '',
                sndngDttm: sndngDttmHtml,
                rsrvCnclDttm: rsrvCnclDttmHtml,
                rsrvCncl: rsrvCnclHtml,
                msgId: v.msgId
            });
        });
        return dataList;
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = scale;
        fn_loadList(1);
    }

    function fn_rcvnDetail(msgMblSndngId) {
        location.href = '/admMsgAlimTalkRcvnSelectView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({ msgMblSndngId: msgMblSndngId });
    }

    function fn_sndngDetail(msgId) {
        location.href = '/admMsgAlimTalkSndngSelectView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({ msgId: msgId });
    }

    function fn_sndngRegist() {
        location.href = '/admMsgAlimTalkSndngRegistView.do?encParams=' + EPARAM;
    }

    function fn_deleteSelected() {
        const idField = ACTIVE_TAB === 'RCVN' ? 'msgMblSndngId' : 'msgId';
        const selectedIds = alimTalkTable.getSelectedData(idField);
        if (!selectedIds || selectedIds.length === 0) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }

        UiComm.showMessage('<spring:message code="msg.alimTalk.msg.confirmDelete"/>', 'confirm').then(function(result) {
            if (!result) return;
            fn_alimTalkDeleteSequential(selectedIds, idField, 0, { failCnt: 0 });
        });
    }

    function fn_alimTalkDeleteSequential(ids, idField, index, state) {
        if (index >= ids.length) {
            if (state.failCnt > 0) {
                UiComm.showMessage("<spring:message code='fail.common.delete'/>", "error");
            } else {
                UiComm.showMessage('<spring:message code="msg.common.msg.deleteSuccess"/>', 'success');
            }
            fn_loadList(1);
            return;
        }
        const delData = { listType: ACTIVE_TAB };
        delData[idField] = ids[index];
        ajaxCall('/admMsgAlimTalkDeleteAjax.do',
            { encParams: EPARAM, addParams: UiComm.makeEncParams(delData) },
            function(res) {
                if (res.encParams) EPARAM = res.encParams;
                if (res.result !== 1) state.failCnt++;
                fn_alimTalkDeleteSequential(ids, idField, index + 1, state);
            },
            function() {
                state.failCnt++;
                fn_alimTalkDeleteSequential(ids, idField, index + 1, state);
            });
    }

    function fn_openRsrvCnclFromBtn(btn) {
        const $b = $(btn);
        fn_openRsrvCnclPopup($b.data('msg-id'), $b.data('ttl'), $b.data('dttm'), $b.data('rcvr-cnt'));
    }

    function fn_openRsrvCnclPopup(msgId, ttl, rsrvDttm, rcvrCnt) {
        $('#rsrvCnclMsgId').val(msgId);
        $('#rsrvCnclTtl').text(ttl);
        $('#rsrvCnclDttm').text(rsrvDttm);
        $('#rsrvCnclRcvrCnt').text(rcvrCnt);
        $('#rsrvCnclUser').text('<c:out value="${vo.userNm}"/>');

        $('#rsrvCnclNowDttm').text(UiComm.formatDate(new Date().toISOString().replace(/[-T:\.Z]/g, '').substring(0, 14), 'datetime2'));
        $('#rsrvCnclModal').addClass('active').attr('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }

    function fn_closeRsrvCnclPopup() {
        $('#rsrvCnclModal').removeClass('active').attr('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    function fn_doRsrvCncl() {
        const msgId = $('#rsrvCnclMsgId').val();
        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgId: msgId })
        };
        ajaxCall('/admMsgAlimTalkRsrvCnclModifyAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                fn_closeRsrvCnclPopup();
                UiComm.showMessage('<spring:message code="msg.common.msg.rsrvCnclSuccess"/>', 'success');
                fn_loadList(1);
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }
</script>
<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <!-- dashboard -->
    <main class="common">
        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">

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
                            <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.course" text="운영과목"/></label></span>
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
                        <h3 class="board-title" id="boardTitle"><c:choose><c:when test="${vo.listType eq 'SNDNG'}"><spring:message code="msg.alimTalk.label.sndngListTitle" text="알림톡 발신 목록"/></c:when><c:otherwise><spring:message code="msg.alimTalk.label.rcvnListTitle" text="알림톡 수신 목록"/></c:otherwise></c:choose></h3>
                        <div class="right-area">
                            <div class="tab_btn">
                                <a href="#0" class="current" data-tab="RCVN"><spring:message code="msg.common.label.rcvnTab" text="수신목록"/></a>
                                <a href="#0" data-tab="SNDNG"><spring:message code="msg.common.label.sndngTab" text="발신목록"/></a>
                            </div>
                            <button type="button" class="btn basic icon" aria-label="<spring:message code='msg.common.label.refresh' text='새로고침'/>" onclick="fn_search()"><i class="xi-refresh"></i></button>
                            <button type="button" class="btn basic" onclick="fn_deleteSelected()"><spring:message code="msg.common.label.delete" text="삭제"/></button>
                            <button type="button" class="btn type2" onclick="fn_sndngRegist()"><spring:message code="msg.common.label.sndngRegist" text="발신하기"/></button>
                            <span class="list-card-button"></span>
                            <uiex:listScale func="fn_changeListScale" value="${vo.listScale}" />
                        </div>
                    </div>

                    <!-- 알림톡 알림 그리드 -->
                    <div id="alimTalkList"></div>

                </div>

            </div>
        </div>
        <!-- //content -->

    </main>
    <!-- //dashboard-->

</div>

<!-- 발신 예약 취소 팝업 -->
<div class="modal-overlay" id="rsrvCnclModal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="modal-content modal-md" tabindex="-1">
        <div class="modal-header">
            <h2><spring:message code="msg.common.label.rsrvCnclTitle" text="발신 예약 취소"/></h2>
            <button class="modal-close" aria-label="<spring:message code='msg.common.label.closeBtn' text='닫기'/>" onclick="fn_closeRsrvCnclPopup()"><i class="icon-svg-close"></i></button>
        </div>
        <div class="modal-body">
            <div class="msg-box">
                <p class="txt">
                    <i class="icon-svg-warning" aria-hidden="true"></i>
                    <span><spring:message code="msg.alimTalk.msg.rsrvCnclWarn"/></span>
                </p>
            </div>
            <input type="hidden" id="rsrvCnclMsgId">
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.ttl" text="제목"/></label></li>
                    <li id="rsrvCnclTtl"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rsrvSndngDttm" text="발신예약일시"/></label></li>
                    <li id="rsrvCnclDttm"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.alimTalk.label.rcvrCnt" text="수신자"/></label></li>
                    <li id="rsrvCnclRcvrCnt"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rsrvCnclUser" text="예약취소자"/></label></li>
                    <li id="rsrvCnclUser"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rsrvCnclDttm" text="예약취소일시"/></label></li>
                    <li id="rsrvCnclNowDttm"></li>
                </ul>
            </div>
            <div class="modal_btns">
                <button type="button" class="btn type1" onclick="fn_doRsrvCncl()"><spring:message code="msg.common.label.rsrvCnclBtn" text="취소하기"/></button>
                <button type="button" class="btn type2" onclick="fn_closeRsrvCnclPopup()"><spring:message code="msg.common.label.closeBtn" text="닫기"/></button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
