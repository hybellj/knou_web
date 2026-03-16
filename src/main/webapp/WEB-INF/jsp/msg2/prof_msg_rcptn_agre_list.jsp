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
    let currentPage = 1;
    let listScale = ${pageSize};
    let totalCnt = 0;
    let rcptnAgreTable;

    $(document).ready(function() {

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

        /* 사용자구분 전체 체크 */
        $('#chkUserTyAll').on('change', function() {
            $('input[name=userTycds]').prop('checked', $(this).is(':checked'));
        });
        $('input[name=userTycds]').on('change', function() {
            if ($('#chkUserTyAll').is(':checked')) {
                $('#chkUserTyAll').prop('checked', false);
                $('input[name=userTycds]').prop('checked', true);
                $(this).prop('checked', false);
            } else {
                let total = $('input[name=userTycds]').length;
                let checked = $('input[name=userTycds]:checked').length;
                $('#chkUserTyAll').prop('checked', total === checked);
            }
        });

        /* 셀렉트박스 초기 로딩 */
        fn_loadYrList();
        fn_loadDeptList();

        /* 초기 리스트 조회 */
        fn_search();
    });

    /* 학사년도 목록 조회 */
    function fn_loadYrList() {
        ajaxCall('/msgRcptnAgreYrListAjax.do', {}, function(res) {
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

        ajaxCall('/msgRcptnAgreSmstrListAjax.do', { sbjctYr: sbjctYr }, function(res) {
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
        ajaxCall('/msgRcptnAgreDeptListAjax.do', {}, function(res) {
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

        ajaxCall('/msgRcptnAgreSbjctListAjax.do', data, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    $sel.append('<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>');
                });
            }
            $sel.trigger('chosen:updated');
        });
    }

    /* 검색 */
    function fn_search() {
        fn_loadList(1);
    }

    /* 검색 파라미터 수집 */
    function fn_getSearchParam() {
        let userTycd = '';
        if ($('input[name=userTycds]:checked').length === 1) {
            userTycd = $('input[name=userTycds]:checked').val();
        }

        return {
            sbjctYr: $('#selectSbjctYr').val(),
            sbjctSmstr: $('#selectSbjctSmstr').val(),
            deptId: $('#selectDept').val(),
            sbjctId: $('#selectSbjct').val(),
            userTycd: userTycd,
            searchType: $('#selectSearchType').val(),
            searchText: $('#inputSearchText').val()
        };
    }

    /* 목록 조회 */
    function fn_loadList(pageIndex) {
        if (pageIndex) currentPage = pageIndex;

        let param = fn_getSearchParam();
        param.pageIndex = currentPage;
        param.listScale = listScale;

        ajaxCall('/msgRcptnAgreListAjax.do', param, function(res) {
            if (res.result > 0) {
                let dataList = fn_createListData(res.returnList, res.pageInfo);
                rcptnAgreTable.clearData();
                rcptnAgreTable.replaceData(dataList);
                rcptnAgreTable.setPageInfo(res.pageInfo);
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

            dataList.push({
                no: rnum,
                sbjctYr: UiComm.escapeHtml(v.sbjctYr || ''),
                sbjctSmstr: UiComm.escapeHtml(v.sbjctSmstr || ''),
                orgnm: UiComm.escapeHtml(v.orgnm || ''),
                deptnm: UiComm.escapeHtml(v.deptnm || ''),
                sbjctnm: UiComm.escapeHtml(v.sbjctnm || ''),
                dvclasNo: UiComm.escapeHtml(v.dvclasNo || ''),
                stdntNo: UiComm.escapeHtml(v.stdntNo || ''),
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

    /* 수신여부 HTML (N이면 빨간색) */
    function fn_rcvynHtml(val) {
        if (val === 'N') {
            return '<span class="txt-red">N</span>';
        }
        return UiComm.escapeHtml(val || '');
    }

    /* 리스트 스케일 변경 */
    function fn_changeListScale(scale) {
        listScale = scale;
        fn_loadList(1);
    }

    /* 엑셀 다운로드 */
    function fn_excelDown() {
        let excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.no" text="번호"/>', name: 'rnum', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.year" text="년도"/>', name: 'sbjctYr', align: 'center', width: '2500'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.smstr" text="학기"/>', name: 'sbjctSmstr', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.org" text="기관"/>', name: 'orgnm', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.rcptnAgre.col.dept" text="학과"/>', name: 'deptnm', align: 'center', width: '5000'});
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

        let param = fn_getSearchParam();
        let form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/msgRcptnAgreExcelDown.do");
        form.append($('<input/>', { type: 'hidden', name: 'sbjctYr', value: param.sbjctYr }));
        form.append($('<input/>', { type: 'hidden', name: 'sbjctSmstr', value: param.sbjctSmstr }));
        form.append($('<input/>', { type: 'hidden', name: 'deptId', value: param.deptId }));
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

<body class="home colorA ${bodyClass}">
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
                            <h2 class="page-title"><span><spring:message code="msg.title.msg.msgDlvrHist" text="메시지 발송내역"/></span><spring:message code="msg.rcptnAgre.label.title" text="알림수신동의현황"/></h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><spring:message code="msg.sndrDsctn.label.msgBox" text="메시지함"/></li>
                                    <li><span class="current"><spring:message code="msg.rcptnAgre.label.title" text="알림수신동의현황"/></span></li>
                                </ul>
                            </div>
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
                                    <select class="form-select" id="selectOrg" disabled>
                                        <option value="${orgId}"><c:out value="${orgId}"/></option>
                                    </select>
                                    <select class="form-select" id="selectDept">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과 전체"/></option>
                                    </select>
                                    <select class="form-select wide" id="selectSbjct">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label><spring:message code="msg.rcptnAgre.label.userTycd" text="사용자 구분"/></label></span>
                                <div class="itemList">
                                    <span class="custom-input"><input type="checkbox" id="chkUserTyAll" checked><label for="chkUserTyAll"><spring:message code="msg.sndrDsctn.label.all" text="전체"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="userTycds" value="STDNT" id="chkStdnt" checked><label for="chkStdnt"><spring:message code="msg.rcptnAgre.label.stdnt" text="수강생"/></label></span>
                                    <span class="custom-input"><input type="checkbox" name="userTycds" value="PROF" id="chkProf" checked><label for="chkProf"><spring:message code="msg.rcptnAgre.label.prof" text="교직원"/></label></span>
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
                            <h3 class="board-title"><spring:message code="msg.rcptnAgre.label.listTitle" text="알림수신동의현황"/> [ <spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b id="totalCntText">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_excelDown()"><spring:message code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                                <span class="list-card-button"></span>
                                <uiex:listScale func="fn_changeListScale" value="10" />
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
                                    <p><label class="label-title"><spring:message code='msg.rcptnAgre.col.dept' text='학과'/></label><strong>#[deptnm]</strong></p>
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
                                {title:"<spring:message code='msg.rcptnAgre.col.smstr' text='학기'/>",      field:"sbjctSmstr",      headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.rcptnAgre.col.org' text='기관'/>",        field:"orgnm",           headerHozAlign:"center", hozAlign:"center", width:130, minWidth:60},
                                {title:"<spring:message code='msg.rcptnAgre.col.dept' text='학과'/>",       field:"deptnm",          headerHozAlign:"center", hozAlign:"center", width:130, minWidth:60},
                                {title:"<spring:message code='msg.rcptnAgre.col.sbjct' text='운영과목'/>",   field:"sbjctnm",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:120},
                                {title:"<spring:message code='msg.rcptnAgre.col.dvclas' text='분반'/>",     field:"dvclasNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.rcptnAgre.col.stdntNo' text='학번'/>",    field:"stdntNo",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:70},
                                {title:"<spring:message code='msg.rcptnAgre.col.usernm' text='이름'/>",     field:"usernm",          headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:60},
                                {title:"<spring:message code='msg.rcptnAgre.col.mblPhn' text='휴대폰번호'/>", field:"mblPhn",          headerHozAlign:"center", hozAlign:"center", width:120, minWidth:90},
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
