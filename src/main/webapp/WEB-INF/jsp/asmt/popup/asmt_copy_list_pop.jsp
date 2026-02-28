<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                //copyList(1);
            }
        });
    });

    // 리스트 가져오기
    function copyList(page) {
        var url = "/asmtProfPrevAsmtList.do";
        var data = {
            "pageIndex": page,
            "creYear": $("#creYear").val(),
            "creTerm": $("#creTerm").val(),
            "crsCreCd": $("#crsCreCd").val(),
            "listScale": $("#listScale").val(),
            "searchValue": $("#searchValue").val(),
            "userId": "${creCrsVO.repUserId}",
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "	<td>" + o.lineNo + "</td>";
                        html += "	<td>" + o.crsCreNm + "(" + o.declsNo + ")</td>";
                        html += "	<td>" + o.asmtGbnnm + "</td>";
                        html += "	<td class='tl'>" + o.asmtTtl + "</td>";
                        html += "	<td>";
                        html += "		<a href=\"javascript:window.parent.copyAsmnt('" + o.asmtId + "')\" class='ui blue button'><spring:message code='asmnt.label.select' />​</a>"; /* 선택 */
                        html += "	</td>";
                        html += "</tr>";
                    });
                }

                $("#copyList").empty().html(html);
                $(".table").footable();
                var params = {
                    totalCount: data.pageInfo.totalRecordCount,
                    listScale: data.pageInfo.pageSize,
                    currentPageNo: data.pageInfo.currentPageNo,
                    eventName: "copyList"
                };

                gfn_renderPaging(params);
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }

    // 선택 학기로 과목 가져오기
    function copyCreCrsList() {
        var url = "/asmtProfSbjctList.do";
        var data = {
            "creYear": $("#creYear").val(),
            "creTerm": $("#creTerm").val(),
            "userId": "${vo.userId}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "<option value=' '><spring:message code='crs.label.all' /></option>"; /* 전체 */

                if (returnList.length > 0) {
                    returnList.forEach(function (o, i) {
                        html += "<option value='" + o.crsCreCd + "'>" + o.crsCreNm + "(" + o.declsNo + ")</option>";
                    });
                }

                $("#crsCreCd").empty().html(html);
                $("#crsCreCd").dropdown("clear");
                $("#crsCreCd").trigger("change");
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert("<spring:message code='fail.common.msg' />");
        }, true);
    }
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap">
    <p class="page-title fcRed tc"><spring:message code="asmnt.alert.select.info.copy" /><!-- 선택 시 과제 정보가 복사됩니다. --></p>
    <div class="option-content mb10 mt20">
        <select class="ui dropdown mr5" id="creYear" onchange="copyCreCrsList()">
            <option value=" " hidden><spring:message code="crs.label.open.year" /><!-- 개설년도 --></option>
            <c:forEach var="item" items="${creYearList }">
                <option value="${item.haksaYear }">${item.haksaYear }</option>
            </c:forEach>
        </select>
        <select class="ui dropdown mr5" id="creTerm" onchange="copyCreCrsList()">
            <option value=" " hidden><spring:message code="crs.label.open.term" /><!-- 개설학기 --></option>
            <c:forEach var="item" items="${termList }">
                <option value="${item.codeCd }">${item.codeNm }</option>
            </c:forEach>
        </select>
        <select class="ui dropdown mr5" id="crsCreCd" onchange="copyList(1)">
            <option value="" hidden><spring:message code="common.all"/></option>
        </select>

        <div class="ui action input search-box mr5">
            <input type="text" placeholder="<spring:message code="asmnt.label.input.asmnt_title" />" id="searchValue">
            <!-- 과제명 입력 -->
            <button class="ui icon button" onclick="copyList(1)"><i class="search icon"></i></button>
        </div>

        <div class="mla">
            <select class="ui dropdown mr5" id="listScale" onchange="copyList(1)">
                <option value="10">10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
        </div>
    </div>

    <div class="ui form">
        <table class="table type2" data-sorting="true" data-paging="false"
               data-empty="<spring:message code='common.nodata.msg' />">
            <colgroup>
                <col width="7%">
                <col width="17%">
                <col width="10%">
                <col width="*">
                <col width="10%">
            </colgroup>
            <thead>
            <tr>
                <th scope="col" class="num tc" data-type="number">
                    <spring:message code="main.common.number.no" /><!-- NO --></th>
                <th scope="col"><spring:message code="crs.label.crecrs.nm"/>(<spring:message code="crs.label.decls"/>)
                    <!-- 과목명 --><!-- 분반 --></th>
                <th scope="col"><spring:message code="asmnt.label.asmnt.type" /><!-- 과제구분 --></th>
                <th scope="col"><spring:message code="asmnt.label.asmnt.title" /><!-- 과제명 --></th>
                <th scope="col" class="tc" data-sortable="false">
                    <spring:message code="asmnt.label.select" /><!-- 선택 --></th>
            </tr>
            </thead>
            <tbody id="copyList">
            </tbody>
        </table>
        <div id="paging" class="paging"></div>
    </div>

    <div class="bottom-content">
        <button class="ui black cancel button" onclick="window.parent.closeModal();">
            <spring:message code="team.common.close"/><!-- 닫기 --></button>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>