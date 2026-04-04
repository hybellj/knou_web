<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="uiex" uri="http://uiextension/tags" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/forum_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>

    <style>
        /* 1. 아이콘을 오른쪽으로 배치 */
        .ui-accordion .ui-accordion-header {
            padding-left: 1em; /* 왼쪽 패딩 복구 */
            padding-right: 2.5em; /* 아이콘이 들어갈 오른쪽 공간 확보 */
        }

        .ui-accordion .ui-accordion-header-icon {
            left: auto !important; /* 기본 왼쪽 고정 해제 */
            right: 0.5em !important; /* 오른쪽 끝에서 약간 띄움 */
        }

        /* 필요시 아이콘 자체의 여백 조정 */
        .ui-accordion-header-icon.ui-icon {
            position: absolute;
            top: 50%;
            margin-top: -8px; /* 세로 중앙 정렬 */
        }

        /* title_area 우측 date+dropdown 그룹 */
        .answer .title_area .right-area { display: flex; align-items: center; gap: 8px; }

        /* 대댓글 recmt_form 배경색 - 최상위 댓글 작성폼과 통일 (common.css:1162 오버라이드) */
        .Comment .comment_list ul li .recmt_form { background-color: #F0F2F6; padding: 1.5rem 2.5rem; }

        /* 게시글 인라인 수정 폼 */
        .atcl_edit_form textarea { width: 100%; box-sizing: border-box; }
        .atcl_edit_form .bottom_btn { display: flex; justify-content: flex-end; }

        /* dropdown - tmpl_atclBody (.right-area) */
        .right-area .dropdown { position: relative; display: inline-block; }
        .right-area .dropdown .option-wrap { position: absolute; top: calc(100% + 2px); right: 0; background: white; border: 1px solid #ddd; border-radius: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); overflow: hidden; max-height: 0; opacity: 0; transition: all 0.25s ease; pointer-events: none; z-index: 10; }
        .right-area .dropdown .option-wrap.show { max-height: 200px; opacity: 1; pointer-events: auto; }
        .right-area .dropdown .option-wrap .item { padding: 8px 12px; white-space: nowrap; transition: all 0.3s ease; }
        .right-area .dropdown .option-wrap .item:hover { background: #f2f2f2; }

        /* dropdown - _tmpl_cmntEditBtns (.cmtBtnGroup) */
        .cmtBtnGroup .dropdown { position: relative; display: inline-block; }
        .cmtBtnGroup .dropdown .option-wrap { position: absolute; top: calc(100% + 2px); right: 0; background: white; border: 1px solid #ddd; border-radius: 4px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); overflow: hidden; max-height: 0; opacity: 0; transition: all 0.25s ease; pointer-events: none; z-index: 20; }
        .cmtBtnGroup .dropdown .option-wrap.show { max-height: 200px; opacity: 1; pointer-events: auto; }
        .cmtBtnGroup .dropdown .option-wrap .item { padding: 8px 12px; white-space: nowrap; transition: all 0.3s ease; }
        .cmtBtnGroup .dropdown .option-wrap .item:hover { background: #f2f2f2; }

        /* 게시글/댓글 프로필 이미지 */
        .title_area .user_img,
        .cmt_info .user_img {
            display: inline-block;
            width: 28px; height: 28px;
            border-radius: 100%;
            overflow: hidden;
            vertical-align: middle;
            margin-right: 6px;
            background: #F4F4F4;
            flex-shrink: 0;
        }
        .title_area .user_img img,
        .cmt_info .user_img img { width: 100%; height: 100%; object-fit: cover; }
    </style>

    <script type="text/javascript">
    var dialog;
    $(document).ready(function() {
        if("${dscsForumVO.dscsUnitTycd}" == "TEAM") {
            if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
                $('.team_selected_nm').prop('disabled', true);
                $('#join_write_input_area').hide();
            } else {
                listForum(1);        // Team 토론시 팀토론 코드로 변경
            }
        } else {
            listForum(1);
        }

        $(".accordion").accordion({
            header: "> .title",
            icons: {
                "header": "ui-icon-triangle-1-s",    // 닫혀있을 때 (아래 방향)
                "activeHeader": "ui-icon-triangle-1-n" // 열려있을 때 (위 방향)
            },
            collapsible: true,
            active: false,
            heightStyle: "content",
            activate: function( event, ui ) {
                // 섹션이 열릴 때 title에 active 클래스를 넣고 싶다면
                if(ui.newHeader.length > 0) {
                    ui.newHeader.addClass("active");
                }
                // 섹션이 닫힐 때 active 클래스를 제거
                if(ui.oldHeader.length > 0) {
                    ui.oldHeader.removeClass("active");
                }
            }
        });
    });

    // 팀토론토론방OPEN여부 수정
    function modifyTeamDscsOyn(el, dscsId) {
        var $el = $(el);
        var isChecked = $el.is(":checked");

        $el.prop("disabled", true);
        var param = {
            dscsId          : dscsId
        ,   teamDscsOyn     : isChecked ? 'Y' : 'N'
        };
        alert("토론방 open 여부 변경 :" + isChecked);
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
        $("input[name='teamCd']").val(teamId || '');
        listForum(1);
    }

    function forumView(tab) {
        var urlMap = {
            "0" : "/forum2/forumLect/Form/infoManage.do",	// 토론정보
            "1" : "/forum2/forumLect/Form/bbsManage.do",	// 토론방
            "2" : "/forum2/forumLect/Form/scoreManage.do",	// 토론평가
            "3" : "/forum2/forumLect/Form/mutEvalResult.do",// 상호평가
        };

        var url  = urlMap[tab];
        /*
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "manageForm");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${dscsForumVO.crsCreCd}" />'}));
        form.append($('<input/>', {type: 'hidden', name: 'dscsId',  value: '<c:out value="${dscsForumVO.dscsId}" />'}));
        form.appendTo("body");
        form.submit();*/
        location.href = url + '?dscsId=<c:out value="${dscsForumVO.dscsId}" />';
    }

    //토론글 리스트
    function listForum(page) {
        if("${dscsForumVO.dscsUnitTycd}" == "TEAM") {
            var teamNm = $("#selectTeam option:selected").text();
        } else {
            var teamNm = "";
        }

        var searchValue = "";

        if ($("#searchValue").val() == "찬성") {
            searchValue = "P";
        } else if ($("#searchValue").val() == "반대") {
            searchValue = "C";
        }else if ($("#searchValue").val() == "FeedBack") {
            searchValue = "F";
        } else {
            searchValue = $("#searchValue").val();
        }

        // Team 토론시 팀토론 코드로 변경
        var dscsId = "${dscsForumVO.dscsId}";
        if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
            dscsId = $('#team_selected_name').attr('teamSelectedDscsId');
        }

        var url = "/forum2/forumLect/Form/forumBbsViewList.do";
        var data = {
            "pageIndex" : page,
            "listScale" : $("#listScale").val(),
            "searchValue" : searchValue,
            "dscsId" : dscsId,
            "dscsUnitTycd" : "${dscsForumVO.dscsUnitTycd}",
            "crsCreCd" : "${dscsForumVO.crsCreCd}",
            "userId" : "${userId}",
            "userName" : "${userName}",
            "stdList" : $("#teamStdList").val(),
            "teamCtgrCd" : "${dscsForumVO.teamTycd}",
            "teamNm" : teamNm,
        };

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                var returnList = data.returnList || [];
                var pageInfo = data.pageInfo;
                var html = createForumListHTML(returnList);
                $("#atclList").find('.tstyle_view').remove();
                $("#atclList").empty().html(html);

                var params = {
                    totalCount : pageInfo.totalRecordCount
                    , listScale : pageInfo.recordCountPerPage
                    , currentPageNo : pageInfo.currentPageNo
                    , eventName : "listForum"
                };
                gfn_renderPaging(params);
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
        }, true);
    }


    var _ctxPath = '${pageContext.request.contextPath}';

    // =========================================================
    // 1. 유틸 함수
    // =========================================================

    // 프로필 이미지 HTML 생성 (내부유틸)
    function _userImgHtml(phtFile) {
        var src = phtFile ? (_ctxPath + phtFile) : (_ctxPath + '/webdoc/img/icon-hycu-symbol-grey.svg');
        return "<span class='user_img'><img src='" + src + "' aria-hidden='true' alt='사진'></span>";
    }

    // 날짜 포맷 변환 (내부유틸)
    function _formatDttm(dttm) {
        return dttm.substring(0, 4) + '.' + dttm.substring(4, 6) + '.' + dttm.substring(6, 8)
             + ' (' + dttm.substring(8, 10) + ':' + dttm.substring(10, 12) + ')';
    }

    // 찬성/반대 뱃지 (내부유틸)
    function _tmpl_prosConsBadge(v) {
        if(v.dscsAtclTycd == "GNRL_N" || v.dscsAtclTycd == "TEAM_N") {
            return '';
        }
        if(v.oknokGbncd == "OK") {
            return "<span class='label mr10 fcBlue'><spring:message code='forum.label.pros'/></span>";
        } else if(v.oknokGbncd == "NOTOK") {
            return "<span class='label mr10 fcRed'><spring:message code='forum.label.cons'/></span>";
        }
        return '';
    }

    // 댓글 수정/삭제/대댓글 버튼 (내부유틸)
    function _tmpl_cmntEditBtns(rs, postIdx, flatIdx, depth) {
        if(rs.delyn == "Y") { return ''; }
        var isOwner = (rs.rgtrId == "${userId}");
        if(rs.delyn == "H") {
            if(!isOwner) { return ''; }
            return [
                "<span class=\"cmtBtnGroup\">",
                "    <div class=\"dropdown\">",
                "        <button type=\"button\" class=\"btn basic icon set settingBtn\" aria-label=\"댓글 관리\"><i class=\"xi-ellipsis-v\"></i></button>",
                "        <div class=\"option-wrap\">",
                "            <div class=\"item\"><button class=\"cmtDel\" data-rgtr-id=\""+ rs.rgtrId +"\" data-cmnt-sn=\""+ rs.dscsCmntId +"\"><spring:message code='forum.button.del'/></button></div>",
                "        </div>",
                "    </div>",
                "</span>"
            ].join('');
        }
        var replyBtn = (depth < 4)
            ? "<button class=\"cmtWri btn basic small\" data-atcl-sn=\""+ rs.dscsAtclId +"\" data-cmnt-sn=\""+ rs.dscsCmntId +"\" data-post-idx=\""+ postIdx +"\" data-flat-idx=\""+ flatIdx +"\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.writer'/></button>"/* 댓글 작성 */
            : '';
        if (!isOwner) {
            return replyBtn ? "<span class=\"cmtBtnGroup\">"+ replyBtn +"</span>" : '';
        }
        return [
            "<span class=\"cmtBtnGroup\">",
            replyBtn,
            "    <div class=\"dropdown\">",
            "        <button type=\"button\" class=\"btn basic icon set settingBtn\" aria-label=\"댓글 관리\"><i class=\"xi-ellipsis-v\"></i></button>",
            "        <div class=\"option-wrap\">",
            "            <div class=\"item\"><button class=\"cmtUpt\" data-atcl-sn=\""+ rs.dscsAtclId +"\" data-rgtr-id=\""+ rs.rgtrId +"\" data-cmnt-sn=\""+ rs.dscsCmntId +"\" data-post-idx=\""+ postIdx +"\" data-flat-idx=\""+ flatIdx +"\" data-level=\""+ rs.lvl +"\" data-ans-req-yn=\""+ rs.rspnsReqyn +"\"><spring:message code='forum.button.mod'/></button></div>",
            "            <div class=\"item\"><button class=\"cmtDel\" data-rgtr-id=\""+ rs.rgtrId +"\" data-cmnt-sn=\""+ rs.dscsCmntId +"\"><spring:message code='forum.button.del'/></button></div>",
            "            <div class=\"item\"><button class=\"cmtHide\" data-cmnt-sn=\""+ rs.dscsCmntId +"\" data-post-idx=\""+ postIdx +"\" data-flat-idx=\""+ flatIdx +"\">댓글 숨김</button></div>",
            "        </div>",
            "    </div>",
            "</span>"
        ].join('');
    }

    // =========================================================
    // 2. 템플릿 함수
    // =========================================================

    // 게시글 상단 -> .answer > .title_area
    function tmpl_atclHeader(v, i) {
        var regDttm = _formatDttm(v.regDttm);
        var fileLinks = [];
        // 파일 다운로드
        (v.fileList || []).forEach(function(item, fIdx) {
            var sep = fIdx > 0 ? " | " : "";
            fileLinks.push(sep + "<a href='#_' onclick=\"UiFileDownloader('"+ item.encDownParam +"');return false;\" class=\"link\" title=\"File download\">"+ item.filenm +"</a>");
        });
        var fileTitle = " | <spring:message code='forum.label.attachFile'/> : ";
        if(fileLinks.length > 0) {
            fileTitle += fileLinks.join('');
        } else {
            fileTitle += '-';
        }

        var titleText = _userImgHtml(v.phtFile) + v.usernm + "(" + v.userId + ")" + _tmpl_prosConsBadge(v);

        var dropdownHtml;
        if(v.rgtrId == "${userId}" && v.delyn == "N") {
            dropdownHtml = [
                "<div class='dropdown'>",
                "    <button type='button' class='btn basic icon set settingBtn' aria-label='게시글 관리'><i class='xi-ellipsis-v'></i></button>",
                "    <div class='option-wrap'>",
                "        <div class='item'><a href='javascript:void(0)' data-action='hidePost' data-atcl-sn='"+ v.dscsAtclId +"'><spring:message code='forum.label.forum.joinCnt'/><spring:message code='forum.button.hide.apply'/></a></div>",/*참여글 숨김*/
                "        <div class='item'><a href='javascript:void(0)' data-action='editPost' data-atcl-sn='"+ v.dscsAtclId +"' data-rgtr-id='"+ v.rgtrId +"' data-post-idx='"+ i +"'><spring:message code='forum.button.mod'/></a></div>",/*수정*/
                "        <div class='item'><a href='javascript:void(0)' data-action='delPost' data-atcl-sn='"+ v.dscsAtclId +"' data-rgtr-id='"+ v.rgtrId +"'><spring:message code='forum.button.del'/></a></div>",/*삭제*/
                "    </div>",
                "</div>"
            ].join('');
        } else {
            dropdownHtml = [
                "<div class='dropdown'>",
                "    <button type='button' class='btn basic icon set settingBtn' aria-label='게시글 관리'><i class='xi-ellipsis-v'></i></button>",
                "    <div class='option-wrap'>",
                (v.delyn != "H" ? "        <div class='item'><a href='javascript:void(0)' data-action='hidePost' data-atcl-sn='"+ v.dscsAtclId +"'><spring:message code='forum.label.forum.joinCnt'/><spring:message code='forum.button.hide.apply'/></a></div>" : ""),/*참여글 숨김*/
                "        <div class='item'><a href='javascript:void(0)' data-action='delPost' data-atcl-sn='"+ v.dscsAtclId +"' data-rgtr-id='"+ v.rgtrId +"'><spring:message code='forum.button.del'/></a></div>",/*삭제*/
                "    </div>",
                "</div>"
            ].join('');
        }
        return [
            "<div class='title_area'>",
            "    <strong class='title'>" + titleText + "</strong>",
            "    <span class='date'> | <b>" + v.atclCtsLen + "</b><spring:message code='forum.label.word'/> | <spring:message code='forum.label.reg.dttm'/> : " + regDttm + fileTitle + "</span>",/*자, 작성일시, 첨부파일*/
            "    <div class='right-area'>",
            "        <button type='button' class='btn basic small my-cmnt-badge'>" + v.myCmntCount + "</button>",
            dropdownHtml,
            "    </div>",
            "</div>"
        ].join('');
    }

    // 게시글 본문 -> .answer > .cont
    function tmpl_atclBody(v, i) {
        var ctsHtml;
        console.log("${dscsForumVO.prosConsForumCfg}");
        if("${dscsForumVO.prosConsForumCfg}" == "Y") {
            ctsHtml = "<pre>" + v.atclCts + "</pre>";
        } else {
            ctsHtml = v.atclCts;
        }
        var delBadge = (v.delyn == "Y")
            ? " <span class=\"fcBlue mr5\">[삭제됨]</span>"
            : (v.delyn == "H")
            ? " <span class=\"fcRed mr5\">[숨겨짐]</span>"
            : '';
        return [
            "<div class='cont' id='atclBody"+ i +"'>",
            "    " + ctsHtml,
            "</div>",
            delBadge
        ].join('');
    }

    // 게시글 인라인 수정 폼 (기본 숨김)
    function tmpl_atclEditForm(v, i) {
        return [
            "<div class='recmt_form atcl_edit_form' id='atclEditForm"+ i +"' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'>게시글 수정</legend>",
            "        <div class='memo'>",
            "            <textarea class='resize-none' rows='3' id='atclEditCts"+ i +"'></textarea>",
            "            <div class='bottom_btn'>",
            "                <div class='right-area'>",
            "                    <button type='button' class='btn type2 atcl_edit_save'",
            "                        data-atcl-sn='"+ v.dscsAtclId +"'",
            "                        data-forum-cd='"+ v.dscsId +"'",
            "                        data-pros-cons-type-cd='"+ (v.oknokGbncd||'') +"'",
            "                        data-post-idx='"+ i +"'><spring:message code='forum.button.mod'/></button>",
            "                    <button type='button' class='btn basic atcl_edit_cancel'",
            "                        data-post-idx='"+ i +"'><spring:message code='forum.button.cancel'/></button>",
            "                </div>",
            "            </div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join('');
    }

    // 댓글 영역 -> .Comment (top_area + comment_list 상단 작성폼, 닫는 div 2개는 createForumListHTML에서 추가)
    function tmpl_cmntWriteForm(atclSn, i, cmntCount) {
        return [
            "<div class='Comment'>",
            "    <div class='top_area'>",
            "        <button class='toggle_commentlist' id='cmntOpen"+ i +"'>",
            "            <i class='icon-svg-message'></i>" + cmntCount + "개의 댓글이 있습니다. <i class='icon-svg-arrow-down'></i>",
            "        </button>",
            "        <button class='toggle_commentwrite btn basic small'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.writer'/></button>", /*댓글 작성*/
            "    </div>",
            "    <div class='comment_list'>",
            "        <div class='recmt_form' id='toggleBox"+ i +"' style='display:none;'>",
            "            <fieldset>",
            "                <legend class='sr_only'>댓글등록</legend>",
            "                <div class='memo'>",
            "                    <div class='simple_answer'>",
            "                        <span><spring:message code='forum.button.label.info' /></span>",
            "                        <div class='answer_btn'>",
            "                            <a href='#0' onclick=\"setCts(0, "+ i +");\"><spring:message code='forum.button.cts0' /></a>",
            "                            <a href='#0' onclick=\"setCts(1, "+ i +");\"><spring:message code='forum.button.cts1' /></a>",
            "                            <a href='#0' onclick=\"setCts(2, "+ i +");\"><spring:message code='forum.button.cts2' /></a>",
            "                        </div>",
            "                    </div>",
            "                    <textarea class='resize-none' title='<spring:message code="forum.label.input.cmnt"/>' class='comment' name='c_comment' rows='3' cols='76' placeholder='<spring:message code="forum.label.input.cmnt"/>' id='cmntText"+ i +"'></textarea>",
            "                    <div class='bottom_btn'>",
            "                        <span class='custom-input'>",
            "                            <input type='checkbox' id='ansReqYn"+ i +"' name='ansReqYn' disabled>",
            "                            <label for='ansReqYn"+ i +"'><span class='small'><spring:message code='forum.checkbox.label.request' /></span></label>",/*답변을 요청합니다.*/
            "                        </span>",
            "                        <div class='right-area'>",
            "                            <button type='button' class='btn basic small type2' data-action='addCmnt' data-atcl-sn='"+ atclSn +"' data-post-idx='"+ i +"'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></button>", /*댓글 등록*/
            "                        </div>",
            "                    </div>",
            "                </div>",
            "            </fieldset>",
            "        </div>"
        ].join('');
    }

    // 댓글 <li> 1개 생성 (재귀 지원, depth 1=top/2+= nested)
    function _createCmntItemHTML(node, postIdx, depth) {
        var rs      = node.rs;
        var flatIdx = node.flatIdx;
        var liClass = (depth > 1) ? " class='re_comment'" : "";
        var regDate = _formatDttm(rs.modDttm);

        var ctsSpan = (rs.delyn == "Y")
            ? "<span class='comment'>"+ (rs.cmntCts || '') +" <span class='ui red label p4 f080'>[삭제됨]</span></span>"
            : (rs.delyn == "H")
            ? "<span class='comment'>"+ (rs.cmntCts || '') +" <span class='ui red label p4 f080'>[숨겨짐]</span></span>"
            : "<span class='comment' id='cmntContents"+ postIdx + flatIdx +"'>"+ rs.cmntCts +"</span>";

        var replyFormHTML = '';
        if(rs.delyn != "Y" && rs.delyn != "H") {
            var fi = "" + postIdx + flatIdx;
            replyFormHTML = [
                "<div class='recmt_form' id='toggleCmnt"+ fi +"' style='display:none;'>",
                "    <fieldset>",
                "        <legend class='sr_only'>댓글등록</legend>",
                "        <div class='memo'>",
                "            <div class='simple_answer'>",
                "                <span><spring:message code='forum.button.label.info' /></span>",
                "                <div class='answer_btn'>",
                "                    <a href='#0' onclick=\"setCts(0, '"+ fi +"');\"><spring:message code='forum.button.cts0' /></a>",
                "                    <a href='#0' onclick=\"setCts(1, '"+ fi +"');\"><spring:message code='forum.button.cts1' /></a>",
                "                    <a href='#0' onclick=\"setCts(2, '"+ fi +"');\"><spring:message code='forum.button.cts2' /></a>",
                "                </div>",
                "            </div>",
                "            <textarea class='resize-none' title='<spring:message code="forum.label.input.cmnt"/>' class='comment' name='c_comment' rows='3' cols='76' placeholder='<spring:message code="forum.label.input.cmnt"/>' id='cmntText"+ fi +"'></textarea>",
                "            <div class='bottom_btn'>",
                "                <span class='custom-input'>",
                "                    <input type='checkbox' id='ansReqYn"+ fi +"' name='ansReqYn' disabled>",
                "                    <label for='ansReqYn"+ fi +"'><span class='small'><spring:message code='forum.checkbox.label.request' /></span></label>",
                "                </span>",
                "                <div class='right-area'>",
                "                    <button type='button' class='btn type2 cmt_create' data-atcl-sn='"+ rs.dscsAtclId +"' data-cmnt-sn='"+ rs.dscsCmntId +"' data-post-idx='"+ postIdx +"' data-flat-idx='"+ flatIdx +"'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></button>",/*댓글 등록*/
                "                </div>",
                "            </div>",
                "        </div>",
                "    </fieldset>",
                "</div>"
            ].join('');
        }

        var repliesHTML = '';
        if(node.children && node.children.length > 0) {
            var replyItems = node.children.map(function(child) {
                return _createCmntItemHTML(child, postIdx, depth + 1);
            }).join('');
            repliesHTML = "<ul class='re_comment_ul'>"+ replyItems +"</ul>";
        }

        return [
            "<li"+ liClass +">",
            "    <div class='item'>",
            "        <div class='cmt_info'>",
            "            " + _userImgHtml(rs.phtFile),
            "            <strong class='name'>"+ rs.rgtrnm +"</strong>",
            "            <span class='date'>"+ regDate +"</span>",
            "        </div>",
            ctsSpan,
            _tmpl_cmntEditBtns(rs, postIdx, flatIdx, depth),
            "    </div>",
            replyFormHTML,
            repliesHTML,
            "</li>"
        ].join('');
    }

    // =========================================================
    // 3. 조립 함수
    // =========================================================

    // 토론 글 리스트 생성 (최상위 조립 함수)
    function createForumListHTML(forumList) {
        if(forumList.length == 0) {
            return [
                "<div class=\"flex-container\">",
                "    <div class=\"cont-none\">",
                "        <span><spring:message code='forum.common.empty' /></span>",
                "    </div>",
                "</div>"
            ].join('');
        }

        if("${dscsForumVO.prosConsForumCfg}" == "Y") {
            var grouped = {ok: [], notok: [], fb: []};
            forumList.forEach(function(v, i) {
                if(v.oknokGbncd === 'OK')        grouped.ok.push({v: v, i: i});
                else if(v.oknokGbncd === 'NOTOK') grouped.notok.push({v: v, i: i});
                else                                  grouped.fb.push({v: v, i: i});
            });
            var buildSection = function(title, cssKey, items, showCount) {
                var header = showCount
                    ? title + " [<spring:message code='common.page.total'/> " + items.length + "<spring:message code='message.person'/>]" /*총 0명*/
                    : title;
                var parts = [
                    "<div class='pros-cons-section pros-cons-section--" + cssKey + "'>",
                    "<h4 class='pros-cons-title'>" + header + "</h4>"
                ];
                items.forEach(function(item) { parts.push(_createPostHTML(item.v, item.i)); });
                parts.push("</div>");
                return parts.join('');
            };
            return buildSection('<spring:message code="forum.label.pros.opinion"/>', 'ok', grouped.ok, true) /*찬성 의견*/
                 + buildSection('<spring:message code="forum.label.cons.opinion"/>', 'notok', grouped.notok, true) /*반대 의견*/
                 + buildSection('FeedBack', 'fb', grouped.fb, false);
        }

        var parts = [];
        forumList.forEach(function(v, i) {
            parts.push(_createPostHTML(v, i));
        });
        return parts.join('');
    }

    // 게시글 1개 .tstyle_view 블록 생성
    function _createPostHTML(v, i) {
        var cmntCount = v.cmntList.length;
        var cmntItemsHTML = _buildCmntListHTML(v.cmntList, i);
        return [
            "<div class='tstyle_view'>",
            "    <div class='answer'>",
            tmpl_atclHeader(v, i),
            tmpl_atclBody(v, i),
            tmpl_atclEditForm(v, i),
            "    </div>",
            tmpl_cmntWriteForm(v.dscsAtclId, i, cmntCount),
            "<ul>",
            cmntItemsHTML,
            "</ul>",
            "    </div>",
            "</div>"
        ].join('');
    }

    // flat 댓글 목록 → parCmntSn 기반 tree HTML 조립
    function _buildCmntListHTML(cmntList, postIdx) {
        var nodeMap = {};
        var roots = [];
        cmntList.forEach(function(rs, flatIdx) {
            nodeMap[rs.dscsCmntId] = { rs: rs, flatIdx: flatIdx, children: [] };
        });
        cmntList.forEach(function(rs) {
            if (rs.upCmntId && nodeMap[rs.upCmntId]) {
                nodeMap[rs.upCmntId].children.push(nodeMap[rs.dscsCmntId]);
            } else {
                roots.push(nodeMap[rs.dscsCmntId]);
            }
        });
        return roots.map(function(node) {
            return _createCmntItemHTML(node, postIdx, 1);
        }).join('');
    }

    // 게시글(참여글) 등록 버튼
    function addAtclBtn(atclSn, atclStatus){
        /*$("#forumListForm").attr("target", "forumAtclIfm");
        $("#forumListForm").attr("action", "/forum2/forumLect/Form/addForumBbs.do");
        $("#forumListForm").submit();
        $('#forumAtclPop').modal('show');*/

        // 입력필드 검증
        UiValidator("atclWriteForm")
        .then(function(result) {
            if (result) {
                // 찬반토론일 경우
                if (${dscsForumVO.prosConsForumCfg eq 'Y'}) {
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
        if (${dscsForumVO.prosConsForumCfg ne 'Y'}) {
            let dx = dx5.get("fileUploader");
            $("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정
        }

        // Team 토론시 팀토론 코드로 변경
        if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
            var teamDscsId = $('#team_selected_name').attr('teamSelectedDscsId');
            $("input[name='dscsId']").val(teamDscsId);
        }

        var atclTypeCd = "<c:out value="${dscsForumVO.dscsUnitTycd}" />"  + "_" + "<c:out value="${dscsForumVO.prosConsForumCfg}" />";
        var param = [];
        param = param.concat($("#forumListForm").serializeArray());
        param = param.concat($("#forumAtclForm").serializeArray());

        // TODO : 03.14 추후 atclCts 로 변경 필요.
        param.push({name:"cts", value:$("#atclCts").val()});
        param.push({name:"atclTypeCd", value:atclTypeCd});

        if(atclStatus == 'E') { // 수정
            var url = "/forum2/forumLect/Form/editAtcl.do";
            ajaxCall(url, param, function(data) {
                if(data.result > 0) {
                    // 입력내용 clear
                    editor.openHTML("");

                    alert("<spring:message code='forum.alert.edit.forum.atcl_success'/>"); // 토론 게시글 수정에 성공하였습니다.
                    listForum(1);
                } else {
                    alert("<spring:message code='forum.alert.edit.forum.atcl_fail'/>"); // 토론 게시글에 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
                }
            }, function(xhr, status, error) {
                alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다.
            }, true);
        } else { // 등록
            var url = "/forum2/forumLect/Form/addAtcl.do";

            ajaxCall(url, param, function(data) {
                if(data.result > 0) {
                    // 입력내용 clear
                    editor.openHTML("");

                    alert("<spring:message code='forum.alert.add.forum.atcl_success'/>"); // 토론 게시글 등록에 성공하였습니다.
                    listForum(1);
                } else {
                    alert("<spring:message code='forum.alert.add.forum.atcl_fail'/>"); // 토론 게시글에 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
                }
            }, function(xhr, status, error) {
                alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다.
            }, true);
        }
    }

    //게시글 삭제
    function delAtcl(atclSn,rgtrId){
        var result = confirm("<spring:message code='forum.button.confirm.del' />"); // 정말 삭제하시겠습니까?
        if(!result) { return false; }

        // Team 토론시 팀토론 코드로 변경
        var dscsId = "${dscsForumVO.dscsId}";
        if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
            forumCd = $('#team_selected_name').attr('teamSelectedDscsId');
        }

        var url = "/forum2/forumLect/Form/delAtcl.do";
        var data = {
            "dscsAtclId" : atclSn,
            "dscsId" : dscsId,
            "userId" : "${userId}"
        };

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                alert("<spring:message code='forum.alert.del.forum.atcl_success'/>"); // 게시글 삭제에 성공하였습니다.
                listForum();
            } else {
                alert("<spring:message code='forum.alert.del.forum.atcl_fail'/>"); // 게시글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
                listForum();
            }
        }, function(xhr, status, error) {
            alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
        }, true);
    }

    //댓글 보기
    function cmntView(atclSn, index) {
        if(!$("#cmntOpen"+index).hasClass("on")) {
            $("#cmntOpen"+index).addClass("on").removeClass("off");
            $("#article"+index).css("display", "block");
            $("#cmntOpen"+index).children("i").removeClass("down").addClass("up");
        } else {
            $("#cmntOpen"+index).addClass("off").removeClass("on");
            $("#article"+index).css("display", "none");
            $("#cmntOpen"+index).children("i").removeClass("up").addClass("down");
        }
        $("#article"+index).toggleClass("on");
        $("#article"+index).toggle();
    }


    // 토론 댓글 리스트 생성
    function createArticleListHTML(articleList, index) {
        var parts = [];
        $.each(articleList, function(i) {
            var rs = articleList[i];
            parts.push(tmpl_cmntItem(rs, index, i));
        });
        return parts.join('');
    }


    //댓글 작성 버튼
    function cmntWirte(atclSn,index) {
        if(!$("#toggleBox"+index ).hasClass("on")) { // 댓글 폼이 off일 때
            $("#toggleBox"+index ).addClass("on").removeClass("off");
            $("#toggleBox"+index).css("display", "block");
    //		$("#cmntWrite"+index).children("i").removeClass("down").addClass("up");
        } else { // 댓글 폼이 on일 때
            $("#toggleBox"+index ).addClass("off").removeClass("on");
            $("#toggleBox"+index).css("display", "none");
    //		$("#cmntWrite"+index).children("i").removeClass("up").addClass("down");
        }
    }

    //댓글 등록
    function addCmnt(atclSn, parCmntSn ,index,i) {
        var ansReqYn = "N";
        var cmntCts ="";
        if (parCmntSn == null || parCmntSn == '') {
            if($("#ansReqYn"+ index).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts = $("#cmntText" + index).val();
        } else {
            if ($("#ansReqYn"+ index + i).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts = $("#cmntText"+index+i).val().trim();
        }

        if(cmntCts == null || cmntCts == ""){
            alert("<spring:message code='forum.alert.input.reply'/>");//댓글을 입력해주시기 바랍니다.
            $("#toggleBox"+index ).addClass("off").removeClass("on");
        }else{
            $("#cmntText" + index).val('');

            // Team 토론시 팀토론 코드로 변경
            var dscsId = "${dscsForumVO.dscsId}";
            if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
                forumCd = $('#team_selected_name').attr('teamSelectedDscsId');
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
                "crsCreCd" : "${dscsForumVO.crsCreCd}"
            };

            ajaxCall(url, data, function(data) {
                if(data.result > 0) {
                    alert("<spring:message code='forum.alert.reg_success.reply'/>");// 댓글 등록에 성공하였습니다.
                } else {
                    alert("<spring:message code='forum.alert.reg_fail.reply'/>");// 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
                }
                listForum($("#currentIndex").val());
            }, function(xhr, status, error) {
                alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
            }, true);
        }
    }

    //댓글 수정 버튼 클릭
    function editBtnClick(atclSn,rgtrId,cmntSn,index,i,level, ansReqYn) {
        if(!$("#toggleCmnt"+index+i).hasClass("on")){
            $("#toggleCmnt"+index+i).addClass("on").removeClass("off");
    //		$("#toggleCmnt"+index+i).css("display", "block");
    //		$("#cmntCts"+index+i).find("i").removeClass("down").addClass("up");
            var cmntCts = $("#cmntContents"+index + i).text();
            $("#cmntText"+index+i).val(cmntCts);
            if(ansReqYn == "Y") {
                $("#ansReqYn"+index+i).prop("checked", true);
            }
            var btn = "";
            btn += "<li id=\"btnCmnt"+index+i+"\">";
            btn += "	<a href=\"javascript:editCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.mod'/></a>"; // 수정
            btn += "</li>";
            $("#btnCmnt"+index+i).after(btn);
            $("#btnCmnt"+index+i).remove();
        }else{
            $("#toggleCmnt"+index+i).addClass("off").removeClass("on");
    //		$("#toggleCmnt"+index+i).css("display", "none");
    //		$("#cmntCts"+index+i).find("i").removeClass("up").addClass("down");
            $("#cmntText"+index+i).val('');
            if(ansReqYn == "Y") {
                $("#ansReqYn"+index+i).prop("checked", true);
            }
            var btn = "";
            btn += "<li id=\"btnCmnt"+index+i+"\">";
            btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
            btn += "</li>";
            $("#btnCmnt"+index+i).after(btn);
            $("#btnCmnt"+index+i).remove();
        }
    }

    // 댓글 수정
    function editCmnt(atclSn,cmntSn,index,i,level){
        var ansReqYn = "N";
        var cmntCts = "";
        if(level == null || level == ''){
            if($("#ansReqYn"+ index).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts= $("#cmntText" + index).val();
            $("#cmntText" + index).val('');
        }else{
            if($("#ansReqYn"+ index + i).is(":checked") == true) {
                ansReqYn = "Y";
            }
            cmntCts = $("#cmntText"+index+i).val().trim();
        }
        if(cmntCts == null || cmntCts == ""){
            alert("<spring:message code='forum.alert.input.reply'/>");//댓글을 입력해주시기 바랍니다.
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
                alert("<spring:message code='forum.alert.mod_success.reply'/>"); // 댓글 수정에 성공하였습니다.
                listForum();
            } else {
                alert("<spring:message code='forum.alert.mod_fail.reply'/>"); // 댓글 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
                listForum();
            }
        }, function(xhr, status, error) {
            alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
        }, true);
    }

    //댓글 삭제
    function delCmnt(rgtrId,cmntSn) {
        var result = confirm("<spring:message code='forum.button.confirm.del' />"); // 정말 삭제하시겠습니까?
        if(!result) { return false; }

        var url = "/forum2/forumLect/Form/delCmnt.do";
        var data = {
            "dscsCmntId" : cmntSn,
            "userId" : "${userId}"
        };

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                alert("<spring:message code='forum.forumBBsManage.alert.del_success'/>"); // 댓글 삭제에 성공하였습니다.
                listForum();
            } else {
                alert("<spring:message code='forum.forumBBsManage.alert.del_fail'/>"); // 댓글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
                listForum();
            }
        }, function(xhr, status, error) {
            alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
        });
    }

    //댓글의 댓글 버튼
    function btnAddCmnt(index,i,atclSn,cmntSn){
        if($("#toggleCmnt"+index+i).hasClass("on")){
            $("#toggleCmnt"+index+i).addClass("off").removeClass("on");
    //		$("#toggleCmnt"+index+i).css("display", "block");
    //		$("#cmntCts"+index+i).find("i").removeClass("down").addClass("up");
            $("#cmntText"+index+i).val('');
            var btn = "";
            btn += "<li id=\"btnCmnt"+index+i+"\">";
            btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></a>"; // 댓글, 등록
            btn += "</li>";
            $("#btnCmnt"+index+i).after(btn);
            $("#btnCmnt"+index+i).remove();
        }else{
            $("#toggleCmnt"+index+i).addClass("on").removeClass("off");
    //		$("#toggleCmnt"+index+i).css("display", "none");
    //		$("#cmntCts"+index+i).find("i").removeClass("up").addClass("down");
            $("#cmntText"+index+i).val('');
            var btn = "";
            btn += "<li id=\"btnCmnt"+index+i+"\">";
            btn += "	<a href=\"javascript:addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"')\" class=\"ui basic grey small button\"><spring:message code='forum.button.reg'/></a>"; // 등록
            btn += "</li>";
            $("#btnCmnt"+index+i).after(btn);
            $("#btnCmnt"+index+i).remove();
        }
    }

    //댓글의 댓글 수정 버튼
    function btnEditCmnt(index,i,level,cmntSn,atclSn){
        var cmntCts = $("#cmntCts"+index+i).text().trim();

        if(!$("#toggleCmnt"+index+i).hasClass("on")){
            var btn = "";
            btn += "<li id=\"editBtnCmnt\">";
            btn += "<a class=\"ui basic grey small button\" onclick=\"editCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"','"+level+"');\" ><spring:message code='forum.button.mod'/></a>"; // 수정
            btn += "</li>";

            $("#toggleCmnt"+index+i).children().find('li#addBtnCmnt').after(btn);
            $("#toggleCmnt"+index+i).children().find('li#addBtnCmnt').remove();
            $("#toggleCmnt"+index+i).children().find('textarea#cmnt'+index+i).val(cmntCts);

            $("#toggleCmnt"+index+i).addClass("on").removeClass("off");
        }else{
            var btn = "";
            btn += "<li id=\"addBtnCmnt\">";
            btn += "<a class=\"ui basic grey small button\" onclick=\"addCmnt('"+atclSn+"','"+cmntSn+"','"+index+"','"+i+"');\" ><spring:message code='forum.button.reg'/></a>"; // 등록
            btn += "</li>";

            $("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').after(btn);
            $("#toggleCmnt"+index+i).children().find('li#editBtnCmnt').remove();

            $("#toggleCmnt"+index+i).addClass("off").removeClass("on");
        }
    }

    //게시글 수정 버튼

    function editAtclBtn(atclSn, rgtrId, postIdx) {
        if(editingPostId !== null && editingPostId !== postIdx) {
            var prevForm = document.getElementById('atclEditForm' + editingPostId);
            var prevBody = document.getElementById('atclBody' + editingPostId);
            if(prevForm) prevForm.style.display = 'none';
            if(prevBody) prevBody.style.display = '';
            editingPostId = null;
        }
        var form = document.getElementById('atclEditForm' + postIdx);
        var body = document.getElementById('atclBody' + postIdx);
        if(!form || !body) return;
        var textarea = document.getElementById('atclEditCts' + postIdx);
        if(textarea) textarea.value = body.innerText;
        body.style.display = 'none';
        form.style.display = 'block';
        if(textarea) textarea.focus();
        editingPostId = postIdx;
    }


    // 간편답글 세팅
    var ctsMsgs = [
        '<spring:message code="forum.button.cts0"/>',
        '<spring:message code="forum.button.cts1"/>',
        '<spring:message code="forum.button.cts2"/>'
    ];
    function setCts(index, i) {
        $("#cmntText"+ i).val(ctsMsgs[index] || "");
    }

    //팀 구성원 보기
    function teamMemberView(teamCtgrCd) {
        $("#teamCtgrCd").val(teamCtgrCd);
        $("#teamMemberForm").attr("target", "teamMemberIfm");
        $("#teamMemberForm").attr("action", "/forum2/forumLect/teamMemberList.do");
        $("#teamMemberForm").submit();
        $('#teamMemberPop').modal('show');
    }

    //목록
    function viewForumList() {
        location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />';
    }

    //토론 수정
    function editForum(forumCd,forumStartDttm) {
        location.href = '<c:url value="/forum2/forumLect/profForumEditView.do" />?dscsId=' + encodeURIComponent(forumCd);
    }

    //토론삭제
    function delForum(forumCd) {
        /*var result = confirm("
        <spring:message code='forum.alert.confirm.delete'/>"); // 정말 토론을 삭제 하시겠습니까?

        if(!result){return false;}

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "forumForm");
        form.attr("action", "/forum2/forumLect/Form/delForum.do");
        form.append($('<input/>', {type: 'hidden', name: 'dscsId', value: forumCd}));
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '
        <c:out value="${dscsForumVO.crsCreCd}" />'}));
        form.appendTo("body");
        form.submit();*/
        // ajaxCall('/forum2/forumLect/profForumDelete.do',{dscsId:'#[valDscsId]'},function(data){if(data.result>0){listPaging(PAGE_INDEX);}else{alert(data.message||'오류가 발생했습니다!');}},function(){alert('오류가 발생했습니다!');});}">삭제</a>

    }

    function downExcel() {
        var excelGrid = {
            colModel: [
                {label: '<spring:message code="common.number.no" />', name: 'lineNo', align: 'right', width: '1000'}, // NO
                {
                    label: '<spring:message code="score.label.crs.cre.nm" />',
                    name:'crsCreNm', 	align:'left', 	width:'7000'}, // 과목명
                {label:'<spring:message code="common.label.decls.no" />', 		name:'declsNo', 	align:'center', width:'2500'}, // 분반
                {label:'<spring:message code="forum.label.user.no" />', 		name:'rgtrId', 		align:'center', width:'4000'}, // 학번
                {label:'<spring:message code="forum.label.user_nm" />', 		name:'userNm', 		align:'left', 	width:'5000'}, // 이름
                {label:'<spring:message code="forum.label.forum.joinCnt" />', 	name:'cts', 		align:'left', 	width:'20000', wrapText: true}, // 참여글
                {label:'<spring:message code="forum.label.length" />', 			name:'ctsLen', 		align:'right', 	width:'2500'}, // 글자수
                {label:'<spring:message code="forum.label.attachFile" />', 		name:'fileNm', 		align:'left', 	width:'5000'}, // 첨부파일
                {label:'<spring:message code="forum.label.reg.dttm" />', 		name:'regDttm', 	align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm'}}, // 작성일시
            ]
        };

        var url  = "/forum2/forumLect/downExcelForumAtclList.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", url);

        // Team 토론시 팀토론 코드로 변경
        var dscsId = "${dscsForumVO.dscsId}";
        if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
            forumCd = $('#team_selected_name').attr('teamSelectedDscsId');
        }

        form.append($('<input/>', {type: 'hidden', name: 'dscsId',		value: forumCd}));
        form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
        form.appendTo("body");
        form.submit();

        $("form[name=excelForm]").remove();
    }

    // =========================================================
    // 상태 변수
    // =========================================================
    var editingPostId = null;
    var editingCommentId = null;

    // =========================================================
    // Delegated event handler (document-level)
    // =========================================================
    document.addEventListener('click', function(e) {

        // 1. 댓글 목록 토글
        var listBtn = e.target.closest('.toggle_commentlist');
        if(listBtn) {
            var comment = listBtn.closest('.Comment');
            if(!comment) return;
            var ul = comment.querySelector('.comment_list > ul');
            if(!ul) return;
            ul.style.display = (ul.style.display === 'none' || !ul.style.display) ? 'block' : 'none';
            return;
        }

        // 2. 상단 댓글 작성폼 토글
        var writeBtn = e.target.closest('.toggle_commentwrite');
        if(writeBtn) {
            var comment = writeBtn.closest('.Comment');
            if(!comment) return;
            var form = comment.querySelector('.comment_list > .recmt_form');
            if(!form) return;
            form.style.display = (form.style.display === 'none' || !form.style.display) ? 'block' : 'none';
            if(form.style.display === 'block') { var ta = form.querySelector('textarea'); if(ta) ta.focus(); }
            return;
        }

        // 3. 대댓글 작성폼 토글 (cmtWri)
        var replyBtn = e.target.closest('.cmtWri');
        if(replyBtn) {
            var li = replyBtn.closest('li');
            if(!li) return;
            var comment = replyBtn.closest('.Comment');
            var replyForm = li.querySelector(':scope > .recmt_form');
            if(!replyForm) return;
            if(comment) {
                comment.querySelectorAll('.comment_list ul li > .recmt_form').forEach(function(f) {
                    if(f !== replyForm) f.style.display = 'none';
                });
            }
            replyForm.style.display = (replyForm.style.display === 'none' || !replyForm.style.display) ? 'block' : 'none';
            if(replyForm.style.display === 'block') { var ta = replyForm.querySelector('textarea'); if(ta) ta.focus(); }
            return;
        }

        // 4-0. 참여글 숨김
        var hidePostBtn = e.target.closest('[data-action="hidePost"]');
        if(hidePostBtn) {
            var atclSn = hidePostBtn.getAttribute('data-atcl-sn');
            if(!confirm("<spring:message code='forum.button.confirm.del' />")) { return; }
            var dscsId = "${dscsForumVO.dscsId}";
            if (${dscsForumVO.byteamDscsUseyn eq 'Y'}) {
                forumCd = $('#team_selected_name').attr('teamSelectedDscsId');
            }
            ajaxCall('/forum2/forumLect/Form/hideAtcl.do',
                { dscsAtclId: atclSn, dscsId: forumCd, userId: "${userId}" },
                function(data) {
                    if(data.result > 0) { listForum(); }
                    else { alert("<spring:message code='forum.common.error'/>"); }
                }, null, true);
            return;
        }

        // 4. 게시글 수정
        var editPostBtn = e.target.closest('[data-action="editPost"]');
        if(editPostBtn) {
            var atclSn = editPostBtn.getAttribute('data-atcl-sn');
            var rgtrId = editPostBtn.getAttribute('data-rgtr-id');
            var postIdx = editPostBtn.getAttribute('data-post-idx');
            editAtclBtn(atclSn, rgtrId, postIdx);
            return;
        }

        // 4-1. atcl_edit_save
        var atclSaveBtn = e.target.closest('.atcl_edit_save');
        if(atclSaveBtn) {
            var atclSn         = atclSaveBtn.getAttribute('data-atcl-sn');
            var forumCd        = atclSaveBtn.getAttribute('data-forum-cd');
            var prosConsTypeCd = atclSaveBtn.getAttribute('data-pros-cons-type-cd');
            var postIdx        = atclSaveBtn.getAttribute('data-post-idx');
            var cts            = (document.getElementById('atclEditCts' + postIdx) || {}).value || '';
            if(!cts.trim()) { alert('<spring:message code="forum.alert.input.forum_reply"/>'); return; }
            ajaxCall('/forum2/forumLect/Form/editAtcl.do',
                { dscsAtclId: atclSn, dscsId: forumCd, oknokGbncd: prosConsTypeCd, atclCts: cts },
                function(data) {
                    if(data.result > 0) { editingPostId = null; listForum(); }
                    else { alert("<spring:message code='forum.common.error'/>"); /* 오류가 발생했습니다! */ }
                }, null, true);
            return;
        }

        // 4-2. atcl_edit_cancel
        var atclCancelBtn = e.target.closest('.atcl_edit_cancel');
        if(atclCancelBtn) {
            var postIdx = atclCancelBtn.getAttribute('data-post-idx');
            var form = document.getElementById('atclEditForm' + postIdx);
            var body = document.getElementById('atclBody' + postIdx);
            if(form) form.style.display = 'none';
            if(body) body.style.display = '';
            editingPostId = null;
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
            var postIdx  = cmtUptBtn.getAttribute('data-post-idx');
            var flatIdx  = cmtUptBtn.getAttribute('data-flat-idx');
            var level    = cmtUptBtn.getAttribute('data-level');
            var ansReqYn = cmtUptBtn.getAttribute('data-ans-req-yn');
            var form = document.getElementById('toggleCmnt' + postIdx + flatIdx);
            if(!form) return;
            // 다른 수정폼 닫기
            if(editingCommentId && editingCommentId !== cmntSn) {
                var prevBtn = document.querySelector('.cmt_create[data-edit-mode="true"]');
                if(prevBtn) {
                    prevBtn.removeAttribute('data-edit-mode');
                    var prevForm = prevBtn.closest('.recmt_form');
                    if(prevForm) { prevForm.style.display = 'none'; prevForm.querySelector('textarea') && (prevForm.querySelector('textarea').value = ''); }
                }
                editingCommentId = null;
            }
            if(editingCommentId === cmntSn) {
                form.style.display = 'none';
                var crtBtn = form.querySelector('.cmt_create');
                if(crtBtn) crtBtn.removeAttribute('data-edit-mode');
                editingCommentId = null;
                return;
            }
            var ctsEl = document.getElementById('cmntContents' + postIdx + flatIdx);
            var textarea = document.getElementById('cmntText' + postIdx + flatIdx);
            if(textarea && ctsEl) textarea.value = ctsEl.textContent;
            form.style.display = 'block';
            if(textarea) textarea.focus();
            editingCommentId = cmntSn;
            var crtBtn = form.querySelector('.cmt_create');
            if(crtBtn) {
                crtBtn.setAttribute('data-edit-mode', 'true');
                crtBtn.setAttribute('data-atcl-sn', atclSn);
                crtBtn.setAttribute('data-cmnt-sn', cmntSn);
                crtBtn.setAttribute('data-post-idx', postIdx);
                crtBtn.setAttribute('data-flat-idx', flatIdx);
            }
            return;
        }

        // 6-5. 댓글 숨김 (cmtHide)
        var cmtHideBtn = e.target.closest('.cmtHide');
        if(cmtHideBtn) {
            var cmntSn = cmtHideBtn.getAttribute('data-cmnt-sn');
            if(!confirm("<spring:message code='forum.button.confirm.del' />")) { return; }
            ajaxCall('/forum2/forumLect/Form/hideCmnt.do',
                { dscsCmntId: cmntSn, userId: "${userId}" },
                function(data) {
                    if(data.result > 0) { listForum(); }
                    else { alert("<spring:message code='forum.common.error'/>"); }
                }, null, true);
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
            var postIdx = addCmntTopBtn.getAttribute('data-post-idx');
            addCmnt(atclSn, '', postIdx);
            return;
        }

        // 9. 대댓글 등록/수정 버튼 (cmt_create)
        var crtBtn = e.target.closest('.cmt_create');
        if(crtBtn) {
            var atclSn  = crtBtn.getAttribute('data-atcl-sn');
            var cmntSn  = crtBtn.getAttribute('data-cmnt-sn');
            var postIdx = crtBtn.getAttribute('data-post-idx');
            var flatIdx = crtBtn.getAttribute('data-flat-idx');
            if(crtBtn.getAttribute('data-edit-mode') === 'true') {
                editCmnt(atclSn, cmntSn, postIdx, flatIdx, 1);
                editingCommentId = null;
                crtBtn.removeAttribute('data-edit-mode');
            } else {
                addCmnt(atclSn, cmntSn, postIdx, flatIdx);
            }
            return;
        }

        // 10. more 메뉴 토글 (.settingBtn)
        var settingBtn = e.target.closest('.settingBtn');
        if(settingBtn) {
            var optionWrap = settingBtn.nextElementSibling;
            document.querySelectorAll('.option-wrap.show').forEach(function(el) {
                if(el !== optionWrap) el.classList.remove('show');
            });
            if(optionWrap) optionWrap.classList.toggle('show');
            return;
        }

        // 11. dropdown 외부 클릭 → 닫기
        if(!e.target.closest('.dropdown')) {
            document.querySelectorAll('.option-wrap.show').forEach(function(el) {
                el.classList.remove('show');
            });
        }
    });
    </script>
