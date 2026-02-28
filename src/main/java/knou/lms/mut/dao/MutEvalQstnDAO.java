package knou.lms.mut.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.mut.vo.MutEvalQstnVO;

@Mapper("mutEvalQstnDAO")
public interface MutEvalQstnDAO {

    /*****************************************************
     * TODO 평가 문제 목록 조회
     * @param MutEvalQstnVO
     * @return List<MutEvalQstnVO>
     * @throws Exception
     ******************************************************/
    public List<MutEvalQstnVO> listMutEvalQstn(MutEvalQstnVO vo) throws Exception;

    // 평가 항목 전체 삭제
    public void deleteAllQstn(MutEvalQstnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 문제 목록 조회
     * @param MutEvalQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listMutEvalQstnEgov(MutEvalQstnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 문제 삭제
     * @param MutEvalQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delMutEvalQstn(MutEvalQstnVO vo) throws Exception;

    /*****************************************************
     * TODO 평가 문제 등록
     * @param MutEvalQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertMutEvalQstn(MutEvalQstnVO vo) throws Exception;

}
