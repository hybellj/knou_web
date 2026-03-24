<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="${
			templateUrl eq 'bbsHome' ? 'dashboard'
			: templateUrl eq 'bbsLect' ? 'classroom'
			: templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>

	<script type="text/javascript">
		var ORG_ID 			= '<c:out value="${bbsVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var BBS_TYCD 			= '<c:out value="${bbsVO.bbsTycd}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${bbsVO.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;
		var BBS_HOME_UNIV_GBNS = ""; // bbsHome 의 전체공지 조회용 대학구분 코드
		var EPARAM			= '<c:out value="${eparam}" />';
		var ATCL_LV			= 1;

		$(document).ready(function() {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});

			if(bbsCommon.isStudent()) {
				if(BBS_TYCD == "TEAM") {
					// 팀 게시판 ID ',' 구분자
					BBS_IDS = '<c:out value="${teamBbsIds}" />';
				} else {
					BBS_IDS = BBS_ID;
				}
			} else {
				if(BBS_TYCD == "ALARM") {
					BBS_IDS = '<c:out value="${alarmBbsIds}" />';
				} else if(BBS_TYCD == "TEAM") {
					// 팀 게시판 ID ',' 구분자
					BBS_IDS = '<c:out value="${teamBbsIds}" />';
				} else {
					BBS_IDS = BBS_ID;
				}
			}

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			if(TEMPLATE_URL == "bbsHome") {
				listPaging(PAGE_INDEX);
			} else {
				listPaging(PAGE_INDEX);
			}
		});

		// 학기기수 세팅 변경
		function changeSmstrChrt() {
			var $sbjctSmstr = $('#sbjctSmstr');

			$sbjctSmstr.off("change");
			$sbjctSmstr.dropdown("clear");
			$sbjctSmstr.empty();

			let basicOptn = `<option value='ALL'><spring:message code="crs.label.open.term" /></option>`;	// 학기

			$.ajax({
				url  : "/crs/termMgr/smstrListByDgrsYr.do",
				data : {
					dgrsYr 	: $("#sbjctYr").val()
				},
				type : "GET",
				success: function(data) {
					if (data.result > 0) {
						var resultList = data.returnList;
						if (resultList.length > 0) {
							$sbjctSmstr.append(basicOptn);
							$.each(resultList, function(i, smstrChrtVO) {
								$sbjctSmstr.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
							})
						}
					} else {
						UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
					}
				},
				error: function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
				}
			});
		}

		// 게시글 조회
		function listPaging(pageIndex) {
			SEARCH_VALUE = $("#searchValue").val();
			PAGE_INDEX = pageIndex;

			var extData = {
					pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, searchValue 	: SEARCH_VALUE
					, sbjctYr		: $("#sbjctYr").val()
					, sbjctSmstr	: $("#sbjctSmstr").val()
					, orgId			: $("#orgId").val()
					, deptId		: $("#deptId").val()
					, sbjctId		: $("#sbjctId").val()
					, atclLv	    : ATCL_LV
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do";

			var param = {
				  eparam		: EPARAM
				, extParam		: UiComm.makeExtParam(extData)
			};

			ajaxCall(url, param, function(data) {
				if (data.eparam != null && data.eparam != '') {
					EPARAM = data.eparam;
				}

				if (data.result > 0) {
	        		let returnList = data.returnList || [];

	        		// 테이블 데이터 설정
	        		let dataList = createAtclListHTML(returnList, data.pageInfo);
	        		atclListTable.clearData();
	        		atclListTable.replaceData(dataList);
	        		atclListTable.setPageInfo(data.pageInfo);
	            } else {
	            	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
			}, true);
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
					var isLabelAtcl = v.noticeYn == "Y" || v.imptYn == "Y" || ((v.bbsCd == "QNA" || v.bbsCd == "SECRET") && v.answerYn == "N");
					var atclLabel = "";
					var atclLabelColor = "";

					if(bbsTycd == "QNA") {
						atclLabel = "Q";
						atclLabelColor = "purple";
					} else if (bbsTycd == "SECRET") {
						atclLabel = "1:1상담";
						atclLabelColor = "deepblue1";
					} else {
						if(v.noticeYn == "Y") {
							atclLabel = '<spring:message code="bbs.label.fix" />'; // 고정
							atclLabelColor = "brown";
						} else if(v.imptYn == "Y") {
							atclLabel = '<spring:message code="bbs.label.impt" />'; // 중요
							atclLabelColor = "red";
						}
					}

					// 문의/상담 게시판 답변, 미답변 아이콘 추가
					var ansIcon = "";

					if(bbsTycd == "QNA" || bbsTycd == "SECRET") {
						if(v.answerYn == "Y") {
							ansIcon = '<small class="ml10 f080"><span style="background:#21BA45;color:#fff;padding:0 5px;"><spring:message code="bbs.label.answer" /></span></small>'; // 답변
						} else {
							ansIcon = '<small class="ml10 f080"><span style="background:#F2711C;color:#fff;padding:0 5px;"><spring:message code="bbs.label.no_answer" /></span></small>'; // 미답변
						}
					}

					var atclTtl = v.atclTtl.replaceAll("<", "&lt").replaceAll(">", "&gt");

					// 비공개글 스타일 추가
					if(v.lockYn == "Y") {
						atclTtl = '<span class="fcGrey" style="text-decoration: line-through">' + atclTtl + '</span>';
					}

					var extParam = UiComm.makeExtParam({
						atclId: v.atclId,
						pageIndex: PAGE_INDEX,
						listScale: LIST_SCALE
					});

					if(bbsCommon.isStudent() && v.bbsCd == "SECRET" && v.regNo != USER_NO) {
						var linkUrl = 'javascript:alert(' + '<spring:message code="bbs.alert.no_auth_secret" />' + ')'; // 1:1상담 게시글 입니다.
					} else {
						var linkUrl = "/bbs/" + TEMPLATE_URL + "/bbsLctrQnaView.do?eparam="+EPARAM+"&extParam="+extParam;
					}
					var isSingleTab = BBS_IDS && BBS_IDS.split(",").length == 1;

					let col0 = "";
					let title = "";
					let colLabel = "";

					if(isLabelAtcl) {
						col0 += '	<label class="ui mini label tc ' + atclLabelColor + '">' + atclLabel + '</label>';
						colLabel = col0;
					} else {
						col0 = lineNo;
					}
					if(bbsTycd == "SECRET" && bbsCommon.isTutor()) {
						// 접근권한이 없는 게시글 입니다.
						title += '<a href="javascript:void(0)" onclick="alert(\'<spring:message code="bbs.alert.no.auth.atcl" />\')" style="color: currentColor;">';
					} else {
						title += '<a href="'+linkUrl+'" title="'+atclTtl+'">';
					}
					// [팀카테고리명 > 팀명]
					if(bbsTycd == "TEAM") {
						title += '		<span class="fcBlue mr5">[' + v.teamCtgrNm + ' > ' + v.teamNm + ']</span>';
					}
					// [게시판명]
					else if(!isSingleTab) {
						title += '		<span class="fcBlue mr5">[' + v.bbsNm + ']</span>';
					}

					var viewYn = v.viewYn;
					if(bbsCommon.isStudent() && (bbsTycd == "SECRET" || bbsTycd == "QNA")) {
						viewYn = v.ansViewYn;
					}

					var atclTitleStr = viewYn == "Y" ? "<span class='fcGrey'>"+atclTtl+"</span>" : atclTtl;
					title += 			atclTitleStr + (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y" ? ' <i class="xi-new icon" aria-hidden="true"></i>' : '') + ansIcon;
					title += '</a>';

					let attach = "";
					if(v.atchUseYn == 'Y' && v.atchFileCnt > 0) {
						attach += '<i class="xi-file-o f120"></i><span class="hide">file</span>';
					}

					dataList.push({
						no: col0,
						orgnm: v.orgnm,
						deptnm: v.deptnm,
						sbjctnm: v.sbjctnm,
						dvclasNo: v.dvclasNo,
						title: title,
						regDate: v.regDttm,
						regNm: v.rgtrnm,
						attach: v.fileCnt > 0 ? "<i class='icon-svg-paperclip' aria-hidden='true'></i>" : "",
						hits: v.inqCnt,
						comment: v.cmntCnt,
						valAtclId: v.atclId,
						label: colLabel
					});
				});

				return dataList;
			}
		}

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			listPaging(1);
		}

	</script>
