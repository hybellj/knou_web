<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
        /* Tabulator 공통 페이징 */
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        /**
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType      = '<c:out value="${vo.tabType}" />';
        var curExamBscId    = '<c:out value="${vo.tkexamMthdCd eq 'RLTM' ? vo.examBscId : vo.quizBscId}" />';
        var curTkexamMthdCd = '<c:out value="${vo.tkexamMthdCd}" />';

        var curByteamSubrexamUseyn = '<c:out value="${vo.byteamSubrexamUseyn}" />';   // 팀 여부
        var hasSubSubject = '${examVO.teamGrpSubsbjctUseyn}';        // 부 주제
        var examInfoListTable = null; // 시험정보 및 평가 Tabulator - 탭 최초 활성화 시 생성

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initExamInfoListTable :    컬럼 정의 (대상자 전체 | 팀)
         * 2. createExamInfoListHtml :   각 컬럼에 들어갈 데이터 세팅 및 요소 생성
         * 3. loadExamInfoList :         컬럼에 들어갈 데이터 ajax 호출
         * 4. changeInfoListScale :      페이지 row수 세팅
         *****************************************************************************/
        /* 1 */
        function initExamInfoListTable() {
            if (examInfoListTable) return;
            var examScrTitle = curTkexamMthdCd === 'QUIZ' ? "<spring:message code='exam.label.quiz' /><spring:message code='exam.label.score' />"       /* 퀴즈 */ /* 점수 */
                                                            : "<spring:message code='exam.label.exam' /><spring:message code='exam.label.score' />";    /* 시험 */ /* 점수 */
            var examInfoColumns = curByteamSubrexamUseyn === 'Y' ? [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='exam.label.team.name' />", field:"teamnm", headerHozAlign:"center", hozAlign:"left",   width:140, minWidth:140},              /* 팀명 */
                {title:"<spring:message code='exam.label.dept' />", field:"deptnm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},                   /* 학과 */
                {title:"<spring:message code='exam.label.user.rprs.id' />",field:"userRprsId", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},        /* 대표아이디 */
                {title:"<spring:message code='exam.label.user.no' />", field:"stdntNo", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},               /* 학번 */
                {title:"<spring:message code='exam.label.user.nm' />", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},                  /* 이름 */
                {title:"<spring:message code='exam.label.team.role' />", field:"ldryn", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},                 /* 역할 */
                {title:examScrTitle, field:"examScr", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"<spring:message code='exam.label.eval.score' />", field:"totScr", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},               /* 평가점수 */
                {title:"<spring:message code='exam.label.stare.count' />", field:"tkexamCnt", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},           /* 응시횟수 */
                {title:"<spring:message code='exam.label.stare.situation' />", field:"tkexamCmptnyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, /* 응시상태 */
                {title:"<spring:message code='exam.label.eval.yn' />", field:"evlyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},                 /* 평가여부 */
                {title:"<spring:message code='exam.label.manage' />", field:"manage", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:600}                      /* 관리 */
            ] : [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='exam.label.dept' />", field:"deptnm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},                   /* 학과 */
                {title:"<spring:message code='exam.label.user.rprs.id' />",field:"userRprsId", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},        /* 대표아이디 */
                {title:"<spring:message code='exam.label.user.no' />",  field:"stdntNo", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},              /* 학번 */
                {title:"<spring:message code='exam.label.user.nm' />",  field:"usernm", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},                 /* 이름 */
                {title:examScrTitle, field:"examScr", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"<spring:message code='exam.label.eval.score' />", field:"totScr", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},               /* 평가점수 */
                {title:"<spring:message code='exam.label.stare.count' />", field:"tkexamCnt", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},           /* 응시횟수 */
                {title:"<spring:message code='exam.label.stare.situation' />", field:"tkexamCmptnyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, /* 응시상태 */
                {title:"<spring:message code='exam.label.eval.yn' />", field:"evlyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},                 /* 평가여부 */
                {title:"<spring:message code='exam.label.manage' />", field:"manage", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:600}                      /* 관리 */
            ];
            examInfoListTable = UiTable("examInfoList", {
                lang: "ko",
                selectRow: "checkbox",
                pageFunc: loadExamInfoList,
                columns: examInfoColumns
            });
        }
        /* 2 */
        function createExamInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 시험점수
                    var examScr = (v.examScr === 0 || v.examScr === "0") ? "-" : v.examScr;
                    // 평가점수
                    var totScr = v.totScr;
                    if(v.tkexamSdttm == null) { totScr = v.evlyn == "Y" ? v.totScr : "-"; }
                    // 평가여부
                    var evlyn = v.evlyn === 'Y' ? "<spring:message code='exam.label.eval.y' />"     /* 평가완료 */
                                                : "<span class='fcRed'><spring:message code='exam.label.eval.n' /></span>"; /* 미평가 */
                    // 응시상태
                    var tkexamCmptnGbnnmMap = {
                        "INIT"      : "<span class='fcOrange'><spring:message code='exam.label.no.stare' /></span>",    /* 미응시 */
                        "NOTKEXAM"  : "<span class='fcRed'><spring:message code='exam.label.no.stare' /></span>",       /* 미응시 */
                        "COMPLETED" : "<spring:message code='exam.label.complete.stare' />",                            /* 응시완료 */
                        "TKEXAMING" : "<span class='fcBlue'><spring:message code='exam.label.taking.stare' /></span>"   /* 응시중 */
                    };
                    var tkexamCmptnyn = tkexamCmptnGbnnmMap[v.tkexamCmptnGbncd] || "-";
                    // 관리 버튼
                    var manageBtns = "";
                    if (curTkexamMthdCd === 'RLTM') {
                        manageBtns += "<div style='display:flex;align-items:center;gap:0 3px'>";
                        manageBtns += "<a class='btn basic small'><spring:message code='exam.button.view.paper' /></a>"; /* 시험지 보기 */
                        manageBtns += "<a href='javascript:memoPopup(\"" + v.examDtlId + "\", \"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='exam.label.memo' /></a>"; /* 메모 */
                        manageBtns += "&nbsp;</div>"
                    } else {
                        manageBtns += "<div style='display:flex;align-items:center;gap:0 3px'>";
                        manageBtns += "<a href='javascript:quizExampprInit(\"" + v.tkexamId + "\", \"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='exam.label.quiz' /> <spring:message code='exam.button.init' /></a>";    /* 퀴즈 */ /* 초기화 */
                        if(v.tkexamSdttm != null) {
                            manageBtns += "<a href='javascript:quizExampprEvlPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='exam.button.view.paper' /></a>"; /* 시험지 보기 */
                        }
                        manageBtns += "<a href='javascript:examTkexamHstryPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='exam.button.stare.hsty' /></a>";   /* 응시기록 */
                        manageBtns += "<a href='javascript:memoPopup(\"" + v.examDtlId + "\", \"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='exam.label.memo' /></a>"; /* 메모 */
                        manageBtns += "&nbsp;</div>"
                    }

                    if (curByteamSubrexamUseyn === 'Y') {
                        // 역할 (팀인 경우)
                        var ldryn = v.ldryn === 'Y' ? "<spring:message code='exam.label.team.leader' />"    /* 팀장 */
                                                    : "<spring:message code='exam.label.team.member' />";   /* 팀원 */
                        dataList.push({
                            lineNo:         v.lineNo
                            , teamnm:       v.teamnm
                            , deptnm:       v.deptnm
                            , userRprsId:   v.userRprsId
                            , stdntNo:      v.stdntNo
                            , usernm:       v.usernm
                            , ldryn:        ldryn
                            , examScr:      examScr
                            , totScr:       totScr
                            , tkexamCmptnyn:tkexamCmptnyn
                            , tkexamCnt:    v.tkexamCnt + "<spring:message code='exam.label.times' />"  /* 회 */
                            , evlyn:        evlyn
                            , manage:       manageBtns
                            , examDtlId:    v.examDtlId
                            , tkexamId:     v.tkexamId
                            , userId:       v.userId
                        });
                    } else {
                        dataList.push({
                            lineNo:         v.lineNo
                            , deptnm:       v.deptnm
                            , userRprsId:   v.userRprsId
                            , stdntNo:      v.stdntNo
                            , usernm:       v.usernm
                            , examScr:      examScr
                            , totScr:       totScr
                            , tkexamCmptnyn:tkexamCmptnyn
                            , tkexamCnt:    v.tkexamCnt + "<spring:message code='exam.label.times' />"  /* 회 */
                            , evlyn:        evlyn
                            , manage:       manageBtns
                            , examDtlId:    v.examDtlId
                            , tkexamId:     v.tkexamId
                            , userId:       v.userId
                        });
                    }
                });
            }
            return dataList;
        }
        /* 3 */
        function loadExamInfoList(pageIndex) {
            initExamInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/tkexamUserPaging.do",
                type: "GET",
                data: {
                    examBscId           : curExamBscId,
                    byteamSubrexamUseyn : curByteamSubrexamUseyn,
                    tkexamCmptnyn       : $("#tkexamCmptnyn").val(),
                    evlyn    		    : $("#evlyn").val(),
                    searchValue 	    : $("#searchValue").val(),
                    pageIndex           : PAGE_INDEX,
                    listScale           : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createExamInfoListHtml(returnList);
                        examInfoListTable.clearData();
                        examInfoListTable.replaceData(dataList);
                        examInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    UiComm.showMessage("<spring:message code='exam.error.list' />", "error"); /* 리스트 조회 중 에러가 발생하였습니다. */
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }
        /* 4 */
        function changeInfoListScale(scale) {
            LIST_SCALE = scale;
            loadExamInfoList(1);
        }

        /*****************************************************************************
         * 점수 일괄 처리 관련 기능
         * 1. plusMinusIconControl :    점수 등록 <=> 점수 가감 타입 변경
         * 2. toggleIcon :              일괄 성적처리 +- 아이콘 변경
         * 3. toggleIconTrigger :       초기 Radio 버튼 클릭 이벤트
         * 4. EvlScrBulkModify  :       선택된 학습자에게 입력한 점수를 일괄 등록/가감
         *****************************************************************************/
        /* 1 */
        function plusMinusIconControl(scoreType){
            if(scoreType == 'batch'){
                $("#scr-toggle-icon").hide();
            }else if(scoreType == 'addition'){
                $("#scr-toggle-icon").show();
            }
        }
        /* 2 */
        function toggleIcon() {
            $('#scr-toggle-icon').click(function() {
                $(this).children("i").toggleClass("xi-plus xi-minus");
            });
        }
        /* 3 */
        function toggleIconTrigger() {
            $("#scoreBatch").trigger("click");
        }
        /* 4 */
        function EvlScrBulkModify() {
            let validator = UiValidator("scoreForm");
            validator.then(function(result) {
                if (result) {
                    if (examInfoListTable.getSelectedData("userId").length == 0) {
                        UiComm.showMessage("<spring:message code='exam.alert.batch.score.select' />", "info");
                        return;
                    }

                    var score = $("#scoreValue").val();
                    if ($("input[name='scoreType']:checked").val() == "addition") {
                        if (!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")) {
                            score = score * (-1);
                        }
                    }

                    var scrList = [];
                    for (var i = 0; i < examInfoListTable.getSelectedData("userId").length; i++) {
                        var scr = {
                            examDtlId : examInfoListTable.getSelectedData("examDtlId")[i],
                            tkexamId  : examInfoListTable.getSelectedData("tkexamId")[i],
                            userId    : examInfoListTable.getSelectedData("userId")[i],
                            scr       : score,
                            scoreType : $("input[name='scoreType']:checked").val()
                        };
                        scrList.push(scr);
                    }

                    $.ajax({
                        url: "/exam/profExamEvlScrBulkModifyAjax.do",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify(scrList),
                        dataType: "json",
                        beforeSend: function () {
                            UiComm.showLoading(true);
                        },
                        success: function (data) {
                            if (data.result > 0) {
                                UiComm.showMessage("<spring:message code='exam.alert.batch.score' />", "success");
                                $("#scoreValue").val("");
                                examTkexamListSelect();
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                            UiComm.showLoading(false);
                        },
                        error: function () {
                            UiComm.showMessage("<spring:message code='exam.error.batch.score' />", "error");
                        },
                        complete: function () {
                            UiComm.showLoading(false);
                        }
                    });
                }
            });
        }

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. var examDtlInfoList :     examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. examSubAsmtListAppend :   팀 시험 부주제 목록 HTML append
         *****************************************************************************/
        /* 1 */
		var examDtlInfoList = [
			<c:forEach var="dtlInfo" items="${examDtlInfoVO}" varStatus="st">
                {
                    teamGrpId    : '${fn:escapeXml(dtlInfo.teamGrpId)}',
                    teamGrpnm    : '${fn:escapeXml(dtlInfo.teamGrpnm)}',
                    teamId      : '${fn:escapeXml(dtlInfo.teamId)}',
                    teamnm      : '${fn:escapeXml(dtlInfo.teamnm)}',
                    ldrnm       : '${fn:escapeXml(dtlInfo.ldrnm)}',
                    examTtl     : '${fn:escapeXml(dtlInfo.examTtl)}',
                    examCts     : '${fn:escapeXml(dtlInfo.examCts)}',
                    teamMbrTot  : '${fn:escapeXml(dtlInfo.teamMbrTot)}'
                }
                <c:if test="${!st.last}">,</c:if>
			</c:forEach>
		];
		/* 2 */
        function examSubAsmtListAppend() {
            var html = "";
            if (examDtlInfoList.length > 0) {
                examDtlInfoList.forEach(function(v, i) {
                    html += "<tr>";
                    html += "	<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
                    html += "	<th><label><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></label></th>";   /* 팀 그룹 */ /* 구성원 */
                    html += "	<td>" + v.ldrnm + " <spring:message code='exam.label.and' /> " + (v.teamMbrTot - 1) + "<spring:message code='exam.label.stdnt' /></td>";    /* 외 */ /* 명 */
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.sub.tpc' /></label></th>";  /* 부 주제 */
                    html += "	<td>" + UiComm.escapeHtml(v.examTtl) + "</td>";
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.cts' /></label></th>";  /* 내용 */
                    html += "	<td><pre>" + $("<div>").html(v.examCts).text() + "</pre></td>";
                    html += "</tr>";
                });
            }
            $("#examSubsbjctbody").append(html);
        }

        /*****************************************************************************
         * 시험지 보기 버튼 생성 제어 기능
         * 1. var pprInfoList:  pprInfo 모델을 JS 배열로 변환
         * 2. onlnPprBtnAppend:     시험지 버튼 HTML append
         *****************************************************************************/
        /* 1 */
        var pprInfoList = [
            <c:forEach var="pprInfo" items="${pprInfo}" varStatus="st">
            {
                onlnExampprUrl  : '${fn:escapeXml(pprInfo.onlnExampprUrl)}',
                isActive        : '${fn:escapeXml(pprInfo.isActive)}',
                teamId          : '${fn:escapeXml(pprInfo.teamId)}',
                teamnm          : '${fn:escapeXml(pprInfo.teamnm)}'
            }
            <c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        /* 2 */
        function onlnPprBtnAppend() {
            var html = "";
            var isTeamExam = pprInfoList.length > 0 && pprInfoList[0].teamId !== '';
            /* 팀 시험: teamId가 존재하는 경우 */
            if (isTeamExam) {
                pprInfoList.forEach(function(v, i) {
                    html += "<a href='javascript:tkexamStatPop(" + "\"" + v.onlnExampprUrl + "\"" + ")' class='btn type1";
                    if (v.isActive === 'N') {
                        html += " disabled'";
                    } else {
                        html += "'";
                    }
                    html += ">" + v.teamnm + " <spring:message code='exam.label.std.paper' /></a>"; /* 의 시험지 */
                });
            } else {
                /* 일반 시험: teamId가 없는 경우 */
                pprInfoList.forEach(function(v, i) {
                    html += "<a href='javascript:tkexamStatPop(" + "\"" + v.onlnExampprUrl + "\"" + ")' class='btn type1";
                    if (v.isActive === 'N') {
                        html += " disabled'";
                    } else {
                        html += "'";
                    }
                    html += "><spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' /></a>"; /* 시험지 */ /* 미리보기 */
                });
            }
            $("#onlnPpr").append(html);
        }

        /*
         * 퀴즈 시험지 미리보기 버튼생성 기능
         */
        function quizPprBtnAppend() {
            var html = "<a href='javascript:quizExampprPreviewPopup(" + "\"" + curExamBscId + "\"" + ")' class='btn type1'><spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' /></a>";    /* 시험지 */ /* 미리보기 */
            $("#quizPpr").append(html);
        }

        /*****************************************************************************
         * 검색 영역 기능
         * 1. examTkexamListSelect :    수강생 검색
         * 2. resetListSelect :         수강생 전체 검색 및 검색영역 초기화
         *****************************************************************************/
        /* 1 */
        function examTkexamListSelect (){
            loadExamInfoList(1);
        }
        /* 2 */
        function resetListSelect() {
            $("#tkexamCmptnyn").val('').trigger('chosen:updated');
            $("#evlyn").val('').trigger("chosen:updated");
            $("#searchValue").val("");
            examTkexamListSelect();
        }

        /*****************************************************************************
         * 엑셀 관련 기능
         * 1. examTkexamStatusExcelDown:    시험 응시현황 엑셀 다운로드
         * 2.
         *****************************************************************************/
        /* 1 */
        function examTkexamStatusExcelDown() {
            var examScrTitle = curTkexamMthdCd === 'QUIZ' ? "<spring:message code='exam.label.quiz' /><spring:message code='exam.label.score' />"       /* 퀴즈 */ /* 점수 */
                                                            : "<spring:message code='exam.label.exam' /><spring:message code='exam.label.score' />";    /* 시험 */ /* 점수 */
            var ldrynObj = {
                Y: "<spring:message code='exam.label.team.leader' />"   /* 팀장 */
                , N: "<spring:message code='exam.label.team.member' />" /* 팀원 */
            };
            var tkexamCmptnObj = {
                INIT: "<spring:message code='exam.button.init' />"                  /* 초기화 */
                , NOTKEXAM: "<spring:message code='exam.label.no.stare' />"         /* 미응시 */
                , COMPLETED: "<spring:message code='exam.label.complete.stare' />"  /* 응시완료 */
                , TKEXAMING: "<spring:message code='exam.label.taking.stare' />"    /* 응시중 */
            };

            var excelGrid = { colModel: [] };

            excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'});
            if (curByteamSubrexamUseyn === 'Y') {
                excelGrid.colModel.push({label: '<spring:message code='exam.label.team.name' />', name: 'teamnm', align: 'left', width: '4000'});                   /* 팀명 */
            }
            excelGrid.colModel.push({label: '<spring:message code="exam.label.dept" />', name: 'deptnm', align: 'left', width: '5000'});                            /* 학과 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.user.rprs.id' />', name: 'userRprsId', align: 'left', width: '5000'});                /* 대표아이디 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.user.no" />', name: 'stdntNo', align: 'center', width: '5000'});                      /* 학번 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.user.nm" />', name: 'usernm', align: 'center', width: '5000'});                       /* 이름 */
            if (curByteamSubrexamUseyn === 'Y') {
                excelGrid.colModel.push({label: '<spring:message code='exam.label.team.role' />', name: 'ldryn', align: 'left', width: '5000', codes: ldrynObj});   /* 역할 */
            }
            excelGrid.colModel.push({label: examScrTitle, name: 'examScr', align: 'center', width: '3000'});
            excelGrid.colModel.push({label: '<spring:message code="exam.label.eval.score" />', name: 'totScr', align: 'center', width: '3000'});                    /* 평가점수 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.stare.situation" />', name: 'tkexamCmptnGbncd', align: 'left', width: '5000', codes: tkexamCmptnObj});    /* 응시상태 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.stare.count" />', name: 'tkexamCnt', align: 'center', width: '3000'});                /* 응시횟수 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.eval.yn" />', name: 'evlyn', align: 'left', width: '5000'});                          /* 평가여부 */

            var kvArr = [];

            kvArr.push({'key': 'examBscId',         'val': curExamBscId});
            kvArr.push({'key': 'tkexamCmptnyn',     'val': $("#tkexamCmptnyn").val()});
            kvArr.push({'key': 'evlyn',             'val': $("#evlyn").val()});
            kvArr.push({'key': 'searchValue',       'val': $("#searchValue").val()});
            kvArr.push({'key': 'excelGrid',         'val': JSON.stringify(excelGrid)});

            submitForm("/exam/profExamTkexamStatusExcelDown.do", "", "", kvArr);
        }

        /*****************************************************************************
         * 팝업 관련 기능
         * 1. examPieChartPop:              시험 응시현황 (파이)차트 팝업
         * 2. examHrChartPop:               시험 응시현황 (가로선)차트 팝업
         * 3. memoPopup:                    메모 보기 팝업
         * 4. examTkexamHstryPopup:         시험 응시이력 팝업
         * 5. excelScrRegistPopup :         엑셀 성적등록 팝업
         * 6. sendMsg :                     메세지 보내기
         * 7. quizExampprEvlPopup:          퀴즈시험지평가팝업
         * 8. quizExampprBulkPrintPopup:    퀴즈시험지일괄인쇄
         * 9. quizExampprPreviewPopup:      퀴즈시험지미리보기팝업
         *****************************************************************************/
        /* 1 */
        function examPieChartPop() {
            var data = "examBscId="+curExamBscId+"&sbjctId=${examVO.sbjctId}";

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.stare.status' />",     /* 응시현황 */
                width: 800,
                height: 500,
                url: "/exam/profExamUserTkexamStatusPieChartPopup.do?"+data,
                autoresize: true
            });
        }
        /* 2 */
        function examHrChartPop() {
            var data = "examBscId="+curExamBscId+"&sbjctId=${examVO.sbjctId}";

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.stare.status' />",     /* 응시현황 */
                width: 800,
                height: 500,
                url: "/exam/profExamUserTkexamStatusHrChartPopup.do?"+data,
                autoresize: true
            });
        }
        /* 3 */
        function memoPopup(examDtlId, tkexamId, userId) {
            var data = "examBscId="+curExamBscId+"&examDtlId="+examDtlId+"&tkexamId="+tkexamId+"&userId="+userId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.memo' />",     /* 메모 */
                width: 600,
                height: 350,
                url: "/exam/profExamMemoPopup.do?"+data
            });
        }
        /* 4 */
        function examTkexamHstryPopup(examDtlId, userId) {
            var data = "examDtlId="+examDtlId+"&userId="+userId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.button.stare.hsty' /> <spring:message code='exam.label.qstn.item' />",   /* 응시기록 */ /* 보기 */
                width: 800,
                height: 300,
                url: "/exam/profExamTkexamHstryPopup.do?"+data,
                autoresize: true
            });
        }
        /* 5 */
        function excelScrRegistPopup() {
            var data = "examBscId="+curExamBscId+"&sbjctId=${examVO.sbjctId}";

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.button.reg.excel.score' />", /* 엑셀 성적등록 */
                width: 600,
                height: 500,
                url: "/exam/profExamExcelScrRegistPopup.do?"+data,
                autoresize: true
            });
        }
        /* 6 */
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#examInfoList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (examInfoListTable.getSelectedData("userId").length == 0) {
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
        /* 7 */
        function quizExampprEvlPopup(examDtlId, userId) {
            const data = "examBscId="+curExamBscId+"&examDtlId="+examDtlId+"&userId="+userId+"&evlyn="+$("#evlyn").val()+"&tkexamCmptnyn=Y&searchValue="+$("#searchValue").val();

            dialog = UiDialog("dialog1", {
                title		: "<spring:message code='exam.label.paper.eval' />",    /* 시험지 및 평가 */
                url			: "/quiz/profQuizExampprEvlPopup.do?"+data,
                fullscreen	: true
            });
        }
        /* 8 */
        function quizExampprBulkPrintPopup() {
            const data = "examBscId="+curExamBscId+"&tkexamCmptnyn="+$("#tkexamCmptnyn").val()+"&evlyn="+$("#evlyn").val()+"&searchValue="+$("#searchValue").val();

            dialog = UiDialog("dialog1", {
                title		: "<spring:message code='exam.button.print.paper' />",  /* 시험지 인쇄 */
                width		: 600,
                height		: 500,
                url			: "/quiz/profQuizExampprBulkPrintPopup.do?"+data,
                autoresize	: true
            });
        }
        /* 9 */
        function quizExampprPreviewPopup(examBscId) {
            dialog = UiDialog("dialog1", {
                title		: "<spring:message code='exam.label.quiz' /><spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' />", /* 퀴즈 */ /* 시험지 */ /* 미리보기 */
                url			: "/quiz/profQuizExampprPreviewPopup.do?examBscId="+examBscId,
                fullscreen	: true
            });
        }

        /**
         * 퀴즈시험지 일괄 엑셀 다운로드
         */
        function quizExampprBlukExcelDown() {
            let kvArr = [];
            kvArr.push({'key' : 'examBscId', 	'val' : curExamBscId});
            kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

            submitForm("/quiz/profQuizExampprBulkExcelDown.do", "", "", kvArr);
        }

        /**
         * 시험 삭제
         * 응시자가 없을 경우에만 실행
         * 응시자가 있을 경우 경고 메시지를 출력한다.
         */
        function examDelete(examBscId, byteamSubrexamUseyn) {
            var url = "/exam/tkexamUserCount.do";
            var data = { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn };
            ajaxCall(url, data, function(data) {
                // 응시자가 있을 경우
                if (data.pageInfo.totalRecordCount > 0) {
                    UiComm.showMessage("<spring:message code='exam.confirm.exist.answer.user.y' />", "confirm") /* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            ajaxCall("/exam/examDelete.do", { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn }, function(data) {
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")   /* 정상 삭제 되었습니다. */
                                        .then(function() {
                                            location.href = "/exam/profExamListView.do?encParams=" + EPARAM;
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }, function(xhr, status, error) {
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error"); /* 삭제 중 에러가 발생하였습니다. */
                            }, true);
                        }
                    });
                } else {
                    UiComm.showMessage("<spring:message code='exam.confirm.exist.answer.user.n' />", "confirm") /* 응시한 학습자가 없습니다. 삭제하시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            ajaxCall("/exam/examDelete.do", { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn }, function(data) {
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")   /* 정상 삭제 되었습니다. */
                                        .then(function() {
                                            location.href = "/exam/profExamListView.do?encParams=" + EPARAM;
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }, function(xhr, status, error) {
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error"); /* 삭제 중 에러가 발생하였습니다. */
                            }, true);
                        }
                    });
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error"); /* 삭제 중 에러가 발생하였습니다. */
            });
        }

        /**
         * 퀴즈시험지초기화
         * @param {String}  tkexamId 	- 시험응시아이디
         * @param {String}  examBscId 	- 시험기본아이디
         * @param {String}  examDtlId 	- 시험상세아이디
         * @param {String}  userId 		- 사용자아이디
         */
        function quizExampprInit(tkexamId, examDtlId, userId) {
            if("${examVO.examQstnsCmptnyn}" == "Y") {
                UiComm.showMessage("<spring:message code='exam.confirm.init' />", "confirm")    /* 초기화를 하시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            UiComm.showLoading(true);
                            var url  = "/quiz/profQuizExampprInitAjax.do";
                            var data = {
                                "tkexamId"  : tkexamId,
                                "examBscId" : curExamBscId,
                                "examDtlId" : examDtlId,
                                "userId" 	: userId
                            };

                            $.ajax({
                                url 	  : url,
                                async	  : false,
                                type 	  : "POST",
                                dataType : "json",
                                data 	  : JSON.stringify(data),
                                contentType: "application/json; charset=UTF-8",
                            }).done(function(data) {
                                UiComm.showLoading(false);
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.init' />", "success"); /* 초기화가 완료 되었습니다. */
                                    quizTkexamListSelect();
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }).fail(function() {
                                UiComm.showLoading(false);
                                UiComm.showMessage("<spring:message code='exam.error.init' />", "error");   /* 초기화 중 에러가 발생하였습니다. */
                            });
                        }
                    });
            } else {
                UiComm.showMessage("<spring:message code='exam.alert.already.qstn.warn' />", "info");   /* 문제 출제 완료 후 가능합니다. */
            }
        }

		$(document).ready(function() {
            loadExamInfoList();

            toggleIcon();
            toggleIconTrigger();

            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }
            if (curTkexamMthdCd == 'RLTM') {
                onlnPprBtnAppend();
            } else {
                quizPprBtnAppend();
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
                    <!-- 콘텐츠 영역 -->
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="exam.label.exam" /><!-- 시험 -->
                            </h2>
                        </div>
                        <!-- 콘텐츠 상단 탭 버튼 영역 -->
                        <div class="listTab">
                            <ul>
                                <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                <li class="mw120 select" style = "pointer-events: none;">
                                    <a onclick="profExamViewMv(1)">
                                        <spring:message code='exam.label.exam' /><!-- 시험 -->
                                        <spring:message code='exam.label.info.score.manage' /><!-- 정보 및 평가 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(2)">
                                            <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                            <spring:message code='exam.label.sub' /><!-- 대체 -->
                                        </a>
                                    </li>
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(3)">
                                            <spring:message code='exam.label.info.absence' /><!-- 결시 내용 및 현황 -->
                                        </a>
                                    </li>
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(4)">
                                            <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                            <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                            <spring:message code='exam.label.support.stts' /><!-- 지원 현황 -->
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(5)">
                                            <spring:message code='exam.label.subs.quiz.manage' /><!-- 퀴즈 관리 -->
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                        <!-- 고정 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">
                                <spring:message code='exam.label.exam' /><!-- 시험 -->
                                <spring:message code='exam.label.info.score.manage' /><!-- 정보 및 평가 -->
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="profExamViewMv(9)"><spring:message code='exam.button.mod' /></button><!-- 수정 -->
                                <button type="button" class="btn type2" onclick="examDelete('${vo.examBscId}', '${examVO.byteamSubrexamUseyn}')"><spring:message code='exam.button.del' /></button><!-- 삭제 -->
                                <button type="button" class="btn basic" onclick="profExamViewMv(8)"><spring:message code='exam.button.list' /></button><!-- 목록 -->
                            </div>
                        </div>
                        <!-- [공통] 시험 정보 영역 -->
                        <!-- accordion -->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                                <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <div class="lecture_tit">
                                                <label class="label s_test mr5">${examVO.examGbnnm}</label><strong>${examVO.examTtl}</strong>
                                                <p class="desc">
                                                    <span><strong class="fcBlack">${examVO.tkexamMthdNm}</strong></span>
                                                    <span><spring:message code='exam.button.stare.start' /> <spring:message code='exam.label.period' /> :<strong><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></strong></span> <!-- 응시 --><!-- 기간 -->
                                                    <span><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> :<strong>${examVO.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
                                                    <span><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> :<strong>${examVO.mrkOyn eq 'Y' ? yes : no }</strong></span>
                                                </p>
                                            </div>
                                            <i class="arrow xi-angle-down"></i>
                                        </a>
                                    </div>
                                    <div class="cont">
                                        <table class="table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <tbody>
                                            <tr>
                                                <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험 구분 -->
                                                <td colspan="3">${examVO.examGbnnm}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.exam.type' /></th><!-- 시험 유형 -->
                                                <td colspan="3">${examVO.tkexamMthdNm}</td>
                                            </tr>
                                            <c:choose>
                                                <c:when test="${examVO.tkexamMthdCd eq 'RLTM'}">
                                                    <tr>
                                                        <th><spring:message code='exam.label.onln' /> <spring:message code='exam.label.paper' /></th><!-- 온라인 --> <!-- 시험지 -->
                                                        <td colspan="3" id="onlnPpr"></td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <th><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' /></th><!-- 퀴즈 --> <!-- 시험지 -->
                                                        <td colspan="3" id="quizPpr"></td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                            <tr>
                                                <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.cts' /></th><!-- 시험 --><!-- 내용 -->
                                                <td colspan="3">
                                                    <div class="tb_content">
                                                        ${examVO.examCts}
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.dttm' /></th><!-- 시험 --><!-- 일시 -->
                                                <td colspan="3"><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.time' /></th><!-- 시험 --><!-- 시간 -->
                                                <td colspan="3">${examVO.examMnts} <spring:message code='exam.label.min.time' /></td><!-- 분 -->
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.aply.y' /></th><!-- 성적 반영 -->
                                                <td>${examVO.mrkRfltyn eq 'Y' ? yes : no}</td>
                                                <th><spring:message code='exam.label.grade.score' /> <spring:message code='exam.label.score.aply.rate' /></th><!-- 성적 --><!-- 반영비율 -->
                                                <td>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt} %</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.score.open.y' /></th><!-- 성적 공개 -->
                                                <td colspan="3">${examVO.mrkOyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.paper.open' /></th><!-- 시험지 공개 -->
                                                <td colspan="3">${examVO.exampprOyn eq 'Y' ? yes : no}</td>
                                            </tr>
                                            <tr>
                                                <th><spring:message code='exam.label.team' /> <spring:message code='exam.label.exam' /></th><!-- 팀 --><!-- 시험 -->
                                                <td colspan="3" class="in_table">
                                                    <c:choose>
                                                        <c:when test="${examVO.byteamSubrexamUseyn eq 'Y' and not empty examDtlInfoVO}">
                                                            <div class="view_con">
                                                                    ${yes}<br>
                                                                <spring:message code='exam.label.team.grp' /> : ${examDtlInfoVO[0].teamGrpnm}<br><!-- 팀 그룹 -->
                                                                <spring:message code='exam.label.team.by' /> <spring:message code='exam.label.sub.tpc' /> <spring:message code='exam.label.use.yn' /> : ${examVO.teamGrpSubsbjctUseyn eq 'Y' ? yes : no}<!-- 팀별 --><!-- 부 주제 --><!-- 사용여부 -->
                                                            </div>
                                                            <!-- 팀별 부 주제 사용여부 -->
                                                            <c:if test="${examVO.teamGrpSubsbjctUseyn eq 'Y'}">
                                                                <div class="table-wrap mb30">
                                                                    <table class="table-type5 in-table">
                                                                        <colgroup>
                                                                            <col class="width-5per" />
                                                                            <col class="width-15per" />
                                                                            <col class="" />
                                                                        </colgroup>
                                                                        <tbody id="examSubsbjctbody">
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="view_con">${no}</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                                        or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                                        or examVO.examGbncd eq 'EXAM_MID'
                                                                                        or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></th><!-- 시험 --><!-- 대체 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.examSbstTynm}
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(2)">
                                                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.button.miss.status' /></th><!-- 결시 현황 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.absnceTot} <spring:message code='exam.label.nm' /><!-- 명 -->
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(3)" >
                                                                <spring:message code='exam.label.info.absence' /><!-- 결시 내용 및 현황 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.support.cnt' /></th><!-- 장애인 --><!-- 고령자 --><!-- 지원 인원 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.dsblTot} <spring:message code='exam.label.nm' /><!-- 명 -->
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(4)">
                                                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                                <spring:message code='exam.label.support.stts' /><!-- 지원 현황 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!-- 시험정보 및 평가 상단영역 -->
                        <div class="board_top mb0">
                            <h4 class="sub-title"><spring:message code='exam.label.exam' /><spring:message code='exam.label.eval.y' /></h4><!-- 시험 --><!-- 평가 -->
                            <div class="right-area">
                                <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                    <a href="javascript:excelScrRegistPopup()" class="btn basic small"><spring:message code="exam.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
                                </c:if>
                                <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='exam.button.eval.send' /></a><!-- 보내기 -->
                            </div>
                        </div>
                        <!-- 시험정보 및 평가 검색영역 -->
                        <div class="board_top in_table">
                            <select class="form-select" id="tkexamCmptnyn">
                                <option value=""><spring:message code='exam.label.answer.yn' /></option><!-- 응시여부 -->
                                <option value="all"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
                                <option value="N"><spring:message code='exam.label.no.stare' /></option><!-- 미응시 -->
                                <option value="Y"><spring:message code='exam.label.complete.stare' /></option><!-- 응시완료 -->
                            </select>
                            <select class="form-select" id="evlyn">
                                <option value=""><spring:message code='exam.label.eval.yn' /></option><!-- 평가여부 -->
                                <option value="all"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
                                <option value="Y"><spring:message code='exam.label.eval.y' /></option><!-- 평가 -->
                                <option value="N"><spring:message code='exam.label.eval.n' /></option><!-- 미평가 -->
                            </select>
                            <!-- search small -->
                            <div class="search-typeC">
                                <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                                <button type="button" class="btn basic icon search" onclick="examTkexamListSelect()"><i class="icon-svg-search"></i></button>
                            </div>
                            <button type="button" class="btn search" onclick="resetListSelect()"><spring:message code='exam.label.std' /> <spring:message code='exam.common.search.all' /></button><!-- 수강생 --><!-- 전체 -->
                        </div>


                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col class="" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><label><spring:message code='exam.label.reg.batch.scoring' /></label></th><!--일괄점수등록-->
                                        <td>
                                            <form id="scoreForm" onsubmit="return false;">
                                                <div class="form-inline">
                                                    <span class="custom-input">
                                                        <input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true" />
                                                        <label for="scoreBatch"><spring:message code='exam.label.reg.scoring' /></label><!-- 점수 등록 -->
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true" />
                                                        <label for="scoreAddition"><spring:message code='exam.label.plus.minus.scoring' /></label><!-- 점수 가감 -->
                                                    </span>
                                                    <div class="custom-txt">
                                                        <span class="tit"><spring:message code='exam.label.score' /> :</span><!-- 점수 -->
                                                        <button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
                                                        <div class="input_btn">
                                                            <input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
                                                            <label for="scoreValue"><spring:message code='exam.label.score.point' /></label><!-- 점 -->
                                                        </div>
                                                    </div>
                                                    <a href="javascript:EvlScrBulkModify()" class="btn type1"><spring:message code='exam.button.save' /></a><!-- 저장 -->
                                                </div>
                                            </form>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <div class="right-area">
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                    <a class="btn type2"><spring:message code='exam.label.real.time.exam' /> <spring:message code='exam.label.exam.scoring' /></a><!-- 실시간시험 --><!-- 채점 -->
                                    <a href="javascript:examTkexamStatusExcelDown()" class="btn type1"><spring:message code='exam.button.excel.down' /></a><!-- 엑셀 다운로드 -->
                                    <a href="javascript:examHrChartPop()" class="btn type2"><spring:message code='exam.label.distribution.grades' /></a><!-- 성적분포도 -->
                                </c:if>
                                <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                    <a href="javascript:quizExampprBulkPrintPopup()" class="btn type2"><spring:message code='exam.button.batch.print.paper' /></a><!-- 시험지 일괄 인쇄 -->
                                    <a href="javascript:quizExampprBlukExcelDown()" class="btn type1"><spring:message code='exam.button.batch.excel.down.paper' /></a><!-- 시험지 일괄 엑셀 다운로드 -->
                                    <a href="javascript:examTkexamStatusExcelDown()" class="btn type1"><spring:message code='exam.button.excel.down' /></a><!-- 엑셀 다운로드 -->
                                    <a href="javascript:examPieChartPop()" class="btn type2"><spring:message code='exam.label.stare.status' /> <spring:message code='exam.label.graph' /></a><!-- 응시현황 --><!-- 그래프 -->
                                </c:if>
                                <uiex:listScale func="changeInfoListScale" value="10" />
                            </div>
                        </div>
                        <div id = "examListArea">
                            <div id="examInfoList"></div>
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
