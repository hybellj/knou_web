package knou.lms.qbnk.web.view;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

public class QbnkMainView {

	List<QbnkCtgrVO> upQbnkCtgrList;

	EgovMap qbnkSbjct;

	List<EgovMap> qbnkSearchSbjctList;

	List<EgovMap> qbnkSearchProfList;

	EgovMap qbnkQstnVO;

	List<QbnkQstnVwitmVO> qbnkQstnVwitmList;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	public List<QbnkCtgrVO> getUpQbnkCtgrList() {
		return upQbnkCtgrList;
	}

	public void setUpQbnkCtgrList(List<QbnkCtgrVO> upQbnkCtgrList) {
		this.upQbnkCtgrList = upQbnkCtgrList;
	}

	public EgovMap getQbnkSbjct() {
		return qbnkSbjct;
	}

	public void setQbnkSbjct(EgovMap qbnkSbjct) {
		this.qbnkSbjct = qbnkSbjct;
	}

	public List<EgovMap> getQbnkSearchSbjctList() {
		return qbnkSearchSbjctList;
	}

	public List<EgovMap> getQbnkSearchProfList() {
		return qbnkSearchProfList;
	}

	public void setQbnkSearchSbjctList(List<EgovMap> qbnkSearchSbjctList) {
		this.qbnkSearchSbjctList = qbnkSearchSbjctList;
	}

	public void setQbnkSearchProfList(List<EgovMap> qbnkSearchProfList) {
		this.qbnkSearchProfList = qbnkSearchProfList;
	}

	public EgovMap getQbnkQstnVO() {
		return qbnkQstnVO;
	}

	public void setQbnkQstnVO(EgovMap qbnkQstnVO) {
		this.qbnkQstnVO = qbnkQstnVO;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public List<QbnkQstnVwitmVO> getQbnkQstnVwitmList() {
		return qbnkQstnVwitmList;
	}

	public void setQbnkQstnVwitmList(List<QbnkQstnVwitmVO> qbnkQstnVwitmList) {
		this.qbnkQstnVwitmList = qbnkQstnVwitmList;
	}

}
