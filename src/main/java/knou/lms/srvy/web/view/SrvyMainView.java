package knou.lms.srvy.web.view;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.org.vo.OrgVO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;
import knou.lms.srvy.vo.SrvyRspnsVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvyVwitmVO;
import knou.lms.srvy.vo.SrvypprVO;

public class SrvyMainView {

	ResultDTO<EgovMap> resultDTO;

	List<EgovMap> egovList;

	List<OrgVO> orgList;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	List<SrvyVO> srvyList;

	List<SrvypprVO> srvypprList;

	List<EgovMap> srvyQstnList;

	List<SrvyVwitmVO> srvyVwitmList;

	List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList;

	List<SrvyRspnsVO> srvyRspnsList;

	List<Map<String, Object>> colorList;

	HashMap<String, Object> srvyQstnSampleMap;

	Map<String, List<EgovMap>> egovListMap;

	Map<String, EgovMap> eMap;

	EgovMap egovMap;

	SrvyVO srvyVO;

	SrvypprVO srvypprVO;

	SrvyQstnVO srvyQstnVO;

	Boolean isQstnsCmptn;

	public List<EgovMap> getEgovList() {
		return egovList;
	}

	public List<OrgVO> getOrgList() {
		return orgList;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public List<SrvyVO> getSrvyList() {
		return srvyList;
	}

	public List<SrvypprVO> getSrvypprList() {
		return srvypprList;
	}

	public List<EgovMap> getSrvyQstnList() {
		return srvyQstnList;
	}

	public List<SrvyVwitmVO> getSrvyVwitmList() {
		return srvyVwitmList;
	}

	public List<SrvyQstnVwitmLvlVO> getSrvyQstnVwitmLvlList() {
		return srvyQstnVwitmLvlList;
	}

	public List<SrvyRspnsVO> getSrvyRspnsList() {
		return srvyRspnsList;
	}

	public List<Map<String, Object>> getColorList() {
		return colorList;
	}

	public HashMap<String, Object> getSrvyQstnSampleMap() {
		return srvyQstnSampleMap;
	}

	public Map<String, List<EgovMap>> getEgovListMap() {
		return egovListMap;
	}

	public Map<String, EgovMap> geteMap() {
		return eMap;
	}

	public EgovMap getEgovMap() {
		return egovMap;
	}

	public SrvyVO getSrvyVO() {
		return srvyVO;
	}

	public SrvypprVO getSrvypprVO() {
		return srvypprVO;
	}

	public SrvyQstnVO getSrvyQstnVO() {
		return srvyQstnVO;
	}

	public Boolean getIsQstnsCmptn() {
		return isQstnsCmptn;
	}

	public void setEgovList(List<EgovMap> egovList) {
		this.egovList = egovList;
	}

	public void setOrgList(List<OrgVO> orgList) {
		this.orgList = orgList;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public void setSrvyList(List<SrvyVO> srvyList) {
		this.srvyList = srvyList;
	}

	public void setSrvypprList(List<SrvypprVO> srvypprList) {
		this.srvypprList = srvypprList;
	}

	public void setSrvyQstnList(List<EgovMap> srvyQstnList) {
		this.srvyQstnList = srvyQstnList;
	}

	public void setSrvyVwitmList(List<SrvyVwitmVO> srvyVwitmList) {
		this.srvyVwitmList = srvyVwitmList;
	}

	public void setSrvyQstnVwitmLvlList(List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList) {
		this.srvyQstnVwitmLvlList = srvyQstnVwitmLvlList;
	}

	public void setSrvyRspnsList(List<SrvyRspnsVO> srvyRspnsList) {
		this.srvyRspnsList = srvyRspnsList;
	}

	public void setColorList(List<Map<String, Object>> colorList) {
		this.colorList = colorList;
	}

	public void setSrvyQstnSampleMap(HashMap<String, Object> srvyQstnSampleMap) {
		this.srvyQstnSampleMap = srvyQstnSampleMap;
	}

	public void setEgovListMap(Map<String, List<EgovMap>> egovListMap) {
		this.egovListMap = egovListMap;
	}

	public void seteMap(Map<String, EgovMap> eMap) {
		this.eMap = eMap;
	}

	public void setEgovMap(EgovMap egovMap) {
		this.egovMap = egovMap;
	}

	public void setSrvyVO(SrvyVO srvyVO) {
		this.srvyVO = srvyVO;
	}

	public void setSrvypprVO(SrvypprVO srvypprVO) {
		this.srvypprVO = srvypprVO;
	}

	public void setSrvyQstnVO(SrvyQstnVO srvyQstnVO) {
		this.srvyQstnVO = srvyQstnVO;
	}

	public void setIsQstnsCmptn(Boolean isQstnsCmptn) {
		this.isQstnsCmptn = isQstnsCmptn;
	}

	public ResultDTO<EgovMap> getResultDTO() {
		return resultDTO;
	}

	public void setResultDTO(ResultDTO<EgovMap> resultDTO) {
		this.resultDTO = resultDTO;
	}
}
