package knou.lms.mut.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.mut.vo.MutEvalGradeVO;
import knou.lms.mut.vo.MutEvalQstnVO;
import knou.lms.mut.vo.MutEvalRltnVO;
import knou.lms.mut.vo.MutEvalVO;

@Mapper("mutEvalDAO")
public interface MutEvalDAO {

    // 정보 조회
    public MutEvalVO selectObject(MutEvalVO vo) throws Exception;

    // 목록 조회
    public List<MutEvalVO> selectList(MutEvalVO vo) throws Exception;

    // 목록 조회 페이징
    public List<MutEvalVO> selectListPaging(MutEvalVO vo) throws Exception;

    // 문항 조회
    public List<MutEvalQstnVO> selectQstn(MutEvalVO vo) throws Exception;

    // 평가등급 조회
    public List<MutEvalGradeVO> selectGrade(MutEvalQstnVO vo) throws Exception;

    // 사용여부 수정
    public int updateUseYn(MutEvalVO vo) throws Exception;

    // 삭제
    public int updateDelYn(MutEvalVO vo) throws Exception;

    // 루브릭 관리자 등록 + 본인 등록 조회
    public List<MutEvalVO> selectRegList(MutEvalRltnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 정보 강의 연결 조회
     * @param MutEvalRltnVO
     * @return List<MutEvalVO>
     * @throws Exception
     ******************************************************/
    public List<MutEvalVO> listMutEvalByCrsCreCd(MutEvalRltnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 정보 조회
     * @param MutEvalVO
     * @return MutEvalVO
     * @throws Exception
     ******************************************************/
    public MutEvalVO selectMutEval(MutEvalVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 정보 등록
     * @param MutEvalVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertMutEval(MutEvalVO vo) throws Exception;

}
