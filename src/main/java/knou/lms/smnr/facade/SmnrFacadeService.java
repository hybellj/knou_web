package knou.lms.smnr.facade;

import java.util.List;
import java.util.Map;

import knou.framework.context2.UserContext;
import knou.lms.smnr.vo.SmnrAtndHstryVO;
import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrFdbkVO;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrMainView;
import knou.lms.smnr.web.view.SmnrPageInfo;

public interface SmnrFacadeService {

	SmnrMainView getProfSmnrList(SmnrPageInfo pageInfo);

	SmnrMainView loadProfSmnrRegistView(SmnrVO vo);

	void smnrRegist(SmnrVO vo, Map<String, String> subMap);

	SmnrMainView loadProfSmnrModifyView(SmnrVO vo);

	void smnrModify(SmnrVO vo, Map<String, String> subMap);

	void smnrDelete(SmnrVO vo);

	void smnrMrkRfltrtListModify(List<SmnrVO> list);

	void smnrDtlModify(SmnrVO vo);

	SmnrMainView getSmnrTeamGrpSubSmnrList(Map<String, Object> params);

	SmnrMainView loadProfSmnrEvlMngView(SmnrVO vo);

	SmnrMainView getSmnrAtndList(Map<String, Object> params);

	void profSmnrEvlScrBulkModify(List<Map<String, Object>> list);

	void smnrScrExcelUpload(SmnrAtndVO vo);

	SmnrMainView loadProfSmnrAtndHstryListPopup(SmnrVO vo);

	SmnrMainView getSmnrAtndHstryList(SmnrVO vo);

	void profSmnrAtndBulkModify(List<Map<String, Object>> list);

	SmnrMainView loadProfSmnrAtndMngPopup(SmnrVO vo);

	SmnrMainView getSmnrAtndSelect(SmnrVO vo);

	SmnrMainView getUserSmnrAtndHstryList(SmnrAtndHstryVO vo);

	void profSmnrAtndModify(SmnrAtndVO vo);

	void profSmnrAtndMemoModify(SmnrAtndVO vo);

	void smnrFdbkRegist(SmnrFdbkVO vo, String fdbkUsersStr);

	SmnrMainView loadProfSmnrFdbkPopup(SmnrVO vo);

	SmnrMainView getSmnrFdbkList(SmnrFdbkVO vo);

	void smnrFdbkModify(SmnrFdbkVO vo);

	SmnrMainView getSmnrFdbk(SmnrFdbkVO vo);

	void smnrFdbkDelete(SmnrFdbkVO vo);

	SmnrMainView loadSmnrEzgraderPopup(SmnrVO vo);

	SmnrMainView getSmnrAtndListByEzGrader(SmnrVO vo);

	SmnrMainView getProfSmnrAtndHstryListByEzGrader(Map<String, Object> params, UserContext userCtx);

	void smnrAtndMemoBulkModify(List<Map<String, Object>> list);

	void profSmnrFdbkBulkRegist(List<Map<String, Object>> list);

	SmnrMainView getStdntSmnrList(SmnrPageInfo pageInfo);

	SmnrMainView loadStdntSmnrInfoView(SmnrVO vo, UserContext userCtx);

	SmnrMainView getSmnrAtndHstryList(SmnrAtndHstryVO vo);

}
