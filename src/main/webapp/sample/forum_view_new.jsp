<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
    </jsp:include>
</head>

<body class="class colorA ">
<div id="wrap" class="main">
    <%@ include file="/WEB-INF/jsp/common_new/class_header.jsp" %>

    <main class="common">
        <%@ include file="/WEB-INF/jsp/common_new/class_gnb_prof.jsp" %>

        <div id="content" class="content-wrap common">
            <div class="class_sub_top">
                <div class="navi_bar">
                    <ul>
                        <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                        <li>강의실</li>
                        <li><span class="current">토론방 Mock</span></li>
                    </ul>
                </div>
                <div class="btn-wrap">
                    <div class="first">
                        <button type="button" class="btn type1" onclick="switchTab('tab1')">토론방</button>
                        <button type="button" class="btn type1" onclick="switchTab('tab2')">상호평가</button>
                    </div>
                    <div class="sec">
                        <button type="button" class="btn type1" onclick="listForum()"><i class="xi-refresh"></i>새로고침</button>
                    </div>
                </div>
            </div>

            <div class="class_sub">
                <div class="segment">
                    <div class="board_top">
                        <i class="icon-svg-message-chat"></i>
                        <h3 class="board-title">토론 개요</h3>
                    </div>
                    <div class="box_content">
                        <h3 id="forumTitleText" class="h3"></h3>
                        <p id="forumSummaryText"></p>
                        <div id="forumInfoArea"></div>
                    </div>
                </div>

                <div class="segment">
                    <div class="board_top course">
                        <h3 class="board-title">검색 및 필터</h3>
                        <div class="right-area">
                            <span class="custom-input mr10">
                                <input type="checkbox" id="myTeamOnly">
                                <label for="myTeamOnly">내 팀만 보기</label>
                            </span>
                            <input type="checkbox" id="evalOpen" class="switch yesno small" checked="checked">
                        </div>
                    </div>
                    <div class="box_content">
                        <div class="form-row" style="display:flex; gap:8px; flex-wrap:wrap;">
                            <select class="form-select" id="bbsTeamCd" style="min-width:160px;"></select>
                            <input type="text" class="form-control" id="searchValue" placeholder="학번, 이름, 내용, 찬성/반대 검색" style="min-width:280px;">
                            <select class="form-select" id="listScale" style="width:120px;">
                                <option value="10">10개</option>
                                <option value="20">20개</option>
                                <option value="50">50개</option>
                                <option value="100">100개</option>
                            </select>
                            <button type="button" class="btn gray1" onclick="listForum()">검색</button>
                        </div>
                    </div>
                </div>

                <div id="tab1" class="segment tab_content" style="display:block;">
                    <div class="board_top">
                        <h3 class="board-title">토론 글 목록</h3>
                    </div>
                    <div class="box_content">
                        <div id="atclList"></div>
                    </div>
                </div>

                <div id="tab2" class="segment tab_content" style="display:none;">
                    <div class="board_top">
                        <h3 class="board-title">평가 대상자 목록</h3>
                    </div>
                    <div class="box_content">
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:6%">
                                    <col style="width:14%">
                                    <col style="width:12%">
                                    <col style="width:10%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:14%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>No</th>
                                    <th>학과</th>
                                    <th>학번</th>
                                    <th>이름</th>
                                    <th>토론 글수</th>
                                    <th>댓글수</th>
                                    <th>평균 별점</th>
                                    <th>평가 인원</th>
                                    <th>평가</th>
                                </tr>
                                </thead>
                                <tbody id="forumStareUserList"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
