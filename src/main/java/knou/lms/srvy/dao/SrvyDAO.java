package knou.lms.srvy.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.web.view.SrvyPageInfo;

@Mapper("srvyDAO")
public interface SrvyDAO {

    public List<EgovMap> admAllSrvyList(int limitTop);

	// 교수설문목록조회
	public List<EgovMap> profSrvyListPaging(PageInfo pageInfo);

	// 과목성적공개설문수조회
	public int sbjctMrkOynSrvyCntSelect(@Param("sbjctId") String sbjctId, @Param("srvyId") String srvyId);

	// 성적반영설문목록조회
	public List<SrvyVO> mrkRfltSrvyList(SrvyVO vo);

	// 설문성적반영비율목록수정
	public void srvyMrkRfltrtListModify(List<SrvyVO> list);

	// 설문등록
	public void srvyRegist(SrvyVO vo);

	// 설문수정
	public void srvyModify(SrvyVO vo);

	// 설문그룹과목목록조회
	public List<EgovMap> srvyGrpSbjctList(@Param("srvyId") String srvyId);

	// 설문조회
	public EgovMap srvySelect(SrvyVO vo);

	// 하위설문삭제
	public void subSrvyDelete(@Param("srvyId") String srvyId);

	// 하위설문삭제여부수정
	public void subSrvyDelynModify(SrvyVO vo);

	// 설문팀목록조회
	public List<EgovMap> srvyTeamList(@Param("srvyId") String srvyId);

	// 설문아이디조회
	public String srvyIdSelect(SrvyVO vo);

	// 설문팀그룹부설문목록조회
	public List<EgovMap> srvyTeamGrpSubSrvyList(Map<String, Object> params);

	// 교수권한과목설문목록조회
	public List<EgovMap> profAuthrtSbjctSrvyList(SrvyVO vo);

	// 설문팀문제출제완료여부조회
	public Boolean srvyTeamQstnsCmptnynSelect(String srvyId);

	// 문제가져오기설문목록조회
	public List<SrvyVO> qstnCopySrvyList(@Param("sbjctId") String sbjctId);

	// 과목별설문목록조회
	public List<EgovMap> bySubjectSrvyList(SrvyVO vo);

	// 학생설문목록조회
	public List<EgovMap> stdntSrvyListPaging(PageInfo pageInfo);

	// 학생설문조회
	public EgovMap stdntSrvySelect(SrvyVO vo);

	// 관리자설문강의평가목록페이징
	public List<EgovMap> admSrvyLctrEvlListPaging(PageInfo pageInfo);

	// 설문강의평가미등록과목목록
	public List<EgovMap> srvyLctrEvlNRegistSbjctList(Map<String, Object> params);

	// 설문일괄등록
	public void srvyBulkRegist(List<SrvyVO> list);

	// 설문강의평가조회
	public EgovMap srvyLctrEvlSelect(SrvyVO vo);

	// 설문강의평가등록과목목록
	public List<EgovMap> srvyLctrEvlRegistSbjctList(SrvyVO vo);

	// 가져오기설문강의평가목록
	public List<EgovMap> copySrvyLctrEvlList(Map<String, Object> params);

	// 관리자설문강의평가결과목록페이징
	public List<EgovMap> admSrvyLctrEvlRsltListPaging(SrvyPageInfo pageInfo);

	// 관리자전체설문목록페이징
	public List<EgovMap> admSrvyListPaging(PageInfo pageInfo);

	// 관리자전체설문조회
	public EgovMap admSrvySelect(SrvyVO vo);

	// 가져오기전체설문목록
	public List<EgovMap> copySrvyList(Map<String, Object> params);

	// 관리자전체설문결과목록페이징
	public List<EgovMap> admSrvyRsltListPaging(SrvyPageInfo pageInfo);

	// 학생대시보드설문강의평가목록조회
	public List<EgovMap> stdntMainSrvyLctrEvlList(Map<String, Object> params);

	// 학생설문강의평가조회
	public EgovMap stdntSrvyLctrEvlSelect(SrvyVO vo);

	// 대상전체설문목록페이징
	public List<EgovMap> trgtWholSrvyListPaging(PageInfo pageInfo);

	// 대상전체설문조회
	public EgovMap trgtWholSrvySelect(SrvyVO vo);

	// 학생설문강의평가목록페이징
	public List<EgovMap> stdntSrvyLctrEvlListPaging(SrvyPageInfo pageInfo);

	// 설문강의평가과목참여목록
	public List<EgovMap> srvyLctrEvlSbjctPtcpList(SrvyVO vo);
}