<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

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
        scoreAplyYn: "Y",
        scoreOpenYn: "N",
        aplyAsnYn: "Y",
        periodAfterWriteYn: "Y",
        extEndDttm: "20260221235900",
        otherViewYn: "Y",
        evalCtgr: "P",
        prosConsForumCfg: "Y",
        prosConsRateOpenYn: "Y",
        regOpenYn: "Y",
        prosConsModYn: "N",
        mutEvalYn: "Y",
        evalStartDttm: "20260221100000",
        evalEndDttm: "20260225180000",
        evalRsltOpenYn: "Y",
        crsCreNm: "2026-1학기 데이터사이언스반"
    },
    meTeamNm: "A팀",
    teamCtgrList: [
        { teamNm: "A팀" },
        { teamNm: "B팀" }
    ],
    atclList: [
        {
            atclSn: "ATCL001",
            rgtrId: "202612345",
            regNm: "김민수",
            userId: "202612345",
            teamNm: "A팀",
            delYn: "N",
            ctsLen: 122,
            atclTypeCd: "TEAM",
            prosConsTypeCd: "P",
            modDttm: "20260212110500",
            cts: "찬성 입장입니다. 학습 효율을 높이는 관점에서 생성형 AI는 강력한 보조도구가 됩니다.",
            cmntCount: 2,
            aplyAsnYn: "Y",
            fileList: [
                { fileSn: "F001", repoCd: "FORUM", fileNm: "근거자료.pdf" }
            ],
            cmntList: [
                {
                    cmntSn: "C001",
                    atclSn: "ATCL001",
                    level: 1,
                    rgtrId: "202698765",
                    regNm: "박지은",
                    modDttm: "20260212132000",
                    delYn: "N",
                    cmntCtsLen: 44,
                    cmntCts: "근거가 명확해서 설득력이 있네요.",
                    parRegNm: "",
                    phtFile: "",
                    ansReqYn: "N"
                },
                {
                    cmntSn: "C002",
                    atclSn: "ATCL001",
                    level: 2,
                    rgtrId: "202612345",
                    regNm: "김민수",
                    modDttm: "20260212150000",
                    delYn: "N",
                    cmntCtsLen: 31,
                    cmntCts: "감사합니다. 반대 근거도 듣고 싶습니다.",
                    parRegNm: "박지은",
                    phtFile: "",
                    ansReqYn: "N"
                }
            ]
        },
        {
            atclSn: "ATCL002",
            rgtrId: "202698765",
            regNm: "박지은",
            userId: "202698765",
            teamNm: "B팀",
            delYn: "N",
            ctsLen: 98,
            atclTypeCd: "TEAM",
            prosConsTypeCd: "C",
            modDttm: "20260213103000",
            cts: "반대 입장입니다. 과의존으로 인해 사고력 저하 가능성이 있습니다.",
            cmntCount: 1,
            aplyAsnYn: "N",
            fileList: [],
            cmntList: [
                {
                    cmntSn: "C003",
                    atclSn: "ATCL002",
                    level: 1,
                    rgtrId: "202655555",
                    regNm: "이도윤",
                    modDttm: "20260213110000",
                    delYn: "N",
                    cmntCtsLen: 26,
                    cmntCts: "평가 기준 설계가 중요하겠네요.",
                    parRegNm: "",
                    phtFile: "",
                    ansReqYn: "N"
                }
            ]
        }
    ],
    evalUsers: [
        {
            lineNo: 1,
            deptNm: "컴퓨터과학과",
            userId: "202612345",
            userNm: "김민수",
            forumMyAtclCnt: 1,
            forumAtclCnt: 2,
            forumMyCmntCnt: 1,
            forumCmntCnt: 3,
            evalRsltOpenYn: "Y",
            mutAvg: 4.5,
            mutCnt: 6,
            stdNo: "STD001",
            mutSn: "M001"
        },
        {
            lineNo: 2,
            deptNm: "컴퓨터과학과",
            userId: "202698765",
            userNm: "박지은",
            forumMyAtclCnt: 1,
            forumAtclCnt: 2,
            forumMyCmntCnt: 2,
            forumCmntCnt: 3,
            evalRsltOpenYn: "Y",
            mutAvg: 4.0,
            mutCnt: 5,
            stdNo: "STD002",
            mutSn: "M002"
        }
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

function ynText(v) {
    return v === "Y" ? "예" : "아니오";
}

function prosConsText(v) {
    if (v === "P") return "찬성";
    if (v === "C") return "반대";
    return "FeedBack";
}

function maskUserId(userId) {
    if (!userId || userId.length < 8) return userId || "";
    return userId.substring(0, 5) + "***" + userId.substring(8);
}

function maskUserName(name) {
    if (!name || name.length < 2) return name || "";
    return name.substring(0, 1) + "*" + name.substring(2);
}

function renderForumInfo(prefix) {
    var f = MOCK.forum;
    var html = "";
    html += "<ul class='tbl'>";
    html += "  <li><dl><dt><label>토론명</label></dt><dd>" + escapeHtml(f.forumTitle) + "</dd></dl></li>";
    html += "  <li><dl><dt><label>토론내용</label></dt><dd><pre>" + escapeHtml(f.forumArtl) + "</pre></dd></dl></li>";
    html += "  <li><dl><dt><label>토론기간</label></dt><dd>" + formatDttm(f.forumStartDttm) + " ~ " + formatDttm(f.forumEndDttm) + "</dd></dl></li>";
    html += "  <li><dl><dt><label>댓글 답변 요청</label></dt><dd>" + ynText(f.aplyAsnYn) + "</dd></dl></li>";
    html += "  <li><dl><dt><label>지각제출</label></dt><dd>" + ynText(f.periodAfterWriteYn);
    if (f.periodAfterWriteYn === "Y") {
        html += " | " + formatDttm(f.extEndDttm);
    }
    html += "</dd></dl></li>";
    html += "  <li><dl><dt><label>평가 방법</label></dt><dd>" + (f.evalCtgr === "P" ? "점수형" : "참여형") + "</dd></dl></li>";
    html += "  <li><dl><dt><label>상호평가</label></dt><dd>" + ynText(f.mutEvalYn);
    if (f.mutEvalYn === "Y") {
        html += " | 기간: " + formatDttm(f.evalStartDttm) + " ~ " + formatDttm(f.evalEndDttm);
        html += " | 결과공개: " + ynText(f.evalRsltOpenYn);
    }
    html += "</dd></dl></li>";
    html += "</ul>";

    $("#" + prefix + "ForumInfo").html(html);
    $("#" + prefix + "ForumSummary").text("토론기간: " + formatDttm(f.forumStartDttm) + " ~ " + formatDttm(f.forumEndDttm));
}

function renderTeamOptions() {
    var html = "";
    MOCK.teamCtgrList.forEach(function(team) {
        var selected = team.teamNm === MOCK.meTeamNm ? " selected" : "";
        html += "<option value='" + escapeHtml(team.teamNm) + "'" + selected + ">" + escapeHtml(team.teamNm) + "</option>";
    });
    $("#bbsTeamCd").html(html);
}

function listForum() {
    var searchValue = ($("#searchValue").val() || "").trim();
    var teamNm = $("#bbsTeamCd").val();
    var listScale = parseInt($("#listScale").val(), 10);

    var filtered = MOCK.atclList.filter(function(v) {
        var teamOk = !teamNm || v.teamNm === teamNm;
        var searchOk = !searchValue
            || v.regNm.indexOf(searchValue) > -1
            || v.userId.indexOf(searchValue) > -1
            || v.cts.indexOf(searchValue) > -1
            || prosConsText(v.prosConsTypeCd).indexOf(searchValue) > -1;
        return teamOk && searchOk;
    });

    var renderList = filtered.slice(0, listScale);
    $("#atclList").html(createForumListHTML(renderList));
}

function toggleComment(index) {
    var target = $("#commentBox" + index);
    target.toggle();
}

function createForumListHTML(forumList) {
    if (!forumList.length) {
        return "<div class='cont-none'><span>등록된 내용이 없습니다.</span></div>";
    }

    var html = "";
    forumList.forEach(function(v, i) {
        html += "<div class='ui card wmax'>";
        html += "  <div class='content'>";
        html += "    <div class='flex fac'>";
        html += "      <span class='label mr10'>" + escapeHtml(v.regNm) + "(" + escapeHtml(v.userId) + ")</span>";
        html += "      <span class='label mr10 fcBlue'>글자수: " + v.ctsLen + "자</span>";
        html += "      <span class='label mr10'>작성일시: " + formatDttm(v.modDttm) + "</span>";
        html += "      <span class='label mr10'>구분: " + prosConsText(v.prosConsTypeCd) + "</span>";
        html += "    </div>";
        html += "  </div>";
        html += "  <div class='ui segment ml25 mr25 mt10 mb10 forumView'><pre>" + escapeHtml(v.cts) + "</pre></div>";
        html += "  <div class='content comment border0 mt10'>";
        html += "    <div class='ui box flex-item'>";
        html += "      <div class='flex-item mra'>";
        html += "        <div class='cur_point' onclick='toggleComment(" + i + ")'>";
        html += "          댓글 " + v.cmntCount + "개 보기/숨기기";
        html += "        </div>";
        html += "      </div>";
        html += "    </div>";
        html += "    <div class='article p10 commentlist Comment' id='commentBox" + i + "' style='display:none;'>";
        html += "      <div class='top_area'>";
        html += "        <button type='button' class='toggle_commentlist'>" + v.cmntCount + "</button>";
        html += "      </div>";
        html += "      <div class='comment_list'>";
        html += "        <ul>";

        var cmntTree = [];
        var currentParent = null;
        v.cmntList.forEach(function(rs) {
            if (rs.level === 2 && currentParent) {
                currentParent.replies.push(rs);
                return;
            }
            currentParent = {
                data: rs,
                replies: []
            };
            cmntTree.push(currentParent);
        });

        cmntTree.forEach(function(node) {
            var main = node.data;
            html += "          <li>";
            html += "            <div class='item'>";
            html += "              <div class='cmt_info'>";
            html += "                <strong class='name'>" + escapeHtml(main.regNm) + "</strong>";
            html += "                <span class='date'>" + formatDttm(main.modDttm) + " | ?�???: " + main.cmntCtsLen + "??/span>";
            html += "              </div>";
            html += "              <span class='comment'>" + escapeHtml(main.cmntCts) + "</span>";
            html += "              <span class='cmtBtnGroup'></span>";
            html += "            </div>";

            if (node.replies.length) {
                html += "            <ul class='re_comment_ul co_inner'>";
                node.replies.forEach(function(reply) {
                    html += "              <li class='re_comment'>";
                    html += "                <div class='item'>";
                    html += "                  <div class='cmt_info'>";
                    html += "                    <strong class='name'>" + escapeHtml(reply.regNm) + "</strong>";
                    html += "                    <span class='date'>" + formatDttm(reply.modDttm) + " | ?�???: " + reply.cmntCtsLen + "??/span>";
                    html += "                  </div>";
                    html += "                  <span class='comment'><em>@" + escapeHtml(reply.parRegNm) + "</em> " + escapeHtml(reply.cmntCts) + "</span>";
                    html += "                  <span class='cmtBtnGroup'></span>";
                    html += "                </div>";
                    html += "              </li>";
                });
                html += "            </ul>";
            }

            html += "          </li>";
        });

        html += "        </ul>";
        html += "      </div>";
        html += "    </div>";
        html += "  </div>";
        html += "</div>";
    });

    return html;
}

function listForumUser() {
    var html = "";
    MOCK.evalUsers.forEach(function(v) {
        html += "<tr>";
        html += "<td class='tc'>" + v.lineNo + "</td>";
        html += "<td class='tc'>" + escapeHtml(v.deptNm) + "</td>";
        html += "<td class='tc'>" + escapeHtml(maskUserId(v.userId)) + "</td>";
        html += "<td class='tc'>" + escapeHtml(maskUserName(v.userNm)) + "</td>";
        html += "<td class='tc'>" + v.forumMyAtclCnt + "/" + v.forumAtclCnt + "</td>";
        html += "<td class='tc'>" + v.forumMyCmntCnt + "/" + v.forumCmntCnt + "</td>";
        html += "<td class='tc'>" + v.mutAvg + "</td>";
        html += "<td class='tc'>" + v.mutCnt + "</td>";
        html += "<td class='tc'><a href='#0' class='ui basic small button' onclick='openEvalMock(\"" + escapeHtml(v.userNm) + "\"); return false;'>평가하기</a></td>";
        html += "</tr>";
    });
    $("#forumStareUserList").html(html);
}

function openEvalMock(userNm) {
    alert("Mock 평가 팝업: " + userNm);
}

function switchTab(tabId) {
    $(".listTab li").removeClass("select");
    $(".listTab a[href='#" + tabId + "']").parent().addClass("select");
    $(".tab_content").hide();
    $("#" + tabId).show();
}

$(document).ready(function() {
    renderTeamOptions();
    renderForumInfo("tab1");
    renderForumInfo("tab2");
    listForum();
    listForumUser();

    $("#searchValue").on("keyup", function(e) {
        if (e.keyCode === 13) {
            listForum();
        }
    });

    $(".listTab a").on("click", function(e) {
        e.preventDefault();
        switchTab($(this).attr("href").replace("#", ""));
    });

    $("#listScale, #bbsTeamCd").on("change", listForum);
    switchTab("tab1");
});
</script>

<body>
<div id="content">
    <div class="content-wrap">
        <div class="content-box">
            <h2 class="h2 mb10">토론방 Mock 화면 (서버 연동 없음)</h2>

            <div class="listTab">
                <ul>
                    <li class="select mw120"><a href="#tab1">토론방</a></li>
                    <li class="mw120"><a href="#tab2">상호평가</a></li>
                </ul>
            </div>

            <div id="tab1" class="tab_content" style="display:block;">
                <div class="ui styled fluid accordion week_lect_list" style="border:none;">
                    <div class="title active">
                        <div class="title_cont">
                            <div class="left_cont">
                                <div class="lectTit_box">
                                    <p class="lect_name">AI 윤리 토론: 생성형 AI의 교육 활용 범위</p>
                                    <span class="fcGrey"><small id="tab1ForumSummary"></small></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="content active p0">
                        <div class="ui segment" id="tab1ForumInfo"></div>
                    </div>
                </div>

                <div class="option-content mb5">
                    <select class="ui dropdown" id="bbsTeamCd"></select>
                </div>
                <div class="option-content">
                    <div class="ui action input search-box">
                        <input type="text" id="searchValue" placeholder="학번, 이름, 내용, 찬성/반대 검색" />
                        <a class="ui icon button" onclick="listForum();"><i class="search icon"></i></a>
                    </div>
                    <div class="button-area flex-left-auto">
                        <select id="listScale">
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="50">50</option>
                            <option value="100">100</option>
                        </select>
                    </div>
                </div>

                <div class="ui attached message element">
                    <div id="atclList" class="mt20"></div>
                </div>
            </div>

            <div id="tab2" class="tab_content" style="display:none;">
                <div class="ui styled fluid accordion week_lect_list" style="border:none;">
                    <div class="title active">
                        <div class="title_cont">
                            <div class="left_cont">
                                <div class="lectTit_box">
                                    <p class="lect_name">AI 윤리 토론: 생성형 AI의 교육 활용 범위</p>
                                    <span class="fcGrey"><small id="tab2ForumSummary"></small></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="content active p0">
                        <div class="ui segment" id="tab2ForumInfo"></div>
                    </div>
                </div>

                <h4 class="ui top attached header">평가 대상자 목록</h4>
                <div class="ui bottom attached segment">
                    <table class="table type2" style="display:table; width:100%;">
                        <thead>
                        <tr>
                            <th>No</th>
                            <th class="tc">학과</th>
                            <th class="tc">학번</th>
                            <th class="tc">이름</th>
                            <th class="tc">토론 글수</th>
                            <th class="tc">댓글수</th>
                            <th class="tc">평균 별점</th>
                            <th class="tc">평가 인원</th>
                            <th class="tc">평가</th>
                        </tr>
                        </thead>
                        <tbody id="forumStareUserList"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
