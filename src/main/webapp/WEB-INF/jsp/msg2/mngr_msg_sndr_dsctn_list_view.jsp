<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
<script type="text/javascript">
    let currentPage = 1;
    let listScale = ${pageSize};
    let totalCnt = 0;
    let sndrDsctnTable;
    let MSG_SUFFIX_YEAR = '<spring:message code="msg.sndrDsctn.label.year" text="년"/>';
    let MSG_SUFFIX_SMSTR = '<spring:message code="msg.sndrDsctn.label.smstr" text="학기"/>';
    let MSG_SUFFIX_WON = '<spring:message code="msg.sndrDsctn.label.unitWon" text="원"/>';
    let costMap = {};

    let SNDNG_GBN_MAP = {
        'PUSH': 'PUSH',
        'SHRTNT': '<spring:message code="msg.title.msg.shrtnt"/>',
        'EML': '<spring:message code="msg.title.msg.eml"/>',
        'ALIM_TALK': '<spring:message code="msg.title.msg.alimTalk"/>',
        'SMS': 'SMS',
        'LMS': 'LMS',
        'RSRV': '<spring:message code="msg.sndrDsctn.label.rsrv"/>'
    };

    let SNDNG_STS_MAP = {
        'SUCCESS': '<spring:message code="msg.sndrDsctn.label.success"/>',
        'FAIL': '<spring:message code="msg.sndrDsctn.label.fail"/>',
        'READY': '<spring:message code="msg.sndrDsctn.label.ready"/>',
        'SENDING': '<spring:message code="msg.sndrDsctn.label.sending"/>'
    };

    $(document).ready(function() {

        /* 발신구분 전체 체크 */
        $('#chkSndngAll').on('change', function() {
            $('input[name=sndngGbncds]').prop('checked', $(this).is(':checked'));
        });
        $('input[name=sndngGbncds]').on('change', function() {
            if ($('#chkSndngAll').is(':checked')) {
                $('#chkSndngAll').prop('checked', false);
                $('input[name=sndngGbncds]').prop('checked', true);
                $(this).prop('checked', false);
            } else {
                let total = $('input[name=sndngGbncds]').length;
                let checked = $('input[name=sndngGbncds]:checked').length;
                $('#chkSndngAll').prop('checked', total === checked);
            }
        });

        /* 결과구분 전체 체크 */
        $('#chkRsltAll').on('change', function() {
            $('input[name=rsltGbncds]').prop('checked', $(this).is(':checked'));
        });
        $('input[name=rsltGbncds]').on('change', function() {
            if ($('#chkRsltAll').is(':checked')) {
                $('#chkRsltAll').prop('checked', false);
                $('input[name=rsltGbncds]').prop('checked', true);
                $(this).prop('checked', false);
            } else {
                let total = $('input[name=rsltGbncds]').length;
                let checked = $('input[name=rsltGbncds]:checked').length;
                $('#chkRsltAll').prop('checked', total === checked);
            }
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

        /* 초기 리스트/요약 조회 */
        fn_search();
    });

    /* 학사년도 목록 조회 */
    function fn_loadYrList() {
        ajaxCall('/msgSndrDsctnYrListAjax.do', {}, function(res) {
            let $sel = $('#selectSbjctYr');
            $sel.find('option:gt(0)').remove();
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + UiComm.escapeHtml(v.sbjctYr) + '">' + UiComm.escapeHtml(v.sbjctYr) + MSG_SUFFIX_YEAR + '</option>');
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

        ajaxCall('/msgSndrDsctnSmstrListAjax.do', { sbjctYr: sbjctYr }, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + UiComm.escapeHtml(v.sbjctSmstr) + '">' + UiComm.escapeHtml(v.sbjctSmstr) + MSG_SUFFIX_SMSTR + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        }, function() {});
    }

    /* 학과 목록 조회 */
    function fn_loadDeptList() {
        ajaxCall('/msgSndrDsctnDeptListAjax.do', {}, function(res) {
            let $sel = $('#selectDept');
            $sel.find('option:gt(0)').remove();
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.deptId + '">' + UiComm.escapeHtml(v.deptnm) + '</option>');
                });
                if (res.returnList.length > 0 && res.returnList[0].orgnm) {
                    $('#selectOrg option:first').text(UiComm.escapeHtml(res.returnList[0].orgnm));
                }
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
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            deptId: $('#selectDept').val()
        };

        ajaxCall('/msgSndrDsctnSbjctListAjax.do', data, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        }, function() {});
    }

    /* 검색 */
    function fn_search() {
        fn_loadList(1);
        fn_loadSmry();
    }

    /* 목록 조회 */
    function fn_loadList(pageIndex) {
        if (pageIndex) currentPage = pageIndex;

        let param = fn_getSearchParam();
        param.pageIndex = currentPage;
        param.listScale = listScale;

        ajaxCall('/msgSndrDsctnListAjax.do', param, function(res) {
            if (res.result > 0) {
                let dataList = fn_createListData(res.returnList, res.pageInfo);
                sndrDsctnTable.clearData();
                sndrDsctnTable.replaceData(dataList);
                sndrDsctnTable.setPageInfo(res.pageInfo);
                totalCnt = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#totalCntText').text(totalCnt);
            } else {
                alert(res.message || '<spring:message code="fail.common.select"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 목록 데이터 생성 */
    function fn_createListData(list, pageInfo) {
        let dataList = [];
        if (!list || list.length === 0) return dataList;

        let total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            let rnum = total - ((currentPage - 1) * listScale) - i;
            let gbnNm = SNDNG_GBN_MAP[v.sndngGbncd] || v.sndngGbncd || '';
            let stsNm = SNDNG_STS_MAP[v.sndngRsltCd] || '';
            let rsltHtml = v.sndngRsltCd === 'FAIL' ? '<span class="txt-red">' + UiComm.escapeHtml(stsNm) + '</span>' : UiComm.escapeHtml(stsNm);

            dataList.push({
                no: rnum,
                sndngGbncd: UiComm.escapeHtml(gbnNm),
                sbjctYr: UiComm.escapeHtml(v.sbjctYr || ''),
                sbjctSmstr: UiComm.escapeHtml(v.sbjctSmstr || ''),
                orgnm: UiComm.escapeHtml(v.orgnm || ''),
                deptnm: UiComm.escapeHtml(v.deptnm || ''),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || ''),
                dvclasNo: UiComm.escapeHtml(v.dvclasNo || ''),
                rcvrnm: UiComm.escapeHtml(v.rcvrnm || ''),
                rcvrTelno: UiComm.escapeHtml(v.rcvrTelno || ''),
                sndngDttm: UiComm.formatDate(v.sndngDttm, 'datetime2'),
                sndngYn: UiComm.escapeHtml(v.sndngYn || ''),
                rslt: rsltHtml,
                cost: (v.sndngYn === 'Y') ? (costMap[v.sndngGbncd] || 0) : 0,
                msgId: UiComm.escapeHtml(v.msgId || '')
            });
        });
        return dataList;
    }

    /* 요약 조회 */
    function fn_loadSmry() {
        let param = fn_getSearchParam();

        ajaxCall('/msgSndrDsctnSmryAjax.do', param, function(res) {
            if (res.result > 0 && res.returnVO) {
                if (res.returnSubVO) {
                    costMap = res.returnSubVO;
                }
                fn_renderSmry(res.returnVO);
            }
        }, function() {});
    }

    /* 검색 파라미터 수집 */
    function fn_getSearchParam() {
        let sndngGbncds = [];
        $('input[name=sndngGbncds]:checked').each(function() {
            sndngGbncds.push($(this).val());
        });

        let rsltGbncds = [];
        $('input[name=rsltGbncds]:checked').each(function() {
            rsltGbncds.push($(this).val());
        });

        return {
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            deptId: $('#selectDept').val(),
            sbjctId: $('#selectSbjct').val(),
            sndngSdttm: $('#sndngSdate').val(),
            sndngEdttm: $('#sndngEdate').val(),
            searchType: $('#selectSearchType').val(),
            searchText: $('#inputSearchText').val(),
            sndngGbncds: sndngGbncds,
            rsltGbncd: rsltGbncds.length === 1 ? rsltGbncds[0] : ''
        };
    }

    /* 리스트 스케일 변경 */
    function fn_changeListScale(scale) {
        listScale = scale;
        fn_loadList(1);
    }

    /* 요약 렌더링 */
    function fn_renderSmry(s) {
        $('#pushTotalCnt').text(s.pushTotalCnt || 0);
        $('#pushSuccCnt').text(s.pushSuccCnt || 0);
        $('#pushFailCnt').text(s.pushFailCnt || 0);
        $('#shrtntTotalCnt').text(s.shrtntTotalCnt || 0);
        $('#shrtntSuccCnt').text(s.shrtntSuccCnt || 0);
        $('#shrtntFailCnt').text(s.shrtntFailCnt || 0);
        $('#emlTotalCnt').text(s.emlTotalCnt || 0);
        $('#emlSuccCnt').text(s.emlSuccCnt || 0);
        $('#emlFailCnt').text(s.emlFailCnt || 0);
        $('#alimtalkTotalCnt').text(s.alimtalkTotalCnt || 0);
        $('#alimtalkSuccCnt').text(s.alimtalkSuccCnt || 0);
        $('#alimtalkFailCnt').text(s.alimtalkFailCnt || 0);
        $('#smsTotalCnt').text(s.smsTotalCnt || 0);
        $('#smsSuccCnt').text(s.smsSuccCnt || 0);
        $('#smsFailCnt').text(s.smsFailCnt || 0);
        $('#lmsTotalCnt').text(s.lmsTotalCnt || 0);
        $('#lmsSuccCnt').text(s.lmsSuccCnt || 0);
        $('#lmsFailCnt').text(s.lmsFailCnt || 0);
        $('#mmsTotalCnt').text(s.mmsTotalCnt || 0);
        $('#mmsSuccCnt').text(s.mmsSuccCnt || 0);
        $('#mmsFailCnt').text(s.mmsFailCnt || 0);

        /* 발신 비용 계산 (성공 건수 × 단가) */
        let pushCost     = (s.pushSuccCnt || 0)     * (costMap['PUSH'] || 0);
        let shrtntCost   = (s.shrtntSuccCnt || 0)   * (costMap['SHRTNT'] || 0);
        let emlCost      = (s.emlSuccCnt || 0)       * (costMap['EML'] || 0);
        let alimtalkCost = (s.alimtalkSuccCnt || 0)  * (costMap['ALIM_TALK'] || 0);
        let smsCost      = (s.smsSuccCnt || 0)       * (costMap['SMS'] || 0);
        let lmsCost      = (s.lmsSuccCnt || 0)       * (costMap['LMS'] || 0);
        let mmsCost      = (s.mmsSuccCnt || 0)       * (costMap['MMS'] || 0);

        $('#pushCost').text(pushCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#shrtntCost').text(shrtntCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#emlCost').text(emlCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#alimtalkCost').text(alimtalkCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#smsCost').text(smsCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#lmsCost').text(lmsCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#mmsCost').text(mmsCost.toLocaleString() + MSG_SUFFIX_WON);

        let totalCostVal = pushCost + shrtntCost + emlCost + alimtalkCost + smsCost + lmsCost + mmsCost;
        $('#totalCost').text(totalCostVal.toLocaleString() + MSG_SUFFIX_WON);
    }

    /* 발송내역 엑셀 다운로드 */
    function fn_excelDown() {
        let excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.no" text="번호"/>', name: 'rnum', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sndngGbn" text="발신구분"/>', name: 'sndngGbncd', align: 'center', width: '3000', codes: {'PUSH':'PUSH', 'SHRTNT':'<spring:message code="msg.title.msg.shrtnt"/>', 'EML':'<spring:message code="msg.title.msg.eml"/>', 'ALIM_TALK':'<spring:message code="msg.title.msg.alimTalk"/>', 'SMS':'SMS', 'LMS':'LMS', 'RSRV':'<spring:message code="msg.sndrDsctn.label.rsrv"/>'}});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.year" text="년도"/>', name: 'sbjctYr', align: 'center', width: '2500'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.smstr" text="학기"/>', name: 'sbjctSmstr', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.org" text="기관"/>', name: 'orgnm', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.dept" text="학과"/>', name: 'deptnm', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sbjct" text="운영과목"/>', name: 'sbjctnm', align: 'left', width: '7000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.dvclas" text="분반"/>', name: 'dvclasNo', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.rcvr" text="수신자"/>', name: 'rcvrnm', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.rcvrTelno" text="수신자번호"/>', name: 'rcvrTelno', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sndngDttm" text="발신일시"/>', name: 'sndngDttm', align: 'center', width: '5000', formatter: 'date'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sndngYn" text="발송"/>', name: 'sndngYn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.rslt" text="결과"/>', name: 'sndngRsltCd', align: 'center', width: '2500', codes: {'SUCCESS':'<spring:message code="msg.sndrDsctn.label.success"/>', 'FAIL':'<spring:message code="msg.sndrDsctn.label.fail"/>', 'READY':'<spring:message code="msg.sndrDsctn.label.ready"/>', 'SENDING':'<spring:message code="msg.sndrDsctn.label.sending"/>'}});

        let param = fn_getSearchParam();
        let form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgSndrDsctnExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'sbjctYr', value: param.sbjctYr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctSmstr', value: param.sbjctSmstr }));
        form.append($('<input/>', { type: 'hidden', name: 'deptId', value: param.deptId }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctId', value: param.sbjctId }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngSdttm', value: param.sndngSdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngEdttm', value: param.sndngEdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'searchType', value: param.searchType }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: param.searchText }));
        if (param.sndngGbncds) {
            param.sndngGbncds.forEach(function(v) {
                form.append($('<input/>', { type: 'hidden', name: 'sndngGbncds', value: v }));
            });
        }
        form.append($('<input/>', { type: 'hidden', name: 'rsltGbncd', value: param.rsltGbncd }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }

    /* 발송비용금액 엑셀 다운로드 */
    function fn_smryExcelDown() {
        let totalCostText = $('#totalCost').text();

        let excelGrid = {
            footerRow: 'true',
            footerRowColspan: [{firstCol: 0, lastCol: 7}],
            colModel: []
        };
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.label.sndngType" text="발신구분"/>', name: 'sndngGbn', align: 'center', width: '5000', footer: {prefix: '<spring:message code="msg.sndrDsctn.label.totalSndCost" text="총 발신 비용"/> : ' + totalCostText, suffix: '', type: '', align: 'center'}});
        excelGrid.colModel.push({label: 'PUSH', name: 'push', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.shrtnt"/>', name: 'shrtnt', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.eml"/>', name: 'eml', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.title.msg.alimTalk"/>', name: 'alimTalk', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: 'SMS', name: 'sms', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: 'LMS', name: 'lms', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: 'MMS', name: 'mms', align: 'center', width: '3000'});

        let param = fn_getSearchParam();
        let form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgSndrDsctnSmryExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'sbjctYr', value: param.sbjctYr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctSmstr', value: param.sbjctSmstr }));
        form.append($('<input/>', { type: 'hidden', name: 'deptId', value: param.deptId }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctId', value: param.sbjctId }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngSdttm', value: param.sndngSdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngEdttm', value: param.sndngEdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'searchType', value: param.searchType }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: param.searchText }));
        if (param.sndngGbncds) {
            param.sndngGbncds.forEach(function(v) {
                form.append($('<input/>', { type: 'hidden', name: 'sndngGbncds', value: v }));
            });
        }
        form.append($('<input/>', { type: 'hidden', name: 'rsltGbncd', value: param.rsltGbncd }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }
</script>
</head>

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
                            <h2 class="page-title"><spring:message code="msg.sndrDsctn.label.title" text="발송내역관리"/></h2>
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
                                        <option value="${orgId}"><c:out value="${not empty orgnm ? orgnm : orgId}"/></option>
                                    </select>
                                    <select class="form-select" id="selectDept">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과 전체"/></option>
                                        <!-- AJAX 동적 로딩 -->
                                    </select>
                                    <select class="form-select wide" id="selectSbjct">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                        <!-- AJAX 동적 로딩 -->
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
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.searchCond" text="검색 조건"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearchType">
                                        <option value="rcvr"><spring:message code="msg.sndrDsctn.label.receiver" text="수신자"/></option>
                                    </select>
                                    <input class="form-control wide" type="text" id="inputSearchText" value="" placeholder="<spring:message code="msg.sndrDsctn.label.searchPlaceholder" text="검색어입력"/>">
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.sndngType" text="발신 구분"/></label></span>
                                <div class="itemList">
                                    <span class="custom-input"><input type="checkbox" id="chkSndngAll" checked><label for="chkSndngAll"><spring:message code="msg.sndrDsctn.label.all" text="전체"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="PUSH" id="chkPush" checked><label for="chkPush">PUSH</label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="SHRTNT" id="chkShrtnt" checked><label for="chkShrtnt"><spring:message code="msg.title.msg.shrtnt"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="EML" id="chkEml" checked><label for="chkEml"><spring:message code="msg.title.msg.eml"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="ALIM_TALK" id="chkAlimtalk" checked><label for="chkAlimtalk"><spring:message code="msg.title.msg.alimTalk"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="SMS" id="chkSms" checked><label for="chkSms"><spring:message code="msg.title.msg.sms"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="LMS" id="chkLms" checked><label for="chkLms">LMS</label></span>
                                    <span class="custom-input"><input type="checkbox" name="sndngGbncds" value="MMS" id="chkMms" checked><label for="chkMms">MMS</label></span>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.rsltType" text="결과 구분"/></label></span>
                                <div class="itemList">
                                    <span class="custom-input"><input type="checkbox" id="chkRsltAll" checked><label for="chkRsltAll"><spring:message code="msg.sndrDsctn.label.all" text="전체"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="rsltGbncds" value="SUCCESS" id="chkSuccess" checked><label for="chkSuccess"><spring:message code="msg.sndrDsctn.label.success" text="성공"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="rsltGbncds" value="FAIL" id="chkFail" checked><label for="chkFail"><spring:message code="msg.sndrDsctn.label.fail" text="실패"/></label></span>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="fn_search()"><spring:message code="msg.sndrDsctn.label.search" text="검색"/></button>
                            </div>
                        </div>
                        <!-- //search typeA -->

                        <!-- 발송내역 -->
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="msg.sndrDsctn.label.listTitle" text="발송내역"/> [ <spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b id="totalCntText">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_excelDown()"><spring:message code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                                <span class="list-card-button"></span>
                                <uiex:listScale func="fn_changeListScale" value="10" />
                            </div>
                        </div>

                        <!-- 발송내역 그리드 -->
                        <div id="sndrDsctnList"></div>

                        <!-- 발송내역 카드 폼 -->
                        <div id="sndrDsctnList_cardForm" style="display:none">
                            <div class="card-header">
                                #[sndngGbncd]
                                <div class="card-title">#[rcvrnm]</div>
                            </div>
                            <div class="card-body">
                                <div class="desc">
                                    <p><label class="label-title"><spring:message code='msg.sndrDsctn.col.sndngDttm' text='발신일시'/></label><strong>#[sndngDttm]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.sndrDsctn.col.sbjct' text='운영과목'/></label><strong>#[sbjctnm]</strong></p>
                                </div>
                                <div class="etc">
                                    <p><label class="label-title"><spring:message code='msg.sndrDsctn.col.sndngYn' text='발송'/></label><strong>#[sndngYn]</strong></p>
                                    <p><label class="label-title"><spring:message code='msg.sndrDsctn.col.rslt' text='결과'/></label><strong>#[rslt]</strong></p>
                                </div>
                            </div>
                        </div>

                        <script>
                        sndrDsctnTable = UiTable("sndrDsctnList", {
                            lang: "ko",
                            pageFunc: fn_loadList,
                            columns: [
                                {title:"<spring:message code='msg.sndrDsctn.col.no' text='번호'/>",         field:"no",         headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.sndngGbn' text='발신구분'/>", field:"sndngGbncd", headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:60},
                                {title:"<spring:message code='msg.sndrDsctn.col.year' text='년도'/>",        field:"sbjctYr",    headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                                {title:"<spring:message code='msg.sndrDsctn.col.smstr' text='학기'/>",       field:"sbjctSmstr", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.org' text='기관'/>",         field:"orgnm",      headerHozAlign:"center", hozAlign:"center", width:150,  minWidth:60},
                                {title:"<spring:message code='msg.sndrDsctn.col.dept' text='학과'/>",        field:"deptnm",     headerHozAlign:"center", hozAlign:"center", width:150,  minWidth:60},
                                {title:"<spring:message code='msg.sndrDsctn.col.sbjct' text='운영과목'/>",    field:"sbjctnm",    headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:120},
                                {title:"<spring:message code='msg.sndrDsctn.col.dvclas' text='분반'/>",      field:"dvclasNo",   headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.rcvr' text='수신자'/>",      field:"rcvrnm",     headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:60},
                                {title:"<spring:message code='msg.sndrDsctn.col.rcvrTelno' text='수신자번호'/>", field:"rcvrTelno", headerHozAlign:"center", hozAlign:"center", width:110, minWidth:90},
                                {title:"<spring:message code='msg.sndrDsctn.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",  headerHozAlign:"center", hozAlign:"center", width:130, minWidth:100, formatter:"date"},
                                {title:"<spring:message code='msg.sndrDsctn.col.sndngYn' text='발송'/>",     field:"sndngYn",    headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.rslt' text='결과'/>",        field:"rslt",       headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50},
                                {title:"<spring:message code='msg.sndrDsctn.col.cost' text='비용(원)'/>",    field:"cost",       headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:50}
                            ]
                        });
                        </script>

                        <!-- 발송비용금액 -->
                        <div class="board_top" style="margin-top:30px;">
                            <h3 class="board-title"><spring:message code="msg.sndrDsctn.label.costTitle" text="발송비용금액"/></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_smryExcelDown()"><spring:message code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:14%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2"><spring:message code="msg.sndrDsctn.label.sndngType" text="발신구분"/></th>
                                        <th rowspan="2">PUSH</th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.shrtnt"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.eml"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.alimTalk"/></th>
                                        <th colspan="3"><spring:message code="msg.sndrDsctn.label.sms" text="문자"/></th>
                                    </tr>
                                    <tr>
                                        <th>SMS</th>
                                        <th>LMS</th>
                                        <th>MMS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalSndCnt" text="총 발신 건수"/></td>
                                        <td id="pushTotalCnt">0</td>
                                        <td id="shrtntTotalCnt">0</td>
                                        <td id="emlTotalCnt">0</td>
                                        <td id="alimtalkTotalCnt">0</td>
                                        <td id="smsTotalCnt">0</td>
                                        <td id="lmsTotalCnt">0</td>
                                        <td id="mmsTotalCnt">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalSuccCnt" text="총 성공 건수"/></td>
                                        <td id="pushSuccCnt">0</td>
                                        <td id="shrtntSuccCnt">0</td>
                                        <td id="emlSuccCnt">0</td>
                                        <td id="alimtalkSuccCnt">0</td>
                                        <td id="smsSuccCnt">0</td>
                                        <td id="lmsSuccCnt">0</td>
                                        <td id="mmsSuccCnt">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalFailCnt" text="총 실패 건수"/></td>
                                        <td id="pushFailCnt" class="txt-red">0</td>
                                        <td id="shrtntFailCnt" class="txt-red">0</td>
                                        <td id="emlFailCnt" class="txt-red">0</td>
                                        <td id="alimtalkFailCnt" class="txt-red">0</td>
                                        <td id="smsFailCnt" class="txt-red">0</td>
                                        <td id="lmsFailCnt" class="txt-red">0</td>
                                        <td id="mmsFailCnt" class="txt-red">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.sndCost" text="발신 비용"/></td>
                                        <td id="pushCost">0</td>
                                        <td id="shrtntCost">0</td>
                                        <td id="emlCost">0</td>
                                        <td id="alimtalkCost">0</td>
                                        <td id="smsCost">0</td>
                                        <td id="lmsCost">0</td>
                                        <td id="mmsCost">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalSndCost" text="총 발신 비용"/></td>
                                        <td colspan="7" id="totalCost">0</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //발송비용금액 -->

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>

</body>
</html>
