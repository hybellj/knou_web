<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>


<script type="text/javascript">
    $(document).ready(function () {
        // 최초 조회
        onSearch(1);

        // 엔터키
        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                onSearch(1);
            }
        });
    });

    // 리스트 OR 카드 화면 변경
    function onChangeList() {
        onChangeView(4); // 성적반영 OFF

        if ($("#typeBtn i").attr("class") != "list ul icon") {
            onChangeView(1); // 카드형 호출
            $(".mla.mr5 a").eq(0).attr("href", "javascript:onChangeScoreRatio(2);");
            onSearch(1, 'CARD');
        } else {
            onChangeView(2); // 리스트형 호출
            $(".mla.mr5 a").eq(0).attr("href", "javascript:onChangeScoreRatio(1);");
            onSearch(1);
        }
    }

    // 리스트 조회
    function onSearch(page, type) {

        var selectType = "LIST";
        /* var selectType = "PAGE";

        if(type == "EDIT"){
            $('#listScale').attr("onchange","");
            $("#listScale").dropdown('set selected', '전체');
            $('#listScale').attr("onchange","onChangeListScale();");
        }if(type == "CARD"){
            selectType = "LIST";
        }

        if($("#listScale").val() == 0) selectType = "LIST"; */

        var url = "/asmt/stu/getAsmnt.do";
        var data = {
            "selectType": selectType,
            "crsCreCd": "${vo.crsCreCd}",
            //"pageIndex"   : page,
            //"listScale"   : $("#listScale").val(),
            "searchValue": $("#searchValue").val()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {

                var html = "";

                if (data.returnList.length > 0) {
                    // 화면 생성
                    var dataList = data.returnList || [];
                    $("#listDiv").empty().html(createHTML(dataList));

                    if ($("#typeBtn i").attr("class") != "list ul icon") { // 리스트
                        $("#listDiv").attr("class", "sixteen wide column");
                        $('div[name="scoreEditDiv"]').hide();
                        $(".table").footable();

                        $("#listDiv tbody tr").each(function (i) {
                            $("#listDiv tbody tr:eq(" + i + ") td:eq(2)").css("text-align", "left");
                        });

                        /* if(selectType == "LIST"){
                            if(type == "EDIT") onChangeView(3);
                        }else{
                            var params = {
                                    totalCount : data.pageInfo.totalRecordCount,
                                    listScale : data.pageInfo.pageSize,
                                    currentPageNo : data.pageInfo.currentPageNo,
                                    eventName : "onSearch"
                                };

                            gfn_renderPaging(params);
                        } */
                        if (type == "EDIT") onChangeView(3);

                    } else { // 카드
                        $("#listDiv").prop("class", "ui two stackable cards info-type mt10");
                        $('.ui.dropdown').dropdown();

                        $(".ui.label").on("click", function () {
                            $(".ui.label").toggleClass('active');
                        });
                    }

                    // 공통
                    $('.ui.checkbox').checkbox();

                    $('input:checkbox[name="scoreOpenArray"]').change(function () {
                        updateScoreOpen($(this).val(), $(this).is(":checked"));
                    });
                } else {
                    $("#listDiv").empty().html(creatNullHTML());
                    $(".table").footable();
                    $('.table tbody').hide();
                }

            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    function onChangeView(key) {
        switch (key) {
            case 1:
                // 카드 VIEW
                $("#typeBtn i").attr("class", "list ul icon");
                $("#typeBtn i").attr("title", "<spring:message code='asmnt.label.title.card'/>");//리스트형 출력
                /* $("#listScale").parent().hide(); */
                break;

            case 2:
                // 리스트 VIEW
                $("#typeBtn i").attr("class", "th ul icon");
                $("#typeBtn i").attr("title", "<spring:message code='asmnt.label.title.card'/>");//카드형 출력
                /* $("#listScale").parent().show(); */
                break;

        }
    }

    // 목록크기 변경
    /* function onChangeListScale(){
        onSearch(1);
    } */

    //과제 정보 페이지
    function viewAsmnt(asmtId, tab) {
        var urlMap = {
            "0": "/asmt/stu/asmtInfoManage.do",	// 과제 상세 정보 페이지
            "1": "/asmt/stu/asmtScoreManage.do"	// 과제 평가 관리 페이지
        };

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': asmtId});

        submitForm(urlMap[tab], "", kvArr);
    }

    //팀 구성원 보기
    function teamMemberView(lrnGrpId) {
        var modalId = "Ap06";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'lrnGrpId', 'val': lrnGrpId});

        submitForm("/forum/forumLect/teamMemberList.do", modalId + "ModalIfm", kvArr);
    }

    // NULL HTML 생성
    function creatNullHTML() {
        var html = "";

        html += "<table class='table type2' data-sorting='true' data-paging='false' data-empty='<spring:message code="resh.common.empty" />'>";
        html += "	<thead>";
        html += "		<tr>";
        html += "			<th scope='col' data-type='' class='tc num'><spring:message code='common.number.no' /></th>";
        html += "      		<th scope='col' data-breakpoints='xs' class='tc'><spring:message code='user.title.userinfo.manage.userdiv' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm'><spring:message code='asmnt.label.asmnt.title' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='asmnt.label.send.date' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='exam.label.score.aply.y' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='asmnt.label.late.send.deadline.dt' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='common.label.score.reveal' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='crs.label.submit.yn' /></th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='exam.label.manage' /></th>";
        html += "		</tr>";
        html += "	</thead>";
        html += "	<tbody>";
        html += "	</tbody>";
        html += "</table>";
        html += "<div class='title'>";
        html += "	<div class='flex-container'>";
        html += "		<div class='cont-none'>";
        html += "			<span><spring:message code='resh.common.empty' /></span>";
        html += "		</div>";
        html += "	</div>";
        html += "</div>";

        return html;
    }

    // HTML 생성
    function createHTML(data) {
        var html = "";

        if ($("#typeBtn i").attr("class") != "list ul icon") {

            html += "		<table class='table type2' data-sorting='true' data-paging='false' data-empty='<spring:message code="resh.common.empty" />'>";
            html += "			<thead>";
            html += "				<tr>";
            html += "				<th scope='col' data-type='' class='tc num'><spring:message code='common.number.no' /></th>";
            html += "	          	<th scope='col' data-breakpoints='xs' class='tc'><spring:message code='user.title.userinfo.manage.userdiv' /></th>";
            html += "           		<th scope='col'><spring:message code='asmnt.label.asmnt.title' /></th>";
            html += "           		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='asmnt.label.send.date' /></th>";
            html += "           		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='asmnt.label.late.send.deadline.dt' /></th>";
            html += "           		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='exam.label.score.aply.y' /></th>";
            //html += "           	<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='exam.label.score.open.y' /></th>";
            html += "           		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='exam.label.submit.yn' /></th>";
            html += "           		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='forum.label.feedback' /> </th>";
            html += "           		<th scope='col' data-breakpoints='xs sm md' class='tc'><spring:message code='exam.label.manage' /></th>";
            html += "				</tr>";
            html += "			</thead>";
            html += "			<tbody>";

            $.each(data, function (i, o) {
                var asmtSbmsnSdttm = o.asmtSbmsnSdttm.substring(0, 4) + '.' + o.asmtSbmsnSdttm.substring(4, 6) + '.' + o.asmtSbmsnSdttm.substring(6, 8) + ' ' + o.asmtSbmsnSdttm.substring(8, 10) + ':' + o.asmtSbmsnSdttm.substring(10, 12);
                var sendEndDttm = o.sendEndDttm.substring(0, 4) + '.' + o.sendEndDttm.substring(4, 6) + '.' + o.sendEndDttm.substring(6, 8) + ' ' + o.sendEndDttm.substring(8, 10) + ':' + o.sendEndDttm.substring(10, 12);
                var extSendDttm = o.extSendDttm != null && o.extSendDttm != "" ? o.extSendDttm.substring(0, 4) + '.' + o.extSendDttm.substring(4, 6) + '.' + o.extSendDttm.substring(6, 8) + ' ' + o.extSendDttm.substring(8, 10) + ':' + o.extSendDttm.substring(10, 12) : "-";
                var scoreAply = o.mrkRfltyn == 'Y' ? "<spring:message code='asmnt.common.yes'/>" : "<spring:message code='asmnt.common.no'/>";
                //var scoreOpen = o.mrkOyn == 'Y' ? "<spring:message code='crs.label.public' />" : "<spring:message code='crs.label.private' />";

                html += "<tr>";
                html += "	<td class='tc'>" + o.lineNo + "</td>";
                html += "	<td class='tc'>";
                if (o.asmtGbncd == 'TEAM') {
                    html += "	<spring:message code='asmnt.label.team'/>";//팀
                    html += "	<spring:message code='asmnt.label.asmnt'/>";//과제
                } else if (o.asmtGbncd == 'INDIVIDUAL') {
                    html += "	<spring:message code='asmnt.label.individual.asmnt'/>";//개별과제
                } else if (o.asmtGbncd == 'NOMAL') {
                    html += "	<spring:message code='asmnt.label.nomal.asmnt'/>";//일반과제
                } else if (o.asmtGbncd == 'PRACTICE') {
                    html += "	<spring:message code='asmnt.label.practice.asmnt'/>";//실기과제
                } else if (o.asmtGbncd == 'SUBS' || o.asmtGbncd == 'EXAM') {
                    html += "<label class='ui pink label active'>";
                    if (o.examStareTypeCd == 'M') {
                        html += "<spring:message code='asmnt.label.mid.exam'/>"; // 중간고사
                    } else if (o.examStareTypeCd == 'L') {
                        html += "<spring:message code='asmnt.label.end.exam'/>"; // 기말고사
                    }
                }
                html += "	</td>";
                html += "	<td><a href=\"javascript:viewAsmnt('" + o.asmtId + "', 0)\" class='header header-icon link'> " + o.asmtTtl + "</a></td>";
                html += "	<td class='tc'>" + asmtSbmsnSdttm + " ~ " + sendEndDttm + "</td>";
                html += "	<td class='tc'>" + extSendDttm + "</td>";
                html += "	<td class='tc'>";
                if (o.examStareTypeCd == 'M') {
                    html += "<spring:message code='crs.label.mid_exam' />";
                } else if (o.examStareTypeCd == 'L') {
                    html += "<spring:message code='crs.label.final_exam' />";
                } else {
                    html += scoreAply;
                }
                html += "	</td>";
                //html += "	<td class='tc'>" + scoreOpen + "</td>";
                if ("<%=SessionInfo.getAuditYn(request) %>" == "Y") {
                    html += "	<td class='tc'>-</td>";
                } else if (o.evalYn == 'Y') {
                    if (o.mrkOyn == 'N') {
                        html += "	<td class='tc'>" + (o.sbmsnStscdnm || "-") + "</td>";
                    } else {
                        html += "	<td class='tc'>" + o.scr + " <spring:message code='forum.label.point' />	</td>";
                    }
                } else {
                    html += "<td class='tc'>";
                    if (o.sbmsnStscdnm == "제출") {
                        html += "<spring:message code='asmnt.label.submit.y'/>";
                    } else if (o.sbmsnStscdnm == "미제출") {
                        html += "<spring:message code='asmnt.label.submit.n'/>";
                    } else if (o.sbmsnStscdnm == "지각제출") {
                        html += "<spring:message code='asmnt.label.submit.late2'/>";
                    } else if (o.sbmsnStscdnm == "재제출") {
                        html += "<spring:message code='asmnt.label.resubmit'/>";
                    } else if (o.sbmsnStscdnm == "미재제출") {
                        html += "<spring:message code='asmnt.label.submit.n'/>";
                    } else {
                        html += o.sbmsnStscdnm;
                    }

                    html += "</td>";
                }

                html += "	<td class='tc'><a href=\"javascript:fdbkList('" + o.asmtId + "', '" + o.stdNo + "')\" class='fcBlue'>" + o.fdbkCnt + "</a></td>";

                if (o.teamAsmtStngyn == "Y") {
                    html += "<td>";
                    html += "<button type='button' class='ui blue small button' onclick=\"teamMemberView('" + o.lrnGrpId + "', 1)\"><spring:message code='forum.label.team.member.view.short' /></button>";
                }
                if (o.evalUseYn == "Y" && "<%=SessionInfo.getAuditYn(request) %>" != "Y") {
                    html += "<td>";
                    html += "<button type='button' class='ui blue small button' onclick=\"viewAsmnt('" + o.asmtId + "', 1)\"><spring:message code='forum.label.mut.eval' /></button>";
                }
                if (o.teamAsmtStngyn != "Y" && o.evalUseYn != "Y") {
                    html += "<td class='tc'>";
                    html += "-";
                }
                html += "	</td>";
                html += "</tr>";

            });

            html += "			</tbody>";
            html += "		</table>";
            html += "	<div id='paging' class='paging'></div>";

        } else {
            $.each(data, function (i, o) {
                var sCd = "<spring:message code='asmnt.label.ongoing'/>";
                var sDttm = o.asmtSbmsnSdttm;
                var eDttm = o.sendEndDttm;
                var eYn = o.extSendAcptYn;
                var lDttm = o.extSendDttm;

                var rYn = o.resbmsnyn;
                var rSDttm = o.resbmsnSdttm;
                var rEDttm = o.resbmsnEdttm;

                const nDt = new Date();
                const sDt = getDate(sDttm);
                const eDt = getDate(eDttm);
                const lDt = getDate(lDttm);
                const rSDt = getDate(rSDttm);
                const rEDt = getDate(rEDttm);

                if (nDt < sDt || nDt > eDt) {
                    if (nDt > sDt && eYn == 'Y') {
                        if (nDt > lDt) {
                            //alert('제출기간이 아닙니다.');
                            sCd = "<spring:message code='lesson.label.status.end' />";
                        } else {
                            //sCd = 'LATE';
                            sCd = "<spring:message code='resh.label.resh.proceeding' />";
                        }
                    } else if (nDt >= sDt && nDt <= eDt && rYn == 'Y') {
                        sCd = "RE";
                    } else {
                        //alert('제출기간이 아닙니다.');
                        sCd = "<spring:message code='lesson.label.status.end' />";
                    }
                }

                var asmtSbmsnSdttm = o.asmtSbmsnSdttm.substring(0, 4) + '.' + o.asmtSbmsnSdttm.substring(4, 6) + '.' + o.asmtSbmsnSdttm.substring(6, 8) + ' ' + o.asmtSbmsnSdttm.substring(8, 10) + ':' + o.asmtSbmsnSdttm.substring(10, 12);
                var sendEndDttm = o.sendEndDttm.substring(0, 4) + '.' + o.sendEndDttm.substring(4, 6) + '.' + o.sendEndDttm.substring(6, 8) + ' ' + o.sendEndDttm.substring(8, 10) + ':' + o.sendEndDttm.substring(10, 12);
                var extSendDttm = o.extSendDttm != null && o.extSendDttm != "" ? o.extSendDttm.substring(0, 4) + '.' + o.extSendDttm.substring(4, 6) + '.' + o.extSendDttm.substring(6, 8) + ' ' + o.extSendDttm.substring(8, 10) + ':' + o.extSendDttm.substring(10, 12) : "-";
                var resbmsnSdttm = o.resbmsnSdttm != null && o.resbmsnSdttm != "" ? o.resbmsnSdttm.substring(0, 4) + '.' + o.resbmsnSdttm.substring(4, 6) + '.' + o.resbmsnSdttm.substring(6, 8) + ' ' + o.resbmsnSdttm.substring(8, 10) + ':' + o.resbmsnSdttm.substring(10, 12) : "-";
                var resbmsnEdttm = o.resbmsnEdttm != null && o.resbmsnEdttm != "" ? o.resbmsnEdttm.substring(0, 4) + '.' + o.resbmsnEdttm.substring(4, 6) + '.' + o.resbmsnEdttm.substring(6, 8) + ' ' + o.resbmsnEdttm.substring(8, 10) + ':' + o.resbmsnEdttm.substring(10, 12) : "-";
                var scoreAply = o.mrkRfltyn == 'Y' ? "<spring:message code='asmnt.common.yes'/>" : "<spring:message code='asmnt.common.no'/>";
                var scoreOpen = o.mrkOyn == 'Y' ? "<spring:message code='crs.label.public' />" : "<spring:message code='crs.label.private' />";

                html += "<div class='card'>";
                html += "    <div class='content card-item-center'>";
                html += "        <div class='title-box'>";

                if (o.asmtGbncd == 'TEAM') {
                    html += "<label class='ui pink label active'>";
                    html += "	<spring:message code='asmnt.label.team'/>";//팀
                    html += "	<spring:message code='asmnt.label.asmnt'/>";//과제
                    html += "</label>";
                } else if (o.asmtGbncd == 'INDIVIDUAL') {
                    html += "<label class='ui pink label active'>";
                    html += "	<spring:message code='asmnt.label.individual.asmnt'/>";//개별과제
                    html += "</label>";
                } else if (o.asmtGbncd == 'NOMAL') {
                    html += "<label class='ui pink label active'>";
                    html += "	<spring:message code='asmnt.label.nomal.asmnt'/>";//일반과제
                    html += "</label>";
                } else if (o.asmtGbncd == 'PRACTICE') {
                    html += "<label class='ui pink label active'>";
                    html += "	<spring:message code='asmnt.label.practice.asmnt'/>";//실기과제
                    html += "</label>";
                } else if (o.asmtGbncd == 'SUBS' || o.asmtGbncd == 'EXAM') {
                    html += "<label class='ui pink label active'>";
                    if (o.examStareTypeCd == 'M') {
                        html += "<spring:message code='crs.label.mid_exam' />";
                    } else if (o.examStareTypeCd == 'L') {
                        html += "<spring:message code='crs.label.final_exam' />";
                    }
                    html += "</label>";
                }

                html += "            <a href=\"javascript:viewAsmnt('" + o.asmtId + "', 0)\" class='header header-icon link'> " + o.asmtTtl + "</a>";
                html += "        </div>";
                if (o.asmtGbncd == 'TEAM') {
                    html += "<button type='button' class='ui blue small button' onclick=\"teamMemberView('" + o.lrnGrpId + "', 1)\"><spring:message code='asmnt.label.team' /></button>";
                }
                html += "    </div>";
                html += "    <div class='sum-box'>";
                html += "        <ul class='process-bar'>";

                if (o.sbmsnStscd == 'NO') {
                    html += "            <li style='width:100%; background: #e03997;'>";
                } else {
                    html += "            <li class='bar-blue' style='width:100%;'>";
                }

                html += sCd + "(";

                if (o.evalYn == 'Y') {
                    if (o.mrkOyn == 'N') {
                        html += o.sbmsnStscdnm || "-";
                    } else {
                        html += o.scr + " <spring:message code='asmnt.label.point'/>";
                    }
                } else {
                    if (o.sbmsnStscdnm == "제출") {
                        html += "<spring:message code='asmnt.label.submit.y'/>";
                    } else if (o.sbmsnStscdnm == "미제출") {
                        html += "<spring:message code='asmnt.label.submit.n'/>";
                    } else if (o.sbmsnStscdnm == "지각제출") {
                        html += "<spring:message code='asmnt.label.submit.late2'/>";
                    } else if (o.sbmsnStscdnm == "재제출") {
                        html += "<spring:message code='asmnt.label.resubmit'/>";
                    } else if (o.sbmsnStscdnm == "미재제출") {
                        html += "<spring:message code='asmnt.label.submit.n'/>";
                    } else {
                        html += o.sbmsnStscdnm;
                    }
                }
                html += ")</li>";

                html += "        </ul>";
                html += "    </div>";
                html += "    <div class='content ui form equal width'>";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'><spring:message code='common.submission.period' /></label>";
                html += "                <i>" + asmtSbmsnSdttm + " ~ " + sendEndDttm + "</i>";
                html += "            </div>";
                html += "        </div>";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'><spring:message code='asmnt.label.late.send.deadline' /></label>";
                html += "                <i>" + extSendDttm + "</i>";
                html += "            </div>";
                html += "        </div>";
                if (rYn == "Y") {
                    html += "   <div class='fields'>";
                    html += "    	<div class='inline field'>";
                    html += "       	<label class='label-title-lg'><spring:message code='asmnt.label.resend.date' /></label>";
                    html += "           <i>" + resbmsnSdttm + " ~ " + resbmsnEdttm + "</i>";
                    html += "       </div>";
                    html += "	</div>";
                }
                //html += "        <div class='fields'>";
                //html += "            <div class='inline field'>";
                //html += "                <label class='label-title-lg'><spring:message code='exam.label.score.open.y' /></label>";
                //html += "				 <i>" +scoreOpen + "</i>";
                //html += "            </div>";
                //html += "        </div>";
                html += "            ";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'><spring:message code='exam.label.score.aply.y' /></label>";
                html += "<i>";
                if (o.examStareTypeCd == 'M') {
                    html += "<spring:message code='crs.label.mid_exam' />";
                } else if (o.examStareTypeCd == 'L') {
                    html += "<spring:message code='crs.label.final_exam' />";
                } else {
                    html += scoreAply;
                }
                html += "</i>";
                if (o.evalUseYn == "Y" && "<%=SessionInfo.getAuditYn(request) %>" != "Y") {
                    html += "<button type='button' class='ui blue small button' onclick=\"viewAsmnt('" + o.asmtId + "', 1)\"><spring:message code='forum.label.mut.eval' /></button>";
                }
                html += "            </div>";
                html += "        </div>";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'><spring:message code='forum.label.feedback'/></label>";
                html += "                <i><a href=\"javascript:fdbkList('" + o.asmtId + "', '" + o.stdNo + "')\" class='fcBlue'>" + o.fdbkCnt + "</a></i>";
                html += "            </div>";
                html += "        </div>";
                html += "    </div>";
                html += "</div>";

            });
        }

        return html;
    }

    // 피드백 가져오기
    function fdbkList(asmtId, stdNo) {
        var modalId = "Ap10";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': asmtId});
        kvArr.push({'key': 'stdNo', 'val': stdNo});

        submitForm("/asmt/profAsmtFdbkPopListView.do", modalId + "ModalIfm", kvArr);
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">

        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code="asmnt.label.asmnt"/>', '<spring:message code="asmnt.label.list"/>');
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="asmnt.label.asmnt"/><!-- 과제 -->
                        </h2>
                    </div>

                    <div class="row">
                        <div class="col">

                            <div class="option-content mb10">

                                <button class="ui basic icon button" id="typeBtn"
                                        title="<spring:message code='asmnt.label.title.card'/>"
                                        onclick="onChangeList();"><i class="list ul icon"></i></button>

                                <div class="ui action input search-box">
                                    <label for="searchValue" class="hide"><spring:message
                                            code='asmnt.label.input.asmnt_title'/></label>
                                    <input type="text" id="searchValue"
                                           placeholder="<spring:message code='asmnt.label.input.asmnt_title' />">
                                    <button class="ui icon button" onclick="onSearch(1);"><i class="search icon"></i>
                                    </button>
                                </div>

                                <!--
                                <div class="select_area">
                                    <select class="ui dropdown list-num selection" id="listScale" onchange="onChangeListScale();">
                                        <option value="10">10</option>
                                        <option value="20">20</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                        <option value="0">전체</option>
                                    </select>
                                </div>
                                -->
                            </div>

                            <form id="asmntForm" method="POST">
                                <div id="listDiv"></div>
                            </form>

                        </div><!-- //col -->
                    </div><!-- //row -->

                </div>
            </div>

        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->

</body>
</html>