package knou.lms.forum2.dao;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("dscsDAO")
public interface DscsDAO {
    // 토론 분반 목록 조회
    List<DscsVO> selectDscsDvclasList(DscsVO vo);
    // 토론 목록 조회(페이징)
    List<DscsListVO> selectStdntDscsList(DscsListVO vo);
    // 교수자 토론 목록 조회(페이징)
    List<DscsListVO> selectProfDscsList(DscsListVO vo);
    // 토론 정보 조회(1건)
    DscsVO selectDscs(DscsVO vo);
    // 토론 그룹 등록
    int insertDscsGrp(DscsVO vo);
    // 토론 등록
    int insertDscs(DscsVO vo);
    // 토론 수정
    int updateDscs(DscsVO vo);
    // 토론 성적공개여부 수정
    int updateDscsMrkOyn(DscsVO vo);
    // 토론 성적반영비율 수정
    void updateDscsMrkRfltrt(List<DscsVO> list);
    // 토론 삭제(논리 삭제)
    int deleteDscs(DscsVO vo);
    // 토론 정보 조회
    public DscsVO select(DscsVO vo);
    // 팀토론 자식 토론 삭제
    int deleteChildDscs(DscsVO vo);
    // 팀토론 자식 토론 제목/내용 수정
    int updateChildDscsDtls(DscsTeamDscsVO vo);
    // 팀토론 화면 정보 조회
    List<DscsTeamDscsVO> selectTeamDscsList(String dscsId);
    // 팀그룹 팀 목록 조회
    List<DscsTeamDscsVO> selectDscsTeamGrpTeamList(DscsTeamDscsVO vo);
    // 팀토론 토론방 오픈여부 수정
    int updateTeamDscsOyn(DscsTeamDscsVO vo);
    // 성적반영비율 토론 리스트 조회
    public List<DscsVO> getScoreRatio(DscsVO vo);
    // 성적반영비율 초기화
    public void setScoreRatio(DscsVO vo);
    // 토론 성적 분포 현황 조회
    public EgovMap selectScoreChart(DscsVO vo);
    // 교수 학기 목록 조회
    List<EgovMap> selectProfSmstrChrtList(DscsVO vo);
    // 교수 학기별 과목 목록 조회
    List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo);
    // 과목 토론 목록 조회
    public List<DscsVO> selectProfSbjctDscsList(DscsVO vo);
    
    // 과목별 토론 목록 조회
	List<EgovMap> bySubjectDscsList(DscsVO vo) ;
	
}