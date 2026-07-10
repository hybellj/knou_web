package knou.lms.forum2.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface DscsService {
    // 토론 분반 목록 조회
    List<DscsVO> selectDscsDvclasList(DscsVO vo);
    // 토론 목록 조회
    ProcessResultVO<DscsListVO> selectStdntDscsList(DscsListVO vo) throws Exception;
    // 교수자 토론 목록 조회
    ProcessResultVO<DscsListVO> selectProfDscsList(DscsListVO vo) throws Exception;
    // 토론 정보 조회
    DscsVO selectDscs(DscsVO vo);
    // 토론 성적공개여부 수정
    ProcessResultVO<DscsVO> modifyDscsMrkOyn(DscsVO vo);
    // 토론 성적반영비율 수정
    void updateDscsMrkRfltrt(List<DscsVO> list);
    // 토론 저장
    ProcessResultVO<DscsVO> saveDscs(DscsVO vo) throws Exception;
    // 과목 토론 목록 조회
    ProcessResultVO<DscsVO> selectProfSbjctDscsList(DscsVO vo);
    // 토론 삭제
    ProcessResultVO<DscsVO> deleteDscs(DscsVO vo);
    // 팀토론 공개여부 수정
    ProcessResultVO<DscsTeamDscsVO> modifyTeamDscsOyn(DscsTeamDscsVO vo);
    // 팀그룹 팀 목록 조회
    ProcessResultVO<DscsTeamDscsVO> selectDscsTeamGrpTeamList(DscsTeamDscsVO vo);
    // 성적반영비율 설정
    void setScoreRatio(DscsVO dscsVO);
    // 성적 분포 현황 조회
    EgovMap viewScoreChart(DscsVO vo);
    // 교수 학기 목록 조회
    List<EgovMap> selectProfSmstrChrtList(DscsVO vo);
    // 교수 학기별 과목 목록 조회
    List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo);
    // 과목별토론목록조회
	List<EgovMap> bySubjectDscsList(DscsVO vo);
}
