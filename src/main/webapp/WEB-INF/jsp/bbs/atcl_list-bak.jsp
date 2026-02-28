<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<c:choose>
		<c:when test="${templateUrl eq 'bbsHome' or templateUrl eq 'bbsLect'}">
			<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
		</c:when>
		<c:when test="${templateUrl eq 'bbsMgr'}">
			<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
		</c:when>
	</c:choose>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<c:choose>
		<c:when test="${templateUrl eq 'bbsHome'}">
			<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
		</c:when>
		<c:when test="${templateUrl eq 'bbsLect'}">
			<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
		</c:when>
		<c:when test="${templateUrl eq 'bbsMgr'}">
			<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/admin-default.css" />
		</c:when>
	</c:choose>
	<!-- 게시판 공통 -->
	<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>

	<link href="https://cdn.jsdelivr.net/npm/jquery-colorbox@1.6.4/example1/colorbox.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/jquery-colorbox@1.6.4/jquery.colorbox-min.min.js"></script>

	<script type="text/javascript">
		var USER_ID 		= '<c:out value="${USER_ID}" />';
		var HAKSA_YEAR 		= '<c:out value="${param.haksaYear}" />';
		var HAKSA_TERM		= '<c:out value="${param.haksaTerm}" />';
		var BBS_CD 			= '<c:out value="${param.bbsId}" />';
		var CRS_CRE_CD		= '<c:out value="${param.crsCreCd}" />';
		var TEAM_CTGR_CD	= '<c:out value="${param.teamCtgrCd}" />';
		var TEAM_CD			= '<c:out value="${param.teamCd}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${param.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${param.listScale}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var BBS_ID 			= '<c:out value="${param.bbsId}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;
		var BBS_HOME_UNIV_GBNS = ""; // bbsHome 의 전체공지 조회용 대학구분 코드

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

			if(!LIST_SCALE) {
				LIST_SCALE = $("#listScale").val();
			}

			$("#listScale").dropdown("set value", [LIST_SCALE]);
			$("#listScale").on("change", function() {
				LIST_SCALE = this.value;
				listPaging(1);
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			if(TEMPLATE_URL == "bbsHome") {
				changeBbsTerm(PAGE_INDEX);
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

			if($("#teamCd").val()) {
				BBS_IDS = $("#teamCd > option:selected")[0].dataset.bbsId;
			}

			if(!BBS_IDS) {
				$("#atclListArea").empty().html(createEmptyListHtml());
				$("#atclList").footable();
				return;
			}

			PAGE_INDEX = pageIndex;

			var url = "/bbs/" + TEMPLATE_URL + "/listAtcl.do"
			var param = {
				  crsCreCd		: CRS_CRE_CD
				, bbsIds		: BBS_IDS
				, pageIndex		: pageIndex
				, listScale		: LIST_SCALE
				, searchValue 	: SEARCH_VALUE
				, haksaYear		: $("#haksaYear").val()
				, haksaTerm		: $("#haksaTerm").val()
			};

			if(TEMPLATE_URL == "bbsLect") {
				param.univGbn = '<c:out value="${courseUnivGbn}" />';
			} else if(TEMPLATE_URL == "bbsHome") {
				param.univGbns = BBS_HOME_UNIV_GBNS;
			}

			ajaxCall(url, param, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var pageInfo = data.pageInfo;
	        		var html = createAtclListHTML(returnList, pageInfo);

	        		$("#atclListArea").empty().html(html);
	    			//$("#atclList").footable();

	    			// 앨범형일경우 라이브러리 세팅
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
	             	alert(data.message);
	             	$("#atclListArea").empty().html(createEmptyListHtml());
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				$("#atclListArea").empty().html(createEmptyListHtml());
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

		// 빈내용 생성
		function createEmptyListHtml() {
			var bbsTycd = '<c:out value="${bbsInfoVO.bbsTycd}" />';

			var html = '';

			if(bbsTycd == "ALBUM") {

			} else {
				html += '<table class="listTable" id="atclList" data-empty="">';
				html += '   <caption>Content table</caption>';
				html += '	<thead>';
				html += '		<tr>';
				html += '			<th class="tc"><spring:message code="bbs.label.form_title" /></th>'; // 제목
				html += '			<th class="tc w100"><spring:message code="bbs.label.reg_date" /></th>';
				html += '			<th class="tc w100"><spring:message code="bbs.label.reg_user" /></th>'; // 작성일/작성자
				html += '			<th class="tc w60"><spring:message code="bbs.label.attach" /></th>'; // 첨부
				if("${bbsInfoVO.bbsTycd}" == "" || "${bbsInfoVO.bbsId}" == "PDS") {
				html += '			<th class="tc w70"><spring:message code="bbs.label.good" /></th>'; // 좋아요
				}
				html += '           <th class="tc w60"><spring:message code="bbs.label.view" /></th>'; // 조회
				html += '			<th class="tc w60"><spring:message code="bbs.label.comment" /></th>'; // 댓글
				html += '		</tr>';
				html += '	</thead>';
				html += '	<tbody style="display:none;">';
				html += '	</tbody>';
				html += '</table>';
			}

			html += '<div class="flex-container mb10">';
			html += '	<div class="cont-none">';
			html += '		<span><spring:message code="common.content.not_found" /></span>';
			html += '	</div>';
			html += '</div>';

			return html;
		}

		// 게시글 리스트 생성
		function createAtclListHTML(atclList, pageInfo) {
			var isKnou = "<%=SessionInfo.isKnou(request)%>" == "true";

			if(atclList.length == 0) {
				return createEmptyListHtml();
			} else {
				var bbsTycd = '<c:out value="${bbsInfoVO.bbsTycd}" />';

				if(bbsTycd == "ALBUM") {
					var html = '';

					html += '<div class="post_album">';
					html += '	<div class="ui five stackable cards">';
					atclList.forEach(function(v, i) {
						var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) : v.regDttm;
						var contentUrlList = v.contentUrlList || [];

						// 링크설정
						var queryInfo = {};

						if(CRS_CRE_CD) {
							queryInfo.crsCreCd	= CRS_CRE_CD;
						}

						queryInfo.bbsId			= v.bbsId;
						queryInfo.atclId		= v.atclId;

						if(SEARCH_VALUE) {
							queryInfo.searchValue	= SEARCH_VALUE;
						}

						if(pageInfo.currentPageNo != 1) {
							queryInfo.pageIndex		= pageInfo.currentPageNo;
						}

						queryInfo.listScale			= pageInfo.recordCountPerPage;

						var queryStr = new URLSearchParams(queryInfo).toString();
						var linkUrl = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do";

						html += '	<div class="ui card">';
						html += '		<p class="view-list-img img-hover-zoom">';
						if(contentUrlList.length == 0) {
							html += '		<a href="javascript:void(0)" title="None">';
							html += '			<img alt="Image" />';
							html += '		</a>';
						} else {
							contentUrlList.forEach(function(contentUrl, j) {
								html += '	<a href="' + contentUrl + '" class="album_img_' + i + '" data-img-index="' + i + '" title="Image">';
								if(j == 0) {
									html += '	<img src="' + contentUrl + '" alt="Image" />';
								}
								else {
									html += '	<span class="blind">None</span>';
								}
								html += '	</a>';
							});
						}
						html += '		</p>';
						var atclTitle = v.atclTitle.replaceAll("<", "&lt").replaceAll(">", "&gt");
						html += '		<div class="content">';
						html += '			<a class="title-box" href="javascript:void(0)" onclick="bbsCommon.movePost(\'' + linkUrl + '\', \'' + queryStr + '\')" style="color: currentColor;">' + atclTtl + '</a>';
						html += '		</div>';
						html += '		<div class="content">';
						html += '			<ul class="post_disc">';
						html += '				<li>' + v.regNm + '</li>';
						html += '				<li>' + regDttmFmt + '</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '	</div>';
					});
					html += '	</div>';
					html += '</div>';
					html +=	'<div id="paging" class="paging"></div>';

					return html;
				} else {
					var html = '';
					var isGoodUseYn = false;

					atclList.forEach(function(v, i) {
						if(!isGoodUseYn && v.goodUseYn == "Y") {
							isGoodUseYn = true;
						}
					});

					atclList.forEach(function(v, i) {
						var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
						var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) : v.regDttm;
						var isLabelAtcl = v.noticeYn == "Y" || v.imptYn == "Y" || ((v.bbsId == "QNA" || v.bbsId == "SECRET") && v.answerYn == "N");
						var atclLabel = "";
						var atclLabelColor = "";

						if(v.bbsId == "QNA") {
							atclLabel = "Q";
							atclLabelColor = "purple";
						} else if (v.bbsId == "SECRET") {
							atclLabel = "1:1";
							atclLabelColor = "deepblue1";
						} else {
							if(v.noticeYn == "Y") {
								//if(v.bbsId == "PDS") {
									atclLabel = '<spring:message code="bbs.label.fix" />'; // 고정
									atclLabelColor = "brown";
								//} else {
								//	atclLabel = '<spring:message code="bbs.label.notice" />'; // 공지
								//	atclLabelColor = "orange";
								//}
							} else if(v.imptYn == "Y") {
								atclLabel = '<spring:message code="bbs.label.impt" />'; // 중요
								atclLabelColor = "red";
							}
						}

						// 문의/상담 게시판 답변, 미답변 아이콘 추가
						var ansIcon = "";

						if(v.bbsId == "QNA" || v.bbsId == "SECRET") {
							if(v.answerYn == "Y") {
								ansIcon = '<small class="ml10 f080"><span style="background:#21BA45;color:#fff;padding:0 5px;"><spring:message code="bbs.label.answer" /></span></small>'; // 답변
								//ansIcon = ' <span class="label2 green"><spring:message code="bbs.label.answer" /></span>'; // 답변
							} else {
								ansIcon = '<small class="ml10 f080"><span style="background:#F2711C;color:#fff;padding:0 5px;"><spring:message code="bbs.label.no_answer" /></span></small>'; // 미답변
								//ansIcon = ' <span class="label2 orange"><spring:message code="bbs.label.no_answer" /></span>'; // 미답변
							}
						}

						/* var atclTitle = v.atclTitle.replaceAll("<", "&lt").replaceAll(">", "&gt"); */
						var atclTitle = v.atclTitle;

						// 비공개글 스타일 추가
						if(v.lockYn == "Y") {
							atclTitle = '<span class="fcGrey" style="text-decoration: line-through">' + atclTitle + '</span>';
						}

						var queryInfo = {};

						if($("#haksaYear").val() && $("#haksaTerm").val()) {
							queryInfo.haksaYear	= $("#haksaYear").val();
							queryInfo.haksaTerm	= $("#haksaTerm").val();
						}

						if(BBS_CD) {
							queryInfo.bbsId = BBS_CD;
						}

						if(CRS_CRE_CD) {
							queryInfo.crsCreCd	= CRS_CRE_CD;
						}

						if(v.bbsId == "TEAM" && $("#teamCd").val()) {
							queryInfo.teamCtgrCd = v.teamCtgrCd;
							queryInfo.teamCd	 = v.teamCd;
						}

						queryInfo.bbsId			= v.bbsId;
						queryInfo.atclId		= v.atclId;

						if(SEARCH_VALUE) {
							queryInfo.searchValue	= SEARCH_VALUE;
						}

						if(pageInfo.currentPageNo != 1) {
							queryInfo.pageIndex		= pageInfo.currentPageNo;
						}

						queryInfo.listScale			= pageInfo.recordCountPerPage;

						if(TAB) {
							queryInfo.tab			= TAB;
						}

						var queryStr = new URLSearchParams(queryInfo).toString();

						if(bbsCommon.isStudent() && v.bbsId == "SECRET" && v.rgtrId != USER_ID) {
							var linkUrl = 'javascript:alert(' + '<spring:message code="bbs.alert.no_auth_secret" />' + ')'; // 1:1상담 게시글 입니다.
						} else {
							var linkUrl = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do";
						}

						var isSingleTab = BBS_IDS && BBS_IDS.split(",").length == 1;

						html += '<tr>';
						html += '	<td class="title">';
						if(isLabelAtcl) {
							html += '	<label class="ui mini label tc ' + atclLabelColor + '">' + atclLabel + '</label>';
						} else {
							html += '	<label class="ui label bcNone border0 p0">' + lineNo + '</label>';
						}
						if(v.bbsId == "SECRET" && bbsCommon.isTutor()) {
							// 접근권한이 없는 게시글 입니다.
							html += '	<a href="javascript:void(0)" onclick="alert(\'<spring:message code="bbs.alert.no.auth.atcl" />\')" style="color: currentColor;">';
						} else {
							html += '	<a href="javascript:void(0)" onclick="bbsCommon.movePost(\'' + linkUrl + '\', \'' + queryStr + '\')" style="color: currentColor;">';
						}
						// [팀카테고리명 > 팀명]
						if(v.bbsId == "TEAM") {
							html += '		<span class="fcBlue mr5">[' + v.teamCtgrNm + ' > ' + v.teamNm + ']</span>';
						}
						// [게시판명]
						else if(!isSingleTab) {
							html += '		<span class="fcBlue mr5">[' + v.bbsNm + ']</span>';
						}

						var viewYn = v.viewYn;
						if(bbsCommon.isStudent() && (v.bbsId == "SECRET" || v.bbsId == "QNA")) {
							viewYn = v.ansViewYn;
						}

						var atclTitleStr = viewYn == "Y" ? "<span class='fcGrey'>"+atclTitle+"</span>" : atclTitle;
						html += 			atclTitleStr + (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y" ? '<i class="text-new"><spring:message code="bbs.label.new_atcl" /></i>' : '') + ansIcon;
						html += '		</a>';
						html += '	</td>';
						html += '	<td class="tl mra word_break_none">';
						html += '		<ul class="list_verticalline opacity7">';
						html += '			<li style="width: 79px;">' + regDttmFmt + '</li>';
						html += '		</ul>';
						html += '	</td>';
						html += '	<td class="tl mra word_break_none">';
						html += '		<ul class="list_verticalline opacity7">';
						html += '			<li>';
						html += 				v.regNm;
						if(isKnou && !bbsCommon.isStudent() && (v.menuType || "").indexOf("STUDENT") > -1) {
							html += '			<a href="javascript:void(0)" onclick="userInfoPop(\'' + v.rgtrId + '\'); return false;" title="사용자 정보" class="bbs-user-icon" style="position: relative; left:-0.3em;"><i class="ico icon-info"></i></a>';
						}
						html += '			</li>';
						html += '		</ul>';
						html += '	</td>';
						html += '	<td class="tc">';
						if(v.atchUseYn == 'Y' && v.atchFileCnt > 0) {
							var fileName = v.atclTitle.replace(/[\{\}\[\]\/?,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi, '');
							html += '	<a href="javascript:fileDown(\'' + v.atclId + '\', \'' + fileName + '\')" alt="Download" title="<spring:message code="filebox.button.download" />"><i class="xi-file-o f120"></i><span class="hide">file</span></a>';
						}
						html += '	</td>';
						if("${bbsInfoVO.bbsTycd}" == "" || "${bbsInfoVO.bbsId}" == "PDS") {
							html += '	<td class="tl">' + (v.goodUseYn == 'Y' ? '<i class="xi-thumbs-up f120 mr5"></i><span class="opacity7">' + v.goodCnt + '</span>' : '') + '</td>';
						}

						html += '	<td class="tl" style="white-space:nowrap">';
						if(v.crsCreCd && !bbsCommon.isStudent()) {
							html += '	<a href="javascript:void(0)" onclick="viewerListModal(\'' + v.crsCreCd + '\', \'' + v.atclId + '\')" class="inline-flex-item">';
							html += '		<i class="xi-eye-o f120 mr5"></i><span class="opacity7">' + v.hits + '</span>';
							html += '	</a>';
						} else {
							html += '	<i class="xi-eye-o f120 mr5"></i><span class="opacity7">' + v.hits + '</span>';
						}
						html += '	</td>';
						html += '	<td class="tl ' + (v.cmntUseYn == "Y" ? '' : 'off') + '" style="white-space:nowrap"><i class="icon comments outline f110 mr5"></i><span class="opacity7">' + v.cmntCnt + '</span></td>';
						html += '</tr>';
					});

					var htmlData = ''
						htmlData += '<table class="listTable" id="atclList">';
						htmlData += '   <caption>Content table</caption>';
						htmlData += '	<thead>';
						htmlData += '		<tr>';
						htmlData += '			<th class="tc"><spring:message code="bbs.label.form_title" /></th>'; // 제목
						htmlData += '			<th class="tc w100"><spring:message code="bbs.label.reg_date" /></th>'; // 작성일
						htmlData += '			<th class="tc w100"><spring:message code="bbs.label.reg_user" /></th>'; // 작성자
						htmlData += '			<th class="tc w60"><spring:message code="bbs.label.attach" /></th>'; // 첨부
						if("${bbsInfoVO.bbsTycd}" == "" || "${bbsInfoVO.bbsId}" == "PDS") {
							htmlData +=  '		<th class="tc w70" style=""><spring:message code="bbs.label.good" /></th>'; // 좋아요
						}
						htmlData += '			<th class="tc w60"><spring:message code="bbs.label.view" /></th>'; // 조회
						htmlData +=  '			<th class="tc w60"><spring:message code="bbs.label.comment" /></th>'; // 댓글
						htmlData +=  '		</tr>';
						htmlData +=  '	</thead>';
						htmlData +=  '	<tbody>';
						htmlData +=			html;
						htmlData +=  '	</tbody>';
						htmlData +=  '</table>';
						htmlData +=  '<div id="paging" class="paging"></div>';

					return htmlData;
				}
			}
		}

		// 팀 게시판 생성여부 조회
		function checkAndCreateTeamBbs(teamCd) {
			if(teamCd == "all") {
				listPaging(1);
				return;
			}

			if(teamCd) {
				var url = "/bbs/bbsLect/checkAndCreateTeamBbs.do";
				var data = {
					teamCd: teamCd
				};

				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						var returnVO = data.returnVO;

						if(returnVO) {
							var bbsId = returnVO.bbsId;

							$("#teamCd > option:selected")[0].dataset.bbsId = bbsId;

							listPaging(1);
						}
		        	} else {
		        		alert(data.message);
		        	}
				}, function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				});
			}
		}

		// 다운로드
		function fileDown(atclId, fileName) {
			var url = "/file/fileHome/listFileInfo.do";
			var data = {
				  fileBindDataSn : atclId
				, repoCd : "BBS"
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];

					if(returnList.length > 0) {
						// 여러파일 다운로드
						fileDownMulti(returnList);
					} else {
						alert('<spring:message code="common.file.not_download" />'); // 지정한 파일을 다운로드할 수 없습니다.
					}
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="common.file.not_download" />'); // 지정한 파일을 다운로드할 수 없습니다.
			});
		}

		// 여러파일 다운로드
		async function fileDownMulti(returnList) {
			var downloadUrl = '<%= CommConst.CONTEXT_FILE_DOWNLOAD %>?path=';
			var timer = ms => new Promise(res => setTimeout(res, ms));

			for (var i=0; i<returnList.length; i++) {
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

		// 게시글 파일 다운로드
		function fileDownZip(atclId, fileName) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "zipDownForm");
			form.attr("action", "/file/fileHome/zipFileDown.do");
			form.append($('<input/>', {type : 'hidden', name : 'fileBindDataSn', 	value : atclId}));
			form.append($('<input/>', {type : 'hidden', name : 'repoCd', 			value : "BBS"}));
			form.append($('<input/>', {type : 'hidden', name : 'fileNm', 			value : fileName}));
			form.appendTo("body");
			form.submit();

			$("form[name=zipDownForm]").remove();
		}

		// 게시판 학기 변경
		function changeBbsTerm(pageIndex) {
			if(TEMPLATE_URL == "bbsHome") {
				BBS_HOME_UNIV_GBNS = "";

				// 사용자 학기별 대학구분 조회
				var url = "/crs/creCrsHome/listUserUnivGbn.do";
				var data = {
					  creYear: $("#haksaYear").val()
					, creTerm: $("#haksaTerm").val()
				};

				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						var returnList = data.returnList || [];
						var univGbnList = [];

						returnList.forEach(function(v, i) {
							if(v.univGbn) {
								univGbnList.push(v.univGbn);
							}
						});

						BBS_HOME_UNIV_GBNS = univGbnList.join(",");

						listPaging(pageIndex || 1);
			    	}
				}, function(xhr, status, error) {
					console.log(xhr, status, error);
					listPaging(pageIndex || 1);
				});
			} else {
				listPaging(1);
			}
		}

	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
