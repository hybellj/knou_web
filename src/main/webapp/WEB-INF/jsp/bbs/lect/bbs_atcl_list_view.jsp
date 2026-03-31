<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

			if(bbsCommon.isStudent()) {
				if(BBS_CD == "TEAM") {
					// 팀 게시판 ID ',' 구분자
					BBS_IDS = '<c:out value="${teamBbsIds}" />';
				} else {
					BBS_IDS = BBS_ID;
				}
			} else {
				if(BBS_CD == "ALARM") {
					BBS_IDS = '<c:out value="${alarmBbsIds}" />';
				} else if(BBS_CD == "TEAM") {
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
				//changeBbsTerm(PAGE_INDEX);
				listPaging(PAGE_INDEX);
			} else {
				listPaging(PAGE_INDEX);
			}
		});

		// 팀분류 Select 변경
		function changeTeamCtgr(teamCtgrCd) {
			$("#teamCd").empty();
			$("#teamCd").off("change");

			if(teamCtgrCd == "all") {
				$("#teamCd").dropdown("clear");
				BBS_IDS = '<c:out value="${teamBbsIds}" />';
				listPaging(1);
				return;
			}

			var url = "/bbs/bbsLect/listTeamBbsId.do";
			var data = {
				teamCtgrCd: teamCtgrCd
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					var studentYn = bbsCommon.isStudent();
					var firstText = "";

					var teamCtgrBbsIdList = [];

					returnList.forEach(function(v, i) {
						if(v.bbsId) {
							teamCtgrBbsIdList.push(v.bbsId);
						}
	        		});

					returnList.forEach(function(v, i) {
						if(i == 0 && studentYn != "Y") {
							html += '<option value="all" data-bbs-id="' + teamCtgrBbsIdList.join(",") + '"><spring:message code="common.all" /></option>';
						}

						if(i == 0) {
							firstText = v.teamNm;
						}

	        			html += '<option value="' + v.teamCd + '" data-bbs-id="' + (v.bbsId || '') + '">' + v.teamNm + '</option>';
	        		});

					$("#teamCd").html(html);
	        		$("#teamCd").dropdown("clear");
	        		$("#teamCd").on("change", function() {
	        			listPaging(1);
	       			});

	        		if(studentYn == "Y") {
	        			$("#teamCd").dropdown("set text", firstText);
	        		}

	        		if(returnList.length == 0) {
	            		$("#atclListArea").empty().html(createEmptyListHtml());
	        			$("#atclList").footable();
	        		} else {
	        			BBS_IDS = teamCtgrBbsIdList.join(",");
	        			listPaging(1);
	        		}
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}

		// 게시글 조회
		function listPaging(pageIndex) {
			ORG_ID       = $("#orgId").val();
			SEARCH_SDTTM = $("#searchSdttm").val();
			SEARCH_EDTTM = $("#searchEdttm").val();
			SEARCH_VALUE = $("#searchValue").val();
			PAGE_INDEX = pageIndex;

			var extData = {
					pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, orgId         : ORG_ID
					, searchSdttm   : SEARCH_SDTTM
					, searchEdttm   : SEARCH_EDTTM
					, searchValue 	: $("#searchValue").val()
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do"
			var param = {
				  encParams		: EPARAM
				, addParams		: UiComm.makeEncParams(extData)
			};

			UiComm.showLoading(true);

			ajaxCall(url, param, function(data) {
				if (data.encParams != null && data.encParams != '') {
					EPARAM = data.encParams;
				}

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


		// 조회자 목록 모달
		function viewerListModal(crsCreCd, atclId) {
			$("#viewerListForm > input[name='crsCreCd']").val(crsCreCd);
			$("#viewerListForm > input[name='atclId']").val(atclId);
			$("#viewerListForm").attr("target", "viewerListModalIfm");
	        $("#viewerListForm").attr("action", "/bbs/bbsLect/popup/viewerList.do");
	        $("#viewerListForm").submit();
	        $('#viewerListModal').modal('show');

	        $("#viewerListForm > input[name='crsCreCd']").val("");
			$("#viewerListForm > input[name='atclId']").val("");
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
					/* var isLabelAtcl = v.noticeYn == "Y" || v.imptYn == "Y" || ((v.bbsCd == "QNA" || v.bbsCd == "SECRET") && v.answerYn == "N"); */
					var isLabelAtcl = v.optnCd == "FIX" || v.optnCd == "IMPT";
					var atclLabel = "";
					var atclLabelColor = "";

					if(bbsTycd == "QNA") {
						atclLabel = "Q";
						atclLabelColor = "purple";
					} else if (bbsTycd == "SECRET") {
						atclLabel = "1:1";
						atclLabelColor = "deepblue1";
					} else {
						if(v.optnCd == "FIX") {
							atclLabel = '<spring:message code="bbs.label.fix" />'; // 고정
							atclLabelColor = "brown";
						} else if(v.optnCd == "IMPT") {
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
					var linkUrl = 'javascript:viewAtcl(\''+v.atclId+'\')';

					let col0 = "";
					let title = "";
					let colLabel = "";
					if(isLabelAtcl) {
						if(v.optnCd == 'FIX') {
							col0 += '	<label class="label s_c01">' + atclLabel + '</label>';
						} else {
							col0 += '	<label class="label s_c02">' + atclLabel + '</label>';
						}
						colLabel = col0;
					} else {
						col0 = lineNo;
					}

					title += '<a href="'+linkUrl+'" title="'+atclTtl+'">';
					title += atclTtl + (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y" ? ' <i class="xi-new icon" aria-hidden="true"></i>' : '') + ansIcon;
					title += '</a>';

					dataList.push({
						no: col0,
						atclTtl: title,
						regDttm: v.regDttm,
						rgtrnm: v.rgtrnm,
						attach: v.fileCnt > 0 ? "<i class='icon-svg-paperclip' aria-hidden='true'></i>" : "",
						inqCnt: v.inqCnt,
						cmntCnt: v.cmntCnt,
						valAtclId: v.atclId,
						label: colLabel
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

		function loadLctrPlandocPopView(sbjctId) {
		    fetch('/lctr/plandoc/profLctrPlandocPopView.do?sbjctId=' + encodeURIComponent(sbjctId))
		        .then(response => response.text())
		        .then(data => {
		            const div = document.getElementById('lecturePlanDoc');
		            div.style.display = "block";
		            div.style.position = "fixed";
		            div.style.top = "50%";
		            div.style.left = "50%";
		            div.style.width = "800px";
		            div.style.maxHeight = "80vh";
		            div.style.overflow = "auto";
		            div.style.zIndex = "9999";
		            div.style.background = "#fff";
		            div.style.padding = "20px";
		            div.style.transform = "translate(-50%, -50%)";
		            div.innerHTML = data;
		        })
		        .catch(error => {
		            document.getElementById('lecturePlanDoc').innerHTML = '에러 발생';
		            console.error(error);
		        });
		}


		function loadLessonProgressManage(sbjctId) {
		    fetch('/lesson/lessonMgr/lessonProgressManage.do?sbjctId=' + encodeURIComponent(sbjctId))
		        .then(response => response.text())
		        .then(data => {
		            const div = document.getElementById('lessonProgressManagePopView');
		            div.style.display = "block";
		            div.style.position = "fixed";
		            div.style.top = "50%";
		            div.style.left = "50%";
		            div.style.width = "800px";
		            div.style.maxHeight = "80vh";
		            div.style.overflow = "auto";
		            div.style.zIndex = "9999";
		            div.style.background = "#fff";
		            div.style.padding = "20px";
		            div.style.transform = "translate(-50%, -50%)";
		            div.innerHTML = data;
		        })
		        .catch(error => {
		            document.getElementById('lessonProgressManagePopView').innerHTML = '에러 발생';
		            console.error(error);
		        });
		}
	</script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
<div style="display:none;" id="lecturePlanDoc"></div>
<div style="display:none;" id="lessonProgressManagePopView"></div>
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
	                            <h4 class="sub-title">공지사항</h4>
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

	                        	<!-- <div class="item">
	                        		<span class="item_tit"><label for="selectSdttm">조회기간</label></span>
		                        	<input type="text" id="searchSdttm" name="searchSdttm" class="datepicker" toDate="searchEdttm">
									<span class="txt-sort">~</span>
									<input type="text" id="searchEdttm" name="searchEdttm" class="datepicker" fromDate="searchSdttm">
								</div> -->
	                        	<%-- <div class="item">
	                        		<span class="item_tit"><label for="selectOrg">기관</label></span>
		                        	<select class="ui dropdown" id="orgId">
									   <option value=""><spring:message code="bbs.label.org" /></option>
									   <c:forEach var="list" items="${filterOptions.orgList}">
									       <option value="${list.orgId}">${list.orgnm}</option>
									   </c:forEach>
									</select>
							    </div> --%>

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
		                            <h3 class="board-title">공지사항</h3>
		                            <div class="right-area">
										<button type="button" class="btn type2" onclick="checkSelect()" style="white-space: nowrap;">선택데이터확인</button>
		                                <button type="button" class="btn type1" style="white-space: nowrap;" onclick="moveWriteAtcl()"><spring:message code="bbs.button.write" /></button><%-- 글쓰기 --%>

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
									//tableMode: "list",
									//rowHeight: 30,
									//height: 400,
									//selectRow: "checkbox",
									//selectRow: "1",
									//selectRowFunc: checkRowSelect,
									sortFunc: atclListTableSort,
									initialSort: [{column:"regDate", dir:"desc"}],
									pageFunc: listPaging,
									columns: [
										{title:"No", 											field:"no",			headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// No
										{title:"<spring:message code='bbs.label.form_title'/>", field:"atclTtl",	headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200, 	headerSort:true},	// 제목
										{title:"<spring:message code='bbs.label.reg_date'/>", 	field:"regDttm", 	headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100,	headerSort:true,	formatter:"date"},	// 등록일자
										{title:"<spring:message code='bbs.label.reg_user'/>", 	field:"rgtrnm", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 작성자
										{title:"<spring:message code='bbs.label.attach'/>", 	field:"attach", 	headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// 첨부
										{title:"<spring:message code='bbs.label.view'/>", 		field:"inqCnt", 	headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// 조회
										{title:"<spring:message code='bbs.label.comment'/>", 	field:"cmntCnt", 	headerHozAlign:"center", hozAlign:"center",	width:60,	minWidth:60},	// 댓글
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