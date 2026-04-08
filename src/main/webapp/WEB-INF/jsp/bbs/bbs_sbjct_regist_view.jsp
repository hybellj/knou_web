<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<style>
    /* 에디터 박스보다 위에 오도록 설정 */
    .editor-box {
        position: relative;
        z-index: 1; /* 에디터는 낮게 */
    }
</style>

<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="${templateUrl eq 'bbsHome' ? 'dashboard' : templateUrl eq 'bbsLect' ? 'classroom' : templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>
    <%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>

    <script type="text/javascript">
        /* 전역 설정 */
        var PAGE_INDEX      = '<c:out value="${bbsVO.pageIndex}" />';
        var LIST_SCALE      = '<c:out value="${bbsVO.listScale}" />';
        var BBS_ID          = '<c:out value="${bbsAtclVO.bbsId}" />';
        var ATCL_ID         = '<c:out value="${bbsAtclVO.atclId}" />';
        var ATCL_OPTN_ID    = '<c:out value="${bbsAtclVO.atclOptnId}" />';
        var TEMPLATE_URL    = '<c:out value="${templateUrl}" />';
        var EPARAM          = '<c:out value="${encParams}" />';
        var MODE            = '<c:out value="${mode}" />';

        var editor;         // 에디터 객체
        var atclListTable;  // 테이블 객체

        $(document).ready(function() {

        	if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

            // 1. UI 컴포넌트 초기화
            editor = UiEditor({
                targetId: "atclCts",
                uploadPath: "/bbs",
                height: "500px"
            });

            atclListTable = UiTable("bbsAtclGrpNtcList", {
                lang: "ko",
                pageFunc: listPaging,
                columns: [
                    {title:"No", field:"no", hozAlign:"center", width:40},
                    {title:"<spring:message code='bbs.label.dept'/>", field:"deptnm", hozAlign:"center", width:100},
                    {title:"<spring:message code='user.title.userinfo.manage.userrprsid'/>", field:"userRprsId", hozAlign:"left", minWidth:100},
                    {title:"<spring:message code='std.label.user_id'/>", field:"userId", hozAlign:"center", width:100},
                    {title:"<spring:message code='user.title.userinfo.manage.usernm'/>", field:"userNm", hozAlign:"center", width:100},
                    {title:"<spring:message code='sys.label.manage'/>", field:"mng", hozAlign:"center", width:60},
                ]
            });

            if(MODE == 'U') {
                bbsAtclModifyForm();
            }
            listPaging(1);

            $('input[name="grpNtcGbncd"]').on('change', function() {
                toggleGrpNtcList();
            });

            $(document).on("click", ".labelRemove", function() {
                $(this).closest("li").remove();
            });
        });

        function toggleGrpNtcList() {
            var selectedValue = $('input[name="grpNtcGbncd"]:checked').val();
            if (selectedValue === 'Y') { $('#bbsAtclGrpNtc').show(); }
            else { $('#bbsAtclGrpNtc').hide(); }
        }

        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;
            var extData = { pageIndex: pageIndex, listScale: LIST_SCALE, bbsId: BBS_ID, atclId: ATCL_ID };
            var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclGrpNtcList.do";
            var data = { encParams: EPARAM, addParams: UiComm.makeEncParams(extData) };

            ajaxCall(url, data, function(data) {
                if (data.encParams != null && data.encParams != '') { EPARAM = data.encParams; }
                if (data.result > 0) {
                    var dataList = createAtclListHTML(data.returnList || [], data.pageInfo);

                    atclListTable.clearData();
                    atclListTable.replaceData(dataList);
                    atclListTable.setPageInfo(data.pageInfo);
                    $('#bbsAtclGrpNtc').hide();
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error");
                }
            });
        }

        function createAtclListHTML(atclList, pageInfo) {
            var dataList = [];
            atclList.forEach(function(v, i) {
                dataList.push({
                    no: i + 1,
                    deptnm: v.deptnm,
                    userId: v.userId,
                    userRprsId: v.userRprsId,
                    userNm: v.userNm,
                    mng: v.mng,
                    valAtclId: v.atclId
                });
            });
            return dataList;
        }

        function bbsAtclModifyForm() {
            var url  = "/bbs/" + TEMPLATE_URL + "/bbsAtclSbjctDtlView.do";
            var data = { bbsId : BBS_ID, atclId : ATCL_ID };

            ajaxCall(url, data, function(data) {
                if(data.result > 0 && data.returnVO) {
                    var vo = data.returnVO;

                    $("#orgId").val(vo.orgId);
                    $("#deptId").val(vo.deptId);
                    $("#sbjctId").val(vo.sbjctId);

                    $("#orgId").trigger("chosen:updated");
                    $("#deptId").trigger("chosen:updated");
                    $("#sbjctId").trigger("chosen:updated");

                    // 주요 옵션
                    if(vo.optnCd === 'IMPT') {
						$("#optnCdI").prop("checked", true);
					} else if(vo.optnCd === 'FIX') {
						$("#optnCdF").prop("checked", true);
					} else {
						$("#optnCdN").prop("checked", true);
					}

					// 주요 옵션 일자
                    setSplitDateTime(vo.optnSdttm, 'optnStartDate', 'optnStartTime');
                    setSplitDateTime(vo.optnEdttm, 'optnEndDate', 'optnEndTime');

                    // 제목
                    $("#atclTtl").val(vo.atclTtl);

                    // 내용
                    editor.openHTML(vo.atclCts);

                    if(vo.fileList && vo.fileList.length > 0) {
                        setTimeout(function(){
                            var dx = dx5.get("fileUploader");
                            dx.addCopyFiles(vo.fileList);
                        }, 500);
                    }

					// 분반 일괄등록
					var i = vo.dvclasNo;
					$("#dvclasNo"+i).prop("checked", true);

					// 부가옵션 - 댓글 사용
                    if(vo.cmntPrmyn === "Y") {
						$("#cmntPrmyn").prop("checked", true);
                    }

					// 등록 예약
                    if(vo.rsrvyn === "Y") {
					    $("#rsrvyn").prop("checked", true);
					    $("#sw_rsrvyn").attr("aria-checked", "true").addClass("ui-switcher-on");
					}

					// 등록 예약 일자
                    setSplitDateTime(vo.rsrvSdttm, 'rsrvStartDate', 'rsrvStartTime');
                    setSplitDateTime(vo.rsrvEdttm, 'rsrvEndDate', 'rsrvEndTime');

                    // 공개여부
                    if(vo.oyn === "Y") {
						$("#oyn").prop("checked", true);
						$("#sw_oyn").attr("aria-checked", "true").trigger("change");
					}

                    // 공지사항 구분
                    if(vo.ntcGbncd === "Y") {
						$("#ntcGbncdY").prop("checked", true);
                    } else {
                    	$("#ntcGbncdN").prop("checked", true);
                    }

                    // 자동 알림 예약 등록
                    if(vo.autoAlimyn === "Y") {
						$("#autoAlimyn").prop("checked", true);
						$("#sw_autoAlimyn").attr("aria-checked", "true").trigger("change");
					}

                    // 자동 알림 예약 등록 일자
                    setSplitDateTime(vo.autoAlimSdttm, 'autoAlimStartDate', 'autoAlimStartTime');
                    setSplitDateTime(vo.autoAlimEdttm, 'autoAlimEndDate', 'autoAlimEndTime');
                }
            });
        }

        function setSplitDateTime(fullStr, dateInputId, timeInputId) {
            if (!fullStr || fullStr.length !== 14) return;
            if (dateInputId) document.getElementById(dateInputId).value = fullStr.substring(0, 8);
            if (timeInputId) document.getElementById(timeInputId).value = fullStr.substring(8, 14);
        }

        function saveConfirm() {
            UiValidator("bbsAtclSbjctWriteForm").then(function(result) {
                if (result) {
                    var dx = dx5.get("fileUploader");
                    if (dx.availUpload()) {
						dx.startUpload();
					}
                    else {
						bbsAtclSbjctRegist();
					}
                }
            });
        }

        function finishUpload() {
            var dx = dx5.get("fileUploader");
            var data = {
				"uploadFiles" : dx.getUploadFiles()
				, "uploadPath"  : dx.getUploadPath()
			};
            ajaxCall("/common/uploadFileCheck.do", data, function(data) {
                if(data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    bbsAtclSbjctRegist();
                }
            });
        }

        function bbsAtclSbjctRegist() {

            // VO 필드명에 맞춰 가공된 값 세팅
            $("#optnSdttm").val(makeDateTimeStr("optnStartDate", "optnStartTime"));
            $("#optnEdttm").val(makeDateTimeStr("optnEndDate", "optnEndTime"));
            $("#rsrvSdttm").val(makeDateTimeStr("rsrvStartDate", "rsrvStartTime"));
            $("#rsrvEdttm").val(makeDateTimeStr("rsrvEndDate", "rsrvEndTime"));
            $("#autoAlimSdttm").val(makeDateTimeStr("autoAlimStartDate", "autoAlimStartTime"));
            $("#autoAlimEdttm").val(makeDateTimeStr("autoAlimEndDate", "autoAlimEndTime"));

            var dx = dx5.get("fileUploader");
            $("#delFileIdStr").val(dx.getDelFileIdStr());

            var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclSbjctRegist.do";
            var data = $("#bbsAtclSbjctWriteForm").serialize();
			var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsSbjctListView.do?encParams=${encParams}";

			bbsCommon.regist(url, returnUrl, data);
        }

     	// 날짜+시간을 14자리 문자열로 합쳐주는 헬퍼 함수
        function makeDateTimeStr(dateId, timeId) {
            var dateVal = $("#" + dateId).val() || "";
            var timeVal = $("#" + timeId).val() || "";
            if (dateVal !== "") {
                // 숫자만 남기고 뒤에 "00"(초) 추가
                return (dateVal + timeVal).replace(/[^0-9]/g, "") + "00";
            }
            return "";
        }

        function openModal() {
            UiDialog("dialog2", {
                title: "수강생 추가",
                width: 1000,
                height: 800,
                url: "/bbs/" + TEMPLATE_URL +"/bbsAtclGrpNtcPopView.do"
            });
        }

        function bbsAtclListMove() {
            document.location.href = "/bbs/" + TEMPLATE_URL +"/bbsSbjctListView.do?encParams=${encParams}";
        }
    </script>
