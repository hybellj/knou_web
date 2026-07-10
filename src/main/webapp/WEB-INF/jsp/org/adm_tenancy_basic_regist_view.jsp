<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table,fileuploader"/>
    </jsp:include>
</head>
<script type="text/javascript">
    const EPARAM = "${encParams}";
    // 파일 업로드 완료
    function finishUpload(uploaderId) {
        let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        let dx = dx5.get(uploaderId);
        let data = {
            "uploadFiles": dx.getUploadFiles(),
            "uploadPath": dx.getUploadPath()
        };

        // 업로드된 파일 체크
        ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());

                    let url = "";
                    <c:choose>
                        <c:when test="${gubun eq 'edit'}">
                        url = "/org/orgMgr/admOrgModify.do";
                        </c:when>
                        <c:otherwise>
                        url = "/org/orgMgr/admOrgRegist.do";
                        </c:otherwise>
                    </c:choose>

                    // 기관 등록 호출
                    orgSave(url);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
                }
            },
            function (xhr, status, error) {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        );
    }
</script>

<body class="admin">
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
                <div class="admin_sub_top">
                    <div class="date_info">
                        <i class="icon-svg-calendar" aria-hidden="true"></i><spring:message code="common.label.org.mgr" /><%--기본 정보 관리--%>
                    </div>
                </div>
                <div class="admin_sub">

                    <div class="sub-content">
                        <form id="orgForm">
                            <input type="hidden" name="uploadFiles"   id="uploadFiles"  value="" />
                            <input type="hidden" name="uploadPath"   id="uploadPath"  value="${uploadPath}" />
                            <input type="hidden" name="delFileIdStr"  id="delFileIdStr" value="" />
                            <input type="hidden" name="encParams"   id="encParams"  value="${encparams}" />
                            <div class="box">
                                <div class="board_top">
                                    <c:choose>
                                        <c:when test="${gubun eq 'edit'}">
                                            <h3 class="board-title"><spring:message code="common.button.modify"/><%--수정--%> </h3>
                                        </c:when>
                                        <c:otherwise>
                                            <h3 class="board-title"><spring:message code="common.button.create"/><%--등록--%> </h3>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!--table-type-->
                                <div class="table-wrap">
                                    <table class="table-type5">
                                        <colgroup>
                                            <col class="width-15per" />
                                            <col class="" />
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th><label for="te_id_label" class="req"><spring:message code='common.label.org.id'/><%--기관 ID--%></label></th>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${gubun eq 'edit'}">
                                                            ${vo.orgId}
                                                            <input class="form-control" type="hidden" id="orgId" name="orgId" value="${vo.orgId}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="form-inline">
                                                            <input class="form-control" type="text" id="orgId" name="orgId" placeholder="기관 ID 입력" required="true" autocomplete="off"/>
                                                            <button type="button" class="btn gray1" onclick="duplicationCheck()">중복확인</button>
                                                            </div>
                                                            <small id="dupCheckRslt" style="display: none;"></small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="te_full_label" class="req"><spring:message code='common.label.org.name.full'/><%--기관 Full Name--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                    <input class="form-control width-50per" type="text" id="orgnm" name="orgnm" placeholder="기관 Full Name 입력" value="${vo.orgnm}" required="true" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="te_short_label" class="req"><spring:message code='common.label.org.name.short'/><%--기관 Short Name--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                    <input class="form-control width-50per" type="text" id="orgShrtnm" name="orgShrtnm" value="${vo.orgShrtnm}" placeholder="기관 Short Name 입력" required="true" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="orgTycd" class="req"><spring:message code='common.label.org.type'/><%--기관 유형--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <select class="form-select" id="orgTycd" name="orgTycd" required="true">
                                                            <option value="">선택</option>
                                                            <c:forEach items="${orgTycdList}" var="item">
                                                            <option value="${item.cd}" <c:if test="${item.cd eq vo.orgTycd}">selected</c:if> >${item.cdnm}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="url_label" class="req"><spring:message code="common.label.org.url.homepage"/> <%--홈페이지 URL--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <c:set var="url" value="http://"/>
                                                        <c:if test="${gubun eq 'edit'}"><c:set var="url" value="${vo.hmpgUrl}"/></c:if>
                                                        <input class="form-control width-100per" type="text" id="hmpgUrl" name="hmpgUrl" required="true" value="${url}" placeholder="">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="name_label" class="req"><spring:message code='common.label.org.chrgr.nm'/><%--담당자명--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <input class="form-control" type="text" id="chrgrnm" name="chrgrnm" value="${vo.chrgrnm}" placeholder="담당자명 입력" required="true" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="mobileLabel" class="req"><spring:message code='common.label.contact.info'/><%--담당자 연락처--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <div class="num_input">
                                                            <input type="hidden" id="chrgrCntct" name="chrgrCntct" value="${vo.chrgrCntct}" required="true">
                                                            <c:if test="${gubun eq 'edit'}">
                                                                <c:set var="chrgrCntctParts" value="${fn:split(vo.chrgrCntct, '-')}"/> <%--'-'기준 쪼개기--%>
                                                                <c:set var="mobile1" value="${chrgrCntctParts[0]}" />
                                                                <c:set var="mobile2" value="${chrgrCntctParts[1]}" />
                                                                <c:set var="mobile3" value="${chrgrCntctParts[2]}" />
                                                            </c:if>
                                                            <c:set var="mobile1" value="${fn:substring(vo.chrgrCntct, 0, 3)}"/>

                                                            <select id="mobile1" class="form-select compact" required="true">
                                                                <option value="010" <c:if test="${mobile1 eq '010'}">selected</c:if>>010</option>
                                                                <option value="011" <c:if test="${mobile1 eq '011'}">selected</c:if>>011</option>
                                                                <option value="016" <c:if test="${mobile1 eq '016'}">selected</c:if>>016</option>
                                                                <option value="017" <c:if test="${mobile1 eq '017'}">selected</c:if>>017</option>
                                                                <option value="018" <c:if test="${mobile1 eq '018'}">selected</c:if>>018</option>
                                                                <option value="019" <c:if test="${mobile1 eq '019'}">selected</c:if>>019</option>
                                                            </select>
                                                            <span class="txt-sort">-</span>
                                                            <input type="text" class="form-control compact" id="mobile2" value="${mobile2}" inputmask="length" maxLen="4" required="true"/>
                                                            <span class="txt-sort">-</span>
                                                            <input type="text" class="form-control compact" id="mobile3" value="${mobile3}" inputmask="length" maxLen="4" required="true"/>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="inputEmail1" class="req"><spring:message code='common.email'/><%--담당자 이메일--%></label></th>
                                                <td>
                                                    <div class="form-inline">
                                                        <input type="hidden" id="chrgrEml" name="chrgrEml" value="${vo.chrgrEml}" required="true">
                                                        <c:set var="emailParts" value="${fn:split(vo.chrgrEml, '@')}"/> <%--'@'기준 앞뒤 쪼개기--%>
                                                        <c:set var="email1" value="${emailParts[0]}"/>
                                                        <c:set var="email2" value="${emailParts[1]}"/>
                                                        <input class="form-control mr5" type="text" id="email1" value="${email1}" required="true">
                                                        <span class="mr5">@</span>
                                                        <input class="form-control mr5" type="text" id="email2" value="${email2}" placeholder="" required="true">
                                                        <select class="form-select" id="selectEmail2" onchange="selectEmail(this)">
                                                            <option value="">직접입력</option>
                                                            <option value="naver.com"<c:if test="${email2 eq 'naver.com'}">selected</c:if>>naver.com</option>
                                                            <option value="daum.net" <c:if test="${email2 eq 'daum.net'}">selected</c:if>>daum.net</option>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="ofcTelno1"><spring:message code="common.label.contact.office"/> <%--사무실 전화번호--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <div class="num_input">
                                                            <input type="hidden" id="ofcTelno" name="ofcTelno" value="${vo.ofcTelno}">
                                                            <%--사무실 번호 세팅--%>
                                                            <c:if test="${gubun eq 'edit'}">
                                                                <c:set var="ofcTelnoParts" value="${fn:split(vo.ofcTelno, '-')}"/> <%--'-'기준 쪼개기--%>
                                                                <c:set var="ofcTelno1" value="${ofcTelnoParts[0]}" />
                                                                <c:set var="ofcTelno2" value="${ofcTelnoParts[1]}" />
                                                                <c:set var="ofcTelno3" value="${ofcTelnoParts[2]}" />
                                                            </c:if>
                                                            <select class="form-select compact" id="ofcTelno1">
                                                                <option value="-">선택</option>
                                                                <option value="02" <c:if test="${ofcTelno1 eq '02'}">selected</c:if>>02</option>
                                                                <option value="031"<c:if test="${ofcTelno1 eq '031'}">selected</c:if>>031</option>
                                                            </select>
                                                            <span class="txt-sort">-</span>
                                                            <input type="text" class="form-control compact" id="ofcTelno2" value="${ofcTelno2}" inputmask="length" maxLen="3"/>
                                                            <span class="txt-sort">-</span>
                                                            <input type="text" class="form-control compact" id="ofcTelno3" value="${ofcTelno3}" inputmask="length" maxLen="4"/>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>
                                                    <label for="attchFile">
                                                        <spring:message code="common.label.org.logo.pc" /><%--기관 로고 PC--%>
                                                        <br/><spring:message code="common.label.org.logo.size" /><%--(로고 이미지: 294 * 41) --%>
                                                    </label>
                                                </th>
                                                <td>

                                                    <!--업로드-->
                                                    <div id="upload">
                                                        <div id="fileUploadBlock" style="width: 100%">
                                                            <uiex:dextuploader
                                                                    id="fileUploader"
                                                                    path="${uploadPath}"
                                                                    limitCount="1"
                                                                    fileList="${vo.fileList}"
                                                                    finishFunc="finishUpload"
                                                                    allowedTypes="jpg,jpeg,png"
                                                            />
                                                        </div>

                                                        <!--파일업로드-->
                                                        <%--<div id="drop">
                                                            파일을 여기에 끌어다 놓거나, 파일 선택 버튼을 클릭하여 업로드하세요.
                                                            <a id="buttonLink" href="javascript:uploderclick('atchuploader');" class="btn type3">파일 선택</a>
                                                            <input type="file" name="atchuploader" id="atchuploader" multiple="" style="display:none">

                                                            <div id="atchprogress" class="progress" style="display: none;">
                                                                <div class="progress-inner"></div>
                                                            </div>

                                                        </div>--%>
                                                        <!--//파일업로드-->

                                                        <!--파일 -->
                                                        <%--<ul id="atchfiles">
                                                            <li id="attachIdx_1">
                                                                <p><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교"></p><span aria-label="삭제" href="#_none"></span>
                                                            </li>
                                                        </ul>--%>
                                                        <!--//파일 -->

                                                    </div>
                                                    <!--//업로드-->

                                                </td>
                                            </tr>
                                            <%--<tr>
                                                <th><label for="attchFile">기관 로고 Mobile</label></th>
                                                <td>

                                                    <!--업로드-->
                                                    <div id="upload">

                                                        <!--파일업로드-->
                                                        <div id="drop">
                                                            파일을 여기에 끌어다 놓거나, 파일 선택 버튼을 클릭하여 업로드하세요.
                                                            <a id="buttonLink" href="javascript:uploderclick('atchuploader');" class="btn type3">파일 선택</a>
                                                            <input type="file" name="atchuploader" id="atchuploader" multiple="" style="display:none">

                                                            <div id="atchprogress" class="progress" style="display: none;">
                                                                <div class="progress-inner"></div>
                                                            </div>
                                                        </div>
                                                        <!--//파일업로드-->

                                                        <!--파일 -->
                                                        <ul id="atchfiles">
                                                            <li id="attachIdx_1">
                                                                <p><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_mobile.png" aria-hidden="true" alt="한국방송통신대학교"></p><span aria-label="삭제" href="#_none"></span>
                                                            </li>
                                                        </ul>
                                                        <!--//파일 -->

                                                    </div>
                                                    <!--//업로드-->

                                                </td>
                                            </tr>--%>
                                        </tbody>
                                    </table>

                                </div>
                                <!--//table-type-->
                            </div>

                            <div class="box">
                                <div class="board_top">
                                    <h3 class="board-title">하단 문구</h3>
                                </div>

                                <!--table-type-->
                                <div class="table-wrap">
                                    <table class="table-type5">
                                        <colgroup>
                                            <col class="width-15per" />
                                            <col class="" />
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th><label for="inputAddress1" class="req"><spring:message code="common.label.post.no" /><%--우편번호--%></label></th>
                                                <td>
                                                    <div class="form-inline mb10">
                                                        <input class="form-control" type="text" name="zipCd" id="zipCd" value="${vo.zipCd}" placeholder="우편번호" required="true">
                                                        <button type="button" class="btn gray1">우편번호 찾기</button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="inputAddress1" class="req"><spring:message code="common.label.address" /><%--주소--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <input class="form-control width-100per" type="text" name="addr1" id="addr1" value="${vo.addr1}" placeholder="주소" required="true">
                                                    </div>
                                                    <div class="form-row">
                                                        <input class="form-control width-100per" type="text" name="addr2" id="addr2" value="${vo.addr2}" placeholder="나머지 주소" required="true">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="telLabel2" class="req"><spring:message code="common.lable.contact.main" /><%--대표전화--%></label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <div class="num_input">
                                                            <input type="hidden" id="rprsTelno" name="rprsTelno" value="${vo.rprsTelno}">
                                                            <c:if test="${gubun eq 'edit'}">
                                                                <c:set var="rprsTelnoParts" value="${fn:split(vo.rprsTelno, '-')}"/> <%--'-'기준 쪼개기--%>
                                                                <c:set var="rprsTelno1" value="${rprsTelnoParts[0]}" />
                                                                <c:set var="rprsTelno2" value="${rprsTelnoParts[1]}" />
                                                                <c:set var="rprsTelno3" value="${rprsTelnoParts[2]}" />
                                                            </c:if>
                                                            <select id="rprsTelno1" class="form-select compact">
                                                                <option value="">선택</option>
                                                                <option value="02" <c:if test="${rprsTelno1 eq '02'}">selected</c:if>>02</option>
                                                                <option value="031"<c:if test="${rprsTelno1 eq '031'}">selected</c:if>>031</option>
                                                            </select>
                                                            <span class="txt-sort">-</span>
                                                            <input type="text" class="form-control compact" id="rprsTelno2" value="${rprsTelno2}" inputmask="length" maxLen="3" required="true"/>
                                                            <span class="txt-sort">-</span>
                                                            <input type="text" class="form-control compact" id="rprsTelno3" value="${rprsTelno3}" inputmask="length" maxLen="4" required="true"/>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><label for="copy_label" class="req">CopyRight</label></th>
                                                <td>
                                                    <div class="form-row">
                                                        <input class="form-control width-100per" type="text" name="cprghtCts" id="cprghtCts" value="${vo.cprghtCts}" placeholder="" required="true">
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </form>

						<div class="btns">
                            <c:choose>
                                <c:when test="${gubun eq 'edit'}">
                                    <button type="button" class="btn type1" onclick="validateForm()">저장</button>
                                    <button type="button" class="btn type8" onclick="orgDelete()">삭제</button>
                                    <button type="button" class="btn type2" onclick="movoToList()">목록</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn type1" onclick="validateForm()">저장</button>
                                    <button type="button" class="btn type2" onclick="movoToList()">목록</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

    <script type="text/javascript">
        <c:if test="${gubun eq 'edit'}">
        const orgId = "${vo.orgId}";
        </c:if>
        let orgIdDupCheck = false;


        $(function() {
            // 중복체크 활성화
            $("#orgId").keypress(function (e) {
                orgIdDupCheck = false;
            })


        });

        // 기관ID 중복 체크
        function duplicationCheck() {
            $("#dupCheckRslt").empty();

            $.ajax({
                url: "/org/orgMgr/admOrgIdDuplicateCheck.do",
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                data: { orgId : $("#orgId").val() },
                success: function (data) {
                    if (data.result > 0) {
                        $("#dupCheckRslt").attr("class", "note");
                        orgIdDupCheck = true;
                    } else {
                        $("#dupCheckRslt").attr("class", "note2");
                        orgIdDupCheck = false;
                        UiComm.showMessage(data.message, "error");
                    }
                    $("#dupCheckRslt").text(data.message);
                    $('#dupCheckRslt').show();
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                }
            });
        }

        // 폼 검증 후 저장
        function validateForm() {

            setValues();

            UiValidator("orgForm") // 입력필드 검증
            .then(function(result) {
                if (result) {
                    <c:if test="${gubun ne 'edit'}">
                    if (!orgIdDupCheck) {
                        UiComm.showMessage('<spring:message code="user.message.userinfo.nodupchek"/>', "warning"); /* 아이디 중복체크가 완료되지 않았습니다.*/
                        return false;
                    }
                    </c:if>
                    let dx = dx5.get("fileUploader");
                    // 첨부파일 있으면 업로드
                     if (dx.availUpload()) {
                         dx.startUpload();
                     }
                     // 첨부파일 없으면 저장 호출
                     else {
                         let url = "";
                        <c:choose>
                        <c:when test="${gubun eq 'edit'}">
                         url = "/org/orgMgr/admOrgModify.do";
                        </c:when>
                        <c:otherwise>
                         url = "/org/orgMgr/admOrgRegist.do";
                        </c:otherwise>
                        </c:choose>
                         orgSave(url);
                     }
                }
            });
        }

        // 기관 등록/수정
        function orgSave(url) {
            // 첨부파일 에러로 인해 임시 주석처리
            let dx = dx5.get("fileUploader");
            $("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

            const param = $("#orgForm").serialize();

            $.post(url, param, function (data) {
                if (data.result > 0) {
                    UiComm.showMessage(data.message, "success")
                        .then(function() {
                            movoToList();
                        });

                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error");// 에러 메세지
                }
            });
        }

        // 기관 삭제
        function orgDelete() {
            $.ajax({
                url: "/org/orgMgr/admOrgDelete.do",
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                data: { orgId : $("#orgId").val() },
                success: function (data) {
                    if (data.result > 0) {
                        UiComm.showMessage(data.message, "info");
                        movoToList();
                    } else {
                        UiComm.showMessage(data.message || '<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                }
            });
        }

        // 기관 목록화면
        function movoToList() {
            document.location.href="/org/orgMgr/admOrgListView.do?encParams=" + EPARAM;
        }

        // 이메일 선택
        function selectEmail(element) {
            $("#email2").attr("readonly", false);
            let domain = element.value;

            if (domain) {
                $("#email2").val(domain);
                $("#email2").attr("readonly", true);
            } else {
                $("#email2").val("");
                $("#email2").focus();
            }
        }

        // 값 세팅
        function setValues() {
            const chrgrCntct = $("#mobile1").val() + $("#mobile2").val() + $("#mobile3").val();
            const chrgrEml = $("#email1").val() + "@" + $("#email2").val();
            const ofcTelno = $("#ofcTelno1").val() + $("#ofcTelno2").val() + $("#ofcTelno3").val();
            const rprsTelno = $("#rprsTelno1").val() + $("#rprsTelno2").val() + $("#rprsTelno3").val();

            $("#chrgrCntct").val(chrgrCntct);
            $("#chrgrEml").val(chrgrEml);
            $("#ofcTelno").val(ofcTelno);
            $("#rprsTelno").val(rprsTelno);
        }


    </script>

</body>
</html>

