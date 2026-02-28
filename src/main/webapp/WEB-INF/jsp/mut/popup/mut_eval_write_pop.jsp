<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		var cYn = false;
		$(document).ready(function() {
		    if("${vo.evalCd}" != ""){
		    	getEval("${vo.evalCd}", null, "load");
		    }else{
		    	addQstnForm();
		    }

			$("#evalPopup").popup({
				popup : $(".popup"),
				on : "click"
			});
			
			<c:if test="${vo.searchType eq 'INFO' }">
				$("input").attr('readonly', true); // or false
			</c:if>
		});

		//선택
		function selTarget(no){
			$('input[name="qstnCts"]').each(function() {
				$(this).css('background-color','white');
			});
			$('input[name="qstnCts"]').eq(no-1).css('background-color','lightyellow');

			$('div[name="gradeList"]').each(function() {
				$(this).hide();
			});
			$('div[name="gradeList"]').eq(no-1).show();

			$('#qstnNoView').hide();
			$('#qstnView').show();
			
			<c:if test="${vo.searchType eq 'INFO' }">
				$("input").attr('readonly', true);
				$("input[type=radio]").attr('disabled', true);
			</c:if>
		};

		//문항추가
		function addQstnForm(qstn, type) {
			var qstnCd = "";
			if(qstn != null){
				qstnCd = qstn.qstnCd;
			}
			var no = $("input[name=evalScore]").length + 1;

			var html  = "<div class='ui input p_w80' name='qstnList'>";
				html += "	<div class='ui label mr0'>" + no + "</div>";
				html += "	<input type='hidden' name='qstnNo' value='" + no + "'>";
				html += "	<input type='hidden' name='qstnCd' value='" + qstnCd + "'>";
				html += "	<input type='text' name='qstnCts' onclick=\"selTarget('" + no + "')\">";
				html += "	<input type='number' name='evalScore' onkeyup='setTotalScore()' class='wf10 fcBlue tc' style='min-width:40px'>";
				if("${vo.searchType}" != "INFO") {
				html += "	<button type='button' class='ui icon basic button' name='qstnBtn' onclick=\"delQstnForm('" + no + "')\"><i class='ion-close icon'></i></button>";
				}
				html += "</div>";

			$("#mutQstnForm").append(html);
			addGradeForm();
			if(type != "load") evalScoreChg();
			setTotalScore();
		}

		//루브릭 문항 제거
		function delQstnForm(no) {
			if($("input[name=evalScore]").length == 1) {
				alert("문항이 1개 이상 있어야 합니다.");
				return false;
			}
			// grade 삭제
			$('div[name="gradeList"]').eq(no-1).remove();

			// qstn 삭제
			$('div[name="qstnList"]').eq(no-1).remove();

			var chk = true;
			$('input[name="qstnCts"]').each(function() {
				if($(this).css('background-color') == 'rgb(255, 255, 224)'){
					chk = false;
				};
			});

			if(chk){
				$('#qstnNoView').show();
				$('#qstnView').hide();
			}

			evalScoreChg();
		};

		// 루브릭 배점 변경
		function evalScoreChg() {
			var cnt = $("input[name=evalScore]").length;
			var ratio = Math.round(100/(cnt));
			var remainder = 100;
			$("input[name=evalScore]").each(function(i, v) {
				remainder -= ratio;
				if(i == (cnt-1)) {
					ratio += remainder;
				}
				$(v).val(ratio);
				$(v).siblings("div").text(i+1);
				$("input[name=qstnNo]").eq(i).val(i+1);
				$("input[name=qstnCts]").eq(i).attr("onclick","selTarget('" + (i+1) + "')");
				$("button[name=qstnBtn]").eq(i).attr("onclick","delQstnForm('" + (i+1) + "')");

				$("div[name=gradeList]:eq("+i+") input:radio").attr("name","evalType"+(i+1));
				$("div[name=gradeList]:eq("+i+") input:radio").attr("onchange","evalTypeSet('" + (i+1) + "')");
				$("div[name=gradeList]:eq("+i+") div[name*=grade]").attr("name","grade" + (i+1));
				$("div[name=gradeList]:eq("+i+") input[name*=gradeScore]").attr("name","gradeScore" + (i+1));
				$("div[name=gradeList]:eq("+i+") input[name*=gradeTitle]").attr("name","gradeTitle" + (i+1));
				$("div[name=addGradeBtn]:eq("+i+") a").attr("href","javascript:addGrade(" + (i+1) + ");");
			});
		};

		//등급추가
		function addGradeForm(){
			var no = $("input[name=evalScore]").length;

			var	html  = "<div name='gradeList'>";
				html += "	<div class='fields'>";
				html += "   	<div class='field'>";
				html += "   		평가 등급";
				html += "   	</div>";
				html += "   	<div class='field'>";
				html += "   		<div class='ui radio checkbox'>";
				html += "   			<input type='radio' name='evalType" + no + "' value='5' onchange=\"evalTypeSet('" + no + "')\" checked />";
				html += "   			<label>5점 척도</label>";
				html += "   		</div>";
				html += "   	</div>";
				html += "   	<div class='field'>";
				html += "   		<div class='ui radio checkbox'>";
				html += "   			<input type='radio' name='evalType" + no + "' value='3' onchange=\"evalTypeSet('" + no + "')\" />";
				html += "   			<label>3점 척도</label>";
				html += "   		</div>";
				html += "   	</div>";
				html += "   	<div class='field'>";
				html += "   		<div class='ui radio checkbox'>";
				html += "   			<input type='radio' name='evalType" + no + "' value='10' onchange=\"evalTypeSet('" + no + "')\" />";
				html += "   			<label>자유척도</label>";
				html += "   		</div>";
				html += "   	</div>";
				html += "   	<div class='field'>";
				html += "   		<div class='ui radio checkbox'>";
				html += "   			<input type='radio' name='evalType" + no + "' value='2' onchange=\"evalTypeSet('" + no + "')\" />";
				html += "   			<label>P/F 척도</label>";
				html += "   		</div>";
				html += "   	</div>";
				html += "   </div>";
				html += "   <div name='grade" + no + "' class='mt10 mb10'></div>";
				if("${vo.searchType}" != "INFO") {
				html += "	<div class='option-content' name='addGradeBtn' style='display:none;'>";
				html += "		<div class='mla'>";
				html += "			<a class='ui blue button' href='javascript:addGrade(" + no + ");'>등급 추가</a>";
				html += "		</div>";
				html += "	</div>";
				}
				html += "</div>";
			$("#qstnView").append(html);
			setGrade(no);

			$('div[name="gradeList"]').eq(no-1).hide();
		}

		//등급기본설정
		function setGrade(no) {
			var html = "";
			var val = $("input[name=evalType"+no+"]:checked").val();
			var gradeTitle = "";
			if(val == 10){
				$("div[name=grade" + no + "]").empty();
				addGrade(no);
			}else if(val == 2) {
				gradeTitle = ["F", "P"];

				for(var i = val; i > 0; i--) {
					html += "<div class='fields'>";
					html += "	<div class='field p_w25 mr40'>";
					html += "		<div class='ui input wmax'>";
					html += "			<input type='number' class='tc' name='gradeScore" +  no + "' value='" + (i-1) + "' readonly='readonly'>";
					html += "			<label class='ui basic label mr0'>점</label>";
					html += "		</div>";
					html += "	</div>";
					html += "	<div class='field p_w70'>";
					html += "		<div class='ui input wmax'>";
					html += "			<input type='text' name='gradeTitle" +  no + "' value='" + gradeTitle[i-1] + "' readonly='readonly'>";
					html += "		</div>";
					html += "	</div>";
					html += "</div>";
				}

				$("div[name=grade" + no + "]").empty().append(html);
			}else{
				if(val == 3) {
					gradeTitle = ["노력하세요", "보통입니다", "잘 했어요"];
				} else if(val == 5) {
					gradeTitle = ["더 노력하세요", "노력하세요", "보통입니다", "잘 했어요", "매우 잘 했어요"];
				}

				for(var i = val; i > 0; i--) {
					html += "<div class='fields'>";
					html += "	<div class='field p_w25 mr40'>";
					html += "		<div class='ui input wmax'>";
					html += "			<input type='number' class='tc' name='gradeScore" +  no + "' value='" + i + "'>";
					html += "			<label class='ui basic label mr0'>점</label>";
					html += "		</div>";
					html += "	</div>";
					html += "	<div class='field p_w70'>";
					html += "		<div class='ui input wmax'>";
					html += "			<input type='text' name='gradeTitle" +  no + "' value='" + gradeTitle[i-1] + "'>";
					html += "		</div>";
					html += "	</div>";
					html += "</div>";
				}

				$("div[name=grade" + no + "]").empty().append(html);
			}
		};

		//등급추가
		function addGrade(no) {
			var cnt = $("input[name=gradeScore" +  no + "]").length;
			if(cnt == 10) {
				alert("등급은 최대 10개까지 가능합니다.");
				return false;
			}
			var	html  = "<div class='fields'>";
				html += "	<div class='field p_w25 mr40'>";
				html += "		<div class='ui input wmax'>";
				html += "			<input type='number' class='tc' name='gradeScore" +  no + "' value=''>";
				html += "			<label class='ui basic label mr0'>점</label>";
				html += "		</div>";
				html += "	</div>";
				html += "	<div class='field p_w70'>";
				html += "		<div class='ui input wmax'>";
				html += "			<input type='text' name='gradeTitle" +  no + "' value=''>";
				if("${vo.searchType}" != "INFO") {
				html += "			<button type='button' class='ui icon basic button' onclick='delGradeForm(this)'><i class='ion-close icon'></i></button>";
				}
				html += "		</div>";
				html += "	</div>";
				html += "</div>";

			$("div[name=grade" + no + "]").append(html);
		}

		//평가 등급 변경
		function evalTypeSet(no) {
			var val = $("input[name=evalType"+no+"]:checked").val();
			// 자유척도
			if(val == 10) {
				$("div[name=addGradeBtn]").eq(no-1).css("display", "");
			} else {
				$("div[name=addGradeBtn]").eq(no-1).css("display", "none");
			}

			setGrade(no);
		}

		// 루브릭 가져오기
		function copyMutEval() {
			$("#mutQstnForm").empty();
			$("#qstnView").empty();

			getEval($("#evalCd").val(), true, "load");
			$("#evalPopup").trigger("click");
		}

		function validation(){

			if($("#evalTitle").val() == null || $("#evalTitle").val() == ''){
				alert("루브릭 제목 입력을 입력하세요.");
				return false;
			}

			var totEvalScore = 0;

			for (var i = 0; i < $("input[name=qstnCts]").length; i++) {
				if($("input[name=qstnCts]").eq(i).val() == ""){
					alert(i+1+"번 평가문항을 입력하세요.");
					return false;
				};

				if($("input[name=evalScore]").eq(i).val() == "") {
					alert(i+1+"번 배점을 입력하세요.");
					return false;
				};

				if($("input[name=evalScore]").eq(i).val().indexOf(".") > -1) {
					alert("배점을 정수로만 입력해주세요.");
					return false;
				};

				totEvalScore += parseInt($("input[name=evalScore]").eq(i).val());

				for (var j = 0; j < $("input[name=gradeScore"+(i+1)+"]").length; j++) {
					if($("input[name=gradeScore"+(i+1)+"]").eq(j).val() == ""){
						alert((i+1)+"번 평가문항 " + (j+1)+"번 평가점수를 입력하세요.");
						return false;
					}
				};

				for (var j = 0; j < $("input[name=gradeTitle"+(i+1)+"]").length; j++) {
					if($("input[name=gradeTitle"+(i+1)+"]").eq(j).val() == ""){
						alert((i+1)+"번 평가문항 " + (j+1)+"번 평가등급을 입력하세요.");
						return false;
					}
				}
			};

			if(totEvalScore != 100) {
				alert("배점을 100%로 맞춰주세요.");
				return false;
			};

			return true;
		}

		// 평가 기준 저장
		function addMutEval() {
			if(validation()){
				var confirm = window.confirm("이미 진행된 평가 내용이 있을 경우 모두 삭제되어 초기화 됩니다. 저장 하시겠습니까?");
				if(confirm) {

					var Obj = "";

					for (var i = 0; i < $("input[name=qstnCts]").length; i++) {

						var qstnCts = $("input[name=qstnCts]").eq(i).val();
						var evalScore = $("input[name=evalScore]").eq(i).val();
						var qstnNo = i + 1 ;
						var evalTypeVal = $("input[name=evalType"+(i+1)+"]:checked").val();
						var evalTypeCd = "M";
						if(evalTypeVal == "5") evalTypeCd = "FIVE";
						if(evalTypeVal == "3") evalTypeCd = "THREE";
						if(evalTypeVal == "2") evalTypeCd = "OX";
						
						Obj += "<input type=\"hidden\"  name=\"evalQstnList["+i+"].qstnNo\" value=\""+qstnNo+"\" >";
						Obj += "<input type=\"hidden\"  name=\"evalQstnList["+i+"].qstnCts\" value=\""+qstnCts+"\" >";
						Obj += "<input type=\"hidden\"  name=\"evalQstnList["+i+"].evalScore\" value=\""+evalScore+"\" >";
						Obj += "<input type=\"hidden\"  name=\"evalQstnList["+i+"].evalTypeCd\" value=\""+evalTypeCd+"\" >";

						for (var j = 0; j < $("input[name=gradeScore"+qstnNo+"]").length; j++) {

							var title = $("input[name=gradeTitle"+qstnNo+"]").eq(j).val();
							var score = $("input[name=gradeScore"+qstnNo+"]").eq(j).val();

							Obj += "<input type=\"hidden\"  name=\"evalQstnList["+i+"].evalGradeList["+j+"].gradeTitle\" value=\""+title+"\" >";
							Obj += "<input type=\"hidden\"  name=\"evalQstnList["+i+"].evalGradeList["+j+"].gradeScore\" value=\""+score+"\" >";
						}
					};

					$("#addEvalForm").append(Obj);

					$.ajax({
						  type: 'post',
						  url: '/mut/mutHome/regEvalQstn.do',
						  async: false,
						  dataType: "json",
						  data: $("#addEvalForm").serialize(),
						  error: function (data){

						  },
						  success: function (data) {
							if (data.result > 0) {
								alert("평가문항 등록에 성공하였습니다.");
								window.parent.mutEvalWrite(data.returnVO.evalCd, data.returnVO.evalTitle);
								window.parent.closeModal();
							} else {
								$("input[name^=evalQstnList]").remove();
								alert("평가문항 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.");
							}
						  }
					});
				}
			}
		}

		// 루브릭 가져오기
		function getEval(evalCd, copy, type) {
			var url  = "/mut/mutHome/getMut.do";
			var data = {
				"selectType" : "OBJECT",
				"evalCd" : evalCd
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var vo = data.returnVO;
					if(!copy){
						$("input[name=evalCd]").val(vo.evalCd);
					}
					$("#evalTitle").val(vo.evalTitle);

					for(var i = 0; i < vo.evalQstnList.length; i++){
						var no = i+1;
						var qstn = vo.evalQstnList[i];

						addQstnForm(qstn.qstnCd, type);

						$("input[name=qstnCts]").eq(i).val(qstn.qstnCts);
						$("input[name=evalScore]").eq(i).val(qstn.evalScore);
						var evalTypeIdx = 2;
						if(qstn.evalTypeCd == "FIVE") evalTypeIdx = 0;
						if(qstn.evalTypeCd == "THREE") evalTypeIdx = 1;
						if(qstn.evalTypeCd == "OX") evalTypeIdx = 3;

						$("input[name=evalType"+no+"]").eq(evalTypeIdx).prop('checked',true);
						setGrade(no);
						
						for(var j = 0; j < qstn.evalGradeList.length; j++){
							if(j!=0 && qstn.evalTypeCd == "M") addGrade(no);
							var grade = qstn.evalGradeList[j];

							$("input[name=gradeScore"+no+"]").eq(j).val(grade.gradeScore);
							$("input[name=gradeTitle"+no+"]").eq(j).val(grade.gradeTitle);
						}
						setTotalScore();

						$("div[name=addGradeBtn]").eq(i).css("display", "");
					}

					$('#qstnNoView').show();
					$('#qstnView').hide();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert("에러가 발생했습니다.");
			});
		}
		
		// 평가 등급 삭제
		function delGradeForm(obj) {
			$(obj).closest(".fields").remove();
		}
		
		// 루브릭 총점 계산
		function setTotalScore() {
			var total = 0;
			$("input[name=evalScore]").each(function(i, v) {
				var score = $(v).val() == "" ? "0" : $(v).val();
				total += parseInt(score);
			});
			$("#mutTotalScore").text(total);
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<c:if test="${vo.searchType ne 'INFO' }">
	        	<p class="tc fcRed mb20">! 평가 진행 혹은 완료된 후, 평가기준을 수정하면 이미 진행된 평가 내용은 모두 삭제되어 초기화됩니다.</p>
        	</c:if>
        	<div class="option-content">
        		<c:if test="${vo.searchType ne 'INFO' }">
        		    <h3>루브릭 설정</h3>
	        		<div class='mla'>
	        			<a class="ui blue button" id="evalPopup">루브릭 가져오기</a>
	        			<a class="ui blue button" href="javascript:addMutEval()">저장</a>
	        		</div>
        		</c:if>
        	</div>
			<div class="ui flowing popup bottom left p_w80 transition hidden">
		        <div>
		        	<div class="fcWhite bcBlue p10">
		        		루브릭 가져오기
		        	</div>
		        	<select class="ui dropdown wmax" id="evalCd" onchange="copyMutEval()">
		        		<option value="">루브릭을 선택하세요</option>
		        		<c:forEach var="list" items="${evalList }">
		        			<option value="${list.evalCd }">${list.evalTitle eq null || list.evalTitle eq '' ? '제목없음' : list.evalTitle }</option>
		       			</c:forEach>
		        	</select>
		        </div>
	      	</div>
	      	<form name="addEvalForm" id="addEvalForm" method="POST">
	      		<input type="hidden" name="crsCreCd"   value="${vo.crsCreCd }" />
	      		<input type="hidden" name="rltnCd"     value="${vo.rltnCd }" />
	      		<input type="hidden" name="evalCd"     value="${vo.evalCd }" />
	      		<input type="hidden" name="evalDivCd"  value="${empty vo.evalDivCd ? 'PROFESSOR_EVAL' : vo.evalDivCd }" />
	      		<input type="hidden" name="adminYn"	   value="N" />
	      		<!-- <input type="hidden" name="evalTypeCd" value="M" id="evalTypeCd" /> -->
	        	<div class="ui segment">
			        <c:if test="${vo.searchType ne 'INFO' }">
			        	<p>루브릭 제목 입력</p>
		        		<div class="ui input wmax mt10 mb10">
			        		<input type="text" name="evalTitle" id="evalTitle" class="bcLgrey" placeholder="평가 기준 타이틀을 입력하세요." />
		        		</div>
				        <p class="p_w70 fl">루브릭 평가요소 등록</p>
			        	<span id="mutTotalScore" class="fcBlue"></span>
			        </c:if>
	        		<div id="mutQstnForm"></div>
	        		<c:if test="${vo.searchType ne 'INFO' }">
			    		<div class="option-content">
			    			<div class="mla">
				    			<a class="ui blue button" href="javascript:addQstnForm()">평가기준추가</a>
			    			</div>
			    		</div>
	        		</c:if>
	        	</div>
	        	<div class="ui segment form" id='qstnNoView'>
	        		<div class="fields">
	        			<div class="field">
	        				선택 된 문항이 없습니다.
	        			</div>
	        		</div>
	        	</div>
	        	<div class="ui segment form" id='qstnView' style="display:none;"></div>
	      	</form>

            <div class="bottom-content">
                <button type='button' class="ui black cancel button" onclick="window.parent.closeModal();">닫기</button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
