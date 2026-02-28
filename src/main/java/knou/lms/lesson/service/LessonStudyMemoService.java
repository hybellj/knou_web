package knou.lms.lesson.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lesson.vo.LessonStudyMemoVO;

public interface LessonStudyMemoService {

    /*****************************************************
     * TODO 학습메모 정보 조회
     * @param LessonStudyMemoVO
     * @return LessonStudyMemoVO
     * @throws Exception
     ******************************************************/
    public LessonStudyMemoVO select(LessonStudyMemoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습메모 목록 조회
     * @param LessonStudyMemoVO
     * @return List<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    public List<LessonStudyMemoVO> list(LessonStudyMemoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습메모 목록 조회 페이징
     * @param LessonStudyMemoVO
     * @return ProcessResultVO<LessonStudyMemoVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LessonStudyMemoVO> listPaging(LessonStudyMemoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습메모 등록
     * @param LessonStudyMemoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public LessonStudyMemoVO insert(LessonStudyMemoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습메모 수정
     * @param LessonStudyMemoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(LessonStudyMemoVO vo) throws Exception;
    
    /*****************************************************
     * TODO 학습메모 삭제
     * @param LessonStudyMemoVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(LessonStudyMemoVO vo) throws Exception;
    
}
