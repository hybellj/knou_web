package knou.lms.smnr.service;

import java.util.List;
import java.util.Map;

import knou.lms.smnr.vo.SmnrFdbkVO;

public interface SmnrFdbkService {

	// 세미나피드백등록
    public void smnrFdbkRegist(SmnrFdbkVO vo, String fdbkUsersStr);

    // 세미나피드백목록
	public List<SmnrFdbkVO> smnrFdbkList(SmnrFdbkVO vo);

	// 세미나피드백수정
	public void smnrFdbkModify(SmnrFdbkVO vo);

	// 세미나피드백조회
	public SmnrFdbkVO smnrFdbkSelect(SmnrFdbkVO vo);

	// 세미나피드백삭제
	public void smnrFdbkDelete(SmnrFdbkVO vo);

	// 세미나피드백일괄등록
	public void smnrFdbkBulkRegist(List<Map<String, Object>> list);

}