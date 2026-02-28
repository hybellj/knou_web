<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    
    <script type="text/javascript">
        var STD_SEARCH_LIST = [];
        var STD_LIST = [];

        $(document).ready(function() {
            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listStdSearch(1);
                }
            });

            $("#searchValue1").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    filterStd();
                }
            });
            
            listStd();
        });

        // 학생 추가 검색
        function listStdSearch(pageIndex) {
            var crsTypeCd = '<c:out value="${creCrsVO.crsTypeCd}" />';
            var menuTypes = "STUDENT";

            if(crsTypeCd == "LEGAL") {
                menuTypes += ",PROFESSOR,ADMIN";
            }

            if(!$("#searchValue").val()) {
                alert("검색어를 입력하세요.");
                return;
            }

            var url = "/user/userMgr/userList.do";
            var data = {
                  pageIndex: pageIndex
                , listScale: 10
                , searchValue: $("#searchValue").val()
                , menuTypes: menuTypes
            };

            ajaxCall(url, data, function(data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    STD_SEARCH_LIST = returnList;
                    
                    setStdSearchList();
                    
                    var params = {
                            totalCount : data.pageInfo.totalRecordCount,
                            listScale : data.pageInfo.recordCountPerPage,
                            currentPageNo : data.pageInfo.currentPageNo,
                            eventName : "listStdSearch"
                        };

                        gfn_renderPaging(params);
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            }, true);
        }

        // 학생 추가 목록 세팅
        function setStdSearchList() {
            var html = '';

            if(STD_SEARCH_LIST.length == 0) {
                html += '<div class="flex-container">';
                html += '   <div class="search-none">';
                html += '       <span><spring:message code="sys.common.search.no.result" /></span>'; // 검색 결과가 없습니다.
                html += '   </div>';
                html += '</div>';
            } else {
                html += '<table class="table select-list" data-sorting="false" data-paging="false" id="stdSearchTable">';
                html += '   <tBody>';
                STD_SEARCH_LIST.forEach(function(v, i) {
                    html += '   <tr data-user-no="' + v.userId + '" data-user-nm="' + v.userNm + '" data-dept-nm="' + (v.deptNm || "") + '">';
                    html += '       <td class="">';
                    html +=             v.userNm + ' (' + v.userId + ')';
                    html += '           <br />';
                    html += '           <div class="f080 mt5">' + (v.deptNm || '-') + '<span class="ml5 mr5 fcGrey">|</span>' + (v.mobileNo || '-')  + '<span  class="ml5 mr5 fcGrey">|</span>' + (v.email || '-') + '</div>';
                    html += '       </td>';
                    html += '   </tr>';
                });
                html += '   <tBody>';
                html += '</table>';
            }

            $("#stdSearchList").html(html);
            $("#stdSearchTable").footable();

            // 선택 이벤트
            $("[data-user-no]").off("click").on("click", function() {
                //$("[data-user-no]").removeClass("active");
                //$(this).addClass("active");
                $(this).toggleClass("active");
            });
        }

        //- 수강생 리스트
        function listStd() {
            var url = "/std/stdMgr/listPagingStd.do";
            var data = {
                 // pageIndex: pageIndex
                //, listScale: $("#listScale").val()
                  pagingYn: "N"
                , crsCreCd: '<c:out value="${creCrsVO.crsCreCd}" />'
            };

            ajaxCall(url, data, function(data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    STD_LIST = returnList;

                    setStdList(STD_LIST);
                    setStdSearchList();
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            }, true);
        }

        // 수강생 목록 세팅
        function setStdList(list) {
            var html = '';
            
            list.forEach(function(v, i) {
                var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) : v.regDttm;
                
                html += '   <tr>';
                html += '       <td>' + (i + 1) + '</td>';
                html += '       <td>' + (v.deptNm || '-') + '</td>';
                html += '       <td>' + v.userId + '</td>';
                html += '       <td>' + v.userNm + '</td>';
                html += '       <td>' + (v.schregGbn || '-') + '</td>';
                html += '       <td>' + (v.enrlStsNm || '-') + '</td>';
                html += '       <td>' + (v.regNm || '-') + '</td>';
                html += '       <td>' + (regDttmFmt || '-') + '</td>';
                html += '       <td>';
                html += '           <a href="javascript:void(0);" class="ui basic small button" onclick="removeStd(\'' + v.userId + '\');"><spring:message code="button.delete"/></a>'; // 삭제
                html += '       </td>';
                html += '   </tr>';
            });

            $("#stdList").html(html);

            if(list.length > 0) {
                $("#nodataMsg").hide();
            } else {
                $("#nodataMsg").show()
            }
        }

        // 학생 필터
        function filterStd() {
            var searchValue = $("#searchValue1").val();

            if(!searchValue) {
                setStdList(STD_LIST);
            } else {
                var searchList = [];

                STD_LIST.forEach(function(v, i) {
                    if(v.userId.indexOf(searchValue) > -1 || v.userNm.indexOf(searchValue) > -1) {
                        searchList.push(v);
                    }
                });

                setStdList(searchList);
            }
        }

        // 추가 수강생
        function addToStdList() {
            var $tr = $("#stdSearchTable > tbody > tr.active");

            if($tr.length == 0) {
                // 등록할 수강생이 없습니다.
                alert('<spring:message code="common.pop.no.record.learner" />');
                return;
            }

            $($("#stdSearchTable > tbody > tr.active")).each(function() {
                var userId = $(this).data("userId");
                var userNm = $(this).data("userNm");
                var deptNm = $(this).data("deptNm") || "";

                var isExists = false;
                STD_LIST.forEach(function(v, i) {
                    if(userId == v.userId) {
                        isExists = true;
                        return false;
                    }
                });

                if(isExists) {
                    alert('<spring:message code="crs.alert.already.exists.std" />'); // 이미 등록된 수강생입니다.
                    return true;
                }

                STD_LIST.unshift({
                      userId : "" + userId
                    , userNm : userNm
                    , deptNm : deptNm
                });
            });

            setStdSearchList();
            setStdList(STD_LIST);
        }

        // 수강생 삭제
        function removeStd(userId) {
            STD_LIST = STD_LIST.filter(function(v, i) {
                return userId != v.userId;
            });

            setStdList(STD_LIST);
        }

        // 수강생 전체 삭제
        function removeAllStd() {
            STD_LIST = [];
            setStdList(STD_LIST);
        }

        // 저장 버튼
        function addCrsCreStdList() {
            var userIdList = [];
            STD_LIST.forEach(function(v, i) {
                userIdList.push(v.userId);
            });

            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "addTchForm");
            form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${creCrsVO.crsCreCd}" />'}));
            form.append($('<input/>', {type: 'hidden', name: "userId", value: userIdList.join(",")}));
            
            var url = "/crs/creCrsMgr/addCreStd.do";
            var data = form.serialize();

            ajaxCall(url, data, function(data) {
                if (data.result > 0) {
                    alert("<spring:message code='crs.class.learner.regist.success'/>"); // 수강생 등록하였습니다.
                    $("#searchValue1").val("");
                    listStd();
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                alert("<spring:message code='crs.alert.request.fail.reference.admin.fail'/>"); // 요청에 대해 정상적인 응답을 받지 못하였습니다. 관리자에게 문의 하십시오.
            }, true);
        }

        // 취소 버튼
        function moveCrsCreList() {
            var crsTypeCd = '<c:out value="${creCrsVO.crsTypeCd}" />';

            var url = "";
            if(crsTypeCd == "OPEN") {
                // 공개강좌 개설과목 목록 
                url = "/crs/creCrsMgr/Form/creCrsOpenListForm.do";
            } else if(crsTypeCd == "LEGAL") {
                // 법정교육 개설과목 목록 
                url = "/crs/creCrsMgr/Form/creCrsLegalListForm.do";
            } else {
                // 학기제 개설과목 목록
                url = "/crs/creCrsMgr/Form/creCrsListForm.do";
            }

            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "moveForm");
            form.attr("action", url);
            form.appendTo("body");
            form.submit();
        }

        // 과목 정보 등록 버튼
        function moveCrsCre() {
            var crsTypeCd = '<c:out value="${creCrsVO.crsTypeCd}" />';

            var url = "";
            if(crsTypeCd == "OPEN") {
                // 공개 과정 목록
                url = "/crs/creCrsMgr/Form/creCrsOpenWriteForm.do";
            } else if(crsTypeCd == "LEGAL") {
                // 법정교육  등록
                url = "/crs/creCrsMgr/Form/creCrsLegalWriteForm.do";
            } else {
                url = "/crs/creCrsMgr/Form/addForm.do";
            }

            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "moveForm");
            form.attr("action", url);
            form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${creCrsVO.crsCreCd}" />'}));
            form.appendTo("body");
            form.submit();
        }

        // 운영자 등록 버튼
        function moveCrsCreTch() {
            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "moveForm");
            form.attr("action", "/crs/creCrsMgr/Form/crsTchForm.do");
            form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${creCrsVO.crsCreCd}" />'}));
            form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: '<c:out value="${creCrsVO.crsTypeCd}" />'}));
            form.appendTo("body");
            form.submit();
        }

        // 엑셀 다운로드
        function listExcel() {
            var excelGrid = {
                colModel:[
                   {label:'<spring:message code="common.number.no"/>',   name:'lineNo',     align:'center', width:'1000'}, // No.
                   {label:'<spring:message code="common.dept_name"/>',   name:'deptNm',     align:'left',   width:'5000'}, // 학과
                   {label:'<spring:message code="common.id"/>',   name:'userId',   align:'left',   width:'5000'}, // 아이디 
                   {label:'<spring:message code="common.name"/>', name:'userNm', align:'left',  width:'5000'}, //  이름
                   {label:'<spring:message code="common.label.schreg.gbn"/>', name:'schregGbn', align:'left',  width:'5000'}, // 재적상태
                   {label:'<spring:message code="crs.access.status"/>', name:'enrlSts', align:'center',  width:'5000', codes:{E:'<spring:message code="common.label.request"/>',S:'<spring:message code="button.confirm"/>',N:'<spring:message code="common.label.reject"/>',D:'<spring:message code="button.delete"/>'}}, <%-- 승인상태, 신청, 승인, 반려, 삭제 --%> 
                   {label:'<spring:message code="common.label.reg.dttm"/>', name:'modDttm', align:'center',  width:'5000'}, // 등록일시
                ]
            };

            var excelForm = $('<form></form>');
            excelForm.attr("name","excelForm");
            excelForm.attr("action","/crs/creCrsMgr/creStdListExcel.do");
            excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value:"${vo.crsCreCd}" }));
            excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val() }));
            excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));

            excelForm.appendTo('body');
            excelForm.submit();
        }

        // 엑셀 수강생 등록
        function uploadExcel() {
            $("#excelUploadForm > input[name='crsCreCd']").val('<c:out value="${vo.crsCreCd}" />');
            $("#excelUploadForm").attr("target", "excelUploadPopIfm");
            $("#excelUploadForm").attr("action", "/crs/creCrsMgr/creCrsStsExcelUploadPop.do");
            $("#excelUploadForm").submit();
            $('#excelUploadModal').modal('show');
        }

        // 엑셀 업로드 콜백
        function excelUploadCallBack() {
            window.location.reload();
        }

        // 대학원, 학부생 일괄추가
        function allStudentSet(uniCd) {
            /*
            var userId = "";
            for(var i=0; i<STD_LIST.length; i++) {
                if(i > 0) userId += ",";
                userId += STD_LIST[i].userId;
            }
            */
            var url = "/user/userMgr/listStudentByUniCd.do";
            var data = {
                uniCd : uniCd
                //userId : userId
            };

            ajaxCall(url, data, function(data){
                if(data.result > 0) {
                    var returnList = data.returnList || [];
                    var dupCheckObj = {};
                    
                    STD_LIST.forEach(function(v, j){
                        dupCheckObj[v.userId] = true;
                    });
                    
                    returnList.forEach(function(v, i){
                        if(!dupCheckObj[v.userId]) {
                            STD_LIST.push({
                                  userId : v.userId
                                , userNm : v.userNm
                                , deptNm : v.deptNm
                            });
                        }
                    });

                    setStdList(STD_LIST);
                    setStdSearchList();
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            }, true);
        }
    </script>
</head>
<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <div id="container">
            <div class="content">
                <div id="info-item-box">
                    <h2 class="page-title flex-item">
                        <spring:message code="common.term.subject"/><!-- 학기/과목 -->
                        <div class="ui breadcrumb small">
                            <small class="section"><spring:message code="common.student.add"/><!-- 수강생 추가 --></small>
                        </div>
                    </h2>
                    <div class="button-area">
                        <c:choose>
                            <c:when test="${creCrsVO.crsTypeCd eq 'LEGAL'}">
                                <a href="javascript:moveCrsCre();" class="btn"><spring:message code="common.label.previous"/></a><!-- 이전 -->
                                <a href="javascript:addCrsCreStdList();" class="btn btn-primary"><spring:message code="button.add"/></a><!-- 저장 -->
                                <a href="javascript:moveCrsCreList();" class="btn btn-negative"><spring:message code="button.cancel"/></a><!-- 취소 -->
                            </c:when>
                            <c:otherwise>
                                <a href="javascript:moveCrsCreTch();" class="btn"><spring:message code="common.label.previous"/></a><!-- 이전 -->
                                <a href="javascript:addCrsCreStdList();" class="btn btn-primary"><spring:message code="button.add"/></a><!-- 저장 -->
                                <a href="javascript:moveCrsCreList();" class="btn btn-negative"><spring:message code="button.cancel"/></a><!-- 취소 -->
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="ui form">
                    <ol class="cd-multi-steps text-bottom count">
                        <li><a href="javascript:moveCrsCre();"><span><spring:message code="crs.lecture.info.regist"/></span></a></li><!-- 과목 정보 등록 -->
                        <c:if test="${creCrsVO.crsTypeCd ne 'LEGAL'}">
                            <li><a href="javascript:moveCrsCreTch();"><span><spring:message code="crs.label.reg.operator"/></span></a></li><!-- 운영자 등록 -->
                        </c:if>
                        <li class="current"><a href="#0"><span><spring:message code="crs.label.learner.regist"/></span></a></li><!-- 수강생 추가 -->
                    </ol>
                    <div class="ui grid stretched row">
                        <div class="sixteen wide tablet six wide computer column">
                            <div class="ui top attached message">
                                <div class="header"><spring:message code="common.student.add"/></div><!-- 수강생 추가 -->
                            </div>
                            <div class="ui bottom attached segment">
                                <div class="option-content">
                                    <div class="ui action input search-box">
                                        <input type="text" placeholder="<spring:message code='crs.label.placeholder.search.learner'/>" id="searchValue" /><!-- 수강생을 검색하세요 -->
                                        <button class="ui icon button" onclick="listStdSearch(1)" type="button"><i class="search icon"></i></button>
                                    </div>
                                    <div class="button-area">
                                        <a href="javascript:addToStdList()" class="ui basic button"><spring:message code="crs.label.learner.regist"/></a><!-- 수강생 추가 -->
                                    </div>
                                </div>
                                <div id="stdSearchList">
                                    <div class="flex-container">
                                        <div class="search-none">
                                            <span><spring:message code="sys.common.search.no.result" /></span><!-- 검색 결과가 없습니다. -->
                                        </div>
                                    </div>
                                </div>
                                <div id="paging" class="paging mt10"></div>
                            </div>
                        </div>
                        <div class="sixteen wide tablet ten wide computer column">
                            <div class="ui top attached message">
                                <div class="header">
                                    <spring:message code='common.student.list'/><!-- 수강생 목록 -->
                                    <c:if test="${creCrsVO.crsTypeCd eq 'LEGAL' }">
                                        <div class="fr">
                                            <button type="button" class="ui green small button" onclick="allStudentSet('G')"><spring:message code='common.student.add.all.g'/><!-- 대학원생 일괄추가 --></button>
                                            <button type="button" class="ui green small button" onclick="allStudentSet('C')"><spring:message code='common.student.add.all.u'/><!-- 학부생 일괄추가 --></button>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="ui bottom attached segment">
                                <div class="option-content">
                                    <div class="ui action input search-box">
                                        <input type="text" placeholder="<spring:message code='button.search'/>" name="searchValue1" id="searchValue1" /><!-- 검색 -->
                                        <a class="ui icon button" onclick="filterStd()"><i class="search icon"></i></a>
                                    </div>
                                    <div class="button-area">
                                        <a href="javascript:removeAllStd()" class="ui basic button"><spring:message code='common.student.batch.delete'/></a><!-- 수강생 일괄 삭제 -->
                                        <a href="javascript:uploadExcel()" class="ui basic button"><spring:message code='crs.excel.learner.regist'/></a><!-- 엑셀 수강생 등록 -->
                                        <a href="javascript:listExcel()" class="ui basic button"><spring:message code='button.download.excel'/></a><!-- 엑셀다운로드 -->
                                        <!-- 
                                        <select class="ui dropdown list-num" id="listScale" onchange="listStd()">
                                            <option value="10">10</option>
                                            <option value="20">20</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                            <option value="100">500</option>
                                            <option value="1000">1000</option>
                                            <option value="3000">3000</option>
                                            <option value="5000">5000</option>
                                        </select>
                                         -->
                                    </div>
                                </div>
                                <table class="tBasic" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.nodata.msg'/>" id="stdTable"><!-- 등록된 내용이 없습니다. -->
                                    <thead class="sticky top0">
                                        <tr>
                                            <th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><!-- NO. -->
                                            <th scope="col"><spring:message code="common.dept_name"/></th><!-- 학과 -->
                                            <th scope="col"><spring:message code="common.id"/></th><!-- 아이디 -->
                                            <th scope="col"><spring:message code="common.name"/></th><!-- 이름 -->
                                            <th scope="col"><spring:message code="common.label.schreg.gbn"/></th><!-- 재적상태 -->
                                            <th scope="col"><spring:message code="crs.access.status"/></th><!-- 승인상태 -->
                                            <th scope="col"><spring:message code="common.registrant"/></th><!-- 등록자 -->
                                            <th scope="col"><spring:message code="common.label.reg.dttm"/></th><!-- 등록일시 -->
                                            <th scope="col"><spring:message code="common.mgr"/></th><!-- 관리 -->
                                        </tr>
                                    </thead>
                                    <tbody  id="stdList">
                                    </tbody>
                                </table>
                                <div class="none tc pt10" id="nodataMsg" style="display: none;">
                                    <span><spring:message code='common.nodata.msg'/></span>
                                    <div class="ui divider"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- //ui form -->
            </div>
            <!-- //본문 content 부분 -->
        </div>
        <!-- footer 영역 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    
    <!-- 엑셀 업로드 팝업 --> 
    <form id="excelUploadForm" method="POST">
        <input type="hidden" name="crsCreCd" value="" />
    </form>
    <div class="modal fade" id="excelUploadModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.button.excel.upload" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='common.button.close' />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="std.button.excel.upload" /></h4><!-- 엑셀 업로드 -->
                </div>
                <div class="modal-body">
                    <iframe src="" id="excelUploadPopIfm" name="excelUploadPopIfm" width="100%" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>
</html>