package knou.lms.exam.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.exam.vo.ExamDsblReqVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Mapper("examDsblReqDAO")
public interface ExamDsblReqDAO {

    /*****************************************************
     * TODO 장애 지원 신청 리스트 조회
     * @param ExamDsblReqVO
     * @return List<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    public List<ExamDsblReqVO> list(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * TODO 장애 지원 신청 정보 조회
     * @param ExamDsblReqVO
     * @return ExamDsblReqVO
     * @throws Exception
     ******************************************************/
    public ExamDsblReqVO select(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * TODO 내 강의에 등록된 장애 시험 지원 리스트 조회
     * @param ExamDsblReqVO
     * @return List<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    public List<ExamDsblReqVO> listMyCreCrsExamDsblReq(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * TODO 장애인 지원 신청
     * @param ExamDsblReqVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamDsblReq(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * TODO 장애인 지원 신청 수정
     * @param ExamDsblReqVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamDsblReq(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * TODO 장애 지원 신청 리스트 조회 ( 관리자 )
     * @param ExamDsblReqVO
     * @return List<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    public List<ExamDsblReqVO> listExamDsblReqByAdmin(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * TODO 장애 시험 지원 미등록 목록 조회
     * @param UsrUserInfoVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdByDsblReq(UsrUserInfoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 장애인 지원 신청 수정일시 수정
     * @param ExamDsblReqVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamDsblReqByModDttm(ExamDsblReqVO vo) throws Exception;
    
}