templateUrl=${templateUrl}
	<div id="wrap" class="main">
		<!-- class_top 인클루드  -->

		<c:choose>
			<c:when test="${templateUrl eq 'bbsHome'}">
				<%@ include file="/WEB-INF/jsp/common/frontLnb.jsp"%>
			</c:when>
			<c:when test="${templateUrl eq 'bbsLect'}">
				<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp"%>
			</c:when>
			<c:when test="${templateUrl eq 'bbsMgr'}">
				<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
			</c:when>
		</c:choose>

		<div id="container">

			<c:choose>
				<c:when test="${templateUrl eq 'bbsHome'}">
					<%@ include file="/WEB-INF/jsp/common/frontGnb.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsLect'}">
					<%@ include file="/WEB-INF/jsp/common/class_header.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsMgr'}">
					<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
				</c:when>
			</c:choose>

			<!-- 본문 content 부분 -->
			<div class="content stu_section">
				<c:choose>
					<c:when test="${templateUrl eq 'bbsHome'}">
						<%-- <%@ include file="/WEB-INF/jsp/common/location.jsp" %> --%>
					</c:when>
					<c:when test="${templateUrl eq 'bbsLect'}">
		        		<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
					</c:when>
					<c:when test="${templateUrl eq 'bbsMgr'}">
						<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
					</c:when>
				</c:choose>

		        <!-- 영역1 -->
		        <div class="ui form">
			        <div class="layout2">
                    	<script>
							$(document).ready(function (){
								var templateUrl = '<c:out value="${templateUrl}" />';

								var bbsTitle;
								if(templateUrl == "bbsHome") {
									bbsTitle = '<spring:message code="bbs.label.bbs_lect_home" />'; 		// 강의실 홈
								} else if(templateUrl == "bbsLect") {
									bbsTitle = '<spring:message code="bbs.label.bbs_alarm" />';				// 알림터
								} else if(templateUrl == "bbsMgr") {
									bbsTitle = '<spring:message code="bbs.label.bbs_manager_home" />';		// 관리자
								}

								var bbsSubTitle;
								var bbsId = '<c:out value="${param.bbsId}" />';
								var bbsNm = '<c:out value="${bbsInfoVO.bbsNm}" />';
								var tab = '<c:out value="${param.tab}" />';

								if(bbsId == "TEAM") {
									bbsSubTitle = '<spring:message code="bbs.label.bbs_team" />';	// 팀게시판
								} else if(bbsId == "ALARM") {
									bbsSubTitle = '<spring:message code="bbs.label.alarm.bbs" />';	// 통합게시판
								} else {
									bbsSubTitle = bbsNm;
								}

								// set location
								if(typeof setLocationBar === "function") {
									setLocationBar(bbsTitle, bbsSubTitle);
								}
							});
						</script>

						<!-- 템플릿 별 ID, 클래스 -->
						<c:choose>
                        	<c:when test="${templateUrl eq 'bbsHome'}">
                        		<c:set var="titleId" value="" />
                        		<c:set var="titleClass" value="classInfo" />
                        	</c:when>
                        	<c:when test="${templateUrl eq 'bbsLect'}">
                        		<c:set var="titleId" value="info-item-box" />
                        		<c:set var="titleClass" value="" />
                        	</c:when>
                        	<c:when test="${templateUrl eq 'bbsMgr'}">
                        		<c:set var="titleId" value="info-item-box" />
                        		<c:set var="titleClass" value="" />
                        	</c:when>
                        </c:choose>

                        <div id="<c:out value="${titleId}" />" class="<c:out value="${titleClass}" />">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
	                            <c:choose>
	                            	<c:when test="${templateUrl eq 'bbsHome'}">
	                            		<spring:message code="bbs.label.bbs_lect_home" /><!-- 강의실 홈 -->
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsLect'}">
	                            		<c:choose>
	                            			<c:when test="${param.bbsId eq 'TEAM'}">
	                            				<spring:message code="bbs.label.bbs_team" /><!-- 팀게시판 -->
	                            			</c:when>
	                            			<c:when test="${param.bbsId eq 'ALARM'}">
	                            				<spring:message code="bbs.label.alarm.bbs" /><!-- 통합게시판 -->
	                            			</c:when>
	                            			<c:otherwise>
	                            				<c:out value="${bbsInfoVO.bbsNm}" />
	                            			</c:otherwise>
	                            		</c:choose>
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsMgr'}">
	                            		<spring:message code="bbs.label.bbs_manager_home" /><!-- 관리자 -->
	                            	</c:when>
	                            </c:choose>
                            </h2>
	                        <c:if test="${atclWriteAuth eq 'Y'}">
	                            <div class="button-area">
	                                <a href="javascript:void(0)" onclick="moveWriteAtcl();" class="ui blue button" id="writeBtn"><spring:message code="bbs.button.write" /><!-- 글쓰기 --></a>
	                            </div>
	                        </c:if>
                        </div>
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                           	<c:if test="${templateUrl eq 'bbsLect' and bbsInfoVO.bbsId eq 'QNA' and STUDENT_YN eq 'Y'}">
								<div class="ui message bcLYellow">
		                        	<b class=""><spring:message code="bbs.label.qna.guide" /><!-- ※강의 관련 문의사항을 등록하는 게시판입니다. 수강생 전체에게 내용이 공유됩니다. --></b>
								</div>
							</c:if>
							<c:if test="${templateUrl eq 'bbsLect' and bbsInfoVO.bbsId eq 'SECRET' and STUDENT_YN eq 'Y'}">
								<div class="ui message bcLYellow">
		                        	<b class=""><spring:message code="bbs.label.secret.guide" /><!-- ※교수자와 1:1로 상담을 요청하는 게시판입니다. 작성자와 답변자만 내용을 볼 수 있습니다. 강의 및 행정 관련 문의는 강의 Q&A에 올려주시기 바랍니다. --></b>
								</div>
							</c:if>

							<!-- 게시판 탭 -->
							<c:if test="${templateUrl eq 'bbsLect'}">
								<%@ include file="/WEB-INF/jsp/bbs/common/bbs_tab_inc.jsp" %>
							</c:if>

								<!-- 검색조건 -->
								<div class="option-content gap4 mt10 mb10">
								<c:if test="${param.bbsId eq 'TEAM'}">
									<label for="teamCtgrCd" class="hide">Team Category</label>
									<select class="ui dropdown mr5" id="teamCtgrCd" onchange="changeTeamCtgr(this.value)">
										<option value=""><spring:message code="bbs.label.select_team_ctgr" /><!-- 팀 분류 선택 --></option>
										<option value="all"><spring:message code="common.all" /><!-- 전체 --></option>
									<c:forEach var="row" items="${listTeamCtgr}">
										<option value="<c:out value="${row.teamCtgrCd}" />" <c:if test="${row.teamCtgrCd eq param.teamCtgrCd}">selected</c:if> ><c:out value="${row.teamCtgrNm}" /></option>
									</c:forEach>
							        </select>

							        <label for="teamCd" class="hide">Team</label>
							        <select class="ui dropdown mr5" id="teamCd" onchange="checkAndCreateTeamBbs(this.value)">
						        		<option value=""><spring:message code="bbs.label.select_team" /><!-- 팀 선택 --></option>
						        	<c:forEach var="row" items="${listTeamBbsId}">
						        		<option value="<c:out value="${row.teamCd}" />" data-bbs-id="<c:out value="${row.bbsId}" />" <c:if test="${row.teamCd eq param.teamCd}">selected</c:if> ><c:out value="${row.teamNm}" /></option>
						        	</c:forEach>
							        </select>
								</c:if>
								<!-- 전체공지 -->
								<c:if test="${bbsInfoVO.sysUseYn eq 'Y' && bbsInfoVO.sysDefaultYn eq 'Y' && bbsInfoVO.bbsId eq 'NOTICE'}">
									<label for="haksaYear" class="hide"><spring:message code="common.year" /></label>
									<select id="haksaYear" class="ui dropdown mr5" onchange="changeBbsTerm()">
										<c:forEach var="item" items="${yearList }">
											<option value="${item }" ${(not empty param.haksaYear and item eq param.haksaYear) or (empty param.haksaYear and item eq defaultYear) ? 'selected' : '' }>${item }</option>
										</c:forEach>
									</select>
									<label for="haksaTerm" class="hide"><spring:message code="common.term" /></label>
									<select id="haksaTerm" class="ui dropdown mr5" onchange="changeBbsTerm()">
										<c:forEach var="item" items="${termList }">
											<option value="${item.codeCd }" ${(not empty param.haksaTerm and item.codeCd eq param.haksaTerm) or (empty param.haksaTerm and item.codeCd eq defaultTerm) ? 'selected' : '' }>${item.codeNm }</option>
										</c:forEach>
									</select>
								</c:if>
								<c:if test="${viewAllYn eq 'Y'}">
									<input type="hidden" id="haksaYear" value="<c:out value="${defaultYear}" />" />
									<input type="hidden" id="haksaTerm" value="<c:out value="${defaultTerm}" />" />
								</c:if>
									<!-- 검색 -->
									<div class="ui action input search-box">
										<label for="searchValue" class="hide">Search</label>
										<input id="searchValue" type="text" placeholder="<spring:message code="bbs.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="listPaging(1)">
											<i class="search icon"></i>
										</button>
									</div>
									<div class="select_area">
										<label for="listScale" class="hide">List size</label>
										<select class="ui dropdown list-num" id="listScale">
								            <option value="10">10</option>
								            <option value="20">20</option>
								            <option value="50">50</option>
								            <option value="100">100</option>
								        </select>
									</div>
								</div>

								<!-- 게시글 리스트 -->
								<div id="atclListArea">
								</div>

								<c:if test="${atclWriteAuth eq 'Y'}">
		                            <div class="tr">
		                                <a href="javascript:void(0)" onclick="moveWriteAtcl();" class="ui blue button" id="writeBtn"><spring:message code="bbs.button.write" /><!-- 글쓰기 --></a>
		                            </div>
		                        </c:if>
                            </div><!-- //col -->
                        </div><!-- //row -->

			        </div><!-- //layout2 -->
			    </div><!-- //ui form -->
			</div><!-- //content stu_section -->

			<c:choose>
				<c:when test="${templateUrl eq 'bbsHome'}">
					<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsLect'}">
					<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp"%>
				</c:when>
				<c:when test="${templateUrl eq 'bbsMgr'}">
					<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp"%>
				</c:when>
			</c:choose>

		</div><!-- //container -->

	</div><!-- //wrap -->

	<!-- 조회자 목록 팝업 -->
	<form id="viewerListForm" name="viewerListForm">
		<input type="hidden" name="crsCreCd" />
		<input type="hidden" name="atclId" />
	</form>
    <div class="modal fade in" id="viewerListModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="bbs.label.viewr_list" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="bbs.label.viewr_list" /><!-- 조회자 목록 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="viewerListModalIfm" name="viewerListModalIfm" title="viewerListModalIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>

    <iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="downloadIfm"></iframe>
</body>
</html>