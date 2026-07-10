<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="table"/>
    </jsp:include>

	<script type="text/javascript">
		var PAGE_INDEX      = '<c:out value="${bbsAtclVO.pageIndex}" />';
	    var LIST_SCALE      = '<c:out value="${bbsAtclVO.listScale}" />';
	    var TEMPLATE_URL    = '<c:out value="${templateUrl}" />';
	    var ORG_ID          = '<c:out value="${bbsAtclVO.orgId}" />';
	    var SBJCT_ID        = '<c:out value="${bbsAtclVO.sbjctId}" />';
	    var ATCL_ID         = '<c:out value="${bbsAtclVO.atclId}" />';
	    var atclListGrpNtcTable;  // 테이블 객체
	    var EPARAM			= '<c:out value="${encParams}" />';

	    $(document).ready(function() {

	    	if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

	    	atclListGrpNtcTable = UiTable("bbsAtclGrpNtcList", {
                lang: "ko",
                selectRow: "checkbox",
                selectable: true,
                pageFunc: listPaging,
                columns: [
                    {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60},
                    {title: "학과", field: "deptnm", headerHozAlign: "center", hozAlign: "center", minWidth: 120, widthGrow: 1},
                    {title: "대표아이디", field: "userRprsId", headerHozAlign: "center", hozAlign: "center", minWidth: 120, widthGrow: 1},
                    {title: "학번", field: "userId", headerHozAlign: "center", hozAlign: "center", minWidth: 110, widthGrow: 1},  // userId → stdntNo
                    {title: "이름", field: "usernm", headerHozAlign: "center", hozAlign: "center", minWidth: 100, widthGrow: 1},
                    {title: "학과ID", field: "deptId", visible: false},
                    {title: "사용자아이디", field: "userId", visible: false},
                    {title: "게시글ID", field: "atclId", visible: false}
                ]
            });

	    	// 검색유형 라디오 변경 시 select 활성/비활성 토글
	    	$('input[name="searchType"]').on("change", function() {
	    		toggleSearchType();
	    	});
	    	toggleSearchType(); // 초기 상태 적용

	    	listPaging(1);
	    });

	    // 선택된 검색유형에 따라 해당 select만 활성화, 나머지는 비활성화
	    function toggleSearchType() {
	    	var type = $('input[name="searchType"]:checked').val();

	    	// 일단 전체 비활성화
	    	$("#searchType_atnd select").prop("disabled", true);
	    	$("#searchType_lrn select").prop("disabled", true);
	    	$("#searchType_team select").prop("disabled", true);

	    	// 선택된 유형만 활성화
	    	if (type === "ATND") {
	    		$("#searchType_atnd select").prop("disabled", false);
	    	} else if (type === "LRN") {
	    		$("#searchType_lrn select").prop("disabled", false);
	    	} else if (type === "TEAM") {
	    		$("#searchType_team select").prop("disabled", false);
	    	}
	    }

	    function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            var searchType = $('input[name="searchType"]:checked').val();

            // 검색유형별 파라미터 구성
            var extData = {
                  pageIndex   : pageIndex
                , listScale   : LIST_SCALE
                , orgId       : ORG_ID
                , sbjctId     : SBJCT_ID
                , searchType  : searchType
                , searchValue : $("#searchValue").val()
            };

            if (searchType === "ATND") {
                extData.lctrWknoSchdlId = $("#atndWkno").val();   // 선택 주차
            } else if (searchType === "LRN") {
                extData.lrnElemtId = $("#lrnElemt").val();           // 선택 과제
            } else if (searchType === "TEAM") {
                extData.teamGrpId = $("#teamGrpId").val();        // 학습그룹
                extData.lrnTeamId = $("#teamId").val();           // 팀
            }

            var url = "/bbs/bbsLect/bbsGrpNtcStdntList.do";
            var data = { encParams: EPARAM, addParams: UiComm.makeEncParams(extData) };

            ajaxCall(url, data, function(data) {
                if (data.encParams != null && data.encParams != '') { EPARAM = data.encParams; }
                if (data.result > 0) {
                    var dataList = createAtclListHTML(data.returnList || [], data.pageInfo);

                    atclListGrpNtcTable.clearData();
                    atclListGrpNtcTable.replaceData(dataList);
                    atclListGrpNtcTable.setPageInfo(data.pageInfo);
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error");
                }
            });
        }

	    function createAtclListHTML(atclList, pageInfo) {
	        var dataList = [];
	        atclList.forEach(function(v, i) {
	            dataList.push({
	                  no: v.lineNo
	                , deptnm: v.deptnm
	                , userRprsId: v.userRprsId
	                , stdntNo: v.stdntNo
	                , usernm: v.usernm
	                , userId: v.userId
	                , deptId: v.deptId
	            });
	        });
	        return dataList;
	    }

     	// 목록화면 이동(취소)
    	function moveListPage() {
    		document.location.href = "/bbs/bbsLect/bbsAtclWrite.do?encParams=${encParams}";
    	}

    	// 저장 버튼(선택 수강생 등록)
		/* function saveConfirm() {
		    var selectedRows = atclListGrpNtcTable.getSelectedRows();
		    var selectedData = selectedRows.map(function(row) { return row.getData(); });

		    if (selectedData.length === 0) {
		        UiComm.showMessage("저장할 항목을 선택해 주세요.", "warning");
		        return;
		    }

		    var userList = selectedData.map(function(v) {
		        return {
		              userId     : v.userId
		            , userRprsId : v.userRprsId
		            , stdntNo    : v.stdntNo
		            , deptId     : v.deptId
		        };
		    });

		    var extData = {
		          orgId    : ORG_ID
		        , sbjctId  : SBJCT_ID
		        , atclId   : ATCL_ID
		        , userList : userList
		    };

		    var url  = "/bbs/bbsLect/bbsGrpNtcRegist.do";
		    var data = { encParams: EPARAM, addParams: UiComm.makeEncParams(extData) };

		    ajaxCall(url, data, function(res) {
		        if (res.encParams != null && res.encParams != '') { EPARAM = res.encParams; }
		        if (res.result > 0) {
		            UiComm.showMessage(res.message || "저장되었습니다.", "success");
		            moveListPage();
		        } else {
		            UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error");
		        }
		    });
		} */

		// 추가하기: 선택 행을 부모 페이지로 전달
		// 추가하기: 선택 행을 그룹공지 테이블에 추가 (레이어 모달)
		function addSelected() {
		    var selectedRows = atclListGrpNtcTable.getSelectedRows();
		    var selectedData = selectedRows.map(function(row) { return row.getData(); });

		    if (selectedData.length === 0) {
		        UiComm.showMessage("추가할 수강생을 선택해 주세요.", "warning");
		        return;
		    }

		    // iframe 방식: 부모 document의 함수 호출
		    if (window.parent && typeof window.parent.addGrpNtcStudents === "function") {
		        window.parent.addGrpNtcStudents(selectedData);
		        // 모달/iframe 닫기 — 부모의 닫기 함수 호출
		        if (typeof window.parent.closeModal === "function") {
		            window.parent.closeModal();
		        }
		    } else {
		        UiComm.showMessage("부모 페이지를 찾을 수 없습니다.", "error");
		    }
		}
	</script>
