<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/crs/common/crs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var PAGE_INDEX = 1;
		var LIST_SCALE = 10;

        var userId = '${vo.userId}';
        var lrnGrpInfoListTable = null;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initRubricInfoListTable:      컬럼 정의
         * 2. createRubricInfoListHtml:     각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성
         * 3. loadRubricInfoList :          컬럼에 들어갈 데이터 ajax 호출
         *****************************************************************************/
        /* 1 */
        function initRubricInfoListTable() {
            if (lrnGrpInfoListTable) return;
            var lrnGrpInfoColumns = [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='common.label.prof.nm' />", field:"profnm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},          /* 교수명 */
                {title:"<spring:message code='crs.label.rubric.name' />", field:"rubricTtl", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200},          /* 루브릭명 */
                {title:"<spring:message code='common.label.qstn.count' />", field:"rubricQstnCnt", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},  /* 문항수 */
                {title:"<spring:message code='common.registrant' />", field:"rgtrnm", headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140},            /* 등록자 */
                {title:"<spring:message code='common.label.reg.dttm' />", field:"regDttm", headerHozAlign:"center", hozAlign:"center", width:160, minWidth:160},        /* 등록일시 */
                {title:"<spring:message code='common.use.yn' />", field:"useyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},                  /* 사용여부 */
                {title:"<spring:message code='common.mgr' />", field:"manage", headerHozAlign:"center", hozAlign:"center", width:160, minWidth:160}                     /* 관리 */
            ];
            lrnGrpInfoListTable = UiTable("rubricList", {
                lang: "ko",
                pageFunc: loadRubricInfoList,
                columns: lrnGrpInfoColumns
            });
        }
        /* 2 */
        function createRubricInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {

                    // 등록일자
                    var regDttm = dateFormat("date", v.regDttm);
                    // 사용여부
                    var useyn = "<input type='checkbox' value=\"" + v.rubricId + "\" class='switch small' " + (v.useyn == "Y" ? "checked" : "") + ">";
                    // 관리
                    var _p  = "\"" + v.rubricId + "\"";
                    var _pd = "\"" + v.userId + "\",\"" + v.rubricId + "\"";
                    var manage = "<div style='display:flex;align-items:center;justify-content:center;gap:0 3px'>"
                                + "<a href='javascript:rubricWriteViewMv(" + _p + ")' class='btn basic small'><spring:message code='common.button.modify' /></a>"   /* 수정 */
                                + "<a href='javascript:rubricDel(" + _pd + ")' class='btn basic small'><spring:message code='common.button.delete' /></a>"          /* 삭제 */
                                + "&nbsp;</div>";

                    dataList.push({
                        lineNo:             v.lineNo
                        , profnm:           v.profnm
                        , rubricTtl:        v.rubricTtl
                        , rubricQstnCnt:    v.rubricQstnCnt
                        , rgtrnm:           v.rgtrnm
                        , regDttm:          regDttm
                        , useyn:            useyn
                        , manage:           manage
                        , rubricId:         v.rubricId
                        , userId:           v.userId
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
                url: "/crs/rubricPaging.do",
                type: "GET",
                data: {
                    encParams   : EPARAM
                    , pageIndex : PAGE_INDEX
                    , listScale : LIST_SCALE
                    , rubricTtl  : $('#rubricTtl').val()
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        if (data.encParams != null && data.encParams != "") {
                            EPARAM = data.encParams;
                        }
                        var returnList = data.returnList || [];
                        var dataList   = createRubricInfoListHtml(returnList);
                        lrnGrpInfoListTable.clearData();
                        lrnGrpInfoListTable.replaceData(dataList);
                        lrnGrpInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        alert(data.message);
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

        /*****************************************************************************
         * 버튼 관련 기능
         * 1. rubricDel:            루브릭 삭제
         * 2. rubricWriteViewMv:    루브릭 [등록|수정] 페이지 이동
         *****************************************************************************/
        /* 1 */
        function rubricDel(userId, rubricId) {
            UiComm.showMessage("<spring:message code='crs.confirm.rubric.delete' />", "confirm")   /* 루브릭을 삭제 하시겠습니까? */
                .then(function(result) {
                    if (!result) return;
                    UiComm.showLoading(true);
                    $.ajax({
                        url: "/crs/rubricDelete.do",
                        type: "POST",
                        data: { rubricId: rubricId, userId: userId },
                        dataType: "json",
                        success: function(data) {
                            if (data.result > 0) {
                                UiComm.showMessage(data.message, "success").then(function() {
                                    loadRubricInfoList(1);
                                });
                            } else {
                                UiComm.showMessage(data.message, "success");
                            }
                        },
                        error: function() {
                            UiComm.showMessage("<spring:message code='crs.error.rubric.delete' />", "error");   /* 루브릭 삭제가 실패하였습니다. 다시 시도해주세요. */
                        },
                        complete: function() {
                            UiComm.showLoading(false);
                        }
                    });
                });
        }
        /* 2 */
        function rubricWriteViewMv(rubricId) {
            rubricViewMv("write", rubricId);
        }

        /**
         * 루브릭 사용여부 수정
         * @param {String} rubricId - 루브릭 ID
         * @param {String} useyn 	- 사용여부 수정
         */
        document.addEventListener('change', (e) => {
            if(e.target.classList.contains('switch')) {
                var useyn = e.target.checked ? "Y" : "N";
                var url = "/crs/rubricUseynModify.do";
                var data = {
                    "rubricId" 	: e.target.value
                    , "useyn"   : useyn
                    , "userId"  : userId
                };

                ajaxCall(url, data, function(data) {
                    if (data.result > 0) {
                        loadRubricInfoList(1);
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                }, function(xhr, status, error) {
                    UiComm.showMessage("<spring:message code='crs.error.rubric.useyn' />", "error");   /* 루브릭 사용여부 변경 중 에러가 발생했습니다. */
                }, true);
            }
        });

        $(document).ready(function() {
            loadRubricInfoList();

            /* 검색 영역 엔터키 입력 */
            $("#rubricTtl").on("keyup", function(e) {
                if(e.keyCode === 13) {
                    loadRubricInfoList(1);
                }
            });
        });
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="searchValue">
                                        <spring:message code='common.search.keyword'/><!-- 검색어 -->
                                    </label>
                                </span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="rubricTtl" id="rubricTtl" value="${vo.rubricTtl}"
                                           placeholder="<spring:message code='crs.input.rubric.nm' />"><!-- 루브릭명을 입력하세요. -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="loadRubricInfoList(1)">
                                    <spring:message code='button.search'/><!-- 검색 -->
                                </button>
                            </div>
                        </div>
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title"><spring:message code='crs.clasOp.rubric.list' /></h3><!-- 기본 루브릭 관리 -->
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick = "rubricWriteViewMv('')"><spring:message code='common.button.create' /></button><!-- 등록 -->
                                <!-- 목록 스케일 선택 -->
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>
                        <!-- 학습 그룹 목록 (list) -->
                        <div id="rubricListArea">
                            <div id="rubricList"></div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
