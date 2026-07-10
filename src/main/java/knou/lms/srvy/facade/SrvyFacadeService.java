package knou.lms.srvy.facade;

import java.util.List;
import java.util.Map;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.srvy.vo.SrvyPtcpHstryVO;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyMainView;
import knou.lms.srvy.web.view.SrvyPageInfo;

public interface SrvyFacadeService {

	SrvyMainView getProfSrvyList(SrvyPageInfo pageInfo);

	SrvyMainView loadProfSrvyRegistView(SrvyVO vo);

	SrvyMainView srvyRegist(SrvyVO vo, Map<String, String> subMap);

	SrvyMainView loadProfSrvyModifyView(SrvyVO vo);

	SrvyMainView srvyModify(SrvyVO vo, Map<String, String> subMap);

	SrvyMainView getSbjctMrkOynSrvyCnt(SrvyVO vo);

	void srvyDtlModify(SrvyVO vo);

	void srvyMrkRfltrtListModify(List<SrvyVO> list);

	SrvyMainView getSrvyTeamGrpSubSrvyList(Map<String, Object> params);

	SrvyMainView loadProfBfrSrvyCopyPopup(SrvyVO vo);

	SrvyMainView getProfAuthrtSbjctSrvyList(SrvyVO vo);

	SrvyMainView getSrvy(SrvyVO vo);

	void srvyDelete(SrvyVO vo);

	SrvyMainView loadProfSrvypprPreviewPopup(SrvyVO vo);

	SrvyMainView loadProfSrvyQstnMngView(SrvyVO vo, UserContext userCtx);

	SrvyMainView getSrvypprQstnList(SrvyVO vo);

	void srvypprRegist(SrvypprVO vo);

	SrvyMainView loadProfSrvypprModifyPopup(SrvypprVO vo);

	Integer getSrvypprPtcpCntSelect(SrvypprVO vo);

	void srvypprDelete(SrvypprVO vo);

	SrvyMainView loadProfSrvyQstnCopyPopup(SrvyVO vo);

	SrvyMainView getQstnCopySrvyList(SrvyVO vo);

	SrvyMainView getQstnCopySrvypprList(SrvypprVO vo);

	SrvyMainView getQstnCopySrvyQstnList(SrvyQstnVO vo);

	void srvyQstnCopy(List<Map<String, Object>> list);

	void srvyQstnRegist(SrvyQstnVO vo, String qstnsStr, String lvlsStr);

	void srvyQstnModify(SrvyQstnVO vo, String qstnsStr, String lvlsStr);

	void srvyQstnDelete(SrvyQstnVO vo);

	SrvyMainView getSrvyQstn(SrvyQstnVO vo);

	void srvySeqnoModify(SrvypprVO vo);

	void qstnSeqnoModify(SrvyQstnVO vo);

	void srvyQstnsCmptnModify(SrvyVO vo);

	SrvyMainView loadProfSrvyEvlMngView(SrvyVO vo);

	SrvyMainView getSrvyPtcpList(Map<String, Object> params);

	SrvyMainView loadProfSrvypprEvlPopup(Map<String, Object> params);

	SrvyMainView loadProfSrvyMemoPopup(Map<String, Object> params);

	void profMemoModify(Map<String, Object> params);

	void profSrvyEvlScrBulkModify(List<Map<String, Object>> list);

	SrvyMainView loadSrvyPtcpStatusPopup(SrvyVO vo, UserContext userCtx);

	SrvyMainView getSrvyPtcpStatusExcelDownList(SrvyVO vo);

	SrvyMainView getSrvyRspnsStatusExcelDownList(SrvyVO vo);

	SrvyMainView getSrvyQstnDistributionChart(Map<String, Object> params);

	SrvyMainView loadProfSrvypprPrintPopup(Map<String, Object> params);

	SrvyMainView loadSrvyEzgraderPopup(SrvyVO vo);

	SrvyMainView getSrvyPtcpListByEzGrader(SrvyVO vo);

	SrvyMainView getProfSrvyRspnsListByEzGrader(SrvyPtcpVO vo);

	void srvyScrExcelUpload(SrvyPtcpVO vo);

	SrvyMainView getSrvyQstnExcelSampleData(SrvyVO vo);

	ResultDTO<SrvyVO> srvyQstnExcelUpload(SrvyVO vo);

	void profMemoBulkModify(List<Map<String, Object>> list);

	SrvyMainView getStdntSrvyList(SrvyPageInfo pageInfo);

	SrvyMainView loadStdntSrvyInfoView(SrvyVO vo, UserContext userCtx);

	SrvyMainView loadSrvyPtcpPopup(SrvyVO srvy, SrvyPtcpVO ptcp, UserContext userCtx);

	void srvypprSbmsn(Map<String, Object> params);

	SrvyMainView getSrvyPtcpHstryList(SrvyPtcpHstryVO vo);

	SrvyMainView loadAdmSrvyLctrEvlListView();

