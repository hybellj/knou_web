package knou.lms.smnr.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.smnr.vo.SmnrTrgtrVO;
import knou.lms.smnr.vo.SmnrVO;

@Mapper("smnrTrgtrDAO")
public interface SmnrTrgtrDAO {

	// 세미나대상자일괄등록
	public void smnrTrgtrBulkRegist(List<SmnrTrgtrVO> list);

	// 세미나대상자일괄삭제
	public void smnrTrgtrBulkDelete(@Param("smnrId") String smnrId);

	// 세미나대상자접속URL조회
	public SmnrTrgtrVO smnrTrgtrCntnUrlSelect(SmnrVO vo);

	// 세미나대상자등록
	public void smnrTrgtrRegist(SmnrTrgtrVO vo);

}
