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
<script type="text/javascript">
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let PAGE_INDEX = '<c:out value="${vo.pageIndex}" />';

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        onObjctSearch(1);
    }
</script>
<body class="class ${uiex:getTheme()}  ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
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
                                    <li><a href="/mrk/lec/stdSbjctMrkStsView.do?encParams=${encParams}"><spring:message code="common.check.grades" /><!-- 성적조회 --></a></li>
                                    <li class="select"><a href="#"><spring:message code="common.label.score.objection.yn"/> <%--성적 이의 신청--%></a></li>
                                </ul>
                            </div>

                            <div class="page-info">
                                <%--타이틀--%>
                                <h4 class="sub-title">목록</h4>
                                <uiex:navibar type="lect"/> <%-- 네비게이션바 --%>
                            </div>

                            <div class="alert alert-warning text-center" role="alert" style="background-color: #ffe38b;padding: 15px 0px;margin-bottom: 30px;">
                                <p>성적이의 신청기간 : <uiex:formatDate value="${taskSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${taskEdttm}" type="datetime2"/></p>
                            </div>

                            <c:if test="${objctAplyProdYn eq 'Y'}">
                            <div id="tableDiv">
                                <div class="board_top">
                                    <div class="right-area">
                                        <button type="button" class="btn type2" onclick="applyObjctAply()"><spring:message code="user.title.userinfo.date"/></button> <%--신청하기--%>

                                            <%-- 목록 스케일 선택 --%>
                                        <uiex:listScale func="changeListScale" value="${vo.listScale}" />
                                    </div>
                                </div>
                                <div id="mrkObjctAplyList"></div>
                            </div>
                            </c:if>

                        </div>
                    </div><!-- //ui form -->
                </div> <!-- //class_sub -->
            </div><!-- //content -->

        </main><!-- //container -->
    </div><!-- //pusher -->

    <c:if test="${objctAplyProdYn eq 'Y'}">
    <script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        let objctAplyListTable;
        let dialog;


        // dialog 닫기
        window.closeDialog = function() {
            dialog.close();
        };

        $(function () {
            let cols = [
                {title: "번호", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                {title: "과목",  field: "sbjctnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 200},
                {title: "분반", field: "dvclasNo", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                {title: "대표아이디",field: "userRprsId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                {title: "처리상태",  field: "objctAplyStscd", headerHozAlign: "center", hozAlign: "left", width: 180, minWidth: 180},
                {title: "처리일시",  field: "chgDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                {title: "관리",  field: "result", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100}
            ];

            objctAplyListTable = UiTable("mrkObjctAplyList", {
                lang: "ko",
                table: "list",
                columns: cols,    // 컬럼정보
                pageFunc: onObjctSearch,
            });

            onObjctSearch();
        });

        function onObjctSearch(pageIndex) {
            UiComm.showLoading(true);

            PAGE_INDEX = pageIndex;

            let extData = {
                pageIndex: pageIndex,
                listScale: LIST_SCALE
            };

            let url = "/mrk/stdMrkObjctAplyListAjax.do";
            let param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            $.ajax({
                url: url,
                data: param,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function (data) {
                    if (data.encParams != null && data.encParams !== '') {
                        EPARAM = data.encParams;
                    }

                    if (data.result > 0) {
                        let returnList = data.returnList || [];

                        // 테이블 데이터 세팅
                        let dataList = createObjctAplyListHTML(returnList);
                        objctAplyListTable.clearData();
                        objctAplyListTable.replaceData(dataList);
                        objctAplyListTable.setPageInfo(data.pageInfo);

                        // $("#totCnt").text(건수입력)
                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
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
                // const lineNo = list.length - i;
                const mdfyBtn = `<button class="btn s_basic" data-aplyid="\${item.mrkObjctAplyId}" onclick="openMdfyAplyPop(this)"><spring:message code="common.button.edit"/> <!--수정하기--></button>`;
                const rsltBtn = `<button class="btn s_basic" data-aplyid="\${item.mrkObjctAplyId}" onclick="openRsltPop(this)"><spring:message code="score.label.result"/><!--처리결과--></button>`;
                const resultBtn = item.chgDttm ? rsltBtn : mdfyBtn;

                dataList.push({
                    no: item.lineNo,
                    deptnm: item.deptnm,
                    sbjctnm: item.sbjctnm,
                    dvclasNo: item.dvclasNo,
                    userRprsId: item.userRprsId,
                    stdntNo: item.stdntNo,
                    usernm: item.usernm,
                    objctAplyStscd: item.cdnm,
                    chgDttm: item.chgDttm || "-",
                    result: resultBtn,
                })
            });

            return dataList;
        }

        /**
         * 이의신청 등록 화면
         */
        function applyObjctAply() {
            dialog = UiDialog("aplyDialog", {
                title: "<spring:message code="common.label.score.objection.yn"/>", /*성적이의신청*/
                width: 1100,
                height: 850,
                url: "/mrk/stdMrkObjctAplyRegistViewPop.do?encParams=" + EPARAM,
                autoresize: false
            });
        }

        /**
         * 이의신청 수정 팝업
         * @param element
         */
        function openMdfyAplyPop(element) {
            const aplyId = element.dataset.aplyid;

            dialog = UiDialog("aplyDialog", {
                title: "<spring:message code="common.label.score.objection.yn"/>", /*성적이의신청*/
                width: 1100,
                height: 850,
                url: "/mrk/stdMrkObjctAplyModifyViewPop.do?encParams=" + EPARAM + "&mrkObjctAplyId=" + aplyId,
                autoresize: false
            });
        }

        /**
         * 성적 이의신청 사유 확인 팝업 open
         */
        function openRsltPop(element) {
            const aplyId = element.dataset.aplyid;
            const params = "mrkObjctAplyId=" + aplyId + "&encParams="+EPARAM;

            dialog = UiDialog("aplyCtsDialog", {
                title: "<spring:message code="common.label.score.objection.yn"/> <spring:message code="score.label.result"/>", /*성적이의신청 처리결과*/
                width: 1100,
                height: 850,
                url: "/mrk/stdMrkObjctAplySelectPop.do?" + params,
                autoresize: false
            });
        }
    </script>
    </c:if>

</body>

</html>
