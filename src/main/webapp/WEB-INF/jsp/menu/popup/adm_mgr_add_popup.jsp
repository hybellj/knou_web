<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="table"/>
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<body>
    <form name="admAuthForm" id="admAuthForm" method="POST"></form>
    <div id="wrap">
        <div class="sub-box">
            <c:if test="${vo.mode != 'U'}">
                <div class="board_top">
                    <select class="ui dropdown" id="orgId">
                        <option value=""><spring:message code="bbs.label.org" /></option>
                        <c:forEach var="list" items="${filterOptions.orgList}">
                            <option value="${list.orgId}">${list.orgnm}</option>
                        </c:forEach>
                    </select>
                    <select class="ui dropdown" id="userTycd">
                        <option value="">사용자 유형</option>
                        <c:forEach var="list" items="${filterOptions.userTycdList}">
                            <option value="${list.userTycd}">${list.userTycdnm}</option>
                        </c:forEach>
                    </select>
                    <input class="form-control wide" type="text" id="searchValue" placeholder="이름/연락처 입력">
                    <button type="button" class="btn basic icon search" aria-label="검색" onclick="listPaging(1)">
                        <i class="icon-svg-search"></i>
                    </button>
                    <uiex:listScale func="changeListScale" value="${vo.listScale}" />
                </div>
            </c:if>

            <div class="table-wrap">
                <div id="activityLogTable"></div>
            </div>

            <!-- 관리자 구분 목록 데이터 (chosen 영향 없는 hidden, JS에서 파싱) -->
            <input type="hidden" id="admGbnListJson"
                   value='<c:forEach var="adm" items="${filterOptions.admGbnList}" varStatus="st"><c:if test="${!st.first}">,</c:if>{"code":"${adm.authrtCd}","name":"${adm.authrtnm}"}</c:forEach>' />
        </div>

        <!-- 닫기 -->
        <div class="modal_btns">
            <c:if test="${vo.mode != 'I'}">
                <button type="button" class="btn type1" onclick="saveConfirm()">
                    <spring:message code="common.button.save" />
                </button>
            </c:if>
            <button type="button" class="btn type2" onclick="closePopup()">
                <spring:message code="button.close"/>
            </button>
        </div>

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
    </div>

    <script type="text/javascript">
        /* =============================================
         * 전역 변수
         * ============================================= */
        var LIST_SCALE    = '<c:out value="${vo.listScale}" />';
        var PAGE_INDEX    = '<c:out value="${vo.pageIndex}" />';
        var USER_ID       = '<c:out value="${vo.userId}" />';
        var MODE          = '<c:out value="${vo.mode}" />';
        var AUTHRT_TYCD   = '<c:out value="${vo.authrtTycd}" />';
        var EPARAM        = '<c:out value="${encParams}" />';
        var addedUserIds  = [];   // 추가된 userId 목록 (중복 방지용)
        var popupDataList = [];   // 원본 데이터 보관 (재렌더링용)
        var activityLogTable;     // 테이블 인스턴스

        // 관리자 구분 목록 - hidden input 에서 JSON 파싱
        var admGbnList = [];
        (function() {
            var raw = $("#admGbnListJson").val();
            if (raw) {
                try { admGbnList = JSON.parse("[" + raw + "]"); }
                catch(e) { console.error("admGbnList 파싱 실패", e); }
            }
        })();

        /* =============================================
         * 테이블 초기화 - listPaging 선언 이후에 생성
         * ============================================= */
        $(document).ready(function() {
            activityLogTable = UiTable("activityLogTable", {
                lang: "ko",
                table: "list",
                layout: "fitColumns",
                placeholder: '<spring:message code="common.no.data.result"/>',
                columns: [
                    {
                        title: '<spring:message code="common.number.no"/>',
                        field: "no",
                        headerHozAlign: "center",
                        hozAlign: "center",
                        width: 60,
                        minWidth: 60,
                        visible: MODE !== 'U'
                    },
                    { title: '기관',      field: "orgnm",    headerHozAlign: "center", hozAlign: "center", minWidth: 80  },
                    { title: '사용자 유형', field: "userTycd", headerHozAlign: "center", hozAlign: "center", minWidth: 90  },
                    { title: '이름',      field: "usernm",   headerHozAlign: "center", hozAlign: "center", minWidth: 80  },
                    { title: '연락처',    field: "cntct",    headerHozAlign: "center", hozAlign: "center", minWidth: 100 },
                    { title: '이메일',    field: "eml",      headerHozAlign: "center", hozAlign: "center", minWidth: 140 },
                    {
                        title    : MODE === 'U' ? '관리자 권한 설정' : '추가',
                        field    : "mng",
                        headerHozAlign: "center",
                        hozAlign : "center",
                        minWidth : MODE === 'U' ? 150 : 100,
                        formatter: "html"
                    }
                ],
                pageFunc: listPaging
            });

            listPaging(1);
        });

        /* =============================================
         * 목록 조회 (페이징)
         * ============================================= */
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            var extData = {
                orgId      : $("#orgId").val(),
                userTycd   : $("#userTycd").val(),
                searchValue: $("#searchValue").val(),
                userId     : USER_ID,
                pageIndex  : PAGE_INDEX,
                listScale  : LIST_SCALE
            };

            var param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            UiComm.showLoading(true);

            ajaxCall(
                "/menu/menuMgr/admAuthMngListViewAjax.do?mode=I",
                param,
                function(data) {
                    if (data.encParams != null && data.encParams !== '') {
                        EPARAM = data.encParams;
                    }

                    if (data.result > 0) {
                        popupDataList = data.returnList || [];
                        renderPopupTable();
                        activityLogTable.setPageInfo(data.pageInfo);
                    } else {
                        UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                    }

                    UiComm.showLoading(false);
                },
                function(xhr, status, error) {
                    UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                    UiComm.showLoading(false);
                },
                true
            );
        }

        /* =============================================
         * list scale 변경
         * ============================================= */
        function changeListScale(scale) {
            LIST_SCALE = scale;
            listPaging(1);
        }

        /* =============================================
         * 팝업 테이블 렌더링 (추가된 항목 제외)
         * ============================================= */
        function renderPopupTable() {
            var dataList = createAtclListHTML(popupDataList);
            activityLogTable.clearData();
            activityLogTable.replaceData(dataList);
        }

        /* =============================================
         * 관리자 구분 select 생성 (JS 문자열 직접 생성)
         * @param v           행 데이터 (userId 포함)
         * @param authrtTycd  현재 권한 유형 ('ALL' 이면 전체 노출, 그 외는 기관/컨텐츠만)
         * ============================================= */
        function makeMngSelect(v, authrtTycd) {
            // ALL 이 아니면 기관관리자(ORGOP), 컨텐츠관리자(CONTSOP) 만 노출
            var allowed = (authrtTycd === 'ALL') ? null : ['ORGOP', 'CONTSOP'];

            var html = '<select class="form-select" style="width:140px;" data-userid="' + (v.userId || '') + '">';
            html += '<option value="">관리자 구분</option>';
            admGbnList.forEach(function(item) {
                if (allowed === null || allowed.indexOf(item.code) > -1) {
                    html += '<option value="' + item.code + '">' + item.name + '</option>';
                }
            });
            html += '</select>';
            return html;
        }

        /* =============================================
         * 테이블 행 HTML 생성
         * ============================================= */
        function createAtclListHTML(atclList) {
            var dataList = [];

            atclList.forEach(function(v) {
                // 이미 추가된 항목 제외
                if (addedUserIds.indexOf(v.userId) !== -1) return;

                var mngHtml = '';

                if (MODE === 'U') {
                    mngHtml = makeMngSelect(v, AUTHRT_TYCD);
                } else {
                    mngHtml = '<button type="button" class="btn basic small"'
                            + ' onclick="addAdminToParent('
                            +     '\'' + (v.userId   || '') + '\','
                            +     '\'' + (v.authrtnm || '') + '\','
                            +     '\'' + (v.orgnm    || '') + '\','
                            +     '\'' + (v.userTycd || '') + '\','
                            +     '\'' + (v.usernm   || '') + '\','
                            +     '\'' + (v.cntct    || '') + '\','
                            +     '\'' + (v.eml      || '') + '\''
                            + ')">'
                            + '<spring:message code="sys.button.add"/></button>';
                }

                dataList.push({
                    userId  : v.userId,
                    no      : v.lineNo,
                    authrtnm: v.authrtnm,
                    orgnm   : v.orgnm,
                    userTycd: v.userTycd,
                    usernm  : v.usernm,
                    cntct   : v.cntct,
                    eml     : v.eml,
                    mng     : mngHtml
                });
            });

            return dataList;
        }

        /* =============================================
         * 추가 버튼 클릭 → 부모창 테이블에 행 추가
         * ============================================= */
        function addAdminToParent(userId, authrtnm, orgnm, userTycd, usernm, cntct, eml) {
            if (addedUserIds.indexOf(userId) !== -1) {
                UiComm.showMessage("이미 추가된 사용자입니다.", "warning");
                return;
            }

            var selectedData = {
                userId  : userId,
                authrtnm: authrtnm,
                orgnm   : orgnm,
                userTycd: userTycd,
                usernm  : usernm,
                cntct   : cntct,
                eml     : eml
            };

            try {
                var parentWin = window.parent || window.opener;

                if (parentWin && typeof parentWin.addRowToMainTable === 'function') {
                    parentWin.addRowToMainTable(selectedData);
                    addedUserIds.push(userId);
                    renderPopupTable();
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            } catch(e) {
                UiComm.showMessage("오류가 발생했습니다: " + e.message, "error");
            }
        }

        /* =============================================
         * 저장
         * ============================================= */
        function saveConfirm() {
        	var tableData = activityLogTable.getData();

        	if (!tableData || tableData.length === 0) {
    	        UiComm.showMessage("저장할 관리자가 없습니다.", "warning");
    	        return;
    	    }

        	// 권한(관리자 구분)을 선택하지 않은 행이 있는지 검증
    	    var hasEmpty = false;
    	    tableData.forEach(function(row) {
    	        var $select  = $("#activityLogTable").find("select[data-userid='" + row.userId + "']");
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
    	    // ※ 프로젝트의 레이어팝업 호출 방식에 맞게 수정 필요
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
		    var tableData = activityLogTable.getData();   // ← 이 팝업의 테이블

		    var admList = tableData.map(function(row) {
		        var $select  = $("#activityLogTable").find("select[data-userid='" + row.userId + "']");  // ← 수정
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

		    var saveData = {
		        authrtChgCts: rsn,
		        admList     : admList
		    };
		    formData.push({ name: "saveDataJson", value: JSON.stringify(saveData) });

		    ajaxCall(url, formData, function(data) {
		        if (data.result > 0) {
		            closeAuthRsnLayer();   // 사유 레이어 닫기
		            UiComm.showMessage("저장되었습니다.", "success")
		            .then(function(result) {
		                // 부모창 목록 새로고침
		                try {
		                    var parentWin = window.parent || window.opener;
		                    if (parentWin && typeof parentWin.listPaging === 'function') {
		                        parentWin.listPaging(1);
		                    }
		                } catch(e) { console.log(e); }

		                // 관리자 수정 팝업 닫기
		                closePopup();
		            });
		        } else {
		            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error");
		        }
		    },
		    function(xhr, status, error) {
		        UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
		    }, true);
		}

        /* =============================================
         * 팝업 닫기
         * ============================================= */
        function closePopup() {
            try {
                var dlgId = null;
                if (window.frameElement) {
                    dlgId = $(window.frameElement).closest('[data-dialog-id]').data('dialog-id');
                }
                if (dlgId && window.parent && typeof window.parent.UiDialog === 'function') {
                    var dlg = window.parent.UiDialog(dlgId);
                    if (dlg && typeof dlg.close === 'function') { dlg.close(); return; }
                }
                $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
            } catch(e) {
                window.close();
            }
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
</body>
</html>