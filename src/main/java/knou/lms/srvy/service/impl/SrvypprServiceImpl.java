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
	* @throws Exception
	*/
	@Override
	public List<SrvypprVO> srvypprList(String srvyId, String searchType) throws Exception {
		return srvypprDAO.srvypprList(srvyId, searchType);
	}

	/**
	* 설문지조회
	*
	* @param srvypprId	설문지아이디
	* @return 설문지정보
	* @throws Exception
	*/
	@Override
	public SrvypprVO srvypprSelect(String srvypprId) throws Exception {
		return srvypprDAO.srvypprSelect(srvypprId);
	}

	/**
	 * 설문지등록
	 *
	 * @param SrvypprVO
	 * @throws Exception
	 */
	@Override
	public void srvypprRegist(SrvypprVO vo) throws Exception {
		if("".equals(vo.getSrvypprId())) {
			vo.setSrvypprId(IdGenUtil.genNewId(IdPrefixType.SRPPR));
		}
		srvypprDAO.srvypprRegist(vo);
	}

	/**
	* 설문지참여수조회
	*
	* @param sbjctId	과목아이디
	* @param srvyId		설문아이디
	* @param srvypprId	설문지아이디
	* @return 설문지참여수
	* @throws Exception
	*/
	@Override
	public int srvypprPtcpCntSelect(SrvypprVO vo) throws Exception {
		return srvypprDAO.srvypprPtcpCntSelect(vo);
	}

	/**
	* 설문지삭제
	*
	* @param SrvypprVO
	* @throws Exception
	*/
	@Override
	public void srvypprDelete(SrvypprVO vo) throws Exception {
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
     * @throws Exception
     */
	@Override
	public void srvySeqnoModify(SrvypprVO vo) throws Exception {
		// 설문지순번수정
		srvypprDAO.srvySeqnoModify(vo);

		// 설문보기항목설문지이동아이디수정
		srvyVwitmDAO.srvyVwitmMvmnSrvypprIdModify(vo.getSrvyId());
	}

}
