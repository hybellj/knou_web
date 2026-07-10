<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<%-- 학습자 화면에서 찬반토론 여부와 찬반 현황 노출 여부를 서버 렌더링 단계에서 먼저 계산한다. --%>
<c:set var="isProsConsForum" value="${dscsVO.oknokStngyn eq 'Y' and dscsVO.dscsUnitTycd ne 'TEAM'}" />
<c:set var="showProsConsRate" value="${isProsConsForum and dscsVO.oknokrtOyn eq 'Y'}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table, editor,fileuploader"/>
    </jsp:include>
    <script type="text/javascript">
    var EPARAM = '<c:out value="${encParams}" />';
    var PAGE_INDEX = '<c:out value="${dscsVO.pageIndex}" />';
    var LIST_SCALE = '<c:out value="${dscsVO.listScale}" />';
    var dialog;
    var prosConsSummary = {
        totalCount: Number("${empty dscsVO.dscsAtclCnt ? 0 : dscsVO.dscsAtclCnt}"),
        prosCount: Number("${empty dscsVO.dscsAtclPorsCnt ? 0 : dscsVO.dscsAtclPorsCnt}"),
        consCount: Number("${empty dscsVO.dscsAtclConsCnt ? 0 : dscsVO.dscsAtclConsCnt}")
    };

    // 학습자 화면 이동 시 encParams를 우선 유지하고, 없을 때만 과목 ID를 fallback으로 전달한다.
    function buildLearnerUrl(path, dscsId) {
        var url = path;
        if (dscsId) {
            url += "?dscsId=" + encodeURIComponent(dscsId);
        }
        if (EPARAM) {
            url += (url.indexOf("?") > -1 ? "&" : "?") + "encParams=" + encodeURIComponent(EPARAM);
        } else if ("${dscsVO.sbjctId}" != "") {
            url += (url.indexOf("?") > -1 ? "&" : "?") + "sbjctId=" + encodeURIComponent("${dscsVO.sbjctId}");
        }
        return url;
    }

    // 참여 현황 화면으로 이동한다.
    function moveToPtcp() {
        location.href = buildLearnerUrl("/forum2/forumHome/Form/stdntPtcpStatusView.do", "${dscsVO.dscsId}");
    }

    var editor;
    // 찬반토론에서 본인 의견 등록 수와 기존 찬반값을 저장해 신규 작성/수정 가능 여부를 판단한다.
    var myAtclStatus = { count: 0, type: "", loaded: false, failed: false };
    // 렌더링된 게시글 원본 데이터를 보관해 찬반토론 수정 시 상단 작성 폼으로 다시 주입한다.
    var atclItemMap = {};
    // 일반/팀토론의 게시글 수정폼과 댓글 수정폼 활성 상태를 각각 관리한다.
    var editingPostId = null;
    var editingCommentId = null;

    // 찬반토론은 팀토론과 동시에 적용하지 않는다. 팀토론에서는 일반/팀 게시글 흐름을 사용한다.
    function _isProsConsForum() {
        return $("#oknokStngyn").val() == "Y" && $("#dscsUnitTycd").val() != "TEAM";
    }

    // 목록 표시 건수 변경
    function changeListScale(scale) {
        LIST_SCALE = getSelectedListScale(scale);
        listForum(1);
    }

    // 목록 표시 건수 값을 조회한다.
    function getSelectedListScale(scale) {
        if (scale) {
            return scale;
        }

        var $listScale = $("#listScale");
        if ($listScale.length == 0) {
            $listScale = $('[id^="listScale"]').eq(0);
        }

        return $listScale.val() || LIST_SCALE || 10;
    }

    $(document).ready(function() {
        PAGE_INDEX = PAGE_INDEX || 1;
        LIST_SCALE = LIST_SCALE || getSelectedListScale();

        renderProsConsSummary();

        editor = UiEditor({
            targetId: "atclCts",
            uploadPath: "${dscsVO.uploadPath}",
            height: "200px"
        });

        if ("${dscsVO.dscsUnitTycd}" == "TEAM") {
            // 팀토론은 참여할 팀을 먼저 선택한 뒤 목록과 작성 영역을 활성화한다.
            $("#join_write_input_area").hide();
            $("#selectedTeamName").text("");
            resetJoinPanel();
            resetProsConsEditorState();
            renderEmptyAtclGuide("<spring:message code='forum.label.join'/>"); // 참여
        } else {
            loadJoinPanel();
            listForum(1);
        }

        $("#searchValue").on("keydown", function(e) {
            if (e.keyCode == 13) {
                e.preventDefault();
                listForum(1);
            }
        });
    });

    // 현재 화면에서 조회/저장 대상이 되는 토론 ID를 반환한다. 팀토론은 선택된 팀 토론 ID가 기준이다.
    function activeDscsId() {
        if ("${dscsVO.dscsUnitTycd}" == "TEAM") {
            return $("#selectedTeamDscsId").val();
        }
        return $("#dscsId").val();
    }

    // 현재 선택된 팀 ID를 반환한다.
    function activeTeamId() {
        return $("#teamId").val();
    }

    // 저장 파라미터에서 현재 토론/팀 식별자를 제거해 중복 전송을 방지한다.
    function removeActiveTargetParams(params) {
        return $.grep(params, function(item) {
            return item.name != "dscsId" && item.name != "teamId";
        });
    }

    // 학습자는 팀토론에서 본인 팀일 때만 게시글/댓글 작성 및 수정이 가능하다.
    function isActiveTeamWritable() {
        if ("${dscsVO.dscsUnitTycd}" != "TEAM") {
            return true;
        }
        return activeTeamId() != "" && activeTeamId() == "${learnerTeamId}";
    }

    // 항목 작성자가 현재 로그인 사용자와 같은지 확인한다.
    function isOwnItem(item) {
        return item && item.rgtrId == "${userId}";
    }

    // 삭제 또는 숨김 처리되지 않은 활성 항목인지 확인한다.
    function isActiveItem(item) {
        return item && (item.delyn || "N") == "N";
    }

    // 학습자가 수정 가능한 본인 활성 항목인지 확인한다.
    function canEditOwnItem(item) {
        return isActiveTeamWritable() && isOwnItem(item) && isActiveItem(item);
    }

    // 작성자 공개 설정에 맞춰 화면에 표시할 작성자명을 만든다.
    function displayWriter(item, showStdntNo) {
        // 찬반토론 작성자 비공개 설정이면 본인 글을 제외한 작성자 정보를 마스킹한다.
        if (_isProsConsForum() && "${dscsVO.oknokRgtrOyn}" != "Y" && !isOwnItem(item)) {
            return "■■■(●●●●)";
        }
        var writerName = item.usernm || item.rgtrnm || item.stdntNo || "";
        var writerNo = showStdntNo ? (item.stdntNo || "") : "";
        if (writerName && writerNo) {
            return escapeHtml(writerName) + "(" + escapeHtml(writerNo) + ")";
        }
        return escapeHtml(writerName || writerNo);
    }

    // 쓰기 권한이 없을 때 공통 안내 메시지를 표시한다.
    function showReadOnlyMessage() {
        UiComm.showMessage("<spring:message code='forum.common.error'/>", "info"); // 오류가 발생했습니다!
    }

    // 현재 선택된 팀 기준으로 작성 영역 노출 여부를 동기화한다.
    function syncWritableArea() {
        var writable = isActiveTeamWritable();
        $("#forumAtclForm").toggle(writable);
    }

    // 팀토론에서 선택한 팀의 게시글 목록과 작성 영역을 활성화한다.
    function joinTeamDscsBtn(dscsId, teamId, teamNm) {
        $("#selectedTeamDscsId").val(dscsId);
        $("#teamId").val(teamId);
        $("#selectedTeamName").text(" : " + teamNm);
        $("#selectedTeamName").attr("teamSelectedDscsId", dscsId);
        $("#join_write_input_area").show();
        syncWritableArea();
        loadJoinPanel();
        listForum(1);
    }

    // 참여 현황 영역을 초기화한다. 팀토론 미선택 또는 조회 실패 시 기본 안내 상태로 되돌린다.
    function resetJoinPanel() {
        $("#myJoinStatus").text("<spring:message code='forum.label.not.join'/>"); // 미참여
        $("#myJoinAtclCnt").text("0");
        $("#myJoinCmntCnt").text("0");
        $("#joinUserCnt").text("0");
        $("#joinUserList").html("<div class='no_content'><span><spring:message code='forum.common.empty'/></span></div>"); // 등록된 내용이 없습니다.
    }

    // 게시글 목록 영역에 안내 메시지를 표시하고 페이징을 비운다.
    function renderEmptyAtclGuide(message) {
        $("#atclList").html("<div class='no_content'><span>" + message + "</span></div>");
        $("#comment_paging").empty();
    }

    // 찬반현황 영역이 노출되는 경우 현재 집계값으로 렌더링한다.
    function renderProsConsSummary() {
        if(!_isProsConsForum() || $("#prosConsSummaryArea").length == 0) {
            return;
        }
        $("#prosConsSummaryArea").html(createProsConsSummaryHTML(prosConsSummary));
    }

    // 찬반현황을 현재 목록 기준으로 갱신한다.
    function updateProsConsSummary(list) {
        if(!_isProsConsForum() || $("#prosConsSummaryArea").length == 0) {
            return;
        }
        prosConsSummary = buildProsConsSummary(list);
        renderProsConsSummary();
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

    // 찬반현황 HTML을 생성한다.
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

    // 찬반토론 작성 폼 상태를 초기화한다. 일반/팀토론에서는 별도 제어 없이 작성 가능 상태로 둔다.
    function resetProsConsEditorState() {
        myAtclStatus.count = 0;
        myAtclStatus.type = "";
        myAtclStatus.loaded = !_isProsConsForum();
        myAtclStatus.failed = false;
        if (_isProsConsForum()) {
            $("#oknokGbncd").val("OK");
            $("#atclStatus").val("A");
            $("#editDscsAtclId").val("");
            $("#editOknokGbncd").val("");
            $("#forumAtclForm .atcl_edit_cancel_btn").hide();
            $("input[name='atclProsCons']").prop("checked", false);
            $("#atclTypeP").prop("checked", true);
            setProsConsInputEnabled(false);
        }
    }

    // 찬반 radio와 저장 버튼의 활성 상태를 함께 제어한다.
    function setProsConsInputEnabled(enabled) {
        $("input[name='atclProsCons']").prop("disabled", !enabled);
        $("#forumAtclForm .atcl_save_btn").prop("disabled", !enabled);
    }

    // 찬반토론 저장 버튼 활성 상태만 제어한다.
    function setProsConsSaveEnabled(enabled) {
        $("#forumAtclForm .atcl_save_btn").prop("disabled", !enabled);
    }

    // 참여 현황, 참여자 목록, 찬반 본인 작성 상태를 함께 조회한다.
    function loadJoinPanel() {
        var dscsId = activeDscsId();
        if (!dscsId) {
            resetJoinPanel();
            resetProsConsEditorState();
            return;
        }
        loadMyJoinStatus(dscsId);
        loadJoinUserList(dscsId);
        loadMyAtclStatus(dscsId);
    }

    // AS-IS 찬반토론처럼 본인 의견 등록 여부를 먼저 확인해 radio/save 활성 상태를 결정한다.
    function loadMyAtclStatus(dscsId) {
        if (!_isProsConsForum()) {
            myAtclStatus.loaded = true;
            myAtclStatus.failed = false;
            return;
        }
        myAtclStatus.loaded = false;
        myAtclStatus.failed = false;
        setProsConsInputEnabled(false);
        ajaxCall("/forum2/forumHome/myAtclStatus.do", {
            "dscsId": dscsId,
            "sbjctId": $("#sbjctId").val()
        }, function(data) {
            if (data.result <= 0) {
                myAtclStatus.count = 0;
                myAtclStatus.type = "";
                myAtclStatus.loaded = false;
                myAtclStatus.failed = true;
                setProsConsInputEnabled(false);
                UiComm.showMessage(data.message || "<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
                return;
            }
            var item = data.returnVO || {};
            myAtclStatus.count = toInt(item.dscsAtclCnt);
            myAtclStatus.type = item.oknokGbncd || "";
            myAtclStatus.loaded = true;
            myAtclStatus.failed = false;
            syncProsConsEditorState();
        }, function() {
            myAtclStatus.count = 0;
            myAtclStatus.type = "";
            myAtclStatus.loaded = false;
            myAtclStatus.failed = true;
            setProsConsInputEnabled(false);
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 복수 의견 등록 가능 여부에 따라 신규 작성 radio/save를 활성화한다.
    function syncProsConsEditorState() {
        if (!_isProsConsForum()) {
            return;
        }
        var selectedType = myAtclStatus.type || "OK";
        $("#atclStatus").val("A");
        $("#editDscsAtclId").val("");
        $("#editOknokGbncd").val("");
        $("#forumAtclForm .atcl_edit_cancel_btn").hide();
        setProsConsRadioValue(selectedType);
        var hasMyAtcl = myAtclStatus.count > 0;
        var allowMultiAtcl = "${dscsVO.mltOpnnRegyn}" == "Y";
        var canWriteNewAtcl = !hasMyAtcl || allowMultiAtcl;
        $("input[name='atclProsCons']").prop("disabled", !canWriteNewAtcl);
        setProsConsSaveEnabled(canWriteNewAtcl);
    }

    // 선택한 찬성/반대 값을 저장용 hidden 필드에 반영한다.
    function checkedProsCons(value) {
        if (value != "OK" && value != "NOTOK") {
            return;
        }
        $("#oknokGbncd").val(value);
    }

    // 찬반토론 작성 폼의 현재 모드(A: 등록, E: 수정)를 반환한다.
    function getProsConsAtclStatus() {
        return String($("#atclStatus").val() || "A");
    }

    // 찬반토론 radio와 저장용 hidden 필드를 같은 값으로 맞춘다.
    function setProsConsRadioValue(value) {
        var oknokGbncd = value == "NOTOK" ? "NOTOK" : "OK";
        $("#oknokGbncd").val(oknokGbncd);
        $("input[name='atclProsCons']").prop("checked", false);
        if (oknokGbncd == "NOTOK") {
            $("#atclTypeC").prop("checked", true);
        } else {
            $("#atclTypeP").prop("checked", true);
        }
    }

    // 에디터 API 사용 가능 여부에 따라 본문 HTML을 에디터 또는 textarea에 주입한다.
    function setAtclEditorHTML(value) {
        if (editor && typeof editor.openHTML == "function") {
            editor.openHTML(value || "");
        } else {
            $("#atclCts").val(value || "");
        }
    }

    // 저장 직전 찬반토론 전용 조건을 한 번 더 검증한다. 최종 권한 검증은 서버에서도 수행한다.
    function canSubmitProsConsAtcl() {
        if (!_isProsConsForum()) {
            return true;
        }
        if (!myAtclStatus.loaded) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", myAtclStatus.failed ? "error" : "info"); // 오류가 발생했습니다!
            return false;
        }
        if (getProsConsAtclStatus() == "E" && "${dscsVO.oknokModyn}" != "Y") {
            setProsConsRadioValue($("#editOknokGbncd").val() || "OK");
        }
        var oknokGbncd = $("#oknokGbncd").val();
        if (oknokGbncd != "OK" && oknokGbncd != "NOTOK") {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            return false;
        }
        if (getProsConsAtclStatus() == "E") {
            if (!$("#editDscsAtclId").val()) {
                UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
                return false;
            }
            return true;
        }
        if (myAtclStatus.count > 0 && "${dscsVO.mltOpnnRegyn}" != "Y") {
            UiComm.showMessage("<spring:message code='forum.alert.only.mod.forum.atcl'/>", "info"); // 이미 토론글을 작성하셨습니다. 수정만 가능합니다.
            return false;
        }
        return true;
    }

    // 현재 학습자의 토론 참여 현황을 조회한다.
    function loadMyJoinStatus(dscsId) {
        ajaxCall("/forum2/forumHome/myJoinStatus.do", {
            "dscsId": dscsId,
            "sbjctId": $("#sbjctId").val(),
            "teamId": activeTeamId()
        }, function(data) {
            var item = data.returnVO || {};
            $("#myJoinStatus").text(item.joinStatus || "<spring:message code='forum.label.not.join'/>"); // 미참여
            $("#myJoinAtclCnt").text(toInt(item.dscsMyAtclCnt != null ? item.dscsMyAtclCnt : item.actlCnt));
            $("#myJoinCmntCnt").text(toInt(item.dscsMyCmntCnt != null ? item.dscsMyCmntCnt : item.cmntCnt));
        }, function() {
            resetJoinPanel();
        }, true);
    }

    // 현재 토론에 참여한 학습자 목록을 조회한다.
    function loadJoinUserList(dscsId) {
        ajaxCall("/forum2/forumHome/dscsJoinUserList.do", {
            "dscsId": dscsId,
            "sbjctId": $("#sbjctId").val(),
            "teamId": activeTeamId(),
            "listScale": 1000,
            "pageIndex": 1
        }, function(data) {
            var list = data.returnList || [];
            $("#joinUserCnt").text(toInt(list.length));
            $("#joinUserList").html(createJoinUserListHTML(list));
        }, function() {
            $("#joinUserCnt").text("0");
            $("#joinUserList").html("<div class='no_content'><span><spring:message code='forum.common.empty'/></span></div>"); // 등록된 내용이 없습니다.
        }, true);
    }

    // 게시글 목록 조회. 찬반토론은 section 구성을 위해 전체 목록을 한 번에 가져오고 화면 페이징을 숨긴다.
    function listForum(page) {
        loadDscsAtclList(page);
    }

    // 토론 게시글 목록을 조회하고 렌더링한다.
    function loadDscsAtclList(page) {
        var isProsConsForum = _isProsConsForum();
        PAGE_INDEX = page || PAGE_INDEX || 1;
        LIST_SCALE = getSelectedListScale();
        var dscsId = activeDscsId();
        if (!dscsId) {
            renderEmptyAtclGuide("<spring:message code='forum.common.empty'/>"); // 등록된 내용이 없습니다.
            resetJoinPanel();
            return;
        }

        var url = "/forum2/forumHome/Form/forumBbsViewList.do";
        var data = {
            "pageIndex": isProsConsForum ? 1 : PAGE_INDEX,
            "listScale": isProsConsForum ? 9999 : LIST_SCALE,
            "searchValue": isProsConsForum ? "" : $("#searchValue").val(),
            "dscsId": dscsId,
            "sbjctId": $("#sbjctId").val(),
            "dscsUnitTycd": "${dscsVO.dscsUnitTycd}",
            "upDscsId": "${dscsVO.dscsUnitTycd}" == "TEAM" ? "${dscsVO.dscsId}" : ""
        };

        ajaxCall(url, data, function(data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                if (isProsConsForum) {
                    updateProsConsSummary(returnList);
                }
                $("#atclList").html(createDscsAtclListHTML(returnList));
                if (isProsConsForum) {
                    $("#comment_paging").empty().hide();
                } else {
                    $("#comment_paging").show();
                    UiComm.showPaging("comment_paging", {
                        pageInfo: data.pageInfo,
                        pageFunc: listForum
                    });
                }
            } else {
                UiComm.showMessage(data.message || "<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 참여자 목록 테이블 HTML을 생성한다.
    function createJoinUserListHTML(list) {
        if (!list.length) {
            return "<div class='no_content'><span><spring:message code='forum.common.empty'/></span></div>"; // 등록된 내용이 없습니다.
        }
        var html = [];
        html.push("<table class='table-type2'><thead><tr>");
        html.push("<th><spring:message code='common.name'/></th><th><spring:message code='forum.label.user.no'/></th><th><spring:message code='forum.label.team.ttl'/></th>"); // 이름 / 부주제
        html.push(
            "<th><spring:message code='forum.label.join.status'/></th>" // 참여상태
            + "<th><spring:message code='forum.label.forum.bbsCnt'/></th>" // 토론 글수
            + "<th><spring:message code='forum.label.forum.commCnt'/></th>" // 댓글수
        );
        html.push("</tr></thead><tbody>");
        $.each(list, function(_, item) {
            html.push(
                "<tr>"
                + "<td>" + escapeHtml(item.userNm || "") + "</td>"
                + "<td>" + escapeHtml(item.stdntNo || "") + "</td>"
                + "<td>" + escapeHtml(item.teamNm || "-") + "</td>"
                + "<td>" + escapeHtml(item.joinStatus || "") + "</td>"
                + "<td>" + toInt(item.actlCnt) + "</td>"
                + "<td>" + toInt(item.cmntCnt) + "</td>"
                + "</tr>"
            );
        });
        html.push("</tbody></table>");
        return html.join("");
    }

    // 렌더링 함수는 하단의 최종 렌더링 함수로 다시 정의된다. 실제 화면 구성 기준은 하단 블록이다.
    // 댓글 계층 렌더링 공통 함수는 최종 렌더링 블록에서도 동일하게 사용한다.
    var CMNT_REPLY_MAX_DEPTH = 5;

    // 댓글 버튼을 교수자와 동일한 순서(수정, 삭제, 댓글)로 구성한다.
    function createCmntActionHTML(item, postIndex, flatIndex, depth) {
        var actionHtml = [];
        if (canEditOwnItem(item)) {
            actionHtml.push(
                "<button type='button' class='item cmtUpt' onclick=\"showEditCmnt('"
                + safeValue(item.dscsAtclId) + "', '"
                + safeValue(item.dscsCmntId) + "', '"
                + safeValue(postIndex) + "', '"
                + safeValue(flatIndex) + "', '"
                + safeValue(item.rspnsReqyn || "N")
                + "')\"><spring:message code='forum.button.mod'/></button>" // 수정
            );
            actionHtml.push(
                "<button type='button' class='item cmtDel' onclick=\"delCmnt('"
                + item.dscsCmntId + "')\"><spring:message code='forum.button.del'/></button>" // ??젣
            );
        }
        if (depth < CMNT_REPLY_MAX_DEPTH && isActiveTeamWritable() && isActiveItem(item)) {
            actionHtml.push(
                "<button type='button' class='item cmtWri' onclick=\"toggleReplyForm('"
                + safeValue(postIndex) + "', '"
                + safeValue(flatIndex)
                + "')\"><spring:message code='forum.button.cmnt'/></button>" // 댓글
            );
        }
        return createActionDropdownHTML(actionHtml);
    }

    // 댓글 1건을 생성하고 자식 댓글은 부모 li 내부에 계층형으로 배치한다.
    function createCmntItemHTML(node, atclId, postIndex, depth) {
        var item = node.item;
        var flatIndex = node.flatIndex;
        var childrenHtml = "";
        if (node.children && node.children.length) {
            childrenHtml = $.map(node.children, function(child) {
                return createCmntItemHTML(child, atclId, postIndex, depth + 1);
            }).join("");
        }
        return [
            "<li class='re_comment'>",
            "    <div class='item'>",
            "        <div class='cmt_info'>",
            createCmntMetaHTML(item),
            "        </div>",
            createCmntActionHTML(item, postIndex, flatIndex, depth),
            renderCmntBody(item),
            "    </div>",
            createReplyFormHTML(item, atclId, postIndex, flatIndex, depth),
            (childrenHtml ? "<ul class='re_comment_ul'>" + childrenHtml + "</ul>" : ""),
            "</li>"
        ].join("");
    }

    // flat 댓글 목록을 upCmntId 기준 tree로 변환하여 재귀 렌더링한다.
    function createCmntListHTML(list, atclId, postIndex) {
        var nodeMap = {};
        var roots = [];
        $.each(list || [], function(index, item) {
            nodeMap[item.dscsCmntId] = {
                item: item,
                flatIndex: index,
                children: []
            };
        });
        $.each(list || [], function(_, item) {
            var node = nodeMap[item.dscsCmntId];
            var parentNode = item.upCmntId ? nodeMap[item.upCmntId] : null;
            if (parentNode) {
                parentNode.children.push(node);
            } else if (node) {
                roots.push(node);
            }
        });
        return $.map(roots, function(node) {
            return createCmntItemHTML(node, atclId, postIndex, 1);
        }).join("");
    }

    // 게시글 본문 표시 HTML을 생성한다.
    function renderAtclBody(item) {
        if (item.delyn == "Y") {
            /*삭제된 메시지입니다.*/
            //return "<span class='ui red label'><spring:message code='forum.label.deleted.message'/></span>"; // 삭제된 메시지입니다.
            //기획시 공백으로 변경함.
            return "";
        }
        if (item.delyn == "H") {
            /*숨겨진 메시지입니다.*/
            //return "<span class='ui red label'><spring:message code='forum.label.hidden.message'/></span>"; // 숨겨진 메시지입니다.
            //기획시 공백으로 변경함.
            return "";
        }
        return item.atclCts || "";
    }

    // 댓글 본문 표시 HTML을 생성한다.
    function renderCmntBody(item) {
        return "<span class='comment' id='cmntBody" + item.dscsCmntId + "'>"
            + renderCmntBodyContent(item)
            + "</span>";
    }

    // 댓글 상태별 본문 내용을 생성한다.
    function renderCmntBodyContent(item) {
        if (item.delyn == "Y") {
            /*return "<span class='ui red label'><spring:message code='forum.label.deleted.message'/></span>"; // 삭제된 메시지입니다.*/
            //기획시 공백으로 변경함.
            return "";
        }
        if (item.delyn == "H") {
            /*return "<span class='ui red label'><spring:message code='forum.label.hidden.message'/></span>"; // 숨겨진 메시지입니다.*/
            //기획시 공백으로 변경함.
            return "";
        }
        var prefix = ((item.rspnsReqyn || "N") == "Y") ? "<span class='label mr10 fcOlive'><spring:message code='forum.checkbox.label.request'/></span>" : ""; // 답변을 요청합니다.
        return prefix + escapeHtml(item.cmntCts || "");
    }

    // 게시글 저장 진입점. 일반/팀토론은 첨부파일 업로드 후 저장하고, 찬반토론은 본인 의견 상태를 먼저 확인한다.
    function addAtclBtn() {
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        if (!canSubmitProsConsAtcl()) {
            return;
        }
        if (!_isProsConsForum()) {
            var dx = dx5.get("fileUploader");
            if (dx && dx.availUpload()) {
                dx.startUpload();
                return;
            }
        }
        addAtcl();
    }

    // 업로드 완료 후 파일 검증을 수행하고 게시글 저장을 이어간다.
    function finishUpload() {
        var dx = dx5.get("fileUploader");
        ajaxCall("/common/uploadFileCheck.do", {
            "uploadFiles": dx.getUploadFiles(),
            "uploadPath": dx.getUploadPath()
        }, function(data) {
            if (data.result > 0) {
                $("#uploadFiles").val(dx.getUploadFiles());
                addAtcl();
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        }, function() {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        });
    }

    // 게시글 등록 또는 찬반토론 수정 요청을 서버로 전송한다.
    function addAtcl() {
        var dscsId = activeDscsId();
        if (!dscsId) { return; }
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        if (!canSubmitProsConsAtcl()) {
            return;
        }
        if (_isProsConsForum() && getProsConsAtclStatus() == "E") {
            editProsConsAtcl();
            return;
        }
        var param = removeActiveTargetParams($("#forumListForm").serializeArray()).concat($("#forumAtclForm").serializeArray());
        DscsParam.set(param, "dscsId", dscsId);
        DscsParam.set(param, "teamId", activeTeamId());
        DscsParam.set(param, "dscsAtclTycd", $("#dscsUnitTycd").val() + "_" + $("#oknokStngyn").val());
        ajaxCall("/forum2/forumHome/Form/addAtcl.do", param, function(data) {
            if (data.result > 0) {
                editor.openHTML("");
                $("#uploadFiles").val("");
                UiComm.showMessage("<spring:message code='forum.alert.add.forum.atcl_success'/>", "success"); // 토론 게시글 등록에 성공하였습니다.
                loadJoinPanel();
                listForum(1);
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.add.forum.atcl_fail'/>"), "error"); // 토론 게시글에 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 찬반토론 수정은 게시글 내부 편집폼이 아니라 상단 작성 폼을 수정 모드로 전환해 처리한다.
    function editProsConsAtcl() {
        ajaxCall("/forum2/forumHome/Form/editAtcl.do", {
            "dscsAtclId": $("#editDscsAtclId").val(),
            "dscsId": activeDscsId(),
            "teamId": activeTeamId(),
            "oknokGbncd": $("#oknokGbncd").val(),
            "atclCts": $("#atclCts").val()
        }, function(data) {
            if (data.result > 0) {
                setAtclEditorHTML("");
                resetProsConsEditorState();
                UiComm.showMessage("<spring:message code='forum.alert.edit.forum.atcl_success'/>", "success"); // 토론 게시글 수정에 성공하였습니다.
                loadJoinPanel();
                listForum(1);
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.edit.forum.atcl_fail'/>"), "error"); // 토론 게시글에 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 게시글 삭제 요청을 확인 후 서버로 전송한다.
    function delAtcl(atclId) {
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        UiComm.showMessage("<spring:message code='forum.button.confirm.del' />", "confirm").then(function(result) { // 정말 삭제하시겠습니까?
            if (!result) { return; }
            ajaxCall("/forum2/forumHome/Form/delAtcl.do", {
                "dscsAtclId": atclId,
                "dscsId": activeDscsId(),
                "teamId": activeTeamId()
            }, function(data) {
                if (data.result > 0) {
                    loadJoinPanel();
                    listForum(1);
                } else {
                    UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.del.forum.atcl_fail'/>"), "error"); // 게시글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
                }
            }, function() {
                UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            }, true);
        });
    }

    // 댓글 등록 시 답변요청 옵션은 토론 설정(cmntRspnsReqyn)이 켜진 경우에만 함께 전달한다.
    function addCmnt(atclId, upCmntId, postIndex, flatIndex) {
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        var isReply = flatIndex !== null && flatIndex !== undefined && flatIndex !== "";
        var targetId = isReply ? "cmntText" + postIndex + flatIndex : "newComment" + postIndex;
        var text = $("#" + targetId).val();
        var rspnsReqyn = "N";
        if ("${dscsVO.cmntRspnsReqyn}" == "Y") {
            var checkboxId = isReply ? "#ansReqYn" + postIndex + flatIndex : "#rspnsReqynMain" + postIndex;
            rspnsReqyn = $(checkboxId).is(":checked") ? "Y" : "N";
        }
        if (!$.trim(text)) {
            UiComm.showMessage("<spring:message code='forum.alert.input.reply'/>", "info"); // 댓글을 입력해주시기 바랍니다.
            return;
        }
        ajaxCall("/forum2/forumHome/Form/addCmnt.do", {
            "dscsAtclId": atclId,
            "upCmntId": upCmntId,
            "cmntCts": text,
            "rspnsReqyn": rspnsReqyn,
            "dscsId": activeDscsId(),
            "sbjctId": $("#sbjctId").val(),
            "teamId": activeTeamId()
        }, function(data) {
            if (data.result > 0) {
                loadJoinPanel();
                listForum(1);
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.reg_fail.reply'/>"), "error"); // 댓글 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 댓글 수정 요청을 서버로 전송한다.
    function editCmnt(atclId, cmntId, postIndex, flatIndex) {
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        var text = $("#cmntText" + postIndex + flatIndex).val();
        var rspnsReqyn = "N";
        if ("${dscsVO.cmntRspnsReqyn}" == "Y") {
            rspnsReqyn = $("#ansReqYn" + postIndex + flatIndex).is(":checked") ? "Y" : "N";
        }
        if (!$.trim(text)) {
            UiComm.showMessage("<spring:message code='forum.alert.input.reply'/>", "info"); // 댓글을 입력해주시기 바랍니다.
            return;
        }
        ajaxCall("/forum2/forumHome/Form/editCmnt.do", {
            "dscsCmntId": cmntId,
            "cmntCts": text,
            "rspnsReqyn": rspnsReqyn
        }, function(data) {
            if (data.result > 0) {
                loadJoinPanel();
                listForum(1);
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.alert.mod_fail.reply'/>"), "error"); // 댓글 수정에 실패하였습니다. 다시 시도해주시기 바랍니다.
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 댓글 삭제 요청을 확인 후 서버로 전송한다.
    function delCmnt(cmntId) {
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        UiComm.showMessage("<spring:message code='forum.button.confirm.del' />", "confirm").then(function(result) { // 정말 삭제하시겠습니까?
            if (!result) { return; }
            ajaxCall("/forum2/forumHome/Form/delCmnt.do", {"dscsCmntId": cmntId}, function(data) {
                if (data.result > 0) {
                    loadJoinPanel();
                    listForum(1);
                } else {
                    UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.forumBBsManage.alert.del_fail'/>"), "error"); // 댓글 삭제에 실패하였습니다. 다시 시도해주시기 바랍니다.
                }
            }, function() {
                UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            }, true);
        });
    }

    // 게시글 수정 UI를 연다. 찬반토론은 상단 작성 폼을 사용한다.
    function showEditAtcl(index) {
        if (_isProsConsForum()) {
            showProsConsEditAtcl(index);
            return;
        }
        var formId = "atclEdit" + index;
        var $form = $("#" + formId);
        if (!$form.length) {
            return;
        }
        if (editingPostId == String(index) && $form.is(":visible")) {
            closeAllActionForms("");
            return;
        }
        closeAllActionForms(formId);
        var item = atclItemMap[index] || {};
        $("#atclEditCts" + index).val(item.atclCts || "");
        $("#atclBody" + index).hide();
        $form.show();
        $("#atclEditCts" + index).focus();
        editingPostId = String(index);
    }

    // 찬반토론 수정은 AS-IS와 동일하게 상단 작성 영역(atclCts)을 재사용한다.
    function showProsConsEditAtcl(index) {
        var item = atclItemMap[index];
        if (!item || !canEditOwnItem(item)) {
            showReadOnlyMessage();
            return;
        }
        if (!myAtclStatus.loaded) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", myAtclStatus.failed ? "error" : "info"); // 오류가 발생했습니다!
            return;
        }
        closeAllActionForms("prosConsAtclEdit");
        $("#atclStatus").val("E");
        $("#editDscsAtclId").val(item.dscsAtclId || "");
        $("#editOknokGbncd").val(item.oknokGbncd || "OK");
        setProsConsRadioValue(item.oknokGbncd || "OK");
        $("input[name='atclProsCons']").prop("disabled", "${dscsVO.oknokModyn}" != "Y");
        setProsConsSaveEnabled(true);
        $("#forumAtclForm .atcl_edit_cancel_btn").show();
        setAtclEditorHTML(item.atclCts || "");
        $("html, body").animate({scrollTop: $("#join_write_input_area").offset().top - 20}, 200);
    }

    // 찬반토론 상단 수정 모드를 취소하고 신규 작성 상태로 되돌린다.
    function cancelProsConsEditAtcl() {
        $("#atclStatus").val("A");
        $("#editDscsAtclId").val("");
        $("#editOknokGbncd").val("");
        $("#forumAtclForm .atcl_edit_cancel_btn").hide();
        setAtclEditorHTML("");
        syncProsConsEditorState();
    }

    // 일반/팀토론 게시글 내부 수정 폼을 닫는다.
    function cancelEditAtcl(index) {
        if (_isProsConsForum()) {
            cancelProsConsEditAtcl();
            return;
        }
        closeAllActionForms("");
    }
    // 댓글 수정은 대댓글 입력 폼을 수정 모드로 전환해 처리한다.
    function showEditCmnt(atclId, cmntId, postIndex, flatIndex, rspnsReqyn) {
        var formId = "toggleCmnt" + postIndex + flatIndex;
        var $form = $("#" + formId);
        if (!$form.length) {
            return;
        }
        var editMode = $form.find(".cmt_create[data-edit-mode='true']").length > 0;
        if (editingCommentId == String(cmntId) && $form.is(":visible") && editMode) {
            closeAllActionForms("");
            return;
        }
        closeAllActionForms(formId);
        var cmntItem = findCmntItem(postIndex, cmntId);
        var cmntCts = cmntItem ? (cmntItem.cmntCts || "") : $("#cmntBody" + cmntId).text();
        $("#cmntText" + postIndex + flatIndex).val(cmntCts).focus();
        $("#ansReqYn" + postIndex + flatIndex).prop("checked", (rspnsReqyn || "N") == "Y");
        $form.closest("ul.re_comment_ul").removeClass("dpNone").show();
        $form.show();
        setCmntFormEditMode($form[0], atclId, cmntId, postIndex, flatIndex);
        editingCommentId = String(cmntId);
    }

    // 댓글 수정 폼을 닫고 작성 모드로 되돌린다.
    function cancelEditCmnt() { closeAllActionForms(""); }

    // 대댓글 입력 폼을 작성 모드로 토글한다.
    function toggleReplyForm(postIndex, flatIndex) {
        var formId = "toggleCmnt" + postIndex + flatIndex;
        var $form = $("#" + formId);
        if (!$form.length) {
            return;
        }
        var editMode = $form.find(".cmt_create[data-edit-mode='true']").length > 0;
        var willOpen = !$form.is(":visible") || editMode;
        setCmntFormCreateMode($form[0]);
        closeAllActionForms(willOpen ? formId : "");
        if (willOpen) {
            $form.closest("ul.re_comment_ul").removeClass("dpNone").show();
            $form.show();
            $("#cmntText" + postIndex + flatIndex).val("").focus();
        }
    }

    // 현재 게시글 목록 캐시에서 댓글 원문을 찾는다.
    function findCmntItem(postIndex, cmntId) {
        var atclItem = atclItemMap[postIndex];
        var list = atclItem ? (atclItem.cmntList || []) : [];
        for (var i = 0; i < list.length; i++) {
            if (String(list[i].dscsCmntId) == String(cmntId)) {
                return list[i];
            }
        }
        return null;
    }
    // 댓글 목록을 열거나 닫는다.
    function toggleCommentList(postIndex) {
        var $list = $("#commentList" + postIndex);
        var willOpen = $list.hasClass("dpNone") || !$list.is(":visible");
        if (willOpen) {
            $list.removeClass("dpNone").show();
        } else {
            $list.addClass("dpNone").hide();
            closeAllActionForms("");
        }
    }
    // 게시글 하단 댓글 입력 폼을 토글한다.
    function toggleCommentWriteForm(postIndex) { toggleSingleCommentForm("commentWrite" + postIndex, "newComment" + postIndex, postIndex); }

    // 일반/팀토론 게시글 수정 내용을 서버로 저장한다.
    function saveEditAtcl(index, atclId, oknokGbncd) {
        if (!isActiveTeamWritable()) {
            showReadOnlyMessage();
            return;
        }
        ajaxCall("/forum2/forumHome/Form/editAtcl.do", {
            "dscsAtclId": atclId,
            "dscsId": activeDscsId(),
            "teamId": activeTeamId(),
            "oknokGbncd": oknokGbncd,
            "atclCts": $("#atclEditCts" + index).val()
        }, function(data) {
            if (data.result > 0) {
                loadJoinPanel();
                listForum(1);
            } else {
                UiComm.showMessage(dscsResultMessage(data, "<spring:message code='forum.common.error'/>"), "error"); // 오류가 발생했습니다!
            }
        }, function() {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        }, true);
    }

    // 간편답글 문구는 댓글/답글/댓글수정 textarea에 공통으로 삽입한다.
    var ctsMsgs = [
        '<spring:message code="forum.button.cts0"/>', // 수고했어요.
        '<spring:message code="forum.button.cts1"/>', // 고생하셨어요.
        '<spring:message code="forum.button.cts2"/>' // 감사합니다.
    ];

    // 선택한 간편답글 문구를 대상 textarea에 입력한다.
    function setCts(index, targetId) {
        $("#" + targetId).val(ctsMsgs[index] || "").focus();
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

    // 사용자 사진 경로를 화면에서 사용할 수 있는 URL로 변환한다.
    function imageSrc(phtFile) {
        if (!phtFile) {
            return "";
        }
        var contextPath = "${pageContext.request.contextPath}";
        if (/^(data:|https?:\/\/)/i.test(phtFile) || (contextPath && phtFile.indexOf(contextPath) == 0)) {
            return phtFile;
        }
        if (phtFile.indexOf("/") == 0) {
            return contextPath + phtFile;
        }
        return contextPath + "/" + phtFile;
    }

    // 아래 렌더링 함수들이 학습자 화면의 최종 게시글/댓글 UI 구성 기준이다.
    function userImgHtml(phtFile) {
        var src = imageSrc(phtFile);
        if (src) {
            return "<div class='user'><div class='user_img'><img src='" + src + "' aria-hidden='true' alt='<spring:message code='forum.common.user.img'/>'></div></div>"; // 학습자이미지
        }
        return "<div class='user'><span class='user_img'></span></div>";
    }

    // JavaScript 문자열에 안전하게 넣을 수 있도록 값을 이스케이프한다.
    function escapeJs(value) {
        return String(value || "").replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\r?\n/g, " ");
    }

    // 첨부파일 다운로드 링크 HTML을 생성한다.
    function createFileLinksHTML(fileList) {
        var html = [];
        $.each(fileList || [], function(_, item) {
            var encDownParam = item ? escapeJs(item.encDownParam || "") : "";
            var filenm = item ? escapeHtml(item.filenm || item.fileNm || item.orgnlFileNm || "") : "";
            if (!encDownParam || !filenm) {
                return true;
            }
            html.push("<span class='fileName'><a href='#0' onclick=\"UiFileDownloader('" + encDownParam + "');return false;\">" + filenm + "</a></span>");
        });
        return html.join("");
    }

    // 댓글 작성자, 작성일, 글자수 정보를 구성한다.
    function createCmntMetaHTML(item) {
        var html = [];
        var date = formatDttm(item.regDttm || item.modDttm);
        html.push(userImgHtml(item.phtFile));
        html.push("<strong class='name'>" + displayWriter(item, false) + "</strong>");
        if (date) {
            html.push("<span class='date'>" + date + "</span>");
        }
        return html.join("");
    }

    // 학습자 액션 버튼은 본인 글 수정/삭제 후 댓글 순서로 노출한다.
    // Ajax 렌더링 게시글/댓글의 관리 버튼을 공통 드롭다운 구조로 감싼다.
    function createActionDropdownHTML(actionHtml) {
        if (!actionHtml || !actionHtml.length) {
            return "";
        }
        return [
            "<span class='btn_right cmtBtnGroup'>",
            "    <div class='dropdown'>",
            "        <button type='button' class='btn basic icon set settingBtn' aria-label='menu'>",
            "            <i class='xi-ellipsis-v'></i>",
            "        </button>",
            "        <div class='optionWrap option-wrap'>",
            actionHtml.join(""),
            "        </div>",
            "    </div>",
            "</span>"
        ].join("");
    }

    function createAtclActionHTML(item, key) {
        var html = [];
        if (canEditOwnItem(item)) {
            html.push("<button type='button' class='item cmtUpt' onclick=\"showEditAtcl('" + key + "')\"><spring:message code='forum.button.mod'/></button>"); // 수정
            html.push("<button type='button' class='item cmtDel' onclick=\"delAtcl('" + item.dscsAtclId + "')\"><spring:message code='forum.button.del'/></button>"); // 삭제
        }
        if (isActiveTeamWritable() && isActiveItem(item)) {
            html.push("<button type='button' class='item cmtWri' onclick=\"toggleCommentWriteForm('" + key + "')\"><spring:message code='forum.button.cmnt'/></button>"); // 댓글
        }
        return createActionDropdownHTML(html);
    }

    // 게시글 하단의 글자 수, 댓글 수, 첨부파일, 댓글 토글 영역을 구성한다.
    function createAtclDetailHTML(item, key, totalCmntCount, detailCmntCount) {
        var commentToggle = totalCmntCount > 0
            ? [
                "<button type='button' class='toggle_commentlist mlAuto' id='cmntOpen",
                key,
                "' onclick=\"toggleCommentList('",
                key,
                "')\"><i class='icon-svg-message'></i>",
                totalCmntCount,
                "<spring:message code='forum.label.cnt.forum.cmnt'/>", // 개의 댓글이 있습니다.
                "<i class='icon-svg-arrow-down'></i></button>"
            ].join("")
            : "";
        var detailParts = [
            "<span class='textNum'><i class='xi-paper-o'></i>" + toInt(item.atclCtsLen) + "<spring:message code='forum.label.word'/></span>"
        ];
        if (detailCmntCount > 0) {
            detailParts.push("<span class='comNum'><i class='xi-speech-o'></i>" + detailCmntCount + "</span>");
        }
        detailParts.push(createFileLinksHTML(item.fileList));
        return [
            "<div class='cmt_detail'>",
            "    <div>" + detailParts.join(" ") + "</div>",
            commentToggle,
            "</div>"
        ].join("");
    }

    // 일반/팀토론만 게시글 내부 수정 폼을 사용한다. 찬반토론은 상단 작성 폼으로 수정한다.
    function createAtclEditFormHTML(item, key) {
        if (_isProsConsForum()) {
            return "";
        }
        if (!canEditOwnItem(item)) {
            return "";
        }
        return [
            "<div class='recmt_form atcl_edit_form' id='atclEdit" + key + "' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'><spring:message code='forum.button.mod'/></legend>", // 수정
            "        <div class='memo'>",
            "            <textarea class='resize-none' rows='3' id='atclEditCts" + key + "'>",
            escapeHtml(item.atclCts || ""),
            "</textarea>",
            "            <div class='bottom_btn'><div class='right-area'>",
            "                <button type='button' class='btn type2' onclick=\"saveEditAtcl('",
            key + "', '" + item.dscsAtclId + "', '" + safeValue(item.oknokGbncd),
            "')\"><spring:message code='forum.button.mod'/></button>", // 수정
            "                <button type='button' class='btn basic' onclick=\"cancelEditAtcl('" + key + "')\"><spring:message code='forum.button.cancel'/></button>", // 취소
            "            </div></div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join("");
    }

    // 댓글 작성 폼은 쓰기 가능한 팀/토론에서만 렌더링하고, 답변요청 옵션은 설정값에 따라 노출한다.
    function createCmntWriteFormHTML(atclId, key) {
        if (!isActiveTeamWritable()) {
            return "";
        }
        var checkbox = "";
        if ("${dscsVO.cmntRspnsReqyn}" == "Y") {
            checkbox = [
                "<span class='custom-input'><input type='checkbox' id='rspnsReqynMain",
                key,
                "' value='Y'><label for='rspnsReqynMain",
                key,
                "'><span class='small'><spring:message code='forum.checkbox.label.request'/></span></label></span>" // 답변을 요청합니다.
            ].join("");
        }
        return [
            "<div class='recmt_form mt20' id='commentWrite" + key + "' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></legend>", // 댓글 / 등록
            "        <div class='memo'>",
            createSimpleAnswerHTML("newComment" + key),
            "            <textarea class='resize-none' rows='3' cols='76' id='newComment", key, "' placeholder='<spring:message code='forum.label.input.cmnt'/>'></textarea>", // 댓글을 입력하세요
            "            <div class='bottom_btn'>",
            "                " + checkbox,
            "                <div class='right-area'><button type='button' class='btn type2' onclick=\"addCmnt('", atclId + "', '', '" + key,
            "', '')\"><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></button></div>", // 댓글 / 등록
            "            </div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join("");
    }

    // 대댓글 입력 폼 HTML을 생성한다.
    function createReplyFormHTML(item, atclId, postIndex, flatIndex, depth) {
        if (!isActiveTeamWritable() || !isActiveItem(item)) {
            return "";
        }
        if (depth >= CMNT_REPLY_MAX_DEPTH && !canEditOwnItem(item)) {
            return "";
        }
        var replyKey = "" + postIndex + flatIndex;
        var checkbox = "";
        if ("${dscsVO.cmntRspnsReqyn}" == "Y") {
            checkbox = [
                "<span class='custom-input'><input type='checkbox' id='ansReqYn",
                replyKey,
                "' value='Y'><label for='ansReqYn",
                replyKey,
                "'><span class='small'><spring:message code='forum.checkbox.label.request'/></span></label></span>" // 답변을 요청합니다.
            ].join("");
        }
        return [
            "<div class='recmt_form' id='toggleCmnt" + replyKey + "' style='display:none;'>",
            "    <fieldset>",
            "        <legend class='sr_only'><spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></legend>", // 댓글 / 등록
            "        <div class='memo'>",
            createSimpleAnswerHTML("cmntText" + replyKey),
            "            <textarea class='resize-none' rows='3' cols='76' id='cmntText", replyKey, "' placeholder='<spring:message code='forum.label.input.cmnt'/>'></textarea>", // 댓글을 입력하세요
            "            <div class='bottom_btn'>",
            "                " + checkbox,
            "                <div class='right-area'><button type='button' class='btn type2 cmt_create'",
            " data-atcl-id='" + atclId + "'",
            " data-cmnt-id='" + item.dscsCmntId + "'",
            " data-post-idx='" + postIndex + "'",
            " data-flat-idx='" + flatIndex + "'",
            " onclick=\"addCmnt('" + atclId + "', '" + item.dscsCmntId + "', '" + postIndex + "', '" + flatIndex + "')\">",
            "<spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/></button></div>", // 댓글 / 등록
            "            </div>",
            "        </div>",
            "    </fieldset>",
            "</div>"
        ].join("");
    }

    // 게시글 1개 li 블록 생성
    function createAtclItemHTML(item, key, isPros) {
        atclItemMap[key] = item;
        var cmntList = item.cmntList || [];
        var totalCmntCount = toInt(item.cmntCount != null ? item.cmntCount : cmntList.length);
        var viewerCmntCount = toInt(item.viewerCmntCount);
        var regDttm = formatDttm(item.regDttm || item.modDttm);
        return [
            "<li>",
            "    <div class='item'>",
            "        <div class='cmt_info'>",
            userImgHtml(item.phtFile),
            "<strong class='name'>",
            displayWriter(item, true),
            "</strong>",
            (regDttm ? "<span class='date'>" + regDttm + "</span>" : ""),
            "</div>",
            createAtclActionHTML(item, key),
            "        <span class='comment' id='atclBody" + key + "'>" + renderAtclBody(item) + "</span>",
            createAtclDetailHTML(item, key, totalCmntCount, viewerCmntCount),
            "    </div>",
            createAtclEditFormHTML(item, key),
            (isActiveItem(item) ? createCmntWriteFormHTML(item.dscsAtclId, key) : ""),
            "    <ul class='re_comment_ul dpNone' id='commentList" + key + "' style='margin-bottom:0;'>",
            createCmntListHTML(cmntList, item.dscsAtclId, key),
            "    </ul>",
            "</li>"
        ].join("");
    }

    // 게시글 목록을 공통 댓글 리스트 마크업으로 감싼다.
    function wrapDscsListHTML(innerHtml, extraClass, includePaging) {
        return [
            "<div class='Comment mt10" + (extraClass ? " " + extraClass : "") + "'>",
            "    <div class='comment_list'>",
            "        <ul>",
            innerHtml,
            "        </ul>",
            "    </div>",
            includePaging ? "    <div id='comment_paging' class='bd0'></div>" : "",
            "</div>"
        ].join("");
    }

    // 찬반토론 section별 검색어는 찬성/반대 영역에만 적용한다.
    function getProsConsSectionKeyword(sectionKey) {
        var $input = $("#prosConsSearch_" + sectionKey);
        return $input.length ? $.trim($input.val()) : "";
    }

    // 찬반토론 section 검색어가 작성자명 또는 ID에 매칭되는지 확인한다.
    function matchProsConsSectionKeyword(item, keyword) {
        if (!keyword) {
            return true;
        }
        var normalizedKeyword = keyword.toLowerCase();
        return [
            item.stdntNo,
            item.usernm,
            item.rgtrnm
        ].some(function(value) {
            return String(value || "").toLowerCase().indexOf(normalizedKeyword) > -1;
        });
    }

    // 찬성/반대 section 검색 UI HTML을 생성한다.
    function createProsConsSearchHTML(sectionKey, keyword) {
        return [
            "<div class='search-typeC'>",
            "    <input class='form-control' type='text' id='prosConsSearch_" + sectionKey + "' value='" + escapeHtml(keyword) + "'",
            "        placeholder='<spring:message code='forum.label.user.no' />, ", // 학번
            "<spring:message code='forum.label.user_nm' /> ", // 이름
            "<spring:message code='forum.label.input' />'>", // 입력
            "    <button type='button' class='btn basic icon search' aria-label='search' onclick='listForum(1)'><i class='icon-svg-search'></i></button>",
            "</div>"
        ].join("");
    }

    // 일반/팀토론은 단일 목록으로, 찬반토론은 찬성/반대/교수피드백 section으로 분리한다.
    function createDscsAtclListHTML(list) {
        atclItemMap = {};
        if (!list.length) {
            return [
                "<div class='flex-container'><div class='cont-none'><span>",
                "<spring:message code='forum.common.empty'/>", // 등록된 내용이 없습니다.
                "</span></div></div>"
            ].join("");
        }
        if (_isProsConsForum()) {
            return createProsConsListHTML(list);
        }
        var html = [];
        $.each(list, function(index, item) {
            html.push(createAtclItemHTML(item, index, false));
        });
        return wrapDscsListHTML(html.join(""), "", true);
    }

    // OK, NOTOK, 그 외 값을 기준으로 찬성의견/반대의견/FeedBack 영역을 구성한다.
    function createProsConsListHTML(list) {
        var grouped = {ok: [], notok: [], fb: []};
        $.each(list, function(index, item) {
            if (item.oknokGbncd === "OK") {
                grouped.ok.push({item: item, index: index});
            } else if (item.oknokGbncd === "NOTOK") {
                grouped.notok.push({item: item, index: index});
            } else {
                grouped.fb.push({item: item, index: index});
            }
        });
        return buildProsConsSection(
                "<spring:message code='forum.label.pros.opinion'/>", // 찬성 의견
                "ok", grouped.ok, true, getProsConsSectionKeyword("ok"), true
            )
            + buildProsConsSection(
                "<spring:message code='forum.label.cons.opinion'/>", // 반대 의견
                "notok", grouped.notok, true, getProsConsSectionKeyword("notok"), true
            )
            + buildProsConsSection("FeedBack", "fb", grouped.fb, false, "", false);
    }

    // 찬성/반대 section은 검색과 건수 표시를 사용하고, 교수피드백 section은 목록만 표시한다.
    function buildProsConsSection(title, sectionKey, list, showCount, keyword, useSearch) {
        var filteredList = keyword
            ? $.grep(list, function(entry) { return matchProsConsSectionKeyword(entry.item, keyword); })
            : list;
        var header = showCount
            ? title + " ["
                + "<spring:message code='common.page.total'/> " // 총
                + list.length
                + "<spring:message code='message.person'/>]" // 명
            : title;
        var html = [];
        html.push("<div class='pros-cons-section pros-cons-section--" + sectionKey + " mt30'>");
        html.push("<div class='flex justify-content-between width-100per mb20'>");
        html.push("<h4 class='sub-title'>" + header + "</h4>");
        if (useSearch) {
            html.push(createProsConsSearchHTML(sectionKey, keyword));
        }
        html.push("</div>");
        if (!filteredList.length) {
            html.push(wrapDscsListHTML(
                "<li><div class='flex-container'><div class='cont-none'><span>"
                + "<spring:message code='forum.common.empty'/>" // 등록된 내용이 없습니다.
                + "</span></div></div></li>"
            ));
        } else {
            var listHtml = [];
            $.each(filteredList, function(_, entry) {
                listHtml.push(createAtclItemHTML(entry.item, sectionKey + "_" + entry.index, sectionKey == "ok"));
            });
            html.push(wrapDscsListHTML(listHtml.join("")));
        }
        html.push("</div>");
        return html.join("");
    }

    // 대댓글 폼을 댓글 등록 모드로 복구한다.
    function setCmntFormCreateMode(form) {
        if (!form) {
            return;
        }
        var $form = $(form);
        var $btn = $form.find(".cmt_create").eq(0);
        if (!$btn.length) {
            return;
        }
        var atclId = $btn.attr("data-atcl-id") || "";
        var cmntId = $btn.attr("data-cmnt-id") || "";
        var postIndex = $btn.attr("data-post-idx") || "";
        var flatIndex = $btn.attr("data-flat-idx") || "";
        $form.find(".right-area").html([
            "<button type='button' class='btn type2 cmt_create'",
            " data-atcl-id='" + atclId + "'",
            " data-cmnt-id='" + cmntId + "'",
            " data-post-idx='" + postIndex + "'",
            " data-flat-idx='" + flatIndex + "'",
            " onclick=\"addCmnt('" + atclId + "', '" + cmntId + "', '" + postIndex + "', '" + flatIndex + "')\">",
            "<spring:message code='forum.button.cmnt'/> <spring:message code='forum.button.reg'/>", // 댓글 / 등록
            "</button>"
        ].join(""));
    }

    // 대댓글 폼을 댓글 수정 모드로 전환한다.
    function setCmntFormEditMode(form, atclId, cmntId, postIndex, flatIndex) {
        if (!form) {
            return;
        }
        $(form).find(".right-area").html([
            "<button type='button' class='btn type2 cmt_create' data-edit-mode='true'",
            " data-atcl-id='" + atclId + "'",
            " data-cmnt-id='" + cmntId + "'",
            " data-post-idx='" + postIndex + "'",
            " data-flat-idx='" + flatIndex + "'",
            " onclick=\"editCmnt('" + atclId + "', '" + cmntId + "', '" + postIndex + "', '" + flatIndex + "')\">",
            "<spring:message code='forum.button.mod'/>", // 수정
            "</button>",
            "<button type='button' class='btn basic cmt_edit_cancel' onclick='cancelEditCmnt()'>",
            "<spring:message code='forum.button.cancel'/>", // 취소
            "</button>"
        ].join(""));
    }

    // 댓글/답글 입력폼과 게시글 수정폼은 초기화 범위가 다르므로 분리해서 정리한다.
    function closeAllActionForms(exceptId) {
        var keepId = exceptId || "";
        $(".recmt_form").each(function() {
            if (!$(this).hasClass("atcl_edit_form") && this.id != keepId) {
                setCmntFormCreateMode(this);
                $(this).hide();
                $(this).find("textarea").val("");
                $(this).find("input[type='checkbox']").prop("checked", false);
            }
        });
        $(".atcl_edit_form").each(function() {
            var postIndex = this.id.replace("atclEdit", "");
            if (this.id != keepId) {
                $(this).hide();
                $("#atclBody" + postIndex).show();
            }
        });
        $("span.comment[id^='cmntBody']").show();
        if (keepId != "prosConsAtclEdit" && _isProsConsForum() && getProsConsAtclStatus() == "E") {
            cancelProsConsEditAtcl();
        }
        if (keepId.indexOf("atclEdit") != 0) {
            editingPostId = null;
        }
        if (keepId.indexOf("toggleCmnt") != 0) {
            editingCommentId = null;
        }
    }

    // Ajax로 생성된 관리 드롭다운은 공통 gnb.js 초기 바인딩 대상이 아니므로 위임 방식으로 처리한다.
    function closeDscsActionDropdowns(exceptMenu) {
        document.querySelectorAll('.cmtBtnGroup .optionWrap.show').forEach(function(menu) {
            if (menu !== exceptMenu) {
                menu.classList.remove('show');
            }
        });
    }

    // 공통 gnb.js의 document click 닫기 이벤트보다 먼저 Ajax 목록 드롭다운을 처리한다.
    document.addEventListener('click', function(e) {
        var settingBtn = e.target.closest('.cmtBtnGroup .settingBtn');
        if (!settingBtn) {
            return;
        }

        var dropdown = settingBtn.closest('.dropdown');
        var menu = dropdown ? dropdown.querySelector('.optionWrap') : null;
        if (menu) {
            var willOpen = !menu.classList.contains('show');
            closeDscsActionDropdowns(menu);
            menu.classList.toggle('show', willOpen);
        }

        e.preventDefault();
        e.stopImmediatePropagation();
    }, true);

    document.addEventListener('click', function(e) {
        if (e.target.closest('.optionWrap .item')) {
            closeDscsActionDropdowns();
        } else if (!e.target.closest('.optionWrap')) {
            closeDscsActionDropdowns();
        }
    });

    // 기존 호출부 호환용 래퍼.
    function closeCommentInputs(exceptId) {
        closeAllActionForms(exceptId);
    }

    // 답글/수정 입력창을 열 때 기존 입력창을 닫아 교수자 화면과 동일하게 단일 입력 상태를 유지한다.
    function toggleSingleCommentForm(formId, focusId, postIndex) {
        var $form = $("#" + formId);
        if (!$form.length) {
            return;
        }
        var willOpen = !$form.is(":visible");
        closeCommentInputs(willOpen ? formId : "");
        if (willOpen) {
            if (postIndex != null && postIndex !== "") {
                $("#commentList" + postIndex).removeClass("dpNone").show();
            }
            $form.closest("ul.re_comment_ul").removeClass("dpNone").show();
            $form.show();
            $("#" + focusId).focus();
        } else {
            $form.hide();
        }
    }

    // 댓글 목록 영역을 열거나 닫는다.
    function toggleCommentList(postIndex) {
        var $list = $("#commentList" + postIndex);
        var willOpen = $list.hasClass("dpNone") || !$list.is(":visible");
        if (willOpen) {
            $list.removeClass("dpNone").show();
        } else {
            $list.addClass("dpNone").hide();
            closeCommentInputs("");
        }
    }
    // 게시글 댓글 작성 폼을 단일 입력 상태로 토글한다.
    function toggleCommentWriteForm(postIndex) {
        toggleSingleCommentForm("commentWrite" + postIndex, "newComment" + postIndex, postIndex);
    }

    // 팀원 보기 팝업을 연다.
    function teamMemberView(teamId) {
        if (!teamId) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            return;
        }
        var url = "/forum2/forumHome/teamMemberList.do";
        url += "?teamId=" + encodeURIComponent(teamId);
        url += "&encParams=" + encodeURIComponent(EPARAM);
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.label.team.member.view' />",/*팀 구성원 보기*/ // 팀 구성원 보기
            width: 500,
            height: 500,
            url: url,
            // autoresize: true
        });
    }

    // 토론 목록 화면으로 이동한다.
    function viewDscsList() { location.href = buildLearnerUrl("/forum2/forumHome/Form/forumList.do", ""); }
    // 일시 값을 화면용 날짜/시간 문자열로 변환한다.
    function formatDttm(value) { return value ? UiComm.formatDate(value, "datetime") : ""; }
    // 숫자 값이 없을 때 0으로 변환한다.
    function toInt(value) { return value == null ? 0 : Number(value); }
    // 작은따옴표가 포함된 값을 안전한 문자열로 변환한다.
    function safeValue(value) { return value == null ? "" : String(value).replace(/'/g, "\\'"); }
    // HTML 출력용 문자열을 이스케이프한다.
    function escapeHtml(value) { return String(value || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\"/g, "&quot;").replace(/'/g, "&#39;"); }
    </script>
</head>
<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>

            <div id="content" class="content-wrap common">
                <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

                <div class="class_sub">
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code="forum.label.forum"/></h2> <%-- 토론 --%>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="mw120"><a href="javascript:void(0)" onclick="moveToPtcp()"><spring:message code='forum.label.forum.info.ptcp' /></a></li><%--토론정보 및 참여--%>
                                <li class="mw120 select"><a href="javascript:void(0)"><spring:message code='forum.label.forum.bbs'/></a></li> <%-- 토론방 --%>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code='forum.label.forum.bbs'/></h3> <%-- 토론방 --%>
                            <div class="right-area">
                                <c:if test="${dscsVO.dscsUnitTycd eq 'TEAM' and not empty learnerTeamId}">
                                    <button type="button" class="btn type2" onclick="teamMemberView('${learnerTeamId}')"><spring:message code='forum.button.team.member'/></button> <%-- 팀 구성원 --%>
                                </c:if>
                                <button type="button" class="btn type2" onclick="viewDscsList()"><spring:message code='forum.label.list'/></button> <%-- 목록 --%>
                            </div>
                        </div>

                        <jsp:include page="/WEB-INF/jsp/forum2/common/dscs_info_inc.jsp" />

                        <%-- 목록/저장 호출에서 공통으로 사용하는 토론 식별자와 To-Be 찬반 설정값을 보관한다. --%>
                        <form id="teamMemberForm" method="post"><input type="hidden" name="teamCtgrCd" id="teamCtgrCd"></form>
                        <form id="forumListForm" method="post">
                            <input type="hidden" id="dscsId" name="dscsId" value="${dscsVO.dscsId}">
                            <input type="hidden" id="selectedTeamDscsId" value="">
                            <input type="hidden" id="dscsUnitTycd" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}">
                            <input type="hidden" id="oknokStngyn" name="oknokStngyn" value="${empty dscsVO.oknokStngyn ? 'N' : dscsVO.oknokStngyn}">
                            <input type="hidden" id="sbjctId" name="sbjctId" value="${dscsVO.sbjctId}">
                            <input type="hidden" id="teamId" name="teamId" value="">
                        </form>

                        <%-- 찬반 비율 공개 설정(oknokrtOyn)이 켜진 경우에만 학습자에게 현황을 노출한다. --%>
                        <c:if test="${showProsConsRate}">
                            <div id="prosConsSummaryArea"></div>
                        </c:if>

                        <%-- 팀토론은 팀별 참여 목록을 먼저 보여주고, 선택한 팀 기준으로 게시글 목록과 작성 영역을 전환한다. --%>
                        <c:if test="${dscsVO.dscsUnitTycd eq 'TEAM'}">
                            <div id="teamDscsList" class="mt20">
                                <c:choose>
                                    <c:when test="${not empty dscsVO.teamDscsList}">
                                        <div class="board_top margin-top-2">
                                            <h4 class="board-title"><spring:message code='forum.label.lrngrp'/></h4> <%-- 학습그룹 --%>
                                        </div>
                                        <table class="table-type2">
                                            <colgroup>
                                                <col style="width:12%">
                                                <col>
                                                <col style="width:12%">
                                                <col style="width:10%">
                                                <col style="width:10%">
                                                <col style="width:10%">
                                                <col style="width:12%">
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <th><spring:message code='forum.label.forum.bbs'/></th> <%-- 토론방 --%>
                                                <th><spring:message code='forum.label.team.ttl'/></th> <%-- 부주제 --%>
                                                <th><spring:message code='forum.label.team.leader'/></th> <%-- 팀장 --%>
                                                <th><spring:message code='forum.label.team.member'/></th> <%-- 팀원 --%>
                                                <th><spring:message code='forum.label.forum.joinCnt'/></th> <%-- 참여글 --%>
                                                <th><spring:message code='forum.button.cmnt'/></th> <%-- 댓글 --%>
                                                <th><spring:message code='forum.label.join'/></th> <%-- 참여 --%>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="item" items="${dscsVO.teamDscsList}">
                                                <tr>
                                                    <td>${item.teamnm}</td>
                                                    <td><c:out value="${empty item.dscsTtl ? '-' : item.dscsTtl}" /></td>
                                                    <td>${item.leaderNm}</td>
                                                    <td>${item.teamMbrCnt}</td>
                                                    <td>${item.atclCnt}</td>
                                                    <td>${item.cmntCnt}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.teamId eq learnerTeamId or item.teamDscsOyn eq 'Y'}">
                                                                <button type="button" class="btn basic small" onclick="joinTeamDscsBtn('${item.dscsId}', '${item.teamId}', '${fn:escapeXml(item.teamnm)}')"><spring:message code='forum.label.join'/></button> <%-- 참여 --%>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="ui segment"><spring:message code='forum.label.use.n'/></div> <%-- 사용 안함 --%>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <%-- 게시글 작성 영역: 찬반토론은 전용 radio/상단 에디터, 일반/팀토론은 첨부파일 포함 기본 폼을 사용한다. --%>
                        <div id="join_write_input_area" class="mt20">
                            <c:choose>
                                <c:when test="${isProsConsForum}">
                                    <%-- 찬반토론 radio는 myAtclStatus, mltOpnnRegyn, oknokModyn 조건에 따라 스크립트에서 활성화한다. --%>
                                    <div class="proCon_wrap">
                                        <h4 class="sub-title"><spring:message code='forum.label.forum.bbs'/><span id="selectedTeamName"></span></h4> <%-- 토론방 --%>
                                        <form id="forumAtclForm" onsubmit="return false;">
                                            <input type="hidden" id="oknokGbncd" name="oknokGbncd" value="OK">
                                            <input type="hidden" id="atclStatus" value="A">
                                            <input type="hidden" id="editDscsAtclId" value="">
                                            <input type="hidden" id="editOknokGbncd" value="">
                                            <div class="table-wrap">
                                                <table class="table-type5">
                                                    <colgroup>
                                                        <col class="width-10em" />
                                                        <col />
                                                    </colgroup>
                                                    <tbody>
                                                    <tr>
                                                        <th class="text-center"><spring:message code='forum.label.pros.cons.opinion'/></th> <%-- 찬반 의견 --%>
                                                        <td>
                                                            <div class="form-inline mb10">
                                                                <span class="custom-input">
                                                                    <input type="radio" name="atclProsCons" id="atclTypeP" value="OK" checked disabled="disabled" onchange="checkedProsCons('OK')">
                                                                    <label for="atclTypeP"><spring:message code='forum.label.pros'/></label> <%-- 찬성 --%>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" name="atclProsCons" id="atclTypeC" value="NOTOK" disabled="disabled" onchange="checkedProsCons('NOTOK')">
                                                                    <label for="atclTypeC"><spring:message code='forum.label.cons'/></label> <%-- 반대 --%>
                                                                </span>
                                                            </div>
                                                            <div class="editor-box">
                                                                <label for="atclCts" class="hide">Content</label>
                                                                <textarea id="atclCts" name="atclCts" class="resize-none"></textarea>
                                                            </div>
                                                            <div class="bottom_btn">
                                                                <div class="right-area">
                                                                    <button type="button" class="btn type2 atcl_save_btn" disabled="disabled" onclick="addAtclBtn()"><spring:message code='forum.button.save'/></button> <%-- 저장 --%>
                                                                    <button type="button" class="btn basic atcl_edit_cancel_btn" style="display:none;" onclick="cancelProsConsEditAtcl()"><spring:message code='forum.button.cancel'/></button> <%-- 취소 --%>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <%-- 일반/팀토론 작성 폼은 첨부파일 업로드 후 게시글을 저장한다. --%>
                                    <div class="options_wrap mt0">
                                        <ul class="accordion">
                                            <li class="active">
                                                <div class="title-wrap">
                                                    <a class="title" href="javascript:void(0);">
                                                        <div class="lecture_tit">
                                                            <strong><spring:message code='forum.label.forum.bbs'/><span id="selectedTeamName"></span></strong> <%-- 토론방 --%>
                                                        </div>
                                                        <i class="arrow xi-angle-down"></i>
                                                    </a>
                                                </div>
                                                <div class="cont">
                                                    <form id="forumAtclForm" onsubmit="return false;">
                                                        <input type="hidden" name="uploadFiles" id="uploadFiles" value="">
                                                        <input type="hidden" name="uploadPath" id="uploadPath" value="${dscsVO.uploadPath}">
                                                        <div class="table-wrap">
                                                            <table class="table-type5">
                                                                <colgroup>
                                                                    <col class="width-15per">
                                                                    <col>
                                                                </colgroup>
                                                                <tbody>
                                                                <tr>
                                                                    <th><label for="atclCts" class="req"><spring:message code='forum.label.forum.content'/></label></th> <%-- 토론내용 --%>
                                                                    <td>
                                                                        <div class="editor-box">
                                                                            <label for="atclCts" class="hide">Content</label>
                                                                            <textarea id="atclCts" name="atclCts" class="resize-none"></textarea>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <th><label for="fileUploader"><spring:message code='forum.label.attachFile'/></label></th> <%-- 첨부파일 --%>
                                                                    <td>
                                                                        <div id="uploaderBox">
                                                                            <uiex:dextuploader id="fileUploader" path="${dscsVO.uploadPath}" limitCount="1" limitSize="100" oneLimitSize="100" listSize="1" fileList="" finishFunc="finishUpload()" allowedTypes="*" uiMode="simple" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                </tbody>
                                                            </table>
                                                            <div class="btns">
                                                                <button type="button" class="btn type1 atcl_save_btn" onclick="addAtclBtn()"><spring:message code='forum.label.forum.joinCnt'/> <spring:message code='forum.button.save'/></button> <%-- 참여글 / 저장 --%>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <%-- 찬반토론은 section별 검색을 사용하므로 전체 검색/페이지 크기 선택을 숨긴다. --%>
                            <c:if test="${not isProsConsForum}">
                                <div class="board_top">
                                    <div class="search-typeC">
                                        <input class="form-control" type="text" id="searchValue"
                                               placeholder="<spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />">
                                        <button type="button" class="btn basic icon search" aria-label="search" onclick="listForum(1)"><i class="icon-svg-search"></i></button>
                                    </div>
                                    <div class="right-area">
                                        <uiex:listScale func="changeListScale" value="${dscsVO.listScale}" />
                                    </div>
                                </div>
                            </c:if>
                            <%-- 게시글 목록은 스크립트에서 일반/팀 단일 목록 또는 찬성/반대/피드백 section으로 렌더링한다. --%>
                            <div id="atclList" class="mt20"></div>
                        </div>
                    </div>
                </div>
            </div>
            <%--Top 버튼--%>
            <button type="button" class="go_top"><i class="xi-angle-up-min"></i><span>TOP</span></button>
        </main>
    </div>
</body>
</html>
