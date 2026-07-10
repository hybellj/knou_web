<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
	</jsp:include>
</head>
<script type="text/javascript">
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let PAGE_INDEX = '<c:out value="${vo.pageIndex}" />';
    let EPARAM = '<c:out value="${encParams}" />';
    let ORG_ID = '<c:out value="${orgId}" />';

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

    // 관리자 추가 팝업 열기
	function sysMgrAddPopup() {
		var extData = {
			mode      : "I"
        };

        const url = "/menu/menuMgr/admMgrAddPopupView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);

        const sysMgrAddDialog = UiDialog("sysMgrAddDialog", {
            title: "관리자 추가"
            , width: 1200
            , height: 800
            , modal: true
            , resizable: true
            , draggable: true
            , autoresize: false
            , url: url
        });
    }

    function moveListPage() {
    	document.location.href = "/menu/menuMgr/admAuthMngListView.do?encParams=${encParams}";
    }

    // -------------------------------------------------------
    // 팝업에서 추가 버튼 클릭 시 호출 → 메인 테이블에 행 추가
    // -------------------------------------------------------
    function addRowToMainTable(data) {
        var currentData = admAuthMngListTable.getData();
        var newNo = currentData.length + 1;

        // 관리자 권한 설정 셀렉트박스
        var mngHtml = "<select class=\"form-select\" style=\"width:140px;\" data-userid=\"" + (data.userId || '') + "\">"
                    + "<option value=''>관리자 구분</option>"
                    + "<option value='ADM'>전체 시스템관리자</option>"
                    + "<option value='ORGOP'>기관 관리자</option>"
                    + "<option value='CONTSOP'>컨텐츠 관리자</option>"
                    + "<option value='SBJCTOP'>과목 관리자</option>"
                    + "<option value='EXTRNLOP'>외부 관리자</option>"
                    + "</select>";

        var newRow = {
            no       : newNo,
            authrtnm : data.authrtnm || '',
            orgnm    : data.orgnm    || '',
            userTycd : data.userTycd || '',
            usernm   : data.usernm   || '',
            cntct    : data.cntct    || '',
            eml      : data.eml      || '',
            mng      : mngHtml,

            userId   : data.userId   || '',
            orgId    : data.orgId    || '',
            authrtId : data.authrtId || ''
        };

        admAuthMngListTable.addData([newRow]);
    }

	// 저장 버튼 클릭 → 사유 입력 팝업 먼저 표시
	function saveConfirm() {
	    var tableData = admAuthMngListTable.getData();

	    if (!tableData || tableData.length === 0) {
	        UiComm.showMessage("저장할 관리자가 없습니다.", "warning");
	        return;
	    }

	    // 권한(관리자 구분)을 선택하지 않은 행이 있는지 검증
	    var hasEmpty = false;
	    tableData.forEach(function(row) {
	        var $select  = $("#admAuthMngList").find("select[data-userid='" + row.userId + "']");
	        var authrtCd = $select.length ? $select.val() : '';
	        if (!authrtCd) hasEmpty = true;
	    });
	    if (hasEmpty) {
	        UiComm.showMessage("관리자 구분을 선택하지 않은 항목이 있습니다.", "warning");
	        return;
	    }

	    // 사유 초기화 후 레이어팝업 표시
	    $("#authrtChgCts").val("");
	    openAuthRsnLayer();
	}

	// 사유 입력 레이어팝업 열기
	function openAuthRsnLayer() {
	    // 예시: UiDialog 사용 시
	    UiDialog("authRsnLayer", {
	        title: "권한 부여 및 변경 사유",
	        width: 500,
	        buttons: [
	            {
	                text: "저장",
	                click: function() {
	                    doSave();   // 사유 확인 후 실제 저장
	                }
	            }
	        ]
	    });
	}

	// 실제 저장 (사유 포함)
	function doSave() {
	    var rsn = $.trim($("#authrtChgCts").val());
	    if (!rsn) {
	        UiComm.showMessage("사유를 입력하세요.", "warning");
	        return;
	    }

	    var url       = "/menu/menuMgr/admAuthSave.do";
	    var returnUrl = "/menu/menuMgr/admAuthMngListView.do?encParams=${encParams}";
	    var formData  = $("#admAuthForm").serializeArray();
	    var tableData = admAuthMngListTable.getData();

	    var admList = tableData.map(function(row) {
	        var $select  = $("#admAuthMngList").find("select[data-userid='" + row.userId + "']");
	        var authrtCd = $select.length ? $select.val() : '';
	        return {
	            userId   : row.userId,
	            orgId    : row.orgId,
	            orgnm    : row.orgnm,
	            userTycd : row.userTycd,
	            usernm   : row.usernm,
	            authrtCd : authrtCd,
	            authrtId : row.authrtId
	        };
	    });

	    // 사유 + 목록을 하나의 객체로 묶어 전송
	    var saveData = {
	    	authrtChgCts: rsn,
	        admList   : admList
	    };
	    formData.push({ name: "saveDataJson", value: JSON.stringify(saveData) });
	    ajaxCall(url, formData, function(data) {
	        if (data.result > 0) {
	            closeAuthRsnLayer();
	            UiComm.showMessage("저장되었습니다.", "success")
	            .then(function(result) {
	                document.location.href = returnUrl;
	            });
	        } else {
	            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error");
	        }
	    },
	    function(xhr, status, error) {
	        UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
	    }, true);
	}

	// 사유 입력 레이어팝업 열기
	function openAuthRsnLayer() {
	    $("#authrtChgCts").val("");
	    $("#authRsnLayer").show();
	    $("#authrtChgCts").focus();
	}

	// 사유 입력 레이어팝업 닫기
	function closeAuthRsnLayer() {
	    $("#authRsnLayer").hide();
	}
