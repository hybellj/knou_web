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
		<jsp:param name="module" value="table,editor"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>

	<script type="text/javascript">
		var ORG_ID 			= '<c:out value="${bbsAtclVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsAtclVO.bbsId}" />';
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;
		var BBS_HOME_UNIV_GBNS = ""; // bbsHome 의 전체공지 조회용 대학구분 코드
		var EPARAM			= '<c:out value="${encParams}" />';
		var ATCL_LV 		= 2;

		$(document).ready(function() {
			// 답변 조회
			bbsAtclRspnsList();
			// 댓글 조회
			bbsAtclCmntList();
	   	});

        // 게시글 목록 이동
        function bbsAtclListMove() {
            document.location.href = "/bbs/${templateUrl}/bbsLctrQnaListView.do?encParams=${encParams}";
        };

     	// 게시글 삭제
    	function bbsAtclDelete(atclId, bbsId) {
    		UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (result) {
    				var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
        			var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsLctrQnaListView.do?encParams=${encParams}";
        			var data = {
        				  atclId	: atclId,
        				  bbsId	    : bbsId
        			};

        			bbsCommon.delete(url, returnUrl, data);
    			}
    			else {}
    		});
    	};

    	// 게시글 > 답변 조회
		function bbsAtclRspnsList() {
		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do";
		    var data = {
					bbsId: BBS_ID,
					upAtclId: ATCL_ID,
					atclLv: ATCL_LV
			};

		    ajaxCall(url, data, function(res) {
		        var returnList = res.returnList;
		        if (typeof returnList === "string") returnList = JSON.parse(returnList);

		        var $container = $("#bbsAtclRspnsDtl");
		        $container.empty();
		        returnList.forEach(function(v, i) {
		            var html = "";
			            html += "<div class='answer_item' id='ans_item_" + i + "'>";
			            html += " <div class='title_area'>";
			            html += " <strong class='title' data-original='" + v.atclTtl + "'>" + v.atclTtl + "</strong>";
			            html += " <span class='date'><b>" + v.rgtrnm + "</b><em>" + UiComm.formatDate(v.regDttm, "datetime") + "</em></span>";
			            html += " </div>";
			            html += " <div class='cont'>";
			            html += "  <div class='atcl-cts-text'>" + v.atclCts + "</div>";
			            html += "  <div class='bottom_btn'>";
			            html += "    <div class='right-area'>";
			            html += "      <button type='button' class='btn basic btn-modify-action' onclick=\"convertToRspnsEdit('" + i + "', '" + v.bbsId + "', '" + v.atclId + "')\">수정</button>";
			            html += "      <button type='button' class='btn basic' onclick=\"bbsAtclRspnsDelete('" + v.atclId + "')\">삭제</button>";
			            html += "    </div>";
			            html += "  </div>";
			            html += " </div>";
			            html += "</div>";

		            $container.append(html);
		        });
		    });
		}

		// 게시글 > 답변 등록
    	function bbsAtclRspnsRegist() {
    		var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclRspnsRegist.do";
    		var data = $("#bbsAtclRspnsWriteForm").serialize();
			var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsLctrQnaView.do?encParams=${encParams}";

			bbsCommon.regist(url, returnUrl, data);
		};

		// 게시글 > 답변 삭제
        function bbsAtclRspnsDelete(atclId) {
    		UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (result) {
    				var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsLctrQnaView.do?encParams=${encParams}";
        			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
        			var data = {
    					orgId : ORG_ID,
    					bbsId : BBS_ID,
    					atclId : atclId,
    					atclLv : ATCL_LV
    				};

        			bbsCommon.delete(url, returnUrl, data);
    			}
    			else {}
    		});
    	};

    	function convertToRspnsEdit(idx, bbsId, atclId) {
		    var $item = $("#ans_item_" + idx);
		    var $title = $item.find(".title");
		    var $cont = $item.find(".atcl-cts-text");
		    var $btnArea = $item.find(".right-area");

		    var currentTitle = $title.text();
		    $title.html("<input type='text' class='edit-input-ttl' style='width:80%; padding:5px;' value='" + currentTitle + "'>");

		    var currentCont = $cont.html().replace(/<br\s*\/?>/gi, "\n");
		    $cont.html("<textarea class='edit-input-cts' style='width:100%; min-height:100px; padding:10px;'>" + currentCont + "</textarea>");

		    $btnArea.html(
		        "<button type='button' class='btn basic' onclick=\"bbsAtclRspnsModify('" + idx + "', '" + bbsId + "', '" + atclId + "')\" style='background:#333; color:#fff;'>저장</button> " +
		        "<button type='button' class='btn basic' onclick='bbsAtclRspnsList()'>취소</button>"
		    );
		}

    	// 게시글 > 답변 수정
		function bbsAtclRspnsModify(idx, bbsId, atclId) {
		    var $item = $("#ans_item_" + idx);
		    var newTitle = $item.find(".edit-input-ttl").val();
		    var newCts = $item.find(".edit-input-cts").val();

		    if(!newTitle.trim() || !newCts.trim()) {
		        return;
		    }

		    var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclRspnsRegist.do";
		    var data = {
		        bbsId: bbsId,
		        atclId: atclId,
		        atclTtl: newTitle,
		        atclCts: newCts
		    };
		    var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsLctrQnaView.do?encParams=${encParams}";

		    bbsCommon.regist(url, returnUrl, data);
		}

		// 댓글 조회
    	function bbsAtclCmntList() {
		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntListAjax.do";
		    var data = {
		        bbsId: BBS_ID,
		        atclId: ATCL_ID
		    };

		    ajaxCall(url, data, function(res) {
		        var returnList = res.returnList;

		        if (!returnList) return;
		        if (typeof returnList === "string") returnList = JSON.parse(returnList);

		        var $container = $("#bbsAtclCmntDtl");
		        $container.empty();

		        var totalCnt = returnList.length;
		        var baseHtml =
		            '<div class="top_area">' +
		                '<button class="toggle_commentlist"><i class="icon-svg-message"></i>' + totalCnt + ' <spring:message code="bbs.button.open_comment"/> <i class="icon-svg-arrow-down"></i></button>' +
		                '<button class="toggle_commentwrite btn basic"><spring:message code="bbs.button.open_write_comment"/></button>' +
		            '</div>' +

		            '<div class="comment_list">' +
			            '<form class="recmt_form" id="bbsAtclCmntWriteForm" name="bbsAtclCmntWriteForm">' +
				            '<input type="hidden" name="userId" value="${bbsAtclVO.userId}">' +
							'<input type="hidden" name="atclId" value="${bbsAtclVO.atclId}">' +
							'<input type="hidden" name="bbsId" value="${bbsAtclVO.bbsId}">' +
		                    '<fieldset>' +
		                        '<legend class="sr_only"><spring:message code="bbs.button.write_comment"/></span></legend>' +
		                        '<div class="memo">' +
		                            '<div class="simple_answer">' +
		                                '<span><spring:message code="bbs.label.easy_comment"/></span>' +
		                                '<div class="answer_btn">' +
		                                    '<a href="#0" class="current"><spring:message code="bbs.label.easy_comment.good_job"/></a>' +
		                                    '<a href="#0"><spring:message code="bbs.label.easy_comment.hard_work"/></a>' +
		                                    '<a href="#0"><spring:message code="bbs.label.easy_comment.thanks"/></a>' +
		                                '</div>' +
		                            '</div>' +
		                            '<textarea title="<spring:message code="bbs.common.placeholder_comment"/>" class="comment" name="atclCmntCts" rows="3" cols="76" placeholder="<spring:message code="bbs.common.placeholder_comment"/>"></textarea>' +
		                            '<div class="bottom_btn">' +
		                                '<span class="custom-input">' +
		                                    '<input type="checkbox" name="feedbackLabel" id="feedbackLabel">' +
		                                    '<label for="feedbackLabel"><spring:message code="bbs.label.feedback_qna"/> <span class="small">( <spring:message code="bbs.label.guide_feedback_qna"/> )</span></label>' +
		                                '</span>' +
		                                '<div class="right-area">' +
		                                    '<button type="button" class="btn type2" onclick="bbsAtclCmntRegist();"><spring:message code="bbs.label.save"/></button>' +
		                                '</div>' +
		                            '</div>' +

		                        '</div>' +
		                    '</fieldset>' +
		                '</form>' +

		                '<ul id="main_comment_ul"></ul>' +
		            '</div>';

		        $container.append(baseHtml);
		        var $mainUl = $("#main_comment_ul");

		        var returnListP = returnList.filter(function(item) {
		            return !item.upAtclCmntId || item.upAtclCmntId == "0" || item.upAtclCmntId == "";
		        });

		        returnListP.forEach(function(v, i) {
		            var atclCmntId = String(v.atclCmntId).trim();
		            var parentHtml =
		                '<li id="cmt_' + atclCmntId + '">' +
		                    '<div class="item">' +
		                        '<div class="cmt_info">' +
		                            '<strong class="name">' + v.rgtrnm + '</strong>' +
		                            '<span class="date">' + UiComm.formatDate(v.regDttm, "datetime") + '</span>' +
		                        '</div>' +
		                        '<span class="comment">' + v.atclCmntCts + '</span>' +
		                        '<span class="cmtBtnGroup">' +
		                            '<button type="button" class="cmtUpt" onclick="convertToCmntEdit(this, \'' + i + '\', \'' + atclCmntId + '\', \'' + v.atclId + '\', \'' + v.bbsId + '\')"><spring:message code="bbs.label.edit"/></button>' +
		                            '<button type="button" class="cmtDel" onclick="bbsAtclCmntDelete(\'' + atclCmntId + '\')"><spring:message code="bbs.label.delete"/></button>' +
		                            '<button type="button" class="cmtWri" onclick="bbsAtclCmntWrite(\'' + atclCmntId + '\')"><spring:message code="bbs.label.comment"/></button>' +
		                        '</span>' +
		                    '</div>' +

		                    '<ul class="re_comment_ul"></ul>' +
		                '</li>';
		            $mainUl.append(parentHtml);
		        });

		        var returnListC = returnList.filter(function(item) {
		            return (item.upAtclCmntId && item.upAtclCmntId != "0" && item.upAtclCmntId != "");
		        });

		        returnListC.forEach(function(v) {
		            var upAtclCmntId = String(v.upAtclCmntId).trim(); // 부모 ID 공백 제거
		            var atclCmntId = String(v.atclCmntId).trim();

		            var replyHtml =
		            	'<li class="re_comment" id="cmt_' + atclCmntId + '">' +
		                '<div class="item">' +
		                    '<div class="cmt_info">' +
		                        '<strong class="name">' + v.rgtrnm + '</strong>' +
		                        '<span class="date">' + UiComm.formatDate(v.regDttm, "datetime") + '</span>' +
		                    '</div>' +
		                    '<span class="comment">' + v.atclCmntCts + '</span>' +
		                    '<span class="cmtBtnGroup">' +
		                        '<button type="button" class="cmtUpt" onclick="convertToCmntEdit(this, \'\', \'' + atclCmntId + '\', \'' + v.atclId + '\', \'' + v.bbsId + '\')">수정</button>' +
		                        '<button type="button" class="cmtDel" onclick="bbsAtclCmntDelete(\'' + atclCmntId + '\')">삭제</button>' +
		                    '</span>' +
		                '</div>' +
		            '</li>';

		            var $parentLi = $("#cmt_" + upAtclCmntId);

		            if ($parentLi.length > 0) {
		                $parentLi.find("> .re_comment_ul").append(replyHtml);
		            } else {
		                $mainUl.append(replyHtml);
		            }
		        });
		    });
		}

		// 게시글 > 댓글 등록
		function bbsAtclCmntRegist() {
    		var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclCmntRegist.do";
    		var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsLctrQnaView.do?encParams=${encParams}";
			var data = $(".recmt_form").serialize();

			bbsCommon.regist(url, returnUrl, data);
		};

		function convertToCmntEdit(obj, idx, atclCmntId, atclId, bbsId) {
		    var $btnGroup = $(obj).parent();
		    var $contEl = $btnGroup.siblings(".comment");

		    if ($contEl.length === 0) {
		        $contEl = $(obj).closest('.item').children('.comment');
		    }

		    if ($contEl.find("textarea").length > 0) return;

		    var currentCont = $contEl.text().trim();

		    $contEl.html('<textarea class="edit-input-cts" style="width:100%; min-height:70px; margin-top:5px; border:1px solid #ccc; background:#fff; color:#333;">' + currentCont + '</textarea>');

		    $(obj).parent().html(
		        '<button type="button" onclick="bbsAtclCmntModify(\'' + atclCmntId + '\', \'' + atclId + '\', \'' + bbsId + '\')" style="background:#333; color:#fff; padding:2px 5px; margin-right:3px;">저장</button>' +
		        '<button type="button" onclick="bbsAtclCmntList()" style="padding:2px 5px;">취소</button>'
		    );
		}

	    //  댓글 수정
		function bbsAtclCmntModify(atclCmntId, atclId, bbsId) {
		    // ID가 부여된 li(#cmt_ID) 바로 아래의 직계 item 안에서만 textarea를 찾습니다.
		    var $targetLi = $("#cmt_" + atclCmntId);
		    var newCts = $targetLi.find("> .item .edit-input-cts").val();

		    if(!newCts || !newCts.trim()) {
		        alert("내용을 입력해주세요.");
		        return;
		    }

		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntRegist.do";
		    var data = {
		        atclCmntId: atclCmntId,
		        atclId: atclId,
		        atclCmntCts: newCts,
		        bbsId: bbsId
		    };

		    var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsLctrQnaView.do?encParams=${encParams}";
		    bbsCommon.regist(url, returnUrl, data);
		}

		// 게시글 > 댓글 삭제
        function bbsAtclCmntDelete(atclCmntId) {
        	UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
        	.then(function(result) {
        		if (result) {
        			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntDelete.do";
        			var data = {
        				bbsId : BBS_ID,
        				atclId : ATCL_ID,
    					atclCmntId : atclCmntId
    				};
        			var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsLctrQnaView.do?encParams=${encParams}";

        			bbsCommon.regist(url, returnUrl, data);
        		}
        		else {}
        	});
    	};

		// 부가 기능: 대댓글 폼 토글 함수
		function toggleReplyForm(atclId) {
		    $("#re_form_" + atclId).slideToggle(200);
		}

        document.addEventListener('DOMContentLoaded', function () {
            document.addEventListener('click', function (e) {
                /* 댓글 목록 토글 */
                const listBtn = e.target.closest('.toggle_commentlist');
                if (listBtn) {
                const comment = listBtn.closest('.Comment');
                if (!comment) return;

                const ul = comment.querySelector('.comment_list > ul');
                if (!ul) return;

                ul.style.display =
                    ul.style.display === 'none' || !ul.style.display
                    ? 'block'
                    : 'none';

                return;
                }

                /* 상단 댓글 작성 폼 토글 */
                const writeBtn = e.target.closest('.toggle_commentwrite');
                if (writeBtn) {
                const comment = writeBtn.closest('.Comment');
                if (!comment) return;

                const form = comment.querySelector('.comment_list > .recmt_form');
                if (!form) return;

                form.style.display =
                    form.style.display === 'none' || !form.style.display
                    ? 'block'
                    : 'none';

                if (form.style.display === 'block') {
                    form.querySelector('textarea')?.focus();
                }

                return;
                }

                /* 댓글 목록 안 대댓글 폼 토글 */
                const replyBtn = e.target.closest('.cmtWri');
                if (replyBtn) {
                const li = replyBtn.closest('li');
                if (!li) return;

                const comment = replyBtn.closest('.Comment');
                const replyForm = li.querySelector('.comment_list > .recmt_form');
                if (!replyForm) return;

                // 같은 Comment 안의 다른 대댓글 폼 닫기
                comment.querySelectorAll('.comment_list ul li > .recmt_form')
                       .forEach(function (form) {
	                    if (form !== replyForm) {
	                        form.style.display = 'none';
	                    }
                });

                replyForm.style.display =
                    replyForm.style.display === 'none' || !replyForm.style.display
                    ? 'block'
                    : 'none';

                if (replyForm.style.display === 'block') {
                    replyForm.querySelector('textarea')?.focus();
                }
                }

            });

            // 답변
            const textarea = document.querySelector('.cont textarea');
            const answerButtons = document.querySelectorAll('.answer_btn a');

            answerButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    const selectedText = this.innerText || this.textContent;

                    textarea.value = selectedText;

                    answerButtons.forEach(btn => btn.classList.remove('current'));
                    this.classList.add('current');

                    textarea.focus();
                });
            });
        });

     	// 대댓글 작성 폼 생성 및 토글
        function bbsAtclCmntWrite(upAtclCmntId) {
            var $parentLi = $("#cmt_" + upAtclCmntId);

            // 이미 폼이 열려있다면 닫기
            if ($parentLi.find(".reply_write_area").length > 0) {
                $parentLi.find(".reply_write_area").remove();
                return;
            }

            // 다른 곳에 열려있는 대댓글 폼들 제거 (선택 사항)
            $(".reply_write_area").remove();

            var replyFormHtml =
                '<div class="reply_write_area" style="margin-top:10px; padding-left:20px;">' +
                '    <form class="recmt_reply_form">' +
                '        <input type="hidden" name="atclId" value="${bbsAtclVO.atclId}">' +
                '        <input type="hidden" name="bbsId" value="${bbsAtclVO.bbsId}">' +
                '        <input type="hidden" name="upAtclCmntId" value="' + upAtclCmntId + '">' + // 부모 댓글 ID
                '        <textarea name="atclCmntCts" rows="2" style="width:100%; border:1px solid #ddd;" placeholder="답글을 입력하세요."></textarea>' +
                '        <div style="text-align:right; margin-top:5px;">' +
                '            <button type="button" class="btn s_basic" onclick="bbsAtclReplyRegist(this)">등록</button>' +
                '            <button type="button" class="btn s_basic" onclick="$(this).closest(\'.reply_write_area\').remove()">취소</button>' +
                '        </div>' +
                '    </form>' +
                '</div>';

            $parentLi.append(replyFormHtml);
            $parentLi.find("textarea").focus();
        }

     	// 대댓글 저장
        function bbsAtclReplyRegist(btn) {
            var $form = $(btn).closest(".recmt_reply_form");
            var cts = $form.find("textarea[name='atclCmntCts']").val();

            if (!cts || !cts.trim()) {
                alert("내용을 입력해주세요.");
                return;
            }

            var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntRegist.do";
            var data = $form.serialize();
            var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsLctrQnaView.do?encParams=${encParams}";

            // 기존 공통 등록 함수 사용
            bbsCommon.regist(url, returnUrl, data);
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

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>강의Q&A</span>상세</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의Q&A</li>
                                    <li><span class="current">상세</span></li>
                                </ul>
                            </div>
                        </div>

						<div class="tstyle_view">
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>운영과목</label></li>
                                    <li>${bbsAtclVO.orgnm} > ${bbsAtclVO.deptnm} > ${bbsAtclVO.sbjctnm}</li>
                                </ul>
                                <ul class="list">
								    <li class="head"><label><spring:message code="bbs.label.form_title"/></label></li>
								    <li style="display: block !important;"> <div class="atcl-title" style="display: block; font-size: 1em;  margin-bottom: 8px;">
								            ${bbsAtclVO.atclTtl}
								        </div>

								        <div class="atcl-meta-info" style="display: block; font-size: 0.9em; color: #777; padding-top: 5px;">
								            <span style="margin-right:10px;">작성자 : <strong>${bbsAtclVO.rgtrnm}</strong></span>
								            <span style="margin-right:10px;">| 작성일 : <uiex:formatDate value="${bbsAtclVO.regDttm}" type="datetime"/></span>
								            <span style="margin-right:10px;">| 조회수 : ${bbsAtclVO.inqCnt}</span>
								            <span>| 댓글 : ${bbsAtclVO.cmntCnt}</span>
								        </div>

								    </li>
								</ul>
                                <ul class="list">
                                    <li class="head"><label>내용</label></li>
                                    <li>${bbsAtclVO.atclCts}</li>
                                </ul>
                            </div>

                            <%-- 첨부파일 --%>
							<c:if test="${not empty bbsAtclVO.fileList}">
								<div class="add_file_list">
	                            	<uiex:filedownload fileList="${bbsAtclVO.fileList}"/>
	                            </div>
							</c:if>

                            <div class="btns">
		                        <a href="javascript:bbsAtclDelete('${bbsAtclVO.atclId}', '${bbsAtclVO.bbsId}')" class="btn type2"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
	                    		<a href="#0" onclick="bbsAtclListMove();return false;" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
                        	</div>

							<form id="bbsAtclRspnsWriteForm" name="bbsAtclRspnsWriteForm">
								<input type="hidden" name="userId" value="${bbsAtclVO.userId}">
								<input type="hidden" name="atclId" value="${bbsAtclVO.atclId}">
								<input type="hidden" name="bbsId" value="${bbsAtclVO.bbsId}">
								<input type="hidden" name="atclLv" value="2">
	                            <!-- 답변 -->
	                            <div class="answer">
	                                <div class="title_area">
	                                    <strong class="title">
	                                   		<input type="text" name="atclTtl" id="atclTtl" placeholder="제목을 입력해주세요."/>
	                                    </strong>
	                                </div>
	                                <div class="cont">
	                                     <label class="width-100per">
	                                     	<textarea rows="5" class="form-control resize-none" id="atclCts" name="atclCts" placeholder="내용을 입력해주세요."></textarea>
	                                     </label>
	                                     <div class="bottom_btn">
	                                        <div class="simple_answer">
	                                            <span>간편 답변</span>
	                                            <div class="answer_btn">
	                                                <a href="#0" class="current">수고했어요.</a><!--간편답변 선택시 클래스추가-->
	                                                <a href="#0">고생하셨어요.</a>
	                                                <a href="#0">감사합니다.</a>
	                                            </div>
	                                        </div>
	                                        <div class="right-area">
	                                            <button type="button" class="btn type2" onclick="bbsAtclRspnsRegist();return false;">저장</button>
	                                        </div>
	                                     </div>
	                                </div>
	                            </div>
                            </form>

							<!-- 답변 -->
                            <div class="answer" id="bbsAtclRspnsDtl"></div>

                            <!-- 댓글 -->
                            <div class="Comment" id="bbsAtclCmntDtl"></div>

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