<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    <%-- 페이지 초기화 --%>
    $(document).ready(function() {
    });

    <%--  용량 클릭 시 수정 박스 표시 --%>
    function displaySizeModifyBlock(obj) {
        $(obj).closest("td").find("a[name=sizeDpBlock]").hide();
        $(obj).closest("td").find("div[name=sizeModifyBlock]").show();
    }

    <%--  용량변경  취소 버튼 클릭 --%>
    function closeSizeModifyBlock(obj) {
        $(obj).closest("td").find("a[name=sizeDpBlock]").show();
        $(obj).closest("td").find("div[name=sizeModifyBlock]").hide();
    }

    <%--  용량변경  ok 버튼 클릭 --%>
    function saveCrsSizeLimit(obj, crsCreCd) {
        var limitSize = $(obj).closest("td").find("input:text[name$=SizeLimit]").val();
        var limitTypeNm = $(obj).closest("td").find("input:text[name$=SizeLimit]").attr("name");
        var limitTypeDetlCd = "";
        if (limitTypeNm == 'bbsSizeLimit') {
            limitTypeDetlCd = 'LECT_BBS';
        } else if (limitTypeNm == 'asmtSizeLimit') {
            limitTypeDetlCd = 'ASMNT';
        } else if (limitTypeNm == 'forumSizeLimit') {
            limitTypeDetlCd = 'FORUM';
        } else if (limitTypeNm == 'examSizeLimit') {
            limitTypeDetlCd = 'EXAM_CD';
        } else if (limitTypeNm == 'teamSizeLimit') {
            limitTypeDetlCd = 'PROJECT';
        } else if (limitTypeNm == 'lectSizeLimit') {
            limitTypeDetlCd = 'LECTURE';
        }

        <%-- if(!isNumber(limitSize)) {
            $("#note-box").prop("class", "warning");
            $("#note-box p").text("<spring:message code="filemgr.alert.input.num" />"); 숫자로 입력하세요.
            $("#note-btn").trigger("click");
            $(obj).closest("td").find("input:text[name$=SizeLimit]").focus();
            return;
        } --%>

        $("#loading_page").show();

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : {
                     "selectedCrsCreCd" : crsCreCd
                   , "limitFileSize" : limitSize
                   , "limitTypeDetlCd" : limitTypeDetlCd
                   },
            url : "/file/fileMgr/modify/crs/fileLimitSize.do",
            success : function(data){
                if(data.result > 0) {
                    if (typeof listCrsSizeLimit == 'function') {
                        listCrsSizeLimit('${pageInfo.currentPageNo}');
                    }
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            },
            beforeSend: function() {
            },
            complete:function(status){
                $("#loading_page").hide();
            },
            error: function(xhr,  Status, error) {
                $("#loading_page").hide();
            }
        });
    }

    <%--  현 페이지를 다시 조회하다 --%>
    function reloadCurrPage() {
        if (typeof listCrsSizeLimit == 'function') {
            listCrsSizeLimit('${pageInfo.currentPageNo}');
        }
    }
</script>

