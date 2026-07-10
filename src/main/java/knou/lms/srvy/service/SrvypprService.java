package knou.lms.srvy.service;

import java.util.List;

import knou.lms.srvy.vo.SrvypprVO;

public interface SrvypprService {

	// 설문지목록조회
	public List<SrvypprVO> srvypprList(String srvyId, String searchType);

	// 설문지조회
	public SrvypprVO srvypprSelect(String srvypprId);

	// 설문지등록
	public void srvypprRegist(SrvypprVO vo);

	// 설문지참여수조회
	public int srvypprPtcpCntSelect(SrvypprVO vo);

	// 설문지삭제
	public void srvypprDelete(SrvypprVO vo);

	// 설문지순번수정
	public void srvySeqnoModify(SrvypprVO vo);

}
