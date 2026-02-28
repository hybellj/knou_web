package knou.lms.exam.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamDsblReqVO;
import knou.lms.user.vo.UsrUserInfoVO;

public interface ExamDsblReqService {
    
    /*****************************************************
     * 장애 지원 신청 리스트 조회
     * @param ExamDsblReqVO
     * @return List<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamDsblReqVO> list(ExamDsblReqVO vo) throws Exception;
    
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
     * @return ProcessResultVO<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamDsblReqVO> listMyCreCrsExamDsblReq(ExamDsblReqVO vo) throws Exception;
    /*****************************************************
     * TODO 장애인 지원 신청 승인/반려
     * @param ExamDsblReqVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertExamDsblReq(ExamDsblReqVO vo) throws Exception;
    
    /*****************************************************
     * 장애 지원 신청 리스트 조회 ( 관리자 )
     * @param ExamDsblReqVO
     * @return List<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    public List<ExamDsblReqVO> listExamDsblReqByAdmin(ExamDsblReqVO vo) throws Exception;
    
    /**
     * 장애인 시험지원 수정
     * @param vo
     * @return 
     * @throws Exception
     */
    public void updateDisability(UsrUserInfoVO vo) throws Exception;

}
