package knou.lms.smnr.pltfrm.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.pltfrm.dao.OnlnPltfrmUserDAO;
import knou.lms.smnr.pltfrm.service.OnlnPltfrmUserService;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmAuthrtVO;
import knou.lms.smnr.pltfrm.vo.OnlnPltfrmUserVO;
import knou.lms.smnr.pltfrm.zoom.api.users.service.ZoomUserService;
import knou.lms.smnr.pltfrm.zoom.api.users.vo.ZoomUserListVO;
import knou.lms.smnr.pltfrm.zoom.api.users.vo.ZoomUserVO;
import knou.lms.smnr.web.view.SmnrPageInfo;

@Service("onlnPltfrmUserService")
public class OnlnPltfrmUserServiceImpl extends ServiceBase implements OnlnPltfrmUserService {

	@Resource(name="zoomUserService")
	private ZoomUserService zoomUserService;

	@Resource(name="onlnPltfrmUserDAO")
	private OnlnPltfrmUserDAO onlnPltfrmUserDAO;

	/**
     * 온라인플랫폼사용자일괄등록
     *
     * @param OnlnPltfrmAuthrtVO	온라인플랫폼권한
     * @param userId				사용자아이디
     */
	public int onlnPltfrmUserBulkRegist(OnlnPltfrmAuthrtVO authrtVO, String userId) {
		// ZOOM 사용자 목록 조회
        ZoomUserListVO userListVO = zoomUserService.zoomUserList(authrtVO.getAuthrtTkn());
        List<ZoomUserVO> users = userListVO.getObjects();

        // Licensed(type=2) 사용자만 필터링
        List<ZoomUserVO> licensedUsers = users.stream()
            .filter(u -> u.getType() == 2)
            .collect(Collectors.toList());

        // 온라인플랫폼사용자목록삭제 ( 이메일 불일치시 )
        Map<String, Object> param = new HashMap<>();
        List<String> emailList = licensedUsers.stream()
        		.map(ZoomUserVO::getEmail)
        		.collect(Collectors.toList());
        param.put("list", emailList);
        param.put("onlnPltfrmAuthrtId", authrtVO.getOnlnPltfrmAuthrtId());
        if(emailList.size() > 0) onlnPltfrmUserDAO.onlnPltfrmUserListDelete(param);

        // 온라인플랫폼사용자목록
        List<OnlnPltfrmUserVO> userList = onlnPltfrmUserDAO.onlnPltfrmUserList(authrtVO.getOnlnPltfrmAuthrtId());
        // 제거할 이메일 Set 만들기
        Set<String> excludeEmails = userList.stream()
            .map(OnlnPltfrmUserVO::getPltfrmUserEml)
            .collect(Collectors.toSet());

        // 동일한 이메일 제거
        List<ZoomUserVO> filteredList = licensedUsers.stream()
            .filter(vo -> !excludeEmails.contains(vo.getEmail()))
            .collect(Collectors.toList());

        // 일괄등록용 사용자목록
        List<OnlnPltfrmUserVO> pltfrmUserList = new ArrayList<OnlnPltfrmUserVO>();
        for (ZoomUserVO user : filteredList) {
            OnlnPltfrmUserVO userVO = new OnlnPltfrmUserVO();
        	userVO.setOnlnPltfrmUserId(IdGenUtil.genNewId(IdPrefixType.OPLUS));
        	userVO.setOnlnPltfrmAuthrtId(authrtVO.getOnlnPltfrmAuthrtId());
            userVO.setPltfrmUserId(user.getId());
            userVO.setPltfrmUserEml(user.getEmail());
            userVO.setPltfrmUserTycd("Licensed");
            userVO.setPltfrmUserStscd(user.getStatus());
            userVO.setRgtrId(userId);
            pltfrmUserList.add(userVO);
        }
        if(pltfrmUserList.size() > 0) onlnPltfrmUserDAO.onlnPltfrmUserBulkRegist(pltfrmUserList);	// 온라인플랫폼사용자일괄등록
        return licensedUsers.size();
	}

	/**
     * 온라인플랫폼사용자목록조회
     *
     * @param onlnPltfrmAuthrtId	온라인플랫폼권한아이디
     */
	@Override
	public List<OnlnPltfrmUserVO> onlnPltfrmUserList(String onlnPltfrmAuthrtId) {
		return onlnPltfrmUserDAO.onlnPltfrmUserList(onlnPltfrmAuthrtId);
	}

	/**
	* 대기중온라인플랫폼사용자조회
	*
	* @param onlnPltfrmStngId	온라인플랫폼설정아이디
	* @param meetngrmSdttm		회의실시작일시
	* @param meetngrmEdttm		회의실종료일시
	* @return 대기중온라인플랫폼사용자정보
	*/
	@Override
	public OnlnPltfrmUserVO pendingOnlnPltfrmUserSelect(String onlnPltfrmStngId, String meetngrmSdttm, String meetngrmEdttm) {
		return onlnPltfrmUserDAO.pendingOnlnPltfrmUserSelect(onlnPltfrmStngId, meetngrmSdttm, meetngrmEdttm);
	}

	/**
	* 대기중온라인플랫폼사용자수조회
	*
	* @param pltfrmGbncd	플랫폼구분코드
	* @param meetngrmSdttm	회의실시작일시
	* @param meetngrmEdttm	회의실종료일시
	* @return 대기중온라인플랫폼사용자수
	*/
	@Override
	public int pendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs) {
		return onlnPltfrmUserDAO.pendingOnlnPltfrmUserCntSelect(subSmnrs);
	}

	/**
	 * 온라인플랫폼기관사용자목록
	 *
	 * @param orgId 		기관아이디
	 * @param searchValue 	검색어(계정이메일)
	 * @param pltfrmGbncd 	플랫폼구분코드
	 * @return ResultDTO<EgovMap>
	 */
	@Override
	public ResultDTO<EgovMap> onlnPltfrmOrgUserList(SmnrPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(onlnPltfrmUserDAO.onlnPltfrmOrgUserList(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	 * 온라인플랫폼사용자일괄삭제
	 *
	 * @param onlnPltfrmStngId	온라인플랫폼설정아이디
	 */
	@Override
	public void onlnPltfrmUserBulkDelete(String onlnPltfrmStngId) {
		onlnPltfrmUserDAO.onlnPltfrmUserBulkDelete(onlnPltfrmStngId);
	}

}
