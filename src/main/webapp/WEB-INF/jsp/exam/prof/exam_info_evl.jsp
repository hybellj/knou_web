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
        var curTabType   = '${vo.tabType}';
        var curExamBscId = '${vo.examBscId}';
        var curTkexamMthdCd = '${vo.tkexamMthdCd}';

        var curByteamSubrexamUseyn = '${vo.byteamSubrexamUseyn}';   // 팀 여부
        var hasSubSubject = '${examVO.lrnGrpSubsbjctUseyn}';        // 부 주제
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
            var examScrTitle = curTkexamMthdCd === 'QUIZ' ? "퀴즈점수" : "시험점수";
            var examInfoColumns = curByteamSubrexamUseyn === 'Y' ? [
                {title:"No",       field:"lineNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"팀명",     field:"teamnm",        headerHozAlign:"center", hozAlign:"left",   width:140, minWidth:140},
                {title:"학과",     field:"deptnm",        headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"대표아이디",field:"userRprsId",    headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"학번",     field:"stdntNo",        headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"이름",     field:"usernm",        headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"역할",     field:"ldryn",         headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:examScrTitle, field:"examScr",       headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"평가점수", field:"totScr",        headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"응시횟수", field:"tkexamCnt",     headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"응시상태", field:"tkexamCmptnyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"평가여부", field:"evlyn",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"관리",    field:"manage",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:600}
            ] : [
                {title:"No",      field:"lineNo",        headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"학과",     field:"deptnm",        headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"대표아이디",field:"userRprsId",    headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},
                {title:"학번",     field:"stdntNo",        headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"이름",     field:"usernm",        headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:examScrTitle, field:"examScr",       headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"평가점수", field:"totScr",        headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"응시횟수", field:"tkexamCnt",     headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                {title:"응시상태", field:"tkexamCmptnyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"평가여부", field:"evlyn",         headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"관리",    field:"manage",         headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:600}
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
                    var evlyn = v.evlyn === 'Y' ? "평가완료" : "<span class='fcRed'>미평가</span>";
                    // 응시상태
                    var tkexamCmptnGbnnmMap = {
                        "INIT"      : "<span class='fcOrange'>미응시</span>",
                        "NOTKEXAM"  : "<span class='fcRed'>미응시</span>",
                        "COMPLETED" : "응시완료",
                        "TKEXAMING" : "<span class='fcBlue'>응시중</span>"
                    };
                    var tkexamCmptnyn = tkexamCmptnGbnnmMap[v.tkexamCmptnGbncd] || "-";
                    // 관리 버튼
                    var manageBtns = "";
                    if (curTkexamMthdCd === 'RLTM') {
                        manageBtns += "<a class='btn basic small'>시험지보기</a>"
                        manageBtns += "<a href='javascript:memoPopup(\"" + v.examDtlId + "\", \"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'>메모</a>"
                    } else {
                        manageBtns += "<a class='btn basic small'>퀴즈초기화</a>"
                        manageBtns += "<a class='btn basic small'>시험지보기</a>"
                        manageBtns += "<a href='javascript:examTkexamHstryPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'>응시기록</a>"
                        manageBtns += "<a href='javascript:memoPopup(\"" + v.examDtlId + "\", \"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'>메모</a>"
                    }

                    if (curByteamSubrexamUseyn === 'Y') {
                        // 역할 (팀인 경우)
                        var ldryn = v.ldryn === 'Y' ? "팀장" : "팀원";
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
                            , tkexamCnt:    v.tkexamCnt + "회"
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
                            , tkexamCnt:    v.tkexamCnt + "회"
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
                    alert("에러가 발생했습니다!");
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
                        UiComm.showMessage("일괄 성적처리할 학습자를 선택해주세요.", "info");
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
         * 아코디언 관련 기능
         * 1. setAccordion :    아코디언 기능 주입
         * 2. eventAccordion :  아코디언 이벤트 로직
         *****************************************************************************/
        /* 1 */
        function setAccordion() {
            $(".accordion").accordion();
        }
        /* 2 */
        function eventAccordion() {
            const title = document.querySelector('.accordion .title');
            document.querySelector('.accordion .title').addEventListener('click', () => {
                const content = title.nextElementSibling;
                content.classList.toggle('hide');
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
                    lrnGrpId    : '${fn:escapeXml(dtlInfo.lrnGrpId)}',
                    lrnGrpnm    : '${fn:escapeXml(dtlInfo.lrnGrpnm)}',
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
					html += "	<th>" + v.lrnGrpnm + "</th>";
					html += "	<td>";
					html += "		<table class='table-type2'>";
					html += "			<colgroup>";
					html += "				<col class='width-10per' />";
					html += "				<col class='' />";
					html += "			</colgroup>";
					html += "			<tbody>";
					html += "				<tr>";
					html += "					<th>주제</th>";
					html += "					<td class='t_left'>" + v.examTtl + "</td>";
					html += "				</tr>";
					html += "				<tr>";
					html += "					<th>내용</th>";
					html += "					<td class='t_left'><pre>" + $("<div>").html(v.examCts).text() + "</pre></td>";
					html += "				</tr>";
					html += "			</tbody>";
					html += "		</table>";
					html += "	</td>";
                    html += "	<td>" + v.ldrnm + " 외 " + (v.teamMbrTot - 1) + " 명" +"</td>";
					html += "</tr>";
				});
			}
			$("#examSubsbjctbody").append(html);
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
            var examScrTitle = curTkexamMthdCd === 'QUIZ' ? "퀴즈점수" : "시험점수";
            var ldrynObj = {
                Y: "팀장", N: "팀원"
            };
            var tkexamCmptnObj = {
                INIT: "초기화"
                , NOTKEXAM: "미응시"
                , COMPLETED: "응시완료"
                , TKEXAMING: "응시중"
            };

            var excelGrid = { colModel: [] };

            excelGrid.colModel.push({label: 'No.',      name: 'lineNo',             align: 'center',    width: '1000'});
            if (curByteamSubrexamUseyn === 'Y') {
                excelGrid.colModel.push({label: '팀명', name: 'teamnm',             align: 'left',      width: '4000'});
            }
            excelGrid.colModel.push({label: '학과',     name: 'deptnm',             align: 'left',      width: '5000'});
            excelGrid.colModel.push({label: '대표아이디', name: 'userRprsId',        align: 'left',      width: '5000'});
            excelGrid.colModel.push({label: '학번',     name: 'stdntNo',            align: 'center',    width: '5000'});
            excelGrid.colModel.push({label: '이름',     name: 'usernm',             align: 'center',    width: '5000'});
            if (curByteamSubrexamUseyn === 'Y') {
                excelGrid.colModel.push({label: '역할', name: 'ldryn',              align: 'left',      width: '5000',  codes: ldrynObj});
            }
            excelGrid.colModel.push({label: examScrTitle, name: 'examScr',          align: 'center',    width: '3000'});
            excelGrid.colModel.push({label: '평가점수', name: 'totScr',             align: 'center',    width: '3000'});
            excelGrid.colModel.push({label: '응시상태', name: 'tkexamCmptnGbncd',   align: 'left',      width: '5000',  codes: tkexamCmptnObj});
            excelGrid.colModel.push({label: '응시횟수', name: 'tkexamCnt',          align: 'center',    width: '3000'});
            excelGrid.colModel.push({label: '평가여부', name: 'evlyn',              align: 'left',      width: '5000'});

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
         * 1. examPieChartPop:      시험 응시현황 (파이)차트 팝업
         * 2. examHrChartPop:       시험 응시현황 (가로선)차트 팝업
         * 3. memoPopup:            메모 보기 팝업
         * 4. examTkexamHstryPopup: 시험 응시이력 팝업
         * 5. excelScrRegistPopup : 엑셀 성적등록 팝업
         * 6. sendMsg :             메세지 보내기
         *****************************************************************************/
        /* 1 */
        function examPieChartPop() {
            var data = "examBscId=${vo.examBscId}&sbjctId=${examVO.sbjctId}";

            dialog = UiDialog("dialog1", {
                title: "응시현황",
                width: 800,
                height: 500,
                url: "/exam/profExamUserTkexamStatusPieChartPopup.do?"+data,
                autoresize: true
            });
        }
        /* 2 */
        function examHrChartPop() {
            var data = "examBscId=${vo.examBscId}&sbjctId=${examVO.sbjctId}";

            dialog = UiDialog("dialog1", {
                title: "응시현황",
                width: 800,
                height: 500,
                url: "/exam/profExamUserTkexamStatusHrChartPopup.do?"+data,
                autoresize: true
            });
        }
        /* 3 */
        function memoPopup(examDtlId, tkexamId, userId) {
            var data = "examBscId=${vo.examBscId}&examDtlId="+examDtlId+"&tkexamId="+tkexamId+"&userId="+userId;

            dialog = UiDialog("dialog1", {
                title: "메모",
                width: 600,
                height: 350,
                url: "/exam/profExamMemoPopup.do?"+data
            });
        }
        /* 4 */
        function examTkexamHstryPopup(examDtlId, userId) {
            var data = "examDtlId="+examDtlId+"&userId="+userId;

            dialog = UiDialog("dialog1", {
                title: "응시기록 보기",
                width: 800,
                height: 300,
                url: "/exam/profExamTkexamHstryPopup.do?"+data,
                autoresize: true
            });
        }
        /* 5 */
        function excelScrRegistPopup() {
            var data = "examBscId=${vo.examBscId}&sbjctId=${examVO.sbjctId}";

            dialog = UiDialog("dialog1", {
                title: "엑셀 성적등록",
                width: 600,
                height: 500,
                url: "/exam/profExamExcelScrRegistPopup.do?"+data,
                autoresize: true
            });
        }
        /* 6 */
        //
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

        /**
         * 시험 화면 이동
         * @param {String}  examBscId           - 시험 기본 ID
         * @param {String}  tkexamMthdCd        - 시험 구분 [RLTM|QUIZ]
         * @param {String}  byteamSubrexamUseyn - 팀 시험여부
         * @param {Integer} tab                 - 탭 번호
         */
        function examViewMv(tab) {
            var urlMap = {
                "1" : "/exam/profExamInfoEvlView.do",   // 시험 상세 [시험 정보 및 평가 탭]
                "2" : "/exam/profExamSbstView.do",      // 시험 상세 [시험 대체 탭]
                "3" : "/exam/profExamAbsnceView.do",    // 시험 상세 [결시 내용 및 현황 탭]
                "4" : "/exam/profExamDsblView.do",      // 시험 상세 [장애인/고령자 지원 현황 탭]
                "5" : "/exam/profExamQuizMngView.do",   // 시험 상세 [퀴즈 관리 탭]
                "8" : "/exam/profExamListView.do",      // 시험 목록
                "9" : "/exam/profExamWriteView.do"      // 시험 [등록|수정] 화면
            };

            var kvArr = [];

            kvArr.push({'key' : 'examBscId',          'val' : '${vo.examBscId}'});
            kvArr.push({'key' : 'tkexamMthdCd',       'val' : '${vo.tkexamMthdCd}'});
            kvArr.push({'key' : 'byteamSubrexamUseyn','val' : '${vo.byteamSubrexamUseyn}'});
            kvArr.push({'key' : 'tabType',            'val' : tab});
            kvArr.push({'key' : 'isModify',           'val' : 'Y'});
            submitForm(urlMap[tab], "", "", kvArr);
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
                    UiComm.showMessage("학습중인 수강생이 있습니다.\n삭제할 경우 수강생의 학습정보가 삭제됩니다.\n정말 삭제하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            ajaxCall("/exam/examDelete.do", { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn }, function(data) {
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")
                                        .then(function() {
                                            location.href = "/exam/profExamListView.do";
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }, function(xhr, status, error) {
                                UiComm.showMessage("<spring:message code='exam.error.list' />", "error");
                            }, true);
                        }
                    });
                } else {
                    UiComm.showMessage("학습중인 수강생이 없습니다.\n정말 삭제하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            ajaxCall("/exam/examDelete.do", { examBscId: examBscId, byteamSubrexamUseyn: byteamSubrexamUseyn }, function(data) {
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")
                                        .then(function() {
                                            location.href = "/exam/profExamListView.do";
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }, function(xhr, status, error) {
                                UiComm.showMessage("<spring:message code='exam.error.list' />", "error");
                            }, true);
                        }
                    });
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='exam.error.list' />", "error");
            });
        }

		$(document).ready(function() {
            toggleIcon();
            toggleIconTrigger();

            setAccordion();
            eventAccordion();

            loadExamInfoList();
            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }
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

                    <!-- 콘텐츠 영역 -->
                    <div class="box span-2 subject">
                        <div class="box_content">
                            <div class="sub-content">
                                <!-- 콘텐츠 상단 탭 버튼 영역 -->
                                <div class="listTab">
                                    <ul>
                                        <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                        <li class="mw120 select" style = "pointer-events: none;"><a onclick="examViewMv(1)">시험정보 및 평가</a></li>
                                        <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                            <li class="mw120"><a onclick="examViewMv(2)">시험 대체</a></li>
                                            <li class="mw120"><a onclick="examViewMv(3)">결시 내용 및 현황</a></li>
                                            <li class="mw120"><a onclick="examViewMv(4)">장애인/고령자 지원 현황</a></li>
                                        </c:if>
                                        <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                            <li class="mw120"><a onclick="examViewMv(5)">퀴즈 관리</a></li>
                                        </c:if>
                                    </ul>
                                </div>
                                <!-- 고정 영역 -->
                                <div class="board_top">
                                    <i class="icon-svg-openbook"></i>
                                    <!-- 탭에 따라서 메인 제목을 바꾸는 로직이 필요하다 -->
                                    <h3 class="board-title">시험정보 및 평가</h3>
                                    <div class="right-area">
                                        <!-- 탭에 따라서 버튼 숨기는 로직이 필요하다 -->
                                        <button type="button" class="btn type2" onclick="examViewMv(9)">수정</button>
                                        <button type="button" class="btn type2" onclick="examDelete('${vo.examBscId}', '${examVO.byteamSubrexamUseyn}')">삭제</button>
                                        <button type="button" class="btn basic" onclick="examViewMv(8)">목록</button>
                                    </div>
                                </div>
                                <!-- [공통] 시험 정보 영역 -->
                                <div class="accordion">
                                    <div class="title flex">
                                        <div class="title_cont">
                                            <div class="left_cont">
                                                <div class="lectTit_box">
                                                    <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                                                    <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                                                    <!-- 날짜 포맷 -->
                                                    <fmt:parseDate var="psblSdttmFmt" pattern="yyyyMMddHHmmss" value="${examVO.examPsblSdttm}" />
                                                    <fmt:formatDate var="examPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${psblSdttmFmt }" />
                                                    <fmt:parseDate var="psblEdttmFmt" pattern="yyyyMMddHHmmss" value="${examVO.examPsblEdttm}" />
                                                    <fmt:formatDate var="examPsblEdttm" pattern="yyyy.MM.dd HH:mm" value="${psblEdttmFmt }" />
                                                    <p class="lect_name"><strong>${examVO.examGbnnm}</strong></p>
                                                    <span class="fcGrey">
                                                        <strong>${examVO.examTtl}</strong> |
                                                        <small>${examVO.tkexamMthdNm}</small> |
                                                        <small>응시 기간 : ${examPsblSdttm} ~ ${examPsblEdttm}</small> |
                                                        <small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${examVO.mrkRfltyn eq 'Y' ? yes : no }</small> |
                                                        <small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${examVO.mrkOyn eq 'Y' ? yes : no }</small>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <i class="dropdown icon ml20"></i>
                                    </div>
                                    <div class="content" style="padding:0;">
                                        <!--table-type-->
                                        <div class="table-wrap">
                                            <table class="table-type2">
                                                <colgroup>
                                                    <col class="width-20per" />
                                                    <col class="" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th><label>시험 구분</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.examGbnnm}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 방식</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.tkexamMthdNm}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 내용</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <pre>
                                                                <div class="editor-box">
                                                                    <uiex:htmlEditor
                                                                        id = "dtl-exam-cts"
                                                                        name = "dtl-exam-cts"
                                                                        uploadPath = "${examVO.uploadPath}"
                                                                        value = "${examVO.examCts}"
                                                                        height = "400px"
                                                                        required="true"
                                                                    />
                                                                </div>
                                                            </pre>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 일시</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examPsblSdttm} ~ ${examPsblEdttm}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 시간</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.examMnts} 분</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>성적 반영</label></th>
                                                        <td class="t_left"><pre>${examVO.mrkRfltyn eq 'Y' ? yes : no}</pre></td>
                                                        <th><label>성적 반영비율</label></th>
                                                        <td class="t_left"><pre>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt} %</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>성적 공개</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.mrkOyn eq 'Y' ? yes : no}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험지 공개</label></th>
                                                        <td class="t_left" colspan="3"><pre>${examVO.exampprOyn eq 'Y' ? yes : no}</pre></td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>팀 시험</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <pre>${examVO.byteamSubrexamUseyn eq 'Y' ? yes : no}</pre>
                                                            <!-- 팀 시험인 경우 -->
                                                            <c:if test = "${examVO.byteamSubrexamUseyn eq 'Y' and not empty examDtlInfoVO}">
                                                                <pre>학습그룹 : ${examDtlInfoVO[0].lrnGrpnm}</pre>
                                                                <pre>팀별 부 주제 사용여부 : ${examVO.lrnGrpSubsbjctUseyn eq 'Y' ? yes : no}</pre>
                                                                <c:if test="${examVO.lrnGrpSubsbjctUseyn eq 'Y'}">
                                                                    <table class="table-type2">
                                                                        <colgroup>
                                                                            <col class="width-10per" />
                                                                            <col class="" />
                                                                            <col class="width-20per" />
                                                                        </colgroup>
                                                                        <tbody id="examSubsbjctbody">
                                                                        <tr>
                                                                            <th><label>팀</label></th>
                                                                            <th><label>부주제 + 내용</label></th>
                                                                            <th><label>학습그룹 구성원</label></th>
                                                                        </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </c:if>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>시험 대체</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <div class = "item_list">
                                                                ${examVO.examSbstTynm}
                                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(2)">시험 대체</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>결시 현황</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <div class = "item_list">
                                                                ${examVO.absnceTot} 명
                                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(3)">결시 내용 및 현황</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label>장애인/고령자 지원</label></th>
                                                        <td class="t_left" colspan="3">
                                                            <div class = "item_list">
                                                                ${examVO.dsblTot} 명
                                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                                                    <button type="button" class = "btn basic" onclick="examViewMv(4)">장애인/고령자 지원</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <!-- 시험정보 및 평가 상단영역 -->
                                <div class="board_top margin-top-4 padding-2">
                                    <h4>시험평가</h4>
                                    <div class="right-area">
                                        <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                            <a href="javascript:excelScrRegistPopup()" class="btn basic small"><spring:message code="exam.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
                                        </c:if>
                                        <a href="javascript:sendMsg()" class="btn basic small">보내기</a>
                                    </div>
                                </div>
                                <!-- 시험정보 및 평가 검색영역 -->
                                <div class="search-typeA margin-bottom-4">
                                    <div class="text-center">
                                        <select class="form-select" id="tkexamCmptnyn">
                                            <option value="">응시여부</option>
                                            <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                            <option value="N">미응시</option>
                                            <option value="Y">응시완료</option>
                                        </select>
                                        <select class="form-select" id="evlyn">
                                            <option value="">평가여부</option>
                                            <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                            <option value="Y">평가</option>
                                            <option value="N">미평가</option>
                                        </select>
                                        <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                                        <button type="button" class="btn type1" onclick="examTkexamListSelect()">검색</button>
                                        <button type="button" class="btn type1" onclick="resetListSelect()">수강생 전체</button>
                                    </div>
                                </div>
                                <table class="table-type1 fs-14px mb10">
                                    <colgroup>
                                        <col class="width-20per" />
                                        <col class="" />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>일괄 성적처리</th>
                                        <td>
                                            <form id="scoreForm" onsubmit="return false;">
                                                <div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true" />
													<label for="scoreBatch">점수 등록</label>
												</span>
                                                    <span class="custom-input">
													<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true" />
													<label for="scoreAddition">점수 가감</label>
												</span>
                                                    점수
                                                    <button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
                                                    <input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
                                                    점
                                                    <a href="javascript:EvlScrBulkModify()" class="btn type7">저장</a>
                                                </div>
                                            </form>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div class="board_top">
                                    <div class="right-area">
                                        <c:if test="${vo.tkexamMthdCd eq 'RLTM'}">
                                            <a class="btn type2">온라인시험 채점하기</a>
                                            <a href="javascript:examTkexamStatusExcelDown()" class="btn type1">엑셀로 다운로드</a>
                                            <a href="javascript:examHrChartPop()" class="btn type2">성적분포도</a>
                                        </c:if>
                                        <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                            <a class="btn type2">시험지 일괄 인쇄</a>
                                            <a class="btn type1">시험지 일괄 엑셀 다운로드</a>
                                            <a href="javascript:examTkexamStatusExcelDown()" class="btn type1">엑셀로 다운로드</a>
                                            <a href="javascript:examPieChartPop()" class="btn type2">응시현황 그래프</a>
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
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
