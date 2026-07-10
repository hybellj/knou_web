package knou.lms.user.facade.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.facade.UserMgrDeptFacadeService;
import knou.lms.user.service.UserMgrDeptService;
import knou.lms.user.vo.UserMgrDeptListVO;
import knou.lms.user.vo.UserMgrDeptVO;
import knou.lms.user.web.view.UserMgrDeptListView;

@Service("userMgrDeptFacadeService")
public class UserMgrDeptFacadeServiceImpl implements UserMgrDeptFacadeService {

    @Resource(name = "userMgrDeptService")
    private UserMgrDeptService userMgrDeptService;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    /*****************************************************
     * 학과/부서 관리 목록 화면 View 조회
     * @param vo
     * @param userCtx
     * @return UserMgrDeptListView
     * @throws Exception
     ******************************************************/
    @Override
    public UserMgrDeptListView userMgrDeptListView(UserMgrDeptListVO vo, UserContext userCtx) throws Exception {
        String orgId = resolveOrgId(vo.getOrgId(), userCtx);
        vo.setOrgId(orgId);

        UserMgrDeptListView view = new UserMgrDeptListView();
        view.setOrgList(getOrgList(userCtx));
        view.setDeptCodeList(getDeptCodeList(orgId));
        view.setAllOrgYn(isSysAdmin(userCtx) ? "Y" : "N");
        view.setHaksaSyncYn(isSysAdmin(userCtx) ? "N" : "Y");
        return view;
    }

    /*****************************************************
     * 학과/부서 목록 조회
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> listUserMgrDept(UserMgrDeptListVO vo, UserContext userCtx) {
        vo.setOrgId(resolveOrgId(vo.getOrgId(), userCtx));
        return userMgrDeptService.listUserMgrDept(vo);
    }

    /*****************************************************
     * 학과/부서 상위 코드 목록 조회 (기관 변경 시)
     * @param vo
     * @param userCtx
     * @return List<UserMgrDeptVO>
     ******************************************************/
    @Override
    public List<UserMgrDeptVO> listUserMgrDeptCode(UserMgrDeptVO vo, UserContext userCtx) {
        return getDeptCodeList(resolveOrgId(vo.getOrgId(), userCtx));
    }

    /*****************************************************
     * 학과/부서 단건 조회 (수정 폼)
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> selectUserMgrDept(UserMgrDeptVO vo, UserContext userCtx) {
        ResultDTO<UserMgrDeptVO> resultDTO = new ResultDTO<UserMgrDeptVO>();
        vo.setOrgId(resolveOrgId(vo.getOrgId(), userCtx));

        if (isBlank(vo.getDeptId())) {
            return resultDTO.setResultFailed("학과/부서를 선택해 주세요.");
        }

        UserMgrDeptVO detail = userMgrDeptService.selectUserMgrDept(vo);
        if (detail == null) {
            return resultDTO.setResultFailed("학과/부서 정보를 확인할 수 없습니다.");
        }
        return resultDTO.setData(detail).setResultSuccess();
    }

    /*****************************************************
     * 학과/부서 등록
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> registUserMgrDept(UserMgrDeptVO vo, UserContext userCtx) {
        vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx));
        vo.setRgtrId(getUserId(userCtx));
        vo.setMdfrId(getUserId(userCtx));
        return userMgrDeptService.insertUserMgrDept(vo);
    }

    /*****************************************************
     * 학과/부서 수정
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> modifyUserMgrDept(UserMgrDeptVO vo, UserContext userCtx) {
        vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx));
        vo.setMdfrId(getUserId(userCtx));
        return userMgrDeptService.updateUserMgrDept(vo);
    }

    /*****************************************************
     * 학과/부서 삭제
     * @param vo
     * @param userCtx
     * @return ResultDTO<UserMgrDeptVO>
     ******************************************************/
    @Override
    public ResultDTO<UserMgrDeptVO> deleteUserMgrDept(UserMgrDeptVO vo, UserContext userCtx) {
        vo.setOrgId(resolveRequiredOrgId(vo.getOrgId(), userCtx));
        return userMgrDeptService.deleteUserMgrDept(vo);
    }

