<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
<script type="text/javascript">
    const PAGE_INDEX = '<c:out value="${vo.pageIndex}" />' || 1;
    let LIST_SCALE   = '<c:out value="${vo.listScale}" />';
    let EPARAM       = '<c:out value="${encParams}" />';
    let TOTAL_CNT    = 0;
    let COST_MAP     = {};
    let sndrDsctnTable;

    const MSG_SUFFIX_YEAR  = '<spring:message code="msg.sndrDsctn.label.year" text="년"/>';
    const MSG_SUFFIX_SMSTR = '<spring:message code="msg.sndrDsctn.label.smstr" text="학기"/>';
    const MSG_SUFFIX_WON   = '<spring:message code="msg.sndrDsctn.label.unitWon" text="원"/>';
    const MSG_NO_COST      = '-';
    const COST_CHANNELS    = ['ALIM_TALK', 'SMS', 'LMS'];

    const SNDNG_GBN_MAP = {
        'PUSH': 'PUSH',
        'SHRTNT': '<spring:message code="msg.title.msg.shrtnt"/>',
        'EML': '<spring:message code="msg.title.msg.eml"/>',
        'ALIM_TALK': '<spring:message code="msg.title.msg.alimTalk"/>',
        'SMS': 'SMS',
        'LMS': 'LMS'
    };

    const SNDNG_STS_MAP = {
        'SCS':  '<spring:message code="msg.sndrDsctn.label.success"/>',
        'FAIL': '<spring:message code="msg.sndrDsctn.label.fail"/>',
        'RJCT': '<spring:message code="msg.sndrDsctn.label.rejected"/>',
        'RSRV': '<spring:message code="msg.sndrDsctn.label.rsrv"/>',
        'CNCL': '<spring:message code="msg.sndrDsctn.label.cncl"/>'
    };

    const INIT_SMRY = {
        pushTotalCnt:     ${initSmry.pushTotalCnt},
        pushSuccCnt:      ${initSmry.pushSuccCnt},
        pushFailCnt:      ${initSmry.pushFailCnt},
        shrtntTotalCnt:   ${initSmry.shrtntTotalCnt},
        shrtntSuccCnt:    ${initSmry.shrtntSuccCnt},
        shrtntFailCnt:    ${initSmry.shrtntFailCnt},
        emlTotalCnt:      ${initSmry.emlTotalCnt},
        emlSuccCnt:       ${initSmry.emlSuccCnt},
        emlFailCnt:       ${initSmry.emlFailCnt},
        alimtalkTotalCnt: ${initSmry.alimtalkTotalCnt},
        alimtalkSuccCnt:  ${initSmry.alimtalkSuccCnt},
        alimtalkFailCnt:  ${initSmry.alimtalkFailCnt},
        smsTotalCnt:      ${initSmry.smsTotalCnt},
        smsSuccCnt:       ${initSmry.smsSuccCnt},
        smsFailCnt:       ${initSmry.smsFailCnt},
        lmsTotalCnt:      ${initSmry.lmsTotalCnt},
        lmsSuccCnt:       ${initSmry.lmsSuccCnt},
        lmsFailCnt:       ${initSmry.lmsFailCnt}
    };

    const INIT_COST_MAP = {
        'PUSH':      ${empty initCostMap['PUSH']      ? 0 : initCostMap['PUSH']},
        'SHRTNT':    ${empty initCostMap['SHRTNT']    ? 0 : initCostMap['SHRTNT']},
        'EML':       ${empty initCostMap['EML']       ? 0 : initCostMap['EML']},
        'ALIM_TALK': ${empty initCostMap['ALIM_TALK'] ? 0 : initCostMap['ALIM_TALK']},
        'SMS':       ${empty initCostMap['SMS']       ? 0 : initCostMap['SMS']},
        'LMS':       ${empty initCostMap['LMS']       ? 0 : initCostMap['LMS']}
    };

    $(document).ready(function() {
        fn_initSearch();
        fn_initFilter();
        fn_initCheckAll();
        COST_MAP = INIT_COST_MAP;
        fn_renderSmry(INIT_SMRY);
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

    function fn_initCheckAll() {
        $('#chkSndngAll').on('change', function() {
            $('input[name=sndngGbncds]').prop('checked', $(this).is(':checked'));
        });
        $('input[name=sndngGbncds]').on('change', function() {
            if ($('#chkSndngAll').is(':checked')) {
                $('#chkSndngAll').prop('checked', false);
                $('input[name=sndngGbncds]').prop('checked', true);
                $(this).prop('checked', false);
            } else {
                const total = $('input[name=sndngGbncds]').length;
                const checked = $('input[name=sndngGbncds]:checked').length;
                $('#chkSndngAll').prop('checked', total === checked);
            }
        });

        $('#chkRsltAll').on('change', function() {
            $('input[name=rsltGbncds]').prop('checked', $(this).is(':checked'));
        });
        $('input[name=rsltGbncds]').on('change', function() {
            if ($('#chkRsltAll').is(':checked')) {
                $('#chkRsltAll').prop('checked', false);
                $('input[name=rsltGbncds]').prop('checked', true);
                $(this).prop('checked', false);
            } else {
                const total = $('input[name=rsltGbncds]').length;
                const checked = $('input[name=rsltGbncds]:checked').length;
                $('#chkRsltAll').prop('checked', total === checked);
            }
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
        fn_loadList(1, fn_loadSmry);
    }

    function fn_loadList(pageIndex, callback) {
        const extData = fn_getSearchParam();
        extData.pageIndex = pageIndex;
        extData.listScale = LIST_SCALE;

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/msgSndrDsctnListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createListData(res.returnList, res.pageInfo);
                sndrDsctnTable.clearData();
                sndrDsctnTable.replaceData(dataList);
                sndrDsctnTable.setPageInfo(res.pageInfo);
                TOTAL_CNT = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
            }
            if (typeof callback === 'function') callback();
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            if (typeof callback === 'function') callback();
        }, true);
    }

    function fn_createListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v) {
            const rnum = total - v.lineNo + 1;
            const gbnNm = SNDNG_GBN_MAP[v.sndngGbncd] || v.sndngGbncd || '';
            const stsNm = SNDNG_STS_MAP[v.sndngStscd] || '';
            const isNegative = (v.sndngStscd === 'FAIL' || v.sndngStscd === 'RJCT' || v.sndngStscd === 'CNCL');
            const rsltHtml = isNegative ? '<span class="fcRed">' + UiComm.escapeHtml(stsNm) + '</span>' : UiComm.escapeHtml(stsNm);

            dataList.push({
                no: rnum,
                sndngGbncd: UiComm.escapeHtml(gbnNm),
                sbjctYr: v.sbjctYr || '-',
                sbjctSmstr: v.sbjctSmstr || '-',
                orgnm: UiComm.escapeHtml(v.orgnm || '-'),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || '-'),
                dvclasNo: v.dvclasNo || '',
                rcvrnm: UiComm.escapeHtml(v.rcvrnm || ''),
                rcvrTelno: v.rcvrTelno || '',
                sndngDttm: UiComm.formatDate(v.sndngDttm, 'datetime2'),
                sndngYn: v.sndngYn || '',
                rslt: rsltHtml,
                cost: (COST_CHANNELS.indexOf(v.sndngGbncd) >= 0 && v.sndngYn === 'Y' && (COST_MAP[v.sndngGbncd] || 0) > 0)
                        ? COST_MAP[v.sndngGbncd]
                        : MSG_NO_COST,
                msgId: v.msgId || ''
            });
        });
        return dataList;
    }

    function fn_loadSmry() {
        const extData = fn_getSearchParam();

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/msgSndrDsctnSmrySelectAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnVO) {
                if (res.returnSubVO) {
                    COST_MAP = res.returnSubVO;
                }
                fn_renderSmry(res.returnVO);
            }
        }, function() {});
    }

    function fn_getSearchParam() {
        const sndngGbncds = [];
        $('input[name=sndngGbncds]:checked').each(function() {
            sndngGbncds.push($(this).val());
        });

        const rsltGbncds = [];
        $('input[name=rsltGbncds]:checked').each(function() {
            rsltGbncds.push($(this).val());
        });

        return {
            orgId: $('#selectOrg').val(),
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            sbjctId: $('#selectSbjct').val(),
            sndngSdttm: $('#sndngSdate').val(),
            sndngEdttm: $('#sndngEdate').val(),
            searchType: $('#selectSearchType').val(),
            searchText: $('#inputSearchText').val(),
            sndngGbncdsStr: sndngGbncds.join(','),
            rsltGbncd: rsltGbncds.length === 1 ? rsltGbncds[0] : ''
        };
    }

    function fn_changeListScale(scale) {
        LIST_SCALE = scale;
        fn_loadList(1);
    }

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

        const alimtalkCost = (s.alimtalkSuccCnt || 0)  * (COST_MAP['ALIM_TALK'] || 0);
        const smsCost      = (s.smsSuccCnt || 0)       * (COST_MAP['SMS'] || 0);
        const lmsCost      = (s.lmsSuccCnt || 0)       * (COST_MAP['LMS'] || 0);

        $('#pushCost').text(MSG_NO_COST);
        $('#shrtntCost').text(MSG_NO_COST);
        $('#emlCost').text(MSG_NO_COST);
        $('#alimtalkCost').text(alimtalkCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#smsCost').text(smsCost.toLocaleString() + MSG_SUFFIX_WON);
        $('#lmsCost').text(lmsCost.toLocaleString() + MSG_SUFFIX_WON);

        const totalCostVal = alimtalkCost + smsCost + lmsCost;
        $('#totalCost').text(totalCostVal.toLocaleString() + MSG_SUFFIX_WON);
    }
    function fn_excelDown() {
        const excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.no" text="번호"/>', name: 'rnum', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sndngGbn" text="발신구분"/>', name: 'sndngGbncd', align: 'center', width: '3000', codes: {'PUSH':'PUSH', 'SHRTNT':'<spring:message code="msg.title.msg.shrtnt"/>', 'EML':'<spring:message code="msg.title.msg.eml"/>', 'ALIM_TALK':'<spring:message code="msg.title.msg.alimTalk"/>', 'SMS':'SMS', 'LMS':'LMS'}});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.year" text="년도"/>', name: 'sbjctYr', align: 'center', width: '2500'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.smstr" text="학기"/>', name: 'sbjctSmstr', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.org" text="기관"/>', name: 'orgnm', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sbjct" text="운영과목"/>', name: 'sbjctnm', align: 'left', width: '7000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.dvclas" text="분반"/>', name: 'dvclasNo', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.rcvr" text="수신자"/>', name: 'rcvrnm', align: 'center', width: '3000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.rcvrTelno" text="수신자번호"/>', name: 'rcvrTelno', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sndngDttm" text="발신일시"/>', name: 'sndngDttm', align: 'center', width: '5000', formatter: 'date'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.sndngYn" text="발송"/>', name: 'sndngYn', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.sndrDsctn.col.rslt" text="결과"/>', name: 'sndngStscd', align: 'center', width: '2500', codes: {'SCS':'<spring:message code="msg.sndrDsctn.label.success"/>', 'FAIL':'<spring:message code="msg.sndrDsctn.label.fail"/>', 'RJCT':'<spring:message code="msg.sndrDsctn.label.rejected"/>', 'RSRV':'<spring:message code="msg.sndrDsctn.label.rsrv"/>', 'CNCL':'<spring:message code="msg.sndrDsctn.label.cncl"/>'}})

        const param = fn_getSearchParam();
        const form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgSndrDsctnExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'orgId', value: param.orgId }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctYr', value: param.sbjctYr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctSmstr', value: param.sbjctSmstr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctId', value: param.sbjctId }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngSdttm', value: param.sndngSdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngEdttm', value: param.sndngEdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'searchType', value: param.searchType }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: param.searchText }));
        if (param.sndngGbncdsStr) {
            param.sndngGbncdsStr.split(',').forEach(function(v) {
                if (v) form.append($('<input/>', { type: 'hidden', name: 'sndngGbncds', value: v }));
            });
        }
        form.append($('<input/>', { type: 'hidden', name: 'rsltGbncd', value: param.rsltGbncd }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }

    function fn_smryExcelDown() {
        const totalCostText = $('#totalCost').text();

        const excelGrid = {
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

        const param = fn_getSearchParam();
        const form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgSndrDsctnSmryExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'orgId', value: param.orgId }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctYr', value: param.sbjctYr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctSmstr', value: param.sbjctSmstr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctId', value: param.sbjctId }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngSdttm', value: param.sndngSdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'sndngEdttm', value: param.sndngEdttm }));
        form.append($('<input/>', { type: 'hidden', name: 'searchType', value: param.searchType }));
        form.append($('<input/>', { type: 'hidden', name: 'searchText', value: param.searchText }));
        if (param.sndngGbncdsStr) {
            param.sndngGbncdsStr.split(',').forEach(function(v) {
                if (v) form.append($('<input/>', { type: 'hidden', name: 'sndngGbncds', value: v }));
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
                                            <option value="${yr.sbjctYr}" <c:if test="${yr.sbjctYr eq vo.sbjctYr}">selected</c:if>>${yr.sbjctYr}<spring:message code="msg.sndrDsctn.label.year" text="년"/></option>
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
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.sndngDate" text="발신 일시"/></label></span>
                                <div class="itemList">
                                    <div class="date_area">
                                        <input type="text" placeholder="<spring:message code='msg.sndrDsctn.label.startDate' text='시작일'/>" id="sndngSdate" name="sndngSdate" class="datepicker" toDate="sndngEdate">
                                        <span class="txt-sort">~</span>
                                        <input type="text" placeholder="<spring:message code='msg.sndrDsctn.label.endDate' text='종료일'/>" id="sndngEdate" name="sndngEdate" class="datepicker" fromDate="sndngSdate">
                                    </div>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.searchCond" text="검색 조건"/></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearchType">
                                        <option value="sndr"><spring:message code="msg.sndrDsctn.label.sender" text="발신자"/></option>
                                        <option value="sndrTelno"><spring:message code="msg.sndrDsctn.label.senderTelno" text="발신자번호"/></option>
                                        <option value="ttl"><spring:message code="msg.sndrDsctn.label.ttl" text="제목"/></option>
                                        <option value="cts"><spring:message code="msg.sndrDsctn.label.cts" text="내용"/></option>
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
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.sndrDsctn.label.rsltType" text="결과 구분"/></label></span>
                                <div class="itemList">
                                    <span class="custom-input"><input type="checkbox" id="chkRsltAll" checked><label for="chkRsltAll"><spring:message code="msg.sndrDsctn.label.all" text="전체"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="rsltGbncds" value="SCS" id="chkSuccess" checked><label for="chkSuccess"><spring:message code="msg.sndrDsctn.label.success" text="성공"/></label></span>
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
                            <h3 class="board-title"><spring:message code="msg.sndrDsctn.label.listTitle" text="발송내역"/></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_excelDown()"><spring:message code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                                <span class="list-card-button"></span>
                                <uiex:listScale func="fn_changeListScale" value="${vo.listScale}" />
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
                                {title:"<spring:message code='msg.sndrDsctn.col.smstr' text='학기'/>",       field:"sbjctSmstr", headerHozAlign:"center", hozAlign:"center", width:160,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.org' text='기관'/>",         field:"orgnm",      headerHozAlign:"center", hozAlign:"center", width:180,  minWidth:60},
                                {title:"<spring:message code='msg.sndrDsctn.col.sbjct' text='운영과목'/>",    field:"sbjctnm",    headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:120},
                                {title:"<spring:message code='msg.sndrDsctn.col.dvclas' text='분반'/>",      field:"dvclasNo",   headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.rcvr' text='수신자'/>",      field:"rcvrnm",     headerHozAlign:"center", hozAlign:"center", width:120,  minWidth:60},
                                {title:"<spring:message code='msg.sndrDsctn.col.rcvrTelno' text='수신자번호'/>", field:"rcvrTelno", headerHozAlign:"center", hozAlign:"center", width:150, minWidth:90},
                                {title:"<spring:message code='msg.sndrDsctn.col.sndngDttm' text='발신일시'/>", field:"sndngDttm",  headerHozAlign:"center", hozAlign:"center", width:130, minWidth:100, formatter:"date"},
                                {title:"<spring:message code='msg.sndrDsctn.col.sndngYn' text='발송'/>",     field:"sndngYn",    headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.sndrDsctn.col.rslt' text='결과'/>",        field:"rslt",       headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:50},
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
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2"><spring:message code="msg.sndrDsctn.label.sndngType" text="발신구분"/></th>
                                        <th rowspan="2">PUSH</th>
                                        <th rowspan="2"><spring:message  code="msg.title.msg.shrtnt"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.eml"/></th>
                                        <th rowspan="2"><spring:message code="msg.title.msg.alimTalk"/></th>
                                        <th colspan="2"><spring:message code="msg.sndrDsctn.label.sms" text="문자"/></th>
                                    </tr>
                                    <tr>
                                        <th>SMS</th>
                                        <th>LMS</th>
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
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalSuccCnt" text="총 성공 건수"/></td>
                                        <td id="pushSuccCnt">0</td>
                                        <td id="shrtntSuccCnt">0</td>
                                        <td id="emlSuccCnt">0</td>
                                        <td id="alimtalkSuccCnt">0</td>
                                        <td id="smsSuccCnt">0</td>
                                        <td id="lmsSuccCnt">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalFailCnt" text="총 실패 건수"/></td>
                                        <td id="pushFailCnt" class="txt-red">0</td>
                                        <td id="shrtntFailCnt" class="txt-red">0</td>
                                        <td id="emlFailCnt" class="txt-red">0</td>
                                        <td id="alimtalkFailCnt" class="txt-red">0</td>
                                        <td id="smsFailCnt" class="txt-red">0</td>
                                        <td id="lmsFailCnt" class="txt-red">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.sndCost" text="발신 비용"/></td>
                                        <td id="pushCost">0</td>
                                        <td id="shrtntCost">0</td>
                                        <td id="emlCost">0</td>
                                        <td id="alimtalkCost">0</td>
                                        <td id="smsCost">0</td>
                                        <td id="lmsCost">0</td>
                                    </tr>
                                    <tr>
                                        <td><spring:message code="msg.sndrDsctn.label.totalSndCost" text="총 발신 비용"/></td>
                                        <td colspan="6" id="totalCost">0</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //발송비용금액 -->

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
