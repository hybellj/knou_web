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
		var ORG_ID 			= '<c:out value="${bbsAtclVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsAtclVO.bbsId}" />';
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var ATCL_LV 		= 2;

		$(document).ready(function() {
			// 답변 조회
			bbsAtclRspnsList();
			// 댓글 조회
			bbsAtclCmntList();
	   	});

		// 게시글 수정 이동
		function moveAtclEdit() {
			document.location.href = "/bbs/${templateUrl}/bbsAtclView.do?encParams=${encParams}&gubun=edit";
		}

        // 게시글 목록 이동
        function moveAtclList() {
            document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?encParams=${encParams}";
        }

        // 게시글 이동
        function moveActlView(atclId) {
			let extParam = UiComm.makeExtParam({"atclId":atclId});
        	document.location.href = "/bbs/${templateUrl}/bbsAtclView.do?encParams=${encParams}&extParam="+extParam;
        }

     	// 게시글 삭제
        function bbsAtclDelete(bbsId, atclId) {
    		// 게시글 삭제 시 댓글도 모두 삭제됩니다. 정말 삭제 하시겠습니까?
    		if(confirm('<spring:message code="bbs.confirm.delete_atcl" />')) {
    			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
    			var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";
    			var data = {
    				  atclId	: atclId
    				, bbsId	    : bbsId
    			};

    			bbsCommon.delete(url, returnUrl, data);
    		}
    	};

    	// 게시글 > 답변 조회
		function bbsAtclRspnsList() {
		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclRspnsListAjax.do";
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
			var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclView.do?encParams=${encParams}";

			bbsCommon.regist(url, returnUrl, data);
		};

		// 게시글 > 답변 삭제
        function bbsAtclRspnsDelete(atclId) {
    		UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (result) {
    				var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";
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
		    var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclView.do?encParams=${encParams}";
		    var data = {
		        bbsId: bbsId,
		        atclId: atclId,
		        atclTtl: newTitle,
		        atclCts: newCts
		    };

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

		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntRegist.do";
		    var data = {
		        atclCmntId: atclCmntId,
		        atclId: atclId,
		        atclCmntCts: newCts,
		        bbsId: bbsId
		    };

		    var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";
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

            var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntRegist.do";
            var data = $form.serialize();
            var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";

            // 기존 공통 등록 함수 사용
            bbsCommon.regist(url, returnUrl, data);
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
	                            <h4 class="sub-title"><span>공지사항</span></h4>
	                            <div class="navi_bar">
	                                <ul>
	                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
	                                    <li>공지사항</li>
	                                    <li><span class="current">전체공지</span></li>
	                                </ul>
	                            </div>
	                        </div>

	                        <div class="tstyle_view">
	                            <div class="title_header">
	                                <div class="title">${bbsAtclVO.atclTtl}</div>
	                                <ul class="head">
	                                    <li class="write"><strong>작성자</strong><span>${bbsAtclVO.rgtrnm}</span></li>
	                                    <li class="date"><strong>작성일</strong><span><uiex:formatDate value="${bbsAtclVO.regDttm}" type="datetime"/></span></li>
	                                    <li class="hit"><strong>조회수</strong><span>${bbsAtclVO.inqCnt}</span></li>
	                                    <li class="hit"><strong>댓글</strong><span>${bbsAtclVO.cmntCnt}</span></li>
	                                </ul>
	                            </div>

	                            <div class="tb_contents">
	                                ${bbsAtclVO.atclCts}
	                            </div>

								<%-- 첨부파일 --%>
								<c:if test="${not empty bbsAtclVO.fileList}">
									<div class="add_file_list">
		                            	<uiex:filedownload fileList="${bbsAtclVO.fileList}"/>
		                            </div>
								</c:if>

		                        <%-- <ul class="list_board">
		                        	이전글
		                        	<c:if test="${not empty bbsAtclVO.prevAtclId}">
										<li class="prev">
											<span><spring:message code="bbs.label.prev_atcl" /></span>
											<a href="#0" onclick="moveActlView('${bbsAtclVO.prevAtclId}');return false;" title="${bbsAtclVO.prevAtclTtl}">${bbsAtclVO.prevAtclTtl}</a>
										</li>
									</c:if>
									다음글
									<c:if test="${not empty bbsAtclVO.nextAtclId}">
										<li class="next">
											<span><spring:message code="bbs.label.next_atcl" /></span>
											<a href="#0" onclick="moveActlView('${bbsAtclVO.nextAtclId}');return false;" title="${bbsAtclVO.nextAtclTtl}">${bbsAtclVO.nextAtclTtl}</a>
										</li>
									</c:if>
		                        </ul> --%>

	                        </div>

	                        <div class="btns">
	                            <c:if test="${atclEditAuth eq 'Y'}">
			                        <a href="#0" onclick="moveAtclEdit();return false;" class="btn type1"><spring:message code="common.button.modify" /></a><!-- 수정 -->
								</c:if>

								<c:if test="${atclDeleteAuth eq 'Y'}">
			                        <a href="#0" onclick="bbsAtclDelete('${bbsAtclVO.bbsId}', '${bbsAtclVO.atclId}')" class="btn type2"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
			                    </c:if>

		                    	<a href="#0" onclick="moveAtclList();return false;" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
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
				<!-- //class_sub -->

			</div>
			<!-- //content -->
        </main>
        <!-- //main-->
    </div>
    <!-- //div main -->
</body>
</html>