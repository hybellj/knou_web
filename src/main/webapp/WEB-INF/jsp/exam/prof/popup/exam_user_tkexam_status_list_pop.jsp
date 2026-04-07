<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
            <jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
        /* Tabulator 공통 페이징 */
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        var sbstUserInfoListTable = null;
        var curSbjctId = '${vo.sbjctId}';

        var	midhtml  = `<tr>`;
            midhtml += `	<td class="tc">100</td>`;
            midhtml += `	<td class="tc">${midChartMap.avgScore}</td>`;
            midhtml += `	<td class="tc">${midChartMap.topAvgScore}</td>`;
            midhtml += `	<td class="tc">${midChartMap.maxScore}</td>`;
            midhtml += `	<td class="tc">${midChartMap.minScore}</td>`;
            midhtml += `	<td class="tc">${midChartMap.noTkexamCnt + midChartMap.tempSaveCnt + midChartMap.completeCnt}</td>`;
            midhtml += `</tr>`;

        var	lsthtml  = `<tr>`;
            lsthtml += `	<td class="tc">100</td>`;
            lsthtml += `	<td class="tc">${lstChartMap.avgScore}</td>`;
            lsthtml += `	<td class="tc">${lstChartMap.topAvgScore}</td>`;
            lsthtml += `	<td class="tc">${lstChartMap.maxScore}</td>`;
            lsthtml += `	<td class="tc">${lstChartMap.minScore}</td>`;
            lsthtml += `	<td class="tc">${lstChartMap.noTkexamCnt + lstChartMap.tempSaveCnt + lstChartMap.completeCnt}</td>`;
            lsthtml += `</tr>`;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initSbstUserInfoListTable :   컬럼 정의
         * 2. createSbstUserInfoListHtml:   각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성
         * 3. loadSbstUserInfoList :        컬럼에 들어갈 데이터 ajax 호출
         *****************************************************************************/
        /* 1 */
        function initSbstUserInfoListTable() {
            if (sbstUserInfoListTable) return;
            var examInfoColumns =  [
                {title:"No",       field:"lineNo",      headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"학과",     field:"deptnm",       headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"대표아이디",field:"userRprsId",   headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"학번",     field:"stdntNo",      headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"이름",     field:"usernm",       headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"중간고사", field:"midExamScr",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"중간고사(대체)", field:"midAbsnceScr",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"기말고사", field:"lstExamScr",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"기말고사(대체)", field:"lstAbsnceScr",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}
            ];
            sbstUserInfoListTable = UiTable("sbstUserList", {
                lang: "ko",
                pageFunc: loadSbstUserInfoList,
                columns: examInfoColumns
            });
        }
        /* 2 */
        function createSbstUserInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 학번
                    var stdntNo;
                    if (v.stdntNo == "" || v.stdntNo == null) {
                        stdntNo = "-";
                    } else {
                        stdntNo = v.stdntNo;
                    }
                    // 중간고사 점수
                    var midExamScr
                    if ((v.midExamScr == "" || v.midExamScr == null) && (v.midAbsnceScr == "" || v.midAbsnceScr == null)) {
                        midExamScr = "<span class='fcRed'>미응시</span>"
                    } else if (v.midExamScr == "" || v.midExamScr == null) {
                        midExamScr = "-";
                    } else {
                        midExamScr = v.midExamScr;
                    }
                    // 중간고사 대체 점수
                    var midAbsnceScr
                    if (v.midAbsnceScr == "" || v.midAbsnceScr == null) {
                        midAbsnceScr = "-";
                    } else {
                        midAbsnceScr = v.midAbsnceScr;
                    }
                    // 기말고사 점수
                    var lstExamScr
                    if ((v.lstExamScr == "" || v.lstExamScr == null) && (v.lstAbsnceScr == "" || v.lstAbsnceScr == null)) {
                        lstExamScr = "<span class='fcRed'>미응시</span>"
                    } else if (v.lstExamScr == "" || v.lstExamScr == null) {
                        lstExamScr = "-";
                    } else {
                        lstExamScr = v.lstExamScr;
                    }
                    // 기말고사 대체 점수
                    var lstAbsnceScr
                    if (v.lstAbsnceScr == "" || v.lstAbsnceScr == null) {
                        lstAbsnceScr = "-";
                    } else {
                        lstAbsnceScr = v.lstAbsnceScr;
                    }

                    dataList.push({
                        lineNo:         v.lineNo
                        , deptnm:       v.deptnm
                        , userRprsId:   v.userRprsId
                        , stdntNo:      stdntNo
                        , userId:       v.userId
                        , usernm:       v.usernm
                        , midExamScr:   midExamScr
                        , midAbsnceScr: midAbsnceScr
                        , lstExamScr:   lstExamScr
                        , lstAbsnceScr: lstAbsnceScr
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadSbstUserInfoList() {
            initSbstUserInfoListTable();
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/tkexamStatPaging.do",
                type: "GET",
                data: {
                    sbjctId     : curSbjctId,
                    pageIndex   : PAGE_INDEX,
                    listScale   : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createSbstUserInfoListHtml(returnList);
                        sbstUserInfoListTable.clearData();
                        sbstUserInfoListTable.replaceData(dataList);
                        sbstUserInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    alert("에러가 발생했습니다!");
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

		$(document).ready(function() {
            loadSbstUserInfoList();

            /* 중간고사 */
            examCommon.horizontalBarChartSet([
                <c:forEach var="item" items="${midChartList}" varStatus="loop">
                { label: "${item.label}", cnt: ${item.cnt} }<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ], "M");
            examCommon.barChartSet({
                avgScore: ${midChartMap.avgScore},
                topAvgScore: ${midChartMap.topAvgScore},
                maxScore: ${midChartMap.maxScore},
                minScore: ${midChartMap.minScore}
            }, "M");

            /* 기말고사 */
            examCommon.horizontalBarChartSet([
                <c:forEach var="item" items="${lstChartList}" varStatus="loop">
                { label: "${item.label}", cnt: ${item.cnt} }<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ], "L");
            examCommon.barChartSet({
                avgScore: ${lstChartMap.avgScore},
                topAvgScore: ${lstChartMap.topAvgScore},
                maxScore: ${lstChartMap.maxScore},
                minScore: ${lstChartMap.minScore}
            }, "L");

            $('#mid-status').html(midhtml);
            $('#lst-status').html(lsthtml);
        });
	</script>

	<body class="modal-page">
        <div id="wrap">
            <div id = "sbstArea">
                <div id="sbstUserList"></div>
            </div>
            <!-- 중간고사 -->
        	<div class="border-1 padding-3">
                <div class="ui segment" style="height:100%;">
                    <div class="column">
                        <canvas id="midHoriBarChart" height="100"></canvas>
                    </div>
                    <table class="table-type2" id="midStatusTable" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
                        <thead>
                        <tr>
                            <th class="tc"><spring:message code="exam.label.gain.point" /></th><!-- 배점 -->
                            <th class="tc"><spring:message code="exam.label.avg" /></th><!-- 평균 -->
                            <th class="tc"><spring:message code="exam.label.avg.upper.10" /></th><!-- 상위10%평균 -->
                            <th class="tc"><spring:message code="exam.label.max" /><spring:message code="exam.label.score.point" /></th><!-- 최고 --><!-- 점 -->
                            <th class="tc"><spring:message code="exam.label.min" /><spring:message code="exam.label.score.point" /></th><!-- 최저 --><!-- 점 -->
                            <th class="tc"><spring:message code="exam.label.total.join.user" /></th><!-- 총응시자수 -->
                        </tr>
                        </thead>
                        <tbody id="mid-status">
                        </tbody>
                    </table>
                    <div class="column">
                        <canvas id="midBarChart" height="100"></canvas>
                    </div>
                </div>
			</div>

            <!-- 기말고사 -->
            <div class="border-1 padding-3">
                <div class="ui segment" style="height:100%;">
                    <div class="column">
                        <canvas id="endHoriBarChart" height="100"></canvas>
                    </div>
                    <table class="table-type2" id="lstStatusTable" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
                        <thead>
                        <tr>
                            <th class="tc"><spring:message code="exam.label.gain.point" /></th><!-- 배점 -->
                            <th class="tc"><spring:message code="exam.label.avg" /></th><!-- 평균 -->
                            <th class="tc"><spring:message code="exam.label.avg.upper.10" /></th><!-- 상위10%평균 -->
                            <th class="tc"><spring:message code="exam.label.max" /><spring:message code="exam.label.score.point" /></th><!-- 최고 --><!-- 점 -->
                            <th class="tc"><spring:message code="exam.label.min" /><spring:message code="exam.label.score.point" /></th><!-- 최저 --><!-- 점 -->
                            <th class="tc"><spring:message code="exam.label.total.join.user" /></th><!-- 총응시자수 -->
                        </tr>
                        </thead>
                        <tbody id="lst-status">
                        </tbody>
                    </table>
                    <div class="column">
                        <canvas id="endBarChart" height="100"></canvas>
                    </div>
                </div>
            </div>

            <div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
