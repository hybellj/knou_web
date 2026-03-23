package knou.lms.srvy.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.srvy.dao.SrvyVwitmDAO;
import knou.lms.srvy.service.SrvyVwitmService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVwitmVO;

@Service("srvyVwitmService")
public class SrvyVwitmServiceImpl extends ServiceBase implements SrvyVwitmService {

	@Resource(name="srvyVwitmDAO")
	private SrvyVwitmDAO srvyVwitmDAO;

	/**
	 * 설문문항목록보기항목삭제
	 *
	 * @param List<SrvyQstnVO>
	 * @throws Exception
	 */
	@Override
	public void srvyQstnListVwitmDelete(List<SrvyQstnVO> list) throws Exception {
		srvyVwitmDAO.srvyQstnListVwitmDelete(list);
	}

	/**
	 * 설문보기항목등록
	 *
	 * @param SrvyQstnVO
	 * @param List<Map<String, Object>> qstns
	 * @throws Exception
	 */
	@Override
	public void srvyVwitmRegist(SrvyQstnVO vo, List<Map<String, Object>> qstns) throws Exception {
		if (qstns != null && !qstns.isEmpty()) {
			List<SrvyVwitmVO> vwitmList = new ArrayList<SrvyVwitmVO>();

			for (Map<String, Object> map : qstns) {
				String vwitmCts = (String) map.get("vwitmCts");
				SrvyVwitmVO vwitm = new SrvyVwitmVO();
				vwitm.setSrvyVwitmId(IdGenUtil.genNewId(IdPrefixType.SRVW));
				vwitm.setSrvyQstnId(vo.getSrvyQstnId());
				vwitm.setVwitmGbncd(vo.getQstnGbncd());
				vwitm.setVwitmCts(vwitmCts);
				vwitm.setVwitmSeqno((Integer) map.get("vwitmSeqno"));
				vwitm.setMvmnSrvyQstnId((String) map.get("mvmnSrvyQstnId"));
				vwitm.setEtcInptyn("ETC".equals(vwitmCts) ? "Y" : "N");
				vwitm.setRgtrId(vo.getRgtrId());
				vwitmList.add(vwitm);
			}

			srvyVwitmDAO.srvyVwitmBulkRegist(vwitmList);
		}
	}

	/**
	 * 설문보기항목수정
	 *
	 * @param SrvyQstnVO
	 * @param List<Map<String, Object>> qstns
	 * @throws Exception
	 */
	@Override
	public void srvyVwitmModify(SrvyQstnVO vo, List<Map<String, Object>> qstns) throws Exception {
		// 설문보기항목삭제
		srvyVwitmDAO.srvyVwitmDelete(vo.getSrvyQstnId());

		// 설문보기항목일괄등록
		if (qstns != null && !qstns.isEmpty()) {
			List<SrvyVwitmVO> vwitmList = new ArrayList<SrvyVwitmVO>();

			for (Map<String, Object> map : qstns) {
				String vwitmCts = (String) map.get("vwitmCts");
				SrvyVwitmVO vwitm = new SrvyVwitmVO();
				vwitm.setSrvyVwitmId(IdGenUtil.genNewId(IdPrefixType.SRVW));
				vwitm.setSrvyQstnId(vo.getSrvyQstnId());
				vwitm.setVwitmGbncd(vo.getQstnGbncd());
				vwitm.setVwitmCts(vwitmCts);
				vwitm.setVwitmSeqno((Integer) map.get("vwitmSeqno"));
				vwitm.setMvmnSrvyQstnId((String) map.get("mvmnSrvyQstnId"));
				vwitm.setEtcInptyn("ETC".equals(vwitmCts) ? "Y" : "N");
				vwitm.setRgtrId(vo.getRgtrId());
				vwitmList.add(vwitm);
			}

			srvyVwitmDAO.srvyVwitmBulkRegist(vwitmList);
		}
	}

	/**
	 * 설문보기항목목록조회
	 *
	 * @param srvyQstnId 설문문항아이디
	 * return 설문보기항목목록
	 * @throws Exception
	 */
	@Override
	public List<SrvyVwitmVO> srvyVwitmList(String srvyQstnId) throws Exception {
		return srvyVwitmDAO.srvyVwitmList(srvyQstnId);
	}

	/**
	 * 설문보기항목일괄조회
	 *
	 * @param srvyId 		설문아이디
	 * @param qstnRspnsTycd 문항답변유형코드
	 * @param searchType 	조회유형
	 * return 설문보기항목목록
	 * @throws Exception
	 */
	@Override
	public List<SrvyVwitmVO> srvyVwitmBulkList(String srvyId, String qstnRspnsTycd, String searchType) throws Exception {
		return srvyVwitmDAO.srvyVwitmBulkList(srvyId, qstnRspnsTycd, searchType);
	}

}
