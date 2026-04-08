package knou.lms.smnr.pltfrm.service;

import java.util.List;
import java.util.Map;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;

public interface OnlnPltfrmUserService {

	/**
     * 온라인플랫폼사용자일괄등록
     *
     * @param OnlnPltfrmAuthrtVO	온라인플랫폼권한
     * @param userId				사용자아이디
     * @throws Exception
     */
	public void onlnPltfrmUserBulkRegist(OnlnPltfrmAuthrtVO authrtVO, String userId) throws Exception;

	/**
     * 온라인플랫폼사용자목록조회
     *
     * @param onlnPltfrmAuthrtId	온라인플랫폼권한아이디
     * @throws Exception
     */
	public List<OnlnPltfrmUserVO> onlnPltfrmUserList(String onlnPltfrmAuthrtId) throws Exception;

	/**
	* 대기중온라인플랫폼사용자조회
	*
	* @param onlnPltfrmStngId	온라인플랫폼설정아이디
	* @param meetngrmSdttm		회의실시작일시
	* @param meetngrmEdttm		회의실종료일시
	* @return 대기중온라인플랫폼사용자정보
	* @throws Exception
	*/
	public OnlnPltfrmUserVO pendingOnlnPltfrmUserSelect(String onlnPltfrmStngId, String meetngrmSdttm, String meetngrmEdttm) throws Exception;

	/**
	* 대기중온라인플랫폼사용자수조회
	*
	* @param pltfrmGbncd	플랫폼구분코드
	* @param meetngrmSdttm	회의실시작일시
	* @param meetngrmEdttm	회의실종료일시
	* @return 대기중온라인플랫폼사용자수
	* @throws Exception
	*/
	public int pendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs) throws Exception;

}
