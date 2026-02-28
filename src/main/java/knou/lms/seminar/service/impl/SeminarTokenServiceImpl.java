package knou.lms.seminar.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.seminar.dao.SeminarTokenDAO;
import knou.lms.seminar.service.SeminarTokenService;
import knou.lms.seminar.vo.SeminarTokenVO;
import knou.lms.seminar.vo.SeminarVO;

@Service("seminarTokenService")
public class SeminarTokenServiceImpl extends ServiceBase implements SeminarTokenService {
    
    @Resource(name="seminarTokenDAO")
    private SeminarTokenDAO seminarTokenDAO;

    /*****************************************************
     * <p>
     * TODO 세미나 OAuth 토큰 정보 조회
     * </p>
     * 세미나 OAuth 토큰 정보 조회
     * 
     * @param SeminarTokenVO
     * @return SeminarTokenVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarTokenVO selectAccessToken(SeminarTokenVO vo) throws Exception {
        return seminarTokenDAO.selectAccessToken(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 OAuth 토큰 등록
     * </p>
     * 세미나 OAuth 토큰 등록
     * 
     * @param SeminarTokenVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertAccessToken(SeminarTokenVO vo) throws Exception {
        String tokenId = IdGenerator.getNewId("TOKEN");
        vo.setTokenId(tokenId);
        seminarTokenDAO.insertAccessToken(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 OAuth 토큰 수정
     * </p>
     * 세미나 OAuth 토큰 수정
     * 
     * @param SeminarTokenVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateAccessToken(SeminarTokenVO vo) throws Exception {
        seminarTokenDAO.updateAccessToken(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 OAuth 토큰 삭제
     * </p>
     * 세미나 OAuth 토큰 삭제
     * 
     * @param SeminarTokenVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteAccessToken(SeminarTokenVO vo) throws Exception {
        seminarTokenDAO.deleteAccessToken(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 OAuth 토큰 여부 조회
     * </p>
     * 세미나 OAuth 토큰 여부 조회
     * 
     * @param SeminarVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int countByCreCrs(SeminarVO vo) throws Exception {
        return seminarTokenDAO.countByCreCrs(vo);
    }

}
