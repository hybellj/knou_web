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
        var url = "/asmt/profAsmtList.do";
        var data = {
            "sbjctId": "${vo.sbjctId}",
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
            //에러가 발생했습니다!
            alert("<spring:message code='fail.common.msg'/>");
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

            case 3:
                // 성적반영 수정 VIEW
                $('div .mla.mr5 a:eq(0)').hide();
                $('div .mla.mr5 a:eq(1)').show(); // 저장
                $('div .mla.mr5 a:eq(2)').show(); // 취소

                $('div[name="scoreViewDiv"]').hide();
                $('div[name="scoreEditDiv"]').show();

                $('input[name="mrkRfltrtArray"]').on("input", function () {
                    //e.target.value = Number(e.target.value);

                    $(this).val(Number($(this).val()));

                    var sum = 0;

                    $('input[name="mrkRfltrtArray"]').each(function () {
                        sum = Number(sum) + Number($(this).val());
                    });

                    if (sum > 100) {
                        $(this).val(Number($(this).val()) + (100 - sum));
                    } else if ($(this).val() > 100) {
                        $(this).val(100);
                    }
                });

                break;

            case 4:
                // 성적반영 일반 VIEW
                $('div .mla.mr5 a:eq(0)').show();
                $('div .mla.mr5 a:eq(1)').hide(); // 저장
                $('div .mla.mr5 a:eq(2)').hide(); // 취소

                $('div[name="scoreEditDiv"]').hide();
                $('div[name="scoreViewDiv"]').show();

                $('input[name="mrkRfltrtArray"]').off("input");

                break;
        }
    }

    // 목록크기 변경
    /* function onChangeListScale(){
        onChangeView(4); // 성적반영 OFF
        onSearch(1);
    } */

    // 성적 반영비율 수정 및 저장
    function onChangeScoreRatio(key) {
        switch (key) {
            case 1:
                onSearch(1, 'EDIT');
                break;
            case 2:
                onChangeView(2);
                onSearch(1, 'EDIT');
                break;// 리스트형 호출
            case 3:
                onChangeView(4);
                break;
        }
    }

    // 성적 반영비율 저장
    function saveScoreRatio() {

        var sum = 0;

        $('input[name="mrkRfltrtArray"]').each(function () {
            sum = Number(sum) + Number($(this).val());
        });

        if (sum != 100) {
            // 성적반영 비율 합이 100%이여야 합니다.
            alert("[" + sum + "] <spring:message code='asmnt.message.score.ratio'/>");

            return false;
        } else {

            var data = $('#asmntForm').serialize();

            ajaxCall("/asmt/profMrkRfltRtModify.do", data, function (data) {
                if (data.result > 0) {
                    alert(data.message);
                    onChangeView(4); // 성적반영 OFF
                    onSearch(1);
                }
            }, function () {

            }, true);
        }
    }

    // 성적공개 수정
    function updateScoreOpen(asmtId, mrkOyn) {
        var data = {
            "asmtId": asmtId
            , "mrkOyn": mrkOyn == true ? 'Y' : 'N'
        };

        ajaxCall("/asmt/profAsmtMrkOpenYnModify.do", data, function (data) {
            if (data.result > 0) {
                alert(data.message);
            }
        }, function () {

        }, true);
    };

    // 과제 정보 페이지
    function viewAsmnt(asmtId, tab) {
        //var urlMap = {
        //	"0" : "/asmt/profAsmtSelectView.do",	// 과제 상세 정보 페이지
        //	"1" : "/asmt/profAsmtEvlView.do"	// 과제 평가 관리 페이지
        //};

        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': "${vo.sbjctId}"});
        kvArr.push({'key': 'asmtId', 'val': asmtId});

        submitForm("/asmt/profAsmtEvlView.do", "", kvArr);
    }

    // 과제등록
    function writeAsmnt() {
        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': "${vo.sbjctId}"});

        submitForm("/asmt/profAsmtRegistView.do", "", kvArr);
    }

    // 과제 수정
    function editAsmnt(asmtId) {
        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': "${vo.sbjctId}"});
        kvArr.push({'key': 'asmtId', 'val': asmtId});

        submitForm("/asmt/profAsmtRegistView.do", "", kvArr);
    }

    // 과제 삭제
    function deleteAsmnt(asmtId) {
        var confirm = "";
        if (true) {
            //학습중인 학습자가 있습니다 삭제 시 학습정보가 삭제됩니다.
            //정말 삭제 하시겠습니까?
            confirm = window.confirm("<spring:message code='asmnt.message.warning.del1'/>\r\n<spring:message code='asmnt.message.warning.del2'/>");
        } else {
            //학습중인 학습자가 없습니다. 삭제 하시겠습니까?
            confirm = window.confirm("<spring:message code='asmnt.message.warning.del3'/>");
        }
        if (confirm) {
            var url = "/asmt/profAsmtDelete.do";
            var data = {
                "asmtId": asmtId
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    //정상 삭제되었습니다.
                    alert("<spring:message code='asmnt.message.del'/>");
                    viewAsmntList();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 삭제 중 오류가 발생하였습니다.  잠시 후 다시 진행해 주세요.*/
                alert("<spring:message code='asmnt.message.error.del'/>");
            }, true);
        }
    }

    //목록
    function viewAsmntList() {
        var kvArr = [];
        kvArr.push({'key': 'sbjctId', 'val': "${vo.sbjctId}"});

        submitForm("/asmt/profAsmtListView.do", "", kvArr);
    }

    // NULL HTML 생성
    function creatNullHTML() {
        var html = "";

        html += "<table class='table type2 mt10' data-empty=' '>";
        html += "	<thead>";
        html += "		<tr>";
        html += "			<th scope='col' data-type='number' class='tc num'>";
        html += "			<spring:message code='common.number.no' />";//NO.
        html += "			</th>";
        html += "      		<th scope='col' data-breakpoints='xs' class='tc'>";
        html += "				<spring:message code='asmnt.label.type'/>";//구분
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm'>";
        html += "				<spring:message code='asmnt.label.asmnt.title'/>";//과제명
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
        html += "				<spring:message code='asmnt.label.send.date'/>";//제출기간
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
        html += "				<spring:message code='asmnt.label.score.ratio'/>";//성적반영비율
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
        html += "				<spring:message code='asmnt.label.send.status'/>";//제출현황
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
        html += "				<spring:message code='asmnt.label.eval.status'/>";//평가현황
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
        html += "				<spring:message code='asmnt.label.late.send.deadline.dt'/>";//지각제출 마감일
        html += "			</th>";
        html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
        html += "				<spring:message code='asmnt.label.score.open'/>";//성적공개
        html += "			</th>";
        html += "		</tr>";
        html += "	</thead>";
        html += "	<tbody>";
        html += "	</tbody>";
        html += "</table>";

        html += "<div class='title'>";
        html += "	<div class='flex-container'>";
        html += "		<div class='cont-none'>";
        html += "			<span>";
        html += "				<spring:message code='asmnt.message.empty'/>";//등록된 내용이 없습니다.
        html += "			</span>";
        html += "		</div>";
        html += "	</div>";
        html += "</div>";

        return html;
    }


    // HTML 생성
    function createHTML(data) {
        var html = "";

        if ($("#typeBtn i").attr("class") != "list ul icon") {

            html += "<table class='table type2' data-sorting='true' data-paging='false' data-empty='<spring:message code="asmnt.message.empty"/>'>";
            html += "	<thead>";
            html += "		<tr>";
            html += "			<th scope='col' data-type='number' class='tc num'>";
            html += "			<spring:message code='common.number.no' />";//NO.
            html += "			</th>";
            html += "      		<th scope='col' data-breakpoints='xs' class='tc'>";
            html += "				<spring:message code='asmnt.label.type'/>";//구분
            html += "			</th>";
            html += "    		<th scope='col'>";
            html += "				<spring:message code='asmnt.label.asmnt.title'/>";//과제명
            html += "			</th>";
            html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
            html += "				<spring:message code='asmnt.label.send.date'/>";//제출기간
            html += "			</th>";
            html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
            html += "				<spring:message code='asmnt.label.late.send.deadline.dt'/>";//지각제출 마감일
            html += "			</th>";
            html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
            html += "				<spring:message code='asmnt.label.score.ratio'/>";//성적반영비율
            html += "			</th>";
            html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
            html += "				<spring:message code='asmnt.label.send.status'/>";//제출현황
            html += "			</th>";
            html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
            html += "				<spring:message code='asmnt.label.eval.status'/>";//평가현황
            html += "			</th>";
            html += "    		<th scope='col' data-breakpoints='xs sm md' class='tc'>";
            html += "				<spring:message code='asmnt.label.score.open'/>";//성적공개
            html += "			</th>";
            html += "		</tr>";
            html += "	</thead>";
            html += "	<tbody>";

            $.each(data, function (i, o) {
                var asmtSbmsnSdttm = dateFormat(o.asmtSbmsnSdttm);
                var asmtSbmsnEdttm = dateFormat(o.asmtSbmsnEdttm);
                var extdSbmsnSdttm = o.extdSbmsnSdttm != null && o.extdSbmsnSdttm != "" ? dateFormat(o.extdSbmsnSdttm) : "-";
                var mrkRfltrt = o.mrkRfltrt != null && o.mrkRfltrt != "" ? o.mrkRfltrt : "0";
                var scoreOpen = o.mrkOyn == 'Y' ? "checked" : "";

                html += "<tr>";
                html += "	<td class='tc'>" + o.lineNo + "</td>";
                html += "	<td class='tc'>";
                /*if (o.asmtGbncd == 'TEAM') {
                    html += "



                <spring:message code='asmnt.label.team'/>";//팀
                    html += "



                <spring:message code='asmnt.label.asmnt'/>";//과제
                } else if (o.asmtGbncd == 'INDIVIDUAL') {
                    html += "



                <spring:message code='asmnt.label.individual.asmnt'/>";//개별과제
                } else if (o.asmtGbncd == 'NOMAL') {
                    html += "



                <spring:message code='asmnt.label.nomal.asmnt'/>";//일반과제
                } else if (o.asmtGbncd == 'PRACTICE') {
                    html += "



                <spring:message code='asmnt.label.practice.asmnt'/>";//실기과제
                } else if (o.asmtGbncd == 'SUBS' || o.asmtGbncd == 'EXAM') {
                    html += "<label class='ui pink label active'>";
                    if (o.examStareTypeCd == 'M') {
                        html += "



                <spring:message code='asmnt.label.mid.exam'/>"; // 중간고사
                    } else if (o.examStareTypeCd == 'L') {
                        html += "



                <spring:message code='asmnt.label.end.exam'/>"; // 기말고사
                    }
                } else {
                    html += o.asmtGbncd;
                }*/

                html += o.asmtGbnnm;
                html += "	</td>";
                html += "	<td><a href=\"javascript:viewAsmnt('" + o.asmtId + "', 0)\" class='header header-icon link'> " + o.asmtTtl + "</a></td>";
                html += "	<td class='tc'>" + asmtSbmsnSdttm + " ~ " + asmtSbmsnEdttm + "</td>";
                html += "	<td class='tc'>" + extdSbmsnSdttm + "</td>";
                html += "	<td class='tc'>";

                if (o.examStareTypeCd == 'M') {
                    html += "<spring:message code='asmnt.label.mid.exam'/>"; // 중간고사
                } else if (o.examStareTypeCd == 'L') {
                    html += "<spring:message code='asmnt.label.end.exam'/>"; // 기말고사
                } else if (o.mrkRfltyn == 'N') {
                    html += "-"
                    //}else if(o.indvAsmtyn == 'Y' ){
                    //html += "		<div>" + mrkRfltrt + " %</div>";
                } else {
                    html += "		<div name='scoreViewDiv'>" + mrkRfltrt + " %</div>";
                    html += "		<div name='scoreEditDiv' class='ui right labeled input'>";
                    html += "	    	<input type='hidden' name='asmntArray' value='" + o.asmtId + "'>";
                    html += "	    	<input type='number' class='w50' name='mrkRfltrtArray' value='" + mrkRfltrt + "'>";
                    html += "	    	<div class='ui basic label'>%</div>";
                    html += "	    </div>";
                }

                html += "	</td>";
                html += "	<td class='tc'>" + o.submitCnt + " / " + o.targetCnt + "</td>";

                if (o.mrkRfltyn == 'N') {
                    html += "	<td class='tc'>-</td>";
                } else {
                    html += "	<td class='tc'><a href=\"javascript:viewAsmnt('" + o.asmtId + "', 1)\" class='fcBlue'>" + o.evalCnt + " / " + o.submitCnt + "</a></td>";
                }


                html += "	<td class='tc'>";

                if (o.mrkRfltyn == 'N') {
                    html += "-"
                } else {
                    html += "		<div class='ui toggle checkbox'>";
                    html += "   	    <input type='checkbox' name='scoreOpenArray' value='" + o.asmtId + "' " + scoreOpen + ">";
                    html += "  		</div>";
                }

                html += "	</td>";
                html += "</tr>";

            });

            html += "		</tbody>";
            html += "	</table>";
            html += "	<div id='paging' class='paging'></div>";

        } else {
            $.each(data, function (i, o) {
                var asmtSbmsnSdttm = dateFormat(o.asmtSbmsnSdttm);
                var asmtSbmsnEdttm = dateFormat(o.asmtSbmsnEdttm);
                var extdSbmsnSdttm = o.extdSbmsnSdttm != null && o.extdSbmsnSdttm != "" ? dateFormat(o.extdSbmsnSdttm) : "-";
                var mrkRfltrt = o.mrkRfltrt != null && o.mrkRfltrt != "" ? o.mrkRfltrt : "0";
                var scoreOpen = o.mrkOyn == 'Y' ? "checked" : "";

                const nDt = new Date();
                const sDt = getDate(o.asmtSbmsnSdttm);
                const eDt = getDate(o.asmtSbmsnEdttm);
                const lDt = getDate(o.extdSbmsnSdttm);

                html += "<div class='card'>";
                html += "    <div class='content card-item-center'>";
                html += "        <div class='title-box'>";

                <%--if (o.asmtGbncd == 'TEAM') {--%>
                <%--    html += "<label class='ui orange label m-w30 active'>";--%>
                <%--    html += "	<spring:message code='asmnt.label.team'/>";//팀--%>
                <%--    html += "</label>";--%>
                <%--    html += "<label class='ui pink label active'>";--%>
                <%--    html += "	<spring:message code='asmnt.label.asmnt'/>";//과제--%>
                <%--    html += "</label>";--%>
                <%--} else if (o.asmtGbncd == 'INDIVIDUAL') {--%>
                <%--    html += "<label class='ui pink label active'>";--%>
                <%--    html += "	<spring:message code='asmnt.label.individual.asmnt'/>";//개별과제--%>
                <%--    html += "</label>";--%>
                <%--} else if (o.asmtGbncd == 'NOMAL') {--%>
                <%--    html += "<label class='ui pink label active'>";--%>
                <%--    html += "	<spring:message code='asmnt.label.nomal.asmnt'/>";//일반과제--%>
                <%--    html += "</label>";--%>
                <%--} else if (o.asmtGbncd == 'PRACTICE') {--%>
                <%--    html += "<label class='ui pink label active'>";--%>
                <%--    html += "	<spring:message code='asmnt.label.practice.asmnt'/>";//실기과제--%>
                <%--    html += "</label>";--%>
                <%--} else if (o.asmtGbncd == 'SUBS' || o.asmtGbncd == 'EXAM') {--%>
                <%--    html += "<label class='ui pink label active'>";--%>
                <%--    if (o.examStareTypeCd == 'M') {--%>
                <%--        html += "<spring:message code='asmnt.label.mid.exam'/>"; // 중간고사--%>
                <%--    } else if (o.examStareTypeCd == 'L') {--%>
                <%--        html += "<spring:message code='asmnt.label.end.exam'/>"; // 기말고사--%>
                <%--    }--%>
                <%--    html += "</label>";--%>
                <%--} else {--%>
                <%--    html += "<label class='ui green label active'>" + o.asmtGbncd + "</label>";--%>
                <%--}--%>
                html += "<label class='ui green label active'>" + o.asmtGbnnm + "</label>";
                html += "            <a href=\"javascript:viewAsmnt('" + o.asmtId + "', 0)\" class='header header-icon link'> " + o.asmtTtl + "</a>";
                html += "        </div>";
                html += "        <div class='ui top right pointing dropdown right-box'>";
                html += "            <span class='bars'>메뉴</span>";
                html += "            <div class='menu'>";
                if (o.mrkRfltyn == 'Y') {
                    html += "				 <a href=\"javascript:viewAsmnt('" + o.asmtId + "', 1)\" class='item'>";
                    html += "					<spring:message code='asmnt.button.asmnt.eval'/>";//과제평가
                    html += "				 </a>";
                }
                html += "                <a href=\"javascript:editAsmnt('" + o.asmtId + "')\" class='item'>";
                html += "					<spring:message code='asmnt.button.mod'/>";//수정
                html += "				 </a>";
                html += "                <a href=\"javascript:deleteAsmnt('" + o.asmtId + "', 1)\" class='item'>";
                html += "					<spring:message code='asmnt.button.del'/>";//삭제
                html += "				 </a>";
                html += "            </div>";
                html += "        </div>";
                html += "    </div>";
                html += "    <div class='sum-box'>";
                html += "        <ul class='process-bar'>";

                var uPer = Math.round(Number(o.submitCnt) / Number(o.targetCnt) * 100);
                var tPer = Number(100) - uPer;

                html += "            <li class='bar-blue' style='width:" + uPer + "%;'>" + (uPer > 0 ? o.submitCnt + "<spring:message code='asmnt.label.person'/>" : "") + "</li>";
                html += "            <li class='bar-softgrey' style='width:" + tPer + "%;'>" + (tPer > 0 ? (o.targetCnt - o.submitCnt) + "<spring:message code='asmnt.label.person'/>" : "") + "</li>";
                html += "        </ul>";

                if (nDt < sDt) {
                    html += "<span class='ui mini blue label'>";
                    html += "	<spring:message code='asmnt.label.open.n'/>";//비공개
                    html += "</span>";
                } else if (nDt >= sDt && nDt <= eDt) {
                    html += "<span class='ui mini blue label'>";
                    html += "	<spring:message code='asmnt.label.ongoing'/>";//진행중
                    html += "</span>";
                } else if (o.extdSbmsnPrmyn == 'Y' && nDt <= lDt) {
                    html += "<span class='ui mini blue label'>";
                    html += "	<spring:message code='asmnt.label.ongoing'/>";//진행중
                    html += "</span>";
                } else {
                    html += "<span class='ui mini blue label'>";
                    html += "	<spring:message code='asmnt.label.deadline'/>";//마감
                    html += "</span>";
                }

                html += "    </div>";
                html += "    <div class='content ui form equal width'>";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'>";
                html += "                	 <spring:message code='asmnt.label.send.date'/>"; //제출기간
                html += "				 </label>";
                html += "                <i>" + asmtSbmsnSdttm + " ~ " + asmtSbmsnEdttm + "</i>";
                html += "            </div>";
                html += "        </div>";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'>";
                html += "                	 <spring:message code='asmnt.label.late.send.deadline.dt'/>"; //지각제출 마감일
                html += "				 </label>";
                html += "                <i>" + extdSbmsnSdttm + "</i>";
                html += "            </div>";
                html += "        </div>";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'>";
                html += "                	 <spring:message code='asmnt.label.score.open'/>"; //성적공개
                html += "			 	 </label>";

                if (o.mrkRfltyn == 'N') {
                    html += "                <i>-</i>";
                } else {
                    html += "                <div class='ui toggle checkbox'>";
                    html += "                    <input type='checkbox' name='scoreOpenArray' value='" + o.asmtId + "' " + scoreOpen + ">";
                    html += "                </div>";
                }

                html += "            </div>";
                html += "        </div>";
                html += "            ";
                html += "        <div class='fields'>";
                html += "            <div class='inline field'>";
                html += "                <label class='label-title-lg'>";
                html += "					<spring:message code='asmnt.label.score.ratio'/>";//성적 반영비율
                html += "				</label>";

                if (o.examStareTypeCd == 'M') {
                    html += "                <i><spring:message code='asmnt.label.mid.exam'/></i>"; //중간고사
                } else if (o.examStareTypeCd == 'L') {
                    html += "                <i><spring:message code='asmnt.label.end.exam'/></i>";	//기말고사
                } else if (o.mrkRfltyn == 'N') {
                    html += "                <i>-</i>";
                } else {
                    html += "                <i>" + mrkRfltrt + " %</i>";
                }

                html += "            </div>";
                html += "        </div>";
                html += "        ";
                html += "    </div>";
                html += "    <div class='content flex'>";

                if (o.mrkRfltyn == 'Y') {
                    html += "<a href=\"javascript:viewAsmnt('" + o.asmtId + "', 1)\" class='ui basic small button mra'>"
                    html += "	<spring:message code='asmnt.button.eval'/> "; // 평가
                    html += o.evalCnt + " / " + o.submitCnt + "</a>";
                }

                html += "    </div>";
                html += "</div>";

            });
        }
        return html;
    }

