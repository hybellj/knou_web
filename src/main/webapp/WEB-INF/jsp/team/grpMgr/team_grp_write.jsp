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
        var isModify = '${isModify}';
        var usingyn = '${usingyn}';     // 현재 그룹 사용여부
        var isAdd = null;               // 행 추가여부
        var autoAllocyn = null;         // 자동구성:'Y' / 수동구성:'N'
        var teamGrpInfoListTable = null;

        // 수강생 전체 목록 (서버에서 전달)
        var userTot = ${userTot};
        var atndlcUserList = [
            <c:forEach var="user" items="${atndlcUserList}" varStatus="vs">
                { userId: '${user.userId}'
                , usernm: '${user.usernm}'
                , lineNo: ${user.lineNo}
                , deptnm: '${user.deptnm}'
                , stdntNo: '${user.stdntNo}'}
                ${!vs.last ? ',' : ''}
            </c:forEach>
        ];

        // 선택 여부 분류
        var notSelectUser = atndlcUserList.slice(); // 초기엔 전원 미선택
        var selectedUser  = [];                     // 배치 된 학생은 해당 List에 담기게 됨

        // 수정 모드: 팀 및 팀원 목록 (서버 전달, 1행 = 1팀원)
        var teamAndMbrList = [
            <c:forEach var="item" items="${teamGrpVO}" varStatus="vs">
            { teamGrpId :    '${item.teamGrpId}'
            , teamGrpnm :    '${item.teamGrpnm}'
            , teamId :      '${item.teamId}'
            , teamnm :      '${item.teamnm}'
            , teamBbsUseyn: '${item.teamBbsUseyn}'
            , userId :      '${item.userId}'
            , ldryn :       '${item.ldryn}'
            , usernm :      '${item.usernm}'
            , stdntNo :     '${item.stdntNo}'
            , deptnm :      '${item.deptnm}' }${!vs.last ? ',' : ''}
            </c:forEach>
        ];

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initTeamGrpInfoListTable :     컬럼 정의 및 테이블 초기화
         * 2. createManageHtml :            manage 버튼 HTML 생성
         * 3. reindexRows :                 전체 row lineNo, teamnm, manage 재정렬
         * 4. curRowDelete:                 해당 row 삭제 후 전체 lineNo 재정렬
         *****************************************************************************/
        /* 1 */
        function initTeamGrpInfoListTable() {
            if (teamGrpInfoListTable) return;
            var columns = [
                {title:"teamId", field:"teamId", visible:false},
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='team.table.teamNm'/>", field:"teamnm", headerHozAlign:"center", hozAlign:"left",  width:0, minWidth:200},         /* 팀명 */
                {title:"<spring:message code='team.table.leaderNm'/>",  field:"leadernm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:100,    /* 팀장 */
                    // 배치 시 팀장 명 정하는 용도.. ldryn = 'Y' 인 요소 찾기
                    formatter: function(cell) {
                        var data        = cell.getRow().getData();
                        var usernms     = data.usernmList ? data.usernmList.split(',') : [];
                        var ldrynArr    = data.ldrynList ? data.ldrynList.split(',') : [];
                        var idx         = ldrynArr.indexOf('Y');
                        return idx >= 0 ? usernms[idx] : '';
                    }
                },
                {title:"<spring:message code='team.label.team.member.cnt'/>", field:"teamCnt", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:100},  /* 팀원 수 */
                {title:"<spring:message code='common.mgr'/>", field:"manage", headerHozAlign:"center", hozAlign:"center", width:160, minWidth:160}                  /* 관리 */
            ];
            teamGrpInfoListTable = UiTable("teamGrpList", {
                lang : "ko"
                , selectRow: "checkbox"
                , columns: columns
            });
        }
        /* 2 */
        function createManageHtml(teamSeq) {
            var html = "<a href='javascript:teamMbrPop(\"" + teamSeq + "\")' class='btn basic small'><spring:message code='common.button.modify'/></a>";    /* 수정 */
            if (usingyn !== 'Y') {
                html += "<a href='javascript:curRowDelete(\"" + teamSeq + "\")' class='btn basic small'><spring:message code='common.button.delete'/></a>"; /* 삭제 */
            } else {
                html += "<a class='btn basic small disabled' style='pointer-events:none; opacity:0.4;'><spring:message code='common.button.delete'/></a>";  /* 삭제 */
            }
            return html;
        }
        /* 3 */
        function reindexRows() {
            var rows = teamGrpInfoListTable.getRows();
            var total = rows.length;
            rows.forEach(function(row, idx) {
                var newLineNo = total - idx;
                var newSeq = 'LRNGR' + newLineNo;
                // leaderId, leadernm, teamCnt, teamList 은 기존 row 값 유지 (명시 안 하면 Tabulator가 보존)
                row.update({
                    teamSeq : newSeq
                    , lineNo  : newLineNo
                    , teamnm: 'TEAM' + newLineNo
                    , manage  : createManageHtml(newSeq)
                });
            });
        }
        /* 4 */
        function curRowDelete(teamSeq) {
            var rows = teamGrpInfoListTable.getRows();
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].getData().teamSeq === teamSeq) {
                    rows[i].delete();
                    break;
                }
            }
            reindexRows();
            $('#teamCount').val(teamGrpInfoListTable.getDataCount());
            syncAssignedUsers();
            updateSetTot();
        }

        /*****************************************************************************
         * 배치 관련 기능
         * 1. userAutoBatch :       자동 배치 (배정)
         * 2. syncAssignedUsers :   배치 이후 tabulator row의 teamList 기준으로 배치/미배치 목록 동기화
         * 3. updateSetTot :        배치 이후 현재 구성원 합계 갱신
         * 4. teamMbrPop:           [수동구성|수정] 팝업 수동구성은 미배치 수강생을, 수정은 미배치 수강생 및 row 에 세팅된 수강생을 보냄
         *****************************************************************************/
        /* 1 */
        function userAutoBatch() {
            autoAllocyn = 'Y';
            onTeamCountChange();
            var teamCount   = parseInt($('#teamCount').val());
            var userAddType = $('#userAddType').val();
            var perTeam     = Math.floor(userTot / teamCount);  // 팀당 기본 인원 계산
            var remainder   = userTot % teamCount;              // 남은 인원은 마지막 row에 전부 추가

            // 배정할 사용자 목록 복사
            var users = atndlcUserList.slice();

            if (userAddType === 'random') {
                // Fisher-Yates 셔플 (랜덤 셔플 기능)
                for (var i = users.length - 1; i > 0; i--) {
                    var j = Math.floor(Math.random() * (i + 1));
                    var tmp = users[i]; users[i] = users[j]; users[j] = tmp;
                }
            } else if (userAddType === 'name') {
                // 쿼리에서 이름순 정렬을 미리 해둬서 순번으로...
                users.sort(function(a, b) { return a.lineNo - b.lineNo; });
            }

            var rows = teamGrpInfoListTable.getRows();
            var userIdx = 0;
            var selected = [];

            rows.forEach(function(row, rowIdx) {
                var isLast = (rowIdx === rows.length - 1);
                var count  = isLast ? perTeam + remainder : perTeam;

                var teamList = [];
                for (var i = 0; i < count && userIdx < users.length; i++) {
                    teamList.push(users[userIdx++]);
                }

                var teamListStr         = teamList.map(function(u) {return u.userId;}).join(',');
                var usernmListStr       = teamList.map(function(u) {return u.usernm;}).join(',');
                var deptnmListStr       = teamList.map(function(u) {return u.deptnm;}).join(',');
                var stdntNoListStr      = teamList.map(function(u) {return u.stdntNo;}).join(',');
                var ldrynListStr        = teamList.map(function(u, idx) {return idx === 0 ? 'Y' : 'N';}).join(',');
                selected                = selected.concat(teamList);

                // ldrynList 기준으로 리더 이름 파생 (셀 재렌더링 트리거용)
                var ldrynArr    = ldrynListStr.split(',');
                var usernmArr   = usernmListStr.split(',');
                var leaderIdx   = ldrynArr.indexOf('Y');
                var leaderNm    = leaderIdx >= 0 ? usernmArr[leaderIdx] : '';

                row.update({
                    leadernm :          leaderNm
                    , teamCnt :         teamList.length
                    , teamList :        teamListStr
                    , usernmList :      usernmListStr
                    , deptnmList :      deptnmListStr
                    , stdntNoList :     stdntNoListStr
                    , ldrynList :       ldrynListStr
                });
            });

            syncAssignedUsers();
            updateSetTot();
        }
        /* 2 */
        function syncAssignedUsers() {
            // 전체 row의 teamList에서 배치된 userId 수집
            var assignedIds = [];
            teamGrpInfoListTable.getRows().forEach(function(row) {
                var teamList = row.getData().teamList;
                if (teamList) {
                    teamList.split(',').forEach(function(uid) {
                        if (uid) assignedIds.push(uid);
                    });
                }
            });

            selectedUser = atndlcUserList.filter(function(u) {
                return assignedIds.indexOf(u.userId) >= 0;
            });
            notSelectUser = atndlcUserList.filter(function(u) {
                return assignedIds.indexOf(u.userId) < 0;
            });
        }
        /* 3 */
        function updateSetTot() {
            var total = teamGrpInfoListTable.getRows().reduce(function(sum, row) {
                var data = row.getData();
                return sum + (parseInt(data.teamCnt) || 0);
            }, 0);
            $('#setTot').text(total);
        }
        /* 4 */
        function teamMbrPop(teamSeq) {
            isAdd = teamSeq ? 'N' : 'Y';

            if (isAdd === 'Y') {
                autoAllocyn = 'N';
            }

            if (isAdd === 'N') {
                // 관리 버튼(수정) - 현재 row 데이터 + 미배치 수강생 전달
                var rowData = null;
                var rows = teamGrpInfoListTable.getRows();
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].getData().teamSeq === teamSeq) {
                        rowData = rows[i].getData();
                        break;
                    }
                }
                window.teamMbrPopData = {
                    isAdd :             'N'
                    , teamSeq :         teamSeq
                    , teamnm :          rowData ? rowData.teamnm : ''
                    , teamList :        rowData ? rowData.teamList : ''
                    , usernmList :      rowData ? rowData.usernmList : ''
                    , deptnmList :      rowData ? rowData.deptnmList : ''
                    , stdntNoList :     rowData ? rowData.stdntNoList : ''
                    , ldrynList :       rowData ? rowData.ldrynList : ''
                    , notSelectUser :   notSelectUser
                };
            } else {
                // 수동 구성 버튼 - 미배치 수강생만 전달
                window.teamMbrPopData = {
                    isAdd :             'Y'
                    , notSelectUser :   notSelectUser
                };
            }

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='team.label.team.grp.set' />",     /* 팀 그룹지정 */
                width: 1600,
                height: 800,
                url: "/team/teamGrpSetTeamPopup.do",
                autoresize: false
            });
        }

        /* teamCount select 변경 시 row 추가/삭제 */
        function onTeamCountChange() {
            var newCount = parseInt($('#teamCount').val());
            var curCount = teamGrpInfoListTable.getDataCount();

            if (newCount > curCount) {
                // 맨 위에 row 추가 → 위에서부터 n,n-1,...,1 순서 유지
                for (var i = curCount; i < newCount; i++) {
                    var seq = 'LRNGR' + (i + 1);
                    teamGrpInfoListTable.addRow({
                        teamSeq :   seq
                        , teamId :  ''
                        , lineNo :  i + 1
                        , teamnm :  'TEAM' + (i + 1)
                        , manage :  createManageHtml(seq)
                    }, true);
                }
            } else if (newCount < curCount) {
                // 맨 위 row 삭제 (기존 데이터 유지)
                for (var i = curCount; i > newCount; i--) {
                    teamGrpInfoListTable.getRows()[0].delete();
                }
            }
        }

        /* 수정 모드 초기화 */
        function initModifyData() {
            if (isModify !== 'Y' || !teamAndMbrList || teamAndMbrList.length === 0) return;

            // 1. 0번째 인덱스로 공통 필드 세팅
            $('#teamGrpnm').val(teamAndMbrList[0].teamGrpnm);
            $('input[name="team-bbs-useyn-rd"][value="' + teamAndMbrList[0].teamBbsUseyn + '"]').prop('checked', true);

            // 2. teamId 기준으로 그룹핑
            var teamMap = {};
            var teamOrder = [];
            teamAndMbrList.forEach(function(item) {
                if (!teamMap[item.teamId]) {
                    teamMap[item.teamId] = {teamId: item.teamId, teamnm: item.teamnm, members: []};
                    teamOrder.push(item.teamId);
                }
                teamMap[item.teamId].members.push(item);
            });

            var teamCount = teamOrder.length;

            // 3. teamCount select box 값 세팅
            $('#teamCount').val(teamCount);

            // 4. 행 데이터 배열 구성 후 setData() 한 번에 로드
            var rowDataArray = [];
            teamOrder.forEach(function(teamId, idx) {
                var team    = teamMap[teamId];
                var members = team.members;
                var lineNo  = teamCount - idx;
                var seq     = 'LRNGR' + (idx + 1);

                var teamListStr         = members.map(function(m) {return m.userId;}).join(',');
                var usernmListStr       = members.map(function(m) {return m.usernm;}).join(',');
                var deptnmListStr       = members.map(function(m) {return m.deptnm;}).join(',');
                var stdntNoListStr      = members.map(function(m) {return m.stdntNo;}).join(',');
                var ldrynListStr        = members.map(function(m) {return m.ldryn;}).join(',');

                var ldrynArr    = ldrynListStr.split(',');
                var usernmArr   = usernmListStr.split(',');
                var leaderIdx   = ldrynArr.indexOf('Y');
                var leaderNm    = leaderIdx >= 0 ? usernmArr[leaderIdx] : '';

                rowDataArray.push({
                    teamSeq :           seq
                    , teamId :          teamId
                    , lineNo :          lineNo
                    , teamnm :          team.teamnm
                    , leadernm :        leaderNm
                    , teamCnt :         members.length
                    , teamList :        teamListStr
                    , usernmList :      usernmListStr
                    , deptnmList :      deptnmListStr
                    , stdntNoList :     stdntNoListStr
                    , ldrynList :       ldrynListStr
                    , manage :          createManageHtml(seq)
                });
            });

            teamGrpInfoListTable.setData(rowDataArray);

            // 5. notSelectUser, selectedUser 동기화
            syncAssignedUsers();
            updateSetTot();
        }

        /* 등록/수정 저장 */
        function teamGrpSave() {
            var url = isModify === 'N' ? '/team/teamGrpRegist.do' : '/team/teamGrpModify.do' ;

            // Case1. 팀 수 최소 2개 이상
            if (teamGrpInfoListTable.getDataCount() < 2) {
                UiComm.showMessage("<spring:message code='team.info.msg1' />", "info");    /* 팀은 최소 2개 이상이어야 합니다. */
                return;
            }

            // Case 2: 수강생 수와 구성원 수 일치 여부
            var setTot = parseInt($('#setTot').text()) || 0;
            var notSetTot = userTot - setTot;
            if (userTot !== setTot) {
                UiComm.showMessage("<spring:message code='team.info.msg2' /> \n(" + notSetTot + " <spring:message code='team.info.msg3' />)", "info"); /* 구성원의 수가 맞지 않습니다. */ /* 명 배치되지 않음. */
                return;
            }

            // 전송할 데이터 세팅
            var teamTot = teamGrpInfoListTable.getDataCount();
            var teamBbsUseyn = $('input[name="team-bbs-useyn-rd"]:checked').val() || 'N';

            var data = {
                sbjctId :           curSbjctId
                , teamGrpId :        '${teamGrpVO[0].teamGrpId}'
                , teamGrpnm :        $('#teamGrpnm').val()
                , teamBbsUseyn :    teamBbsUseyn
                , autoAllocyn :     autoAllocyn || 'N'
                , usingyn :         usingyn
            };

            // 팀 목록 수집 (List 형태임 백엔드 작성시 참고..)
            teamGrpInfoListTable.getRows().forEach(function(row, idx) {
                var d = row.getData();
                var prefix = 'teamDataList[' + idx + '].';
                data[prefix + 'teamId']         = d.teamId || '';
                data[prefix + 'teamnm']         = d.teamnm || '';
                // data[prefix + 'teamQuota']      = d.teamCnt || 0;
                data[prefix + 'teamTot']        = teamTot;
                data[prefix + 'autoAllocyn']    = autoAllocyn || 'N';
                data[prefix + 'teamBbsUseyn']   = teamBbsUseyn;
                data[prefix + 'teamList']       = d.teamList || '';     // ',' 구분 userId
                data[prefix + 'ldrynList']      = d.ldrynList || '';    // ',' 구분 ldryn
            });

            UiComm.showLoading(true);
            $.ajax({
                url :       url
                , async :   false
                , type :    'POST'
                , dataType :'json'
                , data :    data
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='info.regok.msg' />", "info")
                        .then(function() {
                            location.href = '/team/teamGrpMngListView.do?encParams=' + EPARAM;
                        });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function() {
                UiComm.showLoading(false);
                UiComm.showMessage(
                    isModify === 'N'
                        ? "<spring:message code='exam.error.update' />"     /* 수정 중 에러가 발생했습니다. */
                        : "<spring:message code='exam.error.insert' />",    /* 저장 중 에러가 발생했습니다. */
                    "error"

                );
            });
        }

        /* 목록으로 돌아가기 */
        function teamGrpListViewMv (teamGrpId, usingyn, sbjctId) {
            UiComm.showMessage("<spring:message code='team.gobck.list' />", "confirm")  /* 목록으로 돌아가시겠습니까? */
                .then(function(result) {
                    if (result) {
                        teamGrpMgrViewMv("list", teamGrpId, usingyn, sbjctId);
                    }
                });
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
            setTimeout(initModifyData, 0);  // 비동기 작업이 끝난 뒤 함수 실행

            // usingyn = 'Y' 제약 처리
            if (usingyn === 'Y') {
                $('#teamCount').prop('disabled', true);
            }
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
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <c:if test="${isModify eq 'N' or empty isModify}">
                                <h3 class="board-title"><spring:message code='team.label.team.grp.set' /> <spring:message code='common.button.create' /></h3><!-- 팀 그룹 --> <!-- 등록 -->
                            </c:if>
                            <c:if test="${isModify eq 'Y'}">
                                <h3 class="board-title"><spring:message code='team.label.team.grp.set' /> <spring:message code='common.button.modify' /></h3><!-- 팀 그룹 --> <!-- 수정 -->
                            </c:if>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick = "teamGrpSave()"><spring:message code='common.button.save' /></button><!-- 저장 -->
                                <button type="button" class="btn basic" onclick = "teamGrpListViewMv('', '', '${sbjctId}')"><spring:message code='common.button.list' /></button><!-- 목록 -->
                            </div>
                        </div>
                        <!-- 등록 영역 -->
                        <div class = "table-wrap">
                            <form id="teamGrpWrite" name="teamGrpWrite">
                                <table class = "table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                        <!-- 팀 그룹명 -->
                                        <tr>
                                            <th>
                                                <label for="lrn-grpnm-label" class="req"><spring:message code='team.label.grp.nm' /></label><!-- 팀그룹명 -->
                                            </th>
                                            <td class="t_left" colspan="3">
                                                <div class="form-row">
                                                    <input class="form-control width-50per"
                                                           type="text" name="name" id="teamGrpnm" value="${teamGrpVO[0].teamGrpnm}"
                                                           placeholder="<spring:message code='team.input.grp.nm' />" required="true" inputmask="byte"
                                                           maxlen="150" autocomplete="off"><!-- 팀 그룹명을 입력해주세요. -->
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팀 게시판 사용여부 -->
                                        <tr>
                                            <th>
                                                <label for="team-bbs-useyn-label" class="req"><spring:message code='team.write.field.teamBbs'/> <spring:message code='common.use.yn'/></label><!-- 팀 게시판 --> <!-- 사용여부 -->
                                            </th>
                                            <td class="t_left" colspan="3">
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="team-bbs-useyn-rd" id="team-bbs-y-rd" value="Y" ${teamGrpVO[0].teamBbsUseyn eq 'Y' || isModify eq 'N' ? 'checked' : '' }>
                                                        <label for="team-bbs-y-rd"><spring:message code='message.yes'/></label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" name="team-bbs-useyn-rd" id="team-bbs-n-rd" value="N" ${teamGrpVO[0].teamBbsUseyn eq 'N' ? 'checked' : '' }>
                                                        <label for="team-bbs-n-rd"><spring:message code='message.no'/></label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팀 그룹지정 -->
                                        <tr>
                                            <th>
                                                <label for="lrn-grp-label"><spring:message code='team.label.team.grp.set' /></label><!-- 팀 그룹지정 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <label for="team-count-label"><spring:message code='team.label.team.cnt'/></label><!-- 팀 수 -->
                                                    <select class="form-select" id="teamCount">
                                                        <c:forEach var="i" begin="2" end="${userTot div 2}">
                                                            <option value="${i}" ${i == 2 ? 'selected' : ''}>${i}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </td>
                                            <th>
                                                <label for="team-batch-label"><spring:message code='team.write.field.sortKey'/></label><!-- 수강생 배정 -->
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <select class="form-select" id="userAddType">
                                                        <option value="random"><spring:message code='team.write.field.random'/></option><!-- 임의 배정 -->
                                                        <option value="name"><spring:message code='team.write.field.userNm'/></option><!-- 이름순 배정 -->
                                                    </select>
                                                </div>
                                                <button type="button" class="btn type1" onclick="userAutoBatch()"><spring:message code='team.member.batch.auto'/></button><!-- 자동 구성 -->
                                                <c:if test="${usingyn eq 'N' or empty usingyn}">
                                                    <button type="button" class="btn type1" onclick="teamMbrPop()"><spring:message code='team.member.batch.manual'/></button><!-- 수동 구성 -->
                                                </c:if>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        <div class="board_top">
                            <span><spring:message code='team.grp.and.team.member'/> [ <spring:message code='common.label.students'/>  : ${userTot}, <spring:message code='team.label.curr.member'/> : <a id="setTot">0</a> ]</span><!-- 팀 그룹 및 팀 구성원 --> <!-- 수강생 --> <!-- 현재 구성원 -->
                            <div class="right-area">
                                <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='common.button.send'/></a><!-- 보내기 -->
                            </div>
                        </div>
                        <!-- 팀 그룹 목록 (list) -->
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
