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
		var ORG_ID 			= '<c:out value="${bbsVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var BBS_TYCD 		= '<c:out value="${bbsVO.bbsTycd}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${bbsVO.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;
		var BBS_HOME_UNIV_GBNS = ""; // bbsHome 의 전체공지 조회용 대학구분 코드
		var EPARAM			= '<c:out value="${encParams}" />';
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
				//changeBbsTerm(PAGE_INDEX);
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

			var url = "/crs/termMgr/smstrListByDgrsYr.do";
			var data = {
					dgrsYr 	: $("#sbjctYr").val()
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
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
			function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
    		}, true);
		}

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
				UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
			});
		}

		// 게시글 조회
		function listPaging(pageIndex) {
			SEARCH_VALUE = $("#searchValue").val();
			PAGE_INDEX = pageIndex;

			var extData = {
					pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, sbjctYr		: $("#sbjctYr").val()
					, sbjctSmstr	: $("#sbjctSmstr").val()
					, orgId			: $("#orgId").val()
					, deptId		: $("#deptId").val()
					, sbjctId		: $("#sbjctId").val()
					, atclLv	    : ATCL_LV
					, searchValue 	: SEARCH_VALUE
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do"
			var data = {
				  encParams		: EPARAM
				, extParam		: UiComm.makeExtParam(extData)
			};

			ajaxCall(url, data, function(data) {
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
	            	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
			}, true);
		}

		// 글쓰기
		function moveWriteAtcl() {
			var queryInfo = {};

			if(BBS_TYCD) {
				queryInfo.bbsId = BBS_TYCD;
			}

			if(CRS_CRE_CD) {
				queryInfo.crsCreCd = CRS_CRE_CD;
			}

			if(BBS_TYCD == "TEAM" && $("#teamCtgrCd").val() && $("#teamCd").val()) {
				queryInfo.teamCtgrCd = $("#teamCtgrCd").val();
				queryInfo.teamCd	 = $("#teamCd").val();
			}

			if(BBS_TYCD != "TEAM") {
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
				return dataList;
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

					var extParam = UiComm.makeExtParam({
						atclId: v.atclId,
						pageIndex: PAGE_INDEX,
						listScale: LIST_SCALE
					});

					if(bbsCommon.isStudent() && v.bbsCd == "SECRET" && v.regNo != USER_ID) {
						var linkUrl = 'javascript:alert(' + '<spring:message code="bbs.alert.no_auth_secret" />' + ')'; // 1:1상담 게시글 입니다.
					} else {
						var linkUrl = "/bbs/" + TEMPLATE_URL + "/bbsDscsnView.do?encParams="+EPARAM+"&extParam="+extParam;
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

<body class="class colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
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

					<!-- 강의실 상단 -->
					<div class="segment class-area">

						<!-- info-left -->
						<div class="info-left">
							<div class="class_info">
                                <h2>${subjectVM.subjectVO.sbjctnm}</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="javascript:void(0); onclick=loadLctrPlandocPopView('${subjectVM.subjectVO.sbjctId}');" class="btn">강의 계획서</a>
                                        <a href="javascript:void(0); onclick=loadLessonProgressManage('${subjectVM.subjectVO.sbjctId}');" class="btn" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가 기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                	<c:forEach var="item" items="${subjectVM.subjectLearingActvList}">
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>공지</span><div class="num_txt">${item.ntcCnt}</div></a>
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>Q&A</span><div class="num_txt point">${item.qnaCnt}</div></a>
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>1:1</span><div class="num_txt point">${item.oneononeCnt}</div></a>
	                                    <a href="/asmt2/profAsmtListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>과제</span><div class="num_txt">${item.asmtCnt}</div></a>
	                                    <a href="/forum2/forumLect/profForumListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>토론</span><div class="num_txt">${item.dscsCnt}</div></a>
	                                    <a href="/smnr/profSmnrListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>세미나</span><div class="num_txt">${item.smnrCnt}</div></a>
	                                    <a href="/quiz/profQuizListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>퀴즈</span><div class="num_txt">${item.quizCnt}</div></a>
	                                    <a href="/srvy/profSrvyListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>설문</span><div class="num_txt">${item.srvyCnt}</div></a>
	                                    <a href="/exam/profExamListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}" class="info"><span>시험</span><div class="num_txt">${item.examCnt}</div></a>
                                    </c:forEach>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point">
                                            <span class="tit">중간고사:</span>
                                            <span><uiex:formatDate value="${subjectVM.middleLastExam.midExamSdttm}" type="date"/></span>
                                        </p>
                                        <p class="desc">
                                            <span class="tit">시간:</span>
                                            <span>${subjectVM.middleLastExam.midExamMnts}분</span>
                                        </p>
                                    </div>
                                    <div class="info">
                                        <p class="point">
                                            <span class="tit">기말고사:</span>
                                            <span><uiex:formatDate value="${subjectVM.middleLastExam.lstExamSdttm}" type="date"/></span>
                                        </p>
                                        <p class="desc">
                                            <span class="tit">시간:</span>
                                            <span>${subjectVM.middleLastExam.lstExamMnts}분</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
						</div>
						<!--//info-left -->

						<!-- info-right-->
						<div class="info-right">

							<!-- flex -->
							<div class="flex">

								<!-- item user-->
								<div class="item user">
                                    <div class="item_icon"><i class="icon-svg-group" aria-hidden="true"></i></div>

                                    <!-- item_tit -->
                                    <div class="item_tit">
	                                    <a href="#0" class="btn ">접속현황<i class="xi-angle-down-min"></i></a><!-- 접속현황 -->

	                                    <!-- 접속현황레이어팝업-->
	                                    <div class="user-option-wrap">
	                                        <div class="option_head">
	                                            <div class="sort_btn">
	                                                <button type="button">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button><!-- 이름(학생명) -->
	                                                <button type="button">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button><!-- 이름(학생명) -->
	                                            </div>
	                                            <p class="user_num">접속: 37</p><!-- 접속 -->
	                                            <button type="button" class="btn-close" aria-label="접속현황 닫기"><!-- 접속현황닫기 -->
	                                                <i class="icon-svg-close"></i>
	                                            </button>
	                                        </div>
                                            <ul class="user_area"><!-- 현재접속자목록 li loop-->
                                                <li>
                                                    <div class="user-info">
                                                        <div class="user-photo">
                                                            <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"> <!-- 사진 -->
                                                        </div>
                                                        <div class="user-desc">
                                                            <p class="name">나방송</p>
                                                            <p class="subject"><span class="major">[대학원]</span>정보와기술</p> <!-- 대학원 --> <!-- 과목명 -->
                                                        </div>
                                                        <div class="btn_wrap">
                                                            <button type="button"><i class="xi-info-o"></i></button><!-- 정보 -->
                                                            <button type="button"><i class="xi-bell-o"></i></button><!-- 알림 -->
                                                        </div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="user-info">
                                                        <div class="user-photo">
                                                            <img src="/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                        </div>
                                                        <div class="user-desc">
                                                            <p class="name">최남단</p>
                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                        </div>
                                                        <div class="btn_wrap">
                                                            <button type="button"><i class="xi-info-o"></i></button>
                                                            <button type="button"><i class="xi-bell-o"></i></button>
                                                        </div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="user-info">
                                                        <div class="user-photo">
                                                            <img src="/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                        </div>
                                                        <div class="user-desc">
                                                            <p class="name">최남단</p>
                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                        </div>
                                                        <div class="btn_wrap">
                                                            <button type="button"><i class="xi-info-o"></i></button>
                                                            <button type="button"><i class="xi-bell-o"></i></button>
                                                        </div>
                                                    </div>
                                                </li>
                                            </ul>

                                        </div>
                                        <!-- //접속현황레이어팝업-->
                                    </div>
                                    <!-- //item_tit -->

                                    <div class="item_info">
                                        <span class="big">37</span><!-- 현재접속자수 -->
                                        <span class="small">250</span><!-- 전체접속자수 -->
                                    </div>
                                </div>
                                <!-- //item user-->

								<div class="item attend">
                                    <div class="item_icon"><i class="icon-svg-pie-chart-01" aria-hidden="true"></i></div>
                                    <div class="item_tit">7주차 출석 40 / 50</div>
                                    <div class="item_info">
                                        <span class="big">80</span>
                                        <span class="small">%</span>
                                    </div>
                                </div>

								<div class="item week">
                                       <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                       <div class="item_tit">2025.04.14 ~ 04.20</div><!-- 주차기간 -->
                                       <div class="item_info">
                                           <span class="big">7</span><!-- 현재주차 -->
                                           <span class="small">주차</span><!-- 주차 -->
                                       </div>
                                </div>
							</div>
							<!-- //flex -->

						</div>
						<!-- info-right-->

					</div>
					<!-- //강의실 상단 -->

                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h4 class="sub-title">1:1상담</h4>
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
			                            <h3 class="board-title">1:1상담</h3>
			                            <div class="right-area">

											<%-- 리스트/카드 선택 버튼 --%>
											<span class="list-card-button"></span>

											<%-- 목록 스케일 선택 --%>
											<uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
			                            </div>
			                        </div>

			                        <%-- 게시글 리스트 --%>
									<div id="bbsAtclDscsnList"></div>

									<%-- 게시글 리스트 카드 폼 --%>
									<div id="bbsAtclDscsnList_cardForm" style="display:none">
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
									let atclListTable = UiTable("bbsAtclDscsnList", {
										lang: "ko",
										//tableMode: "list",
										//rowHeight: 30,
										//height: 400,
										//selectRow: "checkbox",
										//selectRow: "1",
										//selectRowFunc: checkRowSelect,
										//sortFunc: atclListTableSort,
										//initialSort: [{column:"regDate", dir:"desc"}],
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