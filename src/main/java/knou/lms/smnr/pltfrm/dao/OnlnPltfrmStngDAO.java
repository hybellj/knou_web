package knou.lms.smnr.pltfrm.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

@Mapper("onlnPltfrmStngDAO")
public interface OnlnPltfrmStngDAO {

	// 온라인플랫폼설정등록
	public void onlnPltfrmStngRegist(OnlnPltfrmStngVO vo);

	// 온라인플랫폼설정삭제
	public void onlnPltfrmStngDelete(OnlnPltfrmStngVO vo);

	// 온라인플랫폼설정조회
	public OnlnPltfrmStngVO onlnPltfrmStngSelect(@Param("pltfrmGbncd") String pltfrmGbncd, @Param("orgId") String orgId);

}
