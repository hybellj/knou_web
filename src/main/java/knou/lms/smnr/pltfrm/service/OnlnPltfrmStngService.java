package knou.lms.smnr.pltfrm.service;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;

public interface OnlnPltfrmStngService {

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
	public OnlnPltfrmStngVO onlnPltfrmStngSelect(String pltfrmGbncd, String orgId) throws Exception;

}
