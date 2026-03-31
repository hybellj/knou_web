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
		var USER_ID 		= '<c:out value="${USER_ID}" />';
		var HAKSA_YEAR 		= '<c:out value="${vo.haksaYear}" />';
		var HAKSA_TERM		= '<c:out value="${vo.haksaTerm}" />';
		var BBS_CD 			= '<c:out value="${vo.bbsTycd}" />';
		var CRS_CRE_CD		= '<c:out value="${param.crsCreCd}" />';
		var TEAM_CTGR_CD	= '<c:out value="${param.teamCtgrCd}" />';
		var TEAM_CD			= '<c:out value="${param.teamCd}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var BBS_ID 			= '<c:out value="${vo.bbsId}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;
		var BBS_HOME_UNIV_GBNS = ""; // bbsHome 의 전체공지 조회용 대학구분 코드
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
				  crsCreCd: CRS_CRE_CD
				, teamCtgrCd: teamCtgrCd
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
			SEARCH_VALUE = $("#searchValue").val();
			PAGE_INDEX = pageIndex;

			var extData = {
					pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, searchValue 	: SEARCH_VALUE
					, haksaYear		: $("#haksaYear").val()
					, haksaTerm		: $("#haksaTerm").val()
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclList.do"
			var param = {
				  encParams		: EPARAM
				, addParams		: makeExtParam(extData)
			};

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
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}

		// 글쓰기
		function moveWriteAtcl() {
			var queryInfo = {};

			if(BBS_CD) {
				queryInfo.bbsId = BBS_CD;
			}

			if(CRS_CRE_CD) {
				queryInfo.crsCreCd = CRS_CRE_CD;
			}

			if(BBS_CD == "TEAM" && $("#teamCtgrCd").val() && $("#teamCd").val()) {
				queryInfo.teamCtgrCd = $("#teamCtgrCd").val();
				queryInfo.teamCd	 = $("#teamCd").val();
			}

			if(BBS_CD != "TEAM") {
				queryInfo.bbsId = BBS_IDS.split(",")[0];
			}

			if(SEARCH_VALUE) {
				queryInfo.searchValue	= SEARCH_VALUE;
			}

			if(PAGE_INDEX) {
				queryInfo.pageIndex		= PAGE_INDEX;
			}

			if(LIST_SCALE) {
				queryInfo.listScale		= LIST_SCALE;
			}

			if(TAB) {
				queryInfo.tab = TAB;
			}

			var url = "/bbs/" + TEMPLATE_URL + "/Form/atclWrite.do";
			var queryStr = new URLSearchParams(queryInfo).toString();

			bbsCommon.movePost(url, queryStr);
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
				return listData;
			} else {
				var bbsTycd = '<c:out value="${bbsInfoVO.bbsTycd}" />';
				atclList.forEach(function(v, i) {
					console.log(pageInfo.totalRecordCount+", "+i+", "+v.lineNo);

					var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
					var isLabelAtcl = v.noticeYn == "Y" || v.imptYn == "Y" || ((v.bbsCd == "QNA" || v.bbsCd == "SECRET") && v.answerYn == "N");
					var atclLabel = "";
					var atclLabelColor = "";

					if(bbsTycd == "QNA") {
						atclLabel = "Q";
						atclLabelColor = "purple";
					} else if (bbsTycd == "SECRET") {
						atclLabel = "1:1";
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

					var addParams = makeExtParam({
						atclId: v.atclId,
						pageIndex: PAGE_INDEX,
						listScale: LIST_SCALE
					});

					if(bbsCommon.isStudent() && v.bbsCd == "SECRET" && v.rgtrId != USER_ID) {
						var linkUrl = 'javascript:alert(' + '<spring:message code="bbs.alert.no_auth_secret" />' + ')'; // 1:1상담 게시글 입니다.
					} else {
						var linkUrl = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do?encParams="+EPARAM+"&addParams="+addParams;
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
					title += 			atclTitleStr + (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y" ? '<i class="text-new"><spring:message code="bbs.label.new_atcl" /></i>' : '') + ansIcon;
					title += '</a>';

					let attach = "";
					if(v.atchUseYn == 'Y' && v.atchFileCnt > 0) {
						attach += '<i class="xi-file-o f120"></i><span class="hide">file</span>';
					}

					dataList.push({
						no: col0,
						title: title,
						regDate: v.regDttm,
						regNm: v.rgtrnm,
						attach: attach,
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

<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
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

                    <!-- page_tab -->
                    <%@ include file="/WEB-INF/jsp/common_new/home_page_tab.jsp" %>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">공지사항</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공통</li>
                                    <li><span class="current">레이아웃</span></li>
                                </ul>
                            </div>
                        </div>


								<div id="atclListArea">
									<div class="board_top">
			                            <h3 class="board-title">게시글 목록</h3>
			                            <div class="right-area">
 											<button type="button" class="btn type2" onclick="checkSelect()" style="white-space: nowrap;">선택데이터확인</button>
			                                <button type="button" class="btn type2" style="white-space: nowrap;">등록</button>

											<%-- 리스트/카드 선택 버튼 --%>
											<span class="list-card-button"></span>

											<%-- 목록 스케일 선택 --%>
											<uiex:listScale func="changeListScale" value="${vo.listScale}" />
			                            </div>
			                        </div>

									<%-- 게시글 리스트 --%>
									<div id="atclList"></div>

									<%-- 게시글 리스트 카드 폼 --%>
									<div id="atclList_cardForm" style="display:none">
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
										selectRow: "checkbox",
										//selectRow: "1",
										//selectRowFunc: checkRowSelect,
										sortFunc: atclListTableSort,
										initialSort: [{column:"regDate", dir:"desc"}],
										pageFunc: listPaging,
										columns: [
											{title:"No", 											field:"no",			headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},	// No
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