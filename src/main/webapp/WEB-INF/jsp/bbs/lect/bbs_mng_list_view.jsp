<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>

<html lang="ko">
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="${
				templateUrl eq 'bbsHome' ? 'dashboard'
				: templateUrl eq 'bbsLect' ? 'classroom'
				: templateUrl eq 'bbsMgr' ? 'classroom' : ''}"/>
			<jsp:param name="module" value="table"/>
	</jsp:include>

	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		var USER_ID 		= '<c:out value="${USER_ID}" />';
		var BBS_CD 			= '<c:out value="${bbsVO.bbsTycd}" />';
		var TEAM_CTGR_CD	= '<c:out value="${param.teamCtgrCd}" />';
		var TEAM_CD			= '<c:out value="${param.teamCd}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${bbsVO.pageIndex}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;

		// 사용값
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var EPARAM			= '<c:out value="${encParams}" />';

		$(document).ready(function() {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});

			listPaging(1);
		});

		// 게시글 조회
		function listPaging(pageIndex) {
			ORG_ID       = $("#orgId").val();
			SEARCH_VALUE = $("#searchValue").val();
			PAGE_INDEX = pageIndex;

			var extData = {
					pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, orgId         : ORG_ID
					, searchValue 	: $("#searchValue").val()
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsMngList.do"
			var param = {
				  encParams		: EPARAM
				, addParams		: UiComm.makeEncParams(extData)
			};

			UiComm.showLoading(true);

			ajaxCall(url, param, function(data) {
				if (data.encParams != null && data.encParams != '') {
					EPARAM = data.encParams;
				}
				console.log(data.returnList)
				if (data.result > 0) {
	        		let returnList = data.returnList || [];

	        		// 테이블 데이터 설정
	        		let dataList = createAtclListHTML(returnList, data.pageInfo);
	        		atclListTable.clearData();
	        		atclListTable.replaceData(dataList);
	        		atclListTable.setPageInfo(data.pageInfo);


	        		//let frameId = window.frameElement ? window.frameElement.id : "";
	        		//parent.resizeIframe(frameId);
	            } else {
	             	showMessage(data.message, "error"); // 에러가 발생했습니다!
	            }
			}, function(xhr, status, error) {
				showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
			}, true);
		}

		// 글쓰기
		function moveWriteAtcl() {
			document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsAtclWrite.do?encParams="+EPARAM;
		}

		// 게시글 리스트 생성
		function createAtclListHTML(atclList, pageInfo) {
			let dataList = [];

			if(atclList.length == 0) {
				return dataList;
			} else {
				var bbsTycd = '<c:out value="${bbsInfoVO.bbsTycd}" />';
				atclList.forEach(function(v, i) {
					var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

					let atflUseynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyAtflUseyn(this, \'' + v.lineNo + '\', this.checked)"';
		            if (v.atflUseyn === 'Y') {
		            	atflUseynHtml += '	checked="checked">';
		            } else {
		            	atflUseynHtml += '>';
		            }

					var mngHtml = "";
		            mngHtml += "<a href=\"javascript:moveAtclBbs('" + v.lineNo + "')\" class=\"btn basic small\"><spring:message code='bbs.button.move_bbs'/></a>";

					dataList.push({
						no: v.lineNo,
						bbsNm: v.bbsNm,
						bbsGbn: v.bbsAddyn == 'Y' ? "추가" : "고정",
						bbsOptnNm: v.bbsOptnNm,
						fileCnt: v.fileCnt,
						atflMaxSz: v.atflMaxSz,
						atclCnt: v.atclCnt,
						atflUseyn: v.atflUseyn == 'Y' ? "사용" : "미사용",
						regDttm: v.regDttm,
						mng: mngHtml
					});
				});

				return dataList;
			}
		}

		// 게시글 보기
		function viewAtcl(atclId) {
			let extData = {
				atclId	: atclId
			};

			document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);
		}


		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			listPaging(1);
		}
	</script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
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
				<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<!-- class_sub -->
				<div class="class_sub">
					<div class="dashboard_sub">

	                    <div class="sub-content">
	                        <div class="page-info">
	                            <h4 class="sub-title">게시판 관리</h4>
	                            <div class="navi_bar">
	                                <ul>
	                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
	                                    <li>공통</li>
	                                    <li><span class="current">레이아웃</span></li>
	                                </ul>
	                            </div>
	                        </div>

	                        <!-- search typeA -->
	                        <div class="search-typeA">

	                            <div class="item">
	                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>

	                                <div class="itemList">
	                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${param.searchValue}" placeholder="<spring:message code='bbs.common.placeholder'/>"><%-- 작성자/제목/키워드 --%>
	                                </div>
	                            </div>
	                            <div class="button-area">
	                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
	                            </div>
	                        </div>

							<div id="atclListArea">
								<div class="board_top">
		                            <h3 class="board-title">게시판 관리</h3>
		                            <div class="right-area">
		                                <button type="button" class="btn type1" style="white-space: nowrap;" onclick="moveWriteAtcl()"><spring:message code="bbs.label.bbs_add" /></button><%-- 글쓰기 --%>

										<%-- 리스트/카드 선택 버튼 --%>
										<span class="list-card-button"></span>

										<%-- 목록 스케일 선택 --%>
										<uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
		                            </div>
		                        </div>

								<%-- 게시글 리스트 --%>
								<div id="atclList"></div>

								<%-- 게시글 리스트 카드 폼 --%>
								<div id="atclList_cardForm" style="display:none">
									<div class="card-header">
										#[label]
										<div class="card-title">
											#[atclTtl]
										</div>
									</div>

									<div class="card-body">
										<div class="desc">
											<p><label class="label-title"><spring:message code='bbs.label.reg_date'/></label><strong>#[regDttm]</strong></p>
											<p><label class="label-title"><spring:message code='bbs.label.reg_user'/></label><strong>#[rgtrnm]</strong></p>
										</div>
										<div class="etc">
											<p><label class="label-title"><spring:message code='bbs.label.attach'/></label><strong>#[attach]</strong></p>
											<p><label class="label-title"><spring:message code='bbs.label.view'/></label><strong>#[inqCnt]</strong></p>
											<p><label class="label-title"><spring:message code='bbs.label.comment'/></label><strong>#[cmntCnt]</strong></p>
										</div>
									</div>

									<!-- <div class="bottom_button">
										<button class="btn basic small">상세</button>
									</div> -->
								</div>

								<script>
								// 게시글 리스트 테이블
								let atclListTable = UiTable("atclList", {
									lang: "ko",
									sortFunc: atclListTableSort,
									initialSort: [{column:"regDate", dir:"desc"}],
									pageFunc: listPaging,
									columns: [
										{title:"No", 											field:"no",			    headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// No
										{title:"<spring:message code='bbs.label.bbs_name'/>",   field:"bbsNm",	        headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100, 	headerSort:true},	// 게시판명
										{title:"<spring:message code='bbs.label.type'/>",       field:"bbsGbn",	        headerHozAlign:"center", hozAlign:"left",	width:120,	minWidth:60, 	headerSort:true},	// 구분
										{title:"<spring:message code='bbs.label.option'/>",     field:"bbsOptnNm",	    headerHozAlign:"center", hozAlign:"left",	width:120,	minWidth:60, 	headerSort:true},	// 옵션
										{title:"<spring:message code='bbs.label.file_num'/>",   field:"fileCnt",	    headerHozAlign:"center", hozAlign:"left",	width:120,	minWidth:60, 	headerSort:true},	// 파일수
										{title:"<spring:message code='bbs.label.size_limit'/>", field:"atflMaxSz",	    headerHozAlign:"center", hozAlign:"left",	width:120,	minWidth:60, 	headerSort:true},	// 용량제한
										{title:"<spring:message code='bbs.label.atcl_cnt'/>",   field:"atclCnt",	    headerHozAlign:"center", hozAlign:"left",	width:120,	minWidth:60, 	headerSort:true},	// 게시글수
										{title:"<spring:message code='bbs.label.use_yn'/>",     field:"atflUseyn",	    headerHozAlign:"center", hozAlign:"left",	width:120,	minWidth:60, 	headerSort:true},	// 사용여부
										{title:"<spring:message code='bbs.label.reg_date'/>", 	field:"regDttm", 	    headerHozAlign:"center", hozAlign:"center", width:120, 	minWidth:100,	headerSort:true,	formatter:"date"},	// 등록일자
										{title:"<spring:message code='bbs.label.manage'/>", 	field:"mng", 	        headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:100},	// 작성자
									]
								});


								function atclListTableSort(sortInfo) {
									console.log("field="+sortInfo.field+", dir="+sortInfo.dir);

									listPaging(1);
								}

								function checkSelect() {
									// 선택된값 array로 가져온다.
									let data = atclListTable.getSelectedData("valAtclId"); // "valAtclId" 키로 설정된 값
									alert(data);
								}

								function checkRowSelect(data) {
									let value = data["valAtclId"]; // "valAtclId" 키로 설정된 값
									alert(value);
								}

								</script>
							</div>
	                    </div>
                	</div>
				</div>
				<!-- //class_sub -->

			</div>
			<!-- //content -->
        </main>
        <!-- //main-->
    </div>
    <!-- //div main -->
</body>
</html>