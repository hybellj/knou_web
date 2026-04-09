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
        var lrnGrpInfoListTable = null;

        // 수강생 전체 목록 (서버에서 전달)
        var userTot = ${userTot};
        var atndlcUserList = [
            <c:forEach var="user" items="${atndlcUserList}" varStatus="vs">
            {userId: '${user.userId}', usernm: '${user.usernm}', lineNo: ${user.lineNo}}${!vs.last ? ',' : ''}
            </c:forEach>
        ];

        // 선택 여부 분류 (수동 배정 등 추후 활용)
        var notSelectUser = atndlcUserList.slice(); // 초기엔 전원 미선택
        var selectedUser  = [];

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initLrnGrpInfoListTable :     컬럼 정의 및 테이블 초기화
         * 2. createManageHtml :            manage 버튼 HTML 생성
         * 3. reindexRows :                 전체 row lineNo, lrnGrpnm, manage 재정렬
         * 4. curRowDelete:                 해당 row 삭제 후 전체 lineNo 재정렬
         *****************************************************************************/
        /* 1 */
        function initLrnGrpInfoListTable() {
            if (lrnGrpInfoListTable) return;
            var columns = [
                {title:"No",   field:"lineNo",     headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"팀 명", field:"lrnGrpnm",   headerHozAlign:"center", hozAlign:"left",  width:0, minWidth:200},
                {title:"팀장",  field:"leadernm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:100},
                {title:"팀원 수",  field:"teamCnt",    headerHozAlign:"center", hozAlign:"center", width:0, minWidth:100},
                {title:"관리",  field:"manage",     headerHozAlign:"center", hozAlign:"center", width:160, minWidth:160}
            ];
            lrnGrpInfoListTable = UiTable("lrnGrpList", {
                lang: "ko",
                selectRow: "checkbox",
                columns: columns
            });
        }
        /* 2 */
        function createManageHtml(teamSeq) {
            return "<a href='javascript:curRowModify(\"" + teamSeq + "\")' class='btn basic small'>수정</a>"
                 + "<a href='javascript:curRowDelete(\"" + teamSeq + "\")' class='btn basic small'>삭제</a>";
        }
        /* 3 */
        function reindexRows() {
            var rows = lrnGrpInfoListTable.getRows();
            var total = rows.length;
            rows.forEach(function(row, idx) {
                var newLineNo = total - idx;
                var newSeq    = 'LRNGR' + newLineNo;
                // leaderId, leadernm, teamCnt, teamList 은 기존 row 값 유지 (명시 안 하면 Tabulator가 보존)
                row.update({
                    teamSeq : newSeq
                    , lineNo  : newLineNo
                    , lrnGrpnm: 'TEAM' + newLineNo
                    , manage  : createManageHtml(newSeq)
                });
            });
        }
        /* 4 */
        function curRowDelete(teamSeq) {
            if (lrnGrpInfoListTable.getDataCount() <= 2) {
                UiComm.showMessage("팀은 최소 2개 이상이어야 합니다.", "info");
                return;
            }
            var rows = lrnGrpInfoListTable.getRows();
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].getData().teamSeq === teamSeq) {
                    rows[i].delete();
                    break;
                }
            }
            reindexRows();
            $('#teamCount').val(lrnGrpInfoListTable.getDataCount());
            updateSetTot();
        }

        /* 자동 배정 */
        function userAutoBatch() {
            var teamCount   = parseInt($('#teamCount').val());
            var userAddType = $('#userAddType').val();
            var perTeam     = Math.floor(userTot / teamCount);  // 팀당 기본 인원
            var remainder   = userTot % teamCount;              // 나머지 → 마지막 row에 추가

            // 배정할 사용자 목록 복사
            var users = atndlcUserList.slice();

            if (userAddType === 'random') {
                // Fisher-Yates 셔플
                for (var i = users.length - 1; i > 0; i--) {
                    var j = Math.floor(Math.random() * (i + 1));
                    var tmp = users[i]; users[i] = users[j]; users[j] = tmp;
                }
            } else if (userAddType === 'name') {
                // SQL에서 이미 이름순(lineNo)으로 정렬되어 있으므로 lineNo 오름차순 정렬
                users.sort(function(a, b) { return a.lineNo - b.lineNo; });
            }

            var rows     = lrnGrpInfoListTable.getRows(); // 위→아래: lineNo n...1
            var userIdx  = 0;
            var selected = [];

            rows.forEach(function(row, rowIdx) {
                var isLast = (rowIdx === rows.length - 1);
                var count  = isLast ? perTeam + remainder : perTeam;

                var teamList = [];
                for (var i = 0; i < count && userIdx < users.length; i++) {
                    teamList.push(users[userIdx++]);
                }

                var leader       = teamList.length > 0 ? teamList[0] : null;
                var teamListStr  = teamList.map(function(u) { return u.userId; }).join(',');
                selected         = selected.concat(teamList);

                row.update({
                    leaderId : leader ? leader.userId : ''
                    , leadernm : leader ? leader.usernm : ''
                    , teamCnt  : teamList.length
                    , teamList : teamListStr
                });
            });

            // 선택/미선택 목록 갱신
            selectedUser  = selected;
            notSelectUser = atndlcUserList.filter(function(u) {
                return !selected.some(function(s) { return s.userId === u.userId; });
            });

            updateSetTot();
        }

        /* 현재 구성원 합계 갱신 */
        function updateSetTot() {
            var total = lrnGrpInfoListTable.getRows().reduce(function(sum, row) {
                var data = row.getData();
                console.log('[updateSetTot] lineNo:', data.lineNo,
                    '| leaderId:', data.leaderId,
                    '| teamCnt:', data.teamCnt,
                    '| teamList:', data.teamList);
                return sum + (parseInt(data.teamCnt) || 0);
            }, 0);
            console.log('[updateSetTot] 총 구성원 합계:', total);
            $('#setTot').text(total);
        }

        /* teamCount select 변경 시 row 추가/삭제 */
        function onTeamCountChange() {
            var newCount = parseInt($('#teamCount').val());
            var curCount = lrnGrpInfoListTable.getDataCount();

            if (newCount > curCount) {
                // 맨 위에 row 추가 → 위에서부터 n,n-1,...,1 순서 유지
                for (var i = curCount; i < newCount; i++) {
                    var seq = 'LRNGR' + (i + 1);
                    lrnGrpInfoListTable.addRow({
                        teamSeq : seq
                        , lineNo  : i + 1
                        , lrnGrpnm: 'TEAM' + (i + 1)
                        , manage  : createManageHtml(seq)
                    }, true);
                }
            } else if (newCount < curCount) {
                // 맨 위 row 삭제 (기존 데이터 유지)
                for (var i = curCount; i > newCount; i--) {
                    lrnGrpInfoListTable.getRows()[0].delete();
                }
            }
        }

        $(document).ready(function() {
            console.log('isModify ? : ' + isModify);

            initLrnGrpInfoListTable();

            $('#teamCount').on('change', function() {
                onTeamCountChange();
            });
        });
	</script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
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
                            <li><span class="current">시험</span></li>
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
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info"><span>공지</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>Q&A</span><div class="num_txt point">17</div></a>
                                    <a href="#0" class="info"><span>1:1</span><div class="num_txt point">3</div></a>
                                    <a href="#0" class="info"><span>과제</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>토론</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>세미나</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>설문</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>시험</span><div class="num_txt">2</div></a>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point"><span class="tit">중간고사:</span><span>2025.04.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                    <div class="info">
                                        <p class="point"><span class="tit">기말고사:</span><span>2025.07.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">
                            <div class="flex">
                                <div class="item week">
                                    <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                    <div class="item_tit">2025.04.14 ~ 04.20</div>
                                    <div class="item_info"><span class="big">7</span><span class="small">주차</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">학습그룹지정</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick = "lrnGrpMgrViewMv('', curSbjctId)">등록</button>
                                <!-- 목록 스케일 선택 -->
                                <uiex:listScale func="changeListScale" value="10" />
                            </div>
                        </div>
                        <!-- 등록 영역 -->
                        <div class = "table-wrap">
                            <form id="lrnGrpWrite" name="lrnGrpWrite">
                                <table class = "table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col class="" />
                                    </colgroup>
                                    <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                    <tbody>
                                        <!-- 학습그룹명 -->
                                        <tr>
                                            <th>
                                                <label for="lrn-grpnm-label" class="req">학습그룹명</label>
                                            </th>
                                            <td class="t_left" colspan="3">
                                                <div class="form-row">
                                                    <input class="form-control width-50per"
                                                           type="text" name="name" id="lrnGrpnm" value="${lrnGrpVO.lrnGrpnm}"
                                                           placeholder="학습그룹명을 입력하세요." required="true" inputmask="byte"
                                                           maxlen="150" autocomplete="off">
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팀 게시판 사용여부 -->
                                        <tr>
                                            <th>
                                                <label for="team-bbs-useyn-label" class="req">팀 게시판 사용</label>
                                            </th>
                                            <td class="t_left" colspan="3">
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="team-bbs-useyn-rd" id="team-bbs-y-rd" value="Y" ${lrnGrpVO.teamBbsUseyn eq 'RLTM' || isModify eq 'N' ? 'checked' : '' }>
                                                        <label for="team-bbs-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" name="team-bbs-useyn-rd" id="team-bbs-n-rd" value="N" ${lrnGrpVO.teamBbsUseyn eq 'QUIZ' ? 'checked' : '' }>
                                                        <label for="team-bbs-n-rd">아니오</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 학습그룹지정 -->
                                        <tr>
                                            <th>
                                                <label for="lrn-grp-label">학습그룹지정</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <label for="team-count-label">팀 수</label>
                                                    <select class="form-select" id="teamCount">
                                                        <c:forEach var="i" begin="2" end="${userTot div 2}">
                                                            <option value="${i}" ${i == 2 ? 'selected' : ''}>${i}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </td>
                                            <th>
                                                <label for="team-batch-label">수강생 배정</label>
                                            </th>
                                            <td>
                                                <div class="form-inline">
                                                    <select class="form-select" id="userAddType">
                                                        <option value="random">임의 배정</option>
                                                        <option value="name">이름순 배정</option>
                                                    </select>
                                                </div>
                                                <button type="button" class="btn type1" onclick="userAutoBatch()">자동 구성</button>
                                                <button type="button" class="btn type1" onclick="userManualBatch()">수동 구성</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        <div class="board_top">
                            <span>학습그룹 및 팀 구성원 [ 수강생 : ${userTot}, 현재 구성원 : <a id="setTot">0</a> ]</span>
                        </div>
                        <!-- 학습 그룹 목록 (list) -->
                        <div id="lrnGrpListArea">
                            <div id="lrnGrpList"></div>
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
