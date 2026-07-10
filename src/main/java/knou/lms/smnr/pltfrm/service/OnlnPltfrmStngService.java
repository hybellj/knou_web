package knou.lms.smnr.pltfrm.service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

public interface OnlnPltfrmStngService {

	// 온라인플랫폼설정등록
	public ResultDTO<EgovMap> onlnPltfrmStngRegist(OnlnPltfrmStngVO vo);

	// 온라인플랫폼설정삭제
	public void onlnPltfrmStngDelete(OnlnPltfrmStngVO vo);

	// 온라인플랫폼설정조회
	public OnlnPltfrmStngVO onlnPltfrmStngSelect(String pltfrmGbncd, String orgId);

}
