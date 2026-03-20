package knou.lms.srvy.facade;

import java.util.List;
import java.util.Map;

import knou.framework.context2.UserContext;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyMainView;

public interface SrvyFacadeService {

	SrvyMainView getProfSrvyList(SrvyVO vo) throws Exception;

	SrvyMainView loadProfSrvyRegistView(SrvyVO vo) throws Exception;

	SrvyMainView srvyRegist(SrvyVO vo, Map<String, String> subMap) throws Exception;

	SrvyMainView loadProfSrvyModifyView(SrvyVO vo) throws Exception;

	SrvyMainView srvyModify(SrvyVO vo, Map<String, String> subMap) throws Exception;

	SrvyMainView getSbjctMrkOynSrvyCnt(SrvyVO vo) throws Exception;

	void srvyDtlModify(SrvyVO vo) throws Exception;

	void srvyMrkRfltrtListModify(List<SrvyVO> list) throws Exception;

	SrvyMainView getSrvyLrnGrpSubAsmtList(Map<String, Object> params) throws Exception;

	SrvyMainView loadProfBfrSrvyCopyPopup(SrvyVO vo) throws Exception;

	SrvyMainView getProfAuthrtSbjctSrvyList(Map<String, Object> params) throws Exception;

	SrvyMainView getSrvy(SrvyVO vo) throws Exception;

	void srvyDelete(SrvyVO vo) throws Exception;

	SrvyMainView loadProfSrvypprPreviewPopup(SrvyVO vo) throws Exception;

	SrvyMainView loadProfSrvyQstnMngView(SrvyVO vo, UserContext userCtx) throws Exception;

	SrvyMainView getSrvypprQstnList(SrvyVO vo) throws Exception;

	void srvypprRegist(SrvypprVO vo) throws Exception;

	SrvyMainView loadProfSrvypprModifyPopup(SrvypprVO vo) throws Exception;

	Integer getSrvypprPtcpCntSelect(SrvypprVO vo) throws Exception;

	void srvypprDelete(SrvypprVO vo) throws Exception;

	SrvyMainView loadProfSrvyQstnCopyPopup(SrvyVO vo) throws Exception;

	SrvyMainView getQstnCopySrvyList(SrvyVO vo) throws Exception;

	SrvyMainView getQstnCopySrvypprList(SrvypprVO vo) throws Exception;

	SrvyMainView getQstnCopySrvyQstnList(SrvyQstnVO vo) throws Exception;

	void srvyQstnCopy(List<Map<String, Object>> list) throws Exception;

	void srvyQstnRegist(SrvyQstnVO vo, String qstnsStr, String lvlsStr) throws Exception;

	void srvyQstnModify(SrvyQstnVO vo, String qstnsStr, String lvlsStr) throws Exception;

	void srvyQstnDelete(SrvyQstnVO vo) throws Exception;

	SrvyMainView getSrvyQstn(SrvyQstnVO vo) throws Exception;

	void srvySeqnoModify(SrvypprVO vo) throws Exception;

	void qstnSeqnoModify(SrvyQstnVO vo) throws Exception;

	void srvyQstnsCmptnModify(SrvyVO vo) throws Exception;

	SrvyMainView loadProfSrvyEvlMngView(SrvyVO vo) throws Exception;

	SrvyMainView getSrvyPtcpList(Map<String, Object> params) throws Exception;

	SrvyMainView loadProfSrvyMemoPopup(Map<String, Object> params) throws Exception;

	void profMemoModify(Map<String, Object> params) throws Exception;

	void profSrvyEvlScrBulkModify(List<Map<String, Object>> list) throws Exception;

	SrvyMainView loadProfSrvyPtcpStatusPopup(SrvyVO vo, UserContext userCtx) throws Exception;

}
