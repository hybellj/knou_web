<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<body class="class ${uiex:getTheme()}  ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- 본문 content 부분 -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->
                    <div class="dashboard_sub">

                        <div class="sub-content">
                            <div class="listTab">
                                <ul>
                                    <li><a href="/mrk/lec/profSbjctMrkListView.do?encParams=${encParams}">성적관리</a></li>
                                    <li class="select"><a href="#">성적이의신청</a></li>
                                </ul>
                            </div>

                            <div class="page-info">
                                <%--타이틀--%>
                                    <h4 class="sub-title">성적이의신청</h4>
                                <%--<uiex:navibar type="main"/>--%> <%-- 네비게이션바 --%>
                                    <div class="navi_bar">
                                    <ul>
                                        <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                        <li><span class="current">성적이의신청</span></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="alert alert-warning text-center" role="alert" style="background-color: #ffe38b;padding: 15px 0px;margin-bottom: 20px;">
                                <p>성적이의 신청기간 : <uiex:formatDate value="${taskSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${taskEdttm}" type="datetime2"/></p>
                            </div>

                            <div class="board_top">
                                <div class="right-area">
                                    <button type="button" class="btn basic" onclick="sendAlim()">메시지 보내기</button>
                                    <button type="button" class="btn type2" onclick="downExcel()">엑셀 다운로드</button>
                                </div>
                            </div>

                            <div id="tableDiv">
                                <div id="mrkObjctAplyList"></div>
                                <script>
                                    let cols = [
                                        {title: '<spring:message code="common.no"/>', field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50}, // 번호
                                        {title: '<spring:message code="common.dept_name"/>',  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120}, // 학과
                                        {title: '<spring:message code="common.represent.id"/>',field: "userId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130}, // 대표아이디
                                        {title: '<spring:message code="common.label.student.number"/>',  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120}, // 학번
                                        {title: '<spring:message code="common.name"/>',  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}, // 이름
                                        {title: '<spring:message code="common.label.userdept.grade"/>',  field: "scYr", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50}, // 학년
                                        {title: '<spring:message code="score.label.request.reason"/>',  field: "objctAplyCts", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80}, // 신청사유
                                        {title: '<spring:message code="score.label.before.score"/>',  field: "chgbfrScr", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}, // 변경 전 점수
                                        {title: '<spring:message code="score.label.after.score"/>',  field: "chgaftScr", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}, // 변경 후 점수
                                        {title: '<spring:message code="score.label.objt.list1"/>',  field: "result", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}, //성적이의</br>신청결과
                                        {title: '<spring:message code="exam.label.process.status"/>',  field: "objctAplyStscd", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 100} //처리상태

                                    ];

                                    let objctAplyListTable = UiTable("mrkObjctAplyList", {
                                        lang: "ko",
                                        table: "list",
                                        selectRow: "checkbox",
                                        columns: cols    // 컬럼정보
                                    });
                                </script>
                                </div>


                        </div>
                    </div><!-- //ui form -->
                </div> <!-- //class_sub -->
            </div><!-- //content -->

        </main><!-- //container -->
    </div><!-- //pusher -->


    <script type="text/javascript">
        const EPARAM = '<c:out value="${encParams}" />';
        let dialog1;
        let dialog2;

        // dialog 닫기
        window.closeDialog1 = function() {
            dialog1.close();
        };

        window.closeDialog2 = function() {
            dialog2.close();
        };

        $(function () {
            onObjctSearch();
        });

        function onObjctSearch() {
            UiComm.showLoading(true);

            let url = "/mrk/profMrkObjctAplyListAjax.do";
            let param = {encParams: EPARAM};

            $.ajax({
                url: url,
                data: param,
                headers: {"X-Requested-With": "XMLHttpRequest"},
                type: "GET",
                success: function (data) {
                    if (data.result > 0) {
                        let returnList = data.returnList || [];

                        objctAplyListTable.clearData();

                        if (returnList.length <= 0) return false;

                        // 테이블 데이터 세팅
                        let dataList = createObjctAplyListHTML(returnList);
                        objctAplyListTable.replaceData(dataList);
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function (){
                    UiComm.showLoading(false);
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
                    scYr: item.scYr,
                    objctAplyCts: `<button class="btn s_basic" data-aplyid="\${item.mrkObjctAplyId}" onclick="openObjctCtsPop(this)">사유</button>`,
                    chgbfrScr: item.chgbfrScr,
                    chgaftScr: item.chgaftScr,
                    result: `<button class="btn s_basic" data-aplyid="\${item.mrkObjctAplyId}" onclick="openObjctAplyListPop(this)">신청결과</button>`,
                    objctAplyStscd: item.cdnm
                })
            });

            return dataList;
        }

        /**
         * 성적 이의신청 사유 확인 팝업 open
         */
        function openObjctCtsPop(element) {
            // const userId = element.dataset.userid;
            const aplyId = element.dataset.aplyid;
            const params = "mrkObjctAplyId=" + aplyId + "&encParams="+EPARAM;

            dialog1 = UiDialog("aplyCtsDialog", {
                title: "<spring:message code="score.appeal.label"/><spring:message code="score.label.reason"/>", /*성적이의신청사유*/
                width: 800,
                height: 30,
                url: "/mrk/profMrkObjctAplySelectPop.do?" + params,
                autoresize: true
            });
        }

        /**
         * 성적이의신청 목록 조회 팝업 open
         * @param element
         */
        function openObjctAplyListPop(element) {
            const aplyId = element.dataset.aplyid;
            const params = "mrkObjctAplyId=" + aplyId + "&encParams="+EPARAM;

            dialog1 = UiDialog("aplyListDialog", {
                title: "<spring:message code="score.label.objt.list"/>", /*성적이의 신청결과*/
                width: 900,
                height: 750,
                url: "/mrk/mrkObjctAplyListViewPop.do?" + params,
                autoresize: false
            });

        }

        /**
         * 성적 상세 조회 팝업 open
         * (성적이의신청팝업 내 버튼)
         * @param element
         */
        function viewObjctAplyCts(element) {
            const userId = element.dataset.userid;
            const params = "userId=" + userId + "&encParams="+EPARAM;

            dialog2 = UiDialog("mrkDetailDialog", {
                title: "<spring:message code="score.label.score.detail.info"/>", /*성적 상세*/
                width: 1100,
                height: 700,
                url: "/mrk/mrkSbjctSelectViewPop.do?" + params,
                autoresize: false
            });
        }

        /**
         * 메시지 보내기
         */
        function sendAlim() {
            let listedStd = objctAplyListTable.getSelectedData("userId");

            alert(listedStd);
            // todo :  알림보내기 화면 나오면 작업예정
        }

        /**
         * 엑셀다운
         */
        function downExcel() {

            let excelGrid = {
                colModel:[
                    {label:'No', 											        name:'lineNo', 		align:'left', 	width:'1000'}, // 번호
                    {label:'<spring:message code="common.dept_name"/>', 	        name:'deptNm', 		align:'left', 	width:'7000'}, // 학과
                    {label:'<spring:message code="common.represent.id"/>', 	        name:'deptNm', 		align:'left', 	width:'7000'}, // 대표아이디
                    {label:'<spring:message code="common.label.student.number"/>',  name:'userId', 		align:'left', 	width:'5000'}, // 학번
                    {label:'<spring:message code="common.name"/>',                  name:'userNm', 		align:'left', 	width:'5000'}, // 이름
                    {label:'<spring:message code="common.label.userdept.grade"/>',  name:'userNm', 		align:'left', 	width:'5000'}, // 학년
                    {label:'<spring:message code="score.label.request.reason"/>',   name:'userNm', 		align:'left', 	width:'7000'}, // 신청사유
                    {label:'<spring:message code="score.label.before.score"/>',     name:'userNm', 		align:'left', 	width:'5000'}, // 변경 전 점수
                    {label:'<spring:message code="score.label.after.score"/>',      name:'userNm', 		align:'left', 	width:'5000'}, // 변경 후 점수
                    {label:'<spring:message code="score.label.objt.list1"/>',       name:'userNm', 		align:'left', 	width:'7000'}, // 성적이의 신청결과
                    {label:'<spring:message code="exam.label.process.status"/>',    name:'userNm', 		align:'left', 	width:'7000'} // 처리상태
                ]
            };

            let url  = "/mrk/profMrkObjctAplyListExcelDown.do";
            let form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "excelForm");
            form.attr("action", url);

            form.append($('<input/>', {type: 'hidden', name: 'encParams',	value: EPARAM}));
            form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
            form.appendTo("body");
            form.submit();

            $("form[name=excelForm]").remove();
        }

        // 부모 창에 정의
        function resizeAplyDialog(height) {
            const $dialog = $("#UI_DIALOG_aplyListDialog");
            if ($dialog.hasClass("ui-dialog-content")) { // 초기화 여부 확인
                $dialog.dialog("option", "height", height);
            }
        }


    </script>

</body>

</html>
