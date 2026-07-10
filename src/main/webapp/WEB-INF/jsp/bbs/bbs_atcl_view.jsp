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
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<style>
		/* 삭제된 댓글 "삭제됨" 뱃지 */
		.badge-deleted {
			display: inline-block;
			font-size: 11px;
			color: #fff;
			background: #999;
			border-radius: 3px;
			padding: 1px 6px;
			margin-left: 6px;
			vertical-align: middle;
			font-weight: normal;
		}
		/* 삭제된 댓글 텍스트 흐리게 */
		li.deleted-li .comment {
			color: #aaa;
		}
		/* 3레벨 댓글 추가 들여쓰기 */
		.re_comment_ul .re_comment_ul {
			padding-left: 20px;
		}
		/* 자식 댓글이 없는 빈 ul 이 공간 차지하지 않도록 */
		.re_comment_ul:empty {
			display: none;
			margin: 0;
			padding: 0;
		}
		/* reply_write_area 삽입 후 re_comment_ul 이 생기면 다시 표시 */
		.re_comment_ul:not(:empty) {
			display: block;
		}
		/* 대댓글 작성폼 여백 초기화 */
		.reply_write_area {
			margin-top: 8px;
		}
		.comment {
		    white-space: pre-wrap;
		    word-break: break-word;
		}
	</style>
	<script type="text/javascript">

		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var ORG_ID			= '<c:out value="${bbsAtclVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsAtclVO.bbsId}" />';
		var BBS_TYCD		= '<c:out value="${bbsAtclVO.bbsTycd}" />';
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';
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
			let addParams = UiComm.makeEncParams({"atclId":atclId});
        	document.location.href = "/bbs/${templateUrl}/bbsAtclView.do?encParams=${encParams}&addParams="+addParams;
        }

        // 게시글 삭제
        function bbsAtclDelete(bbsId, bbsTycd, atclId) {
        	UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (!result) return;

    			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
    			var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclListView.do?encParams=${encParams}";
    			var data = {
    				  bbsId   : BBS_ID
    				, bbsTycd : bbsTycd
    				, atclId  : atclId
    			};

    			bbsCommon.delete(url, returnUrl, data);
    		});
    	}

    	// 게시글 > 답변 조회
		function bbsAtclRspnsList() {
		    var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do";
		    var data = {
					bbsId    : BBS_ID,
					upAtclId : ATCL_ID,
					atclLv   : ATCL_LV
			};

		    ajaxCall(url, data, function(res) {
		        var returnList = res.returnList;
		        if (typeof returnList === "string") returnList = JSON.parse(returnList);

		        var $container = $("#bbsAtclRspnsDtl");
		        $container.empty();

		        // 답변이 있으면 답변 작성폼 숨기기
		        if (returnList.length > 0) {
			    	$("#bbsAtclRspnsWriteForm").hide();
			    } else {
			    	$("#bbsAtclRspnsWriteForm").show();
			    }

		        returnList.forEach(function(v, i) {
		            var atclTtl = UiComm.escapeHtml(v.atclTtl);
		            var rgtrnm  = UiComm.escapeHtml(v.rgtrnm);
		            var atclCts = UiComm.escapeHtml(v.atclCts);

		            var html = "";
		            html += "<div class='answer_item' id='ans_item_" + i + "'>";
		            html += " <div class='title_area'>";
		            html += " <strong class='title' data-original='" + atclTtl + "'>" + atclTtl + "</strong>";
		            html += " <span class='date'><b>" + rgtrnm + "</b><em>" + UiComm.formatDate(v.regDttm, "datetime") + "</em></span>";
		            html += " </div>";
		            html += " <div class='cont'>";
		            html += "  <div class='atcl-cts-text'>" + atclCts + "</div>";
		            html += "  <div class='bottom_btn'>";
		            html += "    <div class='right-area'>";
		            html += "      <button type='button' class='btn basic btn-modify-action' onclick=\"convertToRspnsEdit('" + i + "', '" + v.bbsId + "', '" + v.bbsTycd + "', '" + v.atclId + "')\">수정</button>";
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
		}

		// 게시글 > 답변 수정 폼 전환
		function convertToRspnsEdit(idx, bbsId, bbsTycd, atclId) {
		    var $item = $("#ans_item_" + idx);
		    var $title = $item.find(".title");
		    var $cont = $item.find(".atcl-cts-text");
		    var $btnArea = $item.find(".right-area");

		    var currentTitle = $title.text();
		    $title.html("<input type='text' class='edit-input-ttl' style='width:80%; padding:5px;' value='" + UiComm.escapeHtml(currentTitle) + "'>");

		    var currentCont = $cont.html().replace(/<br\s*\/?>/gi, "\n");
		    $cont.html("<textarea class='edit-input-cts' style='width:100%; min-height:100px; padding:10px;'>" + currentCont + "</textarea>");

		    $btnArea.html(
		        "<button type='button' class='btn basic' onclick=\"bbsAtclRspnsModify('" + idx + "', '" + bbsId + "', '" + bbsTycd + "', '" + atclId + "')\" style='background:#333; color:#fff;'>저장</button> " +
		        "<button type='button' class='btn basic' onclick='bbsAtclRspnsList()'>취소</button>"
		    );
		}

		// 게시글 > 답변 수정
		function bbsAtclRspnsModify(idx, bbsId, bbsTycd, atclId) {
		    var $item = $("#ans_item_" + idx);
		    var newTitle = $item.find(".edit-input-ttl").val();
		    var newCts = $item.find(".edit-input-cts").val();

		    if(!newTitle.trim() || !newCts.trim()) {
		        return;
		    }

		    var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclRspnsRegist.do";
		    var data = {
		        bbsId: bbsId,
		        bbsTycd: bbsTycd,
		        atclId: atclId,
		        atclTtl: newTitle,
		        atclCts: newCts
		    };

		    var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclView.do?encParams=${encParams}";
		    bbsCommon.regist(url, returnUrl, data);
		}

		// 게시글 > 답변 삭제
        function bbsAtclRspnsDelete(atclId) {

    		UiComm.showMessage("<spring:message code='bbs.confirm.delete_atcl' />", "confirm")
    		.then(function(result) {
    			if (!result) return;

    			var url = "/bbs/" + TEMPLATE_URL + "/removeAtcl.do";
				var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";
    			var data = {
					orgId : ORG_ID,
					bbsId : BBS_ID,
					bbsTycd : BBS_TYCD,
					atclId : atclId,
					atclLv : ATCL_LV
				};

    			bbsCommon.delete(url, returnUrl, data);
    		});
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

		        var totalCnt = returnList.filter(function(item) {
		            return item.delYn !== "Y";
		        }).length;

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
		                        '<legend class="sr_only"><spring:message code="bbs.button.write_comment"/></legend>' +
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

		        // ── 1레벨 댓글 (부모 댓글)
		        var returnListP = returnList.filter(function(item) {
		            return !item.upAtclCmntId || item.upAtclCmntId == "0" || item.upAtclCmntId == "";
		        });

		        // 1레벨 ID 집합 (2레벨 판별 → 3레벨 제한에 사용)
		        var level1Ids = {};
		        returnListP.forEach(function(item) {
		            level1Ids[String(item.atclCmntId).trim()] = true;
		        });

		        returnListP.forEach(function(v, i) {
		            var atclCmntId = String(v.atclCmntId).trim();
		            var isDeleted  = (v.delYn === "Y");

		            // 삭제 시: 원본 내용 유지 + "삭제됨" 뱃지 표시
		            var cmntCts = isDeleted
		                ? '<span class="comment">' + UiComm.escapeHtml(v.atclCmntCts) + ' <span class="badge-deleted">삭제됨</span></span>'
		                : '<span class="comment">' + UiComm.escapeHtml(v.atclCmntCts) + '</span>';

		            // 삭제 시 버튼 숨김
		            var btnGroup = isDeleted ? '' :
		                '<span class="cmtBtnGroup">' +
		                    '<button type="button" class="cmtUpt" onclick="convertToCmntEdit(this, \'' + i + '\', \'' + atclCmntId + '\', \'' + v.atclId + '\', \'' + v.bbsId + '\')"><spring:message code="bbs.label.edit"/></button>' +
		                    '<button type="button" class="cmtDel" onclick="bbsAtclCmntDelete(\'' + atclCmntId + '\')"><spring:message code="bbs.label.delete"/></button>' +
		                    '<button type="button" class="cmtWri" onclick="bbsAtclCmntWrite(\'' + atclCmntId + '\')"><spring:message code="bbs.label.comment"/></button>' +
		                '</span>';

		            // 삭제 여부와 무관하게 이름/날짜 항상 표시
		            var cmtInfo =
		                '<div class="cmt_info">' +
		                    '<strong class="name">' + UiComm.escapeHtml(v.rgtrnm) + '</strong>' +
		                    '<span class="date">' + UiComm.formatDate(v.regDttm, "datetime") + '</span>' +
		                '</div>';

                    var parentHtml =
                        '<li id="cmt_' + atclCmntId + '"' + (isDeleted ? ' class="deleted-li"' : '') + '>' +
                            '<div class="item">' +
                                cmtInfo +
                                cmntCts +
                                btnGroup +
                            '</div>' +
                            '<ul class="re_comment_ul"></ul>' +
                        '</li>';
		            $mainUl.append(parentHtml);
		        });

		        // ── 2레벨 이하 댓글 (자식 댓글)
		        var returnListC = returnList.filter(function(item) {
		            return (item.upAtclCmntId && item.upAtclCmntId != "0" && item.upAtclCmntId != "");
		        });

		        // 각 자식 댓글의 HTML 을 미리 생성해서 대기열(pending)에 담음
		        // (SQL 정렬/레벨 순서와 무관하게, 부모가 DOM 에 존재할 때만 삽입하기 위함)
		        var pending = returnListC.map(function(v) {
		            var upAtclCmntId = String(v.upAtclCmntId).trim();
		            var atclCmntId   = String(v.atclCmntId).trim();
		            var isDeleted    = (v.delYn === "Y");

		            // 삭제 시: 원본 내용 유지 + "삭제됨" 뱃지 표시
		            var cmntCts = isDeleted
		                ? '<span class="comment">' + UiComm.escapeHtml(v.atclCmntCts) + ' <span class="badge-deleted">삭제됨</span></span>'
		                : '<span class="comment">' + UiComm.escapeHtml(v.atclCmntCts) + '</span>';

		            // 부모가 1레벨이면 → 이건 2레벨 → 댓글 버튼 허용
		            // 부모가 1레벨이 아니면 → 3레벨 이상 → 댓글 버튼 없음 (최대 3레벨 제한)
		            var isLevel2 = level1Ids[upAtclCmntId] === true;

		            // 삭제 시 버튼 숨김 / 3레벨 이상은 댓글 버튼 없음
		            var btnGroup = isDeleted ? '' :
		                '<span class="cmtBtnGroup">' +
		                    '<button type="button" class="cmtUpt" onclick="convertToCmntEdit(this, \'\', \'' + atclCmntId + '\', \'' + v.atclId + '\', \'' + v.bbsId + '\')">수정</button>' +
		                    '<button type="button" class="cmtDel" onclick="bbsAtclCmntDelete(\'' + atclCmntId + '\')">삭제</button>' +
		                    (isLevel2
		                        ? '<button type="button" class="cmtWri" onclick="bbsAtclCmntWrite(\'' + atclCmntId + '\')"><spring:message code="bbs.label.comment"/></button>'
		                        : '') +
		                '</span>';

		            // 삭제 여부와 무관하게 이름/날짜 항상 표시
		            var cmtInfo =
		                '<div class="cmt_info">' +
		                    '<strong class="name">' + UiComm.escapeHtml(v.rgtrnm) + '</strong>' +
		                    '<span class="date">' + UiComm.formatDate(v.regDttm, "datetime") + '</span>' +
		                '</div>';

		            var replyHtml =
		                '<li class="re_comment' + (isDeleted ? ' deleted-li' : '') + '" id="cmt_' + atclCmntId + '">' +
		                    '<div class="item">' +
		                        cmtInfo +
		                        cmntCts +
		                        btnGroup +
		                    '</div>' +
		                    '<ul class="re_comment_ul"></ul>' +
		                '</li>';

		            return {
		                upAtclCmntId : upAtclCmntId,
		                atclCmntId   : atclCmntId,
		                html         : replyHtml
		            };
		        });

		        // 부모가 이미 DOM 에 존재하는 항목부터 반복적으로 삽입
		        // (부모 → 자식 순으로 붙으므로 3레벨이 엉뚱한 위치에 붙지 않음)
		        var guard = 0;
		        while (pending.length > 0 && guard < 1000) {
		            guard++;
		            var progressed = false;

		            for (var idx = 0; idx < pending.length; idx++) {
		                var item = pending[idx];
		                var $parentLi = $("#cmt_" + item.upAtclCmntId);

		                if ($parentLi.length > 0) {
		                    $parentLi.find("> .re_comment_ul").append(item.html);
		                    pending.splice(idx, 1);
		                    idx--;
		                    progressed = true;
		                }
		            }

		            // 이번 순회에서 하나도 못 붙였으면 부모 없는 고아 항목 → 무한루프 방지
		            if (!progressed) {
		                break;
		            }
		        }

		        // 부모를 끝내 찾지 못한 고아 댓글은 최상위 목록에 붙여 유실 방지
		        pending.forEach(function(item) {
		            $mainUl.append(item.html);
		        });
		    });
		}

    	// 게시글 > 댓글 등록
		function bbsAtclCmntRegist() {
    		var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclCmntRegist.do?encParams=${encParams}";
    		var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclView.do?encParams=${encParams}";
			var data = $(".recmt_form").serialize();

			bbsCommon.regist(url, returnUrl, data);
		}

		// 게시글 > 댓글 수정 폼 전환
		function convertToCmntEdit(obj, idx, atclCmntId, atclId, bbsId) {
		    var $btnGroup = $(obj).parent();
		    var $contEl = $btnGroup.siblings(".comment");

		    if ($contEl.length === 0) {
		        $contEl = $(obj).closest('.item').children('.comment');
		    }

		    if ($contEl.find("textarea").length > 0) return;

		    var currentCont = $contEl.text().trim();

		    $contEl.html('<textarea class="edit-input-cts" style="width:100%; min-height:70px; margin-top:5px; border:1px solid #ccc; background:#fff; color:#333;">' + UiComm.escapeHtml(currentCont) + '</textarea>');

		    $(obj).parent().html(
		        '<button type="button" onclick="bbsAtclCmntModify(\'' + atclCmntId + '\', \'' + atclId + '\', \'' + bbsId + '\')" style="background:#333; color:#fff; padding:2px 5px; margin-right:3px;">저장</button>' +
		        '<button type="button" onclick="bbsAtclCmntList()" style="padding:2px 5px;">취소</button>'
		    );
		}

	    // 댓글 수정
		function bbsAtclCmntModify(atclCmntId, atclId, bbsId) {
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
		        if (!result) return;

		        var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclCmntDelete.do";   // encParams 제거
		        var data = {
		            bbsId      : BBS_ID,
		            bbsTycd    : BBS_TYCD,
		            atclId     : ATCL_ID,
		            atclCmntId : atclCmntId
		        };
		        // returnUrl 은 전역변수 기반으로 구성 (encParams 미사용)
		        var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams=${encParams}";

		        bbsCommon.regist(url, returnUrl, data);
		    });
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
                    return;
                }

                /* 간편답변/간편댓글 버튼 클릭 시 textarea 채우기 (동적 생성 요소 대응) */
                const simpleBtn = e.target.closest('.answer_btn a');
                if (simpleBtn) {
                    e.preventDefault();
                    e.stopPropagation();

                    const selectedText = simpleBtn.innerText || simpleBtn.textContent;

                    // 같은 simple_answer 블록 기준으로 대상 textarea 탐색
                    const wrap = simpleBtn.closest('.answer, .memo, .cont, form');
                    let target = null;
                    if (wrap) {
                        target = wrap.querySelector('textarea[name="atclCts"], textarea[name="atclCmntCts"], textarea.comment, .cont textarea');
                    }
                    if (!target) {
                        target = document.querySelector('.cont textarea');
                    }

                    if (target) {
                        target.value = selectedText;
                    }

                    // 같은 answer_btn 그룹 내 current 클래스 토글
                    const group = simpleBtn.closest('.answer_btn');
                    if (group) {
                        group.querySelectorAll('a').forEach(a => a.classList.remove('current'));
                    }
                    simpleBtn.classList.add('current');

                    if (target) {
                        target.focus();
                    }
                }
            });
        });

     	// 대댓글 작성 폼 생성 및 토글
        function bbsAtclCmntWrite(upAtclCmntId) {
		    var $parentLi = $("#cmt_" + upAtclCmntId);

		    // 이미 폼이 열려있다면 닫기
		    if ($parentLi.find("> .reply_write_area").length > 0) {
		        $parentLi.find("> .reply_write_area").remove();
		        return;
		    }

		    // 다른 곳에 열려있는 대댓글 폼들 제거
		    $(".reply_write_area").remove();

		    var replyFormHtml =
		        '<div class="reply_write_area" style="margin-top:10px; padding-left:20px;">' +
		        '    <form class="recmt_reply_form">' +
		        '        <input type="hidden" name="atclId" value="${bbsAtclVO.atclId}">' +
		        '        <input type="hidden" name="bbsId" value="${bbsAtclVO.bbsId}">' +
		        '        <input type="hidden" name="upAtclCmntId" value="' + upAtclCmntId + '">' +
		        '        <textarea name="atclCmntCts" rows="2" style="width:100%; border:1px solid #ddd;" placeholder="답글을 입력하세요."></textarea>' +
		        '        <div style="text-align:right; margin-top:5px;">' +
		        '            <button type="button" class="btn s_basic" onclick="bbsAtclReplyRegist(this)">등록</button>' +
		        '            <button type="button" class="btn s_basic" onclick="$(this).closest(\'.reply_write_area\').remove()">취소</button>' +
		        '        </div>' +
		        '    </form>' +
		        '</div>';

		    // 대댓글 목록(re_comment_ul)이 있으면 그 앞에, 없으면 li 끝에 삽입
		    var $reUl = $parentLi.find("> .re_comment_ul");
		    if ($reUl.length > 0) {
		        $reUl.before(replyFormHtml);
		    } else {
		        $parentLi.append(replyFormHtml);
		    }

		    $parentLi.find("> .reply_write_area textarea").focus();
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

            bbsCommon.regist(url, returnUrl, data);
        }
	</script>