    /*****************************************************
     * 학과/부서 학사연동 실행 (VW_HAK_DEPT_INF Upsert)
     * @param vo
     * @param userCtx
     * @return ResultDTO<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> runUserMgrDeptHaksaSync(UserMgrDeptVO vo, UserContext userCtx) {
        String orgId = resolveRequiredOrgId(vo.getOrgId(), userCtx);
        if (isBlank(orgId)) {
            return new ResultDTO<EgovMap>().setResultFailed("기관 정보를 확인할 수 없습니다.");
        }

        vo.setOrgId(orgId);
        vo.setRgtrId(getUserId(userCtx));
        vo.setMdfrId(getUserId(userCtx));
        return userMgrDeptService.mergeUserMgrDeptHaksaSync(vo);
    }

    /*****************************************************
     * 목록/조회 경로 기관 ID 결정 (비관리자는 본인 기관 강제)
     * @param orgId
     * @param userCtx
     * @return String
     ******************************************************/
    private String resolveOrgId(String orgId, UserContext userCtx) {
        if (!isSysAdmin(userCtx)) {
            return getOrgId(userCtx);
        }
        return StringUtil.nvl(orgId);
    }

    /*****************************************************
     * 저장 경로 기관 ID 결정
     * @param orgId
     * @param userCtx
     * @return String
     ******************************************************/
    private String resolveRequiredOrgId(String orgId, UserContext userCtx) {
        if (!isSysAdmin(userCtx)) {
            return getOrgId(userCtx);
        }
        return StringUtil.nvl(orgId);
    }

    /*****************************************************
     * 사용자 권한 기준 기관 목록 조회
     * @param userCtx
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    private List<OrgInfoVO> getOrgList(UserContext userCtx) throws Exception {
        List<OrgInfoVO> orgList = orgInfoService.listActiveOrg();
        if (isSysAdmin(userCtx)) {
            return orgList;
        }
        return filterOrgList(orgList, getOrgId(userCtx));
    }

    /*****************************************************
     * 단일 기관 관리자용 기관 목록 필터링
     * @param orgList
     * @param orgId
     * @return List<OrgInfoVO>
     ******************************************************/
    private List<OrgInfoVO> filterOrgList(List<OrgInfoVO> orgList, String orgId) {
        List<OrgInfoVO> filteredList = new ArrayList<OrgInfoVO>();
        String value = StringUtil.nvl(orgId);
        if (value.isEmpty() || orgList == null) {
            return filteredList;
        }
        for (OrgInfoVO orgInfoVO : orgList) {
            if (orgInfoVO != null && value.equals(StringUtil.nvl(orgInfoVO.getOrgId()))) {
                filteredList.add(orgInfoVO);
            }
        }
        return filteredList;
    }

    /*****************************************************
     * 기관 기준 상위 학과/부서 코드 목록 조회
     * @param orgId
     * @return List<UserMgrDeptVO>
     ******************************************************/
    private List<UserMgrDeptVO> getDeptCodeList(String orgId) {
        if (isBlank(orgId)) {
            return new ArrayList<UserMgrDeptVO>();
        }
        UserMgrDeptVO codeVo = new UserMgrDeptVO();
        codeVo.setOrgId(orgId);
        return userMgrDeptService.listUserMgrDeptCode(codeVo);
    }

    /*****************************************************
     * 전체시스템관리자 여부 (권한코드 ADM)
     *  - 학과/부서관리 메뉴는 전체시스템관리자(ADM)/기관관리자(ORGOP)만 접근하므로
     *    ADM이 아니면 기관관리자(ORGOP)로 간주한다.
     * @param userCtx
     * @return boolean
     ******************************************************/
    private boolean isSysAdmin(UserContext userCtx) {
        String authrtCd = userCtx != null ? StringUtil.nvl(userCtx.getAuthrtCd()) : "";
        return CommConst.AUTHRT_CD_ADM.equals(authrtCd);
    }

    /*****************************************************
     * 현재 사용자 ID 조회
     * @param userCtx
     * @return String
     ******************************************************/
    private String getUserId(UserContext userCtx) {
        return userCtx != null ? StringUtil.nvl(userCtx.getUserId()) : "";
    }

    /*****************************************************
     * 현재 기관 ID 조회
     * @param userCtx
     * @return String
     ******************************************************/
    private String getOrgId(UserContext userCtx) {
        return userCtx != null ? StringUtil.nvl(userCtx.getOrgId()) : "";
    }

    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
