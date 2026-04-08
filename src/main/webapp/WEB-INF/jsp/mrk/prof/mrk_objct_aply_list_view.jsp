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
<body class="class colorA  ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
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
                <div class="class_sub_top">
                    <div class="navi_bar">
                        <ul>
                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                            <li>강의실</li>
                            <li><span class="current">성적관리</span></li>
                        </ul>
                    </div>
                    <div class="btn-wrap">
                        <div class="first">
                            <select class="form-select">
                                <option value="2026년 1학기">2026년 1학기</option>
                                <option value="2026년 2학기">2026년 2학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2026년 1학기">2026년 1학기</option>
                                <option value="2026년 2학기">2026년 2학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
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

                            <div class="alert alert-warning text-center" role="alert" style="background-color: #ffe38b;padding: 15px 0px;margin: 30px 0px;">
                                <p>성적이의 신청기간 : <uiex:formatDate value="${taskSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${taskEdttm}" type="datetime2"/></p>
                            </div>

                            <div id="tableDiv">
                                <div id="mrkObjctAplyList"></div>
                                <script>
                                    let cols = [
                                        {title:"No", file: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                        {title: "학과",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                        {title: "대표아이디",field: "userId",headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                        {title: "학번",  field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                        {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "학년",  field: "scYr", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},
                                        {title: "신청사유",  field: "objctAplyCts", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80},
                                        {title: "변경 전 점수",  field: "chgbfrScr", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "변경 후 점수",  field: "chgaftScr", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "성적이의</br>신청결과",  field: "result", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "처리상태",  field: "objctAplyStscd", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100}

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
        let dialog;

        // dialog 닫기
        window.closeDialog = function() {
            dialog.close();
        };

        $(function () {
            onObjctSearch();
        });

        function onObjctSearch() {
            UiComm.showLoading(true);

            let url = "/mrk/mrkObjctAplyListAjax.do";
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

            list.forEach(item => {
                dataList.push({
                    no:  item.no,
                    deptnm: item.deptnm,
                    userId: item.userId,
                    stdntNo: item.stdntNo,
                    usernm: item.usernm,
                    scYr: item.scYr,
                    objctAplyCts: `<button class="btn s_basic" data-objctid="\${item.mrkObjctAplyId}" onclick="openObjctCtsPop(this)">사유</button>`,
                    chgbfrScr: item.chgbfrScr,
                    chgaftScr: item.chgaftScr,
                    result: `<button class="btn s_basic" data-userid="\${item.userId}">신청결과</button>`,
                    objctAplyStscd: item.cdnm
                })
            });

            return dataList;
        }

        /**
         * 성적 이의신청 사유 확인 팝업 open
         */
        function openObjctCtsPop(element) {
            const mrkObjctAplyId = element.dataset.objctid;
            const params = "mrkObjctAplyId=" + mrkObjctAplyId + "&encParams="+EPARAM;

            dialog = UiDialog("aplyCtsDialog", {
                title: "<spring:message code="score.appeal.label"/><spring:message code="score.label.reason"/>", /*성적이의신청사유*/
                width: 800,
                height: 30,
                url: "/mrk/mrkObjctAplyCtsSelectPop.do?" + params,
                autoresize: true
            });


        }
    </script>

</body>

</html>
