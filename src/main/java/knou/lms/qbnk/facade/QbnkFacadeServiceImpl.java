package knou.lms.qbnk.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.qbnk.service.QbnkCtgrService;
import knou.lms.qbnk.service.QbnkQstnService;
import knou.lms.qbnk.service.QbnkQstnVwitmService;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkMainView;

@Service("qbnkFacadeService")
public class QbnkFacadeServiceImpl extends ServiceBase implements QbnkFacadeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(QbnkFacadeServiceImpl.class);

	@Resource(name="qbnkCtgrService")
	private QbnkCtgrService qbnkCtgrService;

	@Resource(name="qbnkQstnService")
	private QbnkQstnService qbnkQstnService;

	@Resource(name="qbnkQstnVwitmService")
	private QbnkQstnVwitmService qbnkQstnVwitmService;

	@Resource(name="cmmnCdService")
	private CmmnCdService cmmnCdService;

	@Override
	public QbnkMainView loadProfQbnkListView(QbnkCtgrVO vo) throws Exception {
		QbnkMainView qbnkMainView = new QbnkMainView();

        // 상위문제은행분류목록조회
		qbnkMainView.setUpQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		// 문제은행검색과목목록조회
		qbnkMainView.setQbnkSearchSbjctList(qbnkCtgrService.qbnkSearchSbjctList(vo.getUserId()));

		// 문제은행검색교수목록조회
		qbnkMainView.setQbnkSearchProfList(qbnkCtgrService.qbnkSearchProfList());

        return qbnkMainView;
    }

	@Override
	public QbnkMainView loadProfQbnkQstnViewPopup(QbnkQstnVO vo) throws Exception {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행문항조회
		qbnkMainView.setQbnkQstnVO(qbnkQstnService.qbnkQstnSelect(vo));

        return qbnkMainView;
	}

	@Override
	public QbnkMainView loadProfQbnkQstnRegistView(QbnkCtgrVO vo, UserContext userCtx) throws Exception {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행과목정보조회
		qbnkMainView.setQbnkSbjct(qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

		// 상위문제은행분류목록조회
		vo.setUserRprsId(userCtx.getUserRprsId());
		qbnkMainView.setUpQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 문항답변유형코드 목록 조회
        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
        qstnRspnsTycdList.removeIf(item -> "SRVY".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

        // 문항난이도유형코드 목록 조회
        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

        qbnkMainView.setCmmnCdList(cmmnCdList);

		return qbnkMainView;
	}

	@Override
	public QbnkMainView loadProfQbnkQstnModifyView(QbnkQstnVO vo, UserContext userCtx) throws Exception {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행과목정보조회
		qbnkMainView.setQbnkSbjct(qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

		// 문제은행문항조회
		qbnkMainView.setQbnkQstnVO(qbnkQstnService.qbnkQstnSelect(vo));

		// 문제은행문항보기항목목록조회
		qbnkMainView.setQbnkQstnVwitmList(qbnkQstnVwitmService.qbnkQstnVwitmList(vo));

		// 상위문제은행분류목록조회
		QbnkCtgrVO ctgr = new QbnkCtgrVO();
		ctgr.setUserRprsId(userCtx.getUserRprsId());
		ctgr.setSbjctId(vo.getSbjctId());
		qbnkMainView.setUpQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(ctgr));

		Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
		// 문항답변유형코드 목록 조회
		List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
		qstnRspnsTycdList.removeIf(item -> "SRVY".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
		cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

		// 문항난이도유형코드 목록 조회
		List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
		qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
		cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

		qbnkMainView.setCmmnCdList(cmmnCdList);

		return qbnkMainView;
	}

	@Override
	public QbnkMainView loadProfQbnkCtgrMngView(QbnkCtgrVO vo) throws Exception {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행과목정보조회
		qbnkMainView.setQbnkSbjct(qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

        // 상위문제은행분류목록조회
		qbnkMainView.setUpQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		// 문제은행검색과목목록조회
		qbnkMainView.setQbnkSearchSbjctList(qbnkCtgrService.qbnkSearchSbjctList(vo.getUserId()));

		// 문제은행검색교수목록조회
		qbnkMainView.setQbnkSearchProfList(qbnkCtgrService.qbnkSearchProfList());

        return qbnkMainView;
    }

}