</head>

<body class="home colorA ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/home_gnb_prof.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">강의Q&A</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의Q&A</li>
                                    <li><span class="current">강의Q&A</span></li>
                                </ul>
                            </div>
                        </div>

						<!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                                <select class="ui dropdown" id="sbjctYr" onchange="changeSmstrChrt()">
									<option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
									<c:forEach var="item" items="${filterOptions.yearList}">
										<option value="${item }" ${item eq curSmstrChrtVO.dgrsYr ? 'selected' : '' }>${item }</option>
									</c:forEach>
								</select>
								<select class="ui dropdown" id="sbjctSmstr"><!-- 개설학기 -->
									<option value=""><spring:message code="crs.label.open.term" /></option>
									<c:forEach var="list" items="${filterOptions.smstrChrtList}">
										<option value="${list.smstrChrtId }">${list.smstrChrtnm }</option>
									</c:forEach>
								</select>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <select class="ui dropdown" id="orgId">
							        <option value=""><spring:message code="bbs.label.org" /></option>
							        <c:forEach var="list" items="${filterOptions.orgList}">
							            <option value="${list.orgId}">${list.orgnm}</option>
							        </c:forEach>
							    </select>

								<select class="ui dropdown" id="deptId">
							        <option value=""><spring:message code="bbs.label.dept" /></option>
							        <c:forEach var="list" items="${filterOptions.deptList}">
							            <option value="${list.deptId}">${list.deptnm}</option>
							        </c:forEach>
							    </select>

							    <select class="ui dropdown" id="sbjctId">
							        <option value=""><spring:message code="bbs.label.sbjct" /></option>
							        <c:forEach var="list" items="${filterOptions.sbjctList}">
							            <option value="${list.sbjctId}">${list.sbjctnm}</option>
							        </c:forEach>
							    </select>
                            </div>
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
	                            <h3 class="board-title">강의Q&A</h3>
	                            <div class="right-area">

	                            	<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
	                            </div>
	                        </div>

							<%-- 게시글 리스트 --%>
							<div id="bbsAtclLctrQnaList"></div>

							<%-- 게시글 리스트 카드 폼 --%>
							<div id="bbsAtclLctrQnaList_cardForm" style="display:none">
								<div class="card-header">
									#[label]
									<div class="card-title">
										#[title]
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title"><spring:message code='bbs.label.reg_date'/></label><strong>#[regDate]</strong></p>
										<p><label class="label-title"><spring:message code='bbs.label.reg_user'/></label><strong>#[regNm]</strong></p>
									</div>
									<div class="etc">
										<p><label class="label-title"><spring:message code='bbs.label.attach'/></label><strong>#[attach]</strong></p>
										<p><label class="label-title"><spring:message code='bbs.label.view'/></label><strong>#[hits]</strong></p>
										<p><label class="label-title"><spring:message code='bbs.label.comment'/></label><strong>#[comment]</strong></p>
									</div>
								</div>
							</div>

							<script>
							// 게시글 리스트 테이블
							let atclListTable = UiTable("bbsAtclLctrQnaList", {
								lang: "ko",
								pageFunc: listPaging,
								columns: [
									{title:"No", 											field:"no",			headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},	// No
									{title:"<spring:message code='bbs.label.org'/>", 		field:"orgnm",		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:40},	// 기관
									{title:"<spring:message code='bbs.label.dept'/>", 		field:"deptnm",		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:40},	// 학과
									{title:"<spring:message code='bbs.label.sbjct'/>", 		field:"sbjctnm",	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:40},	// 과목
									{title:"<spring:message code='bbs.label.class'/>", 		field:"dvclasNo",	headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:40},	// 분반
									{title:"<spring:message code='bbs.label.form_title'/>", field:"title",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200, 	headerSort:true},	// 제목
									{title:"<spring:message code='bbs.label.reg_date'/>", 	field:"regDate", 	headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100,	headerSort:true,	formatter:"date"},	// 등록일자
									{title:"<spring:message code='bbs.label.reg_user'/>", 	field:"regNm", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 작성자
									{title:"<spring:message code='bbs.label.attach'/>", 	field:"attach", 	headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// 첨부
									{title:"<spring:message code='bbs.label.view'/>", 		field:"hits", 		headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// 조회
									{title:"<spring:message code='bbs.label.comment'/>", 	field:"comment", 	headerHozAlign:"center", hozAlign:"center",	width:60,	minWidth:60},	// 댓글
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

							function changePage(page) {
								alert("페이지 "+page);
							}

							</script>
						</div>
                    </div>

                </div>
            </div>
            <!-- //content -->

            <!-- common footer -->
            <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>