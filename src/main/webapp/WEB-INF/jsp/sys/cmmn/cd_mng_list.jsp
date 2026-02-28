<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        /******************
         * 변수 지정
         ******************/
        var PAGE_INDEX = 1;
        var LIST_SCALE = 5;
        var isInsert = true;

        // Ajax URL
        var upCdInsertURL = "addSysCmmnUpCd.do";
        var upCdUpdateURL = "editSysCmmnUpCd.do";
        var upCdDeleteURL = "removeSysCmmnUpCd.do";
        var cdInsertURL = "addSysCmmnCd.do";
        var cdUpdateURL = "editSysCmmnCd.do";
        var cdDeleteURL = "removeSysCmmnCd.do";

        /******************
         * 페이지 초기화
         ******************/
        $(document).ready(function() {
            // 페이지 로드 시 목록 조회
            listUpCdPaging(1);

            // 검색 버튼 클릭
            $("#searchUpCdnmBtn").on("click", function() {
                listUpCdPaging(1);
            });

            // 검색창 엔터키
            $("#searchUpCdnm").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listUpCdPaging(1);
                }
            });

            // 공통코드 검색 버튼 클릭
            $("#searchCdnmBtn").on("click", function() {
                var upCd = $("#modifyCdArea1 #upCd").val();
                if (!upCd) {
                    UiComm.showMessage("분류 코드를 먼저 선택해주세요.", "warning");
                    return;
                }
                listCdPaging(1, upCd);
            });

            // 공통코드 검색창 엔터키
            $("#searchCdnm").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    var upCd = $("#modifyCdArea1 #upCd").val();
                    if (!upCd) {
                        UiComm.showMessage("분류 코드를 먼저 선택해주세요.", "warning");
                        return;
                    }
                    listCdPaging(1, upCd);
                }
            });

            // 공통코드분류 취소 버튼 클릭
            $("#upCdCancleBtn").on("click", function() {
                // 작성 중인 내용이 있는지 확인
                var hasContent = $("#updtUpCd").val() || $("#upCdnm").val();
                console.log("isInsert ? : " + isInsert);
                if (hasContent) {
                    UiComm.showMessage("작성중인 내용이 있습니다.\n취소 하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            // 확인 선택 시 초기화
                            resetmodifyUpCdArea();
                        }
                    });
                } else {
                    resetmodifyUpCdArea();
                }
            });

            // 등록 버튼 클릭
            $("#upCdInsertBtn").on("click", function() {
                activatemodifyUpCdArea();
            });

            // 공통코드분류 저장 버튼 클릭
            $("#upCdSaveBtn").on("click", function() {
                saveUpCd();
            });

            // 공통코드 저장 버튼 클릭
            $("#cdSaveBtn").on("click", function() {
                saveCd();
            });

            // 공통코드 취소 버튼 클릭
            $("#cdCancleBtn").on("click", function() {
                // 작성 중인 내용이 있는지 확인
                var hasContent = $("#modifyCdArea1 #cd").val() || $("#modifyCdArea2 #cdnm").val() || $("#modifyCdArea2 #cdSeqno").val();

                console.log("isInsert ? : " + isInsert);
                if (hasContent) {
                    UiComm.showMessage("작성중인 내용이 있습니다.\n취소 하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            // 확인 선택 시 초기화
                            resetmodifyCdArea();
                        }
                    });
                } else {
                    resetmodifyCdArea();
                }
            });
        });

        /******************
         * 공통코드 분류
         ******************/
        /* 공통코드분류: 목록 조회(페이징) */
        function listUpCdPaging(pageIndex) {
            PAGE_INDEX = pageIndex;
            var cdnm = $("#searchUpCdnm").val();

            var url = "/sys/mgr/sysCmmnUpCdPaging.do";
            var param = {
                pageIndex: pageIndex,
                listScale: LIST_SCALE,
                cdnm: cdnm
            };

            // 로딩 표시
            UiComm.showLoading(true);

            $.ajax({
                url: url,
                type: "GET",
                data: param,
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        let returnList = data.returnList || [];
                        let dataList = createUpCdListData(returnList, data.pageInfo);

                        cmmnUpCdListTable.clearData();
                        cmmnUpCdListTable.replaceData(dataList);
                        cmmnUpCdListTable.setPageInfo(data.pageInfo);

                        // 스위치 초기화 (동적으로 추가된 체크박스를 ui-switcher로 변환)
                        initTableSwitcher();
                    } else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("에러가 발생했습니다!");
                },
                complete: function() {
                    // 로딩 닫기
                    UiComm.showLoading(false);
                }
            });
        }

        /* 공통코드분류: 테이블 데이터 생성 */
        function createUpCdListData(list, pageInfo) {
            let dataList = [];

            if(list.length == 0) {
                return dataList;
            }

            list.forEach(function(v, i) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

                // 디버깅용 로그
                console.log("데이터:", v);

                // 관리 버튼 HTML 생성
                var manageUpButtons = '<button type="button" class="btn small" onclick="registerCode(\'' + v.cd + '\')">코드 등록</button> ' +
                                   '<button type="button" class="btn small" onclick="editUpCd(\'' + v.cmmnCdId + '\', \'' + v.cd + '\', \'' + v.upCdnm + '\')">수정</button> ' +
                                   '<button type="button" class="btn small" onclick="deleteUpCd(\'' + v.cd + '\')">삭제</button>';

                dataList.push({
                    no: lineNo,
                    cdnm: v.upCdnm,
                    cd: v.cd,
                    manageUp: manageUpButtons,
                    cmmnCdId: v.cmmnCdId
                });
            });

            return dataList;
        }

        /* 분류코드: row 클릭 이벤트 */
        function onUpCdRowClick(rowData) {
            console.log("선택된 분류코드:", rowData);

            // modifyCdArea1의 upCd에 값 입력
            $("#modifyCdArea1 #upCd").val(rowData.cd);

            // 해당 분류코드의 공통코드 목록 조회
            listCdPaging(1, rowData.cd);
        }

        /******************
         * 공통코드 분류 함수 (Button, onChange 등...)
         ******************/
        /* 코드 등록 버튼 */
        function registerCode(upCd) {
            // 1. modifyCdArea1, modifyCdArea2 활성화
            $("#modifyCdArea1 input").prop("disabled", false);
            $("#modifyCdArea2 input").prop("disabled", false);

            // 2. 입력 필드 초기화
            $("#modifyCdArea1 #cmmnCdId").val("");
            $("#modifyCdArea1 #cd").val("");
            $("#modifyCdArea2 #cdnm").val("");
            $("#modifyCdArea2 #cdSeqno").val("");

            // 3. 사용여부 체크박스 초기화 (Y로 설정)
            $("#modifyCdArea1 #useyn").prop("checked", true);

            // 4. 버튼 상태 변경
            $("#cdSaveBtn").prop("disabled", false);
            $("#cdCancleBtn").prop("disabled", false);

            // 5. 분류 코드(upCd) 설정
            $("#modifyCdArea1 #upCd").val(upCd);

            // 6. 해당 분류코드의 공통코드 목록 조회 (ajax 실행)
            listCdPaging(1, upCd);

            // 7. 등록 모드로 설정
            isInsert = true;

            // 8. 코드 입력란에 포커스
            $("#modifyCdArea1 #cd").focus();
        }

        /* 분류 코드 수정 버튼 */
        function editUpCd(cmmnCdId, cd, cdnm) {
            // 등록 중인지 확인 (입력된 내용이 있는지 체크)
            if (isInsert) {
                var hasContent = $("#updtUpCd").val() || $("#upCdnm").val();
                console.log("isInsert ? : " + isInsert);
                if (hasContent) {
                    UiComm.showMessage("작성중인 내용이 있습니다.\n등록을 중단하고 수정하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            // 확인 선택 시 수정 진행
                            executeEditUpCd(cmmnCdId, cd, cdnm);
                        }
                    });
                    return;
                }
            }

            executeEditUpCd(cmmnCdId, cd, cdnm);
        }

        /* 분류 코드 수정 실행 */
        function executeEditUpCd(cmmnCdId, cd, cdnm) {
            // 1. modifyUpCdArea의 모든 input 활성화
            $("#modifyUpCdArea input").prop("disabled", false);

            // 2. modifyUpCdArea의 input 내용을 전부 지움
            $("#modifyUpCdArea input").val("");

            // 3. 공통코드 ID 입력
            $("#upCmmnCdId").val(cmmnCdId);

            // 4. 분류 코드 입력
            $("#updtUpCd").val(cd);
            $("#upCd").val(cd);

            // 5. 분류 코드명 입력
            $("#upCdnm").val(cdnm);

            // 6. 버튼 상태 변경
            $("#upCdInsertBtn").addClass("hidden");
            $("#upCdSaveBtn").removeClass("hidden");
            $("#upCdCancleBtn").prop("disabled", false);

            // 7. isInsert = false로 변경
            isInsert = false;
        }

        /* 공통코드분류 저장 (등록/수정) */
        function saveUpCd() {
            // 입력값 가져오기
            var updtUpCd = $("#updtUpCd").val();
            var upCd = $("#upCd").val();
            var upCdnm = $("#upCdnm").val();

            // 유효성 검사
            if (!updtUpCd) {
                UiComm.showMessage("분류 코드를 입력해주세요.", "warning");
                $("#updtUpCd").focus();
                return;
            }
            if (!upCdnm) {
                UiComm.showMessage("분류 코드명을 입력해주세요.", "warning");
                $("#upCdnm").focus();
                return;
            }

            // 등록/수정 확인 메시지
            var confirmMsg = isInsert ? "등록하시겠습니까?" : "수정하시겠습니까?";
            UiComm.showMessage(confirmMsg, "confirm")
            .then(function(result) {
                if (result) {
                    // URL 및 파라미터 설정
                    var url = isInsert ? upCdInsertURL : upCdUpdateURL;
                    var param;

                    if (isInsert) {
                        // 등록
                        param = {
                            upCd: updtUpCd,
                            upCdnm: upCdnm
                        };
                    } else {
                        // 수정
                        var upCmmnCdId = $("#upCmmnCdId").val();
                        param = {
                            updtUpCd: updtUpCd,
                            upCd: upCd,
                            upCdnm: upCdnm,
                            cmmnCdId: upCmmnCdId
                        };
                    }

                    // 로딩 표시
                    UiComm.showLoading(true);

                    $.ajax({
                        url: url,
                        type: "POST",
                        data: param,
                        dataType: "json",
                        success: function(data) {
                            if (data.result > 0) {
                                var successMsg = isInsert ? "등록되었습니다." : "수정되었습니다.";
                                UiComm.showMessage(successMsg, "success")
                                .then(function() {
                                    // 초기화 및 목록 새로고침
                                    resetmodifyUpCdArea();
                                    listUpCdPaging(PAGE_INDEX);
                                });
                            } else {
                                UiComm.showMessage(data.message || "처리 중 오류가 발생했습니다.", "error");
                            }
                        },
                        error: function(xhr, status, error) {
                            UiComm.showMessage("에러가 발생했습니다!", "error");
                        },
                        complete: function() {
                            // 로딩 닫기
                            UiComm.showLoading(false);
                        }
                    });
                }
            });
        }

        /* 분류 코드 삭제 버튼 */
        function deleteUpCd(upCd) {
            UiComm.showMessage("삭제하시겠습니까?", "confirm")
            .then(function(result) {
                if (result) {
                    // 로딩 표시
                    UiComm.showLoading(true);

                    $.ajax({
                        url: upCdDeleteURL,
                        type: "POST",
                        data: { upCd: upCd },
                        dataType: "json",
                        success: function(data) {
                            if (data.result > 0) {
                                UiComm.showMessage("삭제되었습니다.", "success")
                                .then(function() {
                                    // 공통코드분류 등록/수정 영역 초기화
                                    resetmodifyUpCdArea();
                                    // 공통코드 등록/수정 영역 초기화
                                    resetmodifyCdArea();
                                    // 공통코드 목록 테이블 비우기
                                    cmmnCdListTable.clearData();
                                    // 분류코드 목록 새로고침
                                    listUpCdPaging(PAGE_INDEX);
                                });
                            } else {
                                UiComm.showMessage(data.message || "삭제 중 오류가 발생했습니다.", "error");
                            }
                        },
                        error: function(xhr, status, error) {
                            UiComm.showMessage("에러가 발생했습니다!", "error");
                        },
                        complete: function() {
                            // 로딩 닫기
                            UiComm.showLoading(false);
                        }
                    });
                }
            });
        }

        /* 등록 영역 활성화 */
        function activatemodifyUpCdArea() {
            // modifyUpCdArea의 모든 input 활성화
            $("#modifyUpCdArea input").prop("disabled", false);

            // 버튼 상태 변경
            $("#upCdInsertBtn").addClass("hidden");
            $("#upCdSaveBtn").removeClass("hidden");
            $("#upCdCancleBtn").prop("disabled", false);

            // 등록 모드로 설정
            isInsert = true;

            // updtUpCd에 포커스
            $("#updtUpCd").focus();
            console.log("isInsert ? : " + isInsert);
        }

        /* 등록 / 수정 영역 초기화 */
        function resetmodifyUpCdArea() {
            // 모든 input 값 지우기
            $("#modifyUpCdArea input").val("");

            // 모든 input 비활성화
            $("#modifyUpCdArea input").prop("disabled", true);

            // 버튼 상태 원래대로
            $("#upCdInsertBtn").removeClass("hidden");
            $("#upCdSaveBtn").addClass("hidden");
            $("#upCdCancleBtn").prop("disabled", true);

            isInsert = true;
        }

        /******************
         * 공통코드
         ******************/
        /* 공통코드: 목록 조회(페이징) */
        function listCdPaging(pageIndex, upCd) {
            PAGE_INDEX = pageIndex;
            var cdnm = $("#searchCdnm").val();

            var url = "/sys/mgr/sysCmmnCdPaging.do";
            var param = {
                pageIndex: pageIndex,
                listScale: LIST_SCALE,
                cdnm: cdnm,
                upCd: upCd
            };

            // 로딩 표시
            UiComm.showLoading(true);

            $.ajax({
                url: url,
                type: "GET",
                data: param,
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        let returnList = data.returnList || [];
                        let dataList = createCdListData(returnList, data.pageInfo);

                        cmmnCdListTable.clearData();
                        cmmnCdListTable.replaceData(dataList);
                        cmmnCdListTable.setPageInfo(data.pageInfo);

                        // 스위치 초기화 (동적으로 추가된 체크박스를 ui-switcher로 변환)
                        initTableSwitcher();
                    } else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("에러가 발생했습니다!");
                },
                complete: function() {
                    // 로딩 닫기
                    UiComm.showLoading(false);
                }
            });
        }

        /* 공통코드: 테이블 데이터 생성 */
        function createCdListData(list, pageInfo) {
            let dataList = [];

            if(list.length == 0) {
                return dataList;
            }

            list.forEach(function(v, i) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

                // 관리 버튼 HTML 생성
                var manageButtons = '<button type="button" class="btn small" onclick="editCd(\'' + v.cmmnCdId + '\', \'' + v.upCd + '\', \'' + v.cd + '\', \'' + v.cdnm + '\', \'' + v.cdSeqno + '\', \'' + v.useyn + '\')">수정</button> ' +
                                   '<button type="button" class="btn small" onclick="deleteCd(\'' + v.cmmnCdId + '\', \'' + v.upCd + '\')">삭제</button>';

                // 사용여부 체크박스 생성 (읽기 전용)
                var useyinCheckbox = '<input type="checkbox" value="' + v.useyn + '" class="switch"' +
                                    (v.useyn === 'Y' ? ' checked="checked"' : '') +
                                    ' disabled>';

                dataList.push({
                    no: lineNo,
                    upCdnm: v.upCdnm,
                    cd: v.cd,
                    cdnm: v.cdnm,
                    cdSeqno: v.cdSeqno,
                    useyn: useyinCheckbox,
                    manage: manageButtons,
                    upCd: v.upCd,  // hidden 컬럼
                    cmmnCdId: v.cmmnCdId  // hidden 컬럼
                });
            });

            return dataList;
        }

        /******************
         * 공통코드 함수 (Button, onChange 등...)
         ******************/
        /* 코드 수정 버튼 */
        function editCd(cmmnCdId, upCd, cd, cdnm, cdSeqno, useyn) {
            // 등록 중인지 확인 (입력된 내용이 있는지 체크)
            console.log("isInsert ? : " + isInsert);
            if (isInsert && $("#cdSaveBtn").prop("disabled") === false) {
                var hasContent = $("#modifyCdArea1 #cd").val() || $("#modifyCdArea2 #cdnm").val() || $("#modifyCdArea2 #cdSeqno").val();
                if (hasContent) {
                    UiComm.showMessage("작성중인 내용이 있습니다.\n등록을 중단하고 수정하시겠습니까?", "confirm")
                    .then(function(result) {
                        if (result) {
                            // 확인 선택 시 수정 진행
                            executeEditCd(cmmnCdId, upCd, cd, cdnm, cdSeqno, useyn);
                        }
                    });
                    return;
                }
            }

            executeEditCd(cmmnCdId, upCd, cd, cdnm, cdSeqno, useyn);
        }

        /* 코드 수정 실행 */
        function executeEditCd(cmmnCdId, upCd, cd, cdnm, cdSeqno, useyn) {
            // 1. modifyCdArea1, modifyCdArea2 활성화
            $("#modifyCdArea1 input").prop("disabled", false);
            $("#modifyCdArea2 input").prop("disabled", false);

            // 2. 값 세팅
            $("#modifyCdArea1 #cmmnCdId").val(cmmnCdId);
            $("#modifyCdArea1 #upCd").val(upCd);
            $("#modifyCdArea1 #cd").val(cd);
            $("#modifyCdArea2 #cdnm").val(cdnm);
            $("#modifyCdArea2 #cdSeqno").val(cdSeqno);

            // 3. 사용여부 체크박스 설정
            if (useyn === 'Y') {
                $.switcherOn("useyn");
            } else {
                $.switcherOff("useyn");
            }

            // 4. 버튼 상태 변경
            $("#cdSaveBtn").prop("disabled", false);
            $("#cdCancleBtn").prop("disabled", false);

            // 5. isInsert = false로 변경
            isInsert = false;

            // 6. 코드 입력란에 포커스
            $("#modifyCdArea1 #cd").focus();
        }

        /* 공통코드 저장 (등록/수정) */
        function saveCd() {
            // 입력값 가져오기
            var cmmnCdId = $("#modifyCdArea1 #cmmnCdId").val();
            var upCd = $("#modifyCdArea1 #upCd").val();
            var cd = $("#modifyCdArea1 #cd").val();
            var cdnm = $("#modifyCdArea2 #cdnm").val();
            var cdSeqno = $("#modifyCdArea2 #cdSeqno").val();
            var useyn = $("#modifyCdArea1 #useyn").is(":checked") ? "Y" : "N";

            // 유효성 검사
            if (!upCd) {
                UiComm.showMessage("분류 코드를 선택해주세요.", "warning");
                return;
            }
            if (!cd) {
                UiComm.showMessage("코드를 입력해주세요.", "warning");
                $("#modifyCdArea1 #cd").focus();
                return;
            }
            if (!cdnm) {
                UiComm.showMessage("코드명을 입력해주세요.", "warning");
                $("#modifyCdArea2 #cdnm").focus();
                return;
            }

            // 등록/수정 확인 메시지
            var confirmMsg = isInsert ? "등록하시겠습니까?" : "수정하시겠습니까?";
            UiComm.showMessage(confirmMsg, "confirm")
            .then(function(result) {
                if (result) {
                    // URL 및 파라미터 설정
                    var url = isInsert ? cdInsertURL : cdUpdateURL;
                    var param = {
                        upCd: upCd,
                        cd: cd,
                        cdnm: cdnm,
                        cdSeqno: cdSeqno || 0,
                        useyn: useyn
                    };

                    // 수정일 경우 코드 ID 추가
                    if (!isInsert) {
                        param.cmmnCdId = cmmnCdId;
                    }

                    // 로딩 표시
                    UiComm.showLoading(true);

                    $.ajax({
                        url: url,
                        type: "POST",
                        data: param,
                        dataType: "json",
                        success: function(data) {
                            if (data.result > 0) {
                                var successMsg = isInsert ? "등록되었습니다." : "수정되었습니다.";
                                UiComm.showMessage(successMsg, "success")
                                .then(function() {
                                    // 초기화 및 목록 새로고침
                                    resetmodifyCdArea();
                                    listCdPaging(PAGE_INDEX, upCd);
                                });
                            } else {
                                UiComm.showMessage(data.message || "처리 중 오류가 발생했습니다.", "error");
                            }
                        },
                        error: function(xhr, status, error) {
                            UiComm.showMessage("에러가 발생했습니다!", "error");
                        },
                        complete: function() {
                            // 로딩 닫기
                            UiComm.showLoading(false);
                        }
                    });
                }
            });
        }

        /* 코드 삭제 버튼 */
        function deleteCd(cmmnCdId, upCd) {
            UiComm.showMessage("삭제하시겠습니까?", "confirm")
            .then(function(result) {
                if (result) {
                    // 로딩 표시
                    UiComm.showLoading(true);

                    $.ajax({
                        url: cdDeleteURL,
                        type: "POST",
                        data: { cmmnCdId: cmmnCdId },
                        dataType: "json",
                        success: function(data) {
                            if (data.result > 0) {
                                UiComm.showMessage("삭제되었습니다.", "success")
                                .then(function() {
                                    // 공통코드 등록/수정 영역 초기화
                                    resetmodifyCdArea();
                                    // 목록 새로고침
                                    listCdPaging(PAGE_INDEX, upCd);
                                });
                            } else {
                                UiComm.showMessage(data.message || "삭제 중 오류가 발생했습니다.", "error");
                            }
                        },
                        error: function(xhr, status, error) {
                            UiComm.showMessage("에러가 발생했습니다!", "error");
                        },
                        complete: function() {
                            // 로딩 닫기
                            UiComm.showLoading(false);
                        }
                    });
                }
            });
        }

        /* 공통코드 등록/수정 영역 초기화 */
        function resetmodifyCdArea() {
            // 모든 input 값 지우기
            $("#modifyCdArea1 input").val("");
            $("#modifyCdArea2 input").val("");

            // 모든 input 비활성화
            $("#modifyCdArea1 input").prop("disabled", true);
            $("#modifyCdArea2 input").prop("disabled", true);

            // 사용여부 체크박스 초기화 (Y로 설정)
            $.switcherOn("useyn");

            // 버튼 상태 원래대로
            $("#cdSaveBtn").prop("disabled", true);
            $("#cdCancleBtn").prop("disabled", true);

            // 등록 모드로 재설정
            isInsert = true;
        }

        /******************
         * 기타 함수
         ******************/
        /* 스위치 초기화 (재귀적 확인) */
        function initTableSwitcher() {
            // 아직 switcher로 변환되지 않은 체크박스만 선택 (:visible = display:none이 아닌 것)
            var upCdswitches = $('#cmmnUpCdList .switch:visible');
            var cdswitches = $('#cmmnCdList .switch:visible');

            var needsRetry = false;

            // cmmnUpCdList 스위치 초기화
            if (upCdswitches.length > 0) {
                $.switcher(upCdswitches);
            } else if ($('#cmmnUpCdList').length > 0) {
                needsRetry = true;
            }

            // cmmnCdList 스위치 초기화
            if (cdswitches.length > 0) {
                $.switcher(cdswitches);
            } else if ($('#cmmnCdList').length > 0) {
                needsRetry = true;
            }

            // 둘 중 하나라도 아직 준비되지 않았으면 재시도
            if (needsRetry) {
                requestAnimationFrame(initTableSwitcher);
            }
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">

    <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
    <form id="moveForm" method="post"></form>

    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
    <!-- //common header -->
    
    <main class="common">
        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
        <!-- //gnb -->
         
        <div id="content" class="content-wrap common">

            <!-- 상단(주차/기간): 공통 규격 유지 -->
            <div class="admin_sub_top">
                <div class="date_info">
                    <i class="icon-svg-calendar" aria-hidden="true"></i>
                    <c:choose>
                        <c:when test="${not empty weekInfo}">
                            ${weekInfo}
                        </c:when>
                        <c:otherwise>
                            2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="admin_sub">
                <div class="sub-content">
                    <!-- 상단 Title -->
                    <div class="page-info">
                        <h2 class="page-title">공통코드관리</h2>
                    </div>   
                    <!-- 공통코드 분류코드 등록 / 삭제 영역 -->
                    <div class="search-typeB">
                        <div class="board_top">
                            <h3>공통코드분류 등록 / 수정</h3>
                        </div>
                        <div class = "item" id = "modifyUpCdArea">
                            <span class = "item_tit">
                                <label for = "searchUpCdInfo" class = "req">분류 코드</label>
                            </span>
                            <div class = "itemList">
                                <!-- Update 용 코드 영역 -->
                                <input class = "form-control wide" type = "text" id = "updtUpCd" placeholder = "분류 코드" disabled>
                                <!-- 기존 코드를 저장하는 영역 -->
                                <input class = "form-control wide hidden" type = "text" id = "upCd" placeholder = "분류 코드" disabled>
                                <input class = "form-control wide hidden" type = "text" id = "upCmmnCdId" placeholder = "공통 코드 ID" disabled>
                            </div> 
                            <span class = "item_tit">
                                <label for = "searchUpCdInfo" class = "req">분류 명</label>
                            </span>
                            <div class = "itemList">
                                <input class = "form-control wide" type = "text" id = "upCdnm" placeholder = "분류 코드명" disabled>
                            </div> 
                        </div>
                        <div class="button-area">                            
                            <button type = "button" id = "upCdInsertBtn" class="btn type2">등록</button>
                            <button type = "button" id = "upCdSaveBtn" class="btn type1 hidden">저장</button>
                            <button type = "button" id = "upCdCancleBtn" class="btn basic" disabled>취소</button>
                        </div>
                    </div>

                    <!-- 공통코드 분류코드 List 영역 -->
                    <div id="cmmnUpCdListArea">
                        <div class="board_top">
                            <h3 class="board-title">공통코드 분류</h3>
                        </div>
                        <!-- 공통코드 분류코드 검색 영역 -->
                        <div class = "item">                            
                            <div class = "form-inline">
                                <input class = "form-control" type = "text" id = "searchUpCdnm" placeholder = "분류 코드명">
                                <button type="button" id = "searchUpCdnmBtn" class="btn search">검색</button>
                            </div> 
                        </div>
                        <!-- 공통코드 분류코드 목록 (tabulator) -->
                        <div id = "cmmnUpCdList"></div>

                        <script>
                        // 공통코드분류 리스트 테이블
                        let cmmnUpCdListTable = UiTable("cmmnUpCdList", {
                            lang: "ko",
                            selectRow: 1,
                            selectRowFunc: onUpCdRowClick,
                            pageFunc: listUpCdPaging,
                            columns: [
                                {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:50, minWidth:80},
                                {title:"분류 코드명", field:"cdnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200},
                                {title:"분류 코드", field:"cd", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:150},
                                {title:"관리", field:"manageUp", headerHozAlign:"center", hozAlign:"center", width:250, minWidth:250},
                                {title:"", field:"cmmnCdId", visible:false}
                            ]
                        });
                        </script>
                    </div>
                        <div class="page-info">
                            <h2 class="page-title"> </h2>
                        </div> 
                    <!-- 공통코드 등록 / 삭제 영역 -->
                    <div class="search-typeB">                         
                        <div class="board_top">
                            <h3>공통코드 등록 / 수정</h3>
                        </div>
                        <div class = "item" id = "modifyCdArea1">
                            <span class = "item_tit">
                                <label for = "searchUpCdInfo" class = "req">코드</label>
                            </span>
                            <div class = "itemList">
                                <!-- 상위 코드 영역 -->
                                <input class = "form-control hidden" type = "text" id = "upCd" placeholder = "분류 코드" disabled>
                                <!-- 코드 ID 영역 -->
                                <input class = "form-control hidden" type = "text" id = "cmmnCdId" placeholder = "코드 ID" disabled>
                                <!-- 코드 영역 -->
                                <input class = "form-control " type = "text" id = "cd" placeholder = "코드" disabled>
                            </div> 
                            <span class = "item_tit">
                                <label for = "searchUpCdInfo" class = "req">사용 여부</label>
                            </span>
                            <div class = "itemList">
                                <input type="checkbox" id = "useyn" value="Y" class="switch" checked="checked">
                            </div> 
                        </div>
                        <div class = "item" id = "modifyCdArea2"> 
                            <span class = "item_tit">
                                <label for = "searchUpCdInfo" class = "req">코드명</label>
                            </span>
                            <div class = "itemList">
                                <input class = "form-control" type = "text" id = "cdnm" placeholder = "코드명" disabled>
                            </div> 
                            <span class = "item_tit">
                                <label for = "searchUpCdInfo">코드 순서</label>
                            </span>
                            <div class = "itemList">
                                <!-- 코드 ID 영역 -->
                                <input class = "form-control" type = "text" id = "cdSeqno" inputmask = "numeric" placeholder = "코드 순서" maxVal = "999" disabled>		
                            </div> 
                        </div>
                        <div class="button-area">                            
                            <button type = "button" id = "cdSaveBtn" class="btn type1" disabled>저장</button>
                            <button type = "button" id = "cdCancleBtn" class="btn basic" disabled>취소</button>
                        </div>
                    </div>

                    <!-- 공통코드 List 영역 -->
                    <div id="cmmnCdListArea">
                        <div class="board_top">
                            <h3 class="board-title">공통코드</h3>
                        </div>
                        <!-- 공통코드 검색 영역 -->
                        <div class = "item">                            
                            <div class = "form-inline">
                                <input class = "form-control" type = "text" id = "searchCdnm" placeholder = "분류 코드명">
                                <button type="button" id = "searchCdnmBtn" class="btn search">검색</button>
                            </div> 
                        </div>
                        <!-- 공통코드 목록 (tabulator) -->
                        <div id = "cmmnCdList"></div>

                        <script>
                        // 공통코드 리스트 테이블
                        let cmmnCdListTable = UiTable("cmmnCdList", {
                            lang: "ko",
                            pageFunc: function(pageIndex) {
                                var upCd = $("#modifyCdArea1 #upCd").val();
                                if (upCd) {
                                    listCdPaging(pageIndex, upCd);
                                }
                            },
                            columns: [
                                {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:50, minWidth:50},
                                {title:"분류명", field:"upCdnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:150},
                                {title:"코드", field:"cd", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:100},
                                {title:"코드명", field:"cdnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:150},
                                {title:"순서", field:"cdSeqno", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                                {title:"사용여부", field:"useyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                                {title:"관리", field:"manage", headerHozAlign:"center", hozAlign:"center", width:180, minWidth:180},
                                {title:"", field:"upCd", visible:false},
                                {title:"", field:"cmmnCdId", visible:false}
                            ]
                        });
                        </script>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>
</body>
</html>
