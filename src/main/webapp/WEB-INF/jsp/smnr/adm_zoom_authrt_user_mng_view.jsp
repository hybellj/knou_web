<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/smnr/common/smnr_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE 		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					onlnPltfrmAuthrtListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			onlnPltfrmAuthrtListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			onlnPltfrmAuthrtListSelect(1);
		}

		/**
		 * 온라인플랫폼권한목록조회
		 * @param page	이동페이지
		 */
		function onlnPltfrmAuthrtListSelect(page) {
			PAGE_INDEX   = page;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/smnr/pltfrm/admOnlnPltfrmAuthrtListAjax.do";
			const param = {
				orgId				: $("#orgId").val(),
				pltfrmGbncd			: "ZOOM",
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10
			};

			$.ajax({
                url			: url,
                type		: "POST",
                data		: param,
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function(data) {
                    if (data.result > 0) {
    	            	let authrtData = createOnlnPltfrmAuthrtListHTML(data.data.onlnPltfrmAuthrtList);	// 온라인플랫폼권한 리스트 HTML 생성

    					authrtListTable.clearData();
    					authrtListTable.replaceData(authrtData);

    					let userData = createOnlnPltfrmUserListHTML(data.data.resultDTO.returnList);		// 온라인플랫폼사용자 리스트 HTML 생성

    					userListTable.clearData();
    					userListTable.replaceData(userData);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='exam.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		// 온라인플랫폼권한 리스트 HTML 생성
		function createOnlnPltfrmAuthrtListHTML(authrtList) {
			let dataList = [];

			$("#authrtRegistBtn").toggle(authrtList.length == 0);
			if(authrtList.length == 0) {
				return dataList;
			} else {
				authrtList.forEach(function(v,i) {
					let manage  = "<a href='javascript:admAcntRegistPopup(\"" + v.onlnPltfrmStngId + "\")' class='btn basic small'>수정</a>";
						manage += "<a href='javascript:admAcntDelete(\"" + v.onlnPltfrmStngId + "\")' class='btn basic small'>삭제</a>";

					dataList.push({
						no: 		v.lineNo,
						orgnm: 		v.orgnm,
						authrtEml: 	v.authrtEml,
						manage: 	manage
					});
				});
			}

			return dataList;
		}

		// 온라인플랫폼사용자 리스트 HTML 생성
		function createOnlnPltfrmUserListHTML(userList) {
			let dataList = [];

			if(userList.length == 0) {
				$("#userCnt").text("0");
				return dataList;
			} else {
				userList.forEach(function(v,i) {
					if(i == 0) $("#userCnt").text(v.totalCnt);
					dataList.push({
						no: 			v.lineNo,
						orgnm: 			v.orgnm,
						pltfrmUserEml: 	v.pltfrmUserEml
					});
				});
			}

			return dataList;
		}

		// 관리자계정등록팝업
		function admAcntRegistPopup(onlnPltfrmStngId) {
			const data = "orgId="+$("#orgId").val()+"&pltfrmGbncd=ZOOM&onlnPltfrmStngId="+onlnPltfrmStngId;

			dialog = UiDialog("dialog1", {
				title	: "ZOOM 관리자계정 등록",
				width	: 800,
				height	: 450,
				url		: "/smnr/pltfrm/admAcntRegistPopup.do?"+data
			});
		}

		// 관리자계정삭제
		function admAcntDelete(onlnPltfrmStngId) {
			createZoomCntSelect(onlnPltfrmStngId).done(function(result) {
				if(result > 0) {
					UiComm.showMessage("생성된 ZOOM이 있어 삭제 할 수 없습니다.", "info");
					return;
				} else {
					UiComm.showMessage("계정을 삭제하시겠습니까?", "confirm")
					.then(function(result) {
						if (result) {
							const url   = "/smnr/pltfrm/admOnlnPltfrmAdmAcntDeleteAjax.do";
							const param = {
								onlnPltfrmStngId	: onlnPltfrmStngId
							};

							ajaxCall(url, param, function(data) {
								if (data.result > 0) {
									UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
									onlnPltfrmAuthrtListSelect(1);
							    } else {
							      	UiComm.showMessage(data.message, "error");
							    }
							}, function(xhr, status, error) {
								UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
							}, true);
						}
					});
				}
			});
		}

		// 생성ZOOM수조회
		function createZoomCntSelect(onlnPltfrmStngId) {
			let deferred = $.Deferred();

			const url  = "/smnr/pltfrm/admCreateZoomCntSelectAjax.do";
			const data = {
				onlnPltfrmStngId	: onlnPltfrmStngId
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result >= 0) {
					deferred.resolve(data.result);
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        		deferred.reject();
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
				deferred.reject();
			}, true);

			return deferred.promise();
		}

		// ZOOM권한목록동기화
		function zoomAuthrtListSync() {
			if(authrtListTable.getDataCount() == 0) {
				UiComm.showMessage('관리자계정이 없습니다.', "info");
				return;
			}

			const data = "orgId="+$("#orgId").val()+"&pltfrmGbncd=ZOOM";

			dialog = UiDialog("dialog1", {
				title	: "ZOOM에서 가져오기",
				width	: 800,
				height	: 450,
				url		: "/smnr/pltfrm/admZoomAuthrtListSyncPopup.do?"+data
			});
		}
	</script>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="search-typeB">
                        	<!-- 슈퍼관리자인경우 선택가능하게 미작업 -->
                            <div class="item">
                                <span class="item_tit"><label for="orgId">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="orgId" onchange="onlnPltfrmAuthrtListSelect(1)">
                                    	<c:forEach var="org" items="${orgList }">
                                    		<option value="${org.orgId }" ${org.orgId eq userCtx.orgId ? 'selected' : '' }>${org.orgnm }</option>
                                    	</c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" placeholder="사용 계정 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="onlnPltfrmAuthrtListSelect(1)">검색</button>
                            </div>
                        </div>

						<div id="authrtDiv">
							<div class="board_top">
								<h3>관리자계정</h3>
								<button type="button" class="btn type1 small right-area" id="authrtRegistBtn" onclick="admAcntRegistPopup('')">ZOOM 관리자계정 등록</button>
							</div>

							<div id="authrtList"></div>

							<script>
								// 리스트 테이블
								let authrtListTable = UiTable("authrtList", {
									lang: "ko",
									columns: [
										{title:"No", 			field:"no",				headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"기관", 			field:"orgnm",			headerHozAlign:"center", 	hozAlign:"left",	width:130,		minWidth:130},
										{title:"ZOOM 관리자계정", 	field:"authrtEml",		headerHozAlign:"left", 		hozAlign:"left",	width:0,		minWidth:150},
										{title:"관리", 			field:"manage", 		headerHozAlign:"center", 	hozAlign:"center",	width:150,		minWidth:150},
									]
								});
							</script>
						</div>

						<div id="userDiv" class="margin-top-3">
							<div class="board_top">
								<h3>라이선스</h3>
								<p>( 총건수 : <span id="userCnt">0</span>건 )</p>
								<div class="right-area">
									<button type="button" class="btn type1 small" id="authrtRegistBtn" onclick="zoomAuthrtListSync()">ZOOM에서 가져오기</button>
									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale }" />
								</div>
							</div>

							<div id="userList"></div>

							<script>
								// 리스트 테이블
								let userListTable = UiTable("userList", {
									lang: "ko",
									pageFunc: onlnPltfrmAuthrtListSelect,
									columns: [
										{title:"No", 		field:"no",					headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"기관", 		field:"orgnm",				headerHozAlign:"center", 	hozAlign:"left",	width:130,		minWidth:130},
										{title:"사용 계정", 	field:"pltfrmUserEml",		headerHozAlign:"left", 		hozAlign:"left",	width:0,		minWidth:150}
									]
								});
							</script>
						</div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>