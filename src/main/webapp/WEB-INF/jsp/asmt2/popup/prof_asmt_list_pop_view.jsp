<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>

                <div class="sub-content">
                    <div id="amstListArea">
                        <div class="board_top">
                            <h5 class="board-title"><spring:message code='asmt.label.score.ratio.manage'/><%--성적 반영비율 관리--%></h5>
                            <div class="right-area">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="searchValue" value="" placeholder="<spring:message code='asmt.label.input.asmt_title'/><%--과제명 입력--%>" autocomplete="off">
                                    <button type="button" class="btn basic icon search" aria-label="<spring:message code='asmt.label.search'/><%--조회--%>" onclick="listPaging(1)"><i class="icon-svg-search"></i></button>
                                </div>

                                <div class="mrkRfltrtFrmTrsfDiv" style="display:none;">
                                    <button type="button" onclick="mrkRfltrtModify()" class="btn basic"><spring:message code='asmt.button.score.ratio.save'/><%--성적반영비율 저장--%></button>
                                    <button type="button" onclick="mrkRfltrtFrmTrsf(2)" class="btn type2"><spring:message code='asmt.button.cancel'/><%--취소--%></button>
                                </div>
                                <button onclick="mrkRfltrtFrmTrsf(1)" id="mrkRfltrtFrmTrsfBtn" type="button" class="btn basic"><spring:message code='asmt.button.score.ratio.chnage'/><%--성적반영비율 조정--%></button>
                                <button onclick="moveAsmtRegistView()" type="button" class="btn type2"><spring:message code='asmt.button.asmt.add'/><%--과제등록--%></button>

                                <%-- 리스트/카드 선택 버튼 --%>
                                <span class="list-card-button"></span>

                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${asmtVO.listScale}"/>
                            </div>
                        </div>
                        <%-- 과제 리스트 --%>
                        <div id="asmtList"></div>
                        <%-- 과제 카드 폼 --%>
                        <div id="asmtList_cardForm" class="lecture_box" style="display:none">
                            <div class="card-header">
                                <label class="label s_c02">#[asmtGbnnm]</label>
                                <div class=card-title">
                                    #[asmtTtl]
                                </div>

                                <div class="btn_right">
                                    <div class="dropdown">
                                        <button type="button" class="btn basic icon set settingBtn" aria-label="<spring:message code='asmt.button.asmt.manage'/><%--과제관리--%>" onclick="this.nextElementSibling.classList.toggle('show')">
                                            <i class="xi-ellipsis-v"></i>
                                        </button>
                                        <div class="option-wrap">
                                            <div class="item"><a href="#0" onclick="moveAsmtEvlView('#[valAsmtId]')"><spring:message code='asmt.button.asmt.eval'/><%--과제평가--%></a></div>
                                            <div class="item"><a href="#0" onclick="moveAsmtModifyView('#[valAsmtId]')"><spring:message code='asmt.button.modify'/><%--수정--%></a></div>
                                            <div class="item"><a href="#0" onclick="deleteAsmt('#[valAsmtId]')"><spring:message code='asmt.button.delete'/><%--삭제--%></a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="extra">
                                    <ul class="process-bar">
                                        <li class="bar-blue" style="width:20%;">#[sbmsnCntBar]</li>
                                        <li class="bar-grey" style="width:80%;">#[nonSbmsnCntBar]</li>
                                    </ul>
                                    <div class="desc">
                                        <p><label><spring:message code='asmt.label.send.date'/><%--제출기간--%></label><strong>#[sbmsnPeriod]</strong></p>
                                        <p><label><spring:message code='asmt.label.ext.send.deadline'/><%--연장제출마감--%></label><strong>#[extdSbmsnEdttm]</strong></p>
                                        <p><label><spring:message code='asmt.label.score.ratio'/><%--성적반영비율--%></label><strong>#[mrkRfltrt]</strong></p>
                                        <p><label><spring:message code='asmt.label.submit.status'/><%--제출현황--%></label><strong>#[sbmsnStts]</strong></p>
                                        <p><label><spring:message code='asmt.label.eval.status'/><%--평가현황--%></label><strong>#[evlStts]</strong></p>
                                        <p><label><spring:message code='asmt.label.score.open'/><%--성적공개--%></label><strong>#[mrkOyn]</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