	SrvyMainView getAdmSrvyLctrEvlList(SrvyPageInfo pageInfo);

	SrvyMainView loadAdmSrvyLctrEvlRegistView(SrvyVO vo);

	SrvyMainView loadAdmSrvyLctrEvlModifyView(SrvyVO vo);

	SrvyMainView getSrvyLctrEvlNRegistSbjctList(Map<String, Object> params);

	SrvyMainView srvyLctrEvlRegist(SrvyVO vo, Map<String, String> subMap);

	SrvyMainView srvyLctrEvlModify(SrvyVO vo, Map<String, String> subMap);

	SrvyMainView loadAdmSrvyLctrEvlInfoView(SrvyVO vo);

	SrvyMainView getSrvyLctrEvlRegistSbjctList(SrvyVO vo);

	SrvyMainView loadAdmBfrSrvyLctrEvlCopyPopup();

	SrvyMainView getAdmRegistSrvyLctrEvlList(Map<String, Object> params);

	SrvyMainView getSrvyLctrEvlSelect(SrvyVO vo);

	SrvyMainView loadAdmSrvyLctrEvlQstnMngView(SrvyVO vo);

	SrvyMainView loadAdmSrvyLctrEvlQstnCopyPopup(SrvyVO vo);

	SrvyMainView loadAdmSrvyLctrEvlMngPopup(SrvyVO vo);

	SrvyMainView loadAdmSrvyLtclEvlRsltListView();

	SrvyMainView loadAdmSrvyLctrEvlRsltMngView(SrvyVO vo);

	SrvyMainView getAdmSrvyLctrEvlRsltList(SrvyPageInfo pageInfo);

	SrvyMainView getAdmSrvyLctrEvlPtcpStatus(Map<String, Object> params);

	SrvyMainView getLctrEvlRspnsStatusExcelDownList(SrvyVO vo);

	SrvyMainView getLctrEvlPtcpStatusExcelDownList(SrvyVO vo);

	SrvyMainView loadAdmSrvyListView(SrvyVO vo);

	SrvyMainView getAdmSrvyList(SrvyPageInfo pageInfo);

	SrvyMainView loadAdmSrvyRegistView(SrvyVO vo);

	SrvyMainView admSrvyRegist(SrvyVO vo);

	SrvyMainView loadAdmSrvyModifyView(SrvyVO vo);

	SrvyMainView admSrvyModify(SrvyVO vo);

	SrvyMainView loadAdmSrvyInfoView(SrvyVO vo);

	SrvyMainView loadAdmBfrSrvyCopyPopup(SrvyVO vo);

	SrvyMainView getAdmRegistSrvyList(Map<String, Object> params);

	SrvyMainView getAdmSrvySelect(SrvyVO vo);

	SrvyMainView loadAdmSrvyQstnMngView(SrvyVO vo);

	SrvyMainView loadAdmSrvyQstnCopyPopup(SrvyVO vo);

	SrvyMainView loadAdmSrvyRsltMngView(SrvyVO vo);

	SrvyMainView getAdmSrvyRsltList(SrvyPageInfo pageInfo);

	SrvyMainView getRspnsStatusExcelDownList(SrvyVO vo);

	SrvyMainView getPtcpStatusExcelDownList(SrvyVO vo);

	SrvyMainView getAdmSrvyPtcpStatus(Map<String, Object> params);

	SrvyMainView loadStdntMainSrvyLctrEvlListView();

	SrvyMainView getStdntMainSrvyLctrEvlList(Map<String, Object> params);

	SrvyMainView loadSrvyPtcpInfoPopup(SrvyVO vo);

	SrvyMainView loadSrvyLctrEvlPtcpPopup(SrvyVO vo, UserContext userCtx);

	SrvyMainView loadSrvyLctrEvlPtcpStatusPopup(SrvyVO vo, UserContext userCtx);

	SrvyMainView loadStdntWholSrvyListView(SrvyVO vo);

	SrvyMainView getTrgtWholSrvyList(SrvyPageInfo pageInfo);

	SrvyMainView loadWholSrvyPtcpPopup(SrvyVO vo, UserContext userCtx);

	SrvyMainView loadWholSrvyPtcpStatusPopup(SrvyVO vo, UserContext userCtx);

	SrvyMainView getStdntSrvyLctrEvlList(SrvyPageInfo pageInfo);

	SrvyMainView loadStdntLectSrvyLctrEvlInfoView(SrvyVO vo, UserContext userCtx);

	SrvyMainView loadAdmSbjctSrvyLctrEvlListView();

	SrvyMainView loadAdmSbjctSrvyLctrEvlInfoView(SrvyVO vo);

	SrvyMainView getSrvyLctrEvlSbjctPtcpList(SrvyVO vo);

	SrvyMainView loadAdmSbjctSrvyLtclEvlRsltListView();

	SrvyMainView loadAdmSbjctSrvyLtclEvlRsltMngView(SrvyVO vo);
}
