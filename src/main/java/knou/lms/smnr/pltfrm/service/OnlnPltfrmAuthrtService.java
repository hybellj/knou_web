package knou.lms.smnr.pltfrm.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

public interface OnlnPltfrmAuthrtService {

	// 온라인플랫폼권한갱신
	public OnlnPltfrmAuthrtVO onlnPltfrmAuthrtUpdt(String pltfrmGbncd, String orgId, String userId);

	// 온라인플랫폼권한목록
	public List<EgovMap> onlnPltfrmAuthrtList(OnlnPltfrmStngVO vo);

	// 온라인플랫폼권한일괄삭제
	public void onlnPltfrmAuthrtBulkDelete(String onlnPltfrmStngId);

}
