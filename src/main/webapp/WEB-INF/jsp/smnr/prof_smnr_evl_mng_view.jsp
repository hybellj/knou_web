<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/smnr/common/smnr_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,fileuploader"/>
    </jsp:include>

    <script type="text/javascript">
        $(document).ready(function () {
            smnrAtndListSelect();

            if ("${vo.byteamSubsmnrUseyn}" == "Y") {
            	// 팀그룹부세미나목록조회
                teamGrpSubSmnrListSelect("${vo.teamGrpId}", "${vo.smnrId}");
            }

            $("#searchValue").on("keyup", function (e) {
                if (e.keyCode == 13) {
                    smnrAtndListSelect();
                }
            });

            // 일괄 성적처리 아이콘 변경
            $('#scr-toggle-icon').click(function () {
                $(this).children("i").toggleClass("xi-plus xi-minus");
            });

            $("#scoreBatch").trigger("click");
        });

        /**
         * 세미나참석목록조회
         * @param {String}  smnrId        - 세미나아이디
         * @param {String}  atndStscd    - 참석여부
         * @param {String}  atndEvlyn    - 참석평가여부
         * @param {String}  searchValue    - 검색어(학과, 학번, 이름)
         * @returns {list} 세미나참석목록
         */
        function smnrAtndListSelect() {
            const url  = "/smnr/profSmnrAtndListAjax.do";
            const data = {
                smnrId		: "${vo.smnrId}",
                atndStscd	: $("#atndStscd").val(),
                atndEvlyn	: $("#atndEvlyn").val(),
                searchValue	: $("#searchValue").val()
            };

            $.ajax({
                url			: url,
                type		: "POST",
                dataType	: "json",
                data		: JSON.stringify(data),
                contentType	: "application/json; charset=UTF-8",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function(data) {
                    if (data.result > 0) {
                        let dataList = createUserListHTML(data.returnList);	// 수강생 리스트 HTML 생성

                        userListTable.clearData();
                        userListTable.replaceData(dataList);
                        atndStsFrmTrsf(2);	// 일괄참여관리폼변환
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='exam.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
        }

        // 수강생 리스트 HTML 생성
        function createUserListHTML(userList) {
            let dataList = [];

            if (userList.length == 0) {
                return dataList;
            } else {
                userList.forEach(function (v, i) {
                	let atndStsnm = "";
                	let atndScnds = v.atndScnds;

                	let hours = Math.floor(atndScnds / 3600);
                	let minutes = Math.floor((atndScnds % 3600) / 60);
                	let seconds = atndScnds % 60;
                    atndScnds = hours > 0 ? hours + ":" : "";
                    atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
                    atndScnds += seconds < 10 ? "0" + seconds : seconds;

                    atndStsnm += "<div class='atndStsRadioDiv' style='display:none;'>";
                    atndStsnm += "	<span class='custom-input'>";
                    atndStsnm += "		<input type='radio' name='atndStscd" + v.lineNo + "' class='atndStscd' id='atndStsAtnd" + v.lineNo + "' data-smnrId='" + v.smnrId + "' data-userId='" + v.userId + "' data-smnrAtndId='" + v.smnrAtndId + "' value='ATND' " + (v.atndStscd == "ATND" ? "checked" : "") + " />";
                    atndStsnm += "		<label for='atndStsAtnd" + v.lineNo + "'>참여</label>";
                    atndStsnm += "	</span>";
                    atndStsnm += "	<span class='custom-input'>";
                    atndStsnm += "		<input type='radio' name='atndStscd" + v.lineNo + "' class='atndStscd' id='atndStsAbsnt" + v.lineNo + "' data-smnrId='" + v.smnrId + "' data-userId='" + v.userId + "' data-smnrAtndId='" + v.smnrAtndId + "' value='ABSNT' " + (v.atndStscd == "ABSNT" ? "checked" : "") + " />";
                    atndStsnm += "		<label for='atndStsAbsnt" + v.lineNo + "'>미참여</label>";
                    atndStsnm += "	</span>";
                    atndStsnm += "</div>";
                    atndStsnm += "<div class='atndStsDiv'>";
                    if (v.atndStscd == "ABSNT") {
                        atndStsnm += "미참석";
                    } else if (v.atndStscd == "ATND") {
                        atndStsnm += "참석";
                    }
                    atndStsnm += "</div>";
                    var mng = "<a href='javascript:atndMngPopup(\"" + v.smnrId + "\", \"" + v.smnrAtndId + "\", \"" + v.userId + "\")' class='btn basic small'>참여관리/관리이력</a>";

                    dataList.push({
                        no			: v.lineNo,
                        deptnm		: v.deptnm,
                        stdntNo		: v.stdntNo,
                        usernm		: v.usernm,
                        atndEvlScr	: v.atndSdttm == null ? v.atndEvlyn == "Y" ? v.atndEvlScr : "-" : v.atndEvlScr,
                        fdbk		: "<i class='xi-comment-o icon cursor-pointer " + (v.fdbkCts == null || v.fdbkCts == "" ? "" : "on") + "' onclick='fdbkPopup(\"" + v.smnrId + "\", \"" + v.userId + "\", this)'></i>",
                        atndStsnm	: atndStsnm,
                        atndSdttm	: v.atndSdttm == null ? "-" : UiComm.formatDate(v.atndSdttm, "datetime2"),
                        atndScnds	: atndScnds,
                        atndEvlyn	: v.atndEvlyn,
                        mng			: mng,
                        ldryn		: v.ldryn == "Y" ? "팀장" : "팀원",
                        teamnm		: v.teamnm,
                        userId		: v.userId,
                        smnrId		: v.smnrId,
                        smnrAtndId	: v.smnrAtndId
                    });
                });
            }

            return dataList;
        }

        // 점수 가감 아이콘 표시 확인
        function plusMinusIconControl(scoreType) {
            if (scoreType == 'batch') {
                $("#scr-toggle-icon").hide();
            } else if (scoreType == 'addition') {
                $("#scr-toggle-icon").show();
            }
        }

        /**
         * 평가점수일괄수정
         * @param {String}  smnrId        - 세미나아이디
         * @param {String}  smnrAtndId    - 세미나참석아이디
         * @param {String}  userId        - 사용자아이디
         */
        function EvlScrBulkModify() {
            let validator = UiValidator("scoreForm");
            validator.then(function (result) {
                if (result) {
                    if (userListTable.getSelectedData("userId").length == 0) {
                        UiComm.showMessage("일괄 성적처리할 학습자를 선택해주세요.", "info");
                        return;
                    }

                    let score = $("#scoreValue").val();
                    if ($("input[name='scoreType']:checked").val() == "addition") {
                        if (!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")) {
                            score = score * (-1);
                        }
                    }

                    const scrList = [];	// 점수 목록

                    for (var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
                    	scrList.push({
                            smnrId		: userListTable.getSelectedData("smnrId")[i],		// 세미나아이디
                            smnrAtndId	: userListTable.getSelectedData("smnrAtndId")[i],	// 세미나참석아이디
                            userId		: userListTable.getSelectedData("userId")[i],		// 사용자아이디
                            scr			: score,											// 점수
                            scoreType	: $("input[name='scoreType']:checked").val()		// 점수유형
                        });
                    }

                    $.ajax({
                        url			: "/smnr/profSmnrEvlScrBulkModifyAjax.do",
                        type		: "POST",
                        contentType	: "application/json",
                        data		: JSON.stringify(scrList),
                        dataType	: "json",
                        beforeSend	: () => UiComm.showLoading(true),
                        success		: function (data) {
                            if (data.result > 0) {
                                UiComm.showMessage("<spring:message code='exam.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
                                $("#scoreValue").val("");
                                smnrAtndListSelect();
                            } else {
                                UiComm.showMessage(data.message, "error");
                            }
                            UiComm.showLoading(false);
                        },
                        error		: () => UiComm.showMessage("<spring:message code='exam.error.batch.score' />", "error"),/* 일괄 점수 등록 중 에러가 발생하였습니다. */
                        complete	: () => UiComm.showLoading(false)
                    });
                }
            });
        }

        /**
         * 엑셀성적등록팝업
         * @param {String}  smnrId	- 세미나아이디
         * @param {String}  sbjctId - 과목아이디
         */
        function excelScrRegistPopup() {
            dialog = UiDialog("dialog1", {
                title	: "엑셀 성적등록",
                width	: 600,
                height	: 530,
                url		: "/smnr/profSmnrExcelScrRegistPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams({smnrId: "${vo.smnrId}"})
            });
        }

        /**
         * 세미나참석목록엑셀다운로드
         * @param {String}  smnrId   	세미나아이디
         * @param {String}  atndStscd 	참석여부
         * @param {String}  atndEvlyn 	참석평가여부
         * @param {String}  searchValue	검색어 ( 학과, 학번, 성명 )
         * @param {String}  excelGrid	엑셀그리드
         */
        function smnrAtndListExcelDown() {
            let ldrynObj = {
                Y: "팀장", N: "팀원"
            };
            let atndStscdObj = {
                ABSNT: "미참석",
                ATND: "참석"
            };

            let excelGrid = {colModel: []};

            excelGrid.colModel.push({label: 'No.', 		name: 'lineNo', 	align: 'center', 	width: '1000'});
            if ("${vo.byteamSubsmnrUseyn }" == "Y") {
                excelGrid.colModel.push({label: '팀명', 	name: 'teamnm', 	align: 'left', 		width: '4000'});
            }
            excelGrid.colModel.push({label: "학과", 		name: 'deptnm', 	align: 'left', 		width: '5000'});
            excelGrid.colModel.push({label: "학번", 		name: 'stdntNo', 	align: 'center', 	width: '5000'});
            excelGrid.colModel.push({label: "이름", 		name: 'usernm', 	align: 'center', 	width: '5000'});
            if ("${vo.byteamSubsmnrUseyn }" == "Y") {
                excelGrid.colModel.push({label: "역할", 	name: 'ldryn', 		align: 'center', 	width: '3000', codes: ldrynObj});
            }
            excelGrid.colModel.push({label: "평가점수", 	name: 'atndEvlScr', align: 'center', 	width: '3000'});
            excelGrid.colModel.push({label: "참석상태", 	name: 'atndStscd', 	align: 'center', 	width: '3000', codes: atndStscdObj});
            excelGrid.colModel.push({label: "참석일시", 	name: 'atndSdttm', 	align: 'center', 	width: '5000'});
            excelGrid.colModel.push({label: "참석시간", 	name: 'atndScnds', 	align: 'center', 	width: '5000'});
            excelGrid.colModel.push({label: "평가여부", 	name: 'atndEvlyn', 	align: 'center', 	width: '3000'});

            var kvArr = [];
            kvArr.push({'key': 'smnrId', 		'val': "${vo.smnrId}"});
            kvArr.push({'key': 'atndStscd', 	'val': $("#atndStscd").val()});
            kvArr.push({'key': 'atndEvlyn', 	'val': $("#atndEvlyn").val()});
            kvArr.push({'key': 'searchValue', 	'val': $("#searchValue").val()});
            kvArr.push({'key': 'excelGrid', 	'val': JSON.stringify(excelGrid)});

            submitForm("/smnr/profSmnrAtndListExcelDown.do", kvArr);
        }

        // 메세지 보내기
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#quizStareUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function () {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (userListTable.getSelectedData("userId").length == 0) {
                UiComm.showMessage("<spring:message code='common.alert.sysmsg.select_user'/>", "warning");	/* 메시지 발송 대상자를 선택하세요. */
                return;
            }

            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

            var form = document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name = 'alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name = 'rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }

        /**
         * 세미나삭제
         * @param {String}  smnrId        - 세미나아이디
         * @param {String}  sbjctId    - 과목아이디
         */
        function smnrDelete() {
            var extData = {
                "smnrId": "${vo.smnrId}"
            };

            const url 	= "/smnr/smnrDeleteAjax.do";
            const param = {
                  encParams: EPARAM
                , addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall(url, param, function (data) {
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
                    smnrViewMv("", "LIST");
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
            }, true);
        }

        // 수강생 전체 버튼
        function resetListSelect() {
            $("#atndStscd").val('').trigger('chosen:updated');
            $("#atndEvlyn").val('').trigger("chosen:updated");
            $("#searchValue").val("");
            smnrAtndListSelect();
        }

        // EZ-Grader 팝업
        function ezGraderPopup() {
            dialog = UiDialog("dialog2", {
                url			: "/smnr/ezgrader/smnrEzGraderPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams({smnrId : "${vo.smnrId}"}),
                titlebar	: false,
                fullscreen	: true
            });
        }

        // ZOOM 호스트 시작
        function zoomHostStart() {
            const url  = "/zoom/zoomHostUrlSelectAjax.do";
            const data = {
                smnrId	: "${vo.smnrId}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    let windowOpener = window.open();
                    windowOpener.location = data.data.start_url;
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
            }, true);
        }

        // ZOOM 참여자 시작
        function zoomUserStart() {
            const url  = "/zoom/zoomUserUrlSelectAjax.do";
            const data = {
                smnrId	: "${vo.smnrId}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    let windowOpener = window.open();
                    windowOpener.location = data.data.trgtrCntnUrl;
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function (xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
            }, true);
        }

        // ZOOM 참여로그 팝업
        function smnrAtndHstryPopup() {
            const data = "smnrId=${vo.smnrId}";

            dialog = UiDialog("dialog1", {
                title	: "ZOOM 참여로그",
                width	: 900,
                height	: 650,
                url		: "/smnr/profSmnrAtndHstryListPopup.do?" + data
            });
        }

        /**
         * 일괄참여관리폼변환
         * @param type - 변환 타입 번호 ( 1 : 선택폼 활성화, 2 : 취소)
         */
        function atndStsFrmTrsf(type) {
        	$(".atndStsRadioDiv").toggle(type == 1);
        	$(".atndStsDiv").toggle(type != 1);
        	$("#atndStsFrmTrsfBtn").toggle(type != 1);
        	$(".atndStsFrmTrsfDiv").toggle(type == 1);
        }

        // 참석상태전체체크
        function atndStsAllCheck(value) {
            $(".atndStscd[value=\"" + value + "\"]").trigger("click");
        }

        // 참석상태일괄수정
        function atndStsModify() {
            const atndList = [];	// 참석 목록

            $(".atndStscd:checked").each(function (i, v) {
            	atndList.push({
                    smnrId		: $(v).data("smnrid"),		// 세미나아이디
                    smnrAtndId	: $(v).data("smnratndid"),	// 세미나참석아이디
                    userId		: $(v).data("userid"),		// 사용자아이디
                    atndStscd	: v.value					// 참석상태코드
                });
            });

            $.ajax({
                url			: "/smnr/profSmnrAtndBulkModifyAjax.do",
                type		: "POST",
                contentType	: "application/json",
                data		: JSON.stringify(atndList),
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                        UiComm.showMessage("일괄 참여 저장이 완료되었습니다.", "success");
                        smnrAtndListSelect();
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("일괄 참여 저장 중 에러가 발생하였습니다.", "error"),
                complete	: () => UiComm.showLoading(false)
            });
        }

        /**
         * 참여관리팝업
         * @param smnrId        - 세미나아이디
         * @param smnrAtndId    - 세미나참석아이디
         * @param userId        - 사용자아이디
         */
        function atndMngPopup(smnrId, smnrAtndId, userId) {
            const data = "smnrId=" + smnrId + "&smnrAtndId=" + smnrAtndId + "&userId=" + userId;

            dialog = UiDialog("dialog1", {
                title	: "참여관리 / 관리이력",
                width	: 850,
                height	: 800,
                url		: "/smnr/profSmnrAtndMngPopup.do?" + data
            });
        }

        // 피드백 저장 확인
        function fdbkSaveConfirm() {
            let validator = UiValidator("fdbkForm");
            validator.then(function (result) {
                if (result) {
                    if (userListTable.getSelectedData("userId").length == 0) {
                        UiComm.showMessage("일괄 피드백할 학습자를 선택해주세요.", "info");
                        return;
                    }

                    let dx = dx5.get("fileUploader");
                    // 첨부파일 있으면 업로드
                    if (dx.availUpload()) {
                        dx.startUpload();
                    }
                    // 첨부파일 없으면 저장 호출
                    else {
                        fdbkRegist();
                    }
                }
            });
        }

        // 파일 업로드 완료
        function finishUpload() {
            let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
            let dx = dx5.get("fileUploader");
            let data = {
                uploadFiles	: dx.getUploadFiles(),
                uploadPath	: dx.getUploadPath()
            };

            // 업로드된 파일 체크
            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());

                    fdbkRegist();
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
                }
            },
            function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            });
        }

        // 피드백등록
        function fdbkRegist() {
            const userList = [];	// 사용자 목록

            for (var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
            	userList.push({
                    smnrId: userListTable.getSelectedData("smnrId")[i],	// 세미나아이디
                    userId: userListTable.getSelectedData("userId")[i]	// 사용자아이디
                });
            }
            $("#fdbkUsers").val(JSON.stringify(userList));

            let dx = dx5.get("fileUploader");
            const url = "/smnr/smnrFdbkRegistAjax.do";

            ajaxCall(url, $("#fdbkForm").serialize(), function(data) {
				if (data.result > 0) {
					UiComm.showMessage("피드백 등록이 완료되었습니다.", "success", 500)
                    .then(function (result) {
                        dx.removeAll();
                        $("#fdbkForm textarea[name=fdbkCts]").val("");
                        smnrAtndListSelect();
                    });
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
    		}, true);
        }

        // 피드백 팝업
        function fdbkPopup(smnrId, userId, obj) {
            // 선택된 피드백의 아이콘 색상 초기화 및 변경
            if ($(".xi-comment-o").parents().hasClass("focused")) {
                $(".xi-comment-o").parents().removeClass("focused");
            }
            $(obj).parents().addClass("focused");

            const data = "smnrId=" + smnrId + "&userId=" + userId;
            dialog = UiDialog("dialog1", {
                title		: "피드백",
                width		: 1000,
                height		: 350,
                url			: "/smnr/smnrFdbkPopup.do?" + data,
                autoresize	: true
            });
        }
    </script>
</head>

<body class="class ${uiex:getTheme()}">
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
                <!-- class_info -->
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                <!-- //class_info -->

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">
                            <spring:message code="seminar.label.seminar" /><!-- 세미나 -->
                        </h2>
                    </div>

                    <div class="listTab">
                        <ul>
                            <li class="select"><a onclick="smnrViewMv('${vo.smnrId}', 'EVL')">세미나정보 및 평가</a></li>
                        </ul>
                    </div>

                    <div class="board_top">
                    	<h3 class="board-title">세미나정보 및 평가</h3>
                        <div class="right-area">
                            <a href="javascript:smnrViewMv('${vo.smnrId}', 'MODIFY')" class="btn type1 big"><spring:message code="exam.button.mod"/></a><!-- 수정 -->
                            <a href="javascript:smnrDelete()" class="btn type2 big"><spring:message code="exam.button.del"/></a><!-- 삭제 -->
                            <a href="javascript:smnrViewMv('', 'LIST')" class="btn type2 big"><spring:message code="exam.button.list"/></a><!-- 목록 -->
                        </div>
                    </div>

					<!--accordion-->
                    <div class="elements_wrap">
                        <ul class="accordion">
                        	<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
							<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                            <li class=""><!-- 클릭시 active 추가 -->
                                <div class="title-wrap">
                                    <a class="title" href="#">
                                        <div class="lecture_tit">
                                            <strong>${fn:escapeXml(vo.smnrnm) }</strong>
                                            <p class="desc">
                                                <span>세미나일시 :<strong><uiex:formatDate type="datetime" value="${vo.smnrSdttm }"/></strong></span>
                                                <span>
                                                	<strong>
														<c:set var="mntsHour" value="${vo.smnrMnts / 60 }"/>
														<c:set var="mntsMin"><fmt:formatNumber value="${vo.smnrMnts % 60}" type="number" pattern="#"/></c:set>
														<c:if test="${vo.smnrMnts >= 60 }">${mntsHour }시간 </c:if>
														${mntsMin }분
                                                	</strong>
                                                </span>
                                                <span><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> :<strong>${vo.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
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
		                                        <th>세미나방식</th>
		                                        <td colspan="3">
		                                            <c:forEach var="code" items="${smnrGbncdList }">
		                                                <c:if test="${code.cd eq vo.smnrGbncd }">${code.cdnm }</c:if>
		                                            </c:forEach>
		                                        </td>
		                                    </tr>
                                			<tr>
	                                			<th>세미나내용</th>
	                                			<td colspan="3">
	                                				<div class="tb_content">
	                                                    ${vo.smnrCts }
	                                                </div>
	                                			</td>
                                			</tr>
                                			<tr>
                                				<th>세미나일시</th>
                                				<td colspan="3">
                                					<uiex:formatDate type="datetime" value="${vo.smnrSdttm }"/>
                                				</td>
                                			</tr>
                                			<tr>
                                				<th>진행시간</th>
                                				<td colspan="3">
                                					<c:if test="${vo.smnrMnts >= 60 }">${mntsHour }시간 </c:if>
                                            		${mntsMin }분
                                				</td>
                                			</tr>
                                			<tr>
                                                <th>성적반영</th>
                                                <td>${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
                                                <th>성적반영비율</th>
                                                <td>${vo.mrkRfltyn eq 'Y' ? vo.mrkRfltrt : '0' }%</td>
                                            </tr>
                                            <tr>
                                                <th>성적공개</th>
                                                <td colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
                                            </tr>
                                            <tr>
                                                <th>평가방법</th>
                                                <td colspan="3">
                                                	<c:choose>
		                                                <c:when test="${vo.evlScrTycd eq 'SCR' }">
		                                                    점수형
		                                                </c:when>
		                                                <c:otherwise>
		                                                    참여형 <span class="fcBlue">( 설문 참여 : 100점, 미참여 : 0점 자동배점 )</span>
		                                                </c:otherwise>
		                                            </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>파일 첨부</th>
                                                <td colspan="3">
                                                	<c:if test="${not empty vo.fileList}">
													<div class="add_file_list">
														<uiex:filedownload fileList="${vo.fileList}"/>
													</div>
												</c:if>
                                                </td>
                                            </tr>
                                            <tr>
                                            	<th>팀 세미나</th>
                                            	<td colspan="3" class="in_table">
                                            		<c:choose>
													<c:when test="${vo.byteamSubsmnrUseyn eq 'Y' }">
														<div class="view_con">
			                                                팀그룹 : ${vo.teamGrpnm }
			                                            </div>
			                                            <!-- 팀그룹별 세미나 설정 -->
														<div class="table-wrap mb30">
															<table class="table-type5 in-table">
																<colgroup>
																	<col class="width-5per" />
					                                                <col class="width-15per" />
					                                                <col class="" />
																</colgroup>
																<tbody id="smnrSubSmnrTbody">
																</tbody>
															</table>
														</div>
														<!-- //팀그룹별 세미나 설정 -->
													</c:when>
													<c:otherwise>
														<div class="view_con">${no }</div>
													</c:otherwise>
												</c:choose>
                                            	</td>
                                            </tr>
                                            <c:if test="${vo.smnrGbncd eq 'ONLN_SMNR' }">
		                                        <tr>
		                                            <th>ZOOM 설정</th>
		                                            <th class="text-right" colspan="3">
		                                                <c:choose>
		                                                    <c:when test="${vo.profId eq userCtx.userId }">
		                                                        <button class="btn type2" onclick="zoomHostStart()">ZOOM 시작</button>
		                                                    </c:when>
		                                                    <c:otherwise>
		                                                        <button class="btn type2" onclick="zoomUserStart()">ZOOM 시작</button>
		                                                    </c:otherwise>
		                                                </c:choose>
		                                            </th>
		                                        </tr>
		                                        <tr>
		                                            <th>ZOOM 회의 ID</th>
		                                            <td colspan="3">${vo.meetngrmId }</td>
		                                        </tr>
		                                        <tr>
		                                            <th>ZOOM 회의 녹화</th>
		                                            <td colspan="3">${vo.autoRcdyn eq 'Y' ? yes : no }</td>
		                                        </tr>
		                                    </c:if>
                                		</tbody>
                                	</table>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <!--//accordion-->

                    <div class="board_top margin-top-4 padding-2 bcLgrey4">
                        <h4>세미나평가</h4>
                        <div class="right-area">
                            <a href="javascript:ezGraderPopup()" class="btn basic small">EZ-Grader</a>
                            <a href="javascript:excelScrRegistPopup()" class="btn basic small"><spring:message code="exam.button.reg.excel.score"/></a><!-- 엑셀 성적등록 -->
                            <a href="javascript:sendMsg()" class="btn basic small">보내기</a>
                        </div>
                    </div>
                    <div class="search-typeA margin-bottom-4">
                        <div class="text-center">
                            <select class="form-select" id="atndStscd" onchange="smnrAtndListSelect()">
                                <option value="">참석여부</option>
                                <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                <option value="ABSNT">미참석</option>
                                <option value="ATND">참석완료</option>
                            </select>
                            <select class="form-select" id="atndEvlyn" onchange="smnrAtndListSelect()">
                                <option value="">평가여부</option>
                                <option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                                <option value="Y">평가</option>
                                <option value="N">미평가</option>
                            </select>
                            <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                            <button type="button" class="btn type1" onclick="smnrAtndListSelect()">검색</button>
                            <button type="button" class="btn type1" onclick="resetListSelect()">수강생 전체</button>
                        </div>
                    </div>
                    <div></div>
                    <table class="table-type5 border-1">
                        <colgroup>
                            <col class="width-20per"/>
                            <col class=""/>
                        </colgroup>
                        <tbody>
                        <tr>
                            <th class="bcLgrey">일괄 성적처리</th>
                            <td>
                                <form id="scoreForm" onsubmit="return false;">
                                    <div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true"/>
													<label for="scoreBatch">점수 등록</label>
												</span>
                                        <span class="custom-input">
													<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true"/>
													<label for="scoreAddition">점수 가감</label>
												</span>
                                        점수
                                        <button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
                                        <input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true"/>
                                        점
                                        <a href="javascript:EvlScrBulkModify()" class="btn type7">저장</a>
                                    </div>
                                </form>
                            </td>
                        </tr>
                        <tr>
                            <th class="bcLgrey">일괄 피드백</th>
                            <td>
                                <form id="fdbkForm" onsubmit="return false;">
                                    <input type="hidden" id="uploadFiles" name="uploadFiles"/>
                                    <input type="hidden" id="uploadPath" name="uploadPath" value="${vo.uploadPath}"/>
                                    <input type="hidden" id="fdbkUsers" name="fdbkUsers"/>
                                    <input type="hidden" name="smnrId" value="${vo.smnrId }"/>
                                    <textarea style="width:100%;height:70px" name="fdbkCts" placeholder="피드백 입력"></textarea>
                                    <div class="board_top margin-bottom-0 margin-top-3">
                                        <div id="uploaderBox" class="width-85per">
                                            <uiex:dextuploader
                                                    id="fileUploader"
                                                    path="${vo.uploadPath}"
                                                    limitCount="1"
                                                    limitSize="100"
                                                    oneLimitSize="100"
                                                    listSize="1"
                                                    fileList=""
                                                    finishFunc="finishUpload()"
                                                    allowedTypes="*"
                                                    uiMode="simple"
                                            />
                                        </div>
                                        <button onclick="fdbkSaveConfirm()" class="btn type7 small right-area">저장</button>
                                    </div>
                                </form>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <div class="board_top margin-top-4">
                        <div class="right-area">
                            <c:choose>
                                <c:when test="${vo.smnrGbncd eq 'ONLN_SMNR' }">
                                    <a href="javascript:smnrAtndHstryPopup()" class="btn type1">ZOOM 참여로그</a>
                                    <div class="atndStsFrmTrsfDiv">
                                        <a href="javascript:atndStsAllCheck('ATND')" class="btn type1">전체 참여</a>
                                        <a href="javascript:atndStsAllCheck('ABSNT')" class="btn type1">전체 미참여</a>
                                        <a href="javascript:atndStsModify()" class="btn type1">일괄 참여 저장</a>
                                        <a href="javascript:atndStsFrmTrsf(2)" class="btn type2">취소</a>
                                    </div>
                                    <a href="javascript:atndStsFrmTrsf(1)" id="atndStsFrmTrsfBtn" class="btn type1">일괄 참여 관리</a>
                                    <%-- <c:choose>
                                        <c:when test="${vo.atndRcdPfltyn eq 'Y' }">
                                            <a href="javascript:void(0)" class="btn type1">일괄 참여 관리</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="javascript:zoomAtndRegist()" class="btn type1">참여기록 가져오기</a>
                                        </c:otherwise>
                                    </c:choose> --%>
                                    <a href="javascript:srvyPtcpStatusExcelDown()" class="btn type1">녹화 영상 보기</a>
                                </c:when>
                                <c:otherwise>
                                    <div class="atndStsFrmTrsfDiv">
                                        <a href="javascript:atndStsAllCheck('ATND')" class="btn type1">전체 참여</a>
                                        <a href="javascript:atndStsAllCheck('ABSNT')" class="btn type1">전체 미참여</a>
                                        <a href="javascript:atndStsModify()" class="btn type1">일괄 참여 저장</a>
                                        <a href="javascript:atndStsFrmTrsf(2)" class="btn type2">취소</a>
                                    </div>
                                    <a href="javascript:atndStsFrmTrsf(1)" id="atndStsFrmTrsfBtn" class="btn type1">일괄 참여 관리</a>
                                </c:otherwise>
                            </c:choose>
                            <a href="javascript:smnrAtndListExcelDown()" class="btn type1">엑셀 다운로드</a>
                        </div>
                    </div>

                    <div>
                        <div id="list"></div>

                        <script>
                            let userListTable = UiTable("list", {
                                lang: "ko",
                                selectRow: "checkbox",
                                columns: [
                                    {title: "No", 										field: "no", 			headerHozAlign: "center", hozAlign: "center", width: 40, 	minWidth: 40},
                                    ("${vo.byteamSubsmnrUseyn}" == "Y" ? {title: "팀명", field: "teamnm", 		headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 80} : null),
                                    {title: "학과", 										field: "deptnm", 		headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 100},
                                    {title: "학번", 										field: "stdntNo", 		headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 100},
                                    {title: "이름", 										field: "usernm", 		headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 100},
                                    ("${vo.byteamSubsmnrUseyn}" == "Y" ? {title: "역할", field: "ldryn", 			headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 80} : null),
                                    {title: "평가점수", 									field: "atndEvlScr", 	headerHozAlign: "center", hozAlign: "center", width: 80, 	minWidth: 80},
                                    {title: "피드백", 									field: "fdbk", 			headerHozAlign: "center", hozAlign: "center", width: 80, 	minWidth: 80},
                                    {title: "참석상태", 									field: "atndStsnm", 	headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 150},
                                    {title: "참석일시", 									field: "atndSdttm", 	headerHozAlign: "center", hozAlign: "center", width: 150, 	minWidth: 150},
                                    {title: "참석시간", 									field: "atndScnds", 	headerHozAlign: "center", hozAlign: "center", width: 100, 	minWidth: 100},
                                    {title: "평가여부", 									field: "atndEvlyn", 	headerHozAlign: "center", hozAlign: "center", width: 80, 	minWidth: 80},
                                    {title: "관리", 										field: "mng", 			headerHozAlign: "center", hozAlign: "center", width: 0, 	minWidth: 150},
                                ].filter(function (col) {
                                    return col !== null;
                                })
                            });
                        </script>
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