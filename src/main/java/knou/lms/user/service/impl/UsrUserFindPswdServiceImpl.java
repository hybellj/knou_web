package knou.lms.user.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.user.dao.UsrUserFindPswdDAO;
import knou.lms.user.service.UsrUserFindPswdService;
import knou.lms.user.vo.UsrUserFindPswdVO;

@Service("usrUserFindPswdService")
public class UsrUserFindPswdServiceImpl extends ServiceBase implements UsrUserFindPswdService {
    
    @Resource(name="usrUserFindPswdDAO")
    private UsrUserFindPswdDAO usrUserFindPswdDAO;

    /*****************************************************
     * <p>
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 수를 카운트 한다.
     * </p>
     * 비밀번호 찾기 EMAIL/SMS 템플릿 수를 카운트 한다.
     * 
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int count(UsrUserFindPswdVO vo) throws Exception {
        return usrUserFindPswdDAO.count(vo);
    }

    /*****************************************************
     * <p>
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 조회한다.
     * </p>
     * 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 조회한다.
     * 
     * @param UsrUserFindPswdVO
     * @return UsrUserFindPswdVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrUserFindPswdVO select(UsrUserFindPswdVO vo) throws Exception {
        return usrUserFindPswdDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 등록한다.
     * </p>
     * 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 등록한다.
     * 
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int insert(UsrUserFindPswdVO vo) throws Exception {
        return usrUserFindPswdDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 수정한다.
     * </p>
     * 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 수정한다.
     * 
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int update(UsrUserFindPswdVO vo) throws Exception {
        return usrUserFindPswdDAO.update(vo);
    }

    /*****************************************************
     * <p>
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 삭제한다.
     * </p>
     * 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 삭제한다.
     * 
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int delete(UsrUserFindPswdVO vo) throws Exception {
        return usrUserFindPswdDAO.delete(vo);
    }

    /*****************************************************
     * <p>
     * TODO 비밀번호 찾기 이메일 템플릿 변수 적용결과 조회
     * </p>
     * 비밀번호 찾기 이메일 템플릿 변수 적용결과 조회
     * 
     * @param 
     * @return UsrUserFindPswdVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrUserFindPswdVO getResetPassEmailTpl() throws Exception {
        UsrUserFindPswdVO vo = new UsrUserFindPswdVO();
        vo.setFindPswdTypeCd("RESET_PASS_EMAIL");
        return this.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 비밀번호 초기화 이메일 템플릿 변수 적용결과 조회
     * </p>
     * 비밀번호 초기화 이메일 템플릿 변수 적용결과 조회
     * 
     * @param 
     * @return UsrUserFindPswdVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrUserFindPswdVO getResetPassResultEmailTpl() throws Exception {
        UsrUserFindPswdVO vo = new UsrUserFindPswdVO();
        vo.setFindPswdTypeCd("RESET_PASS_RESULT_EMAIL");
        return this.select(vo);
    }

}
