package knou.lms.srvy.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.web.view.SrvyPageInfo;

public interface SrvyService {

    public List<EgovMap> admAllSrvyList(int limitTop);

	// 교수설문목록조회
    public ResultDTO<EgovMap> profSrvyListPaging(SrvyPageInfo pageInfo);

    // 설문등록
    public SrvyVO srvyRegist(SrvyVO vo, Map<String, String> subMap);

    // 설문수정
    public SrvyVO srvyModify(SrvyVO vo, Map<String, String> subMap);

    // 설문성적반영비율수정
    public void srvyMrkRfltrtModify(SrvyVO vo);

    // 과목성적공개설문수조회
	public Integer sbjctMrkOynSrvyCntSelect(SrvyVO vo);

	// 설문세부정보수정
	public void srvyDtlModify(SrvyVO vo);

	// 설문성적반영비율목록수정
	public void srvyMrkRfltrtListModify(List<SrvyVO> list);

	// 설문그룹과목목록조회
	public List<EgovMap> srvyGrpSbjctList(String srvyId);

	// 설문조회
	public EgovMap srvySelect(SrvyVO vo);

	// 설문팀그룹부설문목록조회
	public List<EgovMap> srvyTeamGrpSubSrvyList(Map<String, Object> params);

	// 교수권한과목설문목록조회
	public List<EgovMap> profAuthrtSbjctSrvyList(SrvyVO vo);

	// 설문삭제
	public void srvyDelete(SrvyVO vo);

	// 설문팀목록조회
	public List<EgovMap> srvyTeamList(String srvyId);

	// 설문팀문제출제완료여부조회
	public Boolean srvyTeamQstnsCmptnynSelect(String srvyId);

	// 문제가져오기설문목록조회
	public List<SrvyVO> qstnCopySrvyList(String sbjctId);

	// 설문문제출제완료수정
	public void srvyQstnsCmptnModify(SrvyVO vo);

	// 과목별설문조회
	public List<EgovMap> bySubjectSrvyList(SrvyVO vo);

	// 학생설문목록조회
    public ResultDTO<EgovMap> stdntSrvyListPaging(SrvyPageInfo pageInfo);

	// 학생설문조회
	public EgovMap stdntSrvySelect(SrvyVO vo);

	// 관리자설문강의평가목록조회
    public ResultDTO<EgovMap> admSrvyLctrEvlListPaging(SrvyPageInfo pageInfo);

    // 설문강의평가미등록과목목록
 	public List<EgovMap> srvyLctrEvlNRegistSbjctList(Map<String, Object> params);

 	// 설문강의평가등록
    public SrvyVO srvyLctrEvlRegist(SrvyVO vo, Map<String, String> subMap);

    // 설문강의평가수정
    public SrvyVO srvyLctrEvlModify(SrvyVO vo, Map<String, String> subMap);

    // 설문강의평가조회
 	public EgovMap srvyLctrEvlSelect(SrvyVO vo);

 	// 설문강의평가등록과목목록
 	public List<EgovMap> srvyLctrEvlRegistSbjctList(SrvyVO vo);

 	// 가져오기설문강의평가목록
 	public List<EgovMap> copySrvyLctrEvlList(Map<String, Object> params);

 	// 관리자설문강의평가결과목록조회
    public ResultDTO<EgovMap> admSrvyLctrEvlRsltList(SrvyPageInfo pageInfo);

    // 관리자전체설문목록조회
    public ResultDTO<EgovMap> admSrvyListPaging(SrvyPageInfo pageInfo);

    // 관리자전체설문조회
    public EgovMap admSrvySelect(SrvyVO vo);

    // 관리자전체설문등록
    public SrvyVO admSrvyRegist(SrvyVO vo);

    // 관리자전체설문수정
    public SrvyVO admSrvyModify(SrvyVO vo);

    // 가져오기전체설문목록
  	public List<EgovMap> copySrvyList(Map<String, Object> params);

  	// 관리자전체설문결과목록조회
    public ResultDTO<EgovMap> admSrvyRsltList(SrvyPageInfo pageInfo);

    // 학생대시보드설문강의평가목록조회
    public List<EgovMap> stdntMainSrvyLctrEvlList(Map<String, Object> params);

    // 학생설문강의평가조회
 	public EgovMap stdntSrvyLctrEvlSelect(SrvyVO vo);

 	// 대상전체설문목록조회
    public ResultDTO<EgovMap> trgtWholSrvyListPaging(SrvyPageInfo pageInfo);

    // 대상전체설문조회
 	public EgovMap trgtWholSrvySelect(SrvyVO vo);

 	// 학생설문강의평가목록페이징
 	public ResultDTO<EgovMap> stdntSrvyLctrEvlListPaging(SrvyPageInfo pageInfo);

 	// 설문강의평가과목참여목록
  	public List<EgovMap> srvyLctrEvlSbjctPtcpList(SrvyVO vo);

}