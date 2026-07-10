package knou.lms.smnr.pltfrm.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.web.view.SmnrPageInfo;

public interface OnlnPltfrmUserService {

	// 온라인플랫폼사용자일괄등록
	public int onlnPltfrmUserBulkRegist(OnlnPltfrmAuthrtVO authrtVO, String userId);

	// 온라인플랫폼사용자목록조회
	public List<OnlnPltfrmUserVO> onlnPltfrmUserList(String onlnPltfrmAuthrtId);

	// 대기중온라인플랫폼사용자조회
	public OnlnPltfrmUserVO pendingOnlnPltfrmUserSelect(String onlnPltfrmStngId, String meetngrmSdttm, String meetngrmEdttm);

	// 대기중온라인플랫폼사용자수조회
	public int pendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs);

	// 온라인플랫폼기관사용자목록
	public ResultDTO<EgovMap> onlnPltfrmOrgUserList(SmnrPageInfo pageInfo);

	// 온라인플랫폼사용자일괄삭제
	public void onlnPltfrmUserBulkDelete(String onlnPltfrmStngId);

}
