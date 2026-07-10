<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_ID 			= '<c:out value="${bbsAtclVO.bbsId}" />';
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';
		var ATCL_LV 		= 2;

		$(document).ready(function() {
			// 댓글 조회
			bbsAtclCmntList();
	   	});

		// 게시글 수정 이동
		function moveAtclEdit() {
			document.location.href = "/bbs/${templateUrl}/admBbsAtclView.do?encParams=${encParams}&gubun=edit";
		}

        // 게시글 목록 이동
        function moveAtclList() {
            document.location.href = "/bbs/${templateUrl}/admBbsAtclListView.do?encParams=${encParams}";
        }

        // 게시글 이동
        function moveActlView(atclId) {
			let addParams = UiComm.makeEncParams({"atclId":atclId});
        	document.location.href = "/bbs/${templateUrl}/admBbsAtclView.do?encParams=${encParams}&addParams="+addParams;
        }

        function bbsAtclDelete(bbsId, bbsTycd, atclId) {
        	UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (result) {
	    			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
	    			var returnUrl = "/bbs/" + TEMPLATE_URL + "/admBbsAtclListView.do?encParams=${encParams}";
	    			var data = {
	    				bbsId	    : bbsId
	    				, bbsTycd   : bbsTycd
	    				, atclId	: atclId
	    			};

	    			bbsCommon.delete(url, returnUrl, data);
    			}
    			else {}
    		});
    	};

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
							'<input type="hidden" name="bbsId"  value="${bbsAtclVO.bbsId}">' +
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
    		var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclCmntRegist.do?encParams=${encParams}";
    		var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclView.do?encParams=${encParams}";
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

		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntRegist.do?encParams=${encParams}";
		    var data = {
		        bbsId: bbsId
		        , atclId: atclId
		        , atclCmntId: atclCmntId
		        , atclCmntCts: newCts
		    };

		    var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";
		    bbsCommon.regist(url, returnUrl, data);
		}

		// 게시글 > 댓글 삭제
        function bbsAtclCmntDelete(atclCmntId) {
    		UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (result) {
    				var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntDelete.do?encParams=${encParams}";
        			var data = {
        				bbsId : BBS_ID,
        				bbsTycd : BBS_TYCD,
        				atclId : ATCL_ID,
    					atclCmntId : atclCmntId
    				};
        			var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";

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

            var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntRegist.do?encParams=${encParams}";
            var data = $form.serialize();
            var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";

            // 기존 공통 등록 함수 사용
            bbsCommon.regist(url, returnUrl, data);
        }
	</script>
</head>

<body class="admin">
    <div id="wrap" class="main">

        <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
        <form id="moveForm" method="post"></form>

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
        <!-- //common header -->

        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${bbsVO.bbsNm}</h2>
                            <uiex:navibar type="admin"/> <%-- 네비게이션바 --%>
                        </div>

                        <div class="tstyle_view">
                            <div class="title_header">
                            	<c:if test="${(bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'SBJCT') || bbsVO.bbsTycd == 'QNA'}">
	                            	<ul class="list">
	                                    <li>${bbsAtclVO.orgnm} > ${bbsAtclVO.deptnm} > ${bbsAtclVO.sbjctnm}</li>
	                                </ul>
                                </c:if>
                                <div class="title">${bbsAtclVO.atclTtl}</div>
                                <ul class="head">
                                    <li class="write"><strong><spring:message code="bbs.label.reg_user" /></strong><span>${bbsAtclVO.rgtrnm}</span></li>
                                    <li class="date"><strong><spring:message code="bbs.label.reg_date" /></strong><span><uiex:formatDate value="${bbsAtclVO.regDttm}" type="datetime"/></span></li>
                                    <li class="hit"><strong><spring:message code="bbs.label.hit" /></strong><span>${bbsAtclVO.inqCnt}</span></li>
                                    <li class="hit"><strong><strong><spring:message code="bbs.label.comment" /></strong><span>${bbsAtclVO.cmntCnt}</span></li>
                                </ul>
                            </div>

                            <div class="htmlText tb_contents">
                                ${bbsAtclVO.atclCts}
                            </div>

							<%-- 첨부파일 --%>
							<c:if test="${not empty bbsAtclVO.fileList}">
								<div class="add_file_list">
	                            	<uiex:filedownload fileList="${bbsAtclVO.fileList}"/>
	                            </div>
							</c:if>

	                        <ul class="list_board">
	                        	<%-- 이전글 --%>
	                        	<c:if test="${not empty bbsAtclVO.prevAtclId}">
									<li class="prev">
										<span><spring:message code="bbs.label.prev_atcl" /></span>
										<a href="#0" onclick="moveActlView('${bbsAtclVO.prevAtclId}');return false;" title="${bbsAtclVO.prevAtclTtl}">${bbsAtclVO.prevAtclTtl}</a>
									</li>
								</c:if>
								<%-- 다음글 --%>
								<c:if test="${not empty bbsAtclVO.nextAtclId}">
									<li class="next">
										<span><spring:message code="bbs.label.next_atcl" /></span>
										<a href="#0" onclick="moveActlView('${bbsAtclVO.nextAtclId}');return false;" title="${bbsAtclVO.nextAtclTtl}">${bbsAtclVO.nextAtclTtl}</a>
									</li>
								</c:if>
	                        </ul>
                        </div>

                        <div class="btns">
                            <c:if test="${atclEditAuth eq 'Y'}">
		                        <a href="#0" onclick="moveAtclEdit();return false;" class="btn type1"><spring:message code="common.button.modify" /></a><!-- 수정 -->
							</c:if>

							<c:if test="${atclDeleteAuth eq 'Y'}">
		                        <a href="#0" onclick="bbsAtclDelete('${bbsAtclVO.bbsId}', '${bbsAtclVO.bbsTycd}', '${bbsAtclVO.atclId}')" class="btn type2"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
		                    </c:if>

	                    	<a href="#0" onclick="moveAtclList();return false;" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
                        </div>

                        <!-- 댓글 -->
                        <c:if test="${commentWriteAuth eq 'Y'}">
                        	<div class="Comment" id="bbsAtclCmntDtl"></div>
                        </c:if>
                    </div>

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //dashboard-->

    </div>
</body>
</html>
