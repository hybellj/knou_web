package knou.lms.srvy.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.srvy.vo.SrvyVO;

public class SrvyMainView {

	ProcessResultVO<EgovMap> profSrvyList;

	List<EgovMap> sbjctDcvlasList;

	SrvyVO srvyVO;

	List<EgovMap> srvyGrpSbjctList;

	EgovMap srvyEgovMap;

	List<EgovMap> srvyLrnGrpSubAsmtList;

	List<EgovMap> srvySearchSmstrList;

	ProcessResultVO<EgovMap> profAuthrtSbjctSrvyList;

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

	public ProcessResultVO<EgovMap> getProfAuthrtSbjctSrvyList() {
		return profAuthrtSbjctSrvyList;
	}

	public void setProfAuthrtSbjctSrvyList(ProcessResultVO<EgovMap> profAuthrtSbjctSrvyList) {
		this.profAuthrtSbjctSrvyList = profAuthrtSbjctSrvyList;
	}

}
