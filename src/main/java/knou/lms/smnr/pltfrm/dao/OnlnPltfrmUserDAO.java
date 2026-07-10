package knou.lms.smnr.pltfrm.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.web.view.SmnrPageInfo;

@Mapper("onlnPltfrmUserDAO")
public interface OnlnPltfrmUserDAO {

	// 온라인플랫폼사용자목록삭제
	public void onlnPltfrmUserListDelete(Map<String, Object> map);

	// 온라인플랫폼사용자일괄등록
	public void onlnPltfrmUserBulkRegist(List<OnlnPltfrmUserVO> list);

	// 온라인플랫폼사용자목록조회
	public List<OnlnPltfrmUserVO> onlnPltfrmUserList(@Param("onlnPltfrmAuthrtId") String onlnPltfrmAuthrtId);

	// 대기중온라인플랫폼사용자조회
	public OnlnPltfrmUserVO pendingOnlnPltfrmUserSelect(@Param("onlnPltfrmStngId") String onlnPltfrmStngId, @Param("meetngrmSdttm") String meetngrmSdttm, @Param("meetngrmEdttm") String meetngrmEdttm);

	// 대기중온라인플랫폼사용자수조회
	public int pendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs);

	// 온라인플랫폼기관사용자목록
	public List<EgovMap> onlnPltfrmOrgUserList(SmnrPageInfo pageInfo);

	// 온라인플랫폼사용자일괄삭제
	public void onlnPltfrmUserBulkDelete(@Param("onlnPltfrmStngId") String onlnPltfrmStngId);

}
