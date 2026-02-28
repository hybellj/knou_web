<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <script type="text/javascript">
        var ACTIVE_CRITERIA;
        var MENU_TYPE = '<c:out value="${menuType}" />';
        var IS_PROFESSOR = MENU_TYPE.indexOf('PROFESSOR') > -1;
        var IS_PREV_COURSE = '<c:out value="${prevCourseYn}" />' == 'Y' ? true : false;
        var isKnou = "<%=SessionInfo.isKnou(request)%>";

        $(document).ready(function () {
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode == 13) {
                    // 조회
                    search();
                }
            });

            // 과제, 토론, 시험, 퀴즈 버튼 첫번째 클릭 - 목록 조회
            $("[data-criteria]").eq(0).trigger("click");
        });

        // 조회
        function search() {
            // 성적 반영 비율 수정 취소
            cancelScoreRatio();
            list();
        }

        // listScale 변경
        function onChangeListScale() {
            // 조회
            search();
        }

        // 과제, 토론, 시험, 퀴즈 버튼 선택
        function selectCriteria(el) {
            var criteria = $(el).data("criteria");

            // 과제, 토론, 시험, 퀴즈 1개 선택
            $("[data-criteria]").removeClass("active").removeClass("basic").addClass("basic");
            $(el).removeClass("basic").addClass("active");

            // 현재 선택된 것
            ACTIVE_CRITERIA = criteria;

            // 성적 반영 비율 버튼 초기화
            cancelScoreRatio();

            // 검색조건 초기화
            $("#searchValue").val("");

            // 조회
            search();
        }

        // 성적 반영 비율 수정 폼 열기
        function openEditScoreRatioForm() {
            // 교수만 가능
            if (!IS_PROFESSOR) return;
            var listScale = $("#listScale").val();

            var openForm = function () {
                // 검색조건 초기화
                $("#searchValue").val("");
                list().done(function () {
                    // 성적 반영 비율 조정 버튼 show();
                    $("#scoreRatioEditFormOpenBtn").hide();
                    // 성적 반영 비율 수정 버튼 show
                    $("#scoreRatioEditBtn").show();
                    // 취소 버튼 show
                    $("#scroeRatioEditCancelBtn").show();

                    // 리스트 성적반영비율 수정 영역 활성화
                    $(".scoreRatioText").hide();
                    $(".scoreRatioEdit").show();

                    // 리스트 성적반영비율 값 초기화
                    $.each($("[data-score-ratio]"), function () {
                        this.value = $(this).data("scoreRatio");
                    });
                });
            }

            openForm();
        }

        // 성적반영 비율 수정
        function editScoreRatio() {
            // 교수만 가능
            if (!IS_PROFESSOR) return;

            var ratioSum = 0;

            $.each($("[data-score-ratio]"), function () {
                var scoreRatio = this.value || 0;

                ratioSum += 1 * scoreRatio;
            });

            if (ratioSum != 100) {
                alert('<spring:message code="crs.message.error.score_apply_sum" />'); // 성적반영 비율 합이 100%이여야 합니다.
                return;
            }

            var url = "/crs/updateEvalCriteriaScoreRatio.do";
            var data;
            var data = {
                crsCreCd: '<c:out value="${crsCreCd}" />'
                , searchKey: ACTIVE_CRITERIA
            }

            var form = $("<form></form>");
            form.attr("name", "form");

            form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
            form.append($('<input/>', {type: 'hidden', name: 'searchKey', value: ACTIVE_CRITERIA}));

            $.each($("[data-score-ratio]"), function () {
                var key = $(this).data("key");
                var scoreRatio = this.value || 0;

                form.append($('<input/>', {type: 'hidden', name: 'keyList', value: key}));
                form.append($('<input/>', {type: 'hidden', name: 'scoreRatioList', value: scoreRatio}));
            });

            data = $(form).serialize();

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    alert('<spring:message code="crs.message.alert.save" />'); // 수정되었습니다.
                    // 성적 반영 비율 수정 취소 상태
                    cancelScoreRatio();
                    // 목록 갱신
                    list();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }

        // 성적 반영 비율 수정 취소
        function cancelScoreRatio() {
            // 성적 반영 비율 조정 버튼 show();
            $("#scoreRatioEditFormOpenBtn").show();
            // 성적 반영 비율 수정 버튼 hide
            $("#scoreRatioEditBtn").hide();
            // 취소 버튼 hide
            $("#scroeRatioEditCancelBtn").hide();

            // 리스트 성적반영비율 수정 영역 비활성화
            $(".scoreRatioText").show();
            $(".scoreRatioEdit").hide();

            // 리스트 성적반영비율 값 초기화
            $.each($("[data-score-ratio]"), function () {
                this.value = "";
            });
        }

        // 성적공개 수정
        function editScoreOpen(cd, el) {
            // 교수 & 관리자만 가능
            if (!IS_PROFESSOR) return;
            var url, data;

            if (ACTIVE_CRITERIA == "ASMNT") {
                url = "/asmtProfAsmtMrkOpenYnModify.do";
                data = {
                    asmntCd: cd
                    , scoreOpenYn: el.checked ? "Y" : "N"
                };

                data.selectType = "LIST";
            } else if (ACTIVE_CRITERIA == "FORUM") {
                url = "/forum/forumLect/editForumOpen.do";
                data = {
                    forumCd: cd
                    , scoreOpenYn: el.checked ? "Y" : "N"
                };
            } else if (ACTIVE_CRITERIA == "EXAM") {
                url = "/exam/editExamScoreOpen.do";
                data = {
                    examCd: cd
                    , scoreOpenYn: el.checked ? "Y" : "N"
                    , gradeViewYn: el.checked ? "Y" : "N"
                };
            } else if (ACTIVE_CRITERIA == "QUIZ") {
                url = "/quiz/quizMrkOynModify.do";
                data = {
                    examBscId: cd
                    , mrkOyn: el.checked ? "Y" : "N"
                    , exampprOyn: el.checked ? "Y" : "N"
                };
            } else if (ACTIVE_CRITERIA == "RESCH") {
                url = "/resh/editScoreOpenYn.do";
                data = {
                    reschCd: cd
                    , scoreOpenYn: el.checked ? "Y" : "N"
                };
            }

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {

                } else {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                    el.checked = !el.checked;
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                el.checked = !el.checked;
            });
        };

        // 목록 전체 조회
        function list() {
            var deferred = $.Deferred();

            var url = "/crs/listEvalCriteria.do";
            var data = {
                crsCreCd: '<c:out value="${crsCreCd}" />'
                , searchValue: $("#searchValue").val()
                , searchKey: ACTIVE_CRITERIA
                , pagingYn: 'N'
            };

            return $.ajax({
                url: url,
                data: data,
                type: "POST",
            }).done(function (data) {
                if (data.result > 0) {
                    createTable(data);

                    deferred.resolve();
                } else {
                    alert(data.message);
                    createTable();
                    deferred.reject();
                }
            }).fail(function () {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                createTable();
                deferred.reject();
            });
        }

        // 목록 생성
        function createTable(data) {
            if (ACTIVE_CRITERIA == "ASMNT") {
                createTableAsmnt(data);
            } else if (ACTIVE_CRITERIA == "FORUM") {
                createTableForum(data);
            } else if (ACTIVE_CRITERIA == "EXAM") {
                if (isKnou == "true") { //기관 한사대만
                    createTableExam(data);
                }
            } else if (ACTIVE_CRITERIA == "QUIZ") {
                createTableQuiz(data);
            } else if (ACTIVE_CRITERIA == "RESCH") {
                createTableResch(data);
            }
        }

        // 과제 목록 생성
        function createTableAsmnt(data) {
            var returnList = data && data.returnList || [];

            var listHtml = '';

            if (!IS_PROFESSOR) {
                returnList = returnList.filter(function (v) {
                    return v.asmntOpenYn == 'Y'
                });
            }

            returnList.forEach(function (v, i) {
                var sendStartDttmFmt = (v.sendStartDttm || "").length == 14 ? v.sendStartDttm.substring(0, 4) + '.' + v.sendStartDttm.substring(4, 6) + '.' + v.sendStartDttm.substring(6, 8) + ' ' + v.sendStartDttm.substring(8, 10) + ':' + v.sendStartDttm.substring(10, 12) : v.sendStartDttm;
                var sendEndDttmFmt = (v.sendEndDttm || "").length == 14 ? v.sendEndDttm.substring(0, 4) + '.' + v.sendEndDttm.substring(4, 6) + '.' + v.sendEndDttm.substring(6, 8) + ' ' + v.sendEndDttm.substring(8, 10) + ':' + v.sendEndDttm.substring(10, 12) : v.sendEndDttm;

                var extSendDttmFmt = (v.extSendDttm || "").length == 14 ? v.extSendDttm.substring(0, 4) + '.' + v.extSendDttm.substring(4, 6) + '.' + v.extSendDttm.substring(6, 8) + ' ' + v.extSendDttm.substring(8, 10) + ':' + v.extSendDttm.substring(10, 12) : v.extSendDttm;
                var scoreOpenYnChecked = v.scoreOpenYn == "Y" ? "checked" : "";

                // 평가방법
                var evalCtgrText = "-";

                if (v.evalCtgr == "P") {
                    evalCtgrText = '<spring:message code="crs.label.point" />'; // 점수형
                } else if (v.evalCtgr == "R") {
                    evalCtgrText = '<spring:message code="crs.label.rubric" />'; // 루브릭
                }

                // 성적공개여부
                var scoreOpenYnNm;

                if (v.scoreOpenYn == 'Y') {
                    scoreOpenYnNm = '<spring:message code="crs.label.public" />'; // 공개
                } else {
                    scoreOpenYnNm = '<span class="fcRed"><spring:message code="crs.label.private" /></span>'; // 비공개
                }

                // 진행상태
                var progressNm;

                if (v.progress == "READY") {
                    progressNm = '<spring:message code="crs.label.ready" />'; // 대기
                } else if (v.progress == "PROGRESS") {
                    progressNm = '<spring:message code="crs.label.progress" />'; // 진행
                } else if (v.progress == "END") {
                    progressNm = '<spring:message code="crs.label.end" />'; // 완료
                }

                // 참여여부
                var joinYnText = "";

                if (!IS_PROFESSOR) {
                    if (v.joinYn == "Y") {
                        joinYnText = '<spring:message code="crs.label.submit" />'; // 제출
                    } else {
                        joinYnText = '<spring:message code="crs.label.no.submit" />'; // 미제출
                    }
                }

                var asmntCtgrNm = "";
                if (v.asmntCtgrCd == 'TEAM') {
                    asmntCtgrNm += "	<spring:message code='asmnt.label.team'/>";//팀
                    asmntCtgrNm += "	<spring:message code='asmnt.label.asmnt'/>";//과제
                } else if (v.asmntCtgrCd == 'INDIVIDUAL') {
                    asmntCtgrNm += "	<spring:message code='asmnt.label.individual.asmnt'/>";//개별과제
                } else if (v.asmntCtgrCd == 'NOMAL') {
                    asmntCtgrNm += "	<spring:message code='asmnt.label.nomal.asmnt'/>";//일반과제
                } else if (v.asmntCtgrCd == 'PRACTICE') {
                    asmntCtgrNm += "	<spring:message code='asmnt.label.practice.asmnt'/>";//실기과제
                } else if (v.asmntCtgrCd == 'SUBS' || v.asmntCtgrCd == 'EXAM') {
                    asmntCtgrNm += "<label class='ui pink label active'>";
                    if (v.examStareTypeCd == 'M') {
                        asmntCtgrNm += "<spring:message code='asmnt.label.mid.exam'/>"; // 중간고사
                    } else if (v.examStareTypeCd == 'L') {
                        asmntCtgrNm += "<spring:message code='asmnt.label.end.exam'/>"; // 기말고사
                    }
                } else {
                    asmntCtgrNm = v.asmntCtgrCd;
                }

                listHtml += '<tr>';
                listHtml += '	<td>' + (returnList.length - i) + '</td>';
                listHtml += '	<td>' + asmntCtgrNm + '</td>';
                if (v.evalCtgr == "R" && IS_PROFESSOR && !IS_PREV_COURSE) {
                    listHtml += '<td class="tl"><a href="javascript:void(0)" onclick="mutEvalWritePop(\'' + (v.evalCd || '') + '\')" class="fcBlue">' + v.asmntTitle + '</a></td>';
                } else {
                    listHtml += '<td class="tl">' + v.asmntTitle + '</td>';
                }
                listHtml += '	<td class="tl">' + sendStartDttmFmt + ' ~<br />' + sendEndDttmFmt + '</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>';
                    if (v.scoreAplyYn == "Y") {
                        listHtml += '<span class="scoreRatioText">' + (v.scoreRatio || 0) + '%</span>';
                        listHtml += '<div class="ui input scoreRatioEdit" style="display: none;">';
                        listHtml += '	<input type="text" class="w40 tr" placeholder="0" maxlength="3" data-score-ratio="' + (v.scoreRatio || 0) + '" data-key="' + v.asmntCd + '" /><div class="flex-item-center">%</div>';
                        listHtml += '</div>';
                    } else {
                        listHtml += '<span>-</span>';
                    }
                }
                listHtml += '	</td>';
                listHtml += '	<td>' + evalCtgrText + '</td>';
                listHtml += '	<td>' + (extSendDttmFmt || '-') + '</td>';
                listHtml += '	<td>';
                if (IS_PROFESSOR) {
                    if (IS_PREV_COURSE) {
                        listHtml += scoreOpenYnNm;
                    } else {
                        listHtml += '<div class="ui toggle checkbox">';
                        listHtml += '	<input type="checkbox" class="hidden" id="scoreOpenYn_' + i + '" ' + scoreOpenYnChecked + ' onchange="editScoreOpen(\'' + v.asmntCd + '\', this)" /><label for="scoreOpenYn_' + i + '"></label>';
                        listHtml += '</div>';
                    }
                } else {
                    listHtml += scoreOpenYnNm;
                }
                listHtml += '	</td>';
                listHtml += '	</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>' + progressNm + '</td>';
                } else {
                    listHtml += '<td>' + joinYnText + '</td>';
                }
                listHtml += '</tr>';
            });

            var html = '';

            html += '<table id="asmntListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">';
            html += '	<thead>';
            html += '		<tr>';
            html += '			<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>';// NO
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.type" /></th>'; // 구분
            html += '			<th scope="col"><spring:message code="crs.label.asmnt_name" /></th>'; // 과제명
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.submit_period" /></th>'; // 제출기간
            if (IS_PROFESSOR) {
                html += '		<th scope="col"><spring:message code="crs.label.score_apply_rate" /></th>'; // 성적반영 비율
            }
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.eval_method" /></th>'; // 평가 방법
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.late_deadline_date" /></th>'; // 지각제출 마감일
            //html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.asmnt_open" /></th>'; // 과제 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.score_open" /></th>'; // 성적 공개
            if (IS_PROFESSOR) {
                html += '		<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.progress_status" /></th>'; // 진행 상태
            } else {
                html += '		<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.submit.yn" /></th>'; // 제출여부
            }
            html += '		</tr>';
            html += '	</thead>';
            html += '	<tbody>';
            html += listHtml;
            html += '	</tbody>';
            html += '</table>';

            $("#tableArea").empty().html(html);
            $("#asmntListTable").footable();

            // 성적반영비율 유효성 체크 이벤트
            $("[data-score-ratio]").on("input", onInputScoreRatio);
        }

        // 토론 목록 생성
        function createTableForum(data) {
            var returnList = data && data.returnList || [];

            var listHtml = '';

            returnList.forEach(function (v, i) {
                var forumStartDttmFmt = (v.forumStartDttm || "").length == 14 ? v.forumStartDttm.substring(0, 4) + '.' + v.forumStartDttm.substring(4, 6) + '.' + v.forumStartDttm.substring(6, 8) + ' ' + v.forumStartDttm.substring(8, 10) + ':' + v.forumStartDttm.substring(10, 12) : v.forumStartDttm;
                var forumEndDttmFmt = (v.forumEndDttm || "").length == 14 ? v.forumEndDttm.substring(0, 4) + '.' + v.forumEndDttm.substring(4, 6) + '.' + v.forumEndDttm.substring(6, 8) + ' ' + v.forumEndDttm.substring(8, 10) + ':' + v.forumEndDttm.substring(10, 12) : v.forumEndDttm;

                var scoreOpenYnChecked = v.scoreOpenYn == "Y" ? "checked" : "";

                // 구분
                var forumCtgrNm = "-";

                if (v.forumCtgrCd == "NORMAL") {
                    forumCtgrNm = '<spring:message code="forum.label.type.forum" />'; // 일반토론
                } else if (v.forumCtgrCd == "TEAM") {
                    forumCtgrNm = '<spring:message code="forum.label.type.teamForum" />'; // 팀토론
                }

                // 평가방법
                var evalCtgrText = "-";

                if (v.evalCtgr == "P") {
                    evalCtgrText = '<spring:message code="crs.label.point" />'; // 점수형
                } else if (v.evalCtgr == "R") {
                    evalCtgrText = '<spring:message code="forum.label.evalctgr.participate" />'; // 참여형
                }

                // 성적공개여부
                var scoreOpenYnNm;

                if (v.scoreOpenYn == 'Y') {
                    scoreOpenYnNm = '<spring:message code="crs.label.public" />'; // 공개
                } else {
                    scoreOpenYnNm = '<span class="fcRed"><spring:message code="crs.label.private" /></span>'; // 비공개
                }

                // 진행상태
                var progressNm;

                if (v.progress == "READY") {
                    progressNm = '<spring:message code="crs.label.ready" />'; // 대기
                } else if (v.progress == "PROGRESS") {
                    progressNm = '<spring:message code="crs.label.progress" />'; // 진행
                } else if (v.progress == "END") {
                    progressNm = '<spring:message code="crs.label.end" />'; // 완료
                }

                // 참여여부
                var joinYnText = "";

                if (!IS_PROFESSOR) {
                    if (v.joinYn == "Y") {
                        joinYnText = '<spring:message code="crs.label.atnd" />'; // 참여
                    } else {
                        joinYnText = '<spring:message code="crs.label.no.atnd" />'; // 미참여
                    }
                }

                listHtml += '<tr>';
                listHtml += '	<td>' + (returnList.length - i) + '</td>';
                listHtml += '	<td>' + forumCtgrNm + '</td>';
                if (v.evalCtgr == "R" && IS_PROFESSOR && !IS_PREV_COURSE) {
                    listHtml += '<td class="tl"><a href="javascript:void(0)" onclick="mutEvalWritePop(\'' + (v.evalCd || '') + '\')" class="fcBlue">' + v.forumTitle + '</a></td>';
                } else {
                    listHtml += '<td class="tl">' + v.forumTitle + '</td>';
                }

                listHtml += '	<td class="tl">' + forumStartDttmFmt + ' ~<br />' + forumEndDttmFmt + '</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>';
                    if (v.scoreAplyYn == "Y") {
                        listHtml += '<span class="scoreRatioText">' + (v.scoreRatio || 0) + '%</span>';
                        listHtml += '<div class="ui input scoreRatioEdit" style="display: none;">';
                        listHtml += '	<input type="text" class="w40 tr" placeholder="0" maxlength="3" data-score-ratio="' + (v.scoreRatio || 0) + '" data-key="' + v.forumCd + '" /><div class="flex-item-center">%</div>';
                        listHtml += '</div>';
                    } else {
                        listHtml += '<span>-</span>';
                    }
                    listHtml += '</td>';
                }
                listHtml += '	<td>' + evalCtgrText + '</td>';
                listHtml += '	<td>';
                if (IS_PROFESSOR) {
                    if (IS_PREV_COURSE) {
                        listHtml += scoreOpenYnNm;
                    } else {
                        listHtml += '<div class="ui toggle checkbox">';
                        listHtml += '	<input type="checkbox" class="hidden" id="scoreOpenYn_' + i + '" ' + scoreOpenYnChecked + ' onchange="editScoreOpen(\'' + v.forumCd + '\', this)" /><label for="scoreOpenYn_' + i + '"></label>';
                        listHtml += '</div>';
                    }
                } else {
                    listHtml += scoreOpenYnNm;
                }
                listHtml += '	</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>' + progressNm + '</td>';
                } else {
                    listHtml += '<td>' + joinYnText + '</td>';
                }
                listHtml += '</tr>';
            });

            var html = '';

            html += '<table id="forumListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">';
            html += '	<thead>';
            html += '		<tr>';
            html += '			<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>'; // NO
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.type" /></th>'; // 구분
            html += '			<th scope="col"><spring:message code="crs.label.forum_name" /></th>'; // 토론명
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.join_period" /></th>'; // 참여기간
            if (IS_PROFESSOR) {
                html += '		<th scope="col"><spring:message code="crs.label.score_apply_rate" /></th>'; // 성적반영 비율
            }
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.eval_method" /></th>'; // 평가 방법
            //html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.forum_open" /></th>'; // 토론 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.score_open" /></th>'; // 성적 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.progress_status" /></th>'; // 진행 상태
            html += '		</tr>';
            html += '	</thead>';
            html += '	<tbody>';
            html += listHtml;
            html += '	</tbody>';
            html += '</table>';

            $("#tableArea").empty().html(html);
            $("#forumListTable").footable();

            // 성적반영비율 유효성 체크 이벤트
            $("[data-score-ratio]").on("input", onInputScoreRatio);
        }

        // 시험 목록 생성
        function createTableExam(data) {
            var returnList = data && data.returnList || [];
            var listHtml = '';

            returnList.forEach(function (v, i) {
                var examStartDttmFmt = (v.examStartDttm || "").length == 14 ? v.examStartDttm.substring(0, 4) + '.' + v.examStartDttm.substring(4, 6) + '.' + v.examStartDttm.substring(6, 8) + ' ' + v.examStartDttm.substring(8, 10) + ':' + v.examStartDttm.substring(10, 12) : v.examStartDttm;
                var examEndDttmFmt = (v.examEndDttm || "").length == 14 ? v.examEndDttm.substring(0, 4) + '.' + v.examEndDttm.substring(4, 6) + '.' + v.examEndDttm.substring(6, 8) + ' ' + v.examEndDttm.substring(8, 10) + ':' + v.examEndDttm.substring(10, 12) : v.examEndDttm;

                var scoreOpenYnChecked = v.scoreOpenYn == "Y" ? "checked" : "";

                // 성적공개여부
                var scoreOpenYnNm;

                if (v.scoreOpenYn == 'Y') {
                    scoreOpenYnNm = '<spring:message code="crs.label.public" />'; // 공개
                } else {
                    scoreOpenYnNm = '<span class="fcRed"><spring:message code="crs.label.private" /></span>'; // 비공개
                }

                // 진행상태
                var progressNm;

                if (v.progress == "READY") {
                    progressNm = '<spring:message code="crs.label.ready" />'; // 대기
                } else if (v.progress == "PROGRESS") {
                    progressNm = '<spring:message code="crs.label.progress" />'; // 진행
                } else if (v.progress == "END") {
                    progressNm = '<spring:message code="crs.label.end" />'; // 완료
                }

                // 참여여부
                var joinYnText = "";

                if (!IS_PROFESSOR) {
                    if (v.joinYn == "Y") {
                        joinYnText = '<spring:message code="crs.label.join" />'; // 응시
                    } else {
                        joinYnText = '<spring:message code="crs.label.no.join" />'; // 미응시
                    }
                }

                listHtml += '<tr>';
                listHtml += '	<td>' + (returnList.length - i) + '</td>';
                listHtml += '	<td>' + (v.examTypeCd == "QUIZ" ? '<spring:message code="crs.label.quiz" />' : '<spring:message code="crs.label.live.exam" />') + '</td>'; // 퀴즈, 실시간 시험
                listHtml += '	<td class="tl">' + v.examTitle + '</td>';
                listHtml += '	<td class="tl">' + examStartDttmFmt + ' ~<br />' + examEndDttmFmt + '</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>';
                    if (v.scoreAplyYn == "Y") {
                        listHtml += '<span class="scoreRatioText">' + (v.scoreRatio || 0) + '%</span>';
                        listHtml += '<div class="ui input scoreRatioEdit" style="display: none;">';
                        listHtml += '	<input type="text" class="w40 tr" placeholder="0" maxlength="3" data-score-ratio="' + (v.scoreRatio || 0) + '" data-key="' + v.examCd + '" /><div class="flex-item-center">%</div>';
                        listHtml += '</div>';
                    } else {
                        listHtml += '<span>-</span>';
                    }
                    listHtml += '</td>';
                }
                listHtml += '	<td>';
                if (IS_PROFESSOR) {
                    if (IS_PREV_COURSE) {
                        listHtml += scoreOpenYnNm;
                    } else {
                        listHtml += '<div class="ui toggle checkbox">';
                        listHtml += '	<input type="checkbox" class="hidden" id="scoreOpenYn_' + i + '" ' + scoreOpenYnChecked + ' onchange="editScoreOpen(\'' + v.examCd + '\', this)" /><label for="scoreOpenYn_' + i + '"></label>';
                        listHtml += '</div>';
                    }
                } else {
                    listHtml += scoreOpenYnNm;
                }
                listHtml += '	</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>' + progressNm + '</td>';
                } else {
                    listHtml += '<td>' + joinYnText + '</td>';
                }
                listHtml += '</tr>';
            });

            var html = '';

            html += '<table id="examListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">';
            html += '	<thead>';
            html += '		<tr>';
            html += '			<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>'; // NO
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.type" /></th>'; // 구분
            html += '			<th scope="col"><spring:message code="crs.label.exam_name" /></th>'; // 시험명
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.exam_period" /></th>'; // 시험기간
            if (IS_PROFESSOR) {
                html += '		<th scope="col"><spring:message code="crs.label.score_apply_rate" /></th>'; // 성적반영 비율
            }
            //html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.exam_open" /></th>'; // 시험 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.score_open" /></th>'; // 성적 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.progress_status" /></th>'; // 진행 상태
            html += '		</tr>';
            html += '	</thead>';
            html += '	<tbody>';
            html += listHtml;
            html += '	</tbody>';
            html += '</table>';

            $("#tableArea").empty().html(html);
            $("#examListTable").footable();
        }

        // 퀴즈 목록 생성
        function createTableQuiz(data) {
            var returnList = data && data.returnList || [];
            var listHtml = '';

            returnList.forEach(function (v, i) {
                var examStartDttmFmt = (v.examStartDttm || "").length == 14 ? v.examStartDttm.substring(0, 4) + '.' + v.examStartDttm.substring(4, 6) + '.' + v.examStartDttm.substring(6, 8) + ' ' + v.examStartDttm.substring(8, 10) + ':' + v.examStartDttm.substring(10, 12) : v.examStartDttm;
                var examEndDttmFmt = (v.examEndDttm || "").length == 14 ? v.examEndDttm.substring(0, 4) + '.' + v.examEndDttm.substring(4, 6) + '.' + v.examEndDttm.substring(6, 8) + ' ' + v.examEndDttm.substring(8, 10) + ':' + v.examEndDttm.substring(10, 12) : v.examEndDttm;

                var scoreOpenYnChecked = v.scoreOpenYn == "Y" ? "checked" : "";

                // 성적공개여부
                var scoreOpenYnNm;

                if (v.scoreOpenYn == 'Y') {
                    scoreOpenYnNm = '<spring:message code="crs.label.public" />'; // 공개
                } else {
                    scoreOpenYnNm = '<span class="fcRed"><spring:message code="crs.label.private" /></span>'; // 비공개
                }

                // 진행상태
                var progressNm;

                if (v.progress == "READY") {
                    progressNm = '<spring:message code="crs.label.ready" />'; // 대기
                } else if (v.progress == "PROGRESS") {
                    progressNm = '<spring:message code="crs.label.progress" />'; // 진행
                } else if (v.progress == "END") {
                    progressNm = '<spring:message code="crs.label.end" />'; // 완료
                }

                // 참여여부
                var joinYnText = "";

                if (!IS_PROFESSOR) {
                    if (v.joinYn == "Y") {
                        joinYnText = '<spring:message code="crs.label.join" />'; // 응시
                    } else {
                        joinYnText = '<spring:message code="crs.label.no.join" />'; // 미응시
                    }
                }

                listHtml += '<tr>';
                listHtml += '	<td>' + (returnList.length - i) + '</td>';
                listHtml += '	<td class="tl">' + v.examTitle + '</td>';
                listHtml += '	<td class="tl">' + examStartDttmFmt + ' ~<br />' + examEndDttmFmt + '</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>';
                    if (v.scoreAplyYn == "Y") {
                        listHtml += '<span class="scoreRatioText">' + (v.scoreRatio || 0) + '%</span>';
                        listHtml += '<div class="ui input scoreRatioEdit" style="display: none;">';
                        listHtml += '	<input type="text" class="w40 tr" placeholder="0" maxlength="3" data-score-ratio="' + (v.scoreRatio || 0) + '" data-key="' + v.examCd + '" /><div class="flex-item-center">%</div>';
                        listHtml += '</div>';
                    } else {
                        listHtml += '<span>-</span>';
                    }
                    listHtml += '</td>';
                }
                listHtml += '	<td>';
                if (IS_PROFESSOR) {
                    if (IS_PREV_COURSE) {
                        listHtml += scoreOpenYnNm;
                    } else {
                        listHtml += '<div class="ui toggle checkbox">';
                        listHtml += '	<input type="checkbox" class="hidden" id="scoreOpenYn_' + i + '" ' + scoreOpenYnChecked + ' onchange="editScoreOpen(\'' + v.examCd + '\', this)" /><label for="scoreOpenYn_' + i + '"></label>';
                        listHtml += '</div>';
                    }
                } else {
                    listHtml += scoreOpenYnNm;
                }
                listHtml += '	</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>' + progressNm + '</td>';
                } else {
                    listHtml += '<td>' + joinYnText + '</td>';
                }
                listHtml += '</tr>';
            });

            var html = '';

            html += '<table id="quizListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">';
            html += '	<thead>';
            html += '		<tr>';
            html += '			<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>'; // NO
            html += '			<th scope="col"><spring:message code="crs.label.quiz_name" /></th>'; // 퀴즈명
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.quiz_period" /></th>'; // 퀴즈기간
            if (IS_PROFESSOR) {
                html += '		<th scope="col"><spring:message code="crs.label.score_apply_rate" /></th>'; // 성적반영 비율
            }
            //html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.quiz_open" /></th>'; // 퀴즈 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.score_open" /></th>'; // 성적 공개
            html += '			<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.progress_status" /></th>'; // 진행 상태
            html += '		</tr>';
            html += '	</thead>';
            html += '	<tbody>';
            html += listHtml;
            html += '	</tbody>';
            html += '</table>';

            $("#tableArea").empty().html(html);
            $("#quizListTable").footable();
        }

        // 설문 목록 생성
        function createTableResch(data) {
            var returnList = data && data.returnList || [];
            var listHtml = '';

            returnList.forEach(function (v, i) {
                var reschStartDttmFmt = (v.reschStartDttm || "").length == 14 ? v.reschStartDttm.substring(0, 4) + '.' + v.reschStartDttm.substring(4, 6) + '.' + v.reschStartDttm.substring(6, 8) + ' ' + v.reschStartDttm.substring(8, 10) + ':' + v.reschStartDttm.substring(10, 12) : (v.reschStartDttm || "");
                var reschEndDttmFmt = (v.reschEndDttm || "").length == 14 ? v.reschEndDttm.substring(0, 4) + '.' + v.reschEndDttm.substring(4, 6) + '.' + v.reschEndDttm.substring(6, 8) + ' ' + v.reschEndDttm.substring(8, 10) + ':' + v.reschEndDttm.substring(10, 12) : (v.reschEndDttm || "");

                var scoreOpenYnChecked = v.scoreOpenYn == "Y" ? "checked" : "";

                // 성적공개여부
                var scoreOpenYnNm;

                if (v.scoreOpenYn == 'Y') {
                    scoreOpenYnNm = '<spring:message code="crs.label.public" />'; // 공개
                } else {
                    scoreOpenYnNm = '<span class="fcRed"><spring:message code="crs.label.private" /></span>'; // 비공개
                }

                // 진행상태
                var progressNm;

                if (v.progress == "READY") {
                    progressNm = '<spring:message code="crs.label.ready" />'; // 대기
                } else if (v.progress == "PROGRESS") {
                    progressNm = '<spring:message code="crs.label.progress" />'; // 진행
                } else if (v.progress == "END") {
                    progressNm = '<spring:message code="crs.label.end" />'; // 완료
                }

                // 참여여부
                var joinYnText = "";

                if (!IS_PROFESSOR) {
                    if (v.joinYn == "Y") {
                        joinYnText = '<spring:message code="crs.label.atnd" />'; // 참여
                    } else {
                        joinYnText = '<spring:message code="crs.label.no.atnd" />'; // 미참여
                    }
                }

                listHtml += '<tr>';
                listHtml += '	<td>' + (returnList.length - i) + '</td>';
                listHtml += '	<td class="tl">' + v.reschTitle + '</td>';
                listHtml += '	<td class="tl">' + reschStartDttmFmt + ' ~<br />' + reschEndDttmFmt + '</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>';
                    if (v.scoreAplyYn == "Y") {
                        listHtml += '<span class="scoreRatioText">' + (v.scoreRatio || 0) + '%</span>';
                        listHtml += '<div class="ui input scoreRatioEdit" style="display: none;">';
                        listHtml += '	<input type="text" class="w40 tr" placeholder="0" maxlength="3" data-score-ratio="' + (v.scoreRatio || 0) + '" data-key="' + v.reschCd + '" /><div class="flex-item-center">%</div>';
                        listHtml += '</div>';
                    } else {
                        listHtml += '<span>-</span>';
                    }
                    listHtml += '</td>';
                }
                listHtml += '	<td>';
                if (IS_PROFESSOR) {
                    if (IS_PREV_COURSE) {
                        listHtml += scoreOpenYnNm;
                    } else {
                        listHtml += '<div class="ui toggle checkbox">';
                        listHtml += '	<input type="checkbox" class="hidden" id="scoreOpenYn_' + i + '" ' + scoreOpenYnChecked + ' onchange="editScoreOpen(\'' + v.reschCd + '\', this)" /><label for="scoreOpenYn_' + i + '"></label>';
                        listHtml += '</div>';
                    }
                } else {
                    listHtml += scoreOpenYnNm;
                }
                listHtml += '	</td>';
                if (IS_PROFESSOR) {
                    listHtml += '<td>' + progressNm + '</td>';
                } else {
                    listHtml += '<td>' + joinYnText + '</td>';
                }
                listHtml += '</tr>';
            });

            var html = '';

            html += '<table id="reschListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">';
            html += '	<thead>';
            html += '		<tr>';
            html += '			<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>'; // NO
            html += '			<th scope="col"><spring:message code="crs.label.resch_name" /></th>'; // 설문명
            html += '			<th scope="col" data-breakpoints="xs" class="wf15"><spring:message code="crs.label.resch_period" /></th>'; // 설문기간
            if (IS_PROFESSOR) {
                html += '		<th scope="col" class="wf11"><spring:message code="crs.label.score_apply_rate" /></th>'; // 성적반영 비율
            }
            html += '			<th scope="col" data-breakpoints="xs" class="wf8"><spring:message code="crs.label.score_open" /></th>'; // 성적 공개
            html += '			<th scope="col" data-breakpoints="xs" class="wf8"><spring:message code="crs.label.progress_status" /></th>'; // 진행 상태
            html += '		</tr>';
            html += '	</thead>';
            html += '	<tbody>';
            html += listHtml;
            html += '	</tbody>';
            html += '</table>';

            $("#tableArea").empty().html(html);
            $("#reschListTable").footable();
        }

        function onInputScoreRatio() {
            $(this).val(Number($(this).val()));

            var sum = 0;

            $("[data-score-ratio]").each(function () {
                sum = Number(sum) + Number($(this).val());
            });

            if (sum > 100) {
                $(this).val(Number($(this).val()) + (100 - sum));
            } else if ($(this).val() > 100) {
                $(this).val(100);
            }
        }

        // 평가방법 (루브릭) 모달
        function mutEvalWritePop(evalCd) {
            // 교수 & 관리자만 가능
            if (!IS_PROFESSOR) return;

            $("#scoreItemConfForm > input[name='crsCreCd']").val('<c:out value="${crsCreCd}" />');
            $("#scoreItemConfForm > input[name='evalCd']").val(evalCd);
            $("#scoreItemConfForm").attr("target", "mutEvalWriteIfm");
            $("#scoreItemConfForm").attr("action", "/mut/mutPop/mutEvalWritePop.do");
            $("#scoreItemConfForm").submit();
            $('#mutEvalWritePop').modal('show');
        }

        // 평가기준 수정모드
        function changeEditModeScoreItemConf() {
            // 교수 & 관리자만 가능
            if (!IS_PROFESSOR) return;

            $(".scoreItemConfText").hide();
            $(".scoreItemConfInput").show();

            var regex = /[^0-9]/g;
            $.each($("[data-score-type-cd]"), function () {
                var scoreTypeCd = $(this).data("scoreTypeCd");

                if (scoreTypeCd == "ASSIGNMENT") {
                    this.value = ('<c:out value="${scoreItemConfMap.ASSIGNMENT}" />' || "").replace(regex, "");
                } else if (scoreTypeCd == "FORUM") {
                    this.value = ('<c:out value="${scoreItemConfMap.FORUM}" />' || "").replace(regex, "");
                } else if (scoreTypeCd == "QUIZ") {
                    this.value = ('<c:out value="${scoreItemConfMap.QUIZ}" />' || "").replace(regex, "");
                } else if (scoreTypeCd == "RESH") {
                    this.value = ('<c:out value="${scoreItemConfMap.RESH}" />' || "").replace(regex, "");
                } else if (scoreTypeCd == "LESSON") {
                    this.value = ('<c:out value="${scoreItemConfMap.LESSON}" />' || "").replace(regex, "");
                }
            });

            $("#scoreItemConfEditModeBtn").hide();
            $("#scoreItemConfSaveBtn").show();
            $("#scoreItemConfCancelBtn").show();

            $("#scoreItemConfSaveBtn").off("click").on("click", function () {
                saveScoreItemConf();
            });

            $("#scoreItemConfCancelBtn").off("click").on("click", function () {
                cancelScoreItemConfEditMode();
            });
        }

        // 평가기준 수정모드 취소
        function cancelScoreItemConfEditMode() {
            $(".scoreItemConfText").show();
            $(".scoreItemConfInput").hide();

            $("#scoreItemConfEditModeBtn").show();
            $("#scoreItemConfSaveBtn").hide();
            $("#scoreItemConfCancelBtn").hide();

            $.each($("[data-score-type-cd]"), function () {
                this.value = "";
            });

            $("#scoreItemConfSaveBtn").off("click");
            $("#scoreItemConfCancelBtn").off("click");
        }

        // 평가기준 저장
        function saveScoreItemConf() {
            var scoreItemConfList = [];
            var totalRate = 0;

            $.each($("[data-score-type-cd]"), function () {
                var scoreTypeCd = $(this).data("scoreTypeCd");
                var scoreRatio = Number(this.value);

                totalRate += scoreRatio;

                scoreItemConfList.push({
                    crsCreCd: '<c:out value="${crsCreCd}" />'
                    , scoreTypeCd: scoreTypeCd
                    , scoreRatio: scoreRatio
                });
            });

            if (totalRate != 100) {
                alert('<spring:message code="score.alert.incorrect.rate.sum" />'); // 비율의 합계를 100으로 설정하세요.
                return;
            }

            var url = "/score/scoreOverall/updateScoreItemConf.do"
            var data = JSON.stringify(scoreItemConfList);

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    alert('<spring:message code="crs.message.alert.save" />'); // 수정되었습니다.
                    cancelScoreItemConfEditMode();
                    getScoreItemConf();

                    if (typeof window.parent.evalCriteriaCallBack) {
                        window.parent.evalCriteriaCallBack();
                    }
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            }, true, {
                dataType: "json",
                contentType: 'application/json',
            });
        }

        // 평가기준 조회
        function getScoreItemConf() {
            var url = "/score/scoreOverall/selectScoreItemConfList.do"
            var data = {
                crsCreCd: '<c:out value="${crsCreCd}" />'
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];

                    $.each($(".scoreItemConfText"), function () {
                        $(this)[0].innerText = "-";
                    });

                    returnList.forEach(function (v, i) {
                        var $el = $("#scoreTypeCd_" + v.scoreTypeCd)[0];

                        if ($el) {
                            $el.innerText = (v.scoreRatio + "%" || "-");
                        }
                    });
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            }, true);
        }

        // 숫자입력 체크
        function checkNumber(el) {
            var regex = /[^0-9]/g;

            var inputVal = Number((el.value || "").replace(regex, ""));

            if (typeof inputVal === "number") {
                el.value = "" + (inputVal > 100 ? 100 : inputVal);
            } else {
                el.value = "0";
            }
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<div id="wrap">
    <div class="option-content mt10 mb10">
        <div class="sec_head">
            <spring:message code="crs.label.eval_criteria_sub_title1" /><!-- 평가 기준 (수업계획서) -->
        </div>
        <%
            if(!SessionInfo.isKnou(request)) {
        %>
        <div class="flex-left-auto">
            <button class="ui blue icon button" type="button" onclick="changeEditModeScoreItemConf()"
                    id="scoreItemConfEditModeBtn"><spring:message code="common.button.modify" /><!-- 수정 --></button>
            <button class="ui basic icon button" type="button" style="display: none;" id="scoreItemConfSaveBtn">
                <spring:message code="common.button.save" /><!-- 저장 --></button>
            <button class="ui grey icon button" type="button" style="display: none;" id="scoreItemConfCancelBtn">
                <spring:message code="common.button.cancel" /><!-- 취소 --></button>
        </div>
        <%
            }
        %>
    </div>
    <table class="tbl type2" summary="<spring:message code="common.label.eval.crit" />"><!-- 평가기준 -->
        <%
            if(SessionInfo.isKnou(request)) {
        %>
        <thead>
        <tr>
            <th scope="col" class="col wf10"><spring:message code="crs.label.eval_item" /><!-- 평가항목 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.mid_exam" /><!-- 중간고사 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.final_exam" /><!-- 기말고사 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.asmnt" /><!-- 과제 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.forum" /><!-- 토론 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.quiz" /><!-- 퀴즈 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.resch" /><!-- 설문 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.attend" /><!-- 출석 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.nomal_exam" /><!-- 수시평가 --></th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td data-title="<spring:message code="crs.label.eval_item" />">
                <spring:message code="crs.label.rate" /><!-- 비율 --></td>
            <td data-title="<spring:message code="crs.label.mid_exam" />"><c:out
                    value="${not empty scoreItemConfMap.MIDDLE_TEST ? scoreItemConfMap.MIDDLE_TEST : '-'}"/></td>
            <td data-title="<spring:message code="crs.label.final_exam" />"><c:out
                    value="${not empty scoreItemConfMap.LAST_TEST ? scoreItemConfMap.LAST_TEST : '-'}"/></td>
            <td data-title="<spring:message code="crs.label.asmnt" />"><span class="scoreItemConfText"><c:out
                    value="${not empty scoreItemConfMap.ASSIGNMENT ? scoreItemConfMap.ASSIGNMENT : '-'}"/></span></td>
            <td data-title="<spring:message code="crs.label.forum" />"><span class="scoreItemConfText"><c:out
                    value="${not empty scoreItemConfMap.FORUM ? scoreItemConfMap.FORUM : '-'}"/></span></td>
            <td data-title="<spring:message code="crs.label.quiz" />"><span class="scoreItemConfText"><c:out
                    value="${not empty scoreItemConfMap.QUIZ ? scoreItemConfMap.QUIZ : '-'}"/></span></td>
            <td data-title="<spring:message code="crs.label.resch" />"><span class="scoreItemConfText"><c:out
                    value="${not empty scoreItemConfMap.RESH ? scoreItemConfMap.RESH : '-'}"/></span></td>
            <td data-title="<spring:message code="crs.label.attend" />"><span class="scoreItemConfText"><c:out
                    value="${not empty scoreItemConfMap.LESSON ? scoreItemConfMap.LESSON : '-'}"/></span></td>
            <td data-title="<spring:message code="crs.label.nomal_exam" />"><c:out
                    value="${not empty scoreItemConfMap.TEST ? scoreItemConfMap.TEST : '-'}"/></td>
        </tr>
        </tbody>
        <%
        } else {
        %>
        <thead>
        <tr>
            <th scope="col" class="col wf10"><spring:message code="crs.label.eval_item" /><!-- 평가항목 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.asmnt" /><!-- 과제 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.forum" /><!-- 토론 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.quiz" /><!-- 퀴즈 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.resch" /><!-- 설문 --></th>
            <th scope="col" class="col wf10"><spring:message code="crs.label.attend" /><!-- 출석 --></th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td data-title="<spring:message code="crs.label.eval_item" />">
                <spring:message code="crs.label.rate" /><!-- 비율 --></td>
            <td data-title="<spring:message code="crs.label.asmnt" />">
						<span class="scoreItemConfText" id="scoreTypeCd_ASSIGNMENT">
							<c:out value="${not empty scoreItemConfMap.ASSIGNMENT ? scoreItemConfMap.ASSIGNMENT : '-'}"/>
						</span>
                <div class="ui input scoreItemConfInput" style="display: none;">
                    <input type="text" class="w50" data-score-type-cd="ASSIGNMENT" maxlength="3"
                           oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                           onfocus="this.select()" onblur="checkNumber(this)"/>
                </div>
            </td>
            <td data-title="<spring:message code="crs.label.forum" />">
						<span class="scoreItemConfText" id="scoreTypeCd_FORUM">
							<c:out value="${not empty scoreItemConfMap.FORUM ? scoreItemConfMap.FORUM : '-'}"/>
						</span>
                <div class="ui input scoreItemConfInput" style="display: none;">
                    <input type="text" class="w50" data-score-type-cd="FORUM" maxlength="3"
                           oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                           onfocus="this.select()" onblur="checkNumber(this)"/>
                </div>
            </td>
            <td data-title="<spring:message code="crs.label.quiz" />">
						<span class="scoreItemConfText" id="scoreTypeCd_QUIZ">
							<c:out value="${not empty scoreItemConfMap.QUIZ ? scoreItemConfMap.QUIZ : '-'}"/>
						</span>
                <div class="ui input scoreItemConfInput" style="display: none;">
                    <input type="text" class="w50" data-score-type-cd="QUIZ" maxlength="3"
                           oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                           onfocus="this.select()" onblur="checkNumber(this)"/>
                </div>
            </td>
            <td data-title="<spring:message code="crs.label.resch" />">
						<span class="scoreItemConfText" id="scoreTypeCd_RESH">
							<c:out value="${not empty scoreItemConfMap.RESH ? scoreItemConfMap.RESH : '-'}"/>
						</span>
                <div class="ui input scoreItemConfInput" style="display: none;">
                    <input type="text" class="w50" data-score-type-cd="RESH" maxlength="3"
                           oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                           onfocus="this.select()" onblur="checkNumber(this)"/>
                </div>
            </td>
            <td data-title="<spring:message code="crs.label.attend" />">
						<span class="scoreItemConfText" id="scoreTypeCd_LESSON">
							<c:out value="${not empty scoreItemConfMap.LESSON ? scoreItemConfMap.LESSON : '-'}"/>
						</span>
                <div class="ui input scoreItemConfInput" style="display: none;">
                    <input type="text" class="w50" data-score-type-cd="LESSON" maxlength="3"
                           oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                           onfocus="this.select()" onblur="checkNumber(this)"/>
                </div>
            </td>
        </tr>
        </tbody>
        <%
            }
        %>
    </table>

    <div class="option-content mt20 mb10">
        <div class="sec_head">
            <c:choose>
                <c:when test="${menuType.contains('PROFESSOR')}">
                    <spring:message code="crs.label.eval_criteria_sub_title2"/><!-- 성적 반영비율 관리 -->
                </c:when>
                <c:otherwise>
                    <spring:message code="crs.label.eval_criteria_sub_title3"/><!-- 평가항목별 참여현황 -->
                </c:otherwise>
            </c:choose>
        </div>
        <div class="flex-left-auto">
            <div class="ui buttons mb10">
                <c:if test="${not empty scoreItemConfMap.ASSIGNMENT }">
                    <button class="ui blue button active" data-criteria="ASMNT" onclick="selectCriteria(this)">
                        <spring:message code="crs.button.asmnt" /><!-- 과제 --></button>
                </c:if>
                <c:if test="${not empty scoreItemConfMap.FORUM }">
                    <button class="ui basic blue button" data-criteria="FORUM" onclick="selectCriteria(this)">
                        <spring:message code="crs.button.forum" /><!-- 토론 --></button>
                </c:if>
                <c:if test="${not empty scoreItemConfMap.QUIZ }">
                    <button class="ui basic blue button" data-criteria="QUIZ" onclick="selectCriteria(this)">
                        <spring:message code="crs.button.quiz" /><!-- 퀴즈 --></button>
                </c:if>
                <c:if test="${not empty scoreItemConfMap.RESH }">
                    <button class="ui basic blue button" data-criteria="RESCH" onclick="selectCriteria(this)">
                        <spring:message code="crs.button.resch" /><!-- 설문 --></button>
                </c:if>
                <%
                    if(SessionInfo.isKnou(request)) {
                %>
                <c:if test="${not empty scoreItemConfMap.TEST }">
                    <button class="ui basic blue button" data-criteria="EXAM" onclick="selectCriteria(this)">
                        <spring:message code="crs.button.any" /><!-- 수시 --></button>
                </c:if>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <div class="option-content mb10">
        <div class="ui action input search-box">
            <label for="searchValue" class="hide"><spring:message code="common.search.keyword"/></label>
            <input id="searchValue" type="text" placeholder="<spring:message code="common.search.keyword" />"/>
            <!-- 검색어 -->
            <button class="ui black icon button" type="button" onclick="search()">
                <i class="search icon"></i>
            </button>
        </div>

        <div class="select_area inline-flex">
            <c:if test="${menuType.contains('PROFESSOR') and prevCourseYn ne 'Y'}">
                <a href="javascript:void(0)" onclick="openEditScoreRatioForm()" class="ui blue button mt5"
                   id="scoreRatioEditFormOpenBtn">
                    <spring:message code="crs.button.score_apply.revise" /><!-- 성적 반영 비율 조정 --></a>
                <a href="javascript:void(0)" onclick="editScoreRatio()" class="ui basic button mt5"
                   id="scoreRatioEditBtn" style="display: none;">
                    <spring:message code="crs.button.score_apply.edit" /><!-- 성적 반영 비율 수정 --></a>
                <a href="javascript:void(0)" onclick="cancelScoreRatio()" class="ui grey button mt5"
                   id="scroeRatioEditCancelBtn" style="display: none;">
                    <spring:message code="common.button.cancel" /><!-- 취소 --></a>
            </c:if>
        </div>
    </div>

    <div id="tableArea">
    </div>

    <div class="bottom-content">
        <button class="ui black cancel button" onclick="window.parent.closeModal();">
            <spring:message code="common.button.close" /><!-- 닫기 --></button>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>

<!-- 평가기준 등록 팝업 -->
<form id="mutEvalWritePopForm" name="mutEvalWritePopForm">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="evalCd"/>
</form>
<div class="modal fade" id="mutEvalWritePop" tabindex="-1" role="dialog"
     aria-labelledby="<spring:message code="crs.label.eval_criteria_reg" />" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="sys.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="crs.label.eval_criteria_reg" /><!-- 평가기준 등록 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" id="mutEvalWriteIfm" name="mutEvalWriteIfm" width="100%" height="1500px" scrolling="no"
                        title="평가기준"></iframe>
            </div>
        </div>
    </div>
</div>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');
    };
</script>
</body>
</html>