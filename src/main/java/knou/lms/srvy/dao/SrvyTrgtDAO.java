package knou.lms.srvy.dao;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyTrgtVO;

@Mapper("srvyTrgtDAO")
public interface SrvyTrgtDAO {

	// 설문대상등록
	public void srvyTrgtRegist(SrvyTrgtVO vo);

	// 설문대상삭제
	public void srvyTrgtrDelete(@Param("srvyId") String srvyId);

	// 설문대상유형코드수정
	public void srvyTrgtTycdModify(SrvyTrgtVO vo);

}
