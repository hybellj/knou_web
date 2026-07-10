package knou.lms.qbnk.facade;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
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
import knou.lms.qbnk.web.view.QbnkPageInfo;

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
	public QbnkMainView loadProfQbnkListView(QbnkCtgrVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행과목정보조회
		qbnkMainView.setEgovMap(qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

        // 상위문제은행분류목록조회
		qbnkMainView.setQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		// 문제은행검색과목목록조회
		egovListMap.put("sbjctList", qbnkCtgrService.qbnkSearchSbjctList(vo.getSbjctId()));

		// 문제은행검색교수목록조회
		egovListMap.put("profList", qbnkCtgrService.qbnkSearchProfList());
		qbnkMainView.setEgovListMap(egovListMap);

        return qbnkMainView;
    }

	@Override
	public QbnkMainView getProfQbnkCtgrList(QbnkCtgrVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 교수문제은행분류목록조회
		qbnkMainView.setQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		return qbnkMainView;
	}

	@Override
	public QbnkMainView getProfQbnkQstnList(QbnkPageInfo pageInfo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행문항목록조회
		qbnkMainView.setResultDTO(qbnkQstnService.qbnkQstnList(pageInfo));

		return qbnkMainView;
	}

	@Override
	public QbnkMainView loadProfQbnkQstnViewPopup(QbnkQstnVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행문항조회
		qbnkMainView.setEgovMap(qbnkQstnService.qbnkQstnSelect(vo));

		// 문제은행문항보기항목목록조회
		qbnkMainView.setQbnkQstnVwitmList(qbnkQstnVwitmService.qbnkQstnVwitmList(vo));

        return qbnkMainView;
	}

	@Override
	public QbnkMainView loadProfQbnkQstnRegistView(QbnkCtgrVO vo, UserContext userCtx) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행과목정보조회
		qbnkMainView.setEgovMap(qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

		// 상위문제은행분류목록조회
		vo.setUserId(userCtx.getUserId());
		qbnkMainView.setQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		try {
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
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return qbnkMainView;
	}

	@Override
	public void qbnkQstnRegist(QbnkQstnVO vo, String qstnsStr) {
		// 문제은행문항등록
		qbnkQstnService.qbnkQstnRegist(vo, qstnsStr);
	}

	@Override
	public QbnkMainView loadProfQbnkQstnModifyView(QbnkQstnVO vo, UserContext userCtx) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 문제은행과목정보조회
		eMap.put("qbnkSbjct", qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

		// 문제은행문항조회
		eMap.put("qbnkQstnVO", qbnkQstnService.qbnkQstnSelect(vo));
		qbnkMainView.seteMap(eMap);

		// 문제은행문항보기항목목록조회
		qbnkMainView.setQbnkQstnVwitmList(qbnkQstnVwitmService.qbnkQstnVwitmList(vo));

		// 상위문제은행분류목록조회
		QbnkCtgrVO ctgr = new QbnkCtgrVO();
		ctgr.setUserId(userCtx.getUserId());
		ctgr.setSbjctId(vo.getSbjctId());
		qbnkMainView.setQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(ctgr));

		try {
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
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return qbnkMainView;
	}

	@Override
	public void qbnkQstnModify(QbnkQstnVO vo, String qstnsStr) {
		// 문제은행문항수정
		qbnkQstnService.qbnkQstnModify(vo, qstnsStr);
	}

	@Override
	public void qbnkQstnDelete(QbnkQstnVO vo) {
		// 문제은행문항삭제
		qbnkQstnService.qbnkQstnDelete(vo);
	}

	@Override
	public QbnkMainView loadProfQbnkCtgrMngView(QbnkCtgrVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행과목정보조회
		qbnkMainView.setEgovMap(qbnkCtgrService.profQbnkSbjctSelect(vo.getSbjctId()));

        // 상위문제은행분류목록조회
		qbnkMainView.setQbnkCtgrList(qbnkCtgrService.profQbnkCtgrList(vo));

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		// 문제은행검색과목목록조회
		egovListMap.put("sbjctList", qbnkCtgrService.qbnkSearchSbjctList(vo.getSbjctId()));

		// 문제은행검색교수목록조회
		egovListMap.put("profList", qbnkCtgrService.qbnkSearchProfList());
		qbnkMainView.setEgovListMap(egovListMap);

        return qbnkMainView;
    }

	@Override
	public QbnkMainView getProfQbnkCtgrAllList(QbnkPageInfo pageInfo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 교수문제은행분류전체목록조회
		qbnkMainView.setResultDTO(qbnkCtgrService.profQbnkCtgrAllList(pageInfo));

		return qbnkMainView;
	}

	@Override
	public Integer getQbnkNextCtgrSeqnoSelect(QbnkCtgrVO vo) {
		// 문제은행다음분류순번조회
		return qbnkCtgrService.qbnkNextCtgrSeqnoSelect(vo);
	}

	@Override
	public void qbnkCtgrRegist(QbnkCtgrVO vo) {
		// 문제은행분류등록
		qbnkCtgrService.qbnkCtgrRegist(vo);
	}

	@Override
	public QbnkMainView getQbnkCtgrSelect(QbnkCtgrVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행분류조회
		qbnkMainView.setQbnkCtgrVO(qbnkCtgrService.qbnkCtgrSelect(vo.getQbnkCtgrId()));

		return qbnkMainView;
	}

	@Override
	public QbnkMainView getQbnkCtgrUseCntSelect(QbnkCtgrVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 문제은행분류사용수조회
		qbnkMainView.setEgovMap(qbnkCtgrService.qbnkCtgrUseCntSelect(vo.getQbnkCtgrId()));

		return qbnkMainView;
	}

	@Override
	public void qbnkCtgrDelete(QbnkCtgrVO vo) {
		// 문제은행분류삭제
		qbnkCtgrService.qbnkCtgrDelete(vo);
	}

	@Override
	public QbnkMainView getProfQstnCopyQbnkQstnList(QbnkQstnVO vo) {
		QbnkMainView qbnkMainView = new QbnkMainView();

		// 교수문항복사문제은행문항목록조회
		qbnkMainView.setEgovList(qbnkQstnService.profQstnCopyQbnkQstnList(vo));

		return qbnkMainView;
	}

}
