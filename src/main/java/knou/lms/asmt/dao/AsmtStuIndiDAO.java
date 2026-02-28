package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtStuIndiDAO")
public interface AsmtStuIndiDAO {

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

    // 과제 등록
    public AsmtVO selectsbmsnCnt(AsmtVO vo) throws Exception;

    // 과제 등록
    public int updateTarget(AsmtVO vo) throws Exception;

    // 과제 등록 (교수 제출완료)
    public int updateTargetSer(AsmtVO vo) throws Exception;

    // 과제 참여자 초기화
    public int revertTarget(AsmtVO vo) throws Exception;

    // 과제 파일 등록
    public int updateTargetFile(AsmtVO vo) throws Exception;

    // 과제 파일 초기화
    public int revertTargetFile(AsmtVO vo) throws Exception;

    // 과제 이력 등록
    public void insertTargetHsty(AsmtVO vo) throws Exception;

    // 상호평가 조회
    public AsmtVO selectEval(AsmtVO vo) throws Exception;

    // 상호평가 등록
    public void insertEval(AsmtVO vo) throws Exception;

    // 상호평가 등록
    public void updateEval(AsmtVO vo) throws Exception;

    // 우수과제 조회
    public List<AsmtVO> selectBest(AsmtVO vo) throws Exception;

    // 과제 참여자 정보 조회
    public AsmtVO selectAsmntJoinUser(AsmtVO vo) throws Exception;

    // 우수과제 조회
    public List<AsmtVO> selectAsmntJoinUserList(AsmtVO vo) throws Exception;
}
