package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtDAO")
public interface AsmtDAO {

    /*****************************************************
     * 과목 조회
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectCrsCreList(AsmtVO vo) throws Exception;

    /*****************************************************
     * 피드백 조회
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectFdbk(AsmtVO vo) throws Exception;

    // 과제 조회
    public List<AsmtVO> selectAsmntList(AsmtVO vo) throws Exception;

    // 신규 수강생 조회
    public List<AsmtVO> selectChkUpdateStd(AsmtVO vo) throws Exception;

    // 삭제 수강생 조회
    public List<AsmtVO> selectChkDeleteStd(AsmtVO vo) throws Exception;

    // 수강생 삭제
    public int deleteStd(AsmtVO vo) throws Exception;

    // 수강생 목록 삭제
    public int deleteStdList(List<AsmtVO> list) throws Exception;

    // 팀 분류코드와 연결된 과제 목록 조회
    public List<AsmtVO> listAsmntByTeamCtgrCd(AsmtVO vo) throws Exception;

    // 과제 수정(선수강과목 이관용)
    public void updateAsmntForTrans(AsmtVO vo) throws Exception;

    // 상호평가 목록 조회
    public List<AsmtVO> listMutEval(AsmtVO vo) throws Exception;

    // 과제 조회
    public AsmtVO selectAsmnt(AsmtVO vo) throws Exception;
}
