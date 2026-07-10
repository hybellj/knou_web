<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
        var popData = window.parent.teamMbrPopData;
        var isAdd = popData.isAdd;
        var teamnm = '';
        var notSetUserListTable = null;
        var teamMemberListTable = null;

        // 팀명 세팅
        if (isAdd === 'N') {
            // 수정 - 기존 row 의 teamnm 사용
            teamnm = popData.teamnm;
        } else {
            // 신규 - TEAM001 형식 생성 (부모 창 현재 팀 수 + 1)
            var nextNo = window.parent.teamGrpInfoListTable.getDataCount() + 1;
            teamnm = 'TEAM' + ('00' + nextNo).slice(-3);
        }

        // 컬럼 정의 (테이블마다 독립 배열 반환)
        function getColumns() {
            return [
                {title: "No", field: "lineNo", headerHozAlign:"center", hozAlign:"center", width:50, minWidth:50},
                {title: "<spring:message code='common.dept_name'/>", field: "deptnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:100},                 /* 학과 */
                {title: "<spring:message code='common.label.student.number'/>", field: "stdntNo", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:80},    /* 학번 */
                {title: "<spring:message code='common.name'/>", field: "usernm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:80}                      /* 이름 */
            ];
        }

        /* 미배치 수강생 목록 tabulator 초기화 */
        function initNotSetUserListTable() {
            var users = popData.notSelectUser.map(function(u, idx) {
                return {
                    lineNo    : idx + 1
                    , userId    : u.userId
                    , usernm    : u.usernm
                    , deptnm    : u.deptnm
                    , stdntNo   : u.stdntNo
                };
            });
            notSetUserListTable = UiTable("notSetUserList", {
                lang     : "ko",
                selectRow: "checkbox",
                columns  : getColumns(),
                data     : users
            });
        }

        /* 현재 팀 구성원 목록 tabulator 초기화 */
        function initTeamMemberListTable() {
            var tableData = [];
            if (isAdd === 'N' && popData.teamList) {
                var userIds  = popData.teamList.split(',');
                var usernms  = popData.usernmList.split(',');
                var deptnms  = popData.deptnmList.split(',');
                var stdntNos = popData.stdntNoList.split(',');
                var ldrynArr = popData.ldrynList.split(',');

                tableData = userIds.map(function(uid, idx) {
                    var ldryn = ldrynArr[idx];
                    return {
                        lineNo      : idx + 1
                        , userId      : uid
                        , usernm      : usernms[idx]
                        , deptnm      : deptnms[idx]
                        , stdntNo     : stdntNos[idx]
                        , ldryn       : ldryn
                        , ldrynSwitch : "<input type='checkbox' class='switch small' " + (ldryn === 'Y' ? 'checked' : '') + ">"
                    };
                });
            }

            // teamMemberList 전용 컬럼: 공통 컬럼 + 팀장 스위치
            var teamColumns = getColumns();
            teamColumns.push({
                title: "<spring:message code='team.table.leaderNm'/>",  /* 팀장 */
                field: "ldrynSwitch",
                headerHozAlign: "center",
                hozAlign: "center",
                width: 70,
                minWidth: 70
            });

            teamMemberListTable = UiTable("teamMemberList", {
                lang     : "ko",
                selectRow: "checkbox",
                columns  : teamColumns,
                data     : tableData
            });
        }

		$(document).ready(function() {
            initNotSetUserListTable();
            initTeamMemberListTable();

            // teamnm input 초기값 세팅 (isAdd=N: 기존 row 팀명, isAdd=Y: 자동 생성 팀명)
            $('#teamnm').val(teamnm);

            // teamMemberList 팀장 switch change 이벤트
            $(document).on('change', '#teamMemberList .switch', function() {
                var $switch   = $(this);
                var isChecked = $switch.prop('checked');

                // 클릭된 switch 가 속한 Tabulator row 탐색
                var rows      = teamMemberListTable.getRows();
                var targetRow = null;
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].getElement().contains($switch[0])) {
                        targetRow = rows[i];
                        break;
                    }
                }
                if (!targetRow) return;

                // 전체 row 데이터 수집 후 ldryn 여부 따짐 replaceData 로 렌더링
                var newData = rows.map(function(row) {
                    var d = row.getData();
                    var newLdryn;
                    if (isChecked) {
                        newLdryn = (row === targetRow) ? 'Y' : 'N';
                    } else {
                        newLdryn = (row === targetRow) ? 'N' : d.ldryn;
                    }
                    return {
                        lineNo        : d.lineNo
                        , userId      : d.userId
                        , usernm      : d.usernm
                        , deptnm      : d.deptnm
                        , stdntNo     : d.stdntNo
                        , ldryn       : newLdryn
                        , ldrynSwitch : "<input type='checkbox' class='switch small'" + (newLdryn === 'Y' ? ' checked' : '') + ">"
                    };
                });

                teamMemberListTable.replaceData(newData);
            });
		});

        /* 미선택 수강생 리스트 검색 (deptnm, stdntNo, usernm LIKE 검색) */
        function userSelect() {
            var keyword = $('#searchValue').val().trim();
            notSetUserListTable.clearFilter();
            if (!keyword) return;

            notSetUserListTable.setFilter(function(data) {
                var kw = keyword.toLowerCase();
                return (data.deptnm  && data.deptnm.toLowerCase().indexOf(kw)  >= 0)
                    || (data.stdntNo && data.stdntNo.toLowerCase().indexOf(kw) >= 0)
                    || (data.usernm  && data.usernm.toLowerCase().indexOf(kw)  >= 0);
            });
        }

        /* 미선택 -> 팀 멤버로 데이터 이동 */
        function addTeamMbr() {
            var selected = notSetUserListTable.getSelectedRows();
            if (selected.length === 0) {
                UiComm.showMessage("<spring:message code='team.member.select.msg1'/>", "info"); /* 대상자를 선택하세요. */
                return;
            }

            // 선택된 유저를 teamMemberList 에 추가
            var currentTeam = teamMemberListTable.getRows().map(function(row) {
                return row.getData();
            });
            selected.forEach(function(row) {
                var d = row.getData();
                currentTeam.push({
                    lineNo       : 0          // 아래에서 재정렬
                    , userId     : d.userId
                    , usernm     : d.usernm
                    , deptnm     : d.deptnm
                    , stdntNo    : d.stdntNo
                    , ldryn      : 'N'
                    , ldrynSwitch: "<input type='checkbox' class='switch small'>"
                });
            });
            // lineNo 재정렬
            currentTeam.forEach(function(d, idx) { d.lineNo = idx + 1; });
            teamMemberListTable.replaceData(currentTeam);

            // 선택된 유저를 notSetUserList 에서 제거 후 lineNo 재정렬
            var selectedIds = selected.map(function(row) { return row.getData().userId; });
            var remaining = notSetUserListTable.getRows()
                .map(function(row) { return row.getData(); })
                .filter(function(d) { return selectedIds.indexOf(d.userId) < 0; });
            remaining.forEach(function(d, idx) { d.lineNo = idx + 1; });
            notSetUserListTable.replaceData(remaining);

            notSetUserListTable.clearFilter();
            $('#searchValue').val('');
        }

        /* 팀 멤버 ->  미선택 수강생으로 이동 */
        function delTeamMbr() {
            var selected = teamMemberListTable.getSelectedRows();
            if (selected.length === 0) {
                UiComm.showMessage("<spring:message code='team.member.select.msg1'/>", "info"); /* 대상자를 선택하세요. */
                return;
            }

            // 선택된 유저를 notSetUserList 에 추가
            var currentNotSet = notSetUserListTable.getRows().map(function(row) {
                return row.getData();
            });
            selected.forEach(function(row) {
                var d = row.getData();
                currentNotSet.push({
                    lineNo       : 0          // 아래에서 재정렬
                    , userId     : d.userId
                    , usernm     : d.usernm
                    , deptnm     : d.deptnm
                    , stdntNo    : d.stdntNo
                });
            });
            // lineNo 재정렬
            currentNotSet.forEach(function(d, idx) { d.lineNo = idx + 1; });
            notSetUserListTable.replaceData(currentNotSet);

            // 선택된 유저를 teamMemberList 에서 제거 후 lineNo 재정렬
            var selectedIds = selected.map(function(row) { return row.getData().userId; });
            var remaining = teamMemberListTable.getRows()
                .map(function(row) { return row.getData(); })
                .filter(function(d) { return selectedIds.indexOf(d.userId) < 0; });
            remaining.forEach(function(d, idx) { d.lineNo = idx + 1; });
            teamMemberListTable.replaceData(remaining);

            notSetUserListTable.clearFilter();
            $('#searchValue').val('');
        }

        function selectTeamCtgr() {
            // 팀 구성원 데이터 수집
            var teamData = teamMemberListTable.getRows().map(function(row) { return row.getData(); });

            // Case1. 최소 팀원 수 2명 이상
            if (teamData.length <= 1) {
                UiComm.showMessage("<spring:message code='team.member.select.msg2'/>", "info"); /* 최소 팀 멤버의 수는 2명 이상이여야 합니다. */
                return;
            }

            // Case2. 팀장(ldryn='Y') 1명 존재 여부
            var leaders = teamData.filter(function(d) { return d.ldryn === 'Y'; });
            if (leaders.length !== 1) {
                UiComm.showMessage("<spring:message code='team.member.select.msg3'/>", "info"); /* 팀장을 1명 지정해주세요. */
                return;
            }

            // Case3. 팀명 존재 여부
            var teamnmVal = $('#teamnm').val().trim();
            if (!teamnmVal) {
                UiComm.showMessage("<spring:message code='team.member.select.msg4'/>", "info"); /* 팀명을 입력해주세요. */
                return;
            }

            // 부모 페이지 row 에 세팅할 데이터 구성
            var teamListStr       = teamData.map(function(d) { return d.userId;     }).join(',');
            var usernmListStr     = teamData.map(function(d) { return d.usernm;     }).join(',');
            var deptnmListStr     = teamData.map(function(d) { return d.deptnm;     }).join(',');
            var stdntNoListStr    = teamData.map(function(d) { return d.stdntNo;    }).join(',');
            var ldrynListStr      = teamData.map(function(d) { return d.ldryn;      }).join(',');
            var leaderNm          = leaders[0].usernm;

            var parentTable = window.parent.teamGrpInfoListTable;

            if (isAdd === 'Y') {
                // 신규 row 추가
                var newLineNo = parentTable.getDataCount() + 1;
                var newSeq    = 'LRNGR' + newLineNo;
                parentTable.addRow({
                    teamSeq        : newSeq
                    , lineNo       : newLineNo
                    , teamnm     : teamnmVal
                    , leadernm     : leaderNm
                    , teamCnt      : teamData.length
                    , teamList     : teamListStr
                    , usernmList   : usernmListStr
                    , deptnmList   : deptnmListStr
                    , stdntNoList  : stdntNoListStr
                    , ldrynList    : ldrynListStr
                    , manage       : window.parent.createManageHtml(newSeq)
                }, true);
                window.parent.$('#teamCount').val(newLineNo);

            } else {
                // 기존 row 수정 (teamSeq 기준)
                var rows = parentTable.getRows();
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].getData().teamSeq === popData.teamSeq) {
                        rows[i].update({
                            teamnm       : teamnmVal
                            , leadernm     : leaderNm
                            , teamCnt      : teamData.length
                            , teamList     : teamListStr
                            , usernmList   : usernmListStr
                            , deptnmList   : deptnmListStr
                            , stdntNoList  : stdntNoListStr
                            , ldrynList    : ldrynListStr
                        });
                        break;
                    }
                }
            }

            // 부모 페이지 selectedUser / notSelectUser 동기화 및 합계 갱신
            window.parent.syncAssignedUsers();
            window.parent.updateSetTot();

            window.parent.closeDialog();
        }
	</script>

	<body class="modal-page">
        <div id="sub-content">
            <table class="table-type2">
                <tr>
                    <td colspan="2">
                        <table>
                            <colgroup>
                                <col style="width:45%">
                                <col style="width:10%">
                                <col style="width:45%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td class="t_top">
                                        <div class="board_top">
                                            <strong class="margin-3"><spring:message code='common.label.students'/></strong><!-- 수강생 -->
                                            <table class = "table-type1">
                                                <colgroup>
                                                    <col class="width-15per" />
                                                    <col class="" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <td class="t_left" colspan="3">
                                                            <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                                                            <button type="button" class="btn type1" onclick="userSelect()"><spring:message code='common.button.search'/></button><!-- 검색 -->
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div id="notSetUserArea">
                                            <div id="notSetUserList"></div>
                                        </div>
                                    </td>
                                    <td>
                                        <button type="button" class="btn gray1" onclick="addTeamMbr()"><spring:message code='common.button.add'/></button><!-- 추가 -->
                                        <button type="button" class="btn gray1" onclick="delTeamMbr()"><spring:message code='common.button.delete'/></button><!-- 삭제 -->
                                    </td>
                                    <td>
                                        <div class="board_top">
                                            <strong class="margin-3"><spring:message code='team.label.team.grp'/> > <spring:message code='team.button.teamWrite'/></strong><!-- 팀 그룹 --><!-- 팀 구성 -->
                                            <table class = "table-type1">
                                                <colgroup>
                                                    <col class="width-15per" />
                                                    <col class="" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>
                                                            <label for="lrn-grpnm-label" class="req"><spring:message code='team.label.grp.nm'/></label><!-- 팀 그룹명 -->
                                                        </th>
                                                        <td class="t_left" colspan="3">
                                                            <div class="form-row">
                                                                <input class="form-control width-50per"
                                                                       type="text" name="name" id="teamnm" value=""
                                                                       placeholder="<spring:message code='team.input.grp.nm'/>" required="true" inputmask="byte"
                                                                       maxlen="150" autocomplete="off"><!-- 팀 그룹명을 입력하세요. -->
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="teamMemberArea">
                                            <div id="teamMemberList"></div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
			<div class="btns">
                <button class="btn type2" onclick="selectTeamCtgr();"><spring:message code='team.common.save'/><!-- 선택 --></button>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='team.common.close'/><!-- 닫기 --></button>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
