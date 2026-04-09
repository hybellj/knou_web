<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
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

<body class="modal-page">
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
<script>
    
    // 신청사유 조회
    function selectObjctAplyCts(rowData) {
        UiComm.showLoading(true);

        let userId = rowData.userId;
        let param = {"userId": userId, encParams: EPARAM};

        $.ajax({
            url: "/mrk/mrkObjctAplyctsSelectAjax.do",
            data: param,
            type: "GET",
            success: function (data) {
                let returnVO = data.returnVO || {};
                // 신청사유
                $("#objctAplyCts").empty();
                $("#objctAplyCts").text(returnVO.objctAplyCts);

                // 첨부파일
                if (returnVO.fileCnt > 0 && returnVO.fileList) {
                    $("#fileList").empty();

                    let html = "";
                    returnVO.fileList.forEach(vo => {
                        html += `
                            <li>
                                <a href="#_" class="file_down" onclick="UiFileDownloader('\${vo.encDownParam}');return false;">
                                    <i class="icon-svg-paperclip" aria-hidden='true'></i>
                                    <span class="text">\${vo.filenm}</span>
                                    <span class="fileSize">(\${vo.fileSize} KB)</span>
                                </a>
                                <span class="link">
                                    <button class="btn s_basic down" onclick="UiFileDownloader('\${vo.encDownParam}');return false;">다운로드</button>
                                </span>
                            </li>`;
                    });
                    $("#fileList").html(html);
                }
                // 처리상태 objctAplyCts
                $("#objctAplySts").empty();
                $("#objctAplySts").text(returnVO.objctAplySts);
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            },
            complete: function (){
                UiComm.showLoading(false);
            }
        });

        UiComm.showLoading(false);
    }
</script>
<div id="wrap">
    <div>

        <%-- 성적이의 신청자 목록--%>
        <div id="aplyList"></div>
        <script>
            let cols = [
                {title: "번호", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                {title: "대표아이디",field: "userId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                {title: "점수",  field: "chgbfrScr", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60},
                {title: "가산점",  field: "adtnScr", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60},
                {title: "최종점수",  field: "lstScr", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60},
                {title: "순위",  field: "rank", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                {title: "성적상세",  field: "detail", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80}
            ];

            let tableData = [];
            let aplyList = ${aplyList};
            aplyList.forEach(function (item, i) {

                const lineNo = aplyList.length - i;
                tableData.push({
                    no: lineNo,
                    deptnm: item.deptnm,
                    userId: item.userId,
                    stdntNo: item.stdntNo,
                    usernm: item.usernm,
                    chgbfrScr: item.chgbfrScr,
                    adtnScr: item.adtnScr,
                    lstScr: item.lstScr,
                    rank: item.rank,
                    detail: `<button class="btn s_basic" data-objctid="\${item.mrkObjctAplyId}" onclick="viewObjctAplyCts(this)">보기</button>`,
                })
            });

            let objctAplyListTable = UiTable("aplyList", {
                lang: "ko",
                table: "list",
                selectRow: "1",
                selectRowFunc: selectObjctAplyCts,
                // data: aplyList,
                columns: cols    // 컬럼정보
            });
        </script>

        <%-- 신청사유 --%>
        <h4 class="title"  style="margin-top: 50px">신청사유</h4>
        <div class="table_list">
            <ul class="list">
                <li class="head"><label>신청사유</label></li>
                <li id="objctAplyCts" style="height: 100px; display: block; overflow-y: scroll;">

                </li>
            </ul>
            <ul class="list">
                <li class="head"><label>자료첨부</label></li>
                <li>
                    <div class="add_file_list" id="fileList">
                        <small>첨부된 파일이 없습니다.</small>
                    </div>
                </li>
            </ul>
        </div>

        <%-- 처리결과 --%>
        <h4 class="title"  style="margin-top: 50px">처리결과</h4>
        <div class="table_list">
            <ul class="list">
                <li class="head"><label>처리결과</label></li>
                <li id="objctAplySts"></li>
            </ul>
        </div>

    </div>
    <div class="btns">
        <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
    </div>
</div>

<script type="text/javascript">
    const EPARAM = '<c:out value="${encParams}" />';

    $(function () {
        // 테이블 데이터 세팅
        setTableData();

    });

    function setTableData() {
        objctAplyListTable.clearData();

        const aplyList = ${aplyList} || [];
        if (aplyList.length <= 0) return false;

        const dataList = createObjctAplyListHTML(aplyList);
        objctAplyListTable.replaceData(dataList).then(function () {
            const targetId ="${targetId}";

            if (targetId) {
                const rows = objctAplyListTable.getRows();

                rows.forEach(row => {
                    if (row.getData().userId === targetId) {
                        // 2. Tabulator 내장 함수로 행을 선택합니다.
                        // (이렇게 하면 클래스 추가 + 내부 상태 변경이 동시에 일어납니다.)
                        row.select();
                    }
                });
            }

            if (window.parent && typeof window.parent.resizeAplyDialog === "function") {
                const h = $("body").outerHeight(true) + 80;
                window.parent.resizeAplyDialog(h);
            }
        });



    }

    function createObjctAplyListHTML(list) {
        let dataList = [];

        list.forEach(function(item, i) {
            const lineNo = list.length - i;

            dataList.push({
                no: lineNo,
                deptnm: item.deptnm,
                userId: item.userId,
                stdntNo: item.stdntNo,
                usernm: item.usernm,
                chgbfrScr: item.chgbfrScr,
                adtnScr: item.adtnScr,
                lstScr: item.lstScr,
                rank: item.rank,
                detail: `<button class="btn s_basic" data-objctid="\${item.mrkObjctAplyId}" onclick="viewObjctAplyCts(this)">보기</button>`,
            })
        });

        return dataList;
    }
</script>


</body>
</html>