</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%--    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>--%>

    <div id="container">

        <%--        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>--%>

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <%--            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>--%>

            <div class="ui form">
                <div class="layout2">
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code='asmnt.label.asmnt'/>', '<spring:message code='asmnt.label.list'/>');
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code='asmnt.label.asmnt'/><!-- 과제 -->
                        </h2>
                        <div class="button-area">
                            <a href="javascript:writeAsmnt()" class="ui blue button">
                                <spring:message code='asmnt.button.asmnt.add'/><!-- 과제등록 -->
                            </a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">

                            <div class="option-content mb10">

                                <button class="ui basic icon button" id="typeBtn"
                                        title="<spring:message code='asmnt.label.title.card'/>"
                                        onclick="onChangeList();"><!-- 카드형 출력 -->
                                    <i class="th ul icon"></i>
                                </button>

                                <div class="ui action input search-box mr5">
                                    <input type="text" id="searchValue"
                                           placeholder="<spring:message code='asmnt.label.input.asmnt_title'/>">
                                    <!-- 과제명 입력 -->
                                    <button class="ui icon button" onclick="onSearch(1);"><i class="search icon"></i>
                                    </button>
                                </div>

                                <div class="mla mr5">
                                    <a href="javascript:onChangeScoreRatio(1);" class="ui blue button">
                                        <spring:message code='asmnt.button.score.ratio.chnage'/><!-- 성적반영 비율 조정 -->
                                    </a>
                                    <a href="javascript:saveScoreRatio();" class="ui basic button"
                                       style="display:none;">
                                        <spring:message code='asmnt.button.score.ratio.save'/><!-- 성적반영 비율 저장 -->
                                    </a>
                                    <a href="javascript:onChangeScoreRatio(3);" class="ui gray button"
                                       style="display:none;">
                                        <spring:message code='asmnt.button.cancel'/><!-- 취소 -->
                                    </a>
                                </div>

                                <!--
		                    		<select class="ui dropdown list-num selection" id="listScale" onchange="onChangeListScale();">
				                        <option value="10">10</option>
				                        <option value="20">20</option>
				                        <option value="50">50</option>
				                        <option value="100">100</option>
				                        <option value="0">
				                        	<spring:message code='asmnt.label.all'/>
				                        </option>
		                        	</select>
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
        <%--        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>--%>
    </div><!-- //container -->
</div><!-- //pusher -->
</body>
</html>