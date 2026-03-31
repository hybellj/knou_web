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
        var absnceHstrInfoListTable = null;

        /* 서버에서 전달받은 결시신청 이력 데이터 */
        var absnceHstrServerList = [];
        <c:forEach var="item" items="${absnceHstr.returnList}">
        absnceHstrServerList.push({
            lineNo      : "<c:out value='${item.lineNo}'/>",
            examGbnnm   : "<c:out value='${item.examGbnnm}'/>",
            aplyStscd   : "<c:out value='${item.aplyStscd}'/>",
            aprvdttm    : "<c:out value='${item.aprvdttm}'/>",
            absnceTtl   : "<c:out value='${item.absnceTtl}'/>",
            absnceRfltrt: "<c:out value='${item.absnceRfltrt}'/>",
            aprvCts     : "<c:out value='${item.aprvCts}'/>"
        });
        </c:forEach>

        var absnceHstrPageInfo = {
            currentPageNo   : ${empty absnceHstr.pageInfo ? 1    : absnceHstr.pageInfo.currentPageNo},
            totalRecordCount: ${empty absnceHstr.pageInfo ? 0    : absnceHstr.pageInfo.totalRecordCount},
            totalPageCount  : ${empty absnceHstr.pageInfo ? 1    : absnceHstr.pageInfo.totalPageCount},
            pageSize        : ${empty absnceHstr.pageInfo ? 10   : absnceHstr.pageInfo.pageSize}
        };

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initAbsnceInfoListTable :    컬럼 정의
         * 2. createAbsnceHstrInfoListHtml :   각 컬럼에 들어갈 데이터 세팅 및 요소 생성
         * 3. loadAbsnceInfoList :         모델 데이터를 tabulator에 세팅
         *****************************************************************************/
        /* 1 */
        function initAbsnceInfoListTable(data) {
            if (absnceHstrInfoListTable) return;
            var absnceInfoColumns = [
                {title:"No",       field:"lineNo",       headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"시험구분",  field:"examGbnnm",    headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"처리상태",  field:"aplyStsnm",    headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"처리일시",  field:"aprvdttm",     headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"결시사유",  field:"absnceTtl",    headerHozAlign:"center", hozAlign:"center", width:150, minWidth:150},
                {title:"적용비율",  field:"absnceRfltrt", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"처리의견",  field:"aprvCts",      headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:150}
            ];
            absnceHstrInfoListTable = UiTable("absnceHstrList", {
                lang: "ko",
                pageFunc: loadAbsnceInfoList,
                columns: absnceInfoColumns,
                data: data || []
            });
        }
        /* 2 */
        function createAbsnceHstrInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 처리상태
                    var aplyStsnm;
                    if (v.aplyStscd == "APLY") {
                        aplyStsnm = "<span class='fcBlue'>신청</span>";
                    } else if (v.aplyStscd == "RE_APLY") {
                        aplyStsnm = "<span class='fcOrange'>재신청</span>";
                    } else if (v.aplyStscd == "APRV") {
                        aplyStsnm = "<span class='fcBlack'>승인</span>";
                    } else {
                        aplyStsnm = "<span class='fcRed'>거절</span>";
                    }
                    // 처리일시
                    var aprvdttm;
                    if (v.aprvdttm == "" || v.aprvdttm == null) {
                        aprvdttm = "-";
                    } else {
                        aprvdttm = dateFormat("date", v.aprvdttm);
                    }
                    // 처리의견
                    var aprvCts;
                    if (v.aprvCts == "" || v.aprvCts == null) {
                        aprvCts = "-";
                    } else {
                        aprvCts = v.aprvCts;
                    }
                    dataList.push({
                        lineNo      : v.lineNo
                        , examGbnnm : v.examGbnnm
                        , aplyStsnm : aplyStsnm
                        , aprvdttm  : aprvdttm
                        , absnceTtl : v.absnceTtl
                        , absnceRfltrt: v.absnceRfltrt + "%"
                        , aprvCts   : aprvCts
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadAbsnceInfoList() {
            var dataList = createAbsnceHstrInfoListHtml(absnceHstrServerList);
            initAbsnceInfoListTable(dataList);
            absnceHstrInfoListTable.setPageInfo(absnceHstrPageInfo);
        }

		$(document).ready(function() {
            loadAbsnceInfoList();
		});
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top">
        		<div class="left-area">
	            	<a><strong>결시 신청 이력 [총 ${absnceHstr.pageInfo.totalRecordCount} 건]</strong></a>
        		</div>
        	</div>
            <div class="table-wrap margin-bottom-4">
                <table class="table-type2">
                    <colgroup>
                        <col class="width-20per" />
                        <col class="" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label>학번</label></th>
                            <td class="t_left"><pre>${absnceHstr.returnList[0].stdntNo}</pre></td>
                            <th><label>이름</label></th>
                            <td class="t_left"><pre>${absnceHstr.returnList[0].usernm}</pre></td>
                        </tr>
                        <tr>
                            <th><label>학과</label></th>
                            <td class="t_left"><pre>${absnceHstr.returnList[0].deptnm}</pre></td>
                            <th><label>연락처</label></th>
                            <td class="t_left"><pre>${absnceHstr.returnList[0].mobileNo}</pre></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div id="absnceHstrArea">
                <div id="absnceHstrList"></div>
            </div>
			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
