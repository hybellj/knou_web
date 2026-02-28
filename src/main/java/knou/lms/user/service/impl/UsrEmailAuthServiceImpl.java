package knou.lms.user.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.user.dao.UsrEmailAuthDAO;
import knou.lms.user.service.UsrEmailAuthService;
import knou.lms.user.vo.UsrEmailAuthVO;

@Service("usrEmailAuthService")
public class UsrEmailAuthServiceImpl extends ServiceBase implements UsrEmailAuthService {

    @Resource(name="usrEmailAuthDAO")
    private UsrEmailAuthDAO usrEmailAuthDAO;

    /*****************************************************
     * <p>
     * TODO 이메일 인증 관리 정보 조회
     * </p>
     * 이메일 인증 관리 정보 조회
     *
     * @param UsrEmailAuthVO
     * @return UsrEmailAuthVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrEmailAuthVO select(UsrEmailAuthVO vo) throws Exception {
        return usrEmailAuthDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 이메일 인증 관리 정보 등록
     * </p>
     * 이메일 인증 관리 정보 등록
     *
     * @param UsrEmailAuthVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(UsrEmailAuthVO vo) throws Exception {
        usrEmailAuthDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * TODO 이메일 인증 관리 정보 수정
     * </p>
     * 이메일 인증 관리 정보 수정
     *
     * @param UsrEmailAuthVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(UsrEmailAuthVO vo) throws Exception {
        usrEmailAuthDAO.update(vo);
    }

}
