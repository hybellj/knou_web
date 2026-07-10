package knou.lms.smnr.pltfrm.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.org.vo.OrgVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;

public class SmnrPltfrmMainView {

	ResultDTO<EgovMap> resultDTO;

	List<OrgVO> orgList;

	List<EgovMap> onlnPltfrmAuthrtList;

	OnlnPltfrmAuthrtVO onlnPltfrmAuthrtVO;

	public List<OrgVO> getOrgList() {
		return orgList;
	}

	public void setOrgList(List<OrgVO> orgList) {
		this.orgList = orgList;
	}

	public List<EgovMap> getOnlnPltfrmAuthrtList() {
		return onlnPltfrmAuthrtList;
	}

	public void setOnlnPltfrmAuthrtList(List<EgovMap> onlnPltfrmAuthrtList) {
		this.onlnPltfrmAuthrtList = onlnPltfrmAuthrtList;
	}

	public OnlnPltfrmAuthrtVO getOnlnPltfrmAuthrtVO() {
		return onlnPltfrmAuthrtVO;
	}

	public void setOnlnPltfrmAuthrtVO(OnlnPltfrmAuthrtVO onlnPltfrmAuthrtVO) {
		this.onlnPltfrmAuthrtVO = onlnPltfrmAuthrtVO;
	}

	public ResultDTO<EgovMap> getResultDTO() {
		return resultDTO;
	}

	public void setResultDTO(ResultDTO<EgovMap> resultDTO) {
		this.resultDTO = resultDTO;
	}

}
