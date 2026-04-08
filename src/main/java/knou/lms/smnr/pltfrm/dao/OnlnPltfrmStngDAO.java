package knou.lms.smnr.pltfrm.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

@Mapper("onlnPltfrmStngDAO")
public interface OnlnPltfrmStngDAO {

	/**
	 * 온라인플랫폼설정등록
	 *
	 * @param OnlnPltfrmStngVO
	 * @throws Exception
	 */
	public void onlnPltfrmStngRegist(OnlnPltfrmStngVO vo) throws Exception;

	/**
	 * 온라인플랫폼설정수정
	 *
	 * @param OnlnPltfrmStngVO
	 * @throws Exception
	 */
	public void onlnPltfrmStngModify(OnlnPltfrmStngVO vo) throws Exception;

	/**
	 * 온라인플랫폼설정삭제
	 *
	 * @param OnlnPltfrmStngVO
	 * @throws Exception
	 */
	public void onlnPltfrmStngDelete(OnlnPltfrmStngVO vo) throws Exception;

	/**
	 * 온라인플랫폼설정조회
	 *
	 * @param pltfrmGbncd	플랫폼구분코드
	 * @param orgId			기관아이디
	 * @return 온라인플랫폼설정
	 * @throws Exception
	 */
	public OnlnPltfrmStngVO onlnPltfrmStngSelect(@Param("pltfrmGbncd") String pltfrmGbncd, @Param("orgId") String orgId) throws Exception;

}
