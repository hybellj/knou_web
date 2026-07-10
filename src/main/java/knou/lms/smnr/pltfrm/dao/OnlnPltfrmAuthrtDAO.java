package knou.lms.smnr.pltfrm.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

@Mapper("onlnPltfrmAuthrtDAO")
public interface OnlnPltfrmAuthrtDAO {

	// 온라인플랫폼권한조회
	public OnlnPltfrmAuthrtVO onlnPltfrmAuthrtSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId);

	// 온라인플랫폼권한아이디조회
	public String onlnPltfrmAuthrtIdSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId, @Param("authrtEml") String authrtEml);

	// 온라인플랫폼권한등록
	public void onlnPltfrmAuthrtRegist(OnlnPltfrmAuthrtVO vo);

	// 온라인플랫폼권한목록
	public List<EgovMap> onlnPltfrmAuthrtList(OnlnPltfrmStngVO vo);

	// 온라인플랫폼권한일괄삭제
	public void onlnPltfrmAuthrtBulkDelete(@Param("onlnPltfrmStngId") String onlnPltfrmStngId);

}
