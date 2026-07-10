<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/team/common/team_common_inc.jsp" %>
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

        var curSbjctId = '${sbjctId}';
        var teamGrpInfoListTable = null;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initTeamGrpInfoListTable:      컬럼 정의
         * 2. createTeamGrpInfoListHtml:       각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성
         * 3. loadTeamGrpInfoList :            컬럼에 들어갈 데이터 ajax 호출
         *****************************************************************************/
        /* 1 */
        function initTeamGrpInfoListTable() {
            if (teamGrpInfoListTable) return;
            var teamGrpInfoColumns = [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='team.label.grp.nm'/>", field:"teamGrpnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200},           /* 팀그룹명 */
                {title:"<spring:message code='team.table.field.teamCnt'/>", field:"teamTot", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},    /* 팀수 */
                {title:"<spring:message code='common.registrant'/>", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},          /* 등록자 */
                {title:"<spring:message code='common.registration.date'/>", field:"regDttm", headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140}, /* 등록일자 */
                {title:"<spring:message code='common.label.status'/>", field:"teamGrpCmptnyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},/* 상태 */
                {title:"<spring:message code='common.mgr'/>", field:"manage", headerHozAlign:"center", hozAlign:"center", width:160, minWidth:160}                  /* 관리 */
            ];
            teamGrpInfoListTable = UiTable("teamGrpList", {
                lang: "ko",
                pageFunc: loadTeamGrpInfoList,
                columns: teamGrpInfoColumns
            });
        }
        /* 2 */
        function createTeamGrpInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {

                    var _p  = "\"" + v.teamGrpId + "\",\"" + v.usingyn + "\",\"" + v.sbjctId + "\"";
                    // 팀그룹명
                    var teamGrpnm = "<a href='javascript:teamGrpMgrDtlViewMv(" + _p + ")' class='header header-icon link'>" + v.teamGrpnm + "</a>";
                    // 팀수
                    var teamTot;
                    if (v.teamTot === 0) {
                        teamTot = "-";
                    } else {
                        teamTot = v.teamTot + " <spring:message code='common.team'/>";  /* 팀 */
                    }
                    // 등록일자
                    var regDttm = dateFormat("date", v.regDttm);
                    // 상태
                    var teamGrpCmptnyn;
                    if (v.teamGrpCmptnyn === "Y") {
                        teamGrpCmptnyn = "<a><spring:message code='team.label.complete'/></a>"  /* 구성완료 */
                    } else {
                        teamGrpCmptnyn = "<a class='fcRed'><spring:message code='team.label.temp.save'/></a>"   /* 임시저장 */
                    }
                    // 관리
                    var manage = "<div style='display:flex;align-items:center;justify-content:center;gap:0 3px'>"
                                + "<a href='javascript:teamGrpMgrWriteViewMv(" + _p + ")' class='btn basic small'><spring:message code='common.button.modify'/></a>"    /* 수정 */
                                + "<a href='javascript:teamGrpMgrDel(" + _p + ")' class='btn basic small'><spring:message code='common.button.delete'/></a>"            /* 삭제 */
                                + "&nbsp;</div>";

                    dataList.push({
                        lineNo:         v.lineNo
                        , teamGrpnm:     teamGrpnm
                        , teamTot:      teamTot
                        , usernm:       v.usernm
                        , regDttm:      regDttm
                        , teamGrpCmptnyn:teamGrpCmptnyn
                        , manage:       manage
                        , teamGrpId:    v.teamGrpId
                        , sbjctId:      v.sbjctId
                        , usingyn:      v.usingyn
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadTeamGrpInfoList(pageIndex) {
            initTeamGrpInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/team/teamGrpPaging.do",
                type: "GET",
                data: {
                    encParams   : EPARAM
                    , pageIndex : PAGE_INDEX
                    , listScale : LIST_SCALE
                    , teamGrpnm  : $('#teamGrpnm').val()
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        if (data.encParams != null && data.encParams != "") {
                            EPARAM = data.encParams;
                        }
                        var returnList = data.returnList || [];
                        var dataList   = createTeamGrpInfoListHtml(returnList);
                        teamGrpInfoListTable.clearData();
                        teamGrpInfoListTable.replaceData(dataList);
                        teamGrpInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    UiComm.showLoading(false);
                    UiComm.showMessage("<spring:message code='team.error.list.msg1' />", "error");  /* 리스트 조회 중 에러가 발생하였습니다. */
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

        /* 팀 그룹 삭제 */
        function teamGrpMgrDel(teamGrpId, usingyn) {
            if (usingyn === 'Y') {
                UiComm.showMessage("<spring:message code='team.alrd.use.msg' />", "warning");    /* 해당 팀 그룹은 사용중입니다. */
                return;
            }
            UiComm.showMessage("<spring:message code='team.delete.msg1' />", "confirm")   /* 팀 그룹을 삭제 하시겠습니까? */
                .then(function(result) {
                    if (!result) return;
                    UiComm.showLoading(true);
                    $.ajax({
                        url: "/team/teamGrpDelete.do",
                        type: "POST",
                        data: { teamGrpId: teamGrpId },
                        dataType: "json",
                        success: function(data) {
                            if (data.result > 0) {
                                UiComm.showMessage(data.message, "success").then(function() {
                                    loadTeamGrpInfoList(PAGE_INDEX);
                                });
                            } else {
                                UiComm.showMessage(data.message, "success");
                            }
                        },
                        error: function() {
                            UiComm.showLoading(false);
                            UiComm.showMessage("<spring:message code='team.error.delete.msg1' />", "error");  /* 팀 그룹 삭제 중 에러가 발생했습니다. */
                        },
                        complete: function() {
                            UiComm.showLoading(false);
                        }
                    });
                });
        }

        /**
         * 팀 그룹 지정 [등록|수정] 페이지 이동
         * @param teamGrpId  팀 그룹 ID
         * @param usingyn   팀 그룹 사용여부
         */
        function teamGrpMgrWriteViewMv(teamGrpId, usingyn, sbjctId) {
            teamGrpMgrViewMv("write", teamGrpId, usingyn, sbjctId);
        }

        /**
         * 팀 그룹 상세 페이지 이동
         * @param teamGrpId  팀 그룹 ID
         * @param usingyn   팀 그룹 사용여부
         */
        function teamGrpMgrDtlViewMv(teamGrpId, usingyn, sbjctId) {
            teamGrpMgrViewMv("dtl", teamGrpId, usingyn, sbjctId);
        }

        $(document).ready(function() {
            loadTeamGrpInfoList();

            /* 검색 영역 엔터키 입력 */
            $("#teamGrpnm").on("keyup", function(e) {
                if(e.keyCode === 13) {
                    loadTeamGrpInfoList(1);
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
                                    <input class="form-control wide" type="text" name="teamGrpnm" id="teamGrpnm" value="${vo.teamGrpnm}"
                                           placeholder="<spring:message code='team.input.team.grp.nm' />"><!-- 팀 그룹명을 입력하세요. -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="loadTeamGrpInfoList(1)">
                                    <spring:message code='button.search'/><!-- 검색 -->
                                </button>
                            </div>
                        </div>
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title"><spring:message code='team.label.team.grp.set' /></h3><!-- 팀 그룹지정 -->
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick = "teamGrpMgrWriteViewMv('', '', '${sbjctId}')"><spring:message code='common.button.create' /></button>
                                <!-- 목록 스케일 선택 -->
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>
                        <!-- 팀 그룹 목록 (list) -->
                        <div id="teamGrpListArea">
                            <div id="teamGrpList"></div>
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
