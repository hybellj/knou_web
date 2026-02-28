<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript" src="/webdoc/js/common_function.js"></script>
<script type="text/javascript">
    // 페이지 초기화
    $(document).ready(function(){
    });

    /**
     *  용량 클릭 시 수정 박스 표시
     */
    function displayDefaultSizeModifyBlock(obj) {
        $(obj).closest("td").find("a[name=defaultSizeDpBlock]").hide();
        $(obj).closest("td").find("div[name=defaultSizeModifyBlock]").show();
    }

    /**
     *  용량변경  취소 버튼 클릭
     */
    function closeDefaultSizeModifyBlock(obj) {
        $(obj).closest("td").find("a[name=defaultSizeDpBlock]").show();
        $(obj).closest("td").find("div[name=defaultSizeModifyBlock]").hide();
    }

    /**
     *  용량변경  ok 버튼 클릭
     */
    function saveDefaultCrsSizeLimit(obj) {
        var limitSize = $(obj).closest("td").find("input:text[name=defaultSizeLimit]").val();

        /*
        if (limitSize == '' || !isNumber(limitSize)) {
            $("#note-box").prop("class", "warning");
            $("#note-box p").text("<spring:message code="filemgr.alert.input.num" />"); // 숫자로 입력하세요.
            $("#note-btn").trigger("click");
            $(obj).closest("td").find("input:text[name=defaultSizeLimit]").focus();
            return;
        } 
        */

        $("#loading_page").show();

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : {
                     "fileSizeLimitId" : $(obj).closest("td").find("input:hidden[name=fileSizeLimitId]").val()
                   , "limitFileSize" : limitSize
                   },
            url : "/file/fileMgr/modify/crs/defaultFileLimitSize.do",
            success : function(data){
                if(data.result > 0) {
                    if (typeof listDefaultCrsSizeLimitSlide == 'function') {
                        listDefaultCrsSizeLimitSlide($(".listTab.menuBox li.select").attr("data-limitTypeCd"));
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

    /**
     *  탭의 마우스 포인터 변경처리
     */
    function activateTab(obj) {

        if ($(obj).closest("li").hasClass("select") == true) {
            return;
        }

        $(".listTab.menuBox li").each(function(row) { 
            $(this).find("a").attr("href", "#" + $(this).attr("data-limitTypeCd"));
        });

        $(".listTab.menuBox li").removeClass("select");
        $(obj).closest("li").addClass("select");
        $(obj).removeAttr("href");

        $("div.tab_content").hide();
        if ($(obj).closest("li").attr("data-limitTypeCd") == 'CLASS') {
            $("#tab2").show();
        } else {
            $("#tab1").show();
        }
    }

    function closeDefaultSizeLimitSlide() {
        if (typeof reloadCurrPage() == 'function') {
            reloadCurrPage()();
        }
        $('.wide-inbox').sidebar('hide');
    }
</script>

<body>

    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->

		<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

		<!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->
        
		<div id="container">

            <!-- 본문 content 부분 -->
            <div class="content">
            
            	<!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->
                
                <div class="ui form">
		            <button type="button" class="close" onClick="closeDefaultSizeLimitSlide()"><spring:message code="button.close" /></button> <!-- 닫기 -->
		            <div class="scrollbox">
		                <div class="ui form">
		                    <h2 class="page-title pb20"><spring:message code="filemgr.label.crsauth.default_set" /></h2> <!-- 용량 초기설정 -->
		
		                    <div class="listTab menuBox mb20">
		                        <ul>
		                        <c:forEach items="${limitTypeCdList }" var="item" varStatus="status">
		                            <li class="${vo.limitTypeCd == item.codeCd ? 'select' : ''}" data-limitTypeCd="${item.codeCd}"><a href="#${item.codeCd}" onClick="activateTab(this)"><c:out value='${item.codeNm}' /></a></li>
		                        </c:forEach>
		                        </ul>
		                    </div>
		
		                    <div id="tab1" class="tab_content" style="display:${vo.limitTypeCd == 'PORTAL' ? 'block' : ''};">
		                        <table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />"> <!-- 등록된 내용이 없습니다. -->
		                            <thead>
		                                <tr>
		                                    <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
		                                    <th scope="col"><spring:message code="common.name" /></th> <!-- 이름 -->
		                                    <th scope="col"><spring:message code="common.label.auth.size" /></th> <!-- 용량 -->
		                                </tr>
		                            </thead>
		                            <tbody>
				                        <c:if test="${not empty portalResultList}">
				                            <c:forEach items="${portalResultList }" var="item" varStatus="status">
				                                <tr>
				                                    <td><fmt:formatNumber value="${item.rowNum}" type="number" /></td>
				                                    <td><c:out value='${item.limitTypeDetlNm}' /></td>
				                                    <td class="w150">
				                                        <input type="hidden" name="fileSizeLimitId" value="${item.fileSizeLimitId}" />
				                                    <c:if test="${item.limitFileSize == 0}">
				                                        <a href="javascript:;" name="defaultSizeDpBlock" class="link-dots" onClick="displayDefaultSizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <!-- 무제한 -->
				                                    </c:if>
				                                    <c:if test="${item.limitFileSize > 0}">
				                                        <a href="javascript:;" name="defaultSizeDpBlock" class="link-dots" onClick="displayDefaultSizeModifyBlock(this)"><fmt:formatNumber value="${item.limitFileSize}" type="number" />MB</a>
				                                    </c:if>
				                                        <div class="ui action input w80" style="display:none;" name="defaultSizeModifyBlock">
				                                            <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="defaultSizeLimit" maxlength="6" value="${item.limitFileSize}" placeholder="MB">
				                                            <span class="ui basic button img-button">
				                                                <button type="button" class="icon_check" name="btnDefaultSizeModifyOk" onClick="saveDefaultCrsSizeLimit(this)"></button>
				                                                <button type="button" class="icon_cancel" name="btnDefaultSizeModifyCancel" onClick="closeDefaultSizeModifyBlock(this)"></button>
				                                            </span>
				                                        </div>
				                                    </td>
				                                </tr>
				                            </c:forEach>
				                        </c:if>
		                            </tbody>
		                        </table>
		                    </div>
		                    <div id="tab2" class="tab_content" style="display:${vo.limitTypeCd == 'CLASS' ? 'block' : ''};">
		                        <table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />"> <!-- 등록된 내용이 없습니다. -->
		                            <thead>
		                                <tr>
		                                    <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
		                                    <th scope="col"><spring:message code="common.name" /></th> <!-- 이름 -->
		                                    <th scope="col"><spring:message code="common.label.auth.size" /></th> <!-- 용량 -->
		                                </tr>
		                            </thead>
		                            <tbody>
				                        <c:if test="${not empty classResultList}">
				                            <c:forEach items="${classResultList }" var="item" varStatus="status">
				                                <tr>
				                                    <td><fmt:formatNumber value="${item.rowNum}" type="number" /></td>
				                                    <td><c:out value='${item.limitTypeDetlNm}' /></td>
				                                    <td class="w150">
				                                        <input type="hidden" name="fileSizeLimitId" value="${item.fileSizeLimitId}" />
				                                    <c:if test="${item.limitFileSize == 0}">
				                                        <a href="javascript:;" name="defaultSizeDpBlock" class="link-dots" onClick="displayDefaultSizeModifyBlock(this)"><spring:message code="filebox.label.main.nolimit" /></a> <!-- 무제한 -->
				                                    </c:if>
				                                    <c:if test="${item.limitFileSize > 0}">
				                                        <a href="javascript:;" name="defaultSizeDpBlock" class="link-dots" onClick="displayDefaultSizeModifyBlock(this)"><fmt:formatNumber value="${item.limitFileSize}" type="number" />MB</a>
				                                    </c:if>
				                                        <div class="ui action input w80" style="display:none;" name="defaultSizeModifyBlock">
				                                            <input type="text" name="defaultSizeLimit" maxlength="6" value="${item.limitFileSize}" placeholder="MB">
				                                            <span class="ui basic button img-button">
				                                                <button type="button" class="icon_check" name="btnDefaultSizeModifyOk" onClick="saveDefaultCrsSizeLimit(this)"></button>
				                                                <button type="button" class="icon_cancel" name="btnDefaultSizeModifyCancel" onClick="closeDefaultSizeModifyBlock(this)"></button>
				                                            </span>
				                                        </div>
				                                    </td>
				                                </tr>
				                            </c:forEach>
				                        </c:if>
		                            </tbody>
		                        </table>
		                    </div>
		                    <div class="bottom-content">
		                        <button type="button" class="ui button" id="btnDefaultSizeClose" onClick="closeDefaultSizeLimitSlide()"><spring:message code="button.cancel" /></button> <!-- 취소 -->
		                    </div>
                		</div>
            		</div>
            	</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>