</script>

<body class="admin">
	<form name="admAuthForm" id="admAuthForm" method="POST"></form>

    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>관리자</li>
                                    <li><span class="current">${uiex:getCurMenunm()}</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">관리자 등록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="sysMgrAddPopup()">관리자 추가</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요." onchange="changeListScale(this.value)">
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                        	<div id="admAuthMngList"></div>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="saveConfirm()"><spring:message code="common.button.save" /></button><%-- 저장 --%>
                            <button type="button" class="btn type2" onclick="moveListPage()"><spring:message code="common.button.list" /></button><%-- 취소 --%>
                        </div>
                        <!--//table-type-->

                        <script type="text/javascript">
                            let admAuthMngListTable;

                            $(function () {
                                let cols = [
                                    {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                    {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                                    {title: "사용자 유형", field: "userTycd", headerHozAlign: "center", hozAlign: "center", width: 180, minWidth: 180},
                                    {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "연락처",  field: "cntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "이메일",  field: "eml", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250},
                                    {title: "관리자 권한 설정",  field: "mng", headerHozAlign: "center", hozAlign: "center", width: 160, minWidth: 160, formatter: "html"},
                                    {field: "userId",   visible: false},
                                    {field: "orgId",    visible: false},
                                    {field: "authrtId", visible: false}
                                ];

                                admAuthMngListTable = UiTable("admAuthMngList", {
                                    lang: "ko",
                                    table: "list",
                                    columns: cols,
                                    // pageFunc 제거 - 팝업에서 추가한 데이터만 표시
                                });
                            });

                            // 목록 조회
                            function listPaging(pageIndex) {
                                UiComm.showLoading(true);

                                PAGE_INDEX = pageIndex;

                                let extData = {
									orgId : ORG_ID,
                                    searchValue : $("#searchValue").val(),
                                    pageIndex: pageIndex,
                                    listScale: LIST_SCALE
                                };

                                let param = {
                                    encParams: EPARAM,
                                    addParams: UiComm.makeEncParams(extData)
                                };

                                $.ajax({
                                    url: "/menu/menuMgr/admAuthMngListViewAjax.do",
                                    data: param,
                                    type: "GET",
                                    success: function (data) {
                                        if (data.encParams != null && data.encParams !== '') {
                                            EPARAM = data.encParams;
                                        }

                                        if (data.result > 0) {
                                            let returnList = data.returnList || [];
                                            let dataList = createOrgListHTML(returnList, data.pageInfo);
                                            admAuthMngListTable.clearData();
                                            admAuthMngListTable.replaceData(dataList);
                                            admAuthMngListTable.setPageInfo(data.pageInfo);
                                        } else {
                                            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error");
                                        }
                                    },
                                    error: function(xhr, status, error) {
                                        UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");
                                    },
                                    complete: function (){
                                        UiComm.showLoading(false);
                                    }
                                });
                            }

                            // 테이블 행 생성
                            function createOrgListHTML(list, pageInfo) {
                                let dataList = [];

                                list.forEach(function(v, i) {
                                	var mngHtml = "";
                    	            mngHtml += "<a href=\"javascript:moveAtclBbs('" + v.bbsId + "', '" + v.bbsTycd + "', '" + v.bbsAddyn + "')\" class=\"btn basic small\"><spring:message code='sys.button.add'/></a>";

                                    dataList.push({
                                        no: v.lineNo,
                                        authrtId: v.authrtId,
                                        authrtnm: v.authrtnm,
                                        orgId: v.orgId,
                                        orgnm: v.orgnm,
                                        userTycd: v.userTycd,
                                        userId: v.userId,
                                        usernm: v.usernm,
                                        cntct: v.cntct,
                                        eml: v.eml,
                                        mng: mngHtml
                                    });
                                });

                                return dataList;
                            }

                            function moveToDtl(orgId) {
                                document.location.href = "/org/orgMgr/admOrgDetailView.do?orgId=" + orgId + "&encParams=" + EPARAM;
                            }

                            function moveToRegist() {
                                document.location.href = "/org/orgMgr/admOrgRegistView.do?encParams=" + EPARAM;
                            }

                            function setTelNo(telNo) {
                                let len = telNo.length;
                                let prefixLen = telNo.startsWith("02") ? 2 : 3;
                                let part1 = telNo.substring(0, prefixLen);
                                let part2 = telNo.substring(prefixLen, len - 4);
                                let part3 = telNo.substring(len - 4);
                                return part1 + "-" + part2 + "-" + part3;
                            }
                        </script>

                    </div>
                </div>
            </div>
            <!-- //content -->

			<!-- 권한 부여 및 변경 사유 레이어팝업 -->
			<div id="authRsnLayer" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.4); z-index:9999;">
			    <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); width:500px; background:#fff; border-radius:6px; padding:20px; box-shadow:0 4px 20px rgba(0,0,0,0.3);">
			        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
			            <h3 style="margin:0; font-size:16px;">권한 부여 및 변경 사유</h3>
			            <button type="button" onclick="closeAuthRsnLayer()" style="border:none; background:none; font-size:18px; cursor:pointer;">×</button>
			        </div>
			        <textarea id="authrtChgCts" class="form-control" rows="5" style="width:100%; box-sizing:border-box;" placeholder="사유를 입력하세요."></textarea>
			        <div style="text-align:center; margin-top:16px;">
			            <button type="button" class="btn type1" onclick="doSave()">저장</button>
			            <button type="button" class="btn type2" onclick="closeAuthRsnLayer()">닫기</button>
			        </div>
			    </div>
			</div>

        </main>
        <!-- //admin-->

    </div>

</body>
</html>
