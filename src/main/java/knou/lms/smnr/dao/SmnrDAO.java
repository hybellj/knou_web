package knou.lms.smnr.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrPageInfo;

@Mapper("smnrDAO")
public interface SmnrDAO {

	// 교수세미나목록조회
	public List<EgovMap> profSmnrListPaging(SmnrPageInfo pageInfo);

	// 세미나등록
	public void smnrRegist(SmnrVO vo);

	// 세미나수정
	public void smnrModify(SmnrVO vo);

	// 세미나삭제여부수정
	public void smnrDelynModify(SmnrVO vo);

	// 성적반영세미나목록조회
	public List<SmnrVO> mrkRfltSmnrList(SmnrVO vo);

	// 세미나성적반영비율목록수정
	public void smnrMrkRfltrtListModify(List<SmnrVO> list);

	// 세미나일괄등록
	public void smnrBulkRegist(List<SmnrVO> vo);

	// 세미나대상수강생목록
	public List<EgovMap> smnrTrgtAtndlcUserList(SmnrVO vo);

	// 세미나조회
	public EgovMap smnrSelect(SmnrVO vo);

	// 세미나팀그룹부세미나목록조회
	public List<EgovMap> smnrTeamGrpSubSmnrList(Map<String, Object> params);

	// 하위세미나삭제
	public void subSmnrDelete(@Param("smnrId") String smnrId);

	// 세미나아이디조회
	public String smnrIdSelect(SmnrVO vo);

	// 과목별세미나목록조회
	public List<EgovMap> bySubjectSmnrList(SmnrVO vo);

	// 학생세미나목록조회
	public List<EgovMap> stdntSmnrListPaging(SmnrPageInfo pageInfo);

	// 학생세미나조회
	public EgovMap stdntSmnrSelect(SmnrVO vo);
}