package knou.lms.smnr.pltfrm.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;

@Mapper("onlnPltfrmAuthrtDAO")
public interface OnlnPltfrmAuthrtDAO {

	/**
	 * 온라인플랫폼권한조회
	 *
	 * @param onlnPltfrmStngId 	온라인플랫폼설정아이디
	 * @return OnlnPltfrmAuthrtVO
	 * @throws Exception
	 */
	public OnlnPltfrmAuthrtVO onlnPltfrmAuthrtSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId) throws Exception;

	/**
	 * 온라인플랫폼권한아이디조회
	 *
	 * @param onlnPltfrmStngId 	온라인플랫폼설정아이디
	 * @param authrtEml 			권한이메일
	 * @return String
	 * @throws Exception
	 */
	public String onlnPltfrmAuthrtIdSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId, @Param("authrtEml") String authrtEml) throws Exception;

	/**
	 * 온라인플랫폼권한등록
	 *
	 * @param OnlnPltfrmAuthrtVO
	 * @throws Exception
	 */
	public void onlnPltfrmAuthrtRegist(OnlnPltfrmAuthrtVO vo) throws Exception;

}
