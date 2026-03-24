package knou.lms.srvy.web.view;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;
import knou.lms.srvy.vo.SrvyRspnsVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvyVwitmVO;
import knou.lms.srvy.vo.SrvypprVO;

public class SrvyMainView {

	ProcessResultVO<EgovMap> profSrvyList;

	List<EgovMap> sbjctDcvlasList;

	SrvyVO srvyVO;

	List<EgovMap> srvyGrpSbjctList;

	EgovMap srvyEgovMap;

	List<EgovMap> srvyLrnGrpSubAsmtList;

	List<EgovMap> srvySearchSmstrList;

	List<EgovMap> profAuthrtSbjctSrvyList;

	Map<String, List<CmmnCdVO>> cmmnCdList;

	List<EgovMap> srvyTeamList;

	Boolean isQstnsCmptn;

	List<SrvypprVO> srvypprList;

	List<EgovMap> srvyQstnList;

	SrvypprVO srvypprVO;

	List<SrvyVO> qstnCopySrvyList;

	SrvyQstnVO srvyQstnVO;

	List<SrvyVwitmVO> srvyVwitmList;

	List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList;

	List<EgovMap> srvyPtcpList;

	EgovMap srvyPtcpnt;

	EgovMap profMemo;

	List<EgovMap> srvyPtcpDvcStatusList;

	EgovMap srvyPtcpCnt;

	List<EgovMap> srvyChcQstnRspnsStatusList;

	List<EgovMap> srvyTextQstnRspnsStatusList;

	List<EgovMap> srvyLevelQstnRspnsStatusList;

	List<Map<String, Object>> colorList;

	List<EgovMap> srvyExcelDownQstnList;

	List<EgovMap> srvyExcelDownQstnRspnsList;

	List<SrvyRspnsVO> srvyRspnsList;

	List<EgovMap> srvyQstnRspnsDistributionList;

	public ProcessResultVO<EgovMap> getProfSrvyList() {
		return profSrvyList;
	}

	public void setProfSrvyList(ProcessResultVO<EgovMap> profSrvyList) {
		this.profSrvyList = profSrvyList;
	}

	public List<EgovMap> getSbjctDcvlasList() {
		return sbjctDcvlasList;
	}

	public void setSbjctDcvlasList(List<EgovMap> sbjctDcvlasList) {
		this.sbjctDcvlasList = sbjctDcvlasList;
	}

	public SrvyVO getSrvyVO() {
		return srvyVO;
	}

	public void setSrvyVO(SrvyVO srvyVO) {
		this.srvyVO = srvyVO;
	}

	public List<EgovMap> getSrvyGrpSbjctList() {
		return srvyGrpSbjctList;
	}

	public void setSrvyGrpSbjctList(List<EgovMap> srvyGrpSbjctList) {
		this.srvyGrpSbjctList = srvyGrpSbjctList;
	}

	public EgovMap getSrvyEgovMap() {
		return srvyEgovMap;
	}

	public void setSrvyEgovMap(EgovMap srvyEgovMap) {
		this.srvyEgovMap = srvyEgovMap;
	}

	public List<EgovMap> getSrvyLrnGrpSubAsmtList() {
		return srvyLrnGrpSubAsmtList;
	}

	public void setSrvyLrnGrpSubAsmtList(List<EgovMap> srvyLrnGrpSubAsmtList) {
		this.srvyLrnGrpSubAsmtList = srvyLrnGrpSubAsmtList;
	}

	public List<EgovMap> getSrvySearchSmstrList() {
		return srvySearchSmstrList;
	}

	public void setSrvySearchSmstrList(List<EgovMap> srvySearchSmstrList) {
		this.srvySearchSmstrList = srvySearchSmstrList;
	}

	public List<EgovMap> getProfAuthrtSbjctSrvyList() {
		return profAuthrtSbjctSrvyList;
	}

	public void setProfAuthrtSbjctSrvyList(List<EgovMap> profAuthrtSbjctSrvyList) {
		this.profAuthrtSbjctSrvyList = profAuthrtSbjctSrvyList;
	}

	public Map<String, List<CmmnCdVO>> getCmmnCdList() {
		return cmmnCdList;
	}

	public void setCmmnCdList(Map<String, List<CmmnCdVO>> cmmnCdList) {
		this.cmmnCdList = cmmnCdList;
	}

	public List<EgovMap> getSrvyTeamList() {
		return srvyTeamList;
	}

	public void setSrvyTeamList(List<EgovMap> srvyTeamList) {
		this.srvyTeamList = srvyTeamList;
	}

	public Boolean getIsQstnsCmptn() {
		return isQstnsCmptn;
	}

	public void setIsQstnsCmptn(Boolean isQstnsCmptn) {
		this.isQstnsCmptn = isQstnsCmptn;
	}

	public List<SrvypprVO> getSrvypprList() {
		return srvypprList;
	}

	public void setSrvypprList(List<SrvypprVO> srvypprList) {
		this.srvypprList = srvypprList;
	}

	public List<EgovMap> getSrvyQstnList() {
		return srvyQstnList;
	}

	public void setSrvyQstnList(List<EgovMap> srvyQstnList) {
		this.srvyQstnList = srvyQstnList;
	}

