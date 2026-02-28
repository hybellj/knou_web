package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtProIndiDAO")
public interface AsmtProIndiDAO {

    /*****************************************************
     * 정보 조회
     * @param AsmntVO
     * @return AsmtVO
     * @throws Exception
     ******************************************************/
    public AsmtVO selectObject(AsmtVO vo) throws Exception;

    /*****************************************************
     * 목록 조회
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectList(AsmtVO vo) throws Exception;

    /*****************************************************
     * 목록 조회 페이징
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectListPaging(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 조회
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectTarget(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public int insertTarget(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 목록 등록
     * @param list
     * @throws Exception
     ******************************************************/
    public int insertTargetList(List<AsmtVO> list) throws Exception;

    /*****************************************************
     * 대상자 파일 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public int insertTargetFile(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 파일 목록 등록
     * @param list
     * @throws Exception
     ******************************************************/
    public int insertTargetFileList(List<AsmtVO> list) throws Exception;

    /*****************************************************
     * 대상자 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public int deleteTarget(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 파일 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public int deleteTargetFile(AsmtVO vo) throws Exception;

    /*****************************************************
     * 성적 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateScore(AsmtVO vo) throws Exception;

    /*****************************************************
     * 성적 일괄 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateScoreBatch(List<AsmtVO> list) throws Exception;

    /*****************************************************
     * 성적 수정(엑셀)
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateScoreExcel(AsmtVO vo) throws Exception;

    /*****************************************************
     * 메모 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateMemo(AsmtVO vo) throws Exception;

    /*****************************************************
     * 우수과제 선정
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateBest(AsmtVO vo) throws Exception;

    public int deleteResend(AsmtVO vo) throws Exception;

    public int updateResend(AsmtVO vo) throws Exception;

    // 과제 단일 학습자 삭제
    public int deleteTargetByStdNo(AsmtVO vo) throws Exception;

    public int deleteTargetFileByStdNo(AsmtVO vo) throws Exception;

    public int deleteTargetHstyByStdNo(AsmtVO vo) throws Exception;

    public int deleteTargetFdbkByStdNo(AsmtVO vo) throws Exception;

    // 과제 대상자 점수 부여 취소
    public int canecelTargetMutScore(AsmtVO vo) throws Exception;

}
