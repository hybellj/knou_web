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
		var ORG_ID 			= '<c:out value="${bbsVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var BBS_TYCD		= '<c:out value="${bbsVO.bbsTycd}" />';
		var USER_ID		    = '<c:out value="${userId}" />';
		var USER_TYCD		= '<c:out value="${userTycd}" />';

		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${bbsVO.pageIndex}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;

		// 사용값
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var EPARAM			= '<c:out value="${encParams}" />';

		var ATCL_LV         = 1;

		$(document).ready(function() {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});

			// 게시판 ID 세팅 (TEAM/ALARM은 ',' 구분자 목록 사용)
			if(BBS_ID == "TEAM") {
				BBS_IDS = '<c:out value="${teamBbsIds}" />';
			} else if(!bbsCommon.isStudent() && BBS_ID == "ALARM") {
				BBS_IDS = '<c:out value="${alarmBbsIds}" />';
			} else {
				BBS_IDS = BBS_ID;
			}

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			listPaging(PAGE_INDEX);
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

			var currentBbsTycd = '<c:out value="${param.bbsTycd}" />';
			if(!currentBbsTycd) currentBbsTycd = BBS_TYCD; // 파라미터 없으면 기본값 사용

			var extData = {
					orgId           : ORG_ID
					, bbsId         : BBS_ID
					, bbsTycd       : currentBbsTycd
					, atclLv        : ATCL_LV
					, pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, searchValue 	: SEARCH_VALUE
			};
			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do";
			var param = {
				  encParams		: EPARAM
				, addParams		: UiComm.makeEncParams(extData)
			};

			UiComm.showLoading(true);

			ajaxCall(url, param, function(data) {
				if (data.encParams != null && data.encParams != '') {
					EPARAM = data.encParams;
				}

				if (data.result > 0) { // result가 1이면 성공(returnList가 없으면 데이터 없음)
					var returnList = data.returnList || [];

					if(currentBbsTycd == 'ALBUM') {
						var html = createAtclListHTML(returnList, data.pageInfo);

						$("#atclListAlbumArea").empty().html(html);

						$.each($("[data-img-index]"), function() {
		    				var imgIndex = $(this).data("imgIndex");
		    				$("a.album_img_" + imgIndex).colorbox({
		                        rel: "album_img_" + imgIndex,
		                        slideshow: true,
		                        width: "80%",
		                        photo:true
		                    });
		    			});

						var params = {
							totalCount : data.pageInfo.totalRecordCount,
							listScale : data.pageInfo.recordCountPerPage,
							currentPageNo : data.pageInfo.currentPageNo,
							eventName : "listPaging"
						};

						gfn_renderPaging(params);
					} else {
						// 테이블 데이터 설정
		        		var dataList = createAtclListHTML(returnList, data.pageInfo);
		        		atclListTable.clearData();
		        		atclListTable.replaceData(dataList);
		        		atclListTable.setPageInfo(data.pageInfo);
					}

	            } else {
	            	UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
	            }

			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
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
			var dataList = [];
			var bbsTycd = '<c:out value="${bbsVO.bbsTycd}" />';

			if(atclList.length == 0) {
				return dataList;
			}

			// ALBUM: 카드형 HTML 직접 생성
			if(bbsTycd == "ALBUM") {
				var html = '<div class="prof-box">';

				atclList.forEach(function(v, i) {
				    var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) : v.regDttm;
				    var contentUrlList = v.contentUrlList || [];
				    var atclTtl = v.atclTtl.replaceAll("<", "&lt").replaceAll(">", "&gt");

				    html += '    <div class="user-wrap">';
				    html += '        <div class="left_item">';
				    html += '            <div class="user-img">';
				    html += '                <div class="user-photo">';
				    if(contentUrlList.length == 0) {
				        html += '                    <img alt="사진" />';
				    } else {
				        html += '                    <img src="' + contentUrlList[0] + '" alt="사진" />';
				    }
				    html += '                </div>';
				    html += '            </div>';
				    html += '        </div>';
				    html += '        <div class="table_list">';
				    html += '            <ul class="list">';
				    html += '                <li class="head"><label><spring:message code="bbs.label.form_title"/></label></li>';
				    html += '                <li><a href="javascript:void(0)" onclick="viewAtcl(\'' + v.atclId + '\', \'' + v.rgtrId + '\', \'' + v.oyn + '\')" style="color: currentColor;">' + atclTtl + '</a></li>';
				    html += '            </ul>';
				    html += '            <ul class="list">';
				    html += '                <li class="head"><label><spring:message code="bbs.label.reg_user"/></label></li>';
				    html += '                <li>' + v.rgtrnm + '</li>';
				    html += '            </ul>';
				    html += '            <ul class="list">';
				    html += '                <li class="head"><label><spring:message code="bbs.label.reg_date"/></label></li>';
				    html += '                <li>' + regDttmFmt + '</li>';
				    html += '            </ul>';
				    html += '        </div>';
				    html += '    </div>';
				});

				html += '</div>';
				return html;
			}

			// 리스트형: 테이블 데이터 생성
			atclList.forEach(function(v, i) {
				var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
				var isLabelAtcl = v.optnCd == "FIX" || v.optnCd == "IMPT";
				var atclLabel = "";

				if(bbsTycd == "QNA") {
					atclLabel = "Q";
				} else if (bbsTycd == "1ON1") {
					atclLabel = "1:1";
				} else if(v.optnCd == "FIX") {
					atclLabel = '<spring:message code="bbs.label.fix" />'; // 고정
				} else if(v.optnCd == "IMPT") {
					atclLabel = '<spring:message code="bbs.label.impt" />'; // 중요
				}

				// 문의/상담 게시판 답변/미답변 아이콘
				var ansIcon = "";
				if(bbsTycd == "QNA" || bbsTycd == "1ON1") {
					if(v.answerYn == "Y") {
						ansIcon = '<small class="ml10 f080"><span style="background:#21BA45;color:#fff;padding:0 5px;"><spring:message code="bbs.label.answer" /></span></small>'; // 답변
					} else {
						ansIcon = '<small class="ml10 f080"><span style="background:#F2711C;color:#fff;padding:0 5px;"><spring:message code="bbs.label.no_answer" /></span></small>'; // 미답변
					}
				}

				var atclTtl = v.atclTtl.replaceAll("<", "&lt").replaceAll(">", "&gt");
				var linkUrl = "javascript:viewAtcl('" + v.atclId + "', '" + v.rgtrId + "', '" + v.oyn + "')";

				var col0 = lineNo;
				var colLabel = "";
				if(isLabelAtcl) {
					colLabel = (v.optnCd == 'FIX')
						? '	<label class="label s_c01">' + atclLabel + '</label>'
						: '	<label class="label s_c02">' + atclLabel + '</label>';
					col0 = colLabel;
				}

				var title = '<a href="'+linkUrl+'" title="'+atclTtl+'" class="link">'
					+ atclTtl
					+ (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y" ? ' <i class="xi-new icon" aria-hidden="true"></i>' : '')
					+ ansIcon
					+ '</a>';

				dataList.push({
					no: col0,
					atclTtl: title,
					regDttm: v.regDttm,
					rgtrnm: v.rgtrnm,
					attach: v.fileCnt > 0 ? '<i class="xi-paperclip"></i>' : '',
					inqCnt: v.inqCnt,
					cmntCnt: v.cmntCnt,
					atclId: v.atclId,
					lrnGrpTeamnm: v.teamGrpnm + " > " + v.teamnm,
					label: colLabel
				});
			});

			return dataList;
		}

		// 게시글 보기
		function viewAtcl(atclId, rgtrId, oyn) {
			let extData = {
				atclId	: atclId
			};

			if(USER_TYCD === 'STDNT') {
				if(BBS_TYCD === '1ON1' && USER_ID != rgtrId && oyn === 'N') {
					UiComm.showMessage("<spring:message code='bbs.alert.no.auth.atcl' />", "warning");
					UiComm.showLoading(false);
					return;
				}
			}

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

		// 선택한 파일 다운로드
        function selFileDownload(atclId) {
		    var url = "/file/fileHome/bbsZipFileDown.do";

		    // 서버가 response 로 파일(단일 원본 또는 zip)을 직접 내려주므로 form submit 으로 호출
		    var $form = $("<form></form>");
		    $form.attr("method", "POST");
		    $form.attr("action", url);
		    $form.attr("target", "downloadIfm");   // 화면 이동 없이 다운로드

		    $form.append($("<input>").attr({ type: "hidden", name: "fileBindDataSn", value: atclId }));
		    $form.append($("<input>").attr({ type: "hidden", name: "repoCd",        value: "BBS" }));

		    $form.appendTo("body");
		    $form.submit();
		    $form.remove();
		}

        // 여러파일 다운로드
		async function fileDownMulti(returnList) {
			var downloadUrl = '<%= CommConst.CONTEXT_FILE_DOWNLOAD %>?path=';
			var timer = ms => new Promise(res => setTimeout(res, ms));

			for (var i=0; i < returnList.length; i++) {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "downloadForm");
				form.attr("id", "downloadForm");
				form.attr("target", "downloadIfm");
				form.attr("action", downloadUrl + returnList[i].downloadPath);
				form.appendTo("body");
				form.submit();
				$("#downloadForm").remove();
			    await timer(2000);
			}
		}

		// 팀 구성원
		function openModal() {
			var extData = {
				  teamGrpId : $("#teamGrpId").val()
				, lrnTeamId  : $("#lrnTeamId").val()
			};

			dialog = UiDialog("dialog1", {
				title: "<spring:message code='bbs.label.team_mbr' />",
				width: 400,
				height: 600,
				url: "/bbs/bbsLect/bbsTeamMbrPopView.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData)
			});
		}
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<!-- class_sub -->
				<div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h4 class="sub-title">${bbsVO.bbsNm}</h4>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
							<c:if test="${bbsVO.bbsTycd == 'TEAM'}">

	                        	<div class="item">
	                                <span class="item_tit"><label for="selectCourse"><spring:message code="bbs.label.lrn_grp" />/<spring:message code="bbs.label.team" /></label></span>

	                                <select class="ui dropdown" id="teamGrpId">
								        <option value=""><spring:message code="bbs.label.lrn_grp" /></option>
								        <c:forEach var="list" items="${filterOptions.teamGrpList}">
								            <option value="${list.teamGrpId}">${list.teamGrpnm}</option>
								        </c:forEach>
								    </select>

									<select class="ui dropdown" id="lrnTeamId">
								        <option value=""><spring:message code="bbs.label.team" /></option>
								        <c:forEach var="list" items="${filterOptions.lrnTeamList}">
								            <option value="${list.lrnTeamId}">${list.lrnTeamnm}</option>
								        </c:forEach>
								    </select>
	                            </div>
                            </c:if>

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

						<%-- 게시글 리스트 영역(공통 스크립트가 list-card-button을 주입하는 기준 = atclListArea) --%>
						<div id="atclListArea">
							<c:choose>
								<c:when test="${bbsVO.bbsTycd == 'ALBUM'}">
									<div class="board_top">
		                                <h3 class="board-title">${bbsVO.bbsNm}</h3>
		                                <div class="right-area">
											<c:if test="${(bbsVO.bbsTycd == 'NTC' && STUDENT_YN != 'Y') || (bbsVO.bbsTycd == 'QNA' && STUDENT_YN == 'Y') || (bbsVO.bbsTycd == 'TEAM' && STUDENT_YN == 'Y') || (bbsVO.bbsTycd == '1ON1' && STUDENT_YN == 'Y')}">
		                                    	<button type="button" class="btn type1" style="white-space: nowrap;" onclick="moveWriteAtcl()"><spring:message code="bbs.button.write" /></button><%-- 글쓰기 --%>
											</c:if>

											<%-- 리스트/카드 선택 버튼 --%>
											<span class="list-card-button"></span>

											<%-- 목록 스케일 선택 --%>
											<uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
		                                </div>
		                            </div>

									<%-- ALBUM: listPaging에서 이 영역을 통째로 채움 --%>
									<div id="atclListAlbumArea"></div>
								</c:when>
								<c:otherwise>
									<%-- 게시글 리스트 영역(Tabulator 폭 제어 전용 래퍼) --%>
									<div id="atclListBox">
										<%-- board_top: 테이블(#atclList) 바로 앞 형제 → UiTable의 $table.prev()가 list-card-button을 찾음 --%>
										<div class="board_top">
			                                <h3 class="board-title">${bbsVO.bbsNm}</h3>
			                                <div class="right-area">
												<c:if test="${bbsVO.bbsTycd == 'TEAM' && STUDENT_YN == 'Y'}">
			                                    	<button type="button" class="btn type1" style="white-space: nowrap;" onclick="openModal()">팀 구성원</button>
			                                    </c:if>
			                                	<c:if test="${(bbsVO.bbsTycd == 'NTC' && STUDENT_YN != 'Y') || (bbsVO.bbsTycd == 'DATARM' && STUDENT_YN != 'Y') || (bbsVO.bbsTycd == 'QNA' && STUDENT_YN == 'Y') || (bbsVO.bbsTycd == 'TEAM' && STUDENT_YN == 'Y') || (bbsVO.bbsTycd == '1ON1' && STUDENT_YN == 'Y')}">
			                                    	<button type="button" class="btn type1" style="white-space: nowrap;" onclick="moveWriteAtcl()"><spring:message code="bbs.button.write" /></button><%-- 글쓰기 --%>
												</c:if>

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
										</div>
									</div>
								</c:otherwise>
							</c:choose>
						</div>

						<c:if test="${bbsVO.bbsTycd != 'ALBUM'}">
						<script>
						let tableColumns = [
						    {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:60},
						];

						// 조건부 컬럼 추가 (bbsTycd가 'TEAM'인 경우)
						if (BBS_TYCD === "TEAM") {
						    tableColumns.push({
						        title: "<spring:message code='bbs.label.lrn_grp' /> > <spring:message code='bbs.label.team' />",
						        field: "lrnGrpTeamnm",
						        headerHozAlign: "center",
						        hozAlign: "center",
						        width: 200,
						        minWidth: 200
						    });
						}

						// 공통 컬럼 추가
						tableColumns.push(
							{title:"<spring:message code='bbs.label.form_title'/>", field:"atclTtl",  headerHozAlign:"center", hozAlign:"left",   minWidth:200, widthGrow:1, headerSort:true},
						    {title:"<spring:message code='bbs.label.reg_user'/>",   field:"rgtrnm",   headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
						    {title:"<spring:message code='bbs.label.reg_date'/>",   field:"regDttm",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, headerSort:true, formatter:"date"},
						    {title:"<spring:message code='bbs.label.attach'/>",     field:"attach",   headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60,
						    	cellClick: function(e, cell) {
						    	    if (cell.getValue()) {
						    	        var rowData = cell.getRow().getData();
						    	        selFileDownload(rowData.atclId, rowData.atclTtl);  // zip 이름 = 게시글 제목
						    	    }
						    	}
					        },
						    {title:"<spring:message code='bbs.label.view'/>",       field:"inqCnt",   headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},
						    {title:"<spring:message code='bbs.label.comment'/>",    field:"cmntCnt",  headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60}
						);

						if (BBS_TYCD === "TEAM") {
						    tableColumns.push({
						        title: "<spring:message code='bbs.label.public_y'/>",
						        field: "oyn",
						        headerHozAlign: "center",
						        hozAlign: "center",
						        width: 60,
						        minWidth: 60
						    });
						}

						// 게시글 리스트 테이블
						let atclListTable = UiTable("atclList", {
							lang: "ko",
						    pageFunc: listPaging,
						    columns: tableColumns
						});

						function checkSelect() {
							// 선택된값 array로 가져온다.
							let data = atclListTable.getSelectedData("atclId"); // "atclId" 키로 설정된 값
							alert(data);
						}

						function checkRowSelect(data) {
							let value = data["atclId"]; // "atclId" 키로 설정된 값
							alert(value);
						}
						</script>
						</c:if>
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
<iframe name="downloadIfm" id="downloadIfm" style="display:none;"></iframe>
</html>
