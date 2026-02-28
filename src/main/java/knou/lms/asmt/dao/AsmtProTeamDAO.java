package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtProTeamDAO")
public interface AsmtProTeamDAO {

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

    // 팀 목록 조회
    public List<AsmtVO> selectTeamList(AsmtVO vo) throws Exception;

    // 과제 대상자 조회
    public List<AsmtVO> selectTarget(AsmtVO vo) throws Exception;

    // 대상자 팀코드 조회
    public AsmtVO selectTeamCd(AsmtVO vo) throws Exception;


    // 대상자 등록
    public int insertTarget(AsmtVO vo) throws Exception;

    /*****************************************************
     * 대상자 목록 등록
     * @param list
     * @throws Exception
     ******************************************************/
    public int insertTargetList(List<AsmtVO> list) throws Exception;
}
