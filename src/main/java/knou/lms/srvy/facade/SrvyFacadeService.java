package knou.lms.srvy.facade;

import java.util.List;
import java.util.Map;

import knou.lms.srvy.vo.SrvyVO;
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

}
