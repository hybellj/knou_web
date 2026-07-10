<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="classroom"/>
	</jsp:include>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->

  <div class="modal-body">

	   <div class="msg-box warning">
	       <ul class="list-asterisk">
	           <li class="fw-bold">결시 작성시 주의사항</li>
	       </ul>
	       <ul class="list-bullet">
	           <li>결시 사유 발생 : 정해진 일시에 시험에 응시하지 못하는 사유가 발행했을 경우 결시 작성/제출합니다.</li>
	           <li>결시 승인여부 확인 및 코멘트 확인 : 각 과목 강의실로 이동하여 해당 과목의 대처 방안(대체과제유무 등)을 반드시 확인하여 응시하여야 성적을 부여 받을 수 있습니다.</li>
	           <li>결시 제출기간 준수해야 합니다.</li>
	       </ul>
	   </div>

      <div class="table-wrap mb20">
          <table class="table-type5">
              <colgroup>
                  <col class="width-20per">
                  <col>
                  <col class="width-20per">
                  <col>
              </colgroup>
              <tbody>
                  <tr>
                      <th>학과</th>
                      <td>학과</td>
                      <th>학수번호</th>
                      <td>CME000</td>
                  </tr>
                  <tr>
                      <th>과목</th>
                      <td>유럽 문화 탐방</td>
                      <th>분반</th>
                      <td>1반</td>
                  </tr>
                  <tr>
                      <th>시험구분</th>
                      <td>중간고사</td>
                      <th>시험일시</th>
                      <td>2026.05.15</td>
                  </tr>
                  <tr>
                      <th>교수</th>
                      <td>홍*수</td>
                      <th>튜터</th>
                      <td>김*튜터</td>
                  </tr>
              </tbody>
          </table>
      </div>

      <div class="table-wrap mb10">
          <table class="table-type5">
              <colgroup>
                  <col class="width-20per">
                  <col>
                  <col class="width-20per">
                  <col>
              </colgroup>
              <tbody>
                  <tr>
                      <th>대표아이디</th>
                      <td>testid**3</td>
                      <th>학번</th>
                      <td>902***45</td>
                  </tr>
                  <tr>
                      <th>이름</th>
                      <td>학*자1</td>
                      <th>연락처</th>
                      <td>010-2222-33**</td>
                  </tr>
                  <tr>
                      <th class="req">결시 사유</th>
                      <td>
                          <select class="form-select">
                              <option value="">선택</option>
                          </select>
                      </td>
                      <th class="req">적용비율</th>
                      <td>0%</td>
                  </tr>
                  <tr>
                      <th class="req">결시 사유 설명</th>
                      <td colspan="3">
                          <div class="editor-box">
                              <label for="atclCts" class="hide">Content</label>
                              <textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
                              <script>
                                  // HTML 에디터
                                  let editor = UiEditor({
                                      targetId: "atclCts",
                                      uploadPath: "/bbs",
                                      height: "300px"
                                  });
                              </script>
                          </div>
                      </td>
                  </tr>
                  <tr>
                      <th class="req">증빙자료첨부</th>
                      <td colspan="3">
                      	<%--
                      		// 실제 개발 코딩에서는 아래와 같이 <uiex:dextuploader> 태그를 사용하세요.
	                      	<uiex:dextuploader
								id="fileUploader"
								path="${bbsVO.uploadPath}"
								limitCount="5"
								limitSize="100"
								oneLimitSize="100"
								listSize="3"
								fileList="${bbsAtclVO.fileList}"
								finishFunc="finishUpload"
								allowedTypes="*"
								uiMode="normal"
							/>
                      	--%>
                          <div id="fileUploader-container" class="dext5-container" style="width:100%;height:180px;"></div>
                          <script>
                          UiFileUploader({
                              id:"fileUploader",
                              finishFunc:"finishUpload()",
                              uploadUrl:"https://localhost/dext/uploadFileDext.up?type=",
                              path:"/bbs",
                              fileCount:5,
                              oldFiles:[]
                          });
                          </script>
                          <small class="note2">예) 진단서, 입원확인서, 출장확인서, 훈련통지서 등</small>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>

      <div class="mb50">
          <b>이상의 결시 사유를 담당 과목 교수님께 보고 드립니다.</b>
          <div class="text-center mt30">
              신청일 : 2026년 03월 25일<br>신청자 : 학*자1
          </div>
      </div>

      <div class="modal_btns">
          <button type="button" class="btn type1">신청</button>
          <button type="button" class="btn type2" onclick="window.parent.dialog1.close()">닫기</button>
      </div>

  </div>

</body>
</html>
