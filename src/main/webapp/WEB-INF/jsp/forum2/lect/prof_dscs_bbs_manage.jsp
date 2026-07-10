<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<c:set var="isProsConsForum" value="${dscsVO.oknokStngyn eq 'Y'}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>

    <style>
        /* 게시글 인라인 수정 폼 */
        .atcl_edit_form textarea { width: 100%; box-sizing: border-box; }
        .atcl_edit_form .bottom_btn { display: flex; justify-content: flex-end; }
    </style>

    <script type="text/javascript">
    var EPARAM		= '<c:out value="${encParams}" />';
    var PAGE_INDEX  = '<c:out value="${dscsVO.pageIndex}" />';
    var LIST_SCALE  = '<c:out value="${dscsVO.listScale}" />';
    var dialog;
    var prosConsSummary = {
        totalCount: Number("${empty dscsVO.dscsAtclCnt ? 0 : dscsVO.dscsAtclCnt}"),
        prosCount: Number("${empty dscsVO.dscsAtclPorsCnt ? 0 : dscsVO.dscsAtclPorsCnt}"),
        consCount: Number("${empty dscsVO.dscsAtclConsCnt ? 0 : dscsVO.dscsAtclConsCnt}")
    };

    function _isProsConsForum() {
        return $("#oknokStngyn").val() == "Y";
    }

    $(document).ready(function() {
        PAGE_INDEX = PAGE_INDEX || 1;
        LIST_SCALE = LIST_SCALE || getSelectedListScale();

        if(_isProsConsForum()) {
            $("#prosConsSummaryArea").html(createProsConsSummaryHTML());
        }
        if("${dscsVO.dscsUnitTycd}" == "TEAM") {
            $('.team_selected_nm').prop('disabled', true);
            $('#join_write_input_area').hide();
        } else {
            listForum(1);
        }
    });

    // 목록 표시 건수 변경
    function changeListScale(scale) {
        LIST_SCALE = getSelectedListScale(scale);
        listForum(1);
    }

    // 목록 표시 건수 값을 조회한다.
    function getSelectedListScale(scale) {
        if(scale) {
            return scale;
        }

        var $listScale = $("#listScale");
        if($listScale.length == 0) {
            $listScale = $('[id^="listScale"]').eq(0);
        }

        return $listScale.val() || LIST_SCALE || 10;
    }

    // 팀토론토론방OPEN여부 수정
    function modifyTeamDscsOyn(el, dscsId) {
        var $el = $(el);
        var isChecked = $el.is(":checked");

        $el.prop("disabled", true);
        var param = {
            dscsId          : dscsId
        ,   teamDscsOyn     : isChecked ? 'Y' : 'N'
        };

        var url  = "/forum2/forumLect/profTeamDscsOynModify.do";
        ajaxCall(url, param, function(data) {
            $el.prop("disabled", false);
            if (data.result > 0) {
                // do something
            } else {
                $el.prop("checked", !isChecked);
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
            }
        }, function(xhr, status, error) {
            $el.prop("disabled", false);
            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
        });
    }

    // 팀토론 참여시 토론방 이름 활성화
    function joinTeamDscsBtn(teamDscsId, teamnmId, teamnm, teamId) {
        $('.team_selected_nm').prop('disabled', true);
        $('#' + teamnmId).prop('disabled', false);
        // 토론방 참여글 작성 영역 타이틀 변경
        $('#team_selected_name').text(' : ' + teamnm);
        $('#join_write_input_area').show();

        // 조회할 토론 ID 를 설정 한다.
        $('#team_selected_name').attr('teamSelectedDscsId', teamDscsId);
        $("input[name='teamId']").val(teamId || '');
        listForum(1);
    }

    function dscsViewTab(tab) {
        const param = "?dscsId=" + encodeURIComponent('<c:out value="${dscsVO.dscsId}" />') + "&encParams=" + EPARAM;

        if (tab == "0") {
            location.href = '<c:url value="/forum2/forumLect/profDscsEditView.do" />' + param;
            return;
        }

        var urlMap = {
            "1" : "/forum2/forumLect/Form/bbsManage.do",
            "2" : "/forum2/forumLect/Form/scoreManage.do"
        };

        var url  = urlMap[tab];
        if (!url) {
            return;
        }

        location.href = url + param;
    }

    //토론글 리스트
    function listForum(page) {
        loadDscsAtclList(page);
    }

    // 토론 게시글 목록을 조회하고 렌더링한다.
    function loadDscsAtclList(page) {
        var isProsConsForum = _isProsConsForum();
        PAGE_INDEX = page || PAGE_INDEX || 1;
        LIST_SCALE = getSelectedListScale();

        var searchValue = "";
        if(!isProsConsForum) {
            searchValue = $("#searchValue").val();
        }

        // Team 토론시 팀토론 코드로 변경
        var dscsId = "${dscsVO.dscsId}";
        if("${dscsVO.dscsUnitTycd}" == "TEAM") {
            dscsId = $('#team_selected_name').attr('teamSelectedDscsId');
        }

        var url = "/forum2/forumLect/Form/forumBbsViewList.do";
        var data = {
            "pageIndex" : isProsConsForum ? 1 : PAGE_INDEX,
            "listScale" : isProsConsForum ? 9999 : LIST_SCALE,
            "searchValue" : searchValue,
            "dscsId" : dscsId,
            "dscsUnitTycd" : "${dscsVO.dscsUnitTycd}",
            "sbjctId" : "${dscsVO.sbjctId}",
            "userId" : "${userId}",
            "userName" : "${userName}",
            "stdList" : $("#teamStdList").val()
        };

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                var returnList = data.returnList || [];
                var pageInfo = data.pageInfo;
                if(isProsConsForum) {
                    updateProsConsSummary(returnList);
                }
                var html = createDscsAtclListHTML(returnList);
                $("#atclList").find('.tstyle_view').remove();
                $("#atclList").empty().html(html);
                if(isProsConsForum) {
                    $("#comment_paging").empty().hide();
                } else {
                    $("#comment_paging").show();
                    UiComm.showPaging("comment_paging", {
                        pageInfo: data.pageInfo,
                        pageFunc: listForum
                    });
                }
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }


    var _ctxPath = '${pageContext.request.contextPath}';

    // =========================================================
    // 1. 유틸 함수
    // =========================================================

    // 날짜 포맷 변환 (내부유틸)
    function formatDttm(dttm) {
        return dttm.substring(0, 4) + '.' + dttm.substring(4, 6) + '.' + dttm.substring(6, 8)
             + ' (' + dttm.substring(8, 10) + ':' + dttm.substring(10, 12) + ')';
    }

    function userImgHtml(phtFile) {
        var src = phtFile ? (_ctxPath + phtFile) : '';
        if(src) {
            return "<div class='user'><div class='user_img'><img src='" + src + "' aria-hidden='true' alt='사진'></div></div>";
        }
        return "<div class='user'><span class='user_img'></span></div>";
    }

    function createDelynStateHTML(delyn) {
        if(delyn == "Y") {
            return " <span class=\"label s_c02\"><spring:message code='forum.label.sapn.del.content' /></span>"; // 삭제됨
        }
        if(delyn == "H") {
            return " <span class=\"label s_c01\"><spring:message code='forum.button.hide.applied' /></span>"; // 숨김 처리됨
        }
        return "";
    }

    function escapeHtml(text) {
        return String(text || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function escapeJs(value) {
        return String(value || '').replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\r?\n/g, ' ');
    }

    function createFileLinksHTML(fileList) {
        var html = [];
        (fileList || []).forEach(function(item) {
            var encDownParam = item ? escapeJs(item.encDownParam || '') : '';
            var filenm = item ? escapeHtml(item.filenm || item.fileNm || item.orgnlFileNm || '') : '';
            if(!encDownParam || !filenm) {
                return;
            }
            html.push("<span class='fileName'><a href='#0' onclick=\"UiFileDownloader('" + encDownParam + "');return false;\">" + filenm + "</a></span>");
        });
        return html.join('');
    }

    function getProsConsSectionKeyword(sectionKey) {
        var $input = $('#prosConsSearch_' + sectionKey);
        return $input.length ? $.trim($input.val()) : '';
    }

    function matchProsConsSectionKeyword(item, keyword) {
        if(!keyword) {
            return true;
        }
        var normalizedKeyword = keyword.toLowerCase();
        return [
            item.stdntNo,
            item.usernm,
            item.rgtrnm
        ].some(function(value) {
            return String(value || '').toLowerCase().indexOf(normalizedKeyword) > -1;
        });
    }

    function createProsConsSearchHTML(sectionKey, keyword) {
        return [
            "<div class='search-typeC'>",
            "    <input class='form-control' type='text' id='prosConsSearch_" + sectionKey + "' value='" + escapeHtml(keyword) + "'",
            "        placeholder='<spring:message code='forum.label.user.no' />, ", // 학번
            "<spring:message code='forum.label.user_nm' /> ", // 이름
            "<spring:message code='forum.label.input' />'>", // 입력
            "    <button type='button' class='btn basic icon search' aria-label='검색' onclick='listForum(1)'><i class='icon-svg-search'></i></button>",
            "</div>"
        ].join('');
    }

    // Ajax 렌더링 게시글/댓글의 관리 버튼을 공통 드롭다운 구조로 감싼다.
    function createActionDropdownHTML(actionHtml) {
        if(!actionHtml || actionHtml.length == 0) {
            return '';
        }
        return [
            "<span class='btn_right cmtBtnGroup'>",
            "    <div class='dropdown'>",
            "        <button type='button' class='btn basic icon set settingBtn' aria-label='관리'>",
            "            <i class='xi-ellipsis-v'></i>",
            "        </button>",
            "        <div class='optionWrap option-wrap'>",
            actionHtml.join(''),
            "        </div>",
            "    </div>",
            "</span>"
        ].join('');
    }

    // 찬반현황을 현재 목록 기준으로 갱신한다.
    function updateProsConsSummary(list) {
        if(!_isProsConsForum() || $("#prosConsSummaryArea").length == 0) {
            return;
        }
        prosConsSummary = buildProsConsSummary(list);
        $("#prosConsSummaryArea").html(createProsConsSummaryHTML(prosConsSummary));
    }

    // 찬반현황 집계 대상 게시글만 카운트한다.
    function buildProsConsSummary(list) {
        var summary = { totalCount: 0, prosCount: 0, consCount: 0 };
        $.each(list || [], function(_, item) {
            if(!isCountableProsConsItem(item)) {
                return true;
            }
            if(item.oknokGbncd == "OK") {
                summary.prosCount++;
            } else if(item.oknokGbncd == "NOTOK") {
                summary.consCount++;
            }
            return true;
        });
        summary.totalCount = summary.prosCount + summary.consCount;
        return summary;
    }

    // 삭제글, 숨김글, 댓글은 찬반현황 집계에서 제외한다.
    function isCountableProsConsItem(item) {
        if(!item) {
            return false;
        }
        var delyn = item.delyn || "N";
        var atclLv = item.atclLv;
        return delyn == "N" && (atclLv == null || atclLv == "" || Number(atclLv) == 0);
    }

    function createProsConsSummaryHTML(summary) {
        summary = summary || prosConsSummary || {};
        var totalCount = Number(summary.totalCount) || 0;
        var prosCount = Number(summary.prosCount) || 0;
        var consCount = Number(summary.consCount) || 0;
        var prosPercent = totalCount > 0 ? Math.round((prosCount / totalCount) * 100) : 0;
        var consPercent = totalCount > 0 ? Math.round((consCount / totalCount) * 100) : 0;

        return [
            "<div class='proCon_wrap'>",
            "    <h4 class='sub-title'><spring:message code='forum.label.pros.cons.status'/></h4>", // 찬성/반대 현황
            "    <div class='table-wrap'>",
            "        <table class='table-type5'>",
            "            <colgroup><col class='width-10em' /><col /></colgroup>",
            "            <tbody>",
            "                <tr>",
            "                    <th class='text-center'><spring:message code='forum.label.pros'/></th>", // 찬성
            "                    <td>",
            "                        <ul class='process-bar'>",
            "                            <li class='bar-blue' style='width:" + prosPercent + "%;'>" + prosPercent + "%</li>",
            "                            <li class='bar-grey' style='width:" + (100 - prosPercent) + "%;'></li>",
            "                        </ul>",
            "                    </td>",
            "                </tr>",
            "                <tr>",
            "                    <th class='text-center'><spring:message code='forum.label.cons'/></th>", // 반대
            "                    <td>",
            "                        <ul class='process-bar'>",
            "                            <li class='bar-red' style='width:" + consPercent + "%;'>" + consPercent + "%</li>",
            "                            <li class='bar-grey' style='width:" + (100 - consPercent) + "%;'></li>",
            "                        </ul>",
            "                    </td>",
            "                </tr>",
            "            </tbody>",
            "        </table>",
            "    </div>",
            "</div>"
        ].join('');
    }

    // 댓글 수정/삭제/대댓글 버튼 (내부유틸)
    function createCmntActionHTML(item, postIndex, flatIndex, depth) {
        if(item.delyn == "Y") { return ''; }
        var isOwner = (item.rgtrId == "${userId}");
        var canHideComment = (item.delyn != "H");
        var canEditComment = (isOwner && item.delyn == "N");
        var canDeleteComment = true;
        var replyBtn = (depth < 5)
            ? "<button type=\"button\" class=\"item cmtWri\" data-atcl-sn=\""+ item.dscsAtclId +"\" data-cmnt-sn=\""+ item.dscsCmntId +"\" data-post-idx=\""+ postIndex +"\" data-flat-idx=\""+ flatIndex +"\"><spring:message code='forum.button.cmnt'/></button>" // 댓글
            : '';
        if(item.delyn == "H") {
            if(!canDeleteComment) { return ''; }
            return createActionDropdownHTML([
                "    <button type=\"button\" class=\"item cmtDel\" data-rgtr-id=\""+ item.rgtrId +"\" data-cmnt-sn=\""+ item.dscsCmntId +"\"><spring:message code='forum.button.del'/></button>", // 삭제
                replyBtn
            ]);
        }
        var actionHtml = [];
        if(canHideComment) {
            actionHtml.push("    <button type=\"button\" class=\"item cmtHid\" data-cmnt-sn=\""+ item.dscsCmntId +"\" data-post-idx=\""+ postIndex +"\" data-flat-idx=\""+ flatIndex +"\"><spring:message code='forum.button.hide.apply'/></button>"); // 숨김
        }
        if(canEditComment) {
            actionHtml.push("    <button type=\"button\" class=\"item cmtUpt\" data-atcl-sn=\""+ item.dscsAtclId +"\" data-rgtr-id=\""+ item.rgtrId +"\" data-cmnt-sn=\""+ item.dscsCmntId +"\" data-post-idx=\""+ postIndex +"\" data-flat-idx=\""+ flatIndex +"\" data-level=\""+ item.lvl +"\" data-ans-req-yn=\""+ item.rspnsReqyn +"\"><spring:message code='forum.button.mod'/></button>"); // 수정
        }
        if(canDeleteComment) {
            actionHtml.push("    <button type=\"button\" class=\"item cmtDel\" data-rgtr-id=\""+ item.rgtrId +"\" data-cmnt-sn=\""+ item.dscsCmntId +"\"><spring:message code='forum.button.del'/></button>"); // 삭제
        }
        if(replyBtn) {
            actionHtml.push(replyBtn);
        }
        return createActionDropdownHTML(actionHtml);
    }

    // =========================================================
    // 2. 템플릿 함수
    // =========================================================

    // 교수자 게시글 옵션 버튼은 숨김/삭제를 포함하고, 수정만 작성자 본인에게 허용한다.
    function createAtclActionHTML(item, key) {
        if(item.delyn == "Y") { return ''; }
        var actionHtml = [];
        var isOwner = (item.rgtrId == "${userId}");
        var canHidePost = (item.delyn != "H");
        var canEditPost = (isOwner && item.delyn == "N");
        var canDeletePost = true;

        if(canHidePost) {
            actionHtml.push("<button type='button' class='item cmtHid' data-action='hidePost' data-atcl-sn='"+ item.dscsAtclId +"'><spring:message code='forum.button.hide.apply'/></button>"); // 숨김
        }
        if(canEditPost) {
            actionHtml.push("<button type='button' class='item cmtUpt' data-action='editPost' data-atcl-sn='"+ item.dscsAtclId +"' data-rgtr-id='"+ item.rgtrId +"' data-post-idx='"+ key +"'><spring:message code='forum.button.mod'/></button>"); // 수정
        }
        if(canDeletePost) {
            actionHtml.push("<button type='button' class='item cmtDel' data-action='delPost' data-atcl-sn='"+ item.dscsAtclId +"' data-rgtr-id='"+ item.rgtrId +"'><spring:message code='forum.button.del'/></button>"); // 삭제
        }
        if(item.delyn != "H") {
            actionHtml.push("<button type='button' class='item cmtWri' data-atcl-sn='"+ item.dscsAtclId +"' data-post-idx='"+ key +"'><spring:message code='forum.button.cmnt'/></button>"); // 댓글
        }
        return createActionDropdownHTML(actionHtml);
    }

    // 게시글 본문 HTML을 생성한다.
    function renderAtclBody(item) {
        if(_isProsConsForum()) {
            return "<pre>" + item.atclCts + "</pre>";
        }
        return item.atclCts;
    }

    // 게시글 하단 글자수, 댓글수, 첨부파일 영역을 구성한다.
    function createAtclDetailHTML(item, key, totalCmntCount, detailCmntCount) {
        var commentToggleHtml = "";
        if(totalCmntCount > 0) {
            commentToggleHtml = [
                "<button type='button' class='toggle_commentlist mlAuto' id='cmntOpen" + key + "'>",
                "<i class='icon-svg-message'></i>",
                totalCmntCount + "<spring:message code='forum.label.cnt.forum.cmnt'/>", // 개의 댓글이 있습니다.
                "<i class='icon-svg-arrow-down'></i>",
                "</button>"
            ].join('');
        }
        var detailParts = [
            [
                "<span class='textNum'>",
                "<i class='xi-paper-o'></i>",
                item.atclCtsLen + "<spring:message code='forum.label.word'/>", // 자
                "</span>"
            ].join(''),
            "<span class='comNum'><i class='xi-speech-o'></i>" + detailCmntCount + "</span>",
            createFileLinksHTML(item.fileList)
        ];
        return [
            "<div class='cmt_detail'>",
            "    <div>" + detailParts.join(' ') + "</div>",
            commentToggleHtml,
            "</div>"
        ].join('');
    }

    // 게시글 인라인 수정 폼 (기본 숨김)
    function createAtclEditFormHTML(item, key) {
        return [
            "<div class='recmt_form atcl_edit_form' id='atclEditForm"+ key +"' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'><spring:message code='forum.button.mod'/></legend>", // 수정
            "        <div class='memo'>",
            "            <textarea class='resize-none' rows='3' id='atclEditCts"+ key +"'></textarea>",
            "            <div class='bottom_btn'>",
            "                <div class='right-area'>",
            "                    <button type='button' class='btn type2 atcl_edit_save'",
            "                        data-atcl-sn='"+ item.dscsAtclId +"'",
            "                        data-dscs-id='"+ item.dscsId +"'",
            "                        data-oknok-gbncd='"+ (item.oknokGbncd||'') +"'",
            "                        data-post-idx='"+ key +"'><spring:message code='forum.button.mod'/></button>", // 수정
            "                    <button type='button' class='btn basic atcl_edit_cancel'",
            "                        data-post-idx='"+ key +"'><spring:message code='forum.button.cancel'/></button>", // 취소
            "                </div>",
            "            </div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join('');
    }

    // 게시글/댓글 공통 작성폼
    function createCmntWriteFormHTML(atclId, key) {
        return [
            "<div class='recmt_form mt20' id='toggleBox"+ key +"' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></legend>", // 댓글 / 등록
            "        <div class='memo'>",
            createSimpleAnswerHTML("cmntText" + key),
            "            <textarea class='resize-none' title='<spring:message code="forum.label.input.cmnt"/>' class='comment' name='c_comment' rows='3' cols='76' placeholder='<spring:message code="forum.label.input.cmnt"/>' id='cmntText"+ key +"'></textarea>", // 댓글을 입력하세요
            "            <div class='bottom_btn'>",
            "                <span class='custom-input'>",
            "                    <input type='checkbox' id='ansReqYn"+ key +"' name='ansReqYn' disabled>",
            "                    <label for='ansReqYn"+ key +"'><span class='small'><spring:message code='forum.checkbox.label.request' /></span></label>", // 답변을 요청합니다.
            "                </span>",
            "                <div class='right-area'>",
            "                    <button type='button' class='btn type2' data-action='addCmnt' data-atcl-sn='"+ atclId +"' data-post-idx='"+ key +"'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></button>", // 댓글 / 등록
            "                </div>",
            "            </div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join('');
    }

    // 댓글 본문 표시 HTML을 생성한다.
    function renderCmntBody(item, postIndex, flatIndex) {
        if(item.delyn == "Y") {
            return "<span class='comment'>" + (item.cmntCts || '') + createDelynStateHTML('Y') + "</span>";
        }
        if(item.delyn == "H") {
            return "<span class='comment'>" + (item.cmntCts || '') + createDelynStateHTML('H') + "</span>";
        }
        return "<span class='comment' id='cmntContents" + postIndex + flatIndex + "'>" + item.cmntCts + "</span>";
    }

    // 댓글 작성자, 작성일 정보를 구성한다.
    function createCmntMetaHTML(item) {
        var regDttm = formatDttm(item.modDttm);
        return [
            userImgHtml(item.phtFile),
            "<strong class='name'>" + item.rgtrnm + "</strong>",
            "<span class='date'>" + regDttm + "</span>"
        ].join('');
    }

    // 대댓글 입력 폼 HTML을 생성한다.
    function createReplyFormHTML(item, atclId, postIndex, flatIndex, depth) {
        if(item.delyn == "Y" || item.delyn == "H" || depth >= 5) {
            return '';
        }
        var replyKey = "" + postIndex + flatIndex;
        return [
            "<div class='recmt_form' id='toggleCmnt" + replyKey + "' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'>댓글등록</legend>",
            "        <div class='memo'>",
            createSimpleAnswerHTML("cmntText" + replyKey),
            "            <textarea class='resize-none' title='<spring:message code="forum.label.input.cmnt"/>' class='comment' name='c_comment' rows='3' cols='76' placeholder='<spring:message code="forum.label.input.cmnt"/>' id='cmntText" + replyKey + "'></textarea>", // 댓글을 입력하세요
            "            <div class='bottom_btn'>",
            "                <span class='custom-input'>",
            "                    <input type='checkbox' id='ansReqYn" + replyKey + "' name='ansReqYn' disabled>",
            "                    <label for='ansReqYn" + replyKey + "'><span class='small'><spring:message code='forum.checkbox.label.request' /></span></label>", // 답변을 요청합니다.
            "                </span>",
            "                <div class='right-area'>",
            "                    <button type='button' class='btn type2 cmt_create' data-atcl-sn='" + atclId + "' data-cmnt-sn='" + item.dscsCmntId + "' data-post-idx='" + postIndex + "' data-flat-idx='" + flatIndex + "'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></button>", // 댓글 / 등록
            "                </div>",
            "            </div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join('');
    }

    // 댓글 <li> 1개 생성 (재귀 지원, depth 1=top/2+= nested)
    function createCmntItemHTML(node, atclId, postIndex, depth) {
        var item = node.item;
        var flatIndex = node.flatIndex;

        var childrenHtml = '';
        if(node.children && node.children.length > 0) {
            childrenHtml = node.children.map(function(child) {
                return createCmntItemHTML(child, atclId, postIndex, depth + 1);
            }).join('');
        }

        return [
            "<li class='re_comment'>",
            "    <div class='item'>",
            "        <div class='cmt_info'>",
            createCmntMetaHTML(item),
            "        </div>",
            createCmntActionHTML(item, postIndex, flatIndex, depth),
            renderCmntBody(item, postIndex, flatIndex),
            "    </div>",
            createReplyFormHTML(item, atclId, postIndex, flatIndex, depth),
            (childrenHtml ? "<ul class='re_comment_ul'>" + childrenHtml + "</ul>" : ""),
            "</li>"
        ].join('');
    }

    // =========================================================
    // 3. 조립 함수
    // =========================================================
    function wrapDscsListHTML(innerHtml, extraClass) {
        return [
            "<div class='Comment mt10" + (extraClass ? " " + extraClass : "") + "'>",
            "    <div class='comment_list'>",
            "        <ul>",
            innerHtml,
            "        </ul>",
            "    </div>",
            "    <div id='comment_paging' class='bd0'></div>",
            "</div>"
        ].join('');
    }

    // 토론 글 리스트 생성 (최상위 조립 함수)
    function createDscsAtclListHTML(list) {
        if(list.length == 0) {
            return [
                "<div class=\"flex-container\">",
                "    <div class=\"cont-none\">",
                "        <span><spring:message code='forum.common.empty' /></span>", // 등록된 내용이 없습니다.
                "    </div>",
                "</div>"
            ].join('');
        }

        if(_isProsConsForum()) {
            return createProsConsListHTML(list);
        }

        var html = [];
        list.forEach(function(item, index) {
            html.push(createAtclItemHTML(item, index));
        });
        return wrapDscsListHTML(html.join(''));
    }

    function createProsConsListHTML(list) {
        var grouped = {ok: [], notok: [], fb: []};
        list.forEach(function(item, index) {
            if(item.oknokGbncd === 'OK') {
                grouped.ok.push({item: item, index: index});
            } else if(item.oknokGbncd === 'NOTOK') {
                grouped.notok.push({item: item, index: index});
            } else {
                grouped.fb.push({item: item, index: index});
            }
        });

        return buildProsConsSection('<spring:message code="forum.label.pros.opinion"/>', 'ok', grouped.ok, true, getProsConsSectionKeyword('ok'), true) // 찬성 의견
             + buildProsConsSection('<spring:message code="forum.label.cons.opinion"/>', 'notok', grouped.notok, true, getProsConsSectionKeyword('notok'), true) // 반대 의견
             + buildProsConsSection('FeedBack', 'fb', grouped.fb, false, '', false);
    }

    function buildProsConsSection(title, sectionKey, list, showCount, keyword, useSearch) {
        var filteredList = keyword
            ? list.filter(function(entry) { return matchProsConsSectionKeyword(entry.item, keyword); })
            : list;
        var header = showCount
            ? title + " [<spring:message code='common.page.total'/> " + list.length + "<spring:message code='message.person'/>]" // 총 / 명
            : title;
        var html = [
            "<div class='pros-cons-section pros-cons-section--" + sectionKey + " mt30'>",
            "    <div class='flex justify-content-between width-100per mb20'>",
            "        <h4 class='sub-title'>" + header + "</h4>",
            useSearch ? ("        " + createProsConsSearchHTML(sectionKey, keyword)) : "",
            "    </div>"
        ];

        if(filteredList.length === 0) {
            html.push(wrapDscsListHTML([
                "<li>",
                "    <div class='flex-container'>",
                "        <div class='cont-none'>",
                "            <span><spring:message code='forum.common.empty' /></span>", // 등록된 내용이 없습니다.
                "        </div>",
                "    </div>",
                "</li>"
            ].join('')));
        } else {
            var listHtml = [];
            filteredList.forEach(function(entry) {
                listHtml.push(createAtclItemHTML(entry.item, entry.index));
            });
            html.push(wrapDscsListHTML(listHtml.join('')));
        }

        html.push("</div>");
        return html.join('');
    }

    // 게시글 1개 li 블록 생성
    function createAtclItemHTML(item, key) {
        var cmntList = item.cmntList || [];
        var totalCmntCount = Number(item.cmntCount != null ? item.cmntCount : cmntList.length) || 0;
        var writerCmntCount = Number(item.writerCmntCount || 0);
        var regDttm = formatDttm(item.regDttm);
        var writerName = escapeHtml(item.usernm || item.rgtrnm || item.stdntNo || "");
        var writerNo = item.stdntNo ? "(" + escapeHtml(item.stdntNo) + ")" : "";
        return [
            "<li>",
            "    <div class='item'>",
            "        <div class='cmt_info'>",
            userImgHtml(item.phtFile),
            "<strong class='name'>",
            writerName + writerNo,
            "</strong>",
            "            <span class='date'>" + regDttm + "</span>",
            "</div>",
            createAtclActionHTML(item, key),
            "        <span class='comment' id='atclBody" + key + "'>" + renderAtclBody(item) + createDelynStateHTML(item.delyn) + "</span>",
            createAtclDetailHTML(item, key, totalCmntCount, writerCmntCount),
            "    </div>",
            createAtclEditFormHTML(item, key),
            createCmntWriteFormHTML(item.dscsAtclId, key),
            "    <ul class='re_comment_ul dpNone' style='margin-bottom:0;'>",
            createCmntListHTML(cmntList, item.dscsAtclId, key),
            "    </ul>",
            "</li>"
        ].join('');
    }

    // flat 댓글 목록 → parCmntSn 기반 tree HTML 조립
    function createCmntListHTML(list, atclId, postIndex) {
        var nodeMap = {};
        var roots = [];
        list.forEach(function(item, index) {
            nodeMap[item.dscsCmntId] = {
                item: item,
                flatIndex: index,
                children: []
            };
        });
        list.forEach(function(item) {
            if (item.upCmntId && nodeMap[item.upCmntId]) {
                nodeMap[item.upCmntId].children.push(nodeMap[item.dscsCmntId]);
            } else {
                roots.push(nodeMap[item.dscsCmntId]);
            }
        });
        return roots.map(function(node) {
            return createCmntItemHTML(node, atclId, postIndex, 1);
        }).join('');
    }

    // 게시글(참여글) 등록 버튼
    function addAtclBtn(){
        // 입력필드 검증
        UiValidator("atclWriteForm")
        .then(function(result) {
            if (result) {
                // 찬반토론일 경우
                if (_isProsConsForum()) {
                    addActl();
                } else {
                    let dx = dx5.get("fileUploader");
                    // 첨부파일 있으면 업로드
                    if (dx.availUpload()) {
                        dx.startUpload();
                    }
                    // 첨부파일 없으면 저장 호출
                    else {
                        addActl();
                    }
                }
            }
        });
    }

    // 파일 업로드 완료
    function finishUpload() {
        let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        let dx = dx5.get("fileUploader");
        let data = {
            "uploadFiles" : dx.getUploadFiles(),
            "uploadPath"  : dx.getUploadPath()
        };

        // 업로드된 파일 체크
        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                $("#uploadFiles").val(dx.getUploadFiles());

                // 게시글 저장 호출
                addActl();
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        },
        function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        });
    }

    // 게시글 등록/수정
    function addActl(atclStatus) {
        // 찬반토론일 경우:파일첨부하지 않음.
        if (!_isProsConsForum()) {
            let dx = dx5.get("fileUploader");
            $("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정
        }

        // Team 토론시 팀토론 코드로 변경
        if("${dscsVO.dscsUnitTycd}" == "TEAM") {
            var teamDscsId = $('#team_selected_name').attr('teamSelectedDscsId');
            $("input[name='dscsId']").val(teamDscsId);
        }

        var dscsAtclTycd = $("#dscsUnitTycd").val() + "_" + $("#oknokStngyn").val();
        var param = [];
        param = param.concat($("#forumListForm").serializeArray());
        param = param.concat($("#forumAtclForm").serializeArray());
        DscsParam.set(param, "dscsAtclTycd", dscsAtclTycd);

         // 등록
        var url = "/forum2/forumLect/Form/addAtcl.do";

        ajaxCall(url, param, function(data) {
            if(data.result > 0) {
                // 입력내용 clear
                editor.openHTML("");

                UiComm.showMessage("<spring:message code='forum.alert.add.forum.atcl_success'/>", "success"); // 토론 게시글 등록에 성공하였습니다.
                listForum(1);
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.add.forum.atcl_fail'/>"), "error"); // 토론 게시글에 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    //게시글 삭제
    function delAtcl(atclSn,rgtrId){
        UiComm.showMessage("<spring:message code='forum.button.confirm.del' />", "confirm") // 정말 삭제하시겠습니까?
            .then(function(result) {
                if(!result) { return false; }

                // Team 토론시 팀토론 코드로 변경
                var dscsId = "${dscsVO.dscsId}";
                if("${dscsVO.dscsUnitTycd}" == "TEAM") {
                    dscsId = $('#team_selected_name').attr('teamSelectedDscsId');
                }

                var url = "/forum2/forumLect/Form/delAtcl.do";
                var data = {
                    "dscsAtclId" : atclSn,
                    "dscsId" : dscsId,
                    "userId" : "${userId}"
                };

                ajaxCall(url, data, function(data) {
                    if(data.result > 0) {
                        UiComm.showMessage("<spring:message code='forum.alert.del.forum.atcl_success'/>", "success"); // 게시글 삭제에 성공하였습니다.
                        listForum();
                    } else {
                        UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.del.forum.atcl_fail'/>"), "error"); // 게시글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
                        listForum();
                    }
                }, function(xhr, status, error) {
                    UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
                }, true);
            });
    }

    //댓글 등록
    function addCmnt(atclSn, parCmntSn, postIndex, flatIndex) {
        var ansReqYn = "N";
        var cmntCts ="";
        if (parCmntSn == null || parCmntSn == '') {
            if($("#ansReqYn"+ postIndex).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts = $("#cmntText" + postIndex).val();
        } else {
            if ($("#ansReqYn"+ postIndex + flatIndex).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts = $("#cmntText"+ postIndex + flatIndex).val().trim();
        }

        if(cmntCts == null || cmntCts == ""){
            UiComm.showMessage("<spring:message code='forum.alert.input.reply'/>", "info"); // 댓글을 입력해주시기 바랍니다.
            $("#toggleBox"+ postIndex).addClass("off").removeClass("on");
        }else{
            $("#cmntText" + postIndex).val('');

            // Team 토론시 팀토론 코드로 변경
            var dscsId = "${dscsVO.dscsId}";
            if("${dscsVO.dscsUnitTycd}" == "TEAM") {
                dscsId = $('#team_selected_name').attr('teamSelectedDscsId');
            }

            var url = "/forum2/forumLect/Form/addCmnt.do";
            var data = {
                "rspnsReqyn" : ansReqYn,
                "dscsAtclId" : atclSn,
                "cmntCts" : cmntCts,
                "upCmntId" : parCmntSn,
                "dscsId" : dscsId,
                "userId" : "${userId}",
                "userName" : "${userName}",
                "sbjctId" : "${dscsVO.sbjctId}"
            };

            ajaxCall(url, data, function(data) {
                if(data.result > 0) {
                    UiComm.showMessage("<spring:message code='forum.alert.reg_success.reply'/>", "success"); // 댓글 등록에 성공하였습니다.
                } else {
                    UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.reg_fail.reply'/>"), "error"); // 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
                }
                listForum($("#currentIndex").val());
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            }, true);
        }
    }

    // 댓글 수정
    function editCmnt(atclSn, cmntSn, postIndex, flatIndex, level){
        var ansReqYn = "N";
        var cmntCts = "";
        if(level == null || level == ''){
            if($("#ansReqYn"+ postIndex).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts= $("#cmntText" + postIndex).val();
            $("#cmntText" + postIndex).val('');
        }else{
            if($("#ansReqYn"+ postIndex + flatIndex).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts = $("#cmntText"+ postIndex + flatIndex).val().trim();
        }
        if(cmntCts == null || cmntCts == ""){
            UiComm.showMessage("<spring:message code='forum.alert.input.reply'/>", "info"); // 댓글을 입력해주시기 바랍니다.
            return false;
        }

        var url = "/forum2/forumLect/Form/editCmnt.do";
        var data = {
            "rspnsReqyn" : ansReqYn,
            "dscsCmntId" : cmntSn,
            "cmntCts" : cmntCts
        };

        ajaxCall(url, data, function(data) {
            if (data.result > 0) {
                UiComm.showMessage("<spring:message code='forum.alert.mod_success.reply'/>", "success"); // 댓글 수정에 성공하였습니다.
                listForum();
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.mod_fail.reply'/>"), "error"); // 댓글 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
                listForum();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    //댓글 삭제
    function delCmnt(rgtrId,cmntSn) {
        UiComm.showMessage("<spring:message code='forum.button.confirm.del' />", "confirm") // 정말 삭제하시겠습니까?
            .then(function(result) {
                if(!result) { return false; }

                var url = "/forum2/forumLect/Form/delCmnt.do";
                var data = {
                    "dscsCmntId" : cmntSn,
                    "userId" : "${userId}"
                };

                ajaxCall(url, data, function(data) {
                    if(data.result > 0) {
                        UiComm.showMessage("<spring:message code='forum.forumBBsManage.alert.del_success'/>", "success"); // 댓글 삭제에 성공하였습니다.
                        listForum();
                    } else {
                        UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.forumBBsManage.alert.del_fail'/>"), "error"); // 댓글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
                        listForum();
                    }
                }, function(xhr, status, error) {
                    UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
                });
            });
    }

    //게시글 수정 버튼
    function editAtclBtn(atclSn, rgtrId, postIndex) {
        var form = document.getElementById('atclEditForm' + postIndex);
        var body = document.getElementById('atclBody' + postIndex);
        if(!form || !body) return;
        var willOpen = form.style.display !== 'block';
        closeAllActionForms(willOpen ? 'atclEditForm' + postIndex : '');
        if(!willOpen) { return; }
        var textarea = document.getElementById('atclEditCts' + postIndex);
        if(textarea) textarea.value = body.innerText;
        body.style.display = 'none';
        form.style.display = 'block';
        if(textarea) textarea.focus();
        editingPostId = postIndex;
    }


    // 간편답글 세팅
    var ctsMsgs = [
        '<spring:message code="forum.button.cts0"/>', // 수고했어요.
        '<spring:message code="forum.button.cts1"/>', // 고생하셨어요.
        '<spring:message code="forum.button.cts2"/>' // 감사합니다.
    ];
    function setCts(messageIndex, targetId) {
        $("#" + targetId).val(ctsMsgs[messageIndex] || "").focus();
    }

    // 간편답글 버튼 영역 HTML을 생성한다.
    function createSimpleAnswerHTML(targetId) {
        return [
            "<div class='simple_answer'>",
            "    <span><spring:message code='forum.button.label.info' /></span>", // 간편답글
            "    <div class='answer_btn'>",
            "        <a href='#0' onclick=\"setCts(0, '" + targetId + "');return false;\"><spring:message code='forum.button.cts0' /></a>", // 수고했어요.
            "        <a href='#0' onclick=\"setCts(1, '" + targetId + "');return false;\"><spring:message code='forum.button.cts1' /></a>", // 고생하셨어요.
            "        <a href='#0' onclick=\"setCts(2, '" + targetId + "');return false;\"><spring:message code='forum.button.cts2' /></a>", // 감사합니다.
            "    </div>",
            "</div>"
        ].join("");
    }

    //팀 구성원 보기
    function teamMemberView(teamCtgrCd) {
        $("#teamCtgrCd").val(teamCtgrCd);
        $("#teamMemberForm").attr("target", "teamMemberIfm");
        $("#teamMemberForm").attr("action", "/forum2/forumLect/teamMemberList.do");
        $("#teamMemberForm").submit();
        $('#teamMemberPop').modal('show');
    }

    // 목록
    function viewDscsList() {
        location.href = "/forum2/forumLect/profForumListView.do?" + "encParams=" + EPARAM;
    }

    // 토론 수정
    function editDscs(dscsId, forumStartDttm) {
        const param = "?dscsId=" + encodeURIComponent(dscsId) + "&encParams=" + EPARAM;
        location.href = '<c:url value="/forum2/forumLect/profDscsEditView.do" />' + param;
    }

    //토론삭제
    function deleteDscs(dscsId) {
        UiComm.showMessage("<spring:message code='forum.alert.confirm.delete' />", "confirm") // 삭제하시겠습니까?
            .then(function(result) {
                if (!result) {
                    return;
                }

                $.ajax({
                    url: "/forum2/forumLect/profDscsDelete.do",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({dscsId:dscsId}),
                    dataType: "json",
                    beforeSend: function () {
                        UiComm.showLoading(true);
                    }
                }).done(function(data) {
                    UiComm.showLoading(false);
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='success.common.delete' />", "success") // 정상적으로 삭제되었습니다.
                            .then(function() {
                                const param = "?encParams=" + EPARAM;
                                location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />' + param;
                            });
                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='forum.common.error' />", "alert"); // 오류가 발생했습니다!
                    }
                }).fail(function() {
                    UiComm.showLoading(false);
                    UiComm.showMessage("<spring:message code='forum.common.error' />", "alert"); // 오류가 발생했습니다!
                });
            });
    }

    function downExcel() {
        return false;
    }

    // =========================================================
    // 상태 변수
    // =========================================================
    var editingPostId = null;
    var editingCommentId = null;

    function setCmntFormCreateMode(form) {
        if(!form) { return; }
        var btn = form.querySelector('.cmt_create');
        if(!btn) { return; }
        var atclSn = btn.getAttribute('data-atcl-sn') || '';
        var cmntSn = btn.getAttribute('data-cmnt-sn') || '';
        var postIndex = btn.getAttribute('data-post-idx') || '';
        var flatIndex = btn.getAttribute('data-flat-idx') || '';
        var rightArea = form.querySelector('.right-area');
        if(!rightArea) { return; }
        rightArea.innerHTML = [
            "<button type='button' class='btn type2 cmt_create'",
            " data-atcl-sn='" + atclSn + "'",
            " data-cmnt-sn='" + cmntSn + "'",
            " data-post-idx='" + postIndex + "'",
            " data-flat-idx='" + flatIndex + "'>",
            "<spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/>", // 댓글 / 등록
            "</button>"
        ].join('');
    }

    function setCmntFormEditMode(form, atclSn, cmntSn, postIndex, flatIndex) {
        if(!form) { return; }
        var rightArea = form.querySelector('.right-area');
        if(!rightArea) { return; }
        rightArea.innerHTML = [
            "<button type='button' class='btn type2 cmt_create' data-edit-mode='true'",
            " data-atcl-sn='" + atclSn + "'",
            " data-cmnt-sn='" + cmntSn + "'",
            " data-post-idx='" + postIndex + "'",
            " data-flat-idx='" + flatIndex + "'>",
            "<spring:message code='forum.button.mod'/>", // 수정
            "</button>",
            "<button type='button' class='btn basic cmt_edit_cancel' data-form-id='toggleCmnt" + postIndex + flatIndex + "'>",
            "<spring:message code='forum.button.cancel'/>", // 취소
            "</button>"
        ].join('');
    }

    function closeAllActionForms(exceptId) {
        var keepId = exceptId || '';
        document.querySelectorAll('.recmt_form').forEach(function(form) {
            if(form.id !== keepId) {
                setCmntFormCreateMode(form);
                form.style.display = 'none';
                form.classList.add('off');
                form.classList.remove('on');
                var textarea = form.querySelector('textarea');
                if(textarea) { textarea.value = ''; }
            }
        });
        document.querySelectorAll('.atcl_edit_form').forEach(function(form) {
            var postIndex = form.id.replace('atclEditForm', '');
            if(form.id !== keepId) {
                form.style.display = 'none';
                var body = document.getElementById('atclBody' + postIndex);
                if(body) { body.style.display = ''; }
            }
        });
        if(keepId.indexOf('atclEditForm') !== 0) {
            editingPostId = null;
        }
        if(keepId.indexOf('toggleCmnt') !== 0) {
            editingCommentId = null;
        }
    }

    // Ajax로 생성된 관리 드롭다운은 공통 gnb.js 초기 바인딩 대상이 아니므로 위임 방식으로 처리한다.
    function closeDscsActionDropdowns(exceptMenu) {
        document.querySelectorAll('.cmtBtnGroup .optionWrap.show').forEach(function(menu) {
            if(menu !== exceptMenu) {
                menu.classList.remove('show');
            }
        });
    }

    // 공통 gnb.js의 document click 닫기 이벤트보다 먼저 Ajax 목록 드롭다운을 처리한다.
    document.addEventListener('click', function(e) {
        var settingBtn = e.target.closest('.cmtBtnGroup .settingBtn');
        if(!settingBtn) {
            return;
        }

        var dropdown = settingBtn.closest('.dropdown');
        var menu = dropdown ? dropdown.querySelector('.optionWrap') : null;
        if(menu) {
            var willOpen = !menu.classList.contains('show');
            closeDscsActionDropdowns(menu);
            menu.classList.toggle('show', willOpen);
        }

        e.preventDefault();
        e.stopImmediatePropagation();
    }, true);

    // =========================================================
    // Delegated event handler (document-level)
    // =========================================================
    document.addEventListener('click', function(e) {

        if(e.target.closest('.optionWrap .item')) {
            closeDscsActionDropdowns();
        } else if(!e.target.closest('.optionWrap')) {
            closeDscsActionDropdowns();
        }

        // 1. 댓글 목록 토글
        var listBtn = e.target.closest('.toggle_commentlist');
        if(listBtn) {
            var li = listBtn.closest('li');
            if(!li) return;
            var ul = li.querySelector(':scope > .re_comment_ul');
            if(!ul) return;
            ul.style.display = (ul.style.display === 'none' || !ul.style.display) ? 'block' : 'none';
            return;
        }

        // 2. 게시글/대댓글 작성폼 토글 (cmtWri)
        var replyBtn = e.target.closest('.cmtWri');
        if(replyBtn) {
            var postIndex = replyBtn.getAttribute('data-post-idx');
            var flatIndex = replyBtn.getAttribute('data-flat-idx');
            var cmntSn = replyBtn.getAttribute('data-cmnt-sn');
            var formId = cmntSn ? 'toggleCmnt' + postIndex + flatIndex : 'toggleBox' + postIndex;
            var replyForm = document.getElementById(formId);
            if(!replyForm) return;
            var editMode = !!replyForm.querySelector('.cmt_create[data-edit-mode="true"]');
            var willOpen = replyForm.style.display !== 'block' || editMode;
            setCmntFormCreateMode(replyForm);
            closeAllActionForms(willOpen ? formId : '');
            editingCommentId = null;
            if(willOpen) {
                replyForm.style.display = 'block';
                replyForm.classList.add('on');
                replyForm.classList.remove('off');
                var ta = replyForm.querySelector('textarea');
                if(ta) { ta.value = ''; ta.focus(); }
            }
            return;
        }

        // 4-0. 참여글 숨김
        var hidePostBtn = e.target.closest('[data-action="hidePost"]');
        if(hidePostBtn) {
            var atclSn = hidePostBtn.getAttribute('data-atcl-sn');
            UiComm.showMessage("<spring:message code='forum.button.confirm.hide' />", "confirm") // 정말 숨김하시겠습니까?
                .then(function(result) {
                    if(!result) { return; }
                    var dscsId = "${dscsVO.dscsId}";
                    if("${dscsVO.dscsUnitTycd}" == "TEAM") {
                        dscsId = $('#team_selected_name').attr('teamSelectedDscsId');
                    }
                    ajaxCall('/forum2/forumLect/Form/hideAtcl.do',
                        { dscsAtclId: atclSn, dscsId: dscsId, userId: "${userId}" },
                        function(data) {
                            if(data.result > 0) { listForum(); }
                            else { UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.common.error'/>"), "error"); } // 오류가 발생했습니다!
                        }, null, true);
                });
            return;
        }

        // 4. 게시글 수정
        var editPostBtn = e.target.closest('[data-action="editPost"]');
        if(editPostBtn) {
            var atclSn = editPostBtn.getAttribute('data-atcl-sn');
            var rgtrId = editPostBtn.getAttribute('data-rgtr-id');
            var postIndex = editPostBtn.getAttribute('data-post-idx');
            editAtclBtn(atclSn, rgtrId, postIndex);
            return;
        }

        // 4-1. atcl_edit_save
        var atclSaveBtn = e.target.closest('.atcl_edit_save');
        if(atclSaveBtn) {
            var atclSn         = atclSaveBtn.getAttribute('data-atcl-sn');
            var dscsId         = atclSaveBtn.getAttribute('data-dscs-id');
            var oknokGbncd     = atclSaveBtn.getAttribute('data-oknok-gbncd');
            var postIndex      = atclSaveBtn.getAttribute('data-post-idx');
            var atclCts        = (document.getElementById('atclEditCts' + postIndex) || {}).value || '';
            if(!atclCts.trim()) { UiComm.showMessage('<spring:message code="forum.alert.input.forum_reply"/>', "info"); return; } // 댓글을 입력하세요
            ajaxCall('/forum2/forumLect/Form/editAtcl.do',
                { dscsAtclId: atclSn, dscsId: dscsId, oknokGbncd: oknokGbncd, atclCts: atclCts },
                function(data) {
                    if(data.result > 0) { editingPostId = null; listForum(); }
                    else { UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.common.error'/>"), "error"); } // 오류가 발생했습니다!
                }, null, true);
            return;
        }

        // 4-2. atcl_edit_cancel
        var atclCancelBtn = e.target.closest('.atcl_edit_cancel');
        if(atclCancelBtn) {
            closeAllActionForms('');
            return;
        }

        // 5. 게시글 삭제
        var delPostBtn = e.target.closest('[data-action="delPost"]');
        if(delPostBtn) {
            var atclSn = delPostBtn.getAttribute('data-atcl-sn');
            var rgtrId = delPostBtn.getAttribute('data-rgtr-id');
            delAtcl(atclSn, rgtrId);
            return;
        }

        // 6. 댓글 수정 버튼 (cmtUpt)
        var cmtUptBtn = e.target.closest('.cmtUpt');
        if(cmtUptBtn) {
            var atclSn   = cmtUptBtn.getAttribute('data-atcl-sn');
            var rgtrId   = cmtUptBtn.getAttribute('data-rgtr-id');
            var cmntSn   = cmtUptBtn.getAttribute('data-cmnt-sn');
            var postIndex = cmtUptBtn.getAttribute('data-post-idx');
            var flatIndex = cmtUptBtn.getAttribute('data-flat-idx');
            var level    = cmtUptBtn.getAttribute('data-level');
            var ansReqYn = cmtUptBtn.getAttribute('data-ans-req-yn');
            var form = document.getElementById('toggleCmnt' + postIndex + flatIndex);
            if(!form) return;
            if(editingCommentId === cmntSn) {
                closeAllActionForms('');
                return;
            }
            closeAllActionForms('toggleCmnt' + postIndex + flatIndex);
            var ctsEl = document.getElementById('cmntContents' + postIndex + flatIndex);
            var textarea = document.getElementById('cmntText' + postIndex + flatIndex);
            if(textarea && ctsEl) textarea.value = ctsEl.textContent;
            form.style.display = 'block';
            form.classList.add('on');
            form.classList.remove('off');
            if(textarea) textarea.focus();
            editingCommentId = cmntSn;
            setCmntFormEditMode(form, atclSn, cmntSn, postIndex, flatIndex);
            return;
        }

        // 6-5. 댓글 숨김 (cmtHid)
        var cmtHideBtn = e.target.closest('.cmtHid');
        if(cmtHideBtn) {
            var cmntSn = cmtHideBtn.getAttribute('data-cmnt-sn');
            UiComm.showMessage("<spring:message code='forum.button.confirm.hide' />", "confirm") // 정말 숨김하시겠습니까?
                .then(function(result) {
                    if(!result) { return; }
                    ajaxCall('/forum2/forumLect/Form/hideCmnt.do',
                        { dscsCmntId: cmntSn, userId: "${userId}" },
                        function(data) {
                            if(data.result > 0) {
                                listForum();
                            } else {
                                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.common.error'/>"), "error");// 오류가 발생했습니다!
                            }
                        }, null, true);
                });
            return;
        }

        // 7. 댓글 삭제 버튼 (cmtDel)
        var cmtDelBtn = e.target.closest('.cmtDel');
        if(cmtDelBtn) {
            var rgtrId = cmtDelBtn.getAttribute('data-rgtr-id');
            var cmntSn = cmtDelBtn.getAttribute('data-cmnt-sn');
            delCmnt(rgtrId, cmntSn);
            return;
        }

        // 8. 상단 댓글 등록 버튼 (btn.type2, data-action=addCmnt)
        var addCmntTopBtn = e.target.closest('[data-action="addCmnt"]');
        if(addCmntTopBtn) {
            var atclSn  = addCmntTopBtn.getAttribute('data-atcl-sn');
            var postIndex = addCmntTopBtn.getAttribute('data-post-idx');
            addCmnt(atclSn, '', postIndex);
            return;
        }

        // 8-1. 댓글 수정 취소 버튼
        var cmtEditCancelBtn = e.target.closest('.cmt_edit_cancel');
        if(cmtEditCancelBtn) {
            closeAllActionForms('');
            return;
        }

        // 9. 대댓글 등록/수정 버튼 (cmt_create)
        var crtBtn = e.target.closest('.cmt_create');
        if(crtBtn) {
            var atclSn  = crtBtn.getAttribute('data-atcl-sn');
            var cmntSn  = crtBtn.getAttribute('data-cmnt-sn');
            var postIndex = crtBtn.getAttribute('data-post-idx');
            var flatIndex = crtBtn.getAttribute('data-flat-idx');
            if(crtBtn.getAttribute('data-edit-mode') === 'true') {
                editCmnt(atclSn, cmntSn, postIndex, flatIndex, 1);
                editingCommentId = null;
                crtBtn.removeAttribute('data-edit-mode');
            } else {
                addCmnt(atclSn, cmntSn, postIndex, flatIndex);
            }
            return;
        }

    });
    </script>
</head>
<body class="class ${uiex:getTheme()}">
    <form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
        <input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
    </form>
    <form name="forumListForm" id="forumListForm" action="" method="POST">
        <input type="hidden" id="dscsId" name="dscsId" value="${dscsVO.dscsId}" />
        <input type="hidden" id="dscsUnitTycd" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}" />
        <input type="hidden" id="oknokStngyn" name="oknokStngyn" value="${dscsVO.oknokStngyn}" />
        <input type="hidden" id="sbjctId" name="sbjctId" value="${dscsVO.sbjctId}" />
        <input type="hidden" id="userId" name="userId" value="${userId}" />
        <input type="hidden" id="teamStdList" name="teamStdList" />
        <input type="hidden" id="teamId" name="teamId" value="" />
        <input type="hidden" id="userName" name="userName" value="${userName}" />
        <input type="hidden" id="dscsAtclId" name="dscsAtclId" />
        <input type="hidden" name="oknokGbncd" id = "oknokGbncd" value="F"/>
    </form>
	<div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="forum.label.forum" /><!-- 토론 -->
                            </h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="mw120"><a href="javascript:void(0)" onclick="dscsViewTab(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
                                <li class="mw120 select"><a  href="javascript:void(0)" onclick="dscsViewTab(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></h3>
                            <div class="right-area">
                                <%--<a href="javascript:void(0)" class="btn type2" onclick="editDscs('${dscsForumVO.dscsId}','${dscsForumVO.dscsSdttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
                                <a href="javascript:void(0)" class="btn type2" onclick="deleteDscs('${dscsForumVO.dscsId}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>--%>
                                <a href="javascript:void(0)" class="btn type2" onclick="viewDscsList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                        </div>

                        <!-- 토론정보 시작 -->
                        <jsp:include page="/WEB-INF/jsp/forum2/common/dscs_info_inc.jsp" />
                        <!-- 토론정보 끝 -->

                        <!-- 팀토론일경우 학습그룹 정보 표시 시작 -->
                        <c:if test="${dscsVO.dscsUnitTycd eq 'TEAM'}">
                        <div id="teamDscsList">
                            <c:choose>
                                <c:when test="${not empty dscsVO.teamDscsList}">
                                    <div class="lecture_tit">
                                        <strong><spring:message code='forum.label.lrngrp'/><%-- 팀그룹 --%></strong>
                                    </div>

                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width : 10%">
                                            <col >
                                            <col style="width : 10%">
                                            <col style="width : 10%">
                                            <col style="width : 10%">
                                            <col style="width : 10%">
                                            <col style="width : 10%">
                                            <col style="width : 10%">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th><spring:message code='forum.label.forum.bbs'/></th><!-- 토론방 -->
                                            <th><spring:message code='forum.label.team.ttl'/></th><!-- 부주제 -->
                                            <th><spring:message code='forum.label.team.leader'/></th><!-- 팀장 -->
                                            <th><spring:message code='forum.label.team.member'/></th><!-- 팀원 -->
                                            <th><spring:message code='forum.label.forum.joinCnt'/></th><!-- 참여글 -->
                                            <th><spring:message code='forum.button.cmnt'/></th><!-- 댓글 -->
                                            <th><spring:message code='forum.label.join'/></th><!-- 참여 -->
                                            <th><spring:message code='forum.label.dscs.open'/></th><!-- 토론방 OPEN -->
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="item" items="${dscsVO.teamDscsList}" varStatus="status">
                                            <tr>
                                                <td>
                                                    <button class="btn basic small team_selected_nm" id="team_selected_nm_${status.index}">${item.teamnm}</button>
                                                </td>
                                                <td><c:out value="${empty item.dscsTtl ? '-' : item.dscsTtl}" /></td>
                                                <td>${item.leaderNm}</td>
                                                <td>${item.teamMbrCnt}</td>
                                                <td>${item.atclCnt}</td>
                                                <td>${item.cmntCnt}</td>
                                                <td>
                                                    <button class="btn basic small" onclick="joinTeamDscsBtn('${item.dscsId}', 'team_selected_nm_${status.index}', '${item.teamnm}', '${item.teamId}')"><spring:message code='forum.label.join'/></button><!-- 참여 -->
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.teamDscsOyn eq 'Y'}">
                                                            <input type="checkbox" class="switch small" onchange="modifyTeamDscsOyn(this, '${item.dscsId}')" checked>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="checkbox" class="switch small" onchange="modifyTeamDscsOyn(this, '${item.dscsId}')">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code='forum.label.use.n'/><!-- 미사용 -->
                                </c:otherwise>
                            </c:choose>
                        </div>
                        </c:if>
                        <!-- 팀토론일경우 학습그룹 정보 표시 끝 -->

                        <c:if test="${isProsConsForum}">
                            <div id="prosConsSummaryArea"></div>
                        </c:if>

                        <!-- 토론방 참여 영역:시작 -->
                        <div id="join_write_input_area">
                            <!-- 토론방 <참여글 저장> -->
                            <c:choose>
                                <c:when test="${isProsConsForum}">
                                    <div class="proCon_wrap">
                                        <div class="answer">
                                            <div class="title_area">
                                                <strong><spring:message code='common.professor'/> <spring:message code='forum.label.feedback'/><span id="team_selected_name" teamSelectedDscsId=""></span></strong><%-- 교수자 / 피드백 --%>
                                            </div>
                                            <div class="cont">
                                                <form id="forumAtclForm" name="forumAtclForm" onsubmit="return false;">
                                                    <div class="editor-box">
                                                        <label for="atclCts" class="hide">Content</label>
                                                        <textarea class='resize-none' id="atclCts" name="atclCts" required="true"></textarea>
                                                        <script>
                                                            // HTML 에디터
                                                            let editor = UiEditor({
                                                                targetId: "atclCts",
                                                                uploadPath: "${dscsVO.uploadPath}",
                                                                height: "200px",
                                                            });
                                                        </script>
                                                    </div>
                                                    <div class="bottom_btn">
                                                        <div class="right-area">
                                                            <button type="button" class="btn type2" onclick="javascript:addAtclBtn()">
                                                                <spring:message code='forum.button.save'/><%-- 저장 --%>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="options_wrap mt0">
                                        <ul class="accordion">
                                            <li class="active">
                                                <div class="title-wrap">
                                                    <a class="title" href="javascript:void(0);">
                                                        <div class="lecture_tit">
                                                            <strong><spring:message code='forum.label.forum.bbs'/><span id="team_selected_name" teamSelectedDscsId=""></span></strong><%-- 토론방 --%>
                                                        </div>
                                                        <i class="arrow xi-angle-down"></i>
                                                    </a>
                                                </div>
                                                <div class="cont">
                                                    <form id="forumAtclForm" name="forumAtclForm" onsubmit="return false;">
                                                        <input type="hidden" name="uploadFiles"  id="uploadFiles" value="" />
                                                        <input type="hidden" name="uploadPath"   id="uploadPath"  value="${dscsVO.uploadPath}" />
                                                        <input type="hidden" name="delFileIdStr" id="delFileIdStr"  value="" />
                                                        <div class="table-wrap">
                                                            <table class="table-type5">
                                                                <colgroup>
                                                                    <col class="width-15per" />
                                                                    <col />
                                                                </colgroup>
                                                                <tbody>
                                                                    <tr>
                                                                        <th><label for="contTextarea" class="req">토론내용</label></th>
                                                                        <td>
                                                                            <div class="editor-box">
                                                                                <label for="atclCts" class="hide">Content</label>
                                                                                <textarea class='resize-none' id="atclCts" name="atclCts" required="true"></textarea>
                                                                                <script>
                                                                                    // HTML 에디터
                                                                                    let editor = UiEditor({
                                                                                        targetId: "atclCts",
                                                                                        uploadPath: "${dscsVO.uploadPath}",
                                                                                        height: "200px",
                                                                                    });
                                                                                </script>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            <div id="uploaderBox">
                                                                                <uiex:dextuploader
                                                                                        id="fileUploader"
                                                                                        path="${dscsVO.uploadPath}"
                                                                                        limitCount="1"
                                                                                        limitSize="100"
                                                                                        oneLimitSize="100"
                                                                                        listSize="1"
                                                                                        fileList=""
                                                                                        finishFunc="finishUpload()"
                                                                                        allowedTypes="*"
                                                                                        uiMode="simple"
                                                                                />
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                            <div class="btns">
                                                                <button type="button" class="btn type1" onclick="javascript:addAtclBtn()">
                                                                    <spring:message code='forum.label.forum.joinCnt'/> <spring:message code='forum.button.save'/><%-- 참여글 / 저장 --%>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <!-- 토론 참여글 끝 -->

                            <c:if test="${not isProsConsForum}">
                                <!-- 학생, 이름 검색 -->
                                <div class="board_top">
                                    <div class="search-typeC">
                                        <input class="form-control" type="text" placeholder="<spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />" id="searchValue"><!-- 학번, 이름 입력 -->
                                        <button type="button" class="btn basic icon search" aria-label="검색" onclick="listForum(1)"><i class="icon-svg-search"></i></button>
                                    </div>
                                    <div class="right-area">
                                        <div class="flex-left-auto">
                                            <%--<a href="javascript:void(0)" onclick="downExcel();" class="ui green button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>--%>
                                            <uiex:listScale func="changeListScale" value="${dscsVO.listScale}" />
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- 토론 참여글 목록 시작-->
                            <div class="ui attached message element">
                                <div id="atclList" class="mt20">
                                    <%-- 동적 렌더링: listForum() → createDscsAtclListHTML() --%>
                                </div>
                            </div>
                            <!-- 토론 참여글 목록 끝-->
                        </div>
                        <!-- 토론방 참여 영역:끝 -->
                    </div>
                </div>
            </div>
            <%--Top 버튼--%>
            <button type="button" class="go_top"><i class="xi-angle-up-min"></i><span>TOP</span></button>
        </main>
</body>
</html>
