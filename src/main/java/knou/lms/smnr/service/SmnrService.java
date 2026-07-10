package knou.lms.smnr.service;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrPageInfo;

public interface SmnrService {

	// 교수세미나목록조회
    public ResultDTO<EgovMap> profSmnrListPaging(SmnrPageInfo pageInfo);

    // 세미나등록
    public void smnrRegist(SmnrVO vo, Map<String, String> subMap);

    // 세미나수정
    public void smnrModify(SmnrVO vo, Map<String, String> subMap);

    // 세미나삭제
    public void smnrDelete(SmnrVO vo);

    // 세미나성적반영비율수정
    public void smnrMrkRfltrtModify(SmnrVO vo);

    // 세미나성적반영비율목록수정
	public void smnrMrkRfltrtListModify(List<SmnrVO> list);

	// 세미나세부정보수정
	public void smnrDtlModify(SmnrVO vo);

	// 세미나대상수강생목록
	public List<EgovMap> smnrTrgtAtndlcUserList(SmnrVO vo);

	// 세미나조회
	public EgovMap smnrSelect(SmnrVO vo);

	// 세미나팀그룹부세미나목록조회
	public List<EgovMap> smnrTeamGrpSubSmnrList(Map<String, Object> params);

	// 세미나아이디조회
	public String smnrIdSelect(SmnrVO vo);

	// 과목별세미나목록조회
	public List<EgovMap> bySubjectSmnrList(SmnrVO vo);

	// 학생세미나목록조회
    public ResultDTO<EgovMap> stdntSmnrListPaging(SmnrPageInfo pageInfo);

    // 학생세미나조회
    public EgovMap stdntSmnrSelect(SmnrVO vo);
}