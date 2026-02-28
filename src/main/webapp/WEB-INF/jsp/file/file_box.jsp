<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />

<script type="text/javascript">
    var selectedFileBoxCd = "ROOT";

    $(document).ready(function() {
        $("#searchValue").on("keydown", function(e) {
            if(e.keyCode == 13) {
                listFileBox();
            }
        });

        // 트리메뉴 조회
        listFileBoxTree();
        
        // 파일함 사용률 조회
        getFileBoxUseRate();
    });

    // 트리메뉴 조회
    function listFileBoxTree() {
        var url = "/file/fileHome/listFileBoxTree.do";
        var data = {
        };

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                var returnList = data.returnList || [];

                $("#fileBoxTreeMenu").empty();
                setTree(returnList, 1);
                // 최상위 폴더 추가
                var html = '<span class="folder cur_point" onclick="javascript:setMenuTreeItem(\'ROOT\')"><spring:message code="filemgr.label.file.box" /></span>';// 자료실
                $("#fileBoxTreeMenu").prepend(html);

                // tree 설정
                $("#fileBoxTreeMenu li").droppable({
                    drop: function( event, ui ) {
                        moveFileBox($(this).find("span[name=spFileBoxFolder]").attr("data-folderId"));
                    }
                });

                $("#fileBoxTreeMenu").treeview({
                    collapsed: true,
                    unique: false,
                });
                
                if(selectedFileBoxCd == "ROOT") {
                    listFileBox();
                } else {
                    // 선택된 목록 펼치기
                    var fileBoxCdList = getParFileBoxCdList([selectedFileBoxCd], selectedFileBoxCd) || [];
                    
                       fileBoxCdList.reverse().forEach(function(fileBoxCd, i) {
                         $("[data-file-box-cd=" + fileBoxCd + "]").trigger("click");
                       });
                       setMenuTreeItem(selectedFileBoxCd);
                }

                // 메뉴 클릭 이벤트 세팅
                $("[data-file-box-cd]").on("click", function() {
                       var fileBoxCd = $(this).data("fileBoxCd");
                       setMenuTreeItem(fileBoxCd);
                   });
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            // 에러가 발생했습니다!
            alert('<spring:message code="fail.common.msg" />');
        });
    }

    // 부모 폴더 겁색
    function getParFileBoxCdList(list, fileBoxCd) {
        var parFileBoxCd = $("[data-file-box-cd=" + fileBoxCd + "]").parent("li").parent("ul").data("folderFileBoxCd");

        if(parFileBoxCd) {
            list.push(parFileBoxCd);
            getParFileBoxCdList(list, parFileBoxCd);
        }
        
        return list;
    }

    // 트리메뉴 설정
    function setTree(list, depth) {
        var nextList = [];
        
        list.forEach(function(v, i) {
            if(v.depth == depth) {
                var html = '';
                html += '<li>'
                html += '	<span class="folder" data-file-box-cd="' + v.fileBoxCd + '" data-folder-nm="' + v.folderNm + '">' + v.folderNm + '</span>';
            if(v.childrenCnt != "0") {
                html += '	<ul data-folder-file-box-cd="' + v.fileBoxCd + '"></ul>';
            }
                html += '</li>';

                if(v.parFileBoxCd) {
                    $("[data-folder-file-box-cd=" + v.parFileBoxCd + "]").append(html);
                } else {
                    $("#fileBoxTreeMenu").append(html);
                }
            } else {
                nextList.push(v);
            }
        });

        if(nextList.length != 0) {
            setTree(nextList, ++depth);
        } else {
            $.each($("[data-folder-file-box-cd]"), function() {
                if($(this).find("li").length == 0) {
                    $(this).remove();
                }
            });
        }
    }

    // 메뉴트리 아이템 선택
    function setMenuTreeItem(fileBoxCd) {
        // 중복선택 방지
        var isSelected = $("[data-file-box-cd=" + fileBoxCd + "]").parent("li").hasClass("selected");

        if(isSelected) {
            return; 
        } else {
            $("[data-file-box-cd]").parent("li").removeClass("selected");
            $("[data-file-box-cd=" + fileBoxCd + "]").parent("li").addClass("selected");
            selectedFileBoxCd = fileBoxCd;
            
            listFileBox();
        }
    }

    // 파일목록 조회
    function listFileBox() {
        var url = "/file/fileHome/listFileBox.do";
        var data = {
              selectedFileBoxCd: selectedFileBoxCd
            , searchValue: $("#searchValue").val()
        };

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                var returnList = data.returnList || [];
                var html = '';

                returnList.forEach(function(v, i) {
                	var fileBoxFullNmOrder = v.fileBoxTypeCd == "FOLDER" ? "AAAA_" + v.fileBoxFullNm : "BBBB_" + v.fileBoxFullNm;
                	var regDttmOrder = v.fileBoxTypeCd == "FOLDER" ? "AAAA_" + v.regDttm : "BBBB_" + v.regDttm;
                	var fileSizeOrder = v.fileBoxTypeCd == "FOLDER" ? "FOLDER" : (v.fileSize || "-1");
                	
                    var icon = '';

                    if(v.fileBoxTypeCd == "FOLDER") {
                        icon = '<img src="/webdoc/img/home_sub/folder-closed.gif" />';
                    } else if(v.fileBoxTypeCd == "DOC") {
                        icon = '<i class="file alternate outline icon f120 vm mr10"></i>';
                    } else if(v.fileBoxTypeCd == "MOV") {
                        icon = '<i class="file video outline icon f120 vm mr10"></i>';
                    } else if(v.fileBoxTypeCd == "IMG") {
                        icon = '<i class="file image outline icon f120 vm mr10"></i>';
					} else if(v.fileBoxTypeCd == "ETC") {
                         icon = '<i class="file archive outline icon f120 vm mr10"></i>';
					}
					if(v.fileBoxTypeCd != "FOLDER") {
						html += '<input type="hidden" value="' + v.downloadUrl + '" id="downloadUrl' + i + '" />';
					}
                    html += '<tr>';
                    html += '	<td>';
                    html += '		<div class="ui checkbox">';
                    html += '			<input type="checkbox" name="fileBoxCds" value="' + v.fileBoxCd + '" />';
                    html += '		</div>';
                    html += '	</td>';
                    html += '	<td class="tl" data-sort-value="' + fileBoxFullNmOrder + '">';
					if(v.fileBoxTypeCd == "FOLDER") {
						html += '	<a id="fileBoxNmLink' + i + '" href="javascript:void(0)" onclick="moveFolder(\'' + v.fileBoxCd + '\')">' + icon + v.fileBoxFullNm + '</a>';
					} else {
						html += '	<span id="fileBoxNmLink' + i + '" onclick="trToggle(this)">' + icon + v.fileBoxFullNm + '</span>';
					}
                    html += '		<div id="fileBoxNmEdit' + i + '" class="ui action input w150" style="display:none;">';
                    html += '			<input type="text" value="' + v.fileBoxNm + '" maxlength="50" id="fileBoxNm' + i + '" data-origin-file-box-nm="' + v.fileBoxNm + '">';
                    html += '			<span class="ui basic button img-button">';
                    html += '				<button type="button" class="icon_check" onclick="editFileNm(\'' + v.fileBoxCd + '\', ' + i + ')"></button>';
                    html += '				<button type="button" class="icon_cancel" onclick="cancelFileNmEditMode(' + i + ')"></button>';
                    html += '			</span>';
                    html += '		</div>';
                    html += '	</td>';
                    html += '	<td data-sort-value="' + regDttmOrder + '">' + v.regDt + '</td>';
                    html += '	<td data-sort-value="' + fileSizeOrder + '">' + (v.fileSize ? v.fileSizeFormatted : '-') + '</td>';
                    html += '	<td>';
                    html += '		<div class="ui basic small buttons">'
                    html += '			<a href="javascript:void(0)" onclick="fileBoxDetailModal(\'' + v.fileBoxCd + '\')" class="ui button"><spring:message code="filebox.button.detail" /></a>'; // 상세정보
                    
					if(v.fileBoxTypeCd == "FOLDER") {
						html += '		<a href="javascript:void(0)" class="ui button disabled"><spring:message code="filebox.button.urlcopy" /></a>';
					} else {
						html += '		<a href="javascript:void(0)" onclick="copyClipBoard(' + i + ')" class="ui button"><spring:message code="filebox.button.urlcopy" /></a>'; // URL복사
					}
                    html += '		</div>'
					html += '		<div class="ui basic small buttons">'
					if(v.fileBoxTypeCd == "FOLDER") {
                       html += '		<a href="javascript:void(0)" class="ui button disabled"><spring:message code="filebox.button.download" /></a>'; // 다운로드
					} else {
                       html += '		<a href="javascript:void(0)" onclick="fileDown(\'' + v.fileSn + '\')" class="ui button"><spring:message code="filebox.button.download" /></a>'; // 다운로드
					}
                    html += '			<a href="javascript:void(0)" onclick="changeFileNmEditMode(' + i + ')" class="ui button"><spring:message code="filebox.button.nmmodify" /></a>'; // 이름변경
                    html += ' 		</div>'
                    html += '	</td>';
                    html += '</tr>';
                });

                $("#fileList").html(html);
                $("#fileListTable").footable({
                	on: {
                		"before.ft.sorting": function(e, ft, sorter) {
                			var direction = sorter.direction || "ASC";
                			var name = sorter.column.name;
                			var index = sorter.column.index;
                			
							ft.rows.array.forEach(function(v, i) {
								if(v.cells.length > 0) {
									var cell = v.cells[index];
									var sortValue = cell.sortValue || "";
									
									if(name == "fileBoxFullNm" || name == "regDttm") {
										if(direction == "ASC") {
											if(cell.sortValue.indexOf("CCCC_") > -1) {
												cell.sortValue = cell.sortValue.replace("CCCC_", "BBBB_");
											} else if(cell.sortValue.indexOf("DDDD_") > -1) {
												cell.sortValue = cell.sortValue.replace("DDDD_", "AAAA_");
											}
										} else {
											if(cell.sortValue.indexOf("AAAA_") > -1) {
												cell.sortValue = cell.sortValue.replace("AAAA_", "DDDD_");
											} else if(cell.sortValue.indexOf("BBBB_") > -1) {
												cell.sortValue = cell.sortValue.replace("BBBB_", "CCCC_");
											}
										}
										cell.$el.data("sortValue", cell.sortValue);
									} else if(name == "fileSize") {
									}
								}
							});
                		}
                	}
                });
                $(".ui.checkbox").checkbox();

                var folderNm;
                if(selectedFileBoxCd == "ROOT") {
                    folderNm = "MyFileBox";
                } else {
                    var folderNm = $("[data-file-box-cd=" + selectedFileBoxCd + "]").data("folderNm");
                }

                $("#folderNmText").text(folderNm);
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            // 에러가 발생했습니다!
            alert('<spring:message code="fail.common.msg" />');
        });
    }

    // 파일명 클릭
    function trToggle(obj) {
        $(obj).closest("tr").trigger("click");
    }

    // 파일함 사용률 조회
    function getFileBoxUseRate() {
        var url = "/file/fileHome/fileBoxUseRate.do";
        var data = {
        };
        
        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                var returnVO = data.returnVO;
                var rateStr = '<spring:message code="filemgr.label.auth.size" />'; // 용량
                var fileUseRate = 0;

                fileUseRate = returnVO.fileUseRate;
                rateStr = formatBytes(returnVO.fileUseSize) + ' / ' + formatBytes(returnVO.fileLimitSize) + ' (' + returnVO.fileUseRate + '% <spring:message code="filebox.label.main.use" />)'; // 사용중

                $("#fileBoxUseRateBlock").attr("data-percent", fileUseRate);
                $("#fileBoxUseRate").text(rateStr);
                $('#fileBoxUseRateBlock').progress({
                    percent: fileUseRate > 100 ? 100 : fileUseRate
                });
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            // 에러가 발생했습니다!
            alert('<spring:message code="fail.common.msg" />');
        });
    }

    // byte 포멧 변환
    function formatBytes(bytes) {
        if (bytes === 0) return '0 Bytes';
        var decimals = 2;
        var k = 1024;
        var dm = decimals < 0 ? 0 : decimals;
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
        var i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    }

    // 폴더생성 버튼
    function createFolder() {
        // 중복실행 방지
        if($("#newFolderRow").length != 0) return;

        if($("#fileList > tr.footable-empty").length > 0) {
            $("#fileList > tr.footable-empty").remove();
        }

        var html = '';

        html += '<tr id="newFolderRow">';
        html += '	<td></td>';
        html += '	<td class="tl">';
        html += '		<div class="ui action input w150">';
        html += '			<input type="text" value="" maxlength="50" id="fileBoxNm" />';
        html += '			<span class="ui basic button img-button">';
        html += '				<button type="button" class="icon_check" id="createNewFolderBtn"></button>';
        html += '				<button type="button" class="icon_cancel" id="cancelNewFolderBtn"></button>';
        html += '			</span>';
        html += '		</div>';
        html += '	</td>';
        html += '	<td></td>';
        html += '	<td></td>';
        html += '	<td></td>';
        html += '</tr>';

        $("#fileList").prepend(html);
        $("#fileListTable").footable();
        $(".ui.checkbox").checkbox();

        // 폴더생성 ok
        $("#createNewFolderBtn").on("click", function() {
            var url = "/file/fileHome/createFolder.do";
            var data = {
                  fileBoxNm: $("#fileBoxNm").val()
                , parFileBoxCd: (selectedFileBoxCd == "ROOT" ? null : selectedFileBoxCd)
            };
            
            ajaxCall(url, data, function(data) {
                if(data.result > 0) {
                    listFileBoxTree();
                } else {
                    alert(data.message);
                }
            }, function(xhr, status, error) {
                // 에러가 발생했습니다!
                alert('<spring:message code="fail.common.msg" />');
            });
        });
        
        // 폴더생성 cancel
        $("#cancelNewFolderBtn").on("click", function() {
            $("#newFolderRow").remove();
            $("#fileListTable").footable();
            $(".ui.checkbox").checkbox();
        });
    }

    // 삭제 버튼
    function deleteFileBox() {
        if($("input:checkbox[name=fileBoxCds]:checked").length == 0) {
            // 선택한 폴더(파일)이 없습니다.
            alert('<spring:message code="filebox.alert.no.select" />');
            return;
        }
        
        // 선택한 폴더(파일)을 삭제하시겠습니까?
        if(!confirm('<spring:message code="filebox.confirm.filedel" />')) {
            return;
        }

        var url = "/file/fileHome/deleteFileBox.do";
        var data = $("#checkFileBoxForm").serialize();

        ajaxCall(url, data, function(data) {
            if(data.result > 0) {
                // 성공적으로 작업을 완료하였습니다.
                alert('<spring:message code="common.result.success" />');
                $("#searchValue").val("");
                getFileBoxUseRate(); // 파일함 사용률 조회
                listFileBoxTree();
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            // 에러가 발생했습니다!
            alert('<spring:message code="fail.common.msg" />');
        });
    }

    // 리스트 전체 선택/해제
    function checkAll(checked) {
        $("input:checkbox[name=fileBoxCds]").prop("checked", checked);
    }

    // URL복사
    function copyClipBoard(order) {
        var url = new URL(location.href);
        url = url.origin + $("#downloadUrl" + order).val();
        
        var $textarea = document.createElement("textarea");

        document.body.appendChild($textarea);

        $textarea.value = url;
        $textarea.select();

        document.execCommand('copy');
        document.body.removeChild($textarea);
        alert('<spring:message code="filebox.alert.copy.clipboard" />');
    }

    // 다운로드
    function fileDown(fileSn) {
    	var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : fileSn,
			"repoCd" : "FILE_BOX"
		};
		
		ajaxCall(url, data, function(data) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "downloadForm");
			form.attr("id", "downloadForm");
			form.attr("target", "downloadIfm");
			form.attr("action", data);
			form.appendTo("body");
			form.submit();
			
			$("#downloadForm").remove();
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		}); 
    }

    // 이름변경 모드
    function changeFileNmEditMode(order) {
        // 입력 초기화
        $.each($("[data-origin-file-box-nm]"), function() {
            var order = this.id.replace("fileBoxNm", "");
            cancelFileNmEditMode(order);
        });

        $("#fileBoxNmLink" + order).hide();
        $("#fileBoxNmEdit" + order).show();
    }

    // 이름변경 모드 취소
    function cancelFileNmEditMode(order) {
        $("#fileBoxNmLink" + order).show();
        $("#fileBoxNmEdit" + order).hide();

        var originFileBoxNm = $("#fileBoxNm" + order).data("originFileBoxNm");
        $("#fileBoxNm" + order).val(originFileBoxNm);
    }

    // 이름변경
    function editFileNm(fileBoxCd, order) {
        var fileBoxNm = $("#fileBoxNm" + order).val();

        if ($.trim(fileBoxNm) == '') {
            return;
        }

        if (!isValidFileBoxNm(fileBoxNm)) {
            alert('<spring:message code="filebox.alert.notallow.specialchar" />');
            return;
        }

        var url = "/file/fileHome/updateFileBoxNm.do";
        var data = {
            fileBoxCd : fileBoxCd,
            fileBoxNm : fileBoxNm
        };

        ajaxCall(url, data, function(data) {
            if (data.result > 0) {
                // 성공적으로 작업을 완료하였습니다.
                alert('<spring:message code="common.result.success" />');
                listFileBoxTree();
            } else {
                alert(data.message);
            }
        }, function(xhr, status, error) {
            // 에러가 발생했습니다!
            alert('<spring:message code="fail.common.msg" />');
        });
    }

    // 리스트에서 폴더 이동
    function moveFolder(fileBoxCd) {
        $("#searchValue").val("");
        selectedFileBoxCd = fileBoxCd;
        listFileBoxTree();
    }

    // 파일명 특수문자 검사
    function isValidFileBoxNm(str) {
        var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?<>]/gi;
        if (special_pattern.test(str) == true) {
            return false;
        } else {
            return true;
        }
    }

    // 상세정보 보기 모달
    function fileBoxDetailModal(fileBoxCd) {
        $("#fileBoxDetailForm > input[name='selectedFileBoxCd']").val(fileBoxCd);
        $("#fileBoxDetailForm").attr("target", "fileBoxDetailModalIfm");
        $("#fileBoxDetailForm").attr("action", "/file/fileHome/popup/fileBoxDetail.do");
        $("#fileBoxDetailForm").submit();
        $('#fileBoxDetailModal').modal('show');
    }

    // 업로드 모달
    function fileBoxUploadModal() {
        $("#fileBoxUploadForm > input[name='parFileBoxCd']").val(selectedFileBoxCd);
        $("#fileBoxUploadForm").attr("target", "fileBoxUploadModalIfm");
        $("#fileBoxUploadForm").attr("action", "/file/fileHome/popup/fileBoxUpload.do");
        $("#fileBoxUploadForm").submit();
        $('#fileBoxUploadModal').modal('show');
    }

    // 업로드 콜백
    function fileBoxUploadCallBack() {
        getFileBoxUseRate(); // 파일함 사용률 조회
        listFileBox(); // 파일목록 조회
    }
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">