</head>
<body class="class colorA">
    <form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
        <input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
    </form>
    <form name="forumListForm" id="forumListForm" action="" method="POST">
        <input type="hidden" id="dscsId" name="dscsId" value="${dscsForumVO.dscsId}" />
        <input type="hidden" id="dscsUnitTycd" name="dscsUnitTycd" value="${dscsForumVO.dscsUnitTycd}" />
        <input type="hidden" id="prosConsForumCfg" name="prosConsForumCfg" value="${dscsForumVO.prosConsForumCfg}" />
        <input type="hidden" id="crsCreCd" name="crsCreCd" value="${dscsForumVO.crsCreCd}" />
        <input type="hidden" id="userId" name="userId" value="${userId}" />
        <input type="hidden" id="teamStdList" name="teamStdList" />
        <input type="hidden" id="teamCd" name="teamCd" value="" />
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
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="forum.label.forum" /><!-- 토론 -->
                            </h2>
                        </div>

                        <div class="board_top">
                            <div class="right-area">
                                <%--<a href="javascript:void(0)" class="btn type2" onclick="editForum('${dscsForumVO.dscsId}','${dscsForumVO.dscsSdttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
                                <a href="javascript:void(0)" class="btn type2" onclick="delForum('${dscsForumVO.dscsId}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>--%>
                                <a href="javascript:void(0)" class="btn type2" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="mw120"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
                                <li class="mw120 select"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
                            </ul>
                        </div>
                        <!-- 토론정보 시작 -->
                        <jsp:include page="/WEB-INF/jsp/forum2/common/forum_info_inc.jsp" />

                        <c:if test="${dscsForumVO.dscsUnitTycd eq 'TEAM'}">
                            <div class="option-content mt20" id="parentDiv">
                            </div>
                        </c:if>

                        <c:if test="${dscsForumVO.prosConsForumCfg eq 'Y'}">
                        <!-- 찬반 토론일 경우 출력 시작  -->
                        <div class="ui segment">
                            <div class="inline field">
                                <div class="ui checkbox read-only info">
                                    <input type="checkbox" checked> <label><spring:message
                                        code='forum.label.pros.cons.forum.config' /></label>
                                    <!-- 찬반 토론을 설정합니다. -->
                                </div>
                            </div>
                            <div class="flex center-text">
                                <span><spring:message code='forum.label.pros.status' /></span>
                                <span>${(dscsForumVO.forumAtclPorsCnt / dscsForumVO.forumAtclCnt)*100}%</span>
                                <!-- 찬성 현황 -->
                                <div id="pros_progressbar" style="height: 30px; width: 90%; "></div>
                            </div>
                            <div class="flex center-text">
                                <span><spring:message code='forum.label.cons.status' /></span>
                                <span> ${(dscsForumVO.forumAtclConsCnt / dscsForumVO.forumAtclCnt)*100}%</span>
                                <!-- 반대 현황 -->
                                <div id="cons_progressbar" style="height: 30px; width: 90%; "></div>
                            </div>
                            <script>
                                $(document).ready(function() {
                                    // 찬성 현황 계산
                                    const pros_progressbar = jQuery("#pros_progressbar");
                                    var value1 = '<c:out value="${(dscsForumVO.forumAtclPorsCnt / dscsForumVO.forumAtclCnt)*100}" />';
                                    pros_progressbar.progressbar({value:Number(value1)});
                                    pros_progressbar.find(".ui-progressbar-value").css({"background":"#CC66CC"});

                                    // 반대 현황 계산
                                    const cons_progressbar = jQuery("#cons_progressbar");
                                    var value2 = '<c:out value="${(dscsForumVO.forumAtclConsCnt / dscsForumVO.forumAtclCnt)*100}" />';
                                    cons_progressbar.progressbar({value:Number(value2)});
                                    cons_progressbar.find(".ui-progressbar-value").css({"background":"#CC66CC"});
                                });
                            </script>
                        </div>
                        <!-- 찬반 토론일 경우 출력 끝  -->
                        </c:if>
                        <!-- 팀별 학습자 리스트 시작 -->
                        <div id="loadTeamStdList"></div>
                        <!-- 팀별 학습자 리스트 끝 -->
                        <!-- 토론정보 끝 -->

                        <!-- 팀토론일경우 학습그룹 정보 표시 시작 -->
                        <div id="teamDscsList">
                            <c:choose>
                                <c:when test="${dscsForumVO.byteamDscsUseyn eq 'Y'}">
                                    <br/><span><spring:message code='forum.label.lrngrp'/><%--학습그룹--%></span>
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
                                        <c:forEach var="item" items="${dscsForumVO.teamDscsList}" varStatus="status">
                                            <tr>
                                                <td>
                                                    <button class="btn basic small team_selected_nm" id="team_selected_nm_${status.index}">${item.teamnm}</button>
                                                </td>
                                                <td>${item.dscsTtl}</td>
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
                        <!-- 팀토론일경우 학습그룹 정보 표시 끝 -->

                        <!-- 토론방 참여 영역:시작 -->
                        <div id="join_write_input_area">
                            <!-- 토론방 <참여글 저장> -->
                            <div class="board_top margin-top-4 padding-2 bcLgrey4">
                            <c:choose>
                                <c:when test="${dscsForumVO.prosConsForumCfg eq 'Y'}">
                                    <h4>
                                        <spring:message code='common.professor'/> <spring:message code='forum.label.feedback'/><span id="team_selected_name" teamSelectedDscsId=""></span>
                                    </h4><!-- 교수 피드백 -->
                                    <div class="right-area">
                                        <a href="javascript:addAtclBtn('A')" class="btn basic small">
                                            <spring:message code='forum.button.save'/><!-- 저장 -->
                                        </a>
                                    </div>
                                    <h4>
                                </c:when>
                                <c:otherwise>
                                    <h4>
                                        <spring:message code='forum.label.forum.bbs'/><span id="team_selected_name" teamSelectedDscsId=""></span>
                                    </h4><!-- 토론방 -->
                                    <div class="right-area">
                                        <a href="javascript:addAtclBtn('A')" class="btn basic small">
                                            <spring:message code='forum.label.forum.joinCnt'/> <spring:message code='forum.button.save'/><!-- 참여글 저장 -->
                                        </a>
                                    </div>
                                    <h4>
                                </c:otherwise>
                            </c:choose>
                            </div>

                            <form id="forumAtclForm" name="forumAtclForm" onsubmit="return false;">
                                <%--찬성반대토론시 파일업로드 없음 --%>
                                <c:if test="${dscsForumVO.prosConsForumCfg eq 'N'}">
                                <input type="hidden" name="uploadFiles"  id="uploadFiles" value="" />
                                <input type="hidden" name="uploadPath"   id="uploadPath"  value="${dscsForumVO.uploadPath}" />
                                <input type="hidden" name="delFileIdStr" id="delFileIdStr"  value="" />
                                </c:if>
                                <div class="ui segment">
                                    <div class="editor-box">
                                        <%-- TODO : 참여글 Editor Box --%>
                                        <label for="atclCts" class="hide">Content</label>
                                        <textarea class='resize-none' id="atclCts" name="atclCts" required="true"></textarea>
                                        <script>
                                            // HTML 에디터
                                            let editor = UiEditor({
                                                targetId: "atclCts",
                                                uploadPath: "${dscsForumVO.uploadPath}",
                                                height: "200px",
                                            });
                                        </script>
                                    </div>
                                    <%--찬성반대토론시 파일업로드 없음 --%>
                                    <c:if test="${dscsForumVO.prosConsForumCfg eq 'N'}">
                                    <div id="uploaderBox" class="mt10">
                                        <!-- TODO : 참여글 File Uplaod -->
                                        <uiex:dextuploader
                                                id="fileUploader"
                                                path="${dscsForumVO.uploadPath}"
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
                                    </c:if>
                                </div>
                            </form>
                            <!-- 토론 참여글 끝 -->

                            <!-- 학생, 이름 검색 -->
                            <div class="board_top">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" placeholder="<spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />" class="w250"
                                           id="searchValue"><!-- 학번, 이름 입력 -->
                                    <button type="button" class="btn basic icon search" aria-label="검색" onclick="listForum(1)"><i class="icon-svg-search"></i></button>
                                </div>
                                <div class="right-area">
                                    <div class="flex-left-auto">
                                        <%--<a href="javascript:void(0)" onclick="downExcel();" class="ui green button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>--%>
                                        <select class="ui dropdown list-num" id="listScale" onchange="listForum();">
                                            <option value="10">10</option>
                                            <option value="20">20</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="ui attached message element">
                                <div id="atclList" class="mt20">
                                    <%-- 동적 렌더링: listForum() → createForumListHTML() --%>
                                </div>
                                <div id="paging" class="paging"></div>
                            </div>
                            <!-- 토론 참여글 끝-->
                        </div>
                        <!-- 토론방 참여 영역:끝 -->
                    </div>
                </div>
            </div>
        </main>
</body>
</html>