	public SrvypprVO getSrvypprVO() {
		return srvypprVO;
	}

	public void setSrvypprVO(SrvypprVO srvypprVO) {
		this.srvypprVO = srvypprVO;
	}

	public List<SrvyVO> getQstnCopySrvyList() {
		return qstnCopySrvyList;
	}

	public void setQstnCopySrvyList(List<SrvyVO> qstnCopySrvyList) {
		this.qstnCopySrvyList = qstnCopySrvyList;
	}

	public SrvyQstnVO getSrvyQstnVO() {
		return srvyQstnVO;
	}

	public void setSrvyQstnVO(SrvyQstnVO srvyQstnVO) {
		this.srvyQstnVO = srvyQstnVO;
	}

	public List<SrvyVwitmVO> getSrvyVwitmList() {
		return srvyVwitmList;
	}

	public void setSrvyVwitmList(List<SrvyVwitmVO> srvyVwitmList) {
		this.srvyVwitmList = srvyVwitmList;
	}

	public List<SrvyQstnVwitmLvlVO> getSrvyQstnVwitmLvlList() {
		return srvyQstnVwitmLvlList;
	}

	public void setSrvyQstnVwitmLvlList(List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList) {
		this.srvyQstnVwitmLvlList = srvyQstnVwitmLvlList;
	}

	public List<EgovMap> getSrvyPtcpList() {
		return srvyPtcpList;
	}

	public void setSrvyPtcpList(List<EgovMap> srvyPtcpList) {
		this.srvyPtcpList = srvyPtcpList;
	}

	public EgovMap getSrvyPtcpnt() {
		return srvyPtcpnt;
	}

	public void setSrvyPtcpnt(EgovMap srvyPtcpnt) {
		this.srvyPtcpnt = srvyPtcpnt;
	}

	public EgovMap getProfMemo() {
		return profMemo;
	}

	public void setProfMemo(EgovMap profMemo) {
		this.profMemo = profMemo;
	}

	public List<EgovMap> getSrvyPtcpDvcStatusList() {
		return srvyPtcpDvcStatusList;
	}

	public void setSrvyPtcpDvcStatusList(List<EgovMap> srvyPtcpDvcStatusList) {
		this.srvyPtcpDvcStatusList = srvyPtcpDvcStatusList;
	}

	public EgovMap getSrvyPtcpCnt() {
		return srvyPtcpCnt;
	}

	public void setSrvyPtcpCnt(EgovMap srvyPtcpCnt) {
		this.srvyPtcpCnt = srvyPtcpCnt;
	}

	public List<EgovMap> getSrvyChcQstnRspnsStatusList() {
		return srvyChcQstnRspnsStatusList;
	}

	public void setSrvyChcQstnRspnsStatusList(List<EgovMap> srvyChcQstnRspnsStatusList) {
		this.srvyChcQstnRspnsStatusList = srvyChcQstnRspnsStatusList;
	}

	public List<EgovMap> getSrvyTextQstnRspnsStatusList() {
		return srvyTextQstnRspnsStatusList;
	}

	public void setSrvyTextQstnRspnsStatusList(List<EgovMap> srvyTextQstnRspnsStatusList) {
		this.srvyTextQstnRspnsStatusList = srvyTextQstnRspnsStatusList;
	}

	public List<Map<String, Object>> getColorList() {
		return colorList;
	}

	public void setColorList(List<Map<String, Object>> colorList) {
		this.colorList = colorList;
	}

	public List<EgovMap> getSrvyLevelQstnRspnsStatusList() {
		return srvyLevelQstnRspnsStatusList;
	}

	public void setSrvyLevelQstnRspnsStatusList(List<EgovMap> srvyLevelQstnRspnsStatusList) {
		this.srvyLevelQstnRspnsStatusList = srvyLevelQstnRspnsStatusList;
	}

	public List<EgovMap> getSrvyExcelDownQstnList() {
		return srvyExcelDownQstnList;
	}

	public List<EgovMap> getSrvyExcelDownQstnRspnsList() {
		return srvyExcelDownQstnRspnsList;
	}

	public void setSrvyExcelDownQstnList(List<EgovMap> srvyExcelDownQstnList) {
		this.srvyExcelDownQstnList = srvyExcelDownQstnList;
	}

	public void setSrvyExcelDownQstnRspnsList(List<EgovMap> srvyExcelDownQstnRspnsList) {
		this.srvyExcelDownQstnRspnsList = srvyExcelDownQstnRspnsList;
	}

	public List<SrvyRspnsVO> getSrvyRspnsList() {
		return srvyRspnsList;
	}

	public void setSrvyRspnsList(List<SrvyRspnsVO> srvyRspnsList) {
		this.srvyRspnsList = srvyRspnsList;
	}

	public List<EgovMap> getSrvyQstnRspnsDistributionList() {
		return srvyQstnRspnsDistributionList;
	}

	public void setSrvyQstnRspnsDistributionList(List<EgovMap> srvyQstnRspnsDistributionList) {
		this.srvyQstnRspnsDistributionList = srvyQstnRspnsDistributionList;
	}

}
