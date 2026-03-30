<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

    <script type="text/javascript">
        var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
        var PAGE_INDEX		= '<c:out value="${sbjctListVO.pageIndex}" />';
        var LIST_SCALE		= '<c:out value="${sbjctListVO.listScale}" />';
        var EPARAM			= '<c:out value="${encParams}" />';

        $(document).ready(function() {
            // 최초 조회
            listPaging(1);

            // 엔터키
            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listPaging(1);
                }
            });

            $("[name=selectSbjctTypeCd]").on("change", function(){
                listPaging(1);
            });

            if(!PAGE_INDEX) {
                PAGE_INDEX = 1;
            }

            if(!LIST_SCALE) {
                LIST_SCALE = 10;
            }
        });

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			listPaging(1);
		}

        //리스트 조회
        function listPaging(pageIndex) {
            SEARCH_VALUE = $("#searchValue").val();
            PAGE_INDEX = pageIndex;

            var searchValue = $('#searchValue').val();
            var sbjctTycd = $("#selectSbjctTyCd").val();
            var sbjctYr = $('#selectDgrsYr').val();
            var sbjctSmstr = $('#selectDgrsSmstrChrt').val();

            var param = {
                pageIndex		: pageIndex
                , listScale		: LIST_SCALE
                , searchValue   : searchValue
                , sbjctYr       : sbjctYr
                , sbjctSmstr    : sbjctSmstr
                , sbjctTycd     : sbjctTycd
            };

            var url  = "/crs/sbjct/adminSbjctList.do";
			UiComm.showLoading(true);
            ajaxCall(url, param, function(data) {
                if (data.result > 0) {
                    let returnList = data.returnList || [];

                    // 테이블 데이터 설정
                    let dataList = createSbjctListHTML(returnList, data.pageInfo);
                    sbjctListTable.clearData();
                    sbjctListTable.replaceData(dataList);
                    sbjctListTable.setPageInfo(data.pageInfo);
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                alert("에러가 발생했습니다!");
            });
        }

        // 게시글 리스트 생성
		function createSbjctListHTML(sbjctList, pageInfo) {
            let dataList = [];

			if(sbjctList.length == 0) {
				return dataList;
			} else {
				sbjctList.forEach(function(v, i) {
					var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

					let col0 = "";
					let title = "";
					let colLabel = "";
					col0 = lineNo;

					let userYnHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyUseYn(this, \'' + v.sbjctMstrId + '\', this.checked)"';
					if(v.useYn == 'Y') {
						userYnHtml += '	checked="checked">';
					} else {
					    userYnHtml += '>';
					}

					let mgrHtml = '';
					mgrHtml = '<button type="button" class="btn basic small" >';
					mgrHtml += '<spring:message code="sys.button.modify"/></button>';
					mgrHtml += '<button type="button" class="btn basic small"><spring:message code="sys.button.delete" /></button>';

					dataList.push({
						no: col0,
						orgId: v.orgId,
						deptId: v.deptId,
						sbjctSmstr: v.sbjctSmstr,
						sbjctTycd : v.sbjctTycd,
						sbjctGbnCd: v.sbjctGbnCd,
						sbjctnm: v.sbjctnm,
						userYn: userYnHtml,
						mgr : mgrHtml,
						regDttm: v.regDttm,
						valSbjctMstrId: v.sbjctMstrId,
						label: colLabel
					});
				});

				return dataList;
			}

        }

        //사용여부 수정
        function modifyUseYn(el, sbjctMstrId){
            var $el = $(el);
            var isChecked = $el.is(":checked");

            $el.prop("disabled", true);
            var param = {
                sbjctMstrId     : sbjctMstrId
                , useYn         : isChecked ? 'Y' : 'N'
            };

            var url  = "/crs/sbjct/sbjctListUseYnModify.do";
            ajaxCall(url, param, function(data) {
                $el.prop("disabled", false);
                if (data.result > 0) {
                    // do something
                    ;
                } else {
                    $el.prop("checked", !isChecked);
                    alert("에러가 발생했습니다!");
                }
            }, function(xhr, status, error) {
                $el.prop("disabled", false);
                alert("에러가 발생했습니다!");
            });

        }

        //엑셀다운로드
        function selectCrsListExcelDown() {
            var excelGrid = {
                colModel:[
                    {label:'No.',   name:'lineNo',     	align:'center', width:'3000'},
                    {label:"과목분류",	name:'crsTypeNm', 		align:'center', width:'7000'},
                    {label:"구분",  name:'crsOperTypeNm',  	align:'center',	width:'7000'},
                    {label:"과목명",	name:'crsNm',   	align:'center',	width:'10000'},
                    {label:"과목 코드",   	name:'crsCd',		align:'center',	width:'7000'},
                    {label:"사용 여부",	name:'useYn',	align:'center',	width:'5000'}
                ]
            };

            var crsTypeCd = "";

            $("[name=crsTypeCd]:checked").each(function(i, o){
                crsTypeCd += $(this).val() + ",";
            })

            crsTypeCd = crsTypeCd.substring(0, crsTypeCd.length-1);

            $("form[name=excelForm]").remove();
            var excelForm = $('<form name="excelForm" method="post" ></form>');
            excelForm.attr("action", "/crs/crsMgr/selectCrsListExcelDown.do");
            excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 	value: crsTypeCd}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value:JSON.stringify(excelGrid)}));
            excelForm.appendTo('body');
            excelForm.submit();
        }

        /**
         * 과정 관리 폼
         */
        function edit(crsCd, crsCtgrCd) {
            $("#crsListForm").attr("action","/crs/crsMgr/crsWrites.do");
            $("#crsCd").val(crsCd);
            $("#crsCtgrCd").val(crsCtgrCd);
            $("#crsListForm").submit();
        }


        /* 과목 삭제 Confirm */
        function deleteCrsConfirm(crsCd, creCrsCnt) {
            //하위 데이터 체크
            if(creCrsCnt > 0) {
                alert("개설된 과정이 있습니다. 과목을 삭제 할 수 없습니다.");
                return;
            }else{
                if(confirm("과목을 삭제하려고 합니다. 삭제 하시겠습니까?")){
                    deleteCrs(crsCd);
                }

                return;
            }
        }

        /**
         * 과정  삭제
         */
        function deleteCrs(crsCd){
            ajaxCall("/crs/crsMgr/deleteCrs.do", {crsCd : crsCd}, function(data){
                if(data.result > 0){
                    listPaging(1);
                }else{
                    alert("과목 삭제 실패하였습니다.");
                    return;
                }
            }, function(){
                // 요청에 대해 정상적인 응답을 받지 못하였습니다. 관리자에게 문의 하십시오.
                alert('<spring:message code="errors.json" />');
            });
        }

        function fetchSbjctTypeCdList(url) {
            $.ajax({
                url: url,
                success: function(data) {
                    if(data.result > 0) {
                        var returnList = data.returnList || [];
                        var html = '';

                        html += '<option value="all"><spring:message code="crs.label.all" /></option>'; // 과목분류 선택
                        returnList.forEach(function(v, i) {
                            // TODO : Code Nm tag 처리
                            html += '<option value="' + v.cd + '">' + v.cdnm + '</option>';
                        });

                        $("#selectSbjctTyCd").empty();
                        $("#selectSbjctTyCd").off("change");
                        $("#selectSbjctTyCd").html(html);
                        $("#selectSbjctTyCd").trigger("chosen:updated");
                    }
                },
                error: function(xhr) {
                    //Do Something to handle error
                    console.log(xhr);
                }
            });


        }

    </script>
