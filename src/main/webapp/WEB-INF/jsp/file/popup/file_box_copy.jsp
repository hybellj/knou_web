<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript" src="/webdoc/js/jquery.treeview.js"></script>
   	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<style type="text/css">
		/* 트리메뉴 높이제한 */
		#fileBoxTreeMenu {
		    max-height: 300px !important;
    		overflow: auto;
		}
		
		/* 파일 리스트 높이제한 */
		.footable_box {
			max-height: 230px !important;
		}
	</style>
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
	            			icon = '<i class="folder outline icon f120 vm mr10"></i>';
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
	        			html += '		<div class="ui checkbox ' + (v.fileBoxTypeCd == "FOLDER" ? 'disabled' : '') + '">';
	        			html += '			<input type="checkbox" name="fileBoxCds" value="' + v.fileBoxCd + '" ' + (v.fileBoxTypeCd == "FOLDER" ? 'disabled' : '') + ' />';
	        			html += '		</div>';
	        			html += '	</td>';
	        			html += '	<td class="tl" data-sort-value="' + fileBoxFullNmOrder + '">';
        			if(v.fileBoxTypeCd == "FOLDER") {
        				html += '		<a id="fileBoxNmLink' + i + '" href="javascript:void(0)" onclick="' + (v.fileBoxTypeCd == "FOLDER" ? 'moveFolder(\'' + v.fileBoxCd + '\')' : '') + '">' + icon + v.fileBoxFullNm + '</a>';
        			} else {
        				html += '		<span id="fileBoxNmLink' + i + '">' + icon + v.fileBoxFullNm + '</span>';
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
	       				html += '			<a href="javascript:void(0)" class="ui button disabled"><spring:message code="filebox.button.urlcopy" /></a>';
	       			} else {
	       				html += '			<a href="javascript:void(0)" onclick="copyClipBoard(' + i + ')" class="ui button"><spring:message code="filebox.button.urlcopy" /></a>'; // URL복사
	       			}
	        			html += '		</div>'
	       				html += '		<div class="ui basic small buttons">'
	       			if(v.fileBoxTypeCd == "FOLDER") {
	       				html += '			<a href="javascript:void(0)" class="ui button disabled"><spring:message code="filebox.button.download" /></a>'; // 다운로드
	       			} else {
	       				html += '			<a href="javascript:void(0)" onclick="fileDown(\'' + v.fileSn + '\')" class="ui button"><spring:message code="filebox.button.download" /></a>'; // 다운로드
	       			}
	        			html += '			<a href="javascript:void(0)" onclick="changeFileNmEditMode(' + i + ')" class="ui button"><spring:message code="filebox.button.nmmodify" /></a>'; // 이름변경
	        			html += '		</div>'
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
		
		// 리스트 전체 선택/해제
		function checkAll(checked) {
			$("input:checkbox[name=fileBoxCds]:not(:disabled)").prop("checked", checked);
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
		
		// 파일 가져오기
		function getFile() {
			if($("input:checkbox[name=fileBoxCds]:checked").length == 0) {
				// 선택한 폴더(파일)이 없습니다.
				alert('<spring:message code="filebox.alert.no.select" />');
	            return;
	        }
			
			var url = "/file/fileHome/listFileBoxFileInfo.do";
			var data = $("#checkFileBoxForm").serialize();
			var type = "${vo.menuType}";

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		if(type != "dext" && typeof window.parent.UiFileUploader_addFromFileBox === "function") {
						window.parent.UiFileUploader_addFromFileBox(data.returnList);
						window.parent.closeFileBox();
					} else if (type == "dext" && typeof window.parent.addDextFromFileBox === "function") {
						window.parent.addDextFromFileBox("${vo.tabCd}", data.returnList);
						window.parent.closeFileBox();
	        		} else {
						// 에러가 발생했습니다!
						alert('<spring:message code="fail.common.msg" />');
					}
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				// 에러가 발생했습니다!
				alert('<spring:message code="fail.common.msg" />');
			});
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<div class="option-content">
				<div class="ui action input search-box">
                    <input type="text" placeholder="<spring:message code="common.button.search" />" id="searchValue" name="searchValue" maxlength="50" />
                    <button type="button" class="ui icon button" id="btnFileBoxSearch" onclick="listFileBox()">
                        <i class="search icon"></i>
                    </button>
                </div>
				<div class="button-area flex-left-auto">
				</div>
			</div>
			<div class="ui segment mt10">
				<span class="label"><spring:message code="filebox.label.tree.title" /><!-- 내 파일 --></span>
				<div class="ui divider"></div>
				<a href="javascript:setMenuTreeItem('ROOT');"><i class="grey archive icon"></i>MyFileBox</a>
				<ul id="fileBoxTreeMenu" class="filetree treeview">
				</ul>
			</div>
			<div class="ui segment mt10">
				<span class="label" id="folderNmText">MyFileBox</span>
				<div class="ui divider"></div>
				<form id="checkFileBoxForm" name="checkFileBoxForm">
					<table id="fileListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="filebox.common.empty" />">
						<thead>
							<tr>
								<th scope="col" data-sortable="false" class="chk">
                                    <div class="ui checkbox">
                                        <input type="checkbox" onchange="checkAll(this.checked)" />
                                    </div>
                                </th>
								<th scope="col" data-name="fileBoxFullNm"><spring:message code="filebox.label.list.filenm" /><!-- 파일명 --></th>
								<th scope="col" data-name="regDttm" data-breakpoints="xs"><spring:message code="filebox.label.list.createdt" /><!-- 생성일 --></th>
								<th scope="col" data-name="fileSize" data-breakpoints="xs"><spring:message code="filebox.label.list.size" /><!-- 크기 --></th>
								<th scope="col" data-breakpoints="xs sm"><spring:message code="filebox.label.list.manage" /><!-- 관리 --></th>
							</tr>
						</thead>
						<tbody id="fileList">
						</tbody>
					</table>
				</form>
			</div>
		</div>
		<div class="bottom-content">
			<a href="javascript:void(0)" class="ui button blue" onclick="getFile()"><spring:message code="filebox.button.copy" /><!-- 가져오기 --></a>
			<button class="ui black cancel button" onclick="window.parent.closeFileBox();"><spring:message code="filebox.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<!-- 상세정보 --> 
	<form id="fileBoxDetailForm" name="fileBoxDetailForm">
		<input type="hidden" name="selectedFileBoxCd" />
	</form>
    <div class="modal fade in" id="fileBoxDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="filebox.label.pop.detailinfo" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="exam.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="filebox.label.pop.detailinfo" /><!-- 상세정보 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="fileBoxDetailModalIfm" name="fileBoxDetailModalIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;"></iframe>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	<script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>
</html>