package knou.lms.user.facade;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.org.service.OrgInfoService;
import knou.lms.user.dao.UsrUserAuthGrpDAO;
import knou.lms.user.service.UserPrfilService;
import knou.lms.user.vo.UserPrfilVO;
import knou.lms.user.vo.UserPrfilView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service("userPrfilFacadeService")
public class UserPrfilFacadeServiceImpl extends ServiceBase implements UserPrfilFacadeService {
    private static final Logger LOGGER = LoggerFactory.getLogger(UserPrfilFacadeServiceImpl.class);


    @Resource(name="userPrfilService")
    private UserPrfilService userPrfilService;

    @Resource(name="orgInfoService")
    private OrgInfoService orgInfoService;
    @Resource(name="usrUserAuthGrpDAO")
    private UsrUserAuthGrpDAO usrUserAuthGrpDAO;


    /**
     * 사용자프로필불러오기
     *
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public UserPrfilView loadUserPrfil(UserContext userCtx) throws Exception {

        UserPrfilView userPrfilView = new UserPrfilView();

        UserPrfilVO paramVO = new UserPrfilVO();
        paramVO.setUserId(userCtx.getUserId());
        paramVO.setAuthrtGrpcd(userCtx.getAuthrtGrpcd());

        // 사용자프로필정보 조회
        UserPrfilVO userPrfilVO = userPrfilService.userPrfilSelect(paramVO);
        userPrfilVO.setAuthrtCd(userCtx.getAuthrtCd());
        userPrfilVO.setAuthrtGrpcd(userCtx.getAuthrtGrpcd());
        userPrfilView.setUserPrfilVO(userPrfilVO);

        // 사용자 등록된 전체기관권한 조회
        userPrfilView.setUserAuthrtList(userPrfilService.userAllOrgAuthrtList(paramVO));

        return userPrfilView;
    }

    /***
     * 사용자프로필 수정 불러오기
     * @param userCtx
     * @return
     * @throws Exception
     */
    @Override
    public UserPrfilView loadUserPrfilModify(UserContext userCtx) throws Exception {
        UserPrfilView userPrfilView = new UserPrfilView();

        UserPrfilVO paramVO = new UserPrfilVO();
        paramVO.setUserId(userCtx.getUserId());
        paramVO.setAuthrtGrpcd(userCtx.getAuthrtGrpcd());

        // 사용자프로필정보 조회
        UserPrfilVO userPrfilVO = userPrfilService.userPrfilSelect(paramVO);
        userPrfilVO.setAuthrtCd(userCtx.getAuthrtCd());
        userPrfilVO.setAuthrtGrpcd(userCtx.getAuthrtGrpcd());
        userPrfilView.setUserPrfilVO(userPrfilVO);
        // 사용자 등록된 전체기관권한 조회
        userPrfilView.setUserAuthrtList(userPrfilService.userAllOrgAuthrtList(paramVO));
        // 현재학기 강의하는 기관 목록 조회
        userPrfilView.setNowSmstrLectOrgList(userPrfilService.nowSmstrLectOrgList(paramVO));


        return userPrfilView;
    }

    /**
     * 사용자 프로필 수정
     *
     * @param userCtx
     * @param vo
     * @throws Exception
     */
    @Override
    public void modifyUserPrfil(UserContext userCtx, UserPrfilVO vo) throws Exception {
        vo.setOrgId(userCtx.getOrgId());
        vo.setUserId(userCtx.getUserId());
        vo.setMdfrId(userCtx.getUserId());
        vo.setAuthrtGrpcd(userCtx.getAuthrtGrpcd());

        if("PROF".equals(userCtx.getAuthrtGrpcd())) {
            vo.setAuthrtCd("PROF");
        }

        // TODO 사용자 프로필 사진 처리
        userPrfilService.uploadUserPhoto(vo);
        // TODO 파일url 가져와서 세션 갱신하기
        
        // 사용자 기본정보 수정
        userPrfilService.modifyUserBasic(vo);
        // 연락처 정보 수정
        userPrfilService.modifyUserCntct(vo);
        // 사용자 기관 권한 수정
        userPrfilService.modifyUserOrgAuthrt(vo);
    }
}
