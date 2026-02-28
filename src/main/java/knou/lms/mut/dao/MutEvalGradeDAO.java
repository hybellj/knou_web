package knou.lms.mut.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.mut.vo.MutEvalGradeVO;

@Mapper("mutEvalGradeDAO")
public interface MutEvalGradeDAO {

    /*****************************************************
     * TODO 평가 등급 목록 조회
     * @param MutEvalGradeVO
     * @return List<MutEvalGradeVO>
     * @throws Exception
     ******************************************************/
    public List<MutEvalGradeVO> listMutEvalGrade(MutEvalGradeVO vo) throws Exception;

    // 평가 등급 전체 삭제
    public void deleteAllGrade(MutEvalGradeVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 등급 삭제
     * @param MutEvalGradeVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalGrade(MutEvalGradeVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 등급 등록
     * @param MutEvalGradeVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertMutEvalGrade(MutEvalGradeVO vo) throws Exception;

}
