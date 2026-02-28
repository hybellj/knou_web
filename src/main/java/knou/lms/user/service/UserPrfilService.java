package knou.lms.user.service;

import knou.lms.user.vo.UserPrfilVO;

import java.util.List;

public interface UserPrfilService {

    UserPrfilVO userPrfilSelect(UserPrfilVO vo) throws Exception;

    void userPrfilAlimChange(UserPrfilVO vo) throws Exception;

    List<UserPrfilVO> userAllOrgAuthrtList(UserPrfilVO vo) throws Exception;

    List<UserPrfilVO> nowSmstrLectOrgList(UserPrfilVO vo) throws Exception;

    boolean isPswdMtch(UserPrfilVO vo) throws Exception;

    void modifyUserBasic(UserPrfilVO vo) throws Exception;

    void modifyUserCntct(UserPrfilVO vo) throws Exception;

    void modifyUserOrgAuthrt(UserPrfilVO vo) throws Exception;

    void uploadUserPhoto(UserPrfilVO vo) throws Exception;
}
