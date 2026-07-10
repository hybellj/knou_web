package knou.lms.srvy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;

@Mapper("srvypprDAO")
public interface SrvypprDAO {

	// 설문지목록조회
	public List<SrvypprVO> srvypprList(@Param("srvyId") String srvyId, @Param("searchType") String searchType);

	// 설문지조회
	public SrvypprVO srvypprSelect(@Param("srvypprId") String srvypprId);

	// 설문지등록
	public void srvypprRegist(SrvypprVO vo);

	// 설문지참여수조회
	public int srvypprPtcpCntSelect(SrvypprVO vo);

	// 설문지삭제
	public void srvypprDelete(@Param("srvypprId") String srvypprId);

	// 설문지미삭제순번수정
	public void srvypprDelNSeqnoModify(SrvypprVO vo);

	// 설문지순번수정
	public void srvySeqnoModify(SrvypprVO vo);

	// 설문지전체삭제
	public void srvypprAllDelete(SrvyVO vo);

	// 설문지일괄등록
	public void srvypprBulkRegist(List<SrvypprVO> vo);

}
