<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="${userCtx.admin ? 'admin' : 'dashboard'}"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let currentPage = 1;
    let listScale = ${pageSize};
    let totalCnt = 0;
    let activeTab = new URLSearchParams(location.search).get('tab') === 'SNDNG' ? 'SNDNG' : 'RCVN';
    let shrtntTable;

    /* URL prefix by role */
    let rcvnDetailUrl = '${userCtx.admin ? "/mngrMsgShrtntRcvnDetail.do" : "/profMsgShrtntRcvnDetail.do"}';
    let sndngDetailUrl = '${userCtx.admin ? "/mngrMsgShrtntSndngDetail.do" : "/profMsgShrtntSndngDetail.do"}';
    let sndngRegistUrl = '${userCtx.admin ? "/mngrMsgShrtntSndngRegistView.do" : "/profMsgShrtntSndngRegistView.do"}';

    $(document).ready(function() {

        /* URL 파라미터에 의한 초기 탭 활성화 */
        if (activeTab === 'SNDNG') {
            $('.tab_btn a').removeClass('current');
            $('.tab_btn a[data-tab="SNDNG"]').addClass('current');
        }

        /* 탭 클릭 이벤트 */
        $('.tab_btn a').on('click', function(e) {
            e.preventDefault();
            $('.tab_btn a').removeClass('current');
            $(this).addClass('current');
            activeTab = $(this).data('tab');
            fn_initTable();
            fn_search();
        });

        /* 셀렉트박스 change 이벤트 */
        $('#selectSbjctYr').on('change', function() {
            fn_loadSmstrList();
            fn_loadSbjctList();
        });

        $('#selectSbjctSmstr').on('change', function() {
            fn_loadSbjctList();
        });

        $('#selectDept').on('change', function() {
            fn_loadSbjctList();
        });

        /* 셀렉트박스 초기 로딩 */
        fn_loadYrList();
        fn_loadDeptList();

        /* 테이블 초기화 및 리스트 조회 */
        fn_initTable();
        fn_search();
    });

    /* 학사년도 목록 조회 */
    function fn_loadYrList() {
        ajaxCall('/msgShrtntYrListAjax.do', {}, function(res) {
            let $sel = $('#selectSbjctYr');
            $sel.find('option:gt(0)').remove();
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctYr + '">' + v.sbjctYr + '<spring:message code="msg.rcptnAgre.label.year" text="년"/></option>');
                });
            }
            $sel.trigger('chosen:updated');
        });
    }

    /* 학기 목록 조회 */
    function fn_loadSmstrList() {
        let $sel = $('#selectSbjctSmstr');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        let sbjctYr = $('#selectSbjctYr').val();
        if (!sbjctYr) return;

        ajaxCall('/msgShrtntSmstrListAjax.do', { sbjctYr: sbjctYr }, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctSmstr + '">' + v.sbjctSmstr + '<spring:message code="msg.rcptnAgre.label.smstr" text="학기"/></option>');
                });
            }
            $sel.trigger('chosen:updated');
        });
    }

    /* 학과 목록 조회 */
    function fn_loadDeptList() {
        ajaxCall('/msgShrtntDeptListAjax.do', {}, function(res) {
            let $sel = $('#selectDept');
            $sel.find('option:gt(0)').remove();
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.deptId + '">' + UiComm.escapeHtml(v.deptnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        });
    }

    /* 운영과목 목록 조회 */
    function fn_loadSbjctList() {
        let $sel = $('#selectSbjct');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        let data = {
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            deptId: $('#selectDept').val()
        };

        ajaxCall('/msgShrtntSbjctListAjax.do', data, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        });
    }

    /* 테이블 초기화 (탭별 컬럼 구성) */
    function fn_initTable() {
        if (shrtntTable) {
            shrtntTable.destroy();
            $('#shrtntList').parent().css({'width': '', 'max-width': ''});
            $('.list-card-button').empty();
        }

        let columns;
        let cardFormId;

        if (activeTab === 'RCVN') {
            columns = [
                {title:"<spring:message code='msg.shrtnt.col.no' text='번호'/>",            field:"no",          headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                {title:"<spring:message code='msg.shrtnt.col.sbjctYr' text='년도'/>",       field:"sbjctYr",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                {title:"<spring:message code='msg.shrtnt.col.sbjctSmstr' text='학기'/>",    field:"sbjctSmstr",  headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.shrtnt.col.orgnm' text='기관'/>",         field:"orgnm",       headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:50},
                {title:"<spring:message code='msg.shrtnt.col.deptnm' text='학과'/>",        field:"deptnm",      headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:60},
                {title:"<spring:message code='msg.shrtnt.col.sbjctnm' text='운영과목'/>",   field:"sbjctnm",     headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:60},
                {title:"<spring:message code='msg.shrtnt.col.dvclasNo' text='분반'/>",      field:"dvclasNo",    headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.shrtnt.col.sndngnm' text='발신자'/>",     field:"sndngnm",     headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:50},
                {title:"<spring:message code='msg.shrtnt.col.stdntNo' text='학번'/>",       field:"stdntNo",     headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:70},
                {title:"<spring:message code='msg.shrtnt.col.rprsId' text='대표ID'/>",      field:"userRprsId2", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:60},
                {title:"<spring:message code='msg.shrtnt.col.cts' text='내용'/>",           field:"cts",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:150, formatter:"html"},
                {title:"<spring:message code='msg.shrtnt.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",   headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110},
                {title:"<spring:message code='msg.shrtnt.col.fileCnt' text='파일'/>",       field:"fileCnt",     headerHozAlign:"center", hozAlign:"center", width:40,  minWidth:30, formatter:"html"},
                {title:"<spring:message code='msg.shrtnt.col.readYn' text='읽음'/>",        field:"readYn",      headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:40, formatter:"html"}
            ];
            cardFormId = 'rcvnCardForm';
        } else {
            columns = [
                {title:"<spring:message code='msg.shrtnt.col.no' text='번호'/>",            field:"no",            headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                {title:"<spring:message code='msg.shrtnt.col.sbjctYr' text='년도'/>",       field:"sbjctYr",       headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                {title:"<spring:message code='msg.shrtnt.col.sbjctSmstr' text='학기'/>",    field:"sbjctSmstr",    headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.shrtnt.col.orgnm' text='기관'/>",         field:"orgnm",         headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:50},
                {title:"<spring:message code='msg.shrtnt.col.deptnm' text='학과'/>",        field:"deptnm",        headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:60},
                {title:"<spring:message code='msg.shrtnt.col.sbjctnm' text='운영과목'/>",   field:"sbjctnm",       headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:60},
                {title:"<spring:message code='msg.shrtnt.col.dvclasNo' text='분반'/>",      field:"dvclasNo",      headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.shrtnt.col.sndngnm' text='발신자'/>",     field:"sndngnm",       headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:50},
                {title:"<spring:message code='msg.shrtnt.col.ttl' text='제목'/>",           field:"ttl",           headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:150, formatter:"html"},
                {title:"<spring:message code='msg.shrtnt.col.rcvrCnt' text='수신자'/>",     field:"rcvrCnt",       headerHozAlign:"center", hozAlign:"center", width:55,  minWidth:40},
                {title:"<spring:message code='msg.shrtnt.col.sndngSuccCnt' text='성공'/>",  field:"sndngSuccCnt",  headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:35},
                {title:"<spring:message code='msg.shrtnt.col.sndngYn' text='발신'/>",       field:"sndngYn",       headerHozAlign:"center", hozAlign:"center", width:45,  minWidth:35},
                {title:"<spring:message code='msg.shrtnt.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",     headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110, formatter:"html"},
                {title:"<spring:message code='msg.shrtnt.col.rsrvCnclDttm' text='예약취소일시'/>", field:"rsrvCnclDttm", headerHozAlign:"center", hozAlign:"center", width:130, minWidth:110, formatter:"html"},
                {title:"<spring:message code='msg.shrtnt.col.rsrvCncl' text='예약취소'/>",  field:"rsrvCncl",      headerHozAlign:"center", hozAlign:"center", width:84,  minWidth:84, formatter:"html"}
            ];
            cardFormId = 'sndngCardForm';
        }

        $('#shrtntList_cardForm').html($('#' + cardFormId).html());

        shrtntTable = UiTable("shrtntList", {
            lang: "ko",
            selectRow: "checkbox",
            pageFunc: fn_loadList,
            columns: columns
        });
    }

    /* 검색 */
    function fn_search() {
        fn_loadList(1);
    }

    /* 목록 조회 */
    function fn_loadList(pageIndex) {
        if (pageIndex) currentPage = pageIndex;

        let param = fn_getSearchParam();
        param.pageIndex = currentPage;
        param.listScale = listScale;

        let url = activeTab === 'RCVN' ? '/msgShrtntRcvnListAjax.do' : '/msgShrtntSndngListAjax.do';

        ajaxCall(url, param, function(res) {
            if (res.result > 0) {
                let dataList = activeTab === 'RCVN' ? fn_createRcvnListData(res.returnList, res.pageInfo) : fn_createSndngListData(res.returnList, res.pageInfo);
                shrtntTable.clearData();
                shrtntTable.replaceData(dataList);
                shrtntTable.setPageInfo(res.pageInfo);
                totalCnt = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
            } else {
                alert(res.message || '<spring:message code="fail.common.select"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 수신 목록 데이터 생성 */
    function fn_createRcvnListData(list, pageInfo) {
        let dataList = [];
        if (!list || list.length === 0) return dataList;

        let total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            let rnum = total - ((currentPage - 1) * listScale) - i;
            let readYnHtml = v.readYn === 'Y' ? 'O' : '<span class="txt-blue"><strong>X</strong></span>';
            let ctsHtml = '<a href="javascript:fn_rcvnDetail(\'' + v.msgShrtntSndngId + '\')">' + UiComm.escapeHtml(v.sndngTtl || '') + '</a>';

            dataList.push({
                no: rnum,
                sbjctYr: UiComm.escapeHtml(v.sbjctYr || '-'),
                sbjctSmstr: UiComm.escapeHtml(v.sbjctSmstr || '-'),
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                deptnm: UiComm.escapeHtml(v.deptnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: UiComm.escapeHtml(v.dvclasNo || '-'),
                sndngnm: UiComm.escapeHtml(v.sndngnm || ''),
                stdntNo: UiComm.escapeHtml(v.stdntNo || ''),
                userRprsId2: UiComm.escapeHtml(v.userRprsId2 || ''),
                cts: ctsHtml,
                sndngDttm: UiComm.formatDate(v.sndngDttm, 'datetime'),
                fileCnt: v.fileCnt > 0 ? '<i class="xi-paperclip"></i>' : '',
                readYn: readYnHtml,
                msgShrtntSndngId: v.msgShrtntSndngId
            });
        });
        return dataList;
    }

    /* 발신 목록 데이터 생성 */
    function fn_createSndngListData(list, pageInfo) {
        let dataList = [];
        if (!list || list.length === 0) return dataList;

        let total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            let rnum = total - ((currentPage - 1) * listScale) - i;
            let ttlHtml = '<a href="javascript:fn_sndngDetail(\'' + v.msgId + '\')">' + UiComm.escapeHtml(v.ttl || '') + '</a>';
            let sndngDttmHtml = v.sndngYn === 'N'
                ? '<span class="txt-blue">' + UiComm.formatDate(v.efctvSndngDttm, 'datetime') + '</span>'
                : UiComm.formatDate(v.efctvSndngDttm, 'datetime');
            let rsrvCnclDttmHtml = v.rsrvSndngCnclDttm
                ? '<span class="txt-red">' + UiComm.formatDate(v.rsrvSndngCnclDttm, 'datetime') + '</span>'
                : '-';
            let rsrvCnclHtml = (v.rsrvYn === 'Y' && !v.rsrvSndngCnclDttm)
                ? '<button class="btn basic small" onclick="fn_rsrvCncl(\'' + v.msgId + '\')"><spring:message code="msg.shrtnt.label.rsrvCncl" text="예약취소"/></button>'
                : '-';

            dataList.push({
                no: rnum,
                sbjctYr: UiComm.escapeHtml(v.sbjctYr || '-'),
                sbjctSmstr: UiComm.escapeHtml(v.sbjctSmstr || '-'),
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                deptnm: UiComm.escapeHtml(v.deptnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: UiComm.escapeHtml(v.dvclasNo || '-'),
                sndngnm: UiComm.escapeHtml(v.sndngnm || ''),
                ttl: ttlHtml,
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

    /* 검색 파라미터 수집 */
    function fn_getSearchParam() {
        return {
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            deptId: $('#selectDept').val(),
            sbjctId: $('#selectSbjct').val(),
            sndngSdttm: $('#sndngSdate').val(),
            sndngEdttm: $('#sndngEdate').val(),
            searchType: $('#selectSearchType').val(),
            searchText: $('#inputSearchText').val()
        };
    }

    /* 리스트 스케일 변경 */
    function fn_changeListScale(scale) {
        listScale = scale;
        fn_loadList(1);
    }

    /* 수신 상세 이동 */
    function fn_rcvnDetail(msgShrtntSndngId) {
        location.href = rcvnDetailUrl + '?msgShrtntSndngId=' + msgShrtntSndngId;
    }

    /* 발신 상세 이동 */
    function fn_sndngDetail(msgId) {
        location.href = sndngDetailUrl + '?msgId=' + msgId;
    }

    /* 발신하기 이동 */
    function fn_sndngRegist() {
        location.href = sndngRegistUrl;
    }

    /* 선택 삭제 */
    function fn_deleteSelected() {
        let idField = activeTab === 'RCVN' ? 'msgShrtntSndngId' : 'msgId';
        let selectedIds = shrtntTable.getSelectedData(idField);
        if (!selectedIds || selectedIds.length === 0) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }

        if (!confirm('<spring:message code="msg.shrtnt.msg.confirmDelete"/>')) return;

        let deletePromises = selectedIds.map(function(id) {
            let param = { listType: activeTab };
            param[idField] = id;
            return new Promise(function(resolve) {
                ajaxCall('/msgShrtntDeleteAjax.do', param, function(res) { resolve(res); });
            });
        });

        Promise.all(deletePromises).then(function() {
            alert('<spring:message code="msg.shrtnt.msg.deleteSuccess"/>');
            fn_loadList(currentPage);
        });
    }

    /* 예약 취소 */
    function fn_rsrvCncl(msgId) {
        if (!confirm('<spring:message code="msg.shrtnt.msg.confirmRsrvCncl"/>')) return;
        ajaxCall('/msgShrtntRsrvCnclAjax.do', { msgId: msgId }, function(res) {
            if (res.result > 0) {
                alert('<spring:message code="msg.shrtnt.msg.rsrvCnclSuccess"/>');
                fn_loadList(currentPage);
            } else {
                alert(res.message || '<spring:message code="fail.common.update"/>');
            }
        });
    }
</script>

<c:set var="isAdmin" value="${userCtx.admin}"/>

<body class="${isAdmin ? 'admin' : 'home colorA'}">
    <div id="wrap" class="main">
        <!-- common header -->
        <c:choose>
            <c:when test="${isAdmin}">
                <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
            </c:otherwise>
        </c:choose>

        <main class="common">

            <!-- gnb -->
            <c:choose>
                <c:when test="${isAdmin}">
                    <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
                </c:when>
                <c:otherwise>
                    <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
                </c:otherwise>
            </c:choose>

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="${isAdmin ? 'admin_sub' : 'dashboard_sub'}">

                    <div class="sub-content">
                        <!-- page info -->
                        <div class="page-info">
                            <c:choose>
                                <c:when test="${isAdmin}">
                                    <h2 class="page-title"><spring:message code="msg.shrtnt.label.title" text="쪽지"/></h2>
                                </c:when>
                                <c:otherwise>
                                    <h2 class="page-title"><span><spring:message code="msg.shrtnt.label.msgBox" text="메시지함"/></span><spring:message code="msg.shrtnt.label.title" text="쪽지"/></h2>
                                    <div class="navi_bar">
                                        <ul>
                                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                            <li><spring:message code="msg.shrtnt.label.msgBox" text="메시지함"/></li>
                                            <li><span class="current"><spring:message code="msg.shrtnt.label.title" text="쪽지"/></span></li>
                                        </ul>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.yearSmstr" text="학사년도/학기"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSbjctYr">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                    </select>
                                    <select class="form-select" id="selectSbjctSmstr">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.course" text="운영과목"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDept">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과 전체"/></option>
                                    </select>
                                    <select class="form-select wide" id="selectSbjct">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.sndngDate" text="발신 일시"/></label></span>
                                <div class="itemList">
                                    <div class="date_area">
                                        <input type="text" placeholder="시작일" id="sndngSdate" name="sndngSdate" class="datepicker" toDate="sndngEdate">
                                        <span class="txt-sort">~</span>
                                        <input type="text" placeholder="종료일" id="sndngEdate" name="sndngEdate" class="datepicker" fromDate="sndngSdate">
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.shrtnt.label.searchCond" text="검색 조건"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearchType">
                                        <option value="sndngnm"><spring:message code="msg.shrtnt.label.searchSndngnm" text="발신자"/></option>
                                        <option value="sndngrPhnno"><spring:message code="msg.shrtnt.label.searchSndngrPhnno" text="발신자번호"/></option>
                                        <option value="ttl"><spring:message code="msg.shrtnt.label.searchTtl" text="제목"/></option>
                                        <option value="cts"><spring:message code="msg.shrtnt.label.searchCts" text="내용"/></option>
                                    </select>
                                    <input class="form-control wide" type="text" id="inputSearchText" value="" placeholder="<spring:message code="msg.shrtnt.label.searchPlaceholder" text="검색어입력"/>">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="fn_search()"><spring:message code="msg.sndrDsctn.label.search" text="검색"/></button>
                            </div>
                        </div>
                        <!-- //search typeA -->

                        <!-- 목록 -->
                        <div class="board_top">
                            <div class="right-area">
                                <div class="tab_btn">
                                    <a href="#0" class="current" data-tab="RCVN"><spring:message code="msg.shrtnt.label.rcvnTab" text="수신목록"/></a>
                                    <a href="#0" data-tab="SNDNG"><spring:message code="msg.shrtnt.label.sndngTab" text="발신목록"/></a>
                                </div>
                                <button type="button" class="btn basic icon" aria-label="새로고침" onclick="fn_search()"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic" onclick="fn_deleteSelected()"><spring:message code="msg.shrtnt.label.delete" text="삭제"/></button>
                                <button type="button" class="btn type2" onclick="fn_sndngRegist()"><spring:message code="msg.shrtnt.label.sndngRegist" text="발신하기"/></button>
                                <uiex:listScale func="fn_changeListScale" value="10" />
                            </div>
                        </div>

                        <!-- 쪽지 그리드 -->
                        <div id="shrtntList"></div>

                        <!-- 쪽지 카드 폼 -->
                        <div id="shrtntList_cardForm" style="display:none"></div>

                        <!-- 수신 카드 폼 -->
                        <div id="rcvnCardForm" style="display:none">
                            <div class="card-header">
                                #[sndngnm]
                                <div class="card-title">#[cts]</div>
                            </div>
                            <div class="card-body">
                                <div class="desc">
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.sndngDttm' text='발신일시'/></label><strong>#[sndngDttm]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.sbjctnm' text='운영과목'/></label><strong>#[sbjctnm]</strong></p>
                                </div>
                                <div class="etc">
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.readYn' text='읽음'/></label><strong>#[readYn]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.fileCnt' text='파일'/></label><strong>#[fileCnt]</strong></p>
                                </div>
                            </div>
                        </div>

                        <!-- 발신 카드 폼 -->
                        <div id="sndngCardForm" style="display:none">
                            <div class="card-header">
                                #[sndngnm]
                                <div class="card-title">#[ttl]</div>
                            </div>
                            <div class="card-body">
                                <div class="desc">
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.sndngDttm' text='발신일시'/></label><strong>#[sndngDttm]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.sbjctnm' text='운영과목'/></label><strong>#[sbjctnm]</strong></p>
                                </div>
                                <div class="etc">
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.rcvrCnt' text='수신자'/></label><strong>#[rcvrCnt]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.shrtnt.col.sndngYn' text='발신'/></label><strong>#[sndngYn]</strong></p>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
            <!-- //content -->

            <!-- common footer (prof only) -->
            <c:if test="${not isAdmin}">
                <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            </c:if>

        </main>

    </div>

</body>
</html>
