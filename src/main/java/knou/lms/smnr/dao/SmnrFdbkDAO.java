package knou.lms.smnr.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.vo.SmnrFdbkVO;

@Mapper("smnrFdbkDAO")
public interface SmnrFdbkDAO {

	// 세미나피드백등록
	public void smnrFdbkRegist(SmnrFdbkVO vo);

	// 세미나피드백일괄등록
	public void smnrFdbkBulkRegist(List<SmnrFdbkVO> vo);

	// 세미나피드백목록
	public List<SmnrFdbkVO> smnrFdbkList(SmnrFdbkVO vo);

	// 세미나피드백수정
	public void smnrFdbkModify(SmnrFdbkVO vo);

	// 세미나피드백조회
	public SmnrFdbkVO smnrFdbkSelect(SmnrFdbkVO vo);

	// 세미나피드백삭제
	public void smnrFdbkDelete(SmnrFdbkVO vo);

}