<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />"> <%-- 등록된 내용이 없습니다. --%>
    <thead>
        <tr>
            <th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><%-- NO. --%>
            <th scope="col"><spring:message code="common.label.crsauth.crscd" /></th> <%-- 과목코드 --%>
            <th scope="col" width="15%;"><spring:message code="common.label.crsauth.crsnm" /></th> <%-- 과목명 --%>
             <c:if test="${vo.crsTypeCd ne 'OPEN' }">
                <th scope="col"><spring:message code="common.label.decls.no" /></th> <%-- 분반 --%>
             </c:if>
            <c:if test="${vo.crsTypeCd eq 'UNI' }">
                <th scope="col" data-breakpoints="xs"><spring:message code="common.label.crsauth.comtype" /></th> <%-- 이수구분 --%>
            </c:if>
            <th scope="col" data-breakpoints="xs"><spring:message code="common.label.lecture.form" /></th> <%-- 강의형태 --%>
            <th scope="col" data-breakpoints="xs"><spring:message code="common.charge.professor" /></th> <%-- 담당교수 --%>
            <th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="button.bbs" /></th> <%-- 게시판 --%>
            <th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.label.lecture" /></th> <%-- 강의 --%>
            <c:if test="${vo.crsTypeCd ne 'OPEN' }">                                    
                <th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.label.asmnt" /></th> <%-- 과제 --%>
                <th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.label.exam" /></th> <%-- 시험 --%>
                <th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.label.forum" /></th> <%-- 토론 --%>
                <th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.label.proj" /></th> <%-- 팀활동 --%>
            </c:if>
        </tr>
    </thead>
    <tbody>
        <c:if test="${not empty resultList}">
            <c:forEach items="${resultList }" var="item" varStatus="status">
                <tr>
                    <td>${pageInfo.rowNum(status.index) }</td>
                    <td><c:out value='${item.crsCreCd}' /></td>
                    <td>
                        <c:out value='${item.crsCreNm}' />
                        <input type="hidden" name="crsCreCd" value="${item.crsCreCd}" />
                    </td>
                    <c:if test="${vo.crsTypeCd ne 'OPEN' }"><td><c:out value='${item.declsNo}' /></td></c:if>
                    <c:if test="${vo.crsTypeCd eq 'UNI' }"><td><c:out value='${item.courseTypeNm}' /></td></c:if>
                    <td><c:out value='${item.learningTypeNm}' /></td>
                    <td><c:out value='${item.professorNm}' /></td>
                    <td class="w120">
                    <c:if test="${item.bbsFileSize == 0}">
                        <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                    </c:if>
                    <c:if test="${item.bbsFileSize > 0}">
                        <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><fmt:formatNumber value="${item.bbsFileSize}" type="number" />MB</a>
                    </c:if>
                        <div class="ui action input w80" style="display:none;" name="sizeModifyBlock">
                            <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="bbsSizeLimit" maxlength="6" value="${item.bbsFileSize}" placeholder="MB">
                            <span class="ui basic button img-button">
                                <button type="button" class="icon_check" name="btnSizeModifyOk" onClick="saveCrsSizeLimit(this, '${item.crsCreCd}')"></button>
                                <button type="button" class="icon_cancel" name="btnSizeModifyCancel" onClick="closeSizeModifyBlock(this)"></button>
                            </span>
                        </div>
                    </td>
                    <td class="w120">
                    <c:if test="${item.lectureFileSize == 0}">
                        <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                    </c:if>
                    <c:if test="${item.lectureFileSize > 0}">
                        <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><fmt:formatNumber value="${item.lectureFileSize}" type="number" />MB</a>
                    </c:if>
                        <div class="ui action input w80" style="display:none;" name="sizeModifyBlock">
                            <input type="text" name="lectSizeLimit" maxlength="6" value="${item.lectureFileSize}" placeholder="MB">
                            <span class="ui basic button img-button">
                                <button type="button" class="icon_check" name="btnSizeModifyOk" onClick="saveCrsSizeLimit(this, '${item.crsCreCd}')"></button>
                                <button type="button" class="icon_cancel" name="btnSizeModifyCancel" onClick="closeSizeModifyBlock(this)"></button>
                            </span>
                        </div>
                    </td>
                    <c:if test="${vo.crsTypeCd ne 'OPEN' }">
                        <td class="w120">
                        <c:if test="${item.asmtFileSize == 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                        </c:if>
                        <c:if test="${item.asmtFileSize > 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><fmt:formatNumber value="${item.asmtFileSize}" type="number" />MB</a>
                        </c:if>
                            <div class="ui action input w80" style="display:none;" name="sizeModifyBlock">
                                <input type="text" name="asmtSizeLimit" maxlength="6" value="${item.asmtFileSize}" placeholder="MB">
                                <span class="ui basic button img-button">
                                    <button type="button" class="icon_check" name="btnSizeModifyOk" onClick="saveCrsSizeLimit(this, '${item.crsCreCd}')"></button>
                                    <button type="button" class="icon_cancel" name="btnSizeModifyCancel" onClick="closeSizeModifyBlock(this)"></button>
                                </span>
                            </div>
                        </td>
                        <td class="w120">
                        <c:if test="${item.examFileSize == 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                        </c:if>
                        <c:if test="${item.examFileSize > 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><fmt:formatNumber value="${item.examFileSize}" type="number" />MB</a>
                        </c:if>
                            <div class="ui action input w80" style="display:none;" name="sizeModifyBlock">
                                <input type="text" name="examSizeLimit" maxlength="6" value="${item.examFileSize}" placeholder="MB">
                                <span class="ui basic button img-button">
                                    <button type="button" class="icon_check" name="btnSizeModifyOk" onClick="saveCrsSizeLimit(this, '${item.crsCreCd}')"></button>
                                    <button type="button" class="icon_cancel" name="btnSizeModifyCancel" onClick="closeSizeModifyBlock(this)"></button>
                                </span>
                            </div>
                        </td>
                        <td class="w120">
                        <c:if test="${item.forumFileSize == 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                        </c:if>
                        <c:if test="${item.forumFileSize > 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><fmt:formatNumber value="${item.forumFileSize}" type="number" />MB</a>
                        </c:if>
                            <div class="ui action input w80" style="display:none;" name="sizeModifyBlock">
                                <input type="text" name="forumSizeLimit" maxlength="6" value="${item.forumFileSize}" placeholder="MB">
                                <span class="ui basic button img-button">
                                    <button type="button" class="icon_check" name="btnSizeModifyOk" onClick="saveCrsSizeLimit(this, '${item.crsCreCd}')"></button>
                                    <button type="button" class="icon_cancel" name="btnSizeModifyCancel" onClick="closeSizeModifyBlock(this)"></button>
                                </span>
                            </div>
                        </td>
                        <td class="w120">
                        <c:if test="${item.teamFileSize == 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                        </c:if>
                        <c:if test="${item.teamFileSize > 0}">
                            <a href="javascript:;" name="sizeDpBlock" class="link-dots" onClick="displaySizeModifyBlock(this)"><fmt:formatNumber value="${item.teamFileSize}" type="number" />MB</a>
                        </c:if>
                            <div class="ui action input w80" style="display:none;" name="sizeModifyBlock">
                                <input type="text" name="teamSizeLimit" maxlength="6" value="${item.teamFileSize}" placeholder="MB">
                                <span class="ui basic button img-button">
                                    <button type="button" class="icon_check" name="btnSizeModifyOk" onClick="saveCrsSizeLimit(this, '${item.crsCreCd}')"></button>
                                    <button type="button" class="icon_cancel" name="btnSizeModifyCancel" onClick="closeSizeModifyBlock(this)"></button>
                                </span>
                            </div>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
        </c:if>
    </tbody>
</table>
<tagutil:paging pageInfo="${pageInfo}" funcName="listCrsSizeLimit"/>
