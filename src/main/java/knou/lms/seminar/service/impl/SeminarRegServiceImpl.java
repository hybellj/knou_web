package knou.lms.seminar.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.seminar.dao.SeminarRegDAO;
import knou.lms.seminar.service.SeminarRegService;
import knou.lms.seminar.vo.SeminarRegVO;

@Service("seminarRegService")
public class SeminarRegServiceImpl extends ServiceBase implements SeminarRegService {
    
    @Resource(name="seminarRegDAO")
    private SeminarRegDAO seminarRegDAO;

    /*****************************************************
     * <p>
     * TODO 세미나 사전 등록 참가자 정보 조회
     * </p>
     * 세미나 사전 등록 참가자 정보 조회
     * 
     * @param SeminarRegVO
     * @return SeminarRegVO
     * @throws Exception
     ******************************************************/
    @Override
    public SeminarRegVO select(SeminarRegVO vo) throws Exception {
        return seminarRegDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 사전 등록 참가자 목록 조회
     * </p>
     * 세미나 사전 등록 참가자 목록 조회
     * 
     * @param SeminarRegVO
     * @return List<SeminarRegVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SeminarRegVO> list(SeminarRegVO vo) throws Exception {
        return seminarRegDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 사전 등록 참가자 등록
     * </p>
     * 세미나 사전 등록 참가자 등록
     * 
     * @param SeminarRegVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(SeminarRegVO vo) throws Exception {
        seminarRegDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 사전 등록 참가자 수정
     * </p>
     * 세미나 사전 등록 참가자 수정
     * 
     * @param SeminarRegVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(SeminarRegVO vo) throws Exception {
        seminarRegDAO.update(vo);
    }

    /*****************************************************
     * <p>
     * TODO 세미나 사전 등록 참가자 삭제
     * </p>
     * 세미나 사전 등록 참가자 삭제
     * 
     * @param SeminarRegVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(SeminarRegVO vo) throws Exception {
        seminarRegDAO.delete(vo);
    }

}
