<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
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
    let EPARAM = '<c:out value="${encParams}" />';
    $(document).ready(function () {
        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode == 13) {
                bfrAsmtListSelect();
            }
        });
    });

    /**
     * 이전 과제 목록 조회
     * @param {String}  smstrChrtId    - 학사년도/학기
     * @param {String}  sbjctId            - 과목아이디
     * @param {String}  searchValue    - 검색어 ( 과제명 )
     * @param {String}  userId            - 사용자아이디
     * @returns {list} 과제 목록
     */
    function bfrAsmtListSelect() {
        const url = "/asmt2/asmtCopyListAjax.do";

        const extData = {
            "smstrChrtId": $("#smstrChrtId").val(),
            "sbjctId": $("#sbjctId").val(),
            "searchValue": $("#searchValue").val(),
            "userId": "${asmtVO.userId}"
        };

        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall(url, param, function (data) {
            if (data.encParams != null && data.encParams != '') {
                EPARAM = data.encParams;
            }
            if (data.result > 0) {
                const returnList = data.returnList || [];
                let dataList = [];

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
            const selectBtn = "<a href='javascript:window.parent.copyAsmt(\"" + v.asmtId + "\")' class='btn basic small'><spring:message code='asmt.button.select'/><%--선택--%></a>";

                        dataList.push({
                            no: v.lineNo,
                            sbjctnm: v.sbjctnm,
                dvclasNo: v.dvclasNo + "<spring:message code='asmt.label.dvclas'/><%--분반--%>",
                            asmtGbnnm: v.asmtGbnnm,
                            asmtTtl: UiComm.escapeHtml(v.asmtTtl),
                            selectBtn: selectBtn
                        });
                    });
                }

                asmtListTable.clearData();
                asmtListTable.replaceData(dataList);
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
        }, true);
    }

    /**
     * 과제학기기수선택
     * @param {String}  smstrChrtId - 학기기수아이디
     * @param {String}  sbjctId    - 과목아이디
     */
    function asmtSmstrChrtChc(smstrChrtId) {
        const url = "/asmt2/asmtCopySbjctListAjax.do";
        const extData = {
            "smstrChrtId": smstrChrtId,
            "sbjctId": "${asmtVO.sbjctId}"
        };
        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };


        ajaxCall(url, param, function (data) {
            if (data.encParams != null && data.encParams != '') {
                EPARAM = data.encParams;
            }
            if (data.result > 0) {
                const returnList = data.returnList || [];
                let html = "<option value='' selected><spring:message code='asmt.label.course.select'/><%--과목 선택--%></option>";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
        html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + v.dvclasNo + "<spring:message code='asmt.label.dvclas'/><%--분반--%></option>";
                    });
                }

                $("#sbjctId").empty().append(html);
                $("#sbjctId").val('').trigger("chosen:updated");
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
        }, true);
    }
</script>

<body class="modal-page">
<div id="wrap">
    <div class="msg-box info">
        <p class="txt"><i class="xi-error" aria-hidden="true"></i><spring:message code='asmt.alert.select.info.copy'/><!-- 선택 시 과제 정보가 복사됩니다. --></p>
    </div>
    <div class="board_top">
        <select class="form-select" id="smstrChrtId" onchange="asmtSmstrChrtChc(this.value)">
            <option value=""><spring:message code='asmt.label.open.crs.year.term'/><%--개설년도_학기--%> <spring:message code='asmt.button.select'/><%--선택--%></option>
            <c:forEach var="item" items="${smstrChrtList }">
                <option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
            </c:forEach>
        </select>
        <select class="form-select" id="sbjctId" onchange="bfrAsmtListSelect()">
            <option value=""><spring:message code='asmt.label.course.select'/><%--과목 선택--%></option>
        </select>
        <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='asmt.label.input.asmt_title'/><%--과제명 입력--%>"><!-- 과제명 입력 -->
        <button type="button" class="btn basic icon search" aria-label="<spring:message code='asmt.label.search'/><%--조회--%>" onclick="bfrAsmtListSelect()"><i class="icon-svg-search"></i></button>
    </div>

    <div id="list"></div>

    <script>
        // 리스트 테이블
        let asmtListTable = UiTable("list", {
            lang: "ko",
            height: 400,
            columns: [
                {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40},
            {title: "<spring:message code='asmt.label.course'/><%--과목--%>", field: "sbjctnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100},
            {title: "<spring:message code='asmt.label.dvclas'/><%--분반--%>", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
            {title: "<spring:message code='asmt.label.asmt.type'/><%--과제구분--%>", field: "asmtGbnnm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
            {title: "<spring:message code='asmt.label.asmt.title'/><%--과제명--%>", field: "asmtTtl", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 250},
            {title: "<spring:message code='asmt.button.select'/><%--선택--%>", field: "selectBtn", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}
            ]
        });
    </script>

    <div class="btns">
        <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='asmt.button.close'/><%--닫기--%></button><!-- 닫기 -->
    </div>
</div>
</body>
</html>
