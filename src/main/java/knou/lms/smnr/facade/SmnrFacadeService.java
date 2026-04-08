package knou.lms.smnr.facade;

import java.util.List;
import java.util.Map;

import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrMainView;

public interface SmnrFacadeService {

	SmnrMainView getProfSmnrList(SmnrVO vo) throws Exception;

	SmnrMainView loadProfSmnrRegistView(SmnrVO vo) throws Exception;

	void smnrRegist(SmnrVO vo, Map<String, String> subMap) throws Exception;

	SmnrMainView loadProfSmnrModifyView(SmnrVO vo) throws Exception;

	void smnrModify(SmnrVO vo, Map<String, String> subMap) throws Exception;

	void smnrDelete(SmnrVO vo) throws Exception;

	void smnrMrkRfltrtListModify(List<SmnrVO> list) throws Exception;

	void smnrDtlModify(SmnrVO vo) throws Exception;

	SmnrMainView getSmnrLrnGrpSubSmnrList(Map<String, Object> params) throws Exception;

}