var MOCK = {
    forum: {
        forumCd: "FRM20260214001",
        crsCreCd: "CRS2026SPRING01",
        forumCtgrCd: "TEAM",
        teamCtgrCd: "TEAMCTGR2026",
        forumTitle: "AI 윤리 토론: 생성형 AI의 교육 활용 범위",
        forumArtl: "생성형 AI를 학습에 활용할 때 허용 범위와 책임 주체를 논의하세요.\n근거를 포함해 본문을 작성하고, 동료 의견에 댓글로 피드백을 남겨주세요.",
        forumStartDttm: "20260210090000",
        forumEndDttm: "20260220180000",
        aplyAsnYn: "Y",
        periodAfterWriteYn: "Y",
        extEndDttm: "20260221235900",
        evalCtgr: "P",
        mutEvalYn: "Y",
        evalStartDttm: "20260221100000",
        evalEndDttm: "20260225180000",
        evalRsltOpenYn: "Y"
    },
    meTeamNm: "A팀",
    teamCtgrList: [{ teamNm: "A팀" }, { teamNm: "B팀" }],
    atclList: [
        {
            atclSn: "ATCL001",
            regNm: "김민수",
            userId: "202612345",
            teamNm: "A팀",
            ctsLen: 122,
            prosConsTypeCd: "P",
            modDttm: "20260212110500",
            cts: "찬성 입장입니다. 학습 효율을 높이는 관점에서 생성형 AI는 강력한 보조도구가 됩니다.",
            cmntCount: 2,
            cmntList: [
                { level: 1, regNm: "박지은", modDttm: "20260212132000", cmntCtsLen: 44, cmntCts: "근거가 명확해서 설득력이 있네요.", parRegNm: "" },
                { level: 2, regNm: "김민수", modDttm: "20260212150000", cmntCtsLen: 31, cmntCts: "감사합니다. 반대 근거도 듣고 싶습니다.", parRegNm: "박지은" }
            ]
        },
        {
            atclSn: "ATCL002",
            regNm: "박지은",
            userId: "202698765",
            teamNm: "B팀",
            ctsLen: 98,
            prosConsTypeCd: "C",
            modDttm: "20260213103000",
            cts: "반대 입장입니다. 과의존으로 인해 사고력 저하 가능성이 있습니다.",
            cmntCount: 1,
            cmntList: [
                { level: 1, regNm: "이도윤", modDttm: "20260213110000", cmntCtsLen: 26, cmntCts: "평가 기준 설계가 중요하겠네요.", parRegNm: "" }
            ]
        }
    ],
    evalUsers: [
        { lineNo: 1, deptNm: "컴퓨터과학과", userId: "202612345", userNm: "김민수", forumMyAtclCnt: 1, forumAtclCnt: 2, forumMyCmntCnt: 1, forumCmntCnt: 3, mutAvg: 4.5, mutCnt: 6 },
        { lineNo: 2, deptNm: "컴퓨터과학과", userId: "202698765", userNm: "박지은", forumMyAtclCnt: 1, forumAtclCnt: 2, forumMyCmntCnt: 2, forumCmntCnt: 3, mutAvg: 4.0, mutCnt: 5 }
    ]
};

function formatDttm(raw) {
    if (!raw || raw.length < 12) return raw || "";
    return raw.substring(0, 4) + "." + raw.substring(4, 6) + "." + raw.substring(6, 8) + "(" + raw.substring(8, 10) + ":" + raw.substring(10, 12) + ")";
}