</head>

<body class="home ${uiex:getTheme()} ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>${bbsVO.bbsNm}</span></h2>
                            <uiex:navibar type="main"/> <%-- 네비게이션바 --%>
                        </div>

                        <div class="tstyle_view">
                            <div class="title_header">
                            	<c:if test="${(bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'SBJCT') || bbsVO.bbsTycd == 'QNA'}">
	                            	<ul class="list">
	                                    <li>${bbsAtclVO.orgnm} > ${bbsAtclVO.sbjctnm}</li>
	                                </ul>
                                </c:if>
                                <div class="title">${bbsAtclVO.atclTtl}</div>
                                <ul class="head">
                                    <li class="write"><strong><spring:message code="bbs.label.reg_user" /></strong><span>${bbsAtclVO.rgtrnm}</span></li>
                                    <li class="date"><strong><spring:message code="bbs.label.reg_date" /></strong><span><uiex:formatDate value="${bbsAtclVO.regDttm}" type="datetime"/></span></li>
                                    <li class="hit"><strong><spring:message code="bbs.label.hit" /></strong><span>${bbsAtclVO.inqCnt}</span></li>
                                    <li class="hit"><strong><spring:message code="bbs.label.comment" /></strong><span>${bbsAtclVO.cmntCnt}</span></li>
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
		                        <a href="#0" onclick="bbsAtclDelete('${bbsVO.bbsId}', '${bbsVO.bbsTycd}', '${bbsAtclVO.atclId}')" class="btn type2"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
		                    </c:if>

	                    	<a href="#0" onclick="moveAtclList();return false;" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
                        </div>

						<c:if test="${answerWriteAuth eq 'Y'}">
							<form id="bbsAtclRspnsWriteForm" name="bbsAtclRspnsWriteForm">
								<input type="hidden" name="userId" value="${bbsAtclVO.userId}">
								<input type="hidden" name="atclId" value="${bbsAtclVO.atclId}">
								<input type="hidden" name="bbsId" value="${bbsAtclVO.bbsId}">
								<input type="hidden" name="bbsTycd" value="${bbsAtclVO.bbsTycd}">
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
						</c:if>

						<!-- 답변 -->
	                    <div class="answer" id="bbsAtclRspnsDtl"></div>

                        <!-- 댓글 -->
                        <c:if test="${commentWriteAuth eq 'Y'}">
                        	<div class="Comment" id="bbsAtclCmntDtl"></div>
                        </c:if>
                    </div>

                </div>
            </div>
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>
