package knou.lms.srvy.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.srvy.dao.SrvyVwitmDAO;
import knou.lms.srvy.dao.SrvypprDAO;
import knou.lms.srvy.service.SrvypprService;
import knou.lms.srvy.vo.SrvypprVO;

@Service("srvypprService")
public class SrvypprServiceImpl extends ServiceBase implements SrvypprService {

	@Resource(name="srvypprDAO")
	private SrvypprDAO srvypprDAO;

	@Resource(name="srvyVwitmDAO")
	private SrvyVwitmDAO srvyVwitmDAO;

	/**
	* 설문지목록조회
	*
	* @param srvyId		설문아이디
	* @param searchType	조회유형
	* @return 설문지목록
	*/
	@Override
	public List<SrvypprVO> srvypprList(String srvyId, String searchType) {
		return srvypprDAO.srvypprList(srvyId, searchType);
	}

	/**
	* 설문지조회
	*
	* @param srvypprId	설문지아이디
	* @return 설문지정보
	*/
	@Override
	public SrvypprVO srvypprSelect(String srvypprId) {
		return srvypprDAO.srvypprSelect(srvypprId);
	}

	/**
	 * 설문지등록
	 *
	 * @param SrvypprVO
	 */
	@Override
	public void srvypprRegist(SrvypprVO vo) {
		if("".equals(vo.getSrvypprId())) vo.setSrvypprId(IdGenUtil.genNewId(IdPrefixType.SRPPR));
		srvypprDAO.srvypprRegist(vo);
	}

	/**
	* 설문지참여수조회
	*
	* @param sbjctId	과목아이디
	* @param srvyId		설문아이디
	* @param srvypprId	설문지아이디
	* @return 설문지참여수
	*/
	@Override
	public int srvypprPtcpCntSelect(SrvypprVO vo) {
		return srvypprDAO.srvypprPtcpCntSelect(vo);
	}

	/**
	* 설문지삭제
	*
	* @param SrvypprVO
	*/
	@Override
	public void srvypprDelete(SrvypprVO vo) {
		// 설문지삭제
		srvypprDAO.srvypprDelete(vo.getSrvypprId());

		// 설문지미삭제순번수정
		srvypprDAO.srvypprDelNSeqnoModify(vo);

		// 설문보기항목설문지이동아이디수정
		srvyVwitmDAO.srvyVwitmMvmnSrvypprIdModify(vo.getSrvyId());
	}

	/**
     * 설문지순번수정
     *
     * @param srvyId 	설문아이디
     * @param srvySeqno 변경할 설문지순번
     * @param searchKey 설문지순번
     */
	@Override
	public void srvySeqnoModify(SrvypprVO vo) {
		// 설문지순번수정
		srvypprDAO.srvySeqnoModify(vo);

		// 설문보기항목설문지이동아이디수정
		srvyVwitmDAO.srvyVwitmMvmnSrvypprIdModify(vo.getSrvyId());
	}

}
