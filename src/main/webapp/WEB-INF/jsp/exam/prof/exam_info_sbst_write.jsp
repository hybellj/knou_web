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

        var curTabType             = '<c:out value="${vo.tabType}" />';
        var curTkexamMthdCd       = '<c:out value="${vo.tkexamMthdCd}" />';

        var curExamBscId          = '<c:out value="${vo.examBscId}" />';
        var curSbjctId            = '<c:out value="${examVO.sbjctId}" />';
        var curMrkRfltrt          = '<c:out value="${examVO.mrkRfltrt}" />';
        var curExamGbncd          = '<c:out value="${examVO.examGbncd}" />';

        var curExamEvlSbstId      = '<c:out value="${sbstVO.examEvlSbstId}" />';
        var curAsmtId             = '<c:out value="${sbstVO.asmtId}" />';
        var curQuizId             = '<c:out value="${sbstVO.examBscId}" />';

        var curByteamSubrexamUseyn = '<c:out value="${vo.byteamSubrexamUseyn}" />';  // 팀 여부
        var hasSubSubject          = '<c:out value="${examVO.teamGrpSubsbjctUseyn}" />';  // 부 주제
        var sbstUserInfoListTable = null;
        var _rubricId  = '<c:out value="${sbstVO.rubricId}"/>';
        var setUrl = "";            // 등록|수정 URL
        var gbn = '${gbn}';         // 과제|퀴즈 판별용
        const editors = {};	        // 에디터 목록 저장용

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initSbstUserInfoListTable :   컬럼 정의 (시험 대체 대상자)
         * 2. createSbstUserInfoListHtml:   각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성 (시험 대체 대상자)
         * 3. loadSbstUserInfoList :        컬럼에 들어갈 데이터 ajax 호출 (시험 대체 대상자)
         *****************************************************************************/
        /* 1 */
        function initSbstUserInfoListTable() {
            if (sbstUserInfoListTable) return;
            var examInfoColumns =  [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='exam.label.dept' />", field:"deptnm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},                   /* 학과 */
                {title:"<spring:message code='exam.label.user.rprs.id' />",field:"userRprsId", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},        /* 대표아이디 */
                {title:"<spring:message code='exam.label.user.no' />", field:"stdntNo", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},               /* 학번 */
                {title:"<spring:message code='exam.label.user.nm' />", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},                 /* 이름 */
                {title:"<spring:message code="exam.label.absent.reason" />", field:"absnceCts", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:100},           /* 결시 사유 */
                {title:"<spring:message code="exam.label.appl.rate" />", field:"absnceRfltrt",  headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},       /* 적용비율 */
                {title:"<spring:message code="exam.label.absent.approve" />", field:"aplyStsStts",   headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}   /* 결시원 승인 */
            ];
            sbstUserInfoListTable = UiTable("sbstUserList", {
                lang: "ko",
                selectRow: "checkbox",
                pageFunc: loadSbstUserInfoList,
                columns: examInfoColumns
            });
        }
        /* 2 */
        function createSbstUserInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 학번
                    var stdntNo;
                    if (v.stdntNo == "" || v.stdntNo == null) {
                        stdntNo = "-";
                    } else {
                        stdntNo = v.stdntNo;
                    }
                    // 반영비율
                    var absnceRfltrt;
                    if (v.absnceRfltrt == "" || v.absnceRfltrt == null) {
                        absnceRfltrt = '-'
                    } else {
                        absnceRfltrt = v.absnceRfltrt + "%";
                    }
                    // 결시승인
                    var aplyStsStts;
                    if (v.aplyStsStts == "Y") {
                        aplyStsStts = "<span><spring:message code="exam.label.approve" /></span>";  /* 승인 */
                    } else {
                        aplyStsStts = "<span class='fcRed'><spring:message code="exam.label.unapprove" /></span>";  /* 미승인 */
                    }
                    dataList.push({
                        lineNo:         v.lineNo
                        , deptnm:       v.deptnm
                        , userRprsId:   v.userRprsId
                        , stdntNo:      stdntNo
                        , userId:       v.userId
                        , usernm:       v.usernm
                        , absnceCts:    v.absnceCts
                        , absnceRfltrt: absnceRfltrt
                        , aplyStsStts:  aplyStsStts
                        , mobileNo:     v.mobileNo
                        , email:        v.email
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadSbstUserInfoList(pageIndex) {
            initSbstUserInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/examSbstUserPaging.do",
                type: "GET",
                data: {
                    examBscId   : curExamBscId,
                    pageIndex   : PAGE_INDEX,
                    listScale   : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createSbstUserInfoListHtml(returnList);
                        sbstUserInfoListTable.clearData();
                        sbstUserInfoListTable.replaceData(dataList);
                        sbstUserInfoListTable.setPageInfo(data.pageInfo);
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

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. 팀 시험 부주제 목록 HTML append
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
         * 2. pprBtnAppend:     시험지 버튼 HTML append
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
        /* 2 */
        function pprBtnAppend() {
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
                    html += "> <spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' /></a>";    /* 시험지 */ /* 미리보기 */
                });
            }
            $("#onlnPpr").append(html);
        }

        /*****************************************************************************
         * form 요소 제어 함수
         * 1. eventSbstTypeRd :     시험 대체 유형 라디오 버튼 change 이벤트
         * 2. initQuizCheckbox:     퀴즈 체크박스 초기값 세팅
         * 3. eventFlMmTycdRd :     제출파일 유형 라디오 change 이벤트
         * 4. initFlMmTycdRd :      sbstVO.sbmsnFileMimeTycd 값 기반 라디오/체크박스 초기값 세팅
         *****************************************************************************/
        /* 1 */
        function eventSbstTypeRd() {
            $('input[name="sbst-type-rd"]').on('change', function() {
                if ($(this).val() === 'SBST_ASMT') {
                    $('#asmt-write').show();
                    $('#quiz-write').hide();
                    $('#quiz-mng-btn').hide();
                } else {
                    $('#quiz-write').show();
                    $('#asmt-write').hide();
                    $('#quiz-mng-btn').show();
                    createQuizFileUploader();
                }
            });
        }
        function createQuizFileUploader() {
            if (gbn !== '' || dx5.get('quizFileUploader')) {
                return;
            }

            UiFileUploader({
                id: "quizFileUploader",
                targetId: "quizFileUploader_box",
                lang: "ko",
                listSize: 3,
                limitSize: 100,
                oneLimitSize: 100,
                allowedTypes: "*",
                finishFunc: finishUpload,
                path: "<c:out value='${quizUploadPath}'/>",
                limitCount: 5,
                fileList: []
            });
        }
        /* 2 */
        function initQuizCheckbox() {
            if ('${sbstVO.qstnRndmyn}' === 'Y') {
                $('#quiz-mix-type').trigger('click');
            }
            if ('${sbstVO.qstnVwitmRndmyn}' === 'Y') {
                $('#quiz-view-mix-type').trigger('click');
            }
        }
        /* 3 */
        function applyFlMmView() {
            var sbasmtTycd = $('input[name="asmt-sbasmt-tycd-rd"]:checked').val();
            $('#viewSbasmtTycdFile').toggle(sbasmtTycd === 'FILE');
            $('#preFileList, #docFileList').hide();
            if (sbasmtTycd === 'FILE') {
                var opt = $('input[name="sbmsnFileMimeTycdOption"]:checked').val();
                if (opt === 'pre')      $('#preFileList').show();
                else if (opt === 'doc') $('#docFileList').show();
            }
        }
        function eventFlMmTycdRd() {
            $('input[name="asmt-sbasmt-tycd-rd"]').on('change', function() {
                $('input[name="sbmsnFileMimeTycdOption"][value="all"]').prop('checked', true);
                $('input[name="preFile"], input[name="docFile"]').prop('checked', false);
                applyFlMmView();
            });

            $('input[name="sbmsnFileMimeTycdOption"]').on('change', function() {
                $('input[name="preFile"], input[name="docFile"]').prop('checked', false);
                applyFlMmView();
            });

            applyFlMmView();
        }
        /* 4 */
        function initFlMmTycdRd() {
            var savedVal = '${sbstVO.sbmsnFileMimeTycd}';
            if (!savedVal) return;

            var savedList = savedVal.split(',');
            var opt = savedList[0];

            $('input[name="sbmsnFileMimeTycdOption"][value="' + opt + '"]').prop('checked', true);

            if (opt === 'pre') {
                savedList.slice(1).forEach(function(v) {
                    $('input[name="preFile"][value="' + v + '"]').prop('checked', true);
                });
            } else if (opt === 'doc') {
                savedList.slice(1).forEach(function(v) {
                    $('input[name="docFile"][value="' + v + '"]').prop('checked', true);
                });
            }
            applyFlMmView();
        }

        /*****************************************************************************
         * 버튼 기능
         * 1. currentSbstType :         저장 시점의 선택 유형 추적 변수
         * 2. registSbstData :          대체 시험 데이터 [등록|수정] AJAX 실행
         * 3. finishUpload :            파일 업로드 완료 콜백 > registSbstData 호출
         * 4. examSbstSaveBtnEvent :    저장 버튼 이벤트 — 파일 업로드 후 등록
         * 5. examSbstDeleteBtnEvent :  대체 시험 삭제 버튼 이벤트 (ajax)
         *****************************************************************************/
        /* 1 */
        var currentSbstType = '';
        /* 2 */
        function registSbstData() {
            var url = (gbn === '' || gbn == null)
                ? "/exam/examSbstRegist.do"
                : "/exam/examSbstModify.do";

            var isAsmt   = currentSbstType === 'SBST_ASMT';
            var formData = {
                examBscId:      curQuizId ? curQuizId : curExamBscId,
                asmtId:         curAsmtId,
                examEvlSbstId:  curExamEvlSbstId,
                sbjctId:        curSbjctId,
                examGbncd:      curExamGbncd,
                mrkRfltrt:      curMrkRfltrt,
                examSbstTycd:   currentSbstType,
                uploadFiles:    isAsmt ? $('#asmtUploadFiles').val() : $('#quizUploadFiles').val(),
                uploadPath:     isAsmt ? $('#asmtUploadPath').val()  : $('#quizUploadPath').val()
            };

            if (isAsmt) {
                // [과제] form 데이터
                var asmtContents = editors['editor_asmt'].getPublishingHtml();
                var asmtSdttm    = UiComm.getDateTimeVal("dateAsmtSt", "timeAsmtSt") + "00";
                var asmtEdttm    = UiComm.getDateTimeVal("dateAsmtEd", "timeAsmtEd") + "59";

                formData.asmtTtl        = $('#asmt-ttl').val();
                formData.asmtCts        = asmtContents;
                formData.asmtSbmsnSdttm = asmtSdttm;
                formData.asmtSbmsnEdttm = asmtEdttm;
                formData.mrkRfltyn      = $('input[name="asmt-mkr-rfltyn-rd"]:checked').val();
                formData.mrkOyn         = $('input[name="asmt-mkr-oyn-rd"]:checked').val();
                formData.evlScrTycd     = $('input[name="asmt-evl-scr-tycd-rd"]:checked').val();
                formData.rubricId       = _rubricId || document.getElementById('rubricId').value;
                console.log('[registSbstData] rubricId=', formData.rubricId);
                formData.sbasmtTycd     = $('input[name="asmt-sbasmt-tycd-rd"]:checked').val();
                var mimeTycdOpt = $('input[name="sbmsnFileMimeTycdOption"]:checked').val() || 'all';
                if (mimeTycdOpt === 'all') {
                    formData.sbmsnFileMimeTycd = 'all';
                } else {
                    var fileVals = $('input[name="preFile"]:checked, input[name="docFile"]:checked')
                        .map(function() { return $(this).val(); }).get();
                    formData.sbmsnFileMimeTycd = [mimeTycdOpt].concat(fileVals).join(',');
                }
            } else {
                // [퀴즈] form 데이터
                var quizContents = editors['editor_quiz'].getPublishingHtml();
                var quizSdttm    = UiComm.getDateTimeVal("dateQuizSt", "timeQuizSt") + "00";
                var quizEdttm    = UiComm.getDateTimeVal("dateQuizEd", "timeQuizEd") + "59";

                formData.examTtl         = $('#quiz-ttl').val();
                formData.examCts         = quizContents;
                formData.examPsblSdttm   = quizSdttm;
                formData.examPsblEdttm   = quizEdttm;
                formData.examMnts        = $('#quizMnts').val();
                formData.mrkRfltyn       = $('input[name="quiz-mkr-rfltyn-rd"]:checked').val();
                formData.mrkOyn          = $('input[name="quiz-mkr-oyn-rd"]:checked').val();
                formData.qstnDsplyGbncd  = $('input[name="quiz-view-type-rd"]:checked').val();
                formData.qstnRndmyn      = $('#quiz-mix-type').is(':checked') ? 'Y' : 'N';
                formData.qstnVwitmRndmyn = $('#quiz-view-mix-type').is(':checked') ? 'Y' : 'N';
            }

            UiComm.showLoading(true);
            $.ajax({
                url:      url,
                async:    false,
                type:     "POST",
                dataType: "json",
                data:     formData
            }).done(function(data) {
                UiComm.showLoading(false);
                if (data.result > 0) {
                    UiComm.showMessage("<spring:message code='exam.alert.insert' />", "info")   /* 정상 저장 되었습니다. */
                        .then(function() {
                            profExamViewMv(2);
                        });
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }).fail(function() {
                UiComm.showLoading(false);
                UiComm.showMessage(
                    gbn !== ''
                        ? "<spring:message code='exam.error.update' />"     /* 수정 중 에러가 발생하였습니다. */
                        : "<spring:message code='exam.error.insert' />",    /* 저장 중 에러가 발생하였습니다. */
                    "error"
                );
            });
        }
        /* 3 */
        function finishUpload() {
            var isAsmt     = currentSbstType === 'SBST_ASMT';
            var uploaderId = isAsmt ? 'fileUploader' : 'quizFileUploader';
            var $files     = isAsmt ? $('#asmtUploadFiles') : $('#quizUploadFiles');
            var $path      = isAsmt ? $('#asmtUploadPath')  : $('#quizUploadPath');
            var dx = dx5.get(uploaderId);

            ajaxCall("/common/uploadFileCheck.do",
                { uploadFiles: dx.getUploadFiles(), uploadPath: dx.getUploadPath() },
                function(data) {
                    if (data.result > 0) {
                        $files.val(dx.getUploadFiles());
                        $path.val(dx.getUploadPath());
                        registSbstData();
                    } else {
                        UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                    }
                },
                function() {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                },
                true
            );
        }
        /* 4 */
        function examSbstSaveBtnEvent() {
            $("#sbstWriteSave").on("click", function() {
                var selectedSbstType = $('input[name="sbst-type-rd"]:checked').val();
                var validatorFormId  = selectedSbstType === 'SBST_ASMT' ? 'asmt-write' : 'quiz-write';

                UiValidator(validatorFormId).then(function(result) {
                    if (result) {
                        currentSbstType = selectedSbstType;
                        var uploaderId  = selectedSbstType === 'SBST_ASMT' ? 'fileUploader' : 'quizFileUploader';
                        if (selectedSbstType === 'SBST_QUIZ') {
                            createQuizFileUploader();
                        }
                        var dx = dx5.get(uploaderId);
                        if (dx && dx.availUpload()) {
                            dx.startUpload();   // 완료 시 finishUpload() 자동 호출
                        } else {
                            finishUpload();     // 신규 파일 없으면 바로 진행
                        }
                    }
                });
            });
        }
        /* 2 */
        function examSbstDeleteBtnEvent() {
            $("#sbstWriteDelete").on("click", function() {
                UiComm.showMessage("<spring:message code='exam.confirm.exist.answer.user.del' />?", "confirm")  /* 삭제하시겠습니까? */
                    .then(function(result) {
                        if (result) {
                            var selectedSbstType = $('input[name="sbst-type-rd"]:checked').val();

                            var formData = {
                                examEvlSbstId: curExamEvlSbstId,
                                examSbstTycd:  selectedSbstType
                            };

                            if (selectedSbstType === 'SBST_ASMT') {
                                formData.asmtId = '${sbstVO.asmtId}';
                            } else {
                                formData.quizBscId = '${sbstVO.examBscId}';
                                formData.examBscId = curExamBscId;
                            }

                            UiComm.showLoading(true);
                            $.ajax({
                                url:      "/exam/examSbstDelete.do",
                                async:    false,
                                type:     "POST",
                                dataType: "json",
                                data:     formData
                            }).done(function(data) {
                                UiComm.showLoading(false);
                                if (data.result > 0) {
                                    UiComm.showMessage("<spring:message code='exam.alert.delete' />", "info")   /* 정상 삭제 되었습니다. */
                                        .then(function() {
                                            profExamViewMv(2);
                                        });
                                } else {
                                    UiComm.showMessage(data.message, "error");
                                }
                            }).fail(function() {
                                UiComm.showLoading(false);
                                UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");     /* 삭제 중 에러가 발생하였습니다. */
                            });
                        }
                    });
            });
        }

        /* 메세지 전송 기능 */
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#sbstUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (sbstUserInfoListTable.getSelectedData("userId").length == 0) {
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

        /* 문항관리 팝업 */
        function quizQstnMngPop() {
            var data = "examBscId="+curQuizId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.item'/><spring:message code='exam.label.manage'/>", /* 문항 */ /* 관리 */
                width: 800,
                height: 500,
                url: "/quiz/profQuizQstnMngView.do?"+data,
                autoresize: true
            });
        }
        /* 루브릭 팝업 */
        function rubricPop(type) {
            window.applyRubric = _applyRubricImpl;

            let rubricId = _rubricId;
            if (type === "new") {
                rubricId = "";
            } else if (type === "edit") {
                rubricId = _rubricId || document.getElementById('rubricId').value;

                if (!rubricId) {
                    UiComm.showMessage("<spring:message code='asmt.alert.evalCd.del'/><%--평가방법에서 루브릭을 선택 후 루브릭을 등록해 주세요.--%>", "error");
                    return false;
                }
            }
            dialog = UiDialog("asmtRubricWritePop", {
                title: "<spring:message code='asmt.label.rubric.reg'/><%--루브릭 등록--%>",
                width: 1200,
                height: 800,
                url: "/asmt2/profAsmtRubricWritePopup.do?sbjctId=" + curSbjctId
                    + "&rubricId=" + rubricId,
                autoresize: false,
            });
        }

        function _applyRubricImpl(rubricId, rubricTtl) {
            console.log('[applyRubric] called, rubricId=', rubricId);
            _rubricId = rubricId || '';
            document.getElementById('rubricId').value  = _rubricId;
            document.getElementById('rubricTtl').value = rubricTtl || '';
            refreshRubricTitle();
        }
        window.applyRubric = _applyRubricImpl;

        function evlScrRdChange () {
            $("input[name='asmt-evl-scr-tycd-rd']").on("change", function () {
                if (this.checked && this.value === "RUBRIC_SCR" && !$("#rubricId").val()) {
                    rubricPop("new");
                }
            });
        }
        /**
         * 선택한 루브릭 제목을 라디오 버튼 옆에 표시한다.
         */
        function refreshRubricTitle() {
            const rubricTtl = $("#rubricTtl").val();
            const isRubric = $("input[name='asmt-evl-scr-tycd-rd']:checked").val() === "RUBRIC_SCR";

            $("#rubricTitleBtn")
                .text(rubricTtl || "")
                .toggle(isRubric && !!rubricTtl);
        }

        $(document).ready(function() {
            loadSbstUserInfoList();

            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }

            initQuizCheckbox();
            eventSbstTypeRd();
            eventFlMmTycdRd();
            initFlMmTycdRd();
            examSbstDeleteBtnEvent();
            examSbstSaveBtnEvent();

            evlScrRdChange();

            pprBtnAppend();
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
                                <li class="mw120">
                                    <a onclick="profExamViewMv(1)">
                                        <spring:message code='exam.label.exam' /><!-- 시험 -->
                                        <spring:message code='exam.label.info.score.manage' /><!-- 정보 및 평가 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <li class="mw120 select" style = "pointer-events: none;">
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
                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                            </h3>
                            <div class="right-area">
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
                                                        <th><spring:message code='exam.label.onln' /> <spring:message code='exam.label.paper' /></th><!-- 온라인 --><!-- 시험지 -->
                                                        <td colspan="3" id="onlnPpr"></td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <th><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' /></th><!-- 퀴즈 --><!-- 시험지 -->
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
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(2)" style = "pointer-events: none;">
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
                        <!-- 시험 대체 상단영역 -->
                        <div class="board_top">
                            <h4 class="sub-title">[${examVO.examGbnnm}] <spring:message code='exam.label.exam.sub.set' /></h4><!-- 시험 대체 설정 -->
                            <div class="right-area">
                                <button type="button" id="sbstWriteSave" class="btn type2"><spring:message code='exam.button.save' /></button><!-- 저장 -->
                                <c:if test="${not empty gbn}">
                                    <button type="button" id="sbstWriteDelete" class="btn type2"><spring:message code='exam.button.del' /></button><!-- 삭제 -->
                                </c:if>
                                <c:if test="${gbn eq 'QUIZ'}">
                                    <button type="button" id ="quiz-mng-btn" class="btn type2" onclick="quizQstnMngPop()" style="${gbn eq 'QUIZ' ? '' : 'display:none;'}">
                                        <spring:message code='exam.label.item'/><!-- 문항 -->
                                        <spring:message code='exam.label.manage'/><!-- 관리 -->
                                    </button>
                                </c:if>
                                <button type="button" class="btn bsc" onclick="profExamViewMv(2)"><spring:message code='exam.button.list' /></button><!-- 목록 -->
                            </div>
                        </div>
                        <!-- 시험대체 선택 영역 -->
                        <table class = "table-type5" >
                            <colgroup>
                                <col class="width-15per" />
                                <col class="" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>
                                        <label for="sbst-type-label" class ="req">
                                            <spring:message code='exam.label.exam'/><!-- 시험 -->
                                            <spring:message code='exam.label.sub'/> <!-- 대체 -->
                                            <spring:message code='exam.label.type'/><!-- 유형 -->
                                        </label>
                                    </th>
                                    <td>
                                        <div class="form-row">
                                            <span class="custom-input">
                                                <input type="radio" name="sbst-type-rd" id="sbst-type-amst-rd" value="SBST_ASMT" ${gbn eq 'ASMT' || empty gbn ? 'checked' : '' } ${empty gbn ? '' : 'disabled'}>
                                                <label for="sbst-type-amst-rd"><spring:message code='exam.label.asmt'/></label><!-- 과제 -->
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="sbst-type-rd" id="sbst-type-quiz-rd" value="SBST_QUIZ" ${gbn eq 'QUIZ' ? 'checked' : '' } ${empty gbn ? '' : 'disabled'}>
                                                <label for="sbst-type-quiz-rd"><spring:message code='exam.label.quiz'/></label><!-- 퀴즈 -->
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- [과제] 시험 대체 form 영역 -->
                        <form id = "asmt-write" name = "asmt-write" style="${gbn eq 'ASMT' || empty gbn ? '' : 'display:none;'}">
                            <table class = "table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col class="" />
                                </colgroup>
                                <tbody>
                                    <!-- [과제] 과제명 -->
                                    <tr>
                                        <th>
                                            <label for="asmt-ttl-label" class ="req"><spring:message code='exam.label.asmt'/><spring:message code='exam.label.nm'/></label><!-- 과제 --><!-- 명 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-50per"
                                                       type="text" name="name" id="asmt-ttl" value="${sbstVO.asmtTtl}"
                                                       placeholder="<spring:message code='exam.alert.input.title'/>" required="true" inputmask="byte"
                                                       maxlen="150" autocomplete="off">
                                                        <!-- 제목을 입력하세요. -->
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [과제] 과제내용 -->
                                    <tr>
                                        <th>
                                            <label for="contTextarea" class = "req"><spring:message code='exam.label.asmt'/><spring:message code='exam.label.cts'/></label><!-- 과제 --><!-- 내용 -->
                                        </th>
                                        <td data-th="입력">
                                            <li>
                                                <dl>
                                                    <dd>
                                                        <div class="editor-box">
                                                            <label for="asmtCts" class="hide">Content</label>
                                                            <textarea id="asmtCts" name="asmtCts" required="true">
                                                                <c:out value="${sbstVO.asmtCts}"/>
                                                            </textarea>
                                                            <script>
                                                                // HTML 에디터
                                                                editors['editor_asmt'] = UiEditor({
                                                                    targetId: "asmtCts",
                                                                    uploadPath: "/asmt",
                                                                    height: "400px"
                                                                });
                                                            </script>
                                                        </div>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </td>
                                    </tr>
                                    <!-- [과제] 제출기간 -->
                                    <tr>
                                        <th>
                                            <label for="noticeLabel" class = "req"><spring:message code='exam.label.submit.date'/></label><!-- 제출기간 -->
                                        </th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" class="datepicker" id="dateAsmtSt" name="dateAsmtSt" timeId="timeAsmtSt" toDate="dateAsmtEd" required="true" placeholder="<spring:message code='exam.label.start.dt'/>" value="${fn:substring(sbstVO.asmtSbmsnSdttm,0,8)}"><!-- 시작일 -->
                                                <input type="text" class="timepicker" id="timeAsmtSt" name="timeAsmtSt" dateId="dateAsmtSt" required="true" placeholder="<spring:message code='exam.label.start.tm'/>" value="${fn:substring(sbstVO.asmtSbmsnSdttm,8,12)}"><!-- 시작시간 -->
                                                <span class="txt-sort">~</span>
                                                <input type="text" class="datepicker" id="dateAsmtEd" name="dateAsmtEd" timeId="timeAsmtEd" fromDate="dateAsmtSt" required="true" placeholder="<spring:message code='exam.label.end.dt'/>" value="${fn:substring(sbstVO.asmtSbmsnEdttm,0,8)}"><!-- 종료일 -->
                                                <input type="text" class="timepicker" id="timeAsmtEd" name="timeAsmtEd" dateId="dateAsmtEd" required="true" placeholder="<spring:message code='exam.label.end.tm'/>" value="${fn:substring(sbstVO.asmtSbmsnEdttm,8,12)}"><!-- 종료시간 -->
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [과제] 성적반영 -->
                                    <tr>
                                        <th>
                                            <label for="asmt-mkr-rfltyn-label"><spring:message code='exam.label.score.aply.y' /></label><!-- 성적반영 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="asmt-mkr-rfltyn-rd" id="asmt-mkr-rfltyn-y-rd" value="Y" ${sbstVO.mrkRfltyn eq 'Y' || empty gbn ? 'checked' : '' }>
                                                    <label for="asmt-mkr-rfltyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="asmt-mkr-rfltyn-rd" id="asmt-mkr-rfltyn-n-rd" value="N" ${sbstVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                    <label for="asmt-mkr-rfltyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [과제] 성적공개 -->
                                    <tr>
                                        <th>
                                            <label for="asmt-mkr-oyn-label"><spring:message code="exam.label.score.open.y" /></label><!-- 성적공개 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="asmt-mkr-oyn-rd" id="asmt-mkr-oyn-y-rd" value="Y" ${sbstVO.mrkOyn eq 'Y' || empty gbn ? 'checked' : '' }>
                                                    <label for="asmt-mkr-oyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="asmt-mkr-oyn-rd" id="asmt-mkr-oyn-n-rd" value="N" ${sbstVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                    <label for="asmt-mkr-oyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [과제] 평가방법 -->
                                    <tr>
                                        <th>
                                            <label for="asmt-evl-scr-tycd-label"><spring:message code="exam.label.eval.ctgr" /></label><!-- 평가방법 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="asmt-evl-scr-tycd-rd" id="asmt-evl-scr-tycd-scr-rd" value="SCR" ${sbstVO.evlScrTycd eq 'SCR' || empty gbn ? 'checked' : '' }>
                                                    <label for="asmt-evl-scr-tycd-scr-rd"><spring:message code="exam.label.type.score" /></label><!-- 점수형 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="asmt-evl-scr-tycd-rd" id="asmt-evl-scr-tycd-rblc-rd" value="RUBRIC_SCR" ${sbstVO.evlScrTycd eq 'RUBRIC_SCR' ? 'checked' : '' }>
                                                    <label for="asmt-evl-scr-tycd-rblc-rd"><spring:message code="exam.label.type.rubric" /></label><!-- 루브릭 -->
                                                    <button type="button" id="rubricTitleBtn" class="btn basic small ml5" onclick="rubricPop('edit');" style="display:none;"></button>
                                                    <small class="note"><spring:message code='asmt.label.evalctgr.rubric.info'/><%--루브릭 선택시 루브릭 설정 팝업이 활성화 됩니다.--%></small>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [과제] 제출형식 -->
                                    <tr>
                                        <th>
                                            <label for="asmt-sbasmt-tycd-label" class = "req"><spring:message code="exam.label.submit.type" /></label><!-- 제출형식 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="asmt-sbasmt-tycd-rd" id="asmt-sbasmt-tycd-fl-rd" value="FILE" ${sbstVO.sbasmtTycd eq 'FILE' || empty gbn ? 'checked' : '' }>
                                                    <label for="asmt-sbasmt-tycd-fl-rd"><spring:message code="exam.label.submit.type.file" /></label><!-- 파일 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="asmt-sbasmt-tycd-rd" id="asmt-sbasmt-tycd-inpt-txt-rd" value="INPUT_TEXT" ${sbstVO.sbasmtTycd eq 'INPUT_TEXT' ? 'checked' : '' }>
                                                    <label for="asmt-sbasmt-tycd-inpt-txt-rd"><spring:message code="exam.label.submit.type.text" /></label><!-- 텍스트 -->
                                                </span>
                                            </div>
                                            <div class="sub_item" id="viewSbasmtTycdFile">
                                                <div class="item">
                                                    <span class="custom-input">
                                                        <input type="radio" name="sbmsnFileMimeTycdOption" id="allFile" value="all" checked="">
                                                        <label for="allFile"><spring:message code="exam.label.submit.file.all" /></label><!-- 모든 파일 가능 -->
                                                    </span>
                                                </div>
                                                <div class="item">
                                                    <span class="custom-input">
                                                        <input type="radio" name="sbmsnFileMimeTycdOption" id="preFile" value="pre">
                                                        <label for="preFile"><spring:message code="exam.label.submit.file.prev" /></label><!-- 미리 보기 가능 -->
                                                    </span>
                                                    <div class="item-list" id="preFileList">
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="preFile" id="preFile01" value="img">
                                                            <label for="preFile01"><spring:message code="exam.label.submit.file.img" /></label><!-- 이미지 (JPG, GIF, PNG) -->
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="preFile" id="preFile02" value="pdf">
                                                            <label for="preFile02"><spring:message code="exam.label.submit.file.pdf" /></label><!-- PDF -->
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="preFile" id="preFile03" value="txt">
                                                            <label for="preFile03"><spring:message code="exam.label.submit.file.txt" /></label><!-- TXT -->
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="preFile" id="preFile04" value="soc">
                                                            <label for="preFile04"><spring:message code="exam.label.submit.file.prgr" /></label><!-- 프로그램 소스 -->
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="item">
                                                    <span class="custom-input">
                                                        <input type="radio" name="sbmsnFileMimeTycdOption" id="docFile" value="doc">
                                                        <label for="docFile"><spring:message code="exam.label.submit.file.spcfc" /></label><!-- 특정 파일 가능 -->
                                                    </span>
                                                    <div class="item-list" id="docFileList">
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="docFile" id="docFile01" value="hwp">
                                                            <label for="docFile01"><spring:message code="exam.label.submit.file.hwp" /></label><!-- HWP -->
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="docFile" id="docFile02" value="doc">
                                                            <label for="docFile02"><spring:message code="exam.label.submit.file.doc" /></label><!-- DOC -->
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="docFile" id="docFile03" value="ppt">
                                                            <label for="docFile03"><spring:message code="exam.label.submit.file.ppt" /></label><!-- PPT -->
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="docFile" id="docFile04" value="xls">
                                                            <label for="docFile04"><spring:message code="exam.label.submit.file.xls" /></label><!-- XLS -->
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [과제] 첨부파일 -->
                                    <tr>
                                        <th>
                                            <label for="asmt-sbmsn-atfl-label"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
                                        </th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${gbn eq 'ASMT' || empty gbn}">
                                                    <uiex:dextuploader
                                                        id="fileUploader"
                                                        path="${asmtUploadPath}"
                                                        limitCount="5"
                                                        limitSize="100"
                                                        oneLimitSize="100"
                                                        listSize="3"
                                                        fileList="${gbn eq 'ASMT' ? sbstVO.fileList : ''}"
                                                        finishFunc="finishUpload()"
                                                        allowedTypes="*"
                                                    />
                                                </c:when>
                                                <c:otherwise>
                                                    <div id="fileUploader_box"></div>
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="hidden" id="asmtUploadFiles" name="uploadFiles"/>
                                            <input type="hidden" id="asmtUploadPath"  name="uploadPath" value="${asmtUploadPath}"/>
                                            <input type="hidden" id="rubricId"  name="rubricId"  value="${sbstVO.rubricId}"/>
                                            <input type="hidden" id="rubricTtl" name="rubricTtl"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                        <!-- [퀴즈] 시험 대체 form 영역 -->
                        <form id = "quiz-write" name = "quiz-write" style="${gbn eq 'QUIZ' ? '' : 'display:none;'}">
                            <table class = "table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col class="" />
                                </colgroup>
                                <tbody>
                                    <!-- [퀴즈] 퀴즈명 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-ttl-label" class ="req"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></label><!-- 퀴즈 --><!-- 명 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-50per"
                                                       type="text" name="name" id="quiz-ttl" value="${sbstVO.examTtl}"
                                                       placeholder="<spring:message code='exam.alert.input.title'/>" required="true" inputmask="byte"
                                                       maxlen="150" autocomplete="off">
                                                        <!-- 제목을 입력하세요. -->
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 퀴즈내용 -->
                                    <tr>
                                        <th>
                                            <label for="contTextarea" class = "req"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.cts" /></label><!-- 퀴즈 --><!-- 내용 -->
                                        </th>
                                        <td data-th="입력">
                                            <li>
                                                <dl>
                                                    <dd>
                                                        <div class="editor-box">
                                                            <label for="quizCts" class="hide">Content</label>
                                                            <textarea id="quizCts" name="quizCts" required="true">
                                                                <c:out value="${sbstVO.examCts}"/>
                                                            </textarea>
                                                            <script>
                                                                // HTML 에디터
                                                                editors['editor_quiz'] = UiEditor({
                                                                    targetId: "quizCts",
                                                                    uploadPath: "/quiz",
                                                                    height: "400px"
                                                                });
                                                            </script>
                                                        </div>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 응시기간 -->
                                    <tr>
                                        <th>
                                            <label for="noticeLabel" class = "req"><spring:message code="exam.button.stare.start" /><spring:message code="exam.label.period" /></label><!-- 응시 --><!-- 기간 -->
                                        </th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" class="datepicker" id="dateQuizSt" name="dateQuizSt" timeId="timeQuizSt" toDate="dateQuizEd" required="true" placeholder="<spring:message code='exam.label.start.dt'/>" value="${fn:substring(sbstVO.examPsblSdttm,0,8)}"><!-- 시작일 -->
                                                <input type="text" class="timepicker" id="timeQuizSt" name="timeQuizSt" dateId="dateQuizSt" required="true" placeholder="<spring:message code='exam.label.start.tm'/>" value="${fn:substring(sbstVO.examPsblSdttm,8,12)}"><!-- 시작시간 -->
                                                <span class="txt-sort">~</span>
                                                <input type="text" class="datepicker" id="dateQuizEd" name="dateQuizEd" timeId="timeQuizEd" fromDate="dateQuizSt" required="true" placeholder="<spring:message code='exam.label.end.dt'/>" value="${fn:substring(sbstVO.examPsblEdttm,0,8)}"><!-- 종료일 -->
                                                <input type="text" class="timepicker" id="timeQuizEd" name="timeQuizEd" dateId="dateQuizEd" required="true" placeholder="<spring:message code='exam.label.end.tm'/>" value="${fn:substring(sbstVO.examPsblEdttm,8,12)}"><!-- 종료시간 -->
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- 시험시간 -->
                                    <tr>
                                        <th>
                                            <label for="timeLabel" class = "req"><spring:message code='exam.label.exam.time'/></label><!-- 시험시간 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <div class="input_btn">
                                                    <input class="form-control sm" id="quizMnts" type="text" inputmask="numeric" maxlength="3" required="true" value="${sbstVO.examMnts}"><label><spring:message code='exam.label.min.time'/></label><!-- 분 -->
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 성적반영 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-mkr-rfltyn-label"><spring:message code="exam.label.score.aply.y" /></label><!-- 성적반영 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-y-rd" value="Y" ${sbstVO.mrkRfltyn eq 'Y' || empty gbn ? 'checked' : '' }>
                                                    <label for="quiz-mkr-rfltyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-n-rd" value="N" ${sbstVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                    <label for="quiz-mkr-rfltyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 성적공개 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-mkr-oyn-label"><spring:message code="exam.label.score.open.y" /></label><!-- 성적공개 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-y-rd" value="Y" ${sbstVO.mrkOyn eq 'Y' || empty gbn ? 'checked' : '' }>
                                                    <label for="quiz-mkr-oyn-y-rd"><spring:message code="exam.common.yes" /></label><!-- 예 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-n-rd" value="N" ${sbstVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                    <label for="quiz-mkr-oyn-n-rd"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 문제표시방식 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-view-type-label"><spring:message code="exam.label.type.view.qstn" /></label><!-- 문제 표시방식 -->
                                        </th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-all-rd" value="WHOL" ${sbstVO.qstnDsplyGbncd eq 'WHOL' || empty gbn ? 'checked' : '' }>
                                                    <label for="quiz-view-type-all-rd"><spring:message code="exam.label.all.view.qstn" /></label><!-- 전체 문제표시 -->
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-one-rd" value="EACH" ${sbstVO.qstnDsplyGbncd eq 'EACH' ? 'checked' : '' }>
                                                    <label for="quiz-view-type-one-rd"><spring:message code="exam.label.each.view.qstn" /></label><!-- 페이지별로 1문제씩 표시 -->
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 문제 섞기 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-mix-type-label" class = "req"><spring:message code="exam.label.qstn.random" /></label><!-- 문제 섞기 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input type="checkbox" id="quiz-mix-type" class="switch yesno">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 보기 섞기 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-view-mix-type-label" class = "req"><spring:message code="exam.label.empl.random" /></label><!-- 보기 섞기 -->
                                        </th>
                                        <td>
                                            <div class="form-row">
                                                <input type="checkbox" id="quiz-view-mix-type" class="switch yesno">
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- [퀴즈] 첨부파일 -->
                                    <tr>
                                        <th>
                                            <label for="quiz-sbmsn-atfl-label"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
                                        </th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${gbn eq 'QUIZ'}">
                                                    <uiex:dextuploader
                                                        id="quizFileUploader"
                                                        path="${quizUploadPath}"
                                                        limitCount="5"
                                                        limitSize="100"
                                                        oneLimitSize="100"
                                                        listSize="3"
                                                        fileList="${sbstVO.fileList}"
                                                        finishFunc="finishUpload()"
                                                        allowedTypes="*"
                                                    />
                                                </c:when>
                                                <c:otherwise>
                                                    <div id="quizFileUploader_box"></div>
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="hidden" id="quizUploadFiles" name="uploadFiles"/>
                                            <input type="hidden" id="quizUploadPath"  name="uploadPath" value="${quizUploadPath}"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                        <!-- 시험 대체 대상자 영역 -->
                        <div class="board_top margin-top-4">
                            <h4 class="sub-title">[${examVO.examGbnnm}] <spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /> <spring:message code='exam.label.target.user' /></h4><!-- 시험 --><!-- 대체 --><!-- 대상자 -->
                            <div class="right-area">
                                <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='exam.button.eval.send' /></a><!-- 보내기 -->
                            </div>
                        </div>
                        <div id = "sbstUserArea">
                            <div id="sbstUserList"></div>
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
