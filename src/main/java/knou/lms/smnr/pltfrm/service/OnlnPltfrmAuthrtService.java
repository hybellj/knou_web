package knou.lms.smnr.pltfrm.service;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;

public interface OnlnPltfrmAuthrtService {

	/**
     * 온라인플랫폼권한조회
     *
     * @param pltfrmGbncd	플랫폼구분코드
     * @param orgId	 		기관아이디
     * @param userId	 	사용자아이디
     * @return 온라인플랫폼권한
     * @throws Exception
     */
	public OnlnPltfrmAuthrtVO onlnPltfrmAuthrtSelect(String pltfrmGbncd, String orgId, String userId) throws Exception;

}