</head>
<body class="admin">
    <div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
    <!-- //common header -->

        <form class="ui form" id="crsListForm" name="crsListForm" method="POST" action="">
            <input type="hidden" id="crsCd" name="crsCd" >
            <input type="hidden" id="crsCtgrCd" name="crsCtgrCd">
        </form>

         <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub_top">
                    <div class="date_info">
                        <i class="icon-svg-calendar" aria-hidden="true"></i>2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                    </div>
                </div>
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">과목 등록</h2>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectOrg">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select chosen" id="selectOrg" onchange="fetchSbjctTypeCdList('/crs/sbjct/adminSbjctTyCdList.do')">
                                        <c:forEach var="org" items="${orgList}">
                                            <option value="${org.orgId}">
                                                <c:out value="${org.orgnm}" />
                                                <c:if test="${not empty org.orgShrtnm}">(${org.orgShrtnm})</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                             <div class="item">
                                <span class="item_tit"><label for="selectDgrsYrChrt">학사년도/학기</label></span>
                                <div class="itemList">
                                    <c:forEach var="item" items="${dgrsYrChrtList}">
                                    <select class="form-select chosen" id="selectDgrsYr">
                                        <option value="${item.dgrsYr}" smstrChrtId="${item.smstrChrtId}">
                                            <c:out value="${item.dgrsYr}년" />
                                        </option>
                                    </select>
                                    <select class="form-select chosen" id="selectDgrsSmstrChrt">
                                        <option value="${item.dgrsSmstrChrt}" smstrChrtId="${item.smstrChrtId}">
                                            <c:out value="${item.smstrChrtNm}" />
                                        </option>
                                    </select>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSbjctTyCd">과목 분류</label></span>
                                <div class="itemList">
                                    <select class="form-select chosen" id="selectSbjctTyCd">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control" type="text" name="" id="searchValue" value="" placeholder="과목명 검색">
                                </div>
                            </div>


                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1);">검색</button>
                            </div>
                        </div>

                        <div id="sbjctListArea">
                            <div class="board_top">
                                <h3 class="board-title">목록</h3>
                                <div class="right-area">
                                    <button type="button" class="btn type2">엑셀 다운로드</button>
                                    <button type="button" class="btn type2">엑셀로 등록</button>
                                    <button type="button" class="btn type1">학사연동 가져오기</button>
                                    <button type="button" class="btn type2" onClick="location.href='/crs/sbjct/adminSbjctWriteView.do'"><spring:message code="button.write" /></button>

                                    <%-- 목록 스케일 선택 --%>
                                    <uiex:listScale func="changeListScale" value="${searchListVO.listScale}" />
                                </div>
                            </div>

                            <%-- 과목 등록 리스트 --%>
                            <div id="sbjctList"></div>

                            <script>
							<%-- 게시글 리스트 테이블 --%>
							let sbjctListTable = UiTable("sbjctList", {
								lang: "ko",
								//tableMode: "list",
								//rowHeight: 30,
								//height: 400,
								//selectRow: "checkbox",
								//selectRow: "1",
								//selectRowFunc: checkRowSelect,
								// sortFunc: atclListTableSort,
								initialSort: [{column:"regDttm", dir:"desc"}],
								pageFunc: listPaging,
								columns: [
									{title:"No", 											field:"no",			headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},	// No
									{title:"<spring:message code='common.label.org'/>", field:"orgId",	headerHozAlign:"center", hozAlign:"left",	width:200,	minWidth:200, 	headerSort:true},	// 기관
									{title:"<spring:message code='common.dept_name'/>", 	field:"deptId", 	headerHozAlign:"center", hozAlign:"center", width:200, 	minWidth:200,	headerSort:true},	// 학과
									{title:"<spring:message code='crs.label.crecrs.ctgr'/>", 	field:"sbjctSmstr", 	headerHozAlign:"center", hozAlign:"center", width:200,	minWidth:200},	// 과목분류(학기제)
									{title:"<spring:message code='crs.label.crsopertypecd'/>", 	field:"sbjctTycd", 	headerHozAlign:"center", hozAlign:"center", width:200,	minWidth:200},	// 강의형태(온라인)
									{title:"<spring:message code='common.label.crsauth.crscd'/>", 		field:"sbjctGbnCd", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 과목코드
									{title:"<spring:message code='crs.label.crecrs.nm'/>", 	field:"sbjctnm", 	headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100},	// 과목명
									{title:"<spring:message code='main.common.use.yn'/>", 	field:"userYn", 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 사용여부
									{title:"<spring:message code='common.mgr'/>", 	        field:"mgr", 	headerHozAlign:"center", hozAlign:"center",	width:140,	minWidth:140},	// 관리

								]
							});


							function atclListTableSort(sortInfo) {
								console.log("field="+sortInfo.field+", dir="+sortInfo.dir);

								listPaging(1);
							}

							function checkSelect() {
								// 선택된값 array로 가져온다.
								let data = sbjctListTable.getSelectedData("valSbjctMstrId"); // "valSbjctMstrId" 키로 설정된 값
								alert(data);
							}

							function checkRowSelect(data) {
								let value = data["valSbjctMstrId"]; // "valSbjctMstrId" 키로 설정된 값
								alert(value);
							}

							function changePage(page) {
								alert("페이지 "+page);
							}

							function testMessage() {
								UiComm.showMessage("메시지 내용 테스트입니다.", "confirm")
								.then(function(result) {
									if (result) {
										// true 처리
									}
									else {
										// false 처리
									}
								});
							}
							</script>


                            </div>
                        </div>
                        <!--//table-type-->
                    </div>
                    <!-- //sub-content -->

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->
    </div>
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</body>
</html>

