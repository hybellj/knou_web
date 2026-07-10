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

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<body class="modal-page ${uiex:getTheme()}">
    <script type="text/javascript">
        <%--let RECORD_COUNT_PER_PAGE = '<c:out value="${pageInfo.recordCountPerPage}" />';--%>
        let RECORD_COUNT_PER_PAGE = 10;
        let CURRENT_PAGE_NO = '<c:out value="${pageInfo.currentPageNo}" />';

        // 학기기수 세팅 변경
        function changeSmstrChrt() {
            let $dgrsSmstrChrt = $('#dgrsSmstrChrt');

            // 기존 옵션 초기화
            $dgrsSmstrChrt.empty();

            $.ajax({
                url  : "/crs/termMgr/admSmstrListByDgrsYrAjax.do",
                data : {
                    dgrsYr 	: $("#dgrsYr").val()
                    <%--	,orgId	: $("#orgId").val() --%>
                },
                type : "GET",
                success: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $dgrsSmstrChrt.append(`<option value='ALL'><spring:message code="crs.label.open.term" /></option>`);

                        $.each(resultList, function(i, smstrChrtVO) {
                            $dgrsSmstrChrt.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
                            /* $dgrsSmstrChrt.append('<option'+' value="'+smstrChrtVO.smstrChrtId+'" >' + smstrChrtVO.smstrChrtnm + '</option>'); */
                        })

                        $dgrsSmstrChrt.trigger("chosen:updated");
                    }else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        // 학습현황 목록
        function listPaging(pageNo) {
            UiComm.showLoading(true);

            CURRENT_PAGE_NO = pageNo;

            let param = {
                currentPageNo       : CURRENT_PAGE_NO,
                recordCountPerPage  : RECORD_COUNT_PER_PAGE,
                yrSmstr             : $("#yrSmstr").val() || "",
                smstrChrtGbncd      : $("#yrSmstr option:selected").data("type") || "",
                orgId		        : $("#orgId").val(),
                sbjctId		        : $("#sbjctId").val(),
                searchValue         : $("#searchValue").val(),
            };

            $.ajax({
                url	: "/mrk/admAllMrkProcExcpProcListAjax.do",
                data: param,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.encParams != null && data.encParams !== '') {
                        EPARAM = data.encParams;
                    }

                    if (data.result > 0) {
                        let returnList = data.returnList || [];

                        let excpList = createListHtml(returnList);
                        excpListTable.clearData();
                        excpListTable.replaceData(excpList);
                        excpListTable.setPageInfo(data.pageInfo);

                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                    }
                },
                error : function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function (){
                    UiComm.showLoading(false);
                }
            });
        }

        // 테이블 그리기
        function createListHtml(list) {
            let dataList = [];

            list.forEach(item => {
                const procSdttm = formatDttm(item.procSdttm);
                const procEdttm = formatDttm(item.procEdttm);
                const regDttm = formatDttm(item.regDttm);
                const procCts = item.procSts + ": " + procSdttm + " ~ " + procEdttm

                dataList.push({
                    no      : item.lineNo,
                    orgnm   : item.orgnm,
                    dgrsYr  : item.dgrsYr + "년",
                    dgrsSmstr : item.dgrsSmstr,
                    crclmnNo: item.crclmnNo,
                    sbjctnm : item.sbjctnm,
                    dvclasNo: item.dvclasNo,
                    profnm  : item.profnm,
                    procCts : procCts,
                    procnm  : item.procnm,
                    regDttm : regDttm,
                })
            });

            return dataList;
        }

        // 날짜 포맷 변경
        function formatDttm(dttmStr) {
            if (!dttmStr || dttmStr.length < 14) return dttmStr;

            // 문자열을 위치대로 쪼개서 포맷 조립
            const yyyy = dttmStr.substring(0, 4);
            const MM   = dttmStr.substring(4, 6);
            const dd   = dttmStr.substring(6, 8);
            const HH   = dttmStr.substring(8, 10);
            const mm   = dttmStr.substring(10, 12);
            const ss   = dttmStr.substring(12, 14);

            return `\${yyyy}.\${MM}.\${dd} \${HH}:\${mm}`; // yyyy.MM.dd HH:mm
        }
    </script>
    <div id="wrap">
        <div class="board_top">
            <select class="form-select" id="orgId" ${disabled}><!-- 기관 -->
                <option value="">기관</option>
                <c:forEach var="list" items="${filterOptions.orgList }">
                    <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                </c:forEach>
            </select>
            <select class="form-select" id="yrSmstr">
                <option value=""><spring:message code="msg.common.label.yearSmstr" /></option>
                <c:forEach var="item" items="${filterOptions.yrSmstrList }" varStatus="i">
                    <option value="${item.dgrsYr}${item.dgrsSmstrChrt}" <%--${i.index eq 0 ? 'selected' : '' }--%> data-type="${item.smstrChrtGbncd}">${item.yrSmstrnm}</option>
                </c:forEach>
            </select>
            <select class="form-select" id="sbjctId">
                <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                <c:forEach var="list" items="${filterOptions.sbjctList }">
                    <option value="${list.sbjctId }">${list.sbjctnm }</option>
                </c:forEach>
            </select>
            <div class="search-typeC">
                <input type="text" id="searchValue" name="searchValue" class="form-control" value="" placeholder="<spring:message code='lesson.common.placeholder3' />" autocomplete="off"/>
                <button type="button" class="btn basic icon search" onclick="listPaging(1)"><i class="icon-svg-search"></i></button>
            </div>
        </div>

        <div class="table-wrap">
            <div id="excpList"></div>
        </div>

        <script type="text/javascript">
            let excpListTable;

            $(function () {

                excpListTable = UiTable("excpList", {
                    lang: "ko",
                    table: "excpList",
                    columns: [
                        {title: "<spring:message code='common.no'/>",                   field: "no",        headerHozAlign:"center", hozAlign:"center", width: 40, minWidth: 40},
                        {title: "<spring:message code="common.label.org" />",           field: "orgnm",     headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},
                        {title: "<spring:message code="common.year" />",                field: "dgrsYr",    headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60},
                        {title: "<spring:message code="common.term.cohort" />",         field: "dgrsSmstr", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                        {title: "<spring:message code="common.label.crsauth.crscd" />", field: "crclmnNo",  headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                        {title: "<spring:message code="common.subject" />",             field: "sbjctnm",   headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 110},
                        {title: "<spring:message code="common.label.decls.no" />",      field: "dvclasNo",  headerHozAlign: "center", hozAlign: "center", width: 45, minWidth: 45},
                        {title: "<spring:message code="common.professor" />",           field: "profnm",    headerHozAlign: "center", hozAlign: "center", width: 55, minWidth: 55},
                        {title: "<spring:message code="score.label.process.detail" />", field: "procCts",   headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 300},
                        {title: "<spring:message code="score.label.process.handler" />",field: "procnm",    headerHozAlign: "center", hozAlign: "center", width: 85, minWidth: 85},
                        {title: "<spring:message code="score.label.process.date" />",   field: "regDttm",  headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                    ],
                    pageFunc: listPaging,
                });

                listPaging(1);
            });
        </script>

        <div class="btns">
            <button class="btn type2" onclick="window.parent.closeDialog();">
                <spring:message code="exam.button.close" /><%--닫기--%>
            </button>
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>