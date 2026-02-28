package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtProDAO")
public interface AsmtProDAO {

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
     * 이전 과제 목록 조회 페이징
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectPrevAsmntList(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제정보를 등록한다.
     * @param vo
     * @throws Exception
     ******************************************************/
    public int insertAsmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제정보를 복사한다.
     * @param vo
     * @throws Exception
     ******************************************************/
    public int copyAsmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제정보를 수정한다.
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateAsmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제정보 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public int deleteAsmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 성적공개여부 수정
     * @param AsmntVO
     * @throws Exception
     ******************************************************/
    public int updateScoreOpen(AsmtVO vo) throws Exception;

    /*****************************************************
     * 성적반영비율 수정
     * @param AsmntVO
     * @throws Exception
     ******************************************************/
    public int updateScoreRatio(AsmtVO vo) throws Exception;

    /*****************************************************
     * 반 조회
     * @param vo
     * @return asmntList
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectDeclsList(AsmtVO vo) throws Exception;

    /*****************************************************
     * 개설과정과제 연결 추가
     * @param vo
     * @throws Exception
     ******************************************************/
    public int insertAsmntCreCrsRltn(AsmtVO vo) throws Exception;

    /*****************************************************
     * 개설과정과제 연결 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public int deleteAsmntCreCrsRltn(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 피드백 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public int insertFdbk(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제 피드백 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public int updateFdbk(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제 피드백 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public int deleteFdbk(AsmtVO vo) throws Exception;

    /*****************************************************
     * 이전과제
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectPrevAsmntFiles(AsmtVO vo) throws Exception;

    /*****************************************************
     * 참여이력
     * @param AsmntVO
     * @return AsmtVO
     * @throws Exception
     ******************************************************/
    public AsmtVO selectAsmntJoinUser(AsmtVO vo) throws Exception;

    /*****************************************************
     * 제출이력
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectSubmitHystList(AsmtVO vo) throws Exception;

    public int updateResendInfo(AsmtVO vo) throws Exception;

    // 성적반영비율 리스트
    public List<AsmtVO> getScoreRatio(AsmtVO vo) throws Exception;

    // 성적반영비율 초기화
    public void setScoreRatio(AsmtVO vo) throws Exception;

    /*****************************************************
     * 루브릭 평가 연결 조회
     * @param vo
     * @return AsmtVO
     * @throws Exception
     ******************************************************/
    public AsmtVO selectMutEvalRslt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 루브릭 평가 연결 목록 조회
     * @param vo
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> listMutEvalRslt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 루브릭 평가 연결 등록
     * @param vo
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertMutEvalRslt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 루브릭 평가 연결 수정
     * @param vo
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateMutEvalRslt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 루브릭 평가 연결 삭제
     * @param vo
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteMutEvalRslt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제 대상자 루브릭 평가 연결 삭제
     * @param vo
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteMutEvalRsltByStdNo(AsmtVO vo) throws Exception;

    /**
     * 과제그룹 등록
     *
     * @param vo
     * @throws Exception
     */
    public void insertAsmtGrp(AsmtVO vo) throws Exception;
}
