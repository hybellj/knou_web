<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/team/common/team_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
        var curSbjctId = '${sbjctId}';
        var teamGrpInfoListTable = null;

        // 팀 및 팀원 목록 (서버 전달, 1행 = 1팀원)
        var teamAndMbrList = [
            <c:forEach var="item" items="${teamGrpVO}" varStatus="vs">
            { teamGrpId    : '${item.teamGrpId}'
            , teamGrpnm    : '${item.teamGrpnm}'
            , teamId      : '${item.teamId}'
            , teamnm      : '${item.teamnm}'
            , teamBbsUseyn: '${item.teamBbsUseyn}'
            , userId      : '${item.userId}'
            , ldryn       : '${item.ldryn}'
            , usernm      : '${item.usernm}'
            , stdntNo     : '${item.stdntNo}'
            , deptnm      : '${item.deptnm}' }${!vs.last ? ',' : ''}
            </c:forEach>
        ];

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initTeamGrpInfoListTable :     컬럼 정의 및 테이블 초기화
         * 2. initTeamGrpData :              팀 멤버 상세 드롭다운 및 데이터 세팅
         * 3. toggleTeamMbr :               팀 멤버 드롭다운 토글
         *****************************************************************************/
        /* 1 */
        function initTeamGrpInfoListTable() {
            if (teamGrpInfoListTable) return;
            var columns = [
                {title:"teamId", field:"teamId", visible:false},
                {title:"No", field:"lineNo",     headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='team.table.teamNm'/>", field:"teamnm", headerHozAlign:"center", hozAlign:"left",  width:0, minWidth:200},         /* 팀명 */
                {title:"<spring:message code='team.table.leaderNm'/>",  field:"leadernm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:100,    /* 팀장 */
                    // 배치 시 팀장 명 정하는 용도.. ldryn = 'Y' 인 요소 찾기
                    formatter: function(cell) {
                        var data        = cell.getRow().getData();
                        var usernms     = data.usernmList ? data.usernmList.split(',') : [];
                        var ldrynArr    = data.ldrynList  ? data.ldrynList.split(',')  : [];
                        var idx         = ldrynArr.indexOf('Y');
                        return idx >= 0 ? usernms[idx] : '';
                    }
                },
                {title:"<spring:message code='team.label.team.member.cnt'/>", field:"teamCnt", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:100}   /* 팀원 수 */
            ];
            teamGrpInfoListTable = UiTable("teamGrpList", {
                lang: "ko"
                , selectRow: "checkbox"
                , columns: columns
            });
        }
        /* 2 */
        function initTeamGrpData() {
            // teamId 기준으로 그룹핑
            var teamMap   = {};
            var teamOrder = [];
            teamAndMbrList.forEach(function(item) {
                if (!teamMap[item.teamId]) {
                    teamMap[item.teamId] = { teamId: item.teamId, teamnm: item.teamnm, members: [] };
                    teamOrder.push(item.teamId);
                }
                teamMap[item.teamId].members.push(item);
            });

            var teamCount = teamOrder.length;

            // 데이터 배열 구성 후 setData() 한 번에 로드
            var expandMap       = {};  // 멤버 테이블 HTML
            var rowDataArray    = [];
            teamOrder.forEach(function(teamId, idx) {
                var team    = teamMap[teamId];
                var members = team.members;
                var lineNo  = teamCount - idx;
                var seq     = 'LRNGR' + (idx + 1);

                var teamListStr         = members.map(function(m) { return m.userId;}).join(',');
                var usernmListStr       = members.map(function(m) { return m.usernm;}).join(',');
                var deptnmListStr       = members.map(function(m) { return m.deptnm;}).join(',');
                var stdntNoListStr      = members.map(function(m) { return m.stdntNo;}).join(',');
                var ldrynListStr        = members.map(function(m) { return m.ldryn;}).join(',');

                var ldrynArr        = ldrynListStr.split(',');
                var usernmArr       = usernmListStr.split(',');
                var stdntNoArr      = stdntNoListStr.split(',');
                var deptnmArr       = deptnmListStr.split(',');
                var leaderIdx       = ldrynArr.indexOf('Y');
                var leaderNm        = leaderIdx >= 0 ? usernmArr[leaderIdx] : '';

                // 팀 멤버 드롭다운 HTML 구성
                var memberHtml = '<table class="table-type2">'
                    + '<thead><tr>'
                    + '<th><label>No</label></th>'
                    + '<th><label><spring:message code='common.dept_name'/></label></th>'           /* 학과 */
                    + '<th><label><spring:message code='common.label.student.number'/></label></th>'/* 학번 */
                    + '<th><label><spring:message code='common.name'/></label></th>'                /* 이름 */
                    + '<th><label><spring:message code='common.type'/></label></th>'                /* 구분 */
                    + '</tr></thead><tbody>';
                for (var j = 0; j < usernmArr.length; j++) {
                    memberHtml += '<tr>'
                        + '<td><pre>' + (j + 1) + '</pre></td>'
                        + '<td><pre>' + (deptnmArr[j] || '') + '</pre></td>'
                        + '<td><pre>' + (stdntNoArr[j] || '') + '</pre></td>'
                        + '<td><pre>' + (usernmArr[j] || '') + '</pre></td>'
                        + '<td><pre>' + (ldrynArr[j] === 'Y' ? '<spring:message code='common.team.leader'/>' : '<spring:message code='common.team.members'/>')  + '</pre></td>' /* 팀장 */ /* 팀원 */
                        + '</tr>';
                }
                memberHtml += '</tbody></table>';

                expandMap[seq] = memberHtml;

                var teamnmHtml = '<a href="javascript:toggleTeamMbr(\'' + seq + '\')" class="header header-icon link">' + team.teamnm + '</a>';

                rowDataArray.push({
                    teamSeq      : seq
                    , teamId     : teamId
                    , lineNo     : lineNo
                    , teamnm     : teamnmHtml
                    , leadernm   : leaderNm
                    , teamCnt    : members.length
                    , teamList   : teamListStr
                    , usernmList : usernmListStr
                    , deptnmList : deptnmListStr
                    , stdntNoList: stdntNoListStr
                    , ldrynList  : ldrynListStr
                });
            });

            teamGrpInfoListTable.setData(rowDataArray);

            // Tabulator 렌더링 완료 후 row 아래에 expand div 주입
            setTimeout(function() {
                teamGrpInfoListTable.getRows().forEach(function(row) {
                    var seq   = row.getData().teamSeq;
                    var rowEl = row.getElement();
                    // row를 flex-wrap으로 변경하여 100% 너비 div가 아래로 내려가도록 함..
                    rowEl.style.flexWrap = 'wrap';

                    var expandEl = document.createElement('div');
                    expandEl.id = 'expand-' + seq;
                    expandEl.style.cssText = 'display:none; width:100%; padding:8px 12px; background:#fafafa; box-sizing:border-box;';
                    expandEl.innerHTML = expandMap[seq] || '';
                    rowEl.appendChild(expandEl);
                });
            }, 50);

            // 2. 현재 구성원 합계 갱신
            updateSetTot();
        }
        /* 3 */
        function toggleTeamMbr(seq) {
            var expandEl = document.getElementById('expand-' + seq);
            if (!expandEl) return;
            var isHidden = expandEl.style.display === 'none';
            expandEl.style.display = isHidden ? 'block' : 'none';
        }

        /* 현재 구성원 합계 갱신 */
        function updateSetTot() {
            var total = teamGrpInfoListTable.getRows().reduce(function(sum, row) {
                return sum + (parseInt(row.getData().teamCnt) || 0);
            }, 0);
            $('#setTot').text(total);
        }

        /* 목록으로 돌아가기 */
        function teamGrpListViewMv () {
            teamGrpMgrViewMv("list");
        }

        /**
         * 팀 그룹 지정 [등록|수정] 페이지 이동
         * @param teamGrpId  팀 그룹 ID
         * @param usingyn   팀 그룹 사용여부
         */
        function teamGrpMgrModifyMv(teamGrpId, usingyn, sbjctId) {
            teamGrpMgrViewMv("write", teamGrpId, usingyn, sbjctId);
        }

        /* sms 보내기 */
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#teamGrpList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (teamGrpInfoListTable.getSelectedData("userId").length == 0) {
                /* 메시지 발송 대상자를 선택하세요. */
                alert("<spring:message code='common.alert.sysmsg.select_user'/>");
                return;
            }

            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

            var form = document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }

        $(document).ready(function() {
            initTeamGrpInfoListTable();
            setTimeout(initTeamGrpData, 0);  // 비동기 작업이 끝난 뒤 함수 실행
        });
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //강의실 상단 -->
                    <div class="sub-content">
                        <!-- 상단 영역 -->
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code='team.label.team.grp.set'/><!-- 팀 그룹지정 -->
                            </h2>
                        </div>
                        <div class="board_top">
                            <h4 class="sub-title">
                                <spring:message code='common.button.detailinfo'/>
                            </h4><!-- 상세정보 -->
                            <div class="right-area">
                                <button type="button" class="btn type1" onclick = "teamGrpMgrModifyMv('${teamGrpVO[0].teamGrpId}', '${usingyn}', '${sbjctId}')"><spring:message code='common.button.modify'/></button><!-- 수정 -->
                                <button type="button" class="btn type2" onclick = "teamGrpListViewMv('', '', '${sbjctId}')"><spring:message code='common.button.list'/></button><!-- 목록 -->
                            </div>
                        </div>
                        <div class="lectTit_box">
                            <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                            <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                        </div>
                        <!-- 팀 그룹 상세 정보 영역 -->
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col class="" />
                                </colgroup>
                                <tbody>
                                    <!-- 팀그룹명 -->
                                    <tr>
                                        <th class="req"><spring:message code='team.label.grp.nm'/></th><!-- 팀그룹명 -->
                                        <td>${teamGrpVO[0].teamGrpnm}</td>
                                    </tr>
                                    <!-- 팀 게시판 사용여부 -->
                                    <tr>
                                        <th class="req"><spring:message code='team.write.field.teamBbs'/> <spring:message code='common.use.yn'/></th><!-- 팀 게시판 --> <!-- 사용여부 -->
                                        <td>${teamGrpVO[0].teamBbsUseyn eq 'Y' ? yes : no}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="board_top">
                            <h4 class="sub-title">
                                학습그룹 및 팀 구성원
                                <span class="total_txt fw-normal fs-16px"><spring:message code='team.grp.and.team.member'/> [ <spring:message code='common.label.students'/> : ${userTot}, <spring:message code='team.label.curr.member'/> : <a id="setTot">0</a> ]</span><!-- 팀 그룹 및 팀 구성원 --> <!-- 수강생 --> <!-- 현재 구성원 -->
                            </h4>
                            <div class="right-area">
                                <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='common.button.send'/></a><!-- 보내기 -->
                            </div>
                        </div>
                        <!-- 팀  그룹 목록 (list) -->
                        <div id="teamGrpListArea">
                            <div id="teamGrpList"></div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
