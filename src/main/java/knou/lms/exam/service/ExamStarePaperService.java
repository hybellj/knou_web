package knou.lms.exam.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamStarePaperHstyVO;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamStareVO;

public interface ExamStarePaperService {

    /*****************************************************
     * TODO 시험지 문제 목록 조회
     * @param ExamStarePaperVO
     * @return List<?>
     * @throws Exception
     ******************************************************/
    public List<?> paperQstnlist(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학생의 시험지 문제 조회
     * @param ExamStarePaperVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listStdStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험문항 학습자 점수 수정 (단일)
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQstnPaperScore(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험문항별 학습자 점수 수정 (다수)
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateQstnPaperStdScore(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험 응시 시작
     * @param ForumStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> startStdExamStare(ExamStareVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 시험 제출
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> complateExamStare(ExamStarePaperVO vo, HttpServletRequest requset) throws Exception;
    
    /*****************************************************
     * TODO 시험 임시 저장
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> saveTemporaryExamStare(ExamStarePaperVO vo, HttpServletRequest request) throws Exception;
    
    /*****************************************************
     * TODO 시험문제 배정된 학습자 리스트 조회
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listStdPageing(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 시험지 수정
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateStarePaper(ExamStarePaperVO vo) throws Exception;
    
    /*****************************************************
     * TODO 응시 시험지 답안 이력
     * @param ExamStarePaperHstyVO
     * @return ProcessResultVO<ExamStarePaperHstyVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamStarePaperHstyVO> listPaperHstyLog(ExamStarePaperHstyVO vo) throws Exception;
    
}
