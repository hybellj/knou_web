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
    let currentPage = 1;
    let listScale = ${pageSize};
    let totalCnt = 0;
    let activeTab = new URLSearchParams(location.search).get('tab') === 'SNDNG' ? 'SNDNG' : 'RCVN';
    let shrtntTable;

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

        $('#selectOrg').on('change', function() {
            fn_loadDeptList();
            fn_loadSbjctList();
        });

        $('#selectDept').on('change', function() {
            fn_loadSbjctList();
        });

        /* 셀렉트박스 초기 로딩 */
        fn_loadOrgList();
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
        }, function() {});
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
        }, function() {});
    }

    /* 기관 목록 조회 */
    function fn_loadOrgList() {
        ajaxCall('/msgShrtntOrgListAjax.do', {}, function(res) {
            let $sel = $('#selectOrg');
            $sel.find('option:gt(0)').remove();
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.orgId + '">' + UiComm.escapeHtml(v.orgnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        }, function() {});
    }

    /* 학과 목록 조회 */
    function fn_loadDeptList() {
        let $sel = $('#selectDept');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        let data = {
            orgId: $('#selectOrg').val()
        };

        ajaxCall('/msgShrtntDeptListAjax.do', data, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.deptId + '">' + UiComm.escapeHtml(v.deptnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        }, function() {});
    }

    /* 운영과목 목록 조회 */
    function fn_loadSbjctList() {
        let $sel = $('#selectSbjct');
        $sel.find('option:gt(0)').remove();
        $sel.trigger('chosen:updated');

        let data = {
            orgId: $('#selectOrg').val(),
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
        }, function() {});
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
                sndngDttm: UiComm.formatDate(v.sndngDttm, 'datetime2'),
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
                ? '<span class="txt-blue">' + UiComm.formatDate(v.efctvSndngDttm, 'datetime2') + '</span>'
                : UiComm.formatDate(v.efctvSndngDttm, 'datetime2');
            let rsrvCnclDttmHtml = v.rsrvSndngCnclDttm
                ? '<span class="txt-red">' + UiComm.formatDate(v.rsrvSndngCnclDttm, 'datetime2') + '</span>'
                : '-';
            let rsrvCnclHtml = (v.rsrvYn === 'Y' && !v.rsrvSndngCnclDttm)
                ? '<button class="btn basic small" onclick="fn_openRsrvCnclPopup(\'' + v.msgId + '\', \'' + UiComm.escapeHtml(v.ttl || '') + '\', \'' + UiComm.formatDate(v.efctvSndngDttm, 'datetime2') + '\', ' + (v.rcvrCnt || 0) + ')"><spring:message code="msg.shrtnt.label.rsrvCncl" text="예약취소"/></button>'
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
            orgId: $('#selectOrg').val(),
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
        location.href = '/mngrMsgShrtntRcvnDetail.do?msgShrtntSndngId=' + msgShrtntSndngId;
    }

    /* 발신 상세 이동 */
    function fn_sndngDetail(msgId) {
        location.href = '/mngrMsgShrtntSndngDetail.do?msgId=' + msgId;
    }

    /* 발신하기 이동 */
    function fn_sndngRegist() {
        location.href = '/mngrMsgShrtntSndngRegistView.do';
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
            return new Promise(function(resolve, reject) {
                ajaxCall('/msgShrtntDeleteAjax.do', param, function(res) { resolve(res); }, function() { resolve({ result: -1 }); });
            });
        });

        Promise.all(deletePromises).then(function(results) {
            let failCnt = results.filter(function(r) { return r.result !== 1; }).length;
            if (failCnt > 0) {
                alert('<spring:message code="fail.common.delete"/>');
            } else {
                alert('<spring:message code="msg.shrtnt.msg.deleteSuccess"/>');
            }
            fn_loadList(currentPage);
        });
    }

    /* 예약 취소 팝업 열기 */
    function fn_openRsrvCnclPopup(msgId, ttl, rsrvDttm, rcvrCnt) {
        $('#rsrvCnclMsgId').val(msgId);
        $('#rsrvCnclTtl').text(ttl);
        $('#rsrvCnclDttm').text(rsrvDttm);
        $('#rsrvCnclRcvrCnt').text(rcvrCnt);
        $('#rsrvCnclUser').text('${fn:escapeXml(usernm)}');
        $('#rsrvCnclNowDttm').text(UiComm.formatDate(new Date().toISOString().replace(/[-T:\.Z]/g, '').substring(0, 14), 'datetime2'));
        $('#rsrvCnclModal').addClass('active').attr('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }

    /* 예약 취소 팝업 닫기 */
    function fn_closeRsrvCnclPopup() {
        $('#rsrvCnclModal').removeClass('active').attr('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    /* 예약 취소 실행 */
    function fn_doRsrvCncl() {
        let msgId = $('#rsrvCnclMsgId').val();
        ajaxCall('/msgShrtntRsrvCnclAjax.do', { msgId: msgId }, function(res) {
            if (res.result > 0) {
                fn_closeRsrvCnclPopup();
                alert('<spring:message code="msg.shrtnt.msg.rsrvCnclSuccess"/>');
                fn_loadList(currentPage);
            } else {
                alert(res.message || '<spring:message code="fail.common.update"/>');
            }
        }, function() { UiComm.showLoading(false); });
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <!-- admin -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">

                <div class="sub-content">
                    <!-- page info -->
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="msg.shrtnt.label.title" text="쪽지"/></h2>
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
                                <select class="form-select" id="selectOrg">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.orgAll" text="기관 전체"/></option>
                                </select>
                                <select class="form-select wide" id="selectDept" style="width: 200px;">
                                    <option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과 전체"/></option>
                                </select>
                                <select class="form-select wide" id="selectSbjct" style="width: 200px;">
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
                            <span class="list-card-button"></span>
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

    </main>
    <!-- //admin -->
</div>

<!-- 발신 예약 취소 팝업 -->
<div class="modal-overlay" id="rsrvCnclModal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="modal-content modal-md" tabindex="-1">
        <div class="modal-header">
            <h2><spring:message code="msg.shrtnt.label.rsrvCnclTitle" text="발신 예약 취소"/></h2>
            <button class="modal-close" aria-label="닫기" onclick="fn_closeRsrvCnclPopup()"><i class="icon-svg-close"></i></button>
        </div>
        <div class="modal-body">
            <div class="msg-box">
                <p class="txt">
                    <i class="icon-svg-warning" aria-hidden="true"></i>
                    <span><spring:message code="msg.shrtnt.msg.rsrvCnclWarn"/></span>
                </p>
            </div>
            <input type="hidden" id="rsrvCnclMsgId">
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.shrtnt.label.ttl" text="제목"/></label></li>
                    <li id="rsrvCnclTtl"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.shrtnt.label.rsrvSndngDttm" text="발신예약일시"/></label></li>
                    <li id="rsrvCnclDttm"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.shrtnt.label.rcvrCnt" text="수신자"/></label></li>
                    <li id="rsrvCnclRcvrCnt"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.shrtnt.label.rsrvCnclUser" text="예약취소자"/></label></li>
                    <li id="rsrvCnclUser"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.shrtnt.label.rsrvCnclDttm" text="예약취소일시"/></label></li>
                    <li id="rsrvCnclNowDttm"></li>
                </ul>
            </div>
            <div class="modal_btns">
                <button type="button" class="btn type1" onclick="fn_doRsrvCncl()"><spring:message code="msg.shrtnt.label.rsrvCnclBtn" text="취소하기"/></button>
                <button type="button" class="btn type2" onclick="fn_closeRsrvCnclPopup()"><spring:message code="msg.shrtnt.label.closeBtn" text="닫기"/></button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
