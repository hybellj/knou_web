<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">
	var dialog;
	var EPARAM = '<c:out value="${encParams}" />';

	// dialog 닫기
	window.closeDialog = function() {
		dialog.close();
	};

	// 세미나화면이동
	function smnrViewMv(smnrId, type, upSmnrId) {
		var urlMap = {
			"EVL" 		: "/smnr/profSmnrEvlMngView.do",		// 세미나 평가 관리 화면
			"REGIST" 	: "/smnr/profSmnrRegistView.do", 		// 세미나 등록 화면
			"MODIFY" 	: "/smnr/profSmnrModifyView.do", 		// 세미나 수정 화면
			"LIST"		: "/smnr/profSmnrListView.do",			// 세미나 목록 화면
			"VIEW"		: "/smnr/stdntSmnrInfoView.do",			// 학생 세미나 정보 화면
			"STDLIST"	: "/smnr/stdntSmnrListView.do"			// 학생 세미나 목록 화면
		};

		var extData = {
			smnrId 		: smnrId,
			upSmnrId	: upSmnrId
		};

		document.location.href = urlMap[type] + "?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
	}

	/**
     * 팀그룹부세미나목록조회
     */
    function teamGrpSubSmnrListSelect(teamGrpId, smnrId) {
        const url  = "/smnr/smnrTeamGrpSubSmnrListAjax.do";
        const data = {
            teamGrpId	: teamGrpId,
            smnrId		: smnrId
        };

        $.ajax({
            url			: url,
            async		: false,
            type		: "POST",
            dataType	: "json",
            data		: JSON.stringify(data),
            contentType	: "application/json; charset=UTF-8",
            beforeSend: function () {
            	UiComm.showLoading(true);
            },
            success: function (data) {
                if (data.result > 0) {
                	let returnList = data.returnList || [];
                	let html = "";

                    if (returnList.length > 0) {
                        returnList.forEach(function (v, i) {
                        	html += "<tr>";
							html += "	<th rowspan='4' class='group-header'><label>" + v.teamnm + "</label></th>";
							html += "	<th><label>팀그룹 구성원</label></th>";
							html += "	<td>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "명</td>";
							html += "</tr>";
							html += "<tr>";
							html += "	<th><label>부주제</label></th>";
							html += "	<td>" + UiComm.escapeHtml(v.smnrnm) + "</td>";
							html += "</tr>";
							html += "<tr>";
							html += "	<th><label>내용</label></th>";
							html += "	<td><pre>" + v.smnrCts + "</pre></td>";
							html += "</tr>";
							html += "<tr>";
							html += "	<th><label>첨부파일</label></th>";
							html += "	<td>";
							if(v.fileList != null) {
								html += "	<div class='add_file_list'>";
								html += "		<ul class='add_file'>";
								v.fileList.forEach(function(vv, ii) {
									html += "		<li>";
									html += "			<a href='#_' class='file_down' onclick='UiFileDownloader(\""+vv.encDownParam+"\");return false;' title='File download'>"+vv.filenm+"</a>";
									html += "		</li>";
								});
								html += "		</ul>";
								html += "	</div>";
							}
							html += "	</td>";
							html += "</tr>";
                        });
                    }

                    $("#smnrSubSmnrTbody").append(html);
                }
            },
            error: function (xhr, status, error) {
            	UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
            },
            complete: function () {
            	UiComm.showLoading(false);
            },
        });
    }

	// 페이지 이동
	function submitForm(action, kvArr){
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
	};
</script>