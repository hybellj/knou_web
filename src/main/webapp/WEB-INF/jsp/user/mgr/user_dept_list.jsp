<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    // 학과/부서 정보
    function addFormSet(deptCd) {

        if(deptCd != undefined) {

            var url  = "/user/userMgr/viewDept.do";
            var data = {
                "deptCd" : deptCd
            };
            
            $.getJSON(url, data, function(data) {
                if (data.result > 0) {
                    var returnVO = data.returnVO;
                    $("#deptCd").val(returnVO.deptCd);
                    $("#parDeptCd").val(returnVO.parDeptCd).trigger("change");
                    $("#deptNm").val(returnVO.deptNm);
                    $("#deptNmEn").val(returnVO.deptNmEn);
                    $("#deptBtn").attr("href", "javascript:editDept(\""+returnVO.deptCd+"\")");
                } else {
                     alert(data.message);
                }
            }, function(xhr, status, error) {
                alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
            });
        } else {
            $("#deptCd").val("");
            $("#parDeptCd").val("ROOT").trigger("change");
            $("#deptNm").val("");
            $("#deptNmEn").val("");
            $("#deptBtn").attr("href", "javascript:addDept()");
        }
    }
    
    // 학과(부서) 등록
    function addDept() {
        if($("#deptCd").val() == "" || $("#deptNm").val() == "") {
            alert("<spring:message code='user.message.userdept.add.failed' />");/* 학과/부서 등록 실패, 필수 입력 항목 확인 다시 시도 해 주세요. */
            return;
        }
        
        var url  = "/user/userMgr/insertDept.do";
        var data = {
            "deptCd"     : $("#deptCd").val(),
            "parDeptCd" : $("#parDeptCd").val(),
            "deptNm"     : $("#deptNm").val()
            //"deptNmEn"     : $("#deptNmEn").val()
        };
        
        $.getJSON(url, data, function(data) {
            if (data.result > 0) {
                /* 학과/부서 등록이 완료되었습니다. */
                alert("<spring:message code='user.message.userdept.add.success' />");
                
                $("#deptCd").val("");
                $("#parDeptCd").val("");
                $($("#parDeptCd").siblings()[1]).text("<spring:message code='common.label.select'/>");
                $("#deptNm").val("");
                // $("#deptNmEn").val("");
                $("#deptBtn").attr("onclick","addDept()");
                <%-- listDept(1); --%>
                location.reload();
            } else {
                 alert(data.message);
            }
        }, function(xhr, status, error) {
            /* 학과/부서 등록 실패, 필수 입력 항목 확인 다시 시도 해 주세요. */
            alert("<spring:message code='user.message.userdept.add.failed' />");
        });
    }
    
    // 학과(부서) 수정
    function editDept(deptCd) {

        if($("#deptCd").val() == "" || $("#deptNm").val() == "") {
            /* 학과/부서 수정 실패, 필수 입력 항목 확인 다시 시도 해 주세요. */
            alert("<spring:message code='user.message.userdept.edit.failed' />");
            return;
        }
        
        var url  = "/user/userMgr/updateDept.do";
        var data = {
            "deptCd"         : $("#deptCd").val(),
            "parDeptCd"     : $("#parDeptCd").val(),
            "deptNm"         : $("#deptNm").val(),
            //"deptNmEn"   : $("#deptNmEn").val(),
            "searchValue"  : deptCd
        };
        
        $.getJSON(url, data, function(data) {
            if (data.result > 0) {
                /* 학과/부서 수정이 완료되었습니다. */
                alert("<spring:message code='user.message.userdept.edit.success' />");
                
                $("#deptCd").val("");
                $("#parDeptCd").val("");
                $($("#parDeptCd").siblings()[1]).text("<spring:message code='common.label.select'/>");
                $("#deptNm").val("");
                $("#deptNmEn").val("");
                $("#deptBtn").attr("onclick","addDept()");
                $("#clearDeptBtn").attr("onclick","delDept()");
                <%-- listDept(1); --%>
                location.reload();

            } else {
                 alert(data.message);
            }
        }, function(xhr, status, error) {
            /* 학과/부서 수정 실패, 필수 입력 항목 확인 다시 시도 해 주세요. */
            alert("<spring:message code='user.message.userdept.edit.failed' />");
        });
    }
    
    // 학과(부서) 삭제
    function delDept(deptCd) {
        /* 학과/부서를 정말 삭제 하시겠습니까? */
        if(confirm("<spring:message code='user.message.userdept.remove.confirm' />")) {
            var url  = "/user/userMgr/deleteDept.do";
            var data = {
                "deptCd" : deptCd
            };
            
            $.getJSON(url, data, function(data) {
                if (data.result > 0) {
                    /* 학과/부서 삭제가 완료되었습니다. */
                    alert("<spring:message code='user.message.userdept.remove.success' />");
                    location.reload();
                } else {
                     alert(data.message);
                }
            }, function(xhr, status, error) {
                /* 학과/부서 삭제 실패, 다시 시도 해 주세요. */
                alert("<spring:message code='user.message.userdept.remove.failed' />");
            });
        }
    }
    
    // 학과/부서 등록 폼 초기화
    function clearDeptForm() {
        $("#deptCd").val("");
        $("#deptNm").val("");
        $("#deptNmEn").val("");
        $("#parDeptCd").val("");
        $($("#parDeptCd").siblings()[1]).text("<spring:message code='common.label.select'/>");
    }
</script>

<!-- 등록된 내용이 없습니다. -->
<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />">
    <colgroup>
        <col width="5%">
        <col />
        <col />
        <col width="25%">
        <!-- <col width="25%"> -->
        <col width="150px">
    </colgroup>
    <thead>
        <tr>
            <th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th><!-- NO. -->
            <th scope="col"><spring:message code="user.title.userdept.dept.code" /></th><!-- 학과/부서 코드 -->
            <th scope="col"><spring:message code="user.title.userdept.par.dept.code" /></th><!-- 상위 학과/부서 코드 -->
            <th scope="col"><spring:message code="user.title.userdept.dept.name.kr" /></th><!-- 학과/부서명(KR) -->
            <%-- <th scope="col" data-breakpoints="xs sm md"><spring:message code="common.use.yn"/></th><!-- 사용여부 --> --%>
            <th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code='common.mgr'/></th><!-- 관리 -->
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="${not empty resultList}">
                <c:forEach items="${resultList}" var="item" varStatus="status">
                    <tr>
                        <%--
                        <td>${pageInfo.rowNum(status.index)}</td>
                        --%>
                        <td>${item.lineNo}</td>
                        <td>${item.deptCd}</td>
                        <td>${item.parDeptCd}</td>
                        <td>${item.deptNm}</td>
                        <%-- <td>
                            <div class="ui toggle checkbox" onclick="togleUseYn('useYn_${item.deptCd}');">
                                <input type="checkbox" id="useYn_${item.deptCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if>>
                            </div>
                        </td> --%>
                        <td>
                            <div class="ui basic small buttons">
                                <a href="javascript:addFormSet('${item.deptCd }')" class="ui button"><spring:message code='button.edit'/></a>
                                <a href="javascript:delDept('${item.deptCd }')" class="ui button"><spring:message code='button.delete'/></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                </tr>
            </c:otherwise>
        </c:choose>
    </tbody>
</table>
<tagutil:paging pageInfo="${pageInfo}" funcName="listDept"/>
</html>