<div id="wrap" class="main">
    <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content">

            <div class="ui form">
                <div class="layout2">
                
                    <div class="classInfo">
                        <div class="mra">
                            <h2 class="page-title"><spring:message code="filemgr.label.my.file.box" /><!-- 개인자료실 --></h2>
                        </div>
                        <div class="button-area">
                            <a href="javascript:void(0);" class="ui bcPurpleAlpha85 button" onclick="createFolder()"><spring:message code="filebox.button.create.foler" /><!-- 폴더생성 --></a>
                            <a href="javascript:void(0);" class="ui bcTealAlpha85 button" onclick="fileBoxUploadModal()"><spring:message code="filebox.button.upload" /><!-- 업로드 --></a>
                            <a href="javascript:void(0);" class="ui bcDarkblueAlpha85 button" onclick="deleteFileBox()"><spring:message code="filebox.button.del" /><!-- 삭제 --></a>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-left">
                            <div class="option-content header2">
                                <div class="sec_head mra"><spring:message code="filebox.label.tree.title" /><!-- 내 파일 --></div>
                            </div>
                            <div class="file-bar f080 mb20">
                                   <div class="ui blue small wf100 f080 progress" data-percent="0" id="fileBoxUseRateBlock">
                                    <div class="bar" style="transition-duration: 300ms; width: 0%;"></div>
                                    <div class="label" id="fileBoxUseRate">0MB / 0MB (0% <spring:message code="filebox.label.main.use" /><!-- 사용중 -->)</div>
                                </div>
                               </div>
                            <ul id="fileBoxTreeMenu" class="filetree treeview"></ul>
                        </div>
                        <div class="mainCnt">
                            <div class="option-content header2">
                                <div class="sec_head" id="folderNmText">MyFileBox</div>
                            </div>
                            <div class="ui action input search-box mb10">
                            	<label for="searchValue" class="hide"><spring:message code="common.search.keyword"/></label>
                                <input type="text" placeholder="<spring:message code="common.search.keyword"/>" id="searchValue" name="searchValue" maxlength="50" />
                                <button type="button" class="ui icon button" id="btnFileBoxSearch" onclick="listFileBox()">
                                    <i class="search icon"></i>
                                </button>
                            </div>
                            <form id="checkFileBoxForm" name="checkFileBoxForm">
                                <table id="fileListTable" class="table type2 footable footable-1 breakpoint-w_lg" data-sorting="true" data-paging="false" data-empty="<spring:message code="filebox.common.empty" />">
                                	<caption class="hide">file list</caption>
                                    <thead>
                                        <tr>
                                            <th scope="col" data-sortable="false" class="chk">
                                                <div class="ui checkbox">
                                                	<label for="fileCheckAll" class="hide">Check all</label>
						                            <input id="fileCheckAll" type="checkbox" onchange="checkAll(this.checked)" />
                                                </div>
                                            </th>
                                            <th scope="col" data-name="fileBoxFullNm"><spring:message code="filebox.label.list.filenm" /><!-- 파일명 --></th>
                                            <th scope="col" data-name="regDttm" data-breakpoints="xs"><spring:message code="filebox.label.list.createdt" /><!-- 생성일 --></th>
                                            <th scope="col" data-name="fileSize" data-breakpoints="xs"><spring:message code="filebox.label.list.size" /><!-- 크기 --></th>
                                            <th scope="col" data-breakpoints="xs sm md lg" data-sortable="false"><spring:message code="filebox.label.list.manage" /><!-- 관리 --></th>
                                        </tr>
                                    </thead>
                                    <tbody id="fileList">
                                    </tbody>
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div><!-- //content stu_section -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>

    </div><!-- //container -->

</div><!-- //wrap -->

    <!-- 상세정보 --> 
    <form id="fileBoxDetailForm" name="fileBoxDetailForm">
        <input type="hidden" name="selectedFileBoxCd" />
    </form>
    <div class="modal fade in" id="fileBoxDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="filebox.label.pop.detailinfo" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="filebox.label.pop.detailinfo" /><!-- 상세정보 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="fileBoxDetailModalIfm" name="fileBoxDetailModalIfm" title="<spring:message code="filebox.label.pop.detailinfo" />"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- 업로드  --> 
    <form id="fileBoxUploadForm" name="fileBoxUploadForm">
        <input type="hidden" name="parFileBoxCd" />
    </form>
    <div class="modal fade in" id="fileBoxUploadModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="filebox.button.upload" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="exam.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="filebox.button.upload" /><!-- 업로드 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="fileBoxUploadModalIfm" name="fileBoxUploadModalIfm" title="<spring:message code="filebox.button.upload" />"></iframe>
                </div>
            </div>
        </div>
    </div>
    <iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="download"></iframe>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>