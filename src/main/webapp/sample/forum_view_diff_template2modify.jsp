<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            html += "    <div class='article p10 commentlist' id='commentBox" + i + "' style='display:none;'>";
            html += renderForumCommentList(v.cmntList);
            html += "    </div>";
            html += "  </div>";
            html += "</div>";
        });

        return html;
    }


    function renderForumCommentList(list) {
        var $wrap = $("<div></div>");
        (list || []).forEach(function(item, index) {
            var $node = item.level === 2 ? createReplyNode(item, index) : createCommentNode(item, index);
            $wrap.append($node);
        });
        return $wrap.html();
    }

    function createCommentNode(item, index) {
        var $node = $($.trim($("#comment-item-template").html()));
        bindCommentNode($node, item, index);
        return $node;
    }

    function createReplyNode(item, index) {
        var $node = $($.trim($("#reply-item-template").html()));
        bindReplyNode($node, item, index);
        return $node;
    }

    function bindCommentNode($node, item, index) {
        bindForumCommentNode($node, item, index, false);
    }

    function bindReplyNode($node, item, index) {
        bindForumCommentNode($node, item, index, true);
    }

    function bindForumCommentNode($node, item, index, isReply) {
        $node.attr("data-dscs-cmnt-id", item.cmntSn || "");
        $node.attr("data-comment-index", index);
        $node.find("[data-field='rgtrNm']").text(item.regNm || "");
        $node.find("[data-field='regDttm']").text(formatDttm(item.modDttm));
        $node.find("[data-field='cmntCtsLen']").text(item.cmntCtsLen);
        $node.find("[data-field='commentMeta']").text(formatDttm(item.modDttm) + " | 글자수: " + item.cmntCtsLen + "자");
        $node.find("[data-field='atclCmntCts']").text(item.cmntCts || "");
        $node.find("[data-field='dscsCmntId']").text(item.cmntSn || "");

        var $mention = $node.find("[data-role='parent-mention']");
        if (isReply) {
            $mention.find("[data-field='parRegNm']").text(item.parRegNm || "");
            $mention.removeClass("dpn");
        } else {
            $mention.addClass("dpn");
        }

        applyActionVisibility($node, item);
    }

    function applyActionVisibility($node, item) {
        $node.find("[data-role='btn-reply'], [data-role='btn-edit'], [data-role='btn-delete']").hide();
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
</head>

<body class="class colorA">
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
                                <%--<a href="javascript:void(0)" class="btn type2" onclick="editForum('${forumVo.forumCd}','${forumVo.forumStartDttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
                                <a href="javascript:void(0)" class="btn type2" onclick="delForum('${forumVo.forumCd}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>--%>
                                <a href="javascript:void(0)" class="btn type2" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="mw120 select"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
                                <li class="mw120"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
                            </ul>
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

                        <!-- 댓글 -->
                        <div class="Comment">
                            <div class="top_area">
                                <button class="toggle_commentlist"><i class="icon-svg-message"></i>2개의 댓글이 있습니다. <i class="icon-svg-arrow-down"></i></button>
                                <button class="toggle_commentwrite btn basic">댓글 작성</button>
                            </div>

                            <div class="comment_list">
                                <div class="recmt_form">
                                    <fieldset>
                                        <legend class="sr_only">댓글등록</legend>
                                        <div class="memo">
                                            <div class="simple_answer">
                                                <span>간편 댓글</span>
                                                <div class="answer_btn">
                                                    <a href="#0" class="current">수고했어요</a><!--간편답변 선택시 클래스추가-->
                                                    <a href="#0">고생하셨어요.</a>
                                                    <a href="#0">감사합니다.</a>
                                                </div>
                                            </div>
                                            <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                            <div class="bottom_btn">
                                                    <span class="custom-input">
                                                        <input type="checkbox" name="" id="feedbackLabel">
                                                        <label for="feedbackLabel">피드백 문의 <span class="small">( 체크 시 문의로 등록되며 답변을 받을 수 있습니다. )</span></label>
                                                    </span>
                                                <div class="right-area">
                                                    <button type="button" class="btn type2">댓글 등록</button>
                                                </div>
                                            </div>

                                        </div>
                                    </fieldset>
                                </div>
                                <ul>
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <strong class="name">홍길동</strong>
                                                <span class="date">2026.05.02 05:32</span>
                                            </div>
                                            <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>
                                            <span class="cmtBtnGroup">
                                                    <button class="cmtUpt">수정</button>
                                                    <button class="cmtDel">삭제</button>
                                                    <button class="cmtWri">댓글</button>
                                                </span>
                                        </div>
                                        <div class="recmt_form">
                                            <fieldset>
                                                <legend class="sr_only">댓글등록</legend>
                                                <div class="memo">
                                                    <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                                    <button type="button" class="cmt_create">댓글 등록</button>
                                                </div>
                                            </fieldset>
                                        </div>
                                        <ul class="re_comment_ul">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <strong class="name">나방송</strong>
                                                        <span class="date">2026.05.02 05:32</span>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <span class="cmtBtnGroup">
                                                            <button class="cmtUpt">수정</button>
                                                            <button class="cmtDel">삭제</button>
                                                        </span>
                                                </div>
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <strong class="name">홍길동</strong>
                                                        <span class="date">2026.05.02 05:32</span>
                                                    </div>
                                                    <span class="comment">동의합니다.</span>
                                                    <span class="cmtBtnGroup">
                                                            <button class="cmtUpt">수정</button>
                                                            <button class="cmtDel">삭제</button>
                                                        </span>
                                                </div>
                                            </li>

                                        </ul>
                                    </li>

                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <strong class="name">나방송</strong>
                                                <span class="date">2024.05.02 05:32</span>
                                            </div>
                                            <span class="comment">질문의 효과를 최대화 시키기 위해서는 올바른 질문을 하는 것이 중요</span>
                                            <span class="cmtBtnGroup">
                                                    <button class="cmtUpt">수정</button>
                                                    <button class="cmtDel">삭제</button>
                                                    <button class="cmtWri">댓글</button>
                                                </span>
                                        </div>

                                    </li>
                                </ul>
                            </div>

                        </div>
                        <script>
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
                                        const replyForm = li.querySelector('.recmt_form');
                                        if (!replyForm) return;

                                        // 같은 Comment 안의 다른 대댓글 폼 닫기
                                        comment
                                            .querySelectorAll('.comment_list ul li .recmt_form')
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

                            });
                        </script>
                        <div class="ui attached message element">
                            <div id="atclList" class="mt20"></div>
                            <div id="paging" class="paging"></div>
                        </div>
                        <!-- 토론 참여글 끝-->

                    </div>
                </div>

            </div>
        </main>
</body>
</html>
