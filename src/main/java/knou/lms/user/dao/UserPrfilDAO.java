package knou.lms.user.dao;


import knou.lms.user.vo.UserPrfilVO;
import knou.lms.user.vo.UserTelnoChgHstryVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("userPrfilDAO")
public interface UserPrfilDAO {

    /**
     * 사용자 정보를 조회한다.
     *
     * @param vo UserPrfilVO
     * @return 사용자 정보
     * @throws Exception 사용자를 찾지 못한 경우
     * @since 1.0
     */

    public UserPrfilVO userPrfilSelect(UserPrfilVO vo) throws Exception;

    /**
     * 사용자 알림수신여부 변경
     *
     * @param vo UserPrfilVO
     * @throws Exception
     */
    void userPrfilAlimChange(UserPrfilVO vo) throws Exception;

    /**
     * 푸시톡문자수신플래그 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    UserPrfilVO pushTalkSmsFlagSelect(UserPrfilVO vo) throws Exception;

    /**
     * 사용자 모든 기관 목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    List<UserPrfilVO> userAllOrgAuthrtList(UserPrfilVO vo) throws Exception;

    /**
     * 현재학기 강의 기관 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    List<UserPrfilVO> nowSmstrLectOrgList(UserPrfilVO vo) throws Exception;

    int isPswdMtch(UserPrfilVO vo) throws Exception;

    void insertUserAuthrtByAuthrtSelect(UserPrfilVO vo) throws Exception;

    void deleteUserAuthrtByAuthrtIdList(UserPrfilVO vo) throws Exception;

    void modifyUserBasic(UserPrfilVO vo) throws Exception;

    void mergeUserCntct(UserPrfilVO vo) throws Exception;

    void telnoChgHstryRegist(UserTelnoChgHstryVO vo) throws Exception;

    String userCntctSelect(UserPrfilVO vo) throws Exception;
}
