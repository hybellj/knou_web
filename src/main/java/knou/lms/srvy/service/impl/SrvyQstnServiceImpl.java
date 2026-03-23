package knou.lms.srvy.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.srvy.dao.SrvyQstnDAO;
import knou.lms.srvy.dao.SrvyQstnVwitmLvlDAO;
import knou.lms.srvy.dao.SrvyVwitmDAO;
import knou.lms.srvy.dao.SrvypprDAO;
import knou.lms.srvy.service.SrvyQstnService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvypprVO;

@Service("srvyQstnService")
public class SrvyQstnServiceImpl extends ServiceBase implements SrvyQstnService {

	@Resource(name="srvyQstnDAO")
	private SrvyQstnDAO srvyQstnDAO;

	@Resource(name="srvypprDAO")
	private SrvypprDAO srvypprDAO;

	@Resource(name="srvyVwitmDAO")
	private SrvyVwitmDAO srvyVwitmDAO;

	@Resource(name="srvyQstnVwitmLvlDAO")
	private SrvyQstnVwitmLvlDAO srvyQstnVwitmLvlDAO;

	/**
	 * 설문문항목록조회
	 *
	 * @param srvyId		설문아이디
	 * @param searchType	조회유형
	 * @return 설문문항목록
	 * @throws Exception
	 */
	@Override
	public List<EgovMap> srvyQstnList(String srvyId, String searchType) throws Exception {
		return srvyQstnDAO.srvyQstnList(srvyId, searchType);
	}

	/**
	 * 설문지문항목록조회
	 *
	 * @param srvypprId		설문지아이디
	 * @return 설문지문항목록
	 * @throws Exception
	 */
	@Override
	public List<SrvyQstnVO> srvypprQstnList(String srvypprId) throws Exception {
		return srvyQstnDAO.srvypprQstnList(srvypprId);
	}

	/**
	 * 설문지문항삭제
	 *
	 * @param srvypprId		설문지아이디
	 * @throws Exception
	 */
	@Override
	public void srvypprQstnDelete(String srvypprId) throws Exception {
		srvyQstnDAO.srvypprQstnDelete(srvypprId);
	}

	/**
	* 설문문항등록
	*
	* @param SrvyQstnVO
	* @throws Exception
	*/
	@Override
	public SrvyQstnVO srvyQstnRegist(SrvyQstnVO vo) throws Exception {
		vo.setSrvyQstnId(IdGenUtil.genNewId(IdPrefixType.SRQN));
		srvyQstnDAO.srvyQstnRegist(vo);
		return vo;
	}

	/**
	* 설문문항수정
	*
	* @param SrvyQstnVO
	* @throws Exception
	*/
	@Override
	public void srvyQstnModify(SrvyQstnVO vo) throws Exception {
		srvyQstnDAO.srvyQstnModify(vo);
	}

	/**
	* 설문문항삭제
	*
	* @param SrvyQstnVO
	* @throws Exception
	*/
	@Override
	public void srvyQstnDelete(SrvyQstnVO vo) throws Exception {
		// 설문문항삭제여부수정
		srvyQstnDAO.srvyQstnModify(vo);

		// 설문문항미삭제순번수정
		srvyQstnDAO.srvyQstnDelNSeqnoModify(vo);
	}

	/**
	 * 설문문항조회
	 *
	 * @param srvypprId		설문지아이디
	 * @param srvyQstnId	설문문항아이디
	 * @return 설문문항
	 * @throws Exception
	 */
	@Override
	public SrvyQstnVO srvyQstnSelect(SrvyQstnVO vo) throws Exception {
		return srvyQstnDAO.srvyQstnSelect(vo);
	}

	/**
     * 문항순번수정
     *
     * @param srvypprId 	설문지아이디
     * @param qstnSeqno 	변경할 문항순번
     * @param searchKey 	문항순번
     * @throws Exception
     */
	@Override
	public void qstnSeqnoModify(SrvyQstnVO vo) throws Exception {
		srvyQstnDAO.qstnSeqnoModify(vo);
	}

	/**
     * 교수문항복사설문문항목록조회
     *
     * @param srvypprId 	설문지아이디
     * @return 설문문항목록
     * @throws Exception
     */
	@Override
	public List<EgovMap> profQstnCopySrvyQstnList(SrvyQstnVO vo) throws Exception {
		return srvyQstnDAO.profQstnCopySrvyQstnList(vo);
	}

	/**
	* 설문문항가져오기
	*
	* @param copySrvyQstnId	복사설문문항아이디
	* @param srvyId 			설문아이디
	* @throws Exception
	*/
	@Override
	public void srvyQstnCopy(List<Map<String, Object>> list) throws Exception {
		// 1. 설문지등록
		SrvypprVO srvyppr = new SrvypprVO();
		srvyppr.setSrvypprId(IdGenUtil.genNewId(IdPrefixType.SRPPR));
		srvyppr.setSrvyId((String) list.get(0).get("srvyId"));
		srvyppr.setSrvyTtl("문항가져오기용설문지");
		srvyppr.setSrvyCts("문항가져오기용설문지생성");
		srvyppr.setRgtrId((String) list.get(0).get("rgtrId"));
		srvypprDAO.srvypprRegist(srvyppr);

		// 2. 설문문항가져오기
		for(Map<String, Object> map : list) {
	 		map.put("srvyQstnId", IdGenUtil.genNewId(IdPrefixType.SRQN));
	 		map.put("srvypprId", srvyppr.getSrvypprId());
		}
	 	srvyQstnDAO.srvyQstnCopy(list);

	 	// 3. 설문보기항목가져오기
	 	srvyVwitmDAO.srvyVwitmCopy(list);

	 	// 4. 설문문항보기항목레벨가져오기
	 	srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlCopy(list);
	}

}
