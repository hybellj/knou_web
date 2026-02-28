<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <title>교수자 토론 목록</title>
</head>
<body class="class colorA">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <jsp:include page="/WEB-INF/jsp/common_new/navi_bar_prof.jsp"/>

            <div class="class_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">토론</h2>
                    </div>

                    <!-- search typeA -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="dscsTtl"><spring:message code="common.search.keyword"/></label></span>
                            <div class="itemList">
                                <input class="form-control wide" type="text" id="dscsTtl" name="dscsTtl" placeholder="<spring:message code="forum.button.forumNm.input"/>"/>
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1);">검색</button>
                        </div>
                    </div>

                    <!-- List 영역 -->
                    <div id="forumListArea">
                        <div class="board_top">
                            <h3 class="board-title">목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" id="btn_scroe_ratio"><spring:message code="forum.button.scoreRatio.change" /></button><!-- 성적반영비율조정 -->
                                <button type="button" class="btn type2" id="btnGoRegist"><spring:message code="button.write.forum" /></button><!-- 토론 등록 -->

                                <%-- 리스트/카드 선택 버튼 --%>
                                <span class="list-card-button"></span>

                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${forum2ListVO.listScale}" />
                            </div>
                        </div>

                        <%-- 리스트 --%>
                        <div id="forumList"></div>

                        <%-- 카드 폼 --%>
                        <div id="forumList_cardForm" style="display:none">
                            <div class="card-header">
                                #[label]
                                <div class="card-title">
                                    #[dscsTtl]
                                </div>
                            </div>
                            <!-- TODO : 참여현황 (비교바) -->
                            <div class="ml20 mt20">
                                <!-- 참여기간 -->
                                <span class="item_tit"><spring:message code='forum.label.forum.date'/> : #[dscsSdttmEdtm]</label></span><br/>
                                <!-- 성적 반영비율 -->
                                <span class="item_tit"><spring:message code='forum.label.score.ratio'/> : #[scoreRate]</label></span><br/>
                                <!-- 평가현황 -->
                                <span class="item_tit"><spring:message code='forum.label.eval.status'/> : #[mrkStatus]</label></span><br/>
                                <!-- 성적공개 -->
                                <span class="item_tit"><spring:message code='forum.label.score.open'/> : #[mrkOyn]</label></span><br/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
    var SEARCH_VALUE	= '<c:out value="${forum2ListVO.dscsTtl}" />';
    var PAGE_INDEX		= '<c:out value="${forum2ListVO.pageIndex}" />';
    var LIST_SCALE		= '<c:out value="${forum2ListVO.listScale}" />';
    var EPARAM			= '<c:out value="${eparam}" />';

    $(document).ready(function() {
        // 최초 조회
        listPaging(1);
        // 엔터키
        $("#dscsTtl").on("keydown", function(e) {
            if(e.keyCode == 13) {
                listPaging(1);
            }
        });

        $('#btnSearch').on('click', function () {
            $('#pageIndex').val('1');
            listPaging();
        });

        $('#btnGoRegist').on('click', function () {
            location.href = '<c:url value="/forum2/forumLect/profForumWriteView.do" />';
        });

        if(!PAGE_INDEX) {
            PAGE_INDEX = 1;
        }

        if(!LIST_SCALE) {
            LIST_SCALE = 10;
        }
    });

    <%-- 리스트 테이블 --%>
    let forumListTable = UiTable("forumList", {
    lang: "ko",
    tableMode: "list",
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
        {title:"<spring:message code='forum.label.type'/>", field:"dscsUnitTycd",	headerHozAlign:"center", hozAlign:"left",	width:200,	minWidth:200, 	headerSort:true},	// 구분
        {title:"<spring:message code='forum.label.forum'/>", 	field:"dscsTtl", 	headerHozAlign:"center", hozAlign:"left", width:0, 	minWidth:200,	headerSort:true},	// 토론제목
        {title:"<spring:message code='forum.label.forum.date'/>", 	field:"dscsSdttmEdtm", 	headerHozAlign:"center", hozAlign:"center", width:300,	minWidth:300},	// 토론기간
        {title:"<spring:message code='forum.label.forum.bbsCnt'/>", 	field:"dscsAtclCnt", 	headerHozAlign:"center", hozAlign:"center", width:200,	minWidth:200},	// 토론글수
        {title:"<spring:message code='forum.label.forum.commCnt'/>", 		field:"dscsCmntCnt", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 댓글수
        {title:"<spring:message code='forum.label.score.ratio'/>", 	field:"scoreRate", 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 성적 반영비율
        {title:"<spring:message code='forum.label.status.join'/>", 	field:"joinCnt", 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 참여현황
        {title:"<spring:message code='forum.label.eval.status'/>", 	field:"mrkStatus", 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 평가현황
        {title:"<spring:message code='forum.label.score.open'/>", 	field:"mrkOyn", 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 성적공개
        ]
    });

    function checkSelect() {
        // 선택된값 array로 가져온다.
        let data = forumListTable.getSelectedData("valDscsId"); // "valDscsId" 키로 설정된 값
        alert(data);
    }

    function checkRowSelect(data) {
        let value = data["valDscsId"]; // "valDscsId" 키로 설정된 값
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

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

    function parseResult(data) {
        return {
            code: data.resultCode || data.result || data.resultStatus || 0,
            message: data.resultMessage || data.message || '',
            status: data.resultStatus || data.resultCode || data.result || 0
        };
    }

    //리스트 조회
    function listPaging(pageIndex) {
        PAGE_INDEX = pageIndex;

        var param = {
            pageIndex		: pageIndex
            , listScale		: LIST_SCALE
            , dscsTtl       : $("#dscsTtl").val()
        };

        var url = '<c:url value="/forum2/forumLect/profForumList.do" />';

        UiComm.showLoading(true);
        ajaxCall(url, param, function(data) {
            if (data.result > 0) {
                let returnList = data.returnList || [];

                // 테이블 데이터 설정
                let dataList = createForumListHTML(returnList, data.pageInfo);
                forumListTable.clearData();
                forumListTable.replaceData(dataList);
                forumListTable.setPageInfo(data.pageInfo);
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            alert("에러가 발생했습니다!");
        });
    }

    function createForumListHTML(forumList, pageInfo) {
        let dataList = [];
        if(forumList.length === 0) {
            return dataList;
        }

        forumList.forEach(function(v, i) {
            var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

            let col0 = "";
            let colLabel = "";
            col0 = lineNo;

            let mrkOynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyMrkOyn(this, \'' + v.sbjctMstrId + '\', this.checked)"';
            if(v.mrkOyn === 'Y') {
                mrkOynHtml += '	checked="checked">';
            } else {
                mrkOynHtml += '>';
            }

            var dscsTtl = v.dscsTtl.replaceAll("<", "&lt").replaceAll(">", "&gt");
            var linkUrl = 'javascript:goWrite(\''+v.dscsId+'\')';

            let title = "";
            title += '<a href="'+linkUrl+'" title="'+dscsTtl+'">';
            title += dscsTtl;
            title += '</a>';

            dataList.push({
                no: col0,
                dscsUnitTycd: v.dscsUnitTycd,
                dscsTtl: title,
                dscsSdttmEdtm: v.dscsSdttm + '~' + v.dscsEdttm,
                dscsAtclCnt: '0',
                dscsCmntCnt: '0',
                scoreRate: '0/0',
                joinCnt: '0/0',
                mrkStatus: '0/0',
                mrkOyn: mrkOynHtml,
                valDscsId: v.dscsId,
                label: colLabel
            });
        });

        return dataList;
    }

    //사용여부 수정
    function modifyMrkOyn(el, dscsId){
        alert('modifyMrkOyn:' + dscsId);
        /*
      var $el = $(el);
      var isChecked = $el.is(":checked");

      $el.prop("disabled", true);
      var param = {
          sbjctMstrId     : dscsId
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
      */

    }

    function showError(message) {
        var msg = message || '처리 중 오류가 발생했습니다.';
        alert(msg);
    }

    function goWrite(dscsId) {
        if (dscsId != null && dscsId != "") {
            location.href = '<c:url value="/forum2/forumLect/profForumEditView.do" />?dscsId=' + encodeURIComponent(dscsId);
        } else {
            location.href = '<c:url value="/forum2/forumLect/profForumWriteView.do" />';
        }
    }
</script>
</body>
</html>