function escapeHtml(text) {
    return String(text || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/\"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function maskUserId(userId) {
    if (!userId || userId.length < 8) return userId || "";
    return userId.substring(0, 5) + "***" + userId.substring(8);
}

function maskUserName(name) {
    if (!name || name.length < 2) return name || "";
    return name.substring(0, 1) + "*" + name.substring(2);
}

function prosConsText(v) {
    if (v === "P") return "찬성";
    if (v === "C") return "반대";
    return "FeedBack";
}

function renderForumInfo() {
    var f = MOCK.forum;
    var html = "";
    html += "<ul class='dash_item_listA'>";
    html += "<li><div class='item_txt'><p class='tit'>토론기간</p><p class='desc'>" + formatDttm(f.forumStartDttm) + " ~ " + formatDttm(f.forumEndDttm) + "</p></div></li>";
    html += "<li><div class='item_txt'><p class='tit'>댓글 답변 요청</p><p class='desc'>" + (f.aplyAsnYn === "Y" ? "예" : "아니오") + "</p></div></li>";
    html += "<li><div class='item_txt'><p class='tit'>지각 제출</p><p class='desc'>" + (f.periodAfterWriteYn === "Y" ? "예 | " + formatDttm(f.extEndDttm) : "아니오") + "</p></div></li>";
    html += "<li><div class='item_txt'><p class='tit'>평가 방법</p><p class='desc'>" + (f.evalCtgr === "P" ? "점수형" : "참여형") + "</p></div></li>";
    html += "<li><div class='item_txt'><p class='tit'>상호평가</p><p class='desc'>" + (f.mutEvalYn === "Y" ? (formatDttm(f.evalStartDttm) + " ~ " + formatDttm(f.evalEndDttm)) : "미사용") + "</p></div></li>";
    html += "</ul>";

    $("#forumTitleText").text(f.forumTitle);
    $("#forumSummaryText").text(f.forumArtl);
    $("#forumInfoArea").html(html);
}

function renderTeamOptions() {
    var html = "";
    MOCK.teamCtgrList.forEach(function(team) {
        var selected = team.teamNm === MOCK.meTeamNm ? " selected" : "";
        html += "<option value='" + escapeHtml(team.teamNm) + "'" + selected + ">" + escapeHtml(team.teamNm) + "</option>";
    });
    $("#bbsTeamCd").html(html);
}

function toggleComment(index) {
    $("#commentBox" + index).toggle();
}

function createForumListHTML(forumList) {
    if (!forumList.length) {
        return "<p>등록된 내용이 없습니다.</p>";
    }

    var html = "";
    forumList.forEach(function(v, i) {
        html += "<div class='segment' style='margin-bottom:12px;'>";
        html += "  <div class='board_top'>";
        html += "    <h3 class='board-title'>" + escapeHtml(v.regNm) + " (" + escapeHtml(v.userId) + ")</h3>";
        html += "    <div class='right-area'>" + formatDttm(v.modDttm) + " | " + prosConsText(v.prosConsTypeCd) + " | " + v.ctsLen + "자</div>";
        html += "  </div>";
        html += "  <div class='box_content'>";
        html += "    <p>" + escapeHtml(v.cts) + "</p>";
        html += "    <button type='button' class='btn gray1' onclick='toggleComment(" + i + ")'>댓글 " + v.cmntCount + "개 보기/숨기기</button>";
        html += "    <div id='commentBox" + i + "' style='display:none; margin-top:10px;'>";

        v.cmntList.forEach(function(rs) {
            html += "<div style='padding:8px 0; border-top:1px solid #eee;'>";
            html += "<strong>" + escapeHtml(rs.regNm) + "</strong> <small>" + formatDttm(rs.modDttm) + " | " + rs.cmntCtsLen + "자</small><br>";
            if (rs.level === 2) {
                html += "<em>@" + escapeHtml(rs.parRegNm) + "</em> ";
            }
            html += escapeHtml(rs.cmntCts);
            html += "</div>";
        });

        html += "    </div>";
        html += "  </div>";
        html += "</div>";
    });
    return html;
}

function listForum() {
    var searchValue = ($("#searchValue").val() || "").trim();
    var teamNm = $("#bbsTeamCd").val();
    var listScale = parseInt($("#listScale").val(), 10);
    var myTeamOnly = $("#myTeamOnly").is(":checked");

    var filtered = MOCK.atclList.filter(function(v) {
        var teamOk = !teamNm || v.teamNm === teamNm;
        if (myTeamOnly) {
            teamOk = teamOk && v.teamNm === MOCK.meTeamNm;
        }
        var searchOk = !searchValue
            || v.regNm.indexOf(searchValue) > -1
            || v.userId.indexOf(searchValue) > -1
            || v.cts.indexOf(searchValue) > -1
            || prosConsText(v.prosConsTypeCd).indexOf(searchValue) > -1;
        return teamOk && searchOk;
    });

    $("#atclList").html(createForumListHTML(filtered.slice(0, listScale)));
}

function listForumUser() {
    var html = "";
    var showEval = $("#evalOpen").is(":checked");

    MOCK.evalUsers.forEach(function(v) {
        html += "<tr>";
        html += "<td>" + v.lineNo + "</td>";
        html += "<td>" + escapeHtml(v.deptNm) + "</td>";
        html += "<td>" + escapeHtml(maskUserId(v.userId)) + "</td>";
        html += "<td>" + escapeHtml(maskUserName(v.userNm)) + "</td>";
        html += "<td>" + v.forumMyAtclCnt + "/" + v.forumAtclCnt + "</td>";
        html += "<td>" + v.forumMyCmntCnt + "/" + v.forumCmntCnt + "</td>";
        html += "<td>" + (showEval ? v.mutAvg : "-") + "</td>";
        html += "<td>" + v.mutCnt + "</td>";
        html += "<td><button type='button' class='btn gray1' onclick='openEvalMock(\"" + escapeHtml(v.userNm) + "\")'>평가하기</button></td>";
        html += "</tr>";
    });

    $("#forumStareUserList").html(html);
}

function openEvalMock(userNm) {
    UiComm.showMessage("Mock 평가 팝업: " + userNm, "info");
}

function switchTab(tabId) {
    $(".tab_content").hide();
    $("#" + tabId).show();
}

$(document).ready(function() {
    renderForumInfo();
    renderTeamOptions();
    listForum();
    listForumUser();

    $("#searchValue").on("keyup", function(e) {
        if (e.keyCode === 13) listForum();
    });

    $("#listScale, #bbsTeamCd, #myTeamOnly").on("change", listForum);
    $("#evalOpen").on("change", listForumUser);
});
</script>
</body>
</html>
