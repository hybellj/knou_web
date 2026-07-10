package knou.lms.qbnk.web.view;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

public class QbnkMainView {

	ResultDTO<EgovMap> resultDTO;

	Map<String, List<EgovMap>> egovListMap;

	List<EgovMap> egovList;

	List<QbnkCtgrVO> qbnkCtgrList;

	List<QbnkQstnVwitmVO> qbnkQstnVwitmList;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	Map<String, EgovMap> eMap;

	EgovMap egovMap;

	QbnkCtgrVO qbnkCtgrVO;

	public ResultDTO<EgovMap> getResultDTO() {
		return resultDTO;
	}

	public Map<String, List<EgovMap>> getEgovListMap() {
		return egovListMap;
	}

	public List<EgovMap> getEgovList() {
		return egovList;
	}

	public List<QbnkCtgrVO> getQbnkCtgrList() {
		return qbnkCtgrList;
	}

	public List<QbnkQstnVwitmVO> getQbnkQstnVwitmList() {
		return qbnkQstnVwitmList;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public Map<String, EgovMap> geteMap() {
		return eMap;
	}

	public EgovMap getEgovMap() {
		return egovMap;
	}

	public QbnkCtgrVO getQbnkCtgrVO() {
		return qbnkCtgrVO;
	}

	public void setResultDTO(ResultDTO<EgovMap> resultDTO) {
		this.resultDTO = resultDTO;
	}

	public void setEgovListMap(Map<String, List<EgovMap>> egovListMap) {
		this.egovListMap = egovListMap;
	}

	public void setEgovList(List<EgovMap> egovList) {
		this.egovList = egovList;
	}

	public void setQbnkCtgrList(List<QbnkCtgrVO> qbnkCtgrList) {
		this.qbnkCtgrList = qbnkCtgrList;
	}

	public void setQbnkQstnVwitmList(List<QbnkQstnVwitmVO> qbnkQstnVwitmList) {
		this.qbnkQstnVwitmList = qbnkQstnVwitmList;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public void seteMap(Map<String, EgovMap> eMap) {
		this.eMap = eMap;
	}

	public void setEgovMap(EgovMap egovMap) {
		this.egovMap = egovMap;
	}

	public void setQbnkCtgrVO(QbnkCtgrVO qbnkCtgrVO) {
		this.qbnkCtgrVO = qbnkCtgrVO;
	}
}
