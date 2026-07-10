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
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        var userId = '${vo.userId}';

        var rubricInfoListTable = null;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initRubricInfoListTable :    컬럼 정의
         * 2. createRubricInfoListHtml :   각 컬럼에 들어갈 데이터 세팅 및 요소 생성
         * 3. loadRubricInfoList :         모델 데이터를 tabulator에 세팅
         *****************************************************************************/
        /* 1 */
        function initRubricInfoListTable(data) {
            if (rubricInfoListTable) return;
            var rubricInfoColumns = [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='crs.label.rubric.name' />",  field:"rubricTtl", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:140},         /* 루브릭명 */
                {title:"<spring:message code='common.label.qstn.count' />",  field:"rubricQstnCnt", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80}, /* 문항수 */
                {title:"<spring:message code='common.button.choice' />",  field:"manage", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}          /* 선택 */
            ];
            rubricInfoListTable = UiTable("rubricList", {
                lang: "ko",
                pageFunc: loadRubricInfoList,
                columns: rubricInfoColumns,
                data: data || []
            });
        }
        /* 2 */
        function createRubricInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    var _p  = "\"" + v.userId + "\",\"" + v.rubricId + "\"";
                    var manage = "<div style='display:flex;align-items:center;justify-content:center;gap:0 3px'>"
                                + "<a href='javascript:rubricImport(" + _p + ")' class='btn basic small'><spring:message code='common.button.choice' /></a>"    /* 선택 */
                                + "&nbsp;</div>";
                    dataList.push({
                        lineNo          : v.lineNo
                        , rubricTtl     : v.rubricTtl
                        , rubricQstnCnt : v.rubricQstnCnt
                        , manage        : manage
                        , rubricId      : v.rubricId
                        , userId        : v.userId
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadRubricInfoList(pageIndex) {
            initRubricInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url     : "/crs/rubricPaging.do",
                type    : "GET",
                data    : {
                    userId      : userId
                    , pageIndex : PAGE_INDEX
                    , listScale : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0 ) {
                        var returnList  = data.returnList || [];
                        var dataList    = createRubricInfoListHtml(returnList);
                        rubricInfoListTable.clearData();
                        rubricInfoListTable.replaceData(dataList);
                        rubricInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        UiComm.showMessage(data.message, "warning");
                    }
                },
                error: function() {
                    UiComm.showLoading(false);
                    UiComm.showMessage("<spring:message code='crs.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

        /* 루브릭 선택 — 문항 상세 조회 후 부모 페이지에 전달 */
        function rubricImport(userId, rubricId) {
            UiComm.showLoading(true);
            $.ajax({
                url:      '/crs/rubricList.do',
                type:     'GET',
                data:     { userId: userId, rubricId: rubricId },
                dataType: 'json',
                success: function(data) {
                    window.parent.loadRubricImport(data || []);
                    window.parent.closeDialog();
                },
                error: function() {
                    UiComm.showLoading(false);
                    UiComm.showMessage("<spring:message code='crs.error.select.msg' />", "error");/* 조회 중 에러가 발생하였습니다. */
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

		$(document).ready(function() {
            loadRubricInfoList(1);
		});
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top">
        	</div>
            <div class="table-wrap margin-bottom-4">
                <div id="rubricArea">
                    <div id="rubricList"></div>
                </div>
            </div>
			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
