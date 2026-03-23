package knou.lms.srvy.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.srvy.dao.SrvyQstnVwitmLvlDAO;
import knou.lms.srvy.service.SrvyQstnVwitmLvlService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyQstnVwitmLvlVO;

@Service("srvyQstnVwitmLvlService")
public class SrvyQstnVwitmLvlServiceImpl extends ServiceBase implements SrvyQstnVwitmLvlService {

	@Resource(name="srvyQstnVwitmLvlDAO")
	private SrvyQstnVwitmLvlDAO srvyQstnVwitmLvlDAO;

	/**
	 * 설문문항목록보기항목레벨삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	@Override
	public void srvyQstnListVwitmLvlDelete(List<SrvyQstnVO> list) throws Exception {
		srvyQstnVwitmLvlDAO.srvyQstnListVwitmLvlDelete(list);
	}

	/**
	 * 설문문항보기항목레벨등록
	 *
	 * @param SrvyQstnVO
	 * @param List<Map<String, Object>> lvls
	 * @throws Exception
	 */
	@Override
	public void srvyQstnVwitmLvlRegist(SrvyQstnVO vo, List<Map<String, Object>> lvls) throws Exception {
		List<SrvyQstnVwitmLvlVO> lvlList = new ArrayList<SrvyQstnVwitmLvlVO>();

		for (Map<String, Object> map : lvls) {
			SrvyQstnVwitmLvlVO lvl = new SrvyQstnVwitmLvlVO();
			lvl.setSrvyQstnVwitmLvlId(IdGenUtil.genNewId(IdPrefixType.SRQVL));
			lvl.setSrvyQstnId(vo.getSrvyQstnId());
			lvl.setLvlSeqno((Integer) map.get("lvlSeqno"));
			lvl.setLvlCts((String) map.get("lvlCts"));
			lvl.setLvlScr(Integer.valueOf((String) map.get("lvlScr")));
			lvl.setRgtrId(vo.getRgtrId());
			lvlList.add(lvl);
		}

		srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlBulkRegist(lvlList);
	}

	/**
	 * 설문문항보기항목레벨삭제
	 *
	 * @param srvyQstnId 설문문항아이디
	 * @throws Exception
	 */
	@Override
	public void srvyQstnVwitmLvlDelete(String srvyQstnId) throws Exception {
		srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlDelete(srvyQstnId);
	}

	/**
	 * 설문문항보기항목레벨목록조회
	 *
	 * @param srvyQstnId 설문문항아이디
	 * return 설문문항보기항목레벨목록
	 * @throws Exception
	 */
	@Override
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlList(String srvyQstnId) throws Exception {
		return srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlList(srvyQstnId);
	}

	/**
	 * 설문문항보기항목레벨일괄조회
	 *
	 * @param srvyId 		설문아이디
	 * @param searchType 	조회유형
	 * return 설문문항보기항목레벨일괄목록
	 * @throws Exception
	 */
	@Override
	public List<SrvyQstnVwitmLvlVO> srvyQstnVwitmLvlBulkList(String srvyId, String searchType) throws Exception {
		return srvyQstnVwitmLvlDAO.srvyQstnVwitmLvlBulkList(srvyId, searchType);
	}

}
