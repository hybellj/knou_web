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
                    <div class="dashboard_sub">

                        <div class="sub-content">
                            <div class="listTab">
                                <ul>
                                    <li class="select"><a href="#"><spring:message code="common.check.grades" /><!-- 성적조회 --></a></li>
                                    <li><a href="/mrk/lec/stdMrkOjctAplyView.do?encParams=${encParams}"><spring:message code="common.label.score.objection.yn"/> <%--성적 이의 신청--%></a></li>
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

                            <div class="alert alert-warning text-center" role="alert" style="background-color: #ffe38b;padding: 15px 0px;margin: 30px 0px;">
                                <p>성적이의 신청기간 : <uiex:formatDate value="${taskSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${taskEdttm}" type="datetime2"/></p>
                            </div>

                            <div id="tableDiv">
                                <div id="mrkObjctAplyList"></div>
                                <script>
                                    let cols = [
                                        {title: "번호", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                        {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                        {title: "대표아이디",field: "userId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                        {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                        {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "학년",  field: "scYr", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "신청사유",  field: "objctAplyCts", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                                        {title: "변경 전 점수",  field: "chgbfrScr", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "변경 후 점수",  field: "chgaftScr", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "성적이의</br>신청결과",  field: "result", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "처리상태",  field: "objctAplyStscd", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 100}

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

            let url = "/mrk/stdMrkObjctAplyListAjax.do";
            let param = {encParams: EPARAM};

            $.ajax({
                url: url,
                data: param,
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
                    objctAplyCts: `<button class="btn s_basic" data-userid="\${item.userId}" onclick="openObjctCtsPop(this)">사유</button>`,
                    chgbfrScr: item.chgbfrScr,
                    chgaftScr: item.chgaftScr,
                    result: `<button class="btn s_basic" data-userid="\${item.userId}" onclick="openObjctAplyListPop(this)">신청결과</button>`,
                    objctAplyStscd: item.cdnm
                })
            });

            return dataList;
        }

        /**
         * 성적 이의신청 사유 확인 팝업 open
         */
        function openObjctCtsPop(element) {
            const userId = element.dataset.userid;
            const params = "userId=" + userId + "&encParams="+EPARAM;

            dialog1 = UiDialog("aplyCtsDialog", {
                title: "<spring:message code="score.appeal.label"/><spring:message code="score.label.reason"/>", /*성적이의신청사유*/
                width: 800,
                height: 30,
                url: "/mrk/mrkObjctAplyCtsSelectPop.do?" + params,
                autoresize: true
            });
        }

        /**
         * 성적이의신청 목록 조회 팝업 open
         * @param element
         */
        function openObjctAplyListPop(element) {
            const userId = element.dataset.userid;
            const params = "userId=" + userId + "&encParams="+EPARAM;

            dialog1 = UiDialog("aplyListDialog", {
                title: "<spring:message code="score.label.objt.list"/>", /*성적이의 신청결과*/
                width: 900,
                height: 300,
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