</head>

<body class="home colorA ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
        <main class="common">
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>과목공지</span></h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>게시물</li>
                                    <li><span class="current">현재페이지</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <form id="bbsAtclSbjctWriteForm" name="bbsAtclSbjctWriteForm">
                                <input type="hidden" name="bbsId" value="${bbsAtclVO.bbsId}">
                                <input type="hidden" name="bbsTycd" value="${bbsAtclVO.bbsTycd}">
                                <input type="hidden" name="bbsRefTycd" value="SBJCT">
                                <input type="hidden" name="userId" value="${bbsAtclVO.userId}">
                                <input type="hidden" name="atclId" value="${bbsAtclVO.atclId}">
                                <input type="hidden" name="atclOptnId" value="${bbsAtclVO.atclOptnId}">
                                <input type="hidden" name="optnUseyn" value="Y">
                                <input type="hidden" name="delFileIdStr" id="delFileIdStr">
                                <input type="hidden" name="uploadFiles" id="uploadFiles">
                                <input type="hidden" name="uploadPath" id="uploadPath" value="${bbsVO.uploadPath}" />

								<input type="hidden" name="optnSdttm" id="optnSdttm" />
							    <input type="hidden" name="optnEdttm" id="optnEdttm" />
							    <input type="hidden" name="rsrvSdttm" id="rsrvSdttm" />
							    <input type="hidden" name="rsrvEdttm" id="rsrvEdttm" />
							    <input type="hidden" name="autoAlimSdttm" id="autoAlimSdttm" />
							    <input type="hidden" name="autoAlimEdttm" id="autoAlimEdttm" />

                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><label for="univ_label" class="req">운영과목</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <select class="form-select" id="orgId" name="orgId" required="true">
													    <option value=""><spring:message code="bbs.label.org" /></option>
													    <c:forEach var="list" items="${filterOptions.orgList}">
													        <option value="${list.orgId}">
													            ${list.orgnm}
													        </option>
													    </c:forEach>
													</select>

													<select class="form-select" id="deptId" name="deptId" required="true">
													    <option value=""><spring:message code="bbs.label.dept" /></option>
													    <c:forEach var="list" items="${filterOptions.deptList}">
													        <option value="${list.deptId}">
													            ${list.deptnm}
													        </option>
													    </c:forEach>
													</select>

													<select class="form-select" id="sbjctId" name="sbjctId" required="true">
													    <option value=""><spring:message code="bbs.label.sbjct" /></option>
													    <c:forEach var="list" items="${filterOptions.sbjctList}">
													        <option value="${list.sbjctId}">
													            ${list.sbjctnm}
													        </option>
													    </c:forEach>
													</select>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="haksa_label"><spring:message code="bbs.label.form_main_option"/></label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input"><input type="radio" name="optnCd" id="optnCdN" value="N" checked><label for="optnCdN"><spring:message code="bbs.label.na"/></label></span>
                                                    <span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdI" value="I"><label for="optnCdI"><spring:message code="bbs.label.impt"/></label></span>
                                                    <span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdF" value="F"><label for="optnCdF"><spring:message code="bbs.label.fix"/></label></span>
                                                    <input type="text" placeholder="시작일" id="optnStartDate" name="optnStartDate" class="datepicker">
                                                    <input type="text" placeholder="시작시간" id="optnStartTime" name="optnStartTime" class="timepicker">
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" placeholder="종료일" id="optnEndDate" name="optnEndDate" class="datepicker">
                                                    <input type="text" placeholder="종료시간" id="optnEndTime" name="optnEndTime" class="timepicker">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label for="atclTtl" class="req"><spring:message code="bbs.label.form_title"/></label></th>
                                            <td><div class="form-row"><input class="form-control width-100per" type="text" name="atclTtl" id="atclTtl" value="" required="true"></div></td>
                                        </tr>
                                        <tr>
                                            <th><label for="atclCts" class="req"><spring:message code="bbs.label.form_cts"/></label></th>
                                            <td>
                                                <div class="editor-box">
                                                    <textarea id="atclCts" name="atclCts" required="true"></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_decls"/></label></th>
                                            <td>
                                                <div class="checkbox_type">
                                                    <span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNoA" value="Y" required="true"><label for="dvclasNoA">전체</label></span>
                                                    <c:forEach var="i" begin="1" end="4">
                                                        <span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNo${i}" value="${i}" required="true"><label for="dvclasNo${i}">${i}반</label></span>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
											<th><label for="attchFile"><spring:message code="bbs.label.form_attach_file" /></label></th>
											<td>
												<uiex:dextuploader
													id="fileUploader"
													path="${bbsVO.uploadPath}"
													limitCount="5"
													limitSize="100"
													oneLimitSize="100"
													listSize="3"
													fileList="${bbsAtclVO.fileList}"
													finishFunc="finishUpload()"
													allowedTypes="*"
												/>
											</td>
										</tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_sub_option"/></label></th>
                                            <td><div class="checkbox_type"><span class="custom-input"><input type="checkbox" name="cmntPrmyn" id="cmntPrmyn" value="Y"><label for="cmntPrmyn">댓글 사용</label></span></div></td>
                                        </tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_write_resv"/></label></th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="checkbox" id="rsrvyn" name="rsrvyn" class="switch yesno" value="Y">
                                                    <input type="text" id="rsrvStartDate" name="rsrvStartDate" class="datepicker">
                                                    <input type="text" id="rsrvStartTime" name="rsrvStartTime" class="timepicker">
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" id="rsrvEndDate" name="rsrvEndDate" class="datepicker">
                                                    <input type="text" id="rsrvEndTime" name="rsrvEndTime" class="timepicker">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_public_yn"/></label></th>
                                            <td><div class="form-row"><input type="checkbox" id="oyn" name="oyn" class="switch yesno" value="Y"></div></td>
                                        </tr>
                                        <tr>
                                            <th><label>공지사항 구분</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input"><input type="radio" name="ntcGbncd" id="ntcGbncdY" value="Y" checked><label for="ntcGbncdY">일반 공지</label></span>
                                                    <span class="custom-input ml5"><input type="radio" name="ntcGbncd" id="ntcGbncdN" value="N"><label for="ntcGbncdN">긴급 공지</label></span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_auto_alim"/></label></th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="checkbox" id="autoAlimyn" name="autoAlimyn" class="switch yesno" value="Y">
                                                    <input type="text" id="autoAlimStartDate" name="autoAlimStartDate" class="datepicker">
                                                    <input type="text" id="autoAlimStartTime" name="autoAlimStartTime" class="timepicker">
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" id="autoAlimEndDate" name="autoAlimEndDate" class="datepicker">
                                                    <input type="text" id="autoAlimEndTime" name="autoAlimEndTime" class="timepicker">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label>그룹 공지사항</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input"><input type="radio" name="grpNtcGbncd" id="grpNtcGbncdN" value="N" checked><label for="grpNtcGbncdN">아니오</label></span>
                                                    <span class="custom-input ml5"><input type="radio" name="grpNtcGbncd" id="grpNtcGbncdY" value="Y"><label for="grpNtcGbncdY">예</label></span>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>

						<div id="bbsAtclGrpNtc">
	                        <div class="board_top">
	                            <span>수강생 [ <spring:message code="user.title.total.count" /><!-- 총건수 --> : <span class="fcBlue" id="totStdCnt">0</span>]</span>
	                            <div class="right-area">
	                                <button type="button" class="btn type1" onclick="openModal()">수강생 추가</button>
	                            </div>
	                        </div>
	                        <div id="bbsAtclGrpNtcList"></div>
						</div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick='saveConfirm()'>저장</button>
                            <button type="button" class="btn type2" onclick='bbsAtclListMove()'>목록</button>
                        </div>
                    </div>
                </div>
            </div>
            <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
        </main>
    </div>
</body>
</html>