</head>

<body class="${uiex:getTheme()} ${bodyClass}">
	<div id="wrap" class="main">
        <main class="common">
            <div class="search-typeA">

                <!-- 1. 주차별 출석 미달자 -->
                <div class="item" id="searchType_atnd">
                    <span class="item_tit">
                        <span class="custom-input">
                            <input type="radio" name="searchType" id="searchTypeAtnd" value="ATND" checked>
                            <label for="searchTypeAtnd">출석 미달자 검색</label>
                        </span>
                    </span>
                    <select class="ui dropdown" id="atndWkno">
                        <c:forEach var="wk" items="${wknoList}">
                            <option value="${wk.lctrWknoSchdlId}">${wk.lctrWknonm}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 2. 학습요소 미참여자 -->
                <div class="item" id="searchType_lrn">
                    <span class="item_tit">
                        <span class="custom-input">
                            <input type="radio" name="searchType" id="searchTypeLrn" value="LRN">
                            <label for="searchTypeLrn">학습요소 미참여 검색</label>
                        </span>
                    </span>
                    <select class="ui dropdown" id="lrnElemt">
                        <c:forEach var="lrnElemt" items="${filterOptions.lrnElemtList}">
                            <option value="${lrnElemt.lrnElemtId}">${lrnElemt.lrnElemtnm}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 3. 학습그룹 팀 -->
                <div class="item" id="searchType_team">
                    <span class="item_tit">
                        <span class="custom-input">
                            <input type="radio" name="searchType" id="searchTypeTeam" value="TEAM">
                            <label for="searchTypeTeam">학습그룹 팀 검색</label>
                        </span>
                    </span>

                    <select class="ui dropdown" id="teamGrpId">
                        <option value="">학습그룹</option>
                        <c:forEach var="grp" items="${filterOptions.teamGrpList}">
                            <option value="${grp.teamGrpId}">${grp.teamGrpnm}</option>
                        </c:forEach>
                    </select>
                    <select class="ui dropdown" id="teamId">
                        <option value="">팀선택</option>
                        <c:forEach var="team" items="${filterOptions.lrnTeamList}">
                            <option value="${team.lrnTeamId}">${team.lrnTeamnm}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 검색어 -->
                <div class="item">
                    <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span>
                    <div class="itemList">
                        <input class="form-control wide" type="text" id="searchValue" value="${param.searchValue}" placeholder="<spring:message code='bbs.common.placeholder'/>">
                    </div>
                </div>

                <div class="button-area">
                    <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code='button.search'/></button>
                </div>
            </div>

			<div id="bbsAtclGrpNtcList"></div>

			<div class="btns">
                <button type="button" class="btn type1" onclick="addSelected()"><spring:message code="common.button.add" /></button>
                <button type="button" class="btn type2" onclick="moveListPage()"><spring:message code="common.button.cancel" /></button>
            </div>
        </main>
	</div>
</body>
</html>
