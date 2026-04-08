package knou.lms.smnr.pltfrm.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;

@Mapper("onlnPltfrmUserDAO")
public interface OnlnPltfrmUserDAO {

	/**
	 * 온라인플랫폼사용자일괄삭제
	 *
	 * @param onlnPltfrmAuthrtId	온라인플랫폼권한아이디
	 * @throws Exception
	 */
	public void onlnPltfrmUserBulkDelete(Map<String, Object> map) throws Exception;

	/**
	 * 온라인플랫폼사용자일괄등록
	 *
	 * @param List<OnlnPltfrmUserVO>
	 * @throws Exception
	 */
	public void onlnPltfrmUserBulkRegist(List<OnlnPltfrmUserVO> list) throws Exception;

	/**
	* 온라인플랫폼사용자목록조회
	*
	* @param onlnPltfrmAuthrtId	온라인플랫폼권한아이디
	* @return 온라인플랫폼사용자목록
	* @throws Exception
	*/
	public List<OnlnPltfrmUserVO> onlnPltfrmUserList(@Param("onlnPltfrmAuthrtId") String onlnPltfrmAuthrtId) throws Exception;

	/**
	* 대기중온라인플랫폼사용자조회
	*
	* @param onlnPltfrmStngId	온라인플랫폼설정아이디
	* @param meetngrmSdttm		회의실시작일시
	* @param meetngrmEdttm		회의실종료일시
	* @return 대기중온라인플랫폼사용자정보
	* @throws Exception
	*/
	public OnlnPltfrmUserVO pendingOnlnPltfrmUserSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId, @Param("meetngrmSdttm") String meetngrmSdttm, @Param("meetngrmEdttm") String meetngrmEdttm) throws Exception;

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
