<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

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
<%-- 에디터 --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp"%>
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
<script type="text/javascript">
	var HAKSA_YEAR 		= '<c:out value="${param.haksaYear}" />';
	var HAKSA_TERM		= '<c:out value="${param.haksaTerm}" />';
	var BBS_CD 			= '<c:out value="${param.bbsCd}" />';
	var CRS_CRE_CD		= '<c:out value="${param.crsCreCd}" />';
	var TEAM_CTGR_CD	= '<c:out value="${param.teamCtgrCd}" />';
	var TEAM_CD			= '<c:out value="${param.teamCd}" />';
	var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
	var PAGE_INDEX		= '<c:out value="${param.pageIndex}" />';
	var LIST_SCALE		= '<c:out value="${param.listScale}" />';
	var TAB 			= '<c:out value="${param.tab}" />';
	var BBS_ID 			= '<c:out value="${param.bbsId}" />';
	var ATCL_ID 		= '<c:out value="${param.atclId}" />';
	var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
	
	$(document).ready(function() {
		var ansrUseYn = '<c:out value="${bbsInfoVO.ansrUseYn}" />';		// 게시판 정보 답글사용여부
		var cmntUseYn = '<c:out value="${bbsInfoVO.cmntUseYn}" />';		// 게시판 정보 댓글 사용여부
		var atclCmntUseYn = '<c:out value="${bbsAtclVO.cmntUseYn}" />';	// 게시글 댓글 사용여부
		
		// 답글 사용
		if(ansrUseYn == "Y") {
			bbsAnswer.list();
		}
		
		// 댓글 사용
		if(cmntUseYn == "Y" && atclCmntUseYn == "Y") {
			bbsComment.initCommentArea("#commentArea", {
		  		  bbsId	: '<c:out value="${bbsAtclVO.bbsId}" />'
				, atclId: '<c:out value="${bbsAtclVO.atclId}" />'
				, bbsCd	: '<c:out value="${bbsAtclVO.bbsCd}" />'
			}, {
				  useWriteAreaOpen: true
				, useViewAreaOpen: true
				, useWriteAreaToggleBtn: false
			});
		}
	});
	
	// 좋아요
	function addGoodCnt() {
		var url = '/bbs/' + TEMPLATE_URL + '/editGoodCnt.do';
		var data = {
			  crsCreCd	: CRS_CRE_CD
			, bbsId		: BBS_ID
			, atclId	: ATCL_ID
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
	    		var returnVO = data.returnVO;
	    		var goodCnt = returnVO.goodCnt;
	    		var viewerGoodCnt = returnVO.viewerGoodCnt;
	    		
	    		if(viewerGoodCnt == 0) {
	    			$("#goodCntIcon").addClass("disabled");
	    		} else {
	    			$("#goodCntIcon").removeClass("disabled");
	    		}
	    		
	    		$("#goodCntText").text(goodCnt);
	        }
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 게시글 삭제
	function removeAtcl() {
		// 게시글 삭제 시 댓글도 모두 삭제됩니다. 정말 삭제 하시겠습니까?
		if(confirm('<spring:message code="bbs.confirm.delete_atcl" />')) {
			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
				, bbsId		: BBS_ID
				, atclId	: ATCL_ID
			};
			
			$.ajax({
	            url : url,
	            type : "post",
	            data: data,
	        }).done(function(data) {
				alert(data.message);
	        	
	        	if (data.result > 0) {
	        		var queryInfo = {};
	        		
	        		if(BBS_CD) {
	        			queryInfo.bbsCd = BBS_CD;
	        		}
	        		
	        		if(CRS_CRE_CD) {
	        			queryInfo.crsCreCd = CRS_CRE_CD;
	        		}
	        		
	        		if(TEAM_CTGR_CD && TEAM_CD) {
	        			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
	        			queryInfo.teamCd = TEAM_CD;
	        		}
	        		
	        		if(BBS_ID) {
	        			queryInfo.bbsId = BBS_ID;
	        		} 
	        		
	        		if(TAB) {
	        			queryInfo.tab = TAB;
	        		}
	        		
	        		var url = "/bbs/" + TEMPLATE_URL + "/atclList.do";
	        		var queryStr = new URLSearchParams(queryInfo).toString();
	        		
	        		bbsCommon.movePost(url, queryStr);
	            }
	        }).fail(function() {
	        	alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
	        });
		}
	}
	
	// 글수정 페이지 이동
	function moveEditAtcl() {
		var queryInfo = {};
		
		if(BBS_CD) {
			queryInfo.bbsCd = BBS_CD;
		}
		
		if(CRS_CRE_CD) {
			queryInfo.crsCreCd = CRS_CRE_CD;
		}
		
		if(BBS_CD == "TEAM") {
			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
			queryInfo.teamCd	 = TEAM_CD;
		}
		
		if(SEARCH_VALUE) {
			queryInfo.searchValue = SEARCH_VALUE;
		}
		
		if(PAGE_INDEX) {
			queryInfo.pageIndex = PAGE_INDEX
		}
		
		if(LIST_SCALE) {
			queryInfo.listScale	= LIST_SCALE;
		}
		
		if(TAB) {
			queryInfo.tab = TAB;
		}
		
		queryInfo.bbsId = BBS_ID
		queryInfo.atclId = ATCL_ID
		
		var url = "/bbs/" + TEMPLATE_URL + "/Form/atclEdit.do";
		var queryStr = new URLSearchParams(queryInfo).toString();
		
		bbsCommon.movePost(url, queryStr);
	}
	
	// 목록이동
	function moveAtclList() {
		var queryInfo = {};
		
		if(HAKSA_YEAR && HAKSA_TERM) {
			queryInfo.haksaYear = HAKSA_YEAR;
			queryInfo.haksaTerm = HAKSA_TERM;
		}
		
		if(BBS_CD) {
			queryInfo.bbsCd = BBS_CD;
		}
		
		if(CRS_CRE_CD) {
			queryInfo.crsCreCd = CRS_CRE_CD;
		}
		
		if(TEAM_CTGR_CD && TEAM_CD) {
			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
			queryInfo.teamCd	 = TEAM_CD;
		}
		
		if(BBS_ID) {
			queryInfo.bbsId = BBS_ID;
		}
		
		if(SEARCH_VALUE) {
			queryInfo.searchValue = SEARCH_VALUE;
		}
		
		if(PAGE_INDEX) {
			queryInfo.pageIndex	= PAGE_INDEX;
		}
		
		if(LIST_SCALE) {
			queryInfo.listScale	= LIST_SCALE;
		}
		
		if(TAB) {
			queryInfo.tab = TAB;
		}
		
		var url = "/bbs/" + TEMPLATE_URL + "/atclList.do";
		var queryStr = new URLSearchParams(queryInfo).toString();
		
		bbsCommon.movePost(url, queryStr);
	}
	
	// 이전, 다음 글
	function moveAtclPost(atclId) {
		// 링크설정
		var queryInfo = {};
		
		if(HAKSA_YEAR && HAKSA_TERM) {
			queryInfo.haksaYear = HAKSA_YEAR;
			queryInfo.haksaTerm = HAKSA_TERM;
		}
		
		if(BBS_CD) {
			queryInfo.bbsCd = BBS_CD;
		}
		
		if(CRS_CRE_CD) {
			queryInfo.crsCreCd	= CRS_CRE_CD;
		}
		
		queryInfo.bbsId			= "${bbsAtclVO.bbsId}";
		queryInfo.atclId		= atclId;
		
		/*
		if(SEARCH_VALUE) {
			queryInfo.searchValue	= SEARCH_VALUE;
		}
		*/
		var queryStr = new URLSearchParams(queryInfo).toString();
		var linkUrl = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do";
		bbsCommon.movePost(linkUrl, queryStr);
	}
	
	// 다운로드
	function fileDown(fileSn, repoCd) {
		var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : fileSn,
			"repoCd" : repoCd
		};
		
		ajaxCall(url, data, function(data) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "downloadForm");
			form.attr("id", "downloadForm");
			form.attr("target", "downloadIfm");
			form.attr("action", data);
			form.appendTo("body");
			form.submit();
			
			$("#downloadForm").remove();
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 답글
	var bbsAnswer = {
		editor: null,
		answerWriteAuth: '<c:out value="${answerWriteAuth}" />',
		createHtml: function(atclInfo, type) {
			var html = '';
			var regNm = ' - ';
			var regDttm = ' - ';
			var atclCts = "";
			var atclDiv = "atclDiv";
			
			if(type == "VIEW") {
				atclCts = '<spring:message code="bbs.label.before_answer" />'; // 답변전입니다.
			}
			
			if(atclInfo) {
				regNm = atclInfo.regNm;
				regDttm = (atclInfo.regDttm || "").length == 14 ? atclInfo.regDttm.substring(0, 4) + '.' + atclInfo.regDttm.substring(4, 6) + '.' + atclInfo.regDttm.substring(6, 8) + " (" + atclInfo.regDttm.substring(8, 10) + ":" + atclInfo.regDttm.substring(10, 12) + ")" : atclInfo.regDttm;
				atclCts = atclInfo.atclCts;
				atclDiv = "atclDiv_" + atclInfo.atclId;
			}
			
			html += '<div class="ui segment" id="' + atclDiv + '">';
			html += '	<div class="flex mb10">';
			html += '		<div class="flex_1">';
			html += '			<label class="ui green label w50 small tc mr5">A</label>';
			html += '			<small class="bbs-post-info opacity7">';
			html += '				<em><spring:message code="bbs.label.answer" /> : ' + regNm + '</em>';			// 답변
			html += '				<em><spring:message code="bbs.label.answer_date" /> : ' + regDttm + '</em>'; 	// 답변일
			html += '			</small>';
			html += '		</div>';
			html += '		<div class="button-area">';
	if(bbsAnswer.answerWriteAuth == "Y") {
		// 버튼 - 답글 보기  (교수자)
		if(type == "VIEW" && atclInfo && atclInfo.rgtrId == "${userId}") {
			html += '			<a href="javascript:void(0)" onclick="bbsAnswer.openEditForm(\'' + atclInfo.bbsId + '\', \'' + atclInfo.atclId + '\')" class="ui basic button small"><spring:message code="common.button.modify" /></a>'; // 수정
			html += '			<a href="javascript:void(0)" onclick="bbsAnswer.remove(\'' + atclInfo.bbsId + '\', \'' + atclInfo.atclId + '\')" class="ui basic button small"><spring:message code="common.button.delete" /></a>'; // 삭제
		}
		// 버튼 - 답글 수정 폼 (교수자)
		if(type != "VIEW" && atclInfo && atclInfo.rgtrId == "${userId}") {
			html += '			<a href="javascript:void(0)" onclick="bbsAnswer.edit(\'' + atclInfo.bbsId + '\', \'' + atclInfo.atclId + '\')" class="ui basic button small"><spring:message code="common.button.modify" /></a>'; // 수정
			html += '			<a href="javascript:void(0)" onclick="bbsAnswer.list()" class="ui basic button small"><spring:message code="common.button.cancel" /></a>'; // 취소
		}
		// 버튼 - 답글 작성 폼 (교수자)
		if(type != "VIEW" && !atclInfo) {
			html += '			<a href="javascript:void(0)" onclick="bbsAnswer.add(\'\')" class="ui blue button small"><spring:message code="common.button.save" /></a>'; // 저장
		}
	}
			html += '		</div>';
			html += '	</div>';
			
		if(type == "VIEW") {
			html += '	<div class="ui divider mt5"></div>';
			html += '	<div class="ui message p0 m0 pt10"><div class="atclView">' + atclCts + '</div></div>';
		} else {
			html += '	<dl style="display:table; width:100%;">';
			html += '		<dd style="height: 300px;display:table-cell">';
			html += '			<div class="editor-responsive" style="height: 90%">';
			html += '				<label for="contentTextArea"><spring:message code="common.reply" /></label>';	// 답글
			html += '				<textarea name="contentTextArea" id="contentTextArea">' + atclCts + '</textarea>';
			html += '			</div>';
			html += '		</dd>';
			html += '	</dl>';
			html += '	<div class="button-area mt15">';
			html += '		<div class="inline-flex-item flex-wrap">';
			html += '			<small class="pr10"><spring:message code="bbs.label.easy_answer" /></small>'; // 간편 답글
			html += '			<div>';
			html += '				<a href="javascript:void(0)" onclick="bbsAnswer.setEasyAnswer(1, this, \'\');" class="easy-answer-btn ui basic small label">';	// 수고했어요.
			html += '					<span class="mr5"><spring:message code="forum.button.cts0" /></span><i class="icon chevron down" style="visibility: hidden;"></i>';
			html += '				</a>';
			html += '				<a href="javascript:void(0)" onclick="bbsAnswer.setEasyAnswer(2, this, \'\');" class="easy-answer-btn ui basic small label">';	// 고생하셨어요.
			html += '					<span class="mr5"><spring:message code="forum.button.cts1" /></span><i class="icon chevron down" style="visibility: hidden;"></i>';
			html += '				</a>';
			html += '				<a href="javascript:void(0)" onclick="bbsAnswer.setEasyAnswer(3, this, \'\');" class="easy-answer-btn ui basic small label">';	// 감사합니다
			html += '					<span class="mr5"><spring:message code="forum.button.cts2" /></span><i class="icon chevron down" style="visibility: hidden;"></i>';
			html += '				</a>';
			html += '			</div>';
			html += '		</div>';
			html += '	</div>';
		}
			html += '</div>';
			// 댓글영역
			if(atclInfo && (atclInfo.bbsCd == "QNA" || atclInfo.bbsCd == "SECRET") && atclInfo.cmntUseYn == "Y") {
				html += '<div id="answerCmnt_' + atclInfo.atclId + '"></div>';
				html += '<div class="ui divider"></div>';
			}
			
			return html;
		},
		openViewForm: function(atclInfo) {
			if(atclInfo != undefined) {
				atclInfo.forEach(function(v, i) {
					var html = bbsAnswer.createHtml(v, "VIEW");
					$("#answerViewArea").append(html);
					bbsAnswer.editor = null;
					
					if(v.cmntUseYn == "Y") {
						// 댓글영역 초기화
						bbsComment.initCommentArea("#answerCmnt_" + v.atclId, {
							  bbsId: v.bbsId
							, atclId: v.atclId
							, bbsCd: v.bbsCd
							, parAtclId: v.parAtclId
						}, {
						      useWriteAreaOpen: false
							, useViewAreaOpen: true
							, useWriteAreaToggleBtn: true
						});
					}
				});
			} else {
				var html = bbsAnswer.createHtml(atclInfo, "VIEW");
				$("#answerViewArea").empty().html(html);
				bbsAnswer.editor = null;
			}
		},
		openWriteForm: function(atclInfo) {
			var html = bbsAnswer.createHtml(atclInfo);
			if(atclInfo) {
				$("#atclDiv_"+atclInfo.atclId).empty().html(html);
			} else {
				$("#answerViewArea").empty().html(html);
			}
			bbsAnswer.editor = HtmlEditor('contentTextArea', THEME_MODE, '/bbs/'+BBS_ID);
		}, 
		openEditForm: function(bbsId, atclId) {
			var url = "/bbs/bbsHome/atclInfo.do";
			var data = {
           	      bbsId: bbsId
            	, atclId: atclId
            };
			
			ajaxCall(url, data, function(data) {
				var returnVO = data.returnVO;
	        	
	        	if (data.result > 0 && returnVO) {
        			bbsAnswer.openWriteForm(returnVO);
	            } else {
	            	alert('<spring:message code="bbs.error.not_exists_atcl" />'); // 게시글 정보를 찾을 수 없습니다.
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		},
		add: function(type) {
			var editor = type == "other" ? otherEditor : this.editor;
			
			if(editor.isEmpty()) {
				alert('<spring:message code="bbs.alert.empty_content" />'); // 내용은 필수 항목입니다. 다시 확인 바랍니다.
				editor.execCommand('selectAll');
				editor.execCommand('deleteLeft');
				editor.execCommand('insertText', "");
				return;
			}
			
			var url = "/bbs/" + TEMPLATE_URL + "/addAtcl.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
	           	, bbsId		: '<c:out value="${bbsAtclVO.bbsId}" />'
	           	, parAtclId	: '<c:out value="${bbsAtclVO.atclId}" />'
	           	, atclCts	: type == "other" ? $("#otherContentTextArea").val() : $("#contentTextArea").val()
			};
			
			ajaxCall(url, data, function(data) {
				alert(data.message);
	        	
	        	if(data.result > 0) {
	        		moveReload();
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		},
		edit: function(bbsId, atclId) {
			var editor = this.editor;
			
			if(editor.isEmpty()) {
				alert('<spring:message code="bbs.alert.empty_content" />'); // 내용은 필수 항목입니다. 다시 확인 바랍니다.
				editor.execCommand('selectAll');
				editor.execCommand('deleteLeft');
				editor.execCommand('insertText', "");
				return;
			}
			
			var url = "/bbs/" + TEMPLATE_URL + "/editAtcl.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
            	, bbsId		: bbsId
            	, atclId	: atclId
            	, atclCts	: $("#contentTextArea").val()
			};
			
			ajaxCall(url, data, function(data) {
	        	if(data.result > 0) {
	        		moveReload();
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		},
		remove: function(bbsId, atclId) {
			if(!confirm('<spring:message code="bbs.confirm.delete" />')) return; // 정말 삭제 하시겠습니까?
					
			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
            	, bbsId		: bbsId
            	, atclId	: atclId
			};
			
			ajaxCall(url, data, function(data) {
				alert(data.message);
	        	
	        	if(data.result > 0) {
	        		moveReload();
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		},
		list: function() {
			var url = "/bbs/" + TEMPLATE_URL + "/listAnswerAtcl.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
				, bbsId 	: '<c:out value="${bbsAtclVO.bbsId}" />'
           		, parAtclId : '<c:out value="${bbsAtclVO.atclId}" />'	
			}
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		
	        		if(returnList.length > 0) {
	        			// 1개의 답글만 있음
	        			bbsAnswer.openViewForm(returnList);
	        		} else {
	        			if(bbsAnswer.answerWriteAuth == "Y") {
	        				bbsAnswer.openWriteForm();
	        			} else {
	        				bbsAnswer.openViewForm();
	        			}
	        		}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		},
		// 간편답글 적용
		setEasyAnswer: function(order, el, type) {
			var unSelectBgColor = "basic";
			var selectBgColor = "green";
			var isSelected = $(el).hasClass(selectBgColor);
			
			// 버튼 색상 미선택으로 변경
			$(el).siblings($(".easy-answer-btn")).removeClass(selectBgColor).addClass(unSelectBgColor);
			$(el).siblings($(".easy-answer-btn")).find("i").css("visibility", "hidden");
			
			var msg = "";
			
			if(!isSelected) {
				if(order == "1") {
					/* 수고했어요. */
					msg = "<spring:message code='forum.button.cts0' />";
				} else if(order == "2") {
					/* 고생하셨어요. */
					msg = "<spring:message code='forum.button.cts1' />";
				} else if(order == "3") {
					/* 감사합니다. */
					msg = "<spring:message code='forum.button.cts2' />";
				}
				
				$(el).removeClass(unSelectBgColor).addClass(selectBgColor);
				$(el).find("i").css("visibility", "visible");
			}
			
			if(type == "other") {
				otherEditor.execCommand('selectAll');
				otherEditor.execCommand('deleteLeft');
				otherEditor.execCommand('insertText', msg);
			} else {
				bbsAnswer.editor.execCommand('selectAll');
				bbsAnswer.editor.execCommand('deleteLeft');
				bbsAnswer.editor.execCommand('insertText', msg);
			}
		}
	};
	
	// 댓글
	var bbsComment = {
		option : {
			  useWriteAreaOpen: false 	// 댓글입력창 오픈여부
			, useViewAreaOpen: false	// 댓글보기창 오픈여부
			, useWriteAreaToggleBtn: true // 댓글쓰기 버튼 사용여부
		},
		initCommentArea: function(target, bbsAtclVO, option) {
			var commentOption = $.extend(this.option, option);
			
			var bbsId = bbsAtclVO.bbsId;
			var atclId = bbsAtclVO.atclId;
			var bbsCd = bbsAtclVO.bbsCd;
			var parAtclId = bbsAtclVO.parAtclId;
			var commentWriteAuth = '<c:out value="${commentWriteAuth}" />';
			
			if(parAtclId) {
				commentWriteAuth = "Y";
			}
			
			commentOption.commentWriteAuth = commentWriteAuth;
			
			var html = '';
			
			// 댓글영역 추가
			html += '<div class="comment border0 mt10">';
			html += '	<div class="ui box flex-item ">';
			html += '		<div class="flex-item mra" id="commentViewBtnArea_' + atclId + '" style="visibility: hidden">';
			html += '			<button class="toggle_commentlist flex-item" type="button">';
			html += '				<i class="xi-message-o f120 mr5" aria-hidden="true"></i>';
			html += '				<span id="cmntCntText_' + atclId + '"></span><span class="desktop_elem"><spring:message code="bbs.button.open_comment" /><!-- 개의 댓글이 있습니다. --></span>';
			html += '				<i class="xi-angle-down-min" aria-hidden="true"></i>';
			html += '			</button>';
			html += '		</div>';
			if(commentWriteAuth == "Y" && commentOption.useWriteAreaToggleBtn) {
				html += '	<div>';
				html += '		<button class="ui basic small button toggle_commentwrite" id="commentWriteBtn_' + atclId + '" type="button" onclick=""><spring:message code="bbs.button.open_write_comment" /><!-- 댓글 작성하기 --></button>';
				html += '	</div>'; // 댓글 버튼 영역
			}
			html += '	</div>';
			html += '	<div class="ui box">';
			if(commentWriteAuth == "Y") {
				html += '	<div class="toggle_box pt10 commentwrite" id="commentWriteArea_' + atclId + '">';
				html += '		<ul class="comment-write  bcdark1Alpha05 p8">';
				if(!bbsCommon.isStudent()) {
					html += '		<li class="flex-item mra pb4">';
					html += '			<small class="pr4"><spring:message code="bbs.label.easy_comment" /></small>'; // 간편 댓글
					html += '			<a href="javascript:void(0)" onclick="bbsComment.setEasyComment(\'' + atclId + '\', \'1\', this);" class="ui basic mini label easyCommentBtn_' + atclId + '"><spring:message code="forum.button.cts0" /></a>'; // 수고했어요
					html += '			<a href="javascript:void(0)" onclick="bbsComment.setEasyComment(\'' + atclId + '\', \'2\', this);" class="ui basic mini label easyCommentBtn_' + atclId + '"><spring:message code="forum.button.cts1" /></a>'; // 고생하셨어요
					html += '			<a href="javascript:void(0)" onclick="bbsComment.setEasyComment(\'' + atclId + '\', \'3\', this);" class="ui basic mini label easyCommentBtn_' + atclId + '"><spring:message code="forum.button.cts2" /></a>'; // 감사합니다.
					html += '		</li>';
				}
				html += '			<li>';
				html += '				<label for="cmntCts" class="blind"><spring:message code="bbs.label.comment" /></label>'; // 댓글
				html += '				<textarea id="cmntCts_' + atclId + '" rows="3" class="wmax" placeholder="<spring:message code="bbs.common.placeholder_comment" />"></textarea>'; // 댓글 입력, 최소 5자 입력하세요.
				html += '			</li>';
				html + '			<li class="flex-item flex-wrap">'
				/*
				if(bbsCommon.isStudent() && bbsCd == "QNA") {
					html += '			<input type="checkbox" tabindex="0" class="hidden" id="feedbackYN" />';
					html += '			<label for="feedbackYN"><spring:message code="bbs.label.feedback_qna" /><!-- 피드백 문의 --> <span class="">( <spring:message code="bbs.label.guide_feedback_qna" /><!-- 체크 시 문의로 등록되며 답변을 받을 수 있습니다. --> )</span></label>';
				}
				*/
				html += '				<a href="javascript:void(0)" class="ui basic grey small button mt5" onclick="bbsComment.add(\'' + atclId + '\')"><spring:message code="common.button.create" /></a>'; // 등록 
				html += '			</li>';
				html += '		</ul>';
				html += '	</div>';
			}
			html += '		<div class="article p10 commentlist" id="commentViewArea_' + atclId + '"></div>'; // 댓글 보기 영역
			html += '	</div>';
			html += '</div>';
			
			$(target).html(html);
			
			// n개의 댓글이 있습니다. 버튼 이벤트
			$("#commentViewBtnArea_" + atclId).off("click").on("click", function() {
				if($("#commentViewArea_" + atclId).is(":visible")) {
					$("#commentViewArea_" + atclId).hide();
				} else {
					$("#commentViewArea_" + atclId).show();
				}
			});
			
			// 댓글 작성하기 버튼 이벤트
			$("#commentWriteBtn_" + atclId).off("click").on("click", function() {
				if($("#commentWriteArea_" + atclId).is(":visible")) {
					$("#commentWriteArea_" + atclId).hide();
				} else {
					$("#commentWriteArea_" + atclId).show();
				}
			});

			bbsComment["listPaging_" + atclId] = new bbsComment.initPaging(bbsId, atclId, commentOption);
			bbsComment["listPaging_" + atclId](1); // 댓글목록 조회
			
			// 댓글작성 영역
			if(commentOption.useWriteAreaOpen) {
				$("#commentWriteArea_" + atclId).show();
			}
			
			// 댓글보기 영역
			if(commentOption.useViewAreaOpen) {
				$("#commentViewArea_" + atclId).show();
			}
		},
		initPaging: function(bbsId, atclId, commentOption) {
			var listPaging = function(pageIndex) {
				var url = "/bbs/" + TEMPLATE_URL + "/cmntList.do";
				var data = {
					  crsCreCd	: CRS_CRE_CD
					, bbsId		: bbsId
	            	, atclId	: atclId
	            	, listScale : 10
	            	, pageIndex	: pageIndex
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
		        		var returnList = data.returnList || [];
		        		var returnVO = data.returnVO;
		        		var pageInfo = data.pageInfo;
		        		
		        		// 댓글 관리자 권한
		    			var isCommentManager = false;
		    			
		    			if(TEMPLATE_URL == "bbsLect") {
		    				if(bbsCommon.isProfessor()) {
		    					isCommentManager = true;
		    				}
		    			} else {
		    				if(bbsCommon.isAdmin()) {
		    					isCommentManager = true;
		    				}
		    			}
		    			
		    			var html = '';
		    			returnList.forEach(function(v, i) {
		    				var regDttm = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + " (" + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) + ")" : v.regDttm;
		    				var isDeleted = v.delYn == 'Y';
		    				var innerClass = v.level > 1 ? 'co_inner' : '';
		    				var toUserText = v.level > 2 ? '<small class="mr5">@' + v.toUserNm + '</small>' : '';
		    				var deleteText = isDeleted ? '<span class="ui red label ml5"><spring:message code="bbs.label.deleted" /></span>' : ''; // 삭제됨;
		    				var cmntCts = v.cmntCts;
		    				cmntCts = cmntCts.replaceAll("<", "&lt").replaceAll(">", "&gt") + deleteText;
		    				cmntCts = toUserText + cmntCts;
		    				
		    				if(!isCommentManager && isDeleted) {
		    					cmntCts = deleteText;
		    				}
		    				
		    				html += '<ul class="' + innerClass + '">';
		    				html += '	<li class="imgBox">';
		    				html += '		<div class="initial-img sm c-4">';
		    				if(v.phtFile) {
		    					html += 		'<img src="' + v.phtFile + '" alt="Image">';
		    				} else {
		    					html += 		v.regNm;
		    				}
		    				html += '		</div>';
		    				html += '	</li>';
		    				html += '	<li>';
		    				html += '		<ul>';
		    				// 댓글 수정영역 Start
		    				if(!isDeleted) {
		    					html += '		<li class="toggle_box childCommentEdit_' + atclId + '" id="childCommentEdit_' + v.cmntId + '">';
		    					html += '			<ul class="comment-write">';
		    					html += '				<li>';
		    					html += '				    <label for="editCmntCts_' + v.cmntId + '"><spring:message code="asmnt.button.cmnt" /></label>';	// 댓글
		    					html += '					<textarea id="editCmntCts_' + v.cmntId + '"  rows="3" class="wmax" placeholder="<spring:message code="bbs.common.placeholder_child_comment" />"></textarea>'; // 댓글에 댓글을 입력, 최소 5자 입력하세요.
		    					html += '				</li>';
		    					html += '				<li>';
		    					html += '					<a href="javascript:void(0)" class="ui basic grey small button" onclick="bbsComment.edit(\'' + atclId + '\', \'' + v.cmntId + '\')"><spring:message code="common.button.modify" /></a>'; // 수정
		    					html += '					<a href="javascript:void(0)" class="ui basic grey small button" onclick="bbsComment.editFormCancel(\'' + atclId + '\')"><spring:message code="common.button.cancel" /></a>'; // 취소
		    					html += '				</li>';
		    					html += '			</ul>';
		    					html += '		</li>';
		    				}
		    				// 댓글 수정영역 End
		    				// 타이틀 Start
		    				html += '			<li class="flex-item">';
		    				html += '				<em class="mra">' + v.regNm;
		    				html += '					<code>' + regDttm + (isCommentManager ? '<small class="ml5 mr5 f080">|</small><spring:message code="bbs.label.word.cnt" /> : ' + v.cmntCts.length : '') + '</code>'; // 날짜 | 글자수
		    				html += '				</em>';
		    				if(!isDeleted) {
		    					if(commentOption.commentWriteAuth == "Y") {
		    						html += '		<button type="button" class="toggle_btn" onclick="bbsComment.toggleChildCommentWriteArea(\'' + atclId + '\', \'' + v.cmntId + '\')"><spring:message code="bbs.label.comment" /></button>'; // 댓글
		    					}
		    					if(v.editAuthYn == "Y" || v.deleteAuthYn == "Y") {
			    					html += '		<ul class="ui icon top right pointing dropdown" tabindex="0" style="' + (v.editAuthYn == "Y" || isCommentManager ? '' : 'visibility:hidden') + '">';
			    					html += '			<i class="xi-ellipsis-v p5"></i>';
			    					html += '			<div class="menu" tabindex="-1">';
			    					if(v.editAuthYn == "Y") {
			    						html += '			<button type="button" class="item" onclick="bbsComment.editForm(\'' + atclId + '\', \'' + v.cmntId + '\')"><spring:message code="common.button.modify" /></button>'; // 수정
			    					}
			    					if(v.deleteAuthYn == "Y") {
			    						html += '			<button type="button" class="item" onclick="bbsComment.remove(\'' + atclId + '\', \'' + v.cmntId + '\')"><spring:message code="common.button.delete" /></button>'; // 삭제
			    					}
			    					html += '			</div>';
			    					html += '		</ul>';
		    					}
		    				}
		    				html += '			</li>';
		    				// 타이틀 End
		    				// 본문 Start
		    				html += '			<li id="cmntBody_' + v.cmntId + '" style="word-break: break-word">';
		    				html += 				cmntCts
		    				html += '			</li>';
		    				// 본문 End
		    				if(commentOption.commentWriteAuth == "Y") {
		    					// 대댓글 작성영역 Start
			    				html += '		<li class="toggle_box childCommentWriteArea_' + atclId + '" id="childCommentWriteArea_' + v.cmntId + '">';
			    				html += '			<ul class="comment-write">';
			    				html += '				<li>';
			    				html += '					<label for="cmntCts_' + v.cmntId + '"><spring:message code="asmnt.button.cmnt" /></label>';	// 댓글
			    				html += '					<textarea id="cmntCts_' + v.cmntId + '"  rows="3" class="wmax" placeholder="<spring:message code="bbs.common.placeholder_child_comment" />"></textarea>'; // 댓글에 댓글을 입력, 최소 5자 입력하세요.
			    				html += '				</li>';
			    				html += '				<li>';
			    				html += '					<a href="javascript:void(0)" class="ui basic grey small button" onclick="bbsComment.add(\'' + atclId + '\', \'' + v.cmntId + '\')"><spring:message code="common.button.create" /></a>'; // 등록
			    				html += '				</li>';
			    				html += '			</ul>';
			    				html += '		</li>';
		    					// 대댓글 작성영역 End
		    				}
		    				html += '		</ul>';
		    				html += '	</li>';
		    				html += '</ul>';
		    			});
		    			
		    			if(returnList.length > 0) {
		    				html += '<div id="paging_' + atclId + '" class="paging"></div>';
		    			}
		        		
		    			$("#commentViewArea_" + atclId).empty().html(html);
		    			$("#commentViewArea_" + atclId).find(".dropdown").dropdown();
		    			
		    			// n 개의 댓글이 있습니다.
		    			$("#cmntCntText_" + atclId).text(returnVO.totalCnt);
		    			
		    			
		    			if(!commentOption.useWriteAreaOpen) {
		    				// n 개의 댓글이 있습니다. 버튼 show/hide
			    			if(returnList.length > 0) {
			    				$("#commentViewBtnArea_" + atclId).css("visibility", "visible");
			    			} else {
			    				$("#commentViewBtnArea_" + atclId).css("visibility", "hidden");
			    			}
		    				
		    				$("#commentWriteArea_" + atclId).hide();
		    			} else {
		    				$("#commentViewBtnArea_" + atclId).css("visibility", "visible");
		    			}
		    			
		    			var params = {
	       					totalCount : data.pageInfo.totalRecordCount,
	       					listScale : data.pageInfo.recordCountPerPage,
	       					currentPageNo : data.pageInfo.currentPageNo,
	       					eventName : "bbsComment.listPaging_" + atclId,
	       					pagingDivId: "paging_" + atclId
	       				};

	       				gfn_renderPaging(params);
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				});
			};
			
			return listPaging;
		},
		add: function(atclId, parCmntId) {
			var parCmntId = parCmntId || "";
			var cmntCts;
			
			if(parCmntId) {
				cmntCts = $("#cmntCts_" + parCmntId).val();
			} else {
				cmntCts = $("#cmntCts_" + atclId).val();
			}
			
			if(!cmntCts) {
				/*  댓글 내용은 필수 항목입니다. 다시 확인 바랍니다. */
				alert('<spring:message code="bbs.alert.empty_content_comment" />');
				return;
			}
			
			if(cmntCts.length < 5) {
				/* 댓글은 최소 5자 입력하세요. */
				alert('<spring:message code="bbs.alert.short_comment" />');
				return;
			}

			var url = "/bbs/" + TEMPLATE_URL + "/addCmnt.do";
			var data = {
				  crsCreCd : CRS_CRE_CD
            	, bbsId : '<c:out value="${bbsAtclVO.bbsId}" />'
            	, atclId : atclId
            	, parCmntId : parCmntId
            	, cmntCts : cmntCts
            	, feedbackYN: $("#feedbackYN").is(":checked") ? "Y" : "N"
			};
			
			ajaxCall(url, data, function(data) {
				alert(data.message);
	        	
	        	if(data.result > 0) {
	        		$("#commentViewArea_" + atclId).show();	// 댓글목록 영역 show
	        		bbsComment["listPaging_" + atclId](1);  // 댓글목록 조회
	        		
	        		if(parCmntId) {
	    				cmntCts = $("#cmntCts_" + parCmntId).val("");
	    			} else {
	    				cmntCts = $("#cmntCts_" + atclId).val("");
	    			}
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		},
		editForm: function(atclId, cmntId) {
			// 대댓글 작성 닫기
			bbsComment.closeChildCommentWriteArea(atclId);
			// 대댓글 수정 닫기
			bbsComment.closeChildCommentEditArea(atclId);
			
			var url = "/bbs/" + TEMPLATE_URL + "/cmntInfo.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
            	, bbsId		: '<c:out value="${bbsAtclVO.bbsId}" />'
            	, atclId	: atclId
            	, cmntId	: cmntId
			};
			
			$.ajax({
	            url : url,
	            type : "post",
	            data: data,
	            async: false,
	        }).done(function(data) {
	        	if (data.result > 0) {
	        		var returnVO = data.returnVO;
	        		var cmntCts = returnVO.cmntCts;
	        		
	        		// 대댓글 입력창 show
	        		$("#childCommentEdit_" + cmntId).show();
	        		
	        		// 대댓글 수정 내용 설정
	        		$("#editCmntCts_" + cmntId).val(cmntCts);
	            }
	        }).fail(function() {
	        	alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
	        });
		},
		edit: function(atclId, cmntId) {
			var cmntCts = $("#editCmntCts_" + cmntId).val();
			
			if(!cmntCts) {
				/* 댓글 내용은 필수 항목입니다. 다시 확인 바랍니다. */
				alert('<spring:message code="bbs.alert.empty_content_comment" />');
				return;
			}
			
			if(cmntCts.length < 5) {
				/* 댓글은 최소 5자 입력하세요. */
				alert('<spring:message code="bbs.alert.short_comment" />');
				return;
			}
			
			var url = "/bbs/" + TEMPLATE_URL + "/editCmnt.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
            	, bbsId		: '<c:out value="${bbsAtclVO.bbsId}" />'
            	, atclId	: atclId
            	, cmntId	: cmntId
            	, cmntCts	: cmntCts
			};
			
			ajaxCall(url, data, function(data) {
				alert(data.message);
	        	
	        	if (data.result > 0) {
	        		$("#cmntBody_" + cmntId).text(cmntCts);
	        		bbsComment.editFormCancel(atclId);
	            }
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert('<spring:message code="fail.common.msg" />');
			}, true);
		},
		remove: function(atclId, cmntId) {
			if(!confirm('<spring:message code="bbs.confirm.delete" />')) return; // 정말 삭제 하시겠습니까?
			
			var url = "/bbs/" + TEMPLATE_URL + "/removeCmnt.do";
			var data = {
				  crsCreCd	: CRS_CRE_CD
            	, bbsId		: '<c:out value="${bbsAtclVO.bbsId}" />'
            	, atclId	: atclId
            	, cmntId	: cmntId
			};
			
			ajaxCall(url, data, function(data) {
				alert(data.message);
	        	
	        	if (data.result > 0) {
	        		bbsComment["listPaging_" + atclId](1); // 댓글목록 조회
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		},
		editFormCancel: function(atclId) {
			// 대댓글 작성 닫기
			bbsComment.closeChildCommentWriteArea(atclId);
			// 대댓글 수정 닫기
			bbsComment.closeChildCommentEditArea(atclId);
		},
		// 댓글작성 영역 - 간편댓글 세팅
		setEasyComment: function(atclId, type, el) {
			var unSelectBgColor = "basic";
			var selectBgColor = "green";
			var isSelected = $(el).hasClass(selectBgColor);
			
			// 버튼 색상 미선택으로 변경
			this.clearEasyComment(atclId);
			
			var msg = "";
			
			if(!isSelected) {
				if(type == "1") {
					/* 수고했어요. */
					msg = "<spring:message code='forum.button.cts0' />";
				} else if(type == "2") {
					/* 고생하셨어요. */
					msg = "<spring:message code='forum.button.cts1' />";
				} else if(type == "3") {
					/* 감사합니다. */
					msg = "<spring:message code='forum.button.cts2' />";
				}
				
				$(el).removeClass(unSelectBgColor).addClass(selectBgColor);
				$(el).find("i").css("visibility", "visible");
			}
			
			$("#cmntCts_" + atclId).val(msg);
		},
		// 댓글작성 영역 - 간편댓글 선택 초기화
		clearEasyComment: function(atclId) {
			var unSelectBgColor = "basic";
			var selectBgColor = "green";
			
			// 선택되어있는경우 내용도 초기화
			if($(".easyCommentBtn_" + atclId).hasClass(selectBgColor)) {
				$("#cmntCts_" + atclId).val("");
			}
			
			// 버튼 색상 미선택으로 변경
			$(".easyCommentBtn_" + atclId).removeClass(selectBgColor).addClass(unSelectBgColor);
			$(".easyCommentBtn_" + atclId + " > i").css("visibility", "hidden");
		},
		// 대댓글 작성 닫기
		closeChildCommentWriteArea: function(atclId) {
			$.each($(".childCommentWriteArea_" + atclId), function() {
				$(this).hide();
				
				// 대댓글 작성 초기화
				$(this).find("textarea").val("");
			});
			
		},
		// 대댓글 작성영역 show/hide
		toggleChildCommentWriteArea: function(atclId, cmntId) {
			// 대댓글 수정 닫기
			bbsComment.closeChildCommentEditArea(atclId);
			
			$.each($(".childCommentWriteArea_" + atclId), function() {
				if(this.id == ("childCommentWriteArea_" + cmntId)) {
					$(this).toggle();
				} else {
					$(this).hide();
				}
				
				// 대댓글 작성 초기화
				$(this).find("textarea").val("");
			});
		},
		// 대댓글 수정 닫기
		closeChildCommentEditArea: function(atclId) {
			$.each($(".childCommentEdit_" + atclId), function() {
				
				$(this).hide();
				
				// 대댓글 수정 초기화
				$(this).find("textarea").val("");
			});
		},
	};
	
	function moveReload() {
		var queryInfo = {};
		
		if(BBS_CD) {
			queryInfo.bbsCd = BBS_CD;
		}
		
		if(CRS_CRE_CD) {
			queryInfo.crsCreCd = CRS_CRE_CD;
		}
		
		if(BBS_CD == "TEAM") {
			queryInfo.teamCtgrCd = TEAM_CTGR_CD;
			queryInfo.teamCd	 = TEAM_CD;
		}
		
		if(SEARCH_VALUE) {
			queryInfo.searchValue = SEARCH_VALUE;
		}
		
		if(PAGE_INDEX) {
			queryInfo.pageIndex = PAGE_INDEX
		}
		
		if(LIST_SCALE) {
			queryInfo.listScale	= LIST_SCALE;
		}
		
		if(TAB) {
			queryInfo.tab = TAB;
		}
		
		queryInfo.bbsId = BBS_ID
		queryInfo.atclId = ATCL_ID
		
		var url = "/bbs/" + TEMPLATE_URL + "/Form/atclView.do";
		var queryStr = new URLSearchParams(queryInfo).toString();
		
		bbsCommon.movePost(url, queryStr);
	}
	
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">

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
									bbsTitle = '<spring:message code="bbs.label.bbs_manager_home" />';	// 관리자
								}
								
								var bbsSubTitle;
								var bbsCd = '<c:out value="${param.bbsCd}" />';
								var bbsNm = '<c:out value="${bbsInfoVO.bbsNm}" />';
								var tab = '<c:out value="${param.tab}" />';
	
								if(bbsCd == "TEAM") {
									bbsSubTitle = '<spring:message code="bbs.label.bbs_team" />';	// 팀게시판
								} else if(bbsCd == "ALARM") {
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
                        	<div class="mra">
	                            <h2 class="page-title">
	                                 <c:choose>
		                            	<c:when test="${templateUrl eq 'bbsHome'}">
		                            		<spring:message code="bbs.label.bbs_lect_home" /><!-- 강의실 홈 -->
		                            	</c:when>
		                            	<c:when test="${templateUrl eq 'bbsLect'}">
		                            		<c:choose>
		                            			<c:when test="${param.bbsCd eq 'TEAM'}">
		                            				<spring:message code="bbs.label.bbs_team" /><!-- 팀게시판 -->
		                            			</c:when>
		                            			<c:when test="${param.bbsCd eq 'ALARM'}">
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
                            </div>
                            <div class="button-area">
                            	<c:choose>
	                            	<c:when test="${templateUrl eq 'bbsHome'}">
	                            		<c:set var="btnColor1" value="bcTealAlpha85" />
	                            		<c:set var="btnColor2" value="bcDarkblueAlpha85" />
	                            		<c:set var="btnColor3" value="bcPurpleAlpha85" />
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsLect'}">
	                            		<c:set var="btnColor1" value="basic" />
	                            		<c:set var="btnColor2" value="basic" />
	                            		<c:set var="btnColor3" value="basic" />
	                            	</c:when>
	                            	<c:when test="${templateUrl eq 'bbsMgr'}">
	                            		<c:set var="btnColor1" value="basic" />
	                            		<c:set var="btnColor2" value="basic" />
	                            		<c:set var="btnColor3" value="basic" />
	                            	</c:when>
	                            </c:choose>
                            
                                <c:if test="${atclEditAuth eq 'Y'}">
			                        <a href="javascript:moveEditAtcl()" class="ui <c:out value="${btnColor1}" /> button"><spring:message code="common.button.modify" /></a><!-- 수정 -->
								</c:if>
								<c:if test="${atclDeleteAuth eq 'Y'}">
			                        <a href="javascript:removeAtcl()" class="ui <c:out value="${btnColor2}" /> button"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
			                    </c:if>
		                    	<a href="javascript:moveAtclList()" class="ui <c:out value="${btnColor3}" /> button"><spring:message code="common.button.list" /></a><!-- 목록 -->
                            </div>
                        </div>
		                 
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            <!-- 게시판 탭 -->
							<c:if test="${templateUrl eq 'bbsLect'}">
								<%@ include file="/WEB-INF/jsp/bbs/common/bbs_tab_inc.jsp" %>
							</c:if>
								
								<!-- 게시글 -->
								<div class="ui segment view">
									<ul class="tbl-simple type2">
										<li class="title-wrap">
											<div class="title">
												<c:choose>
													<c:when test="${bbsAtclVO.noticeYn eq 'Y'}">
														<c:choose>
															<c:when test="${bbsInfoVO.bbsCd eq 'PDS'}">
																<label class="ui brown label w50 small mr5 tc"><spring:message code="bbs.label.fix" /></label><!-- 공지 -->
															</c:when>
															<c:otherwise>
																<label class="ui orange label w50 small mr5 tc"><spring:message code="bbs.label.notice" /></label><!-- 공지 -->
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:when test="${bbsAtclVO.imptYn eq 'Y'}">
														<label class="ui red label w50 small mr5 tc"><spring:message code="bbs.label.impt" /></label><!-- 중요 -->
													</c:when>
												</c:choose>
												<strong>
												<c:choose>
													<c:when test="${bbsInfoVO.bbsCd eq 'TEAM'}">
														[<c:out value="${bbsAtclVO.teamCtgrNm}" />&nbsp;>&nbsp;<c:out value="${bbsAtclVO.teamNm}" />]
													</c:when>
													<c:otherwise>
														[<c:out value="${bbsAtclVO.bbsNm}" />]
													</c:otherwise>
												</c:choose>
												&nbsp;${bbsAtclVO.atclTitle}&nbsp;
												</strong>
											</div>
											<div class="list_verticalline">
												<fmt:parseDate  var="regDateFmt"  pattern="yyyyMMddHHmmss" value="${bbsAtclVO.regDttm}" />
					                            <fmt:formatDate var="regDttm" pattern="yyyy.MM.dd HH:mm" value="${regDateFmt}" />

												<small>
													<span class="desktop-elem"><spring:message code="bbs.label.reg_user" />&nbsp;:&nbsp;</span>
													<c:choose>
														<c:when test="${menuType.contains('PROFESSOR') and (bbsInfoVO.bbsCd eq 'QNA' or bbsInfoVO.bbsCd eq 'SECRET') and not empty bbsAtclVO.regMenuType and bbsAtclVO.regMenuType.contains('STUDENT')}">
															<c:out value="${bbsAtclVO.regNm}" />
															(<c:out value="${bbsAtclVO.rgtrId}" />)
															<a href="javascript:userInfoPop('<c:out value="${bbsAtclVO.rgtrId}" />')"><i class="ico icon-info" style="width: 1.5em; height: 1.5em;"></i></a>
														</c:when>
														<c:otherwise>
															<c:out value="${bbsAtclVO.regNm}" />
														</c:otherwise>
													</c:choose>
												</small><!-- 작성자 -->
												<small><span class="desktop-elem"><spring:message code="bbs.label.reg_date" />&nbsp;:&nbsp;</span><c:out value="${regDttm}" /></small><!-- 작성일 -->
												<small><spring:message code="bbs.label.hit" />&nbsp;:&nbsp;<c:out value="${bbsAtclVO.hits}" /></small><!-- 조회수 -->

											<c:if test="${bbsAtclVO.rsrvUseYn eq 'Y'}">
												<small>
													<spring:message code="bbs.label.write_resv" />&nbsp;:&nbsp;<!-- 등록예약 -->
													<c:choose>
														<c:when test="${bbsAtclVO.rsrvUseYn eq 'Y'}">
															<spring:message code="bbs.label.use_y" /><!-- 사용 -->
														</c:when>
														<c:otherwise>
															<spring:message code="bbs.label.use_n" /><!-- 사용안함 -->
														</c:otherwise>
													</c:choose>
												</small>
											</c:if>
												<small>
													<span class="desktop-elem"><spring:message code="bbs.label.public_yn" />&nbsp;:&nbsp;</span><!-- 공개여부 -->
													<c:choose>
														<c:when test="${bbsAtclVO.lockYn eq 'Y' or bbsInfoVO.bbsCd eq 'SECRET'}">
															<spring:message code="bbs.label.public_n" /><!-- 비공개 -->
														</c:when>
														<c:otherwise>
															<spring:message code="bbs.label.public_y" /><!-- 공개 -->
														</c:otherwise>
													</c:choose>
												</small>
											</div>
										</li>
									</ul>
									<div class="ui message">
										<div class="atclView">
											${bbsAtclVO.atclCts}
										</div>
									</div>
								<c:if test="${(not empty bbsAtclVO.fileList and bbsAtclVO.atchFileCnt > 0) or bbsAtclVO.goodUseYn eq 'Y'}">
								</c:if>
									<div class="flex">
										<!-- 첨부파일 -->
										<div class="flex_1 mr5">
											<ul>
										<c:forEach items="${bbsAtclVO.fileList}" var="row">
												<li class="mb5 opacity7 file-txt">
													<a href="javascript:void(0)" class="btn border0" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd }" />')">
														<i class="xi-download mr3"></i><c:out value="${row.fileNm}" /> (<c:out value="${row.fileSizeStr}" />)
													</a>
												</li>
										</c:forEach>
											</ul>
										</div>
										<div>
										<!-- 좋아요 버튼 -->
										<c:if test="${bbsAtclVO.goodUseYn eq 'Y'}">
											<a href="javascript:void(0)" onclick="addGoodCnt()" class="btn border0">
												<i id="goodCntIcon" class="xi-thumbs-up mr5 f120 <c:if test="${bbsAtclVO.viewerGoodCnt eq 0}">disabled</c:if>"></i>
												<span id="goodCntText">
													<c:out value="${bbsAtclVO.goodCnt}" />
												</span>
											</a>
										</c:if>	
										</div>
									</div>
									
									<c:if test="${bbsInfoVO.bbsCd eq 'PHOTO' and not empty bbsAtclVO.contentUrlList}">
										<div class="ui divider"></div>
		                            	<div class="post_album">
											<div class="ui five stackable cards">
												<c:forEach var="contentUrl" items="${bbsAtclVO.contentUrlList}">
													<div class="ui card">
														<p class="view-list-img img-hover-zoom">
														<a href="javascript:void(0)">
															<img src="${contentUrl}" alt="Image" />
														</a>
													</div>
												</c:forEach>
											</div>
										</div>
									</c:if>
									
									<div class="tr">
										<c:if test="${not empty bbsAtclVO.beforeAtclId }">
		                            		<a href="javascript:moveAtclPost('${bbsAtclVO.beforeAtclId }')" class="ui basic button"><spring:message code="bbs.label.prev_atcl" /><!-- 이전글 --></a>
		                            	</c:if>
		                            	<c:if test="${not empty bbsAtclVO.afterAtclId }">
		                            		<a href="javascript:moveAtclPost('${bbsAtclVO.afterAtclId }')" class="ui basic button"><spring:message code="bbs.label.next_atcl" /><!-- 다음글 --></a>
		                            	</c:if>
		                                <c:if test="${atclEditAuth eq 'Y'}">
					                        <a href="javascript:moveEditAtcl()" class="ui basic button"><spring:message code="common.button.modify" /></a><!-- 수정 -->
										</c:if>
										<c:if test="${atclDeleteAuth eq 'Y'}">
					                        <a href="javascript:removeAtcl()" class="ui basic button"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
					                    </c:if>
				                    	<a href="javascript:moveAtclList()" class="ui basic button"><spring:message code="common.button.list" /></a><!-- 목록 -->
		                            </div>
									
								<!-- 댓글 -->
								<c:if test="${bbsInfoVO.cmntUseYn eq 'Y' and bbsAtclVO.cmntUseYn eq 'Y'}">
									<div class="ui divider"></div>
									<div id="commentArea"></div>
				                </c:if>
				                
				                 <!-- 답변글 -->
								<c:if test="${bbsInfoVO.ansrUseYn eq 'Y'}">
									<div class="ui divider"></div>
									<div id="answerViewArea" class="comment border0"></div>
									<div class="mt10">
										<c:if test="${menuType.contains('PROFESSOR') and bbsAtclVO.answerAtclCnt > 0 and answerWriteAuth eq 'Y'}">
										<button type="button" class="ui small basic button mb10" onclick="$('#otherAnswerDiv').toggle('show')"><spring:message code="bbs.label.add_answer" /><!-- 답변 추가 --></button>
										<div id="otherAnswerDiv" style="display:none;">
											<div class="ui segment">
												<div class="flex mb10">
													<div class="flex_1">
														<label class="ui green label w50 small tc mr5">A</label>
														<small class="bbs-post-info opacity7">
															<em><spring:message code="bbs.label.answer" /> : -</em>
															<em><spring:message code="bbs.label.answer_date" /> : -</em>
														</small>
													</div>
													<div class="button-area">
														<a href="javascript:void(0)" onclick="bbsAnswer.add('other')" class="ui blue button small"><spring:message code="common.button.save" /></a>
													</div>
												</div>
												<dl style="display:table; width:100%;">
													<dd style="height: 300px;display:table-cell">
														<div class="editor-responsive" style="height: 90%">
															<label for="otherContentTextArea"><spring:message code="common.reply" /></label>
															<textarea name="otherContentTextArea" id="otherContentTextArea"></textarea>
															<script>
											                   // html 에디터 생성
											               		var otherEditor = HtmlEditor('otherContentTextArea', THEME_MODE, '/bbs/'+BBS_ID);
											                </script>
														</div>
													</dd>
												</dl>
												<div class="button-area mt15">
													<div class="inline-flex-item flex-wrap">
														<small class="pr10"><spring:message code="bbs.label.easy_answer" /></small>
														<div>
															<a href="javascript:void(0)" onclick="bbsAnswer.setEasyAnswer(1, this, 'other');" class="easy-answer-btn ui basic small label">
																<span class="mr5"><spring:message code="forum.button.cts0" /></span><i class="icon chevron down" style="visibility: hidden;"></i>
															</a>
															<a href="javascript:void(0)" onclick="bbsAnswer.setEasyAnswer(2, this, 'other');" class="easy-answer-btn ui basic small label">
																<span class="mr5"><spring:message code="forum.button.cts1" /></span><i class="icon chevron down" style="visibility: hidden;"></i>
															</a>
															<a href="javascript:void(0)" onclick="bbsAnswer.setEasyAnswer(3, this, 'other');" class="easy-answer-btn ui basic small label">
																<span class="mr5"><spring:message code="forum.button.cts2" /></span><i class="icon chevron down" style="visibility: hidden;"></i>
															</a>
														</div>
													</div>
												</div>
											</div>
										</div>
										</c:if>
									</div>
								</c:if>
								
								</div>
								<!-- 게시글 -->
								
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
	
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="downloadIfm"></iframe>
</body>
</html>