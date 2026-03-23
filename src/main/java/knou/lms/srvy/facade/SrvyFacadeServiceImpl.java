package knou.lms.srvy.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.exam.service.ExamService;
import knou.lms.srvy.service.SrvyPtcpService;
import knou.lms.srvy.service.SrvyQstnService;
import knou.lms.srvy.service.SrvyQstnVwitmLvlService;
import knou.lms.srvy.service.SrvyRspnsService;
import knou.lms.srvy.service.SrvyService;
import knou.lms.srvy.service.SrvyVwitmService;
import knou.lms.srvy.service.SrvypprService;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyMainView;

@Service("srvyFacadeService")
public class SrvyFacadeServiceImpl extends ServiceBase implements SrvyFacadeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SrvyFacadeServiceImpl.class);

	@Resource(name="srvyService")
	private SrvyService srvyService;

	@Resource(name="srvypprService")
	private SrvypprService srvypprService;

	@Resource(name="srvyQstnService")
	private SrvyQstnService srvyQstnService;

	@Resource(name="srvyQstnVwitmLvlService")
	private SrvyQstnVwitmLvlService srvyQstnVwitmLvlService;

	@Resource(name="srvyRspnsService")
	private SrvyRspnsService srvyRspnsService;

	@Resource(name="srvyVwitmService")
	private SrvyVwitmService srvyVwitmService;

	@Resource(name="srvyPtcpService")
	private SrvyPtcpService srvyPtcpService;

	@Resource(name="examService")
	private ExamService examService;

	@Resource(name="cmmnCdService")
	private CmmnCdService cmmnCdService;

	@Override
	public SrvyMainView getProfSrvyList(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 교수설문목록조회
		srvyMainView.setProfSrvyList(srvyService.profSrvyListPaging(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyRegistView(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 과목분반목록조회
		srvyMainView.setSbjctDcvlasList(examService.sbjctDvclasList(vo.getSbjctId()));

		return srvyMainView;
	}

	@Override
	public SrvyMainView srvyRegist(SrvyVO vo, Map<String, String> subMap) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문등록
		srvyMainView.setSrvyVO(srvyService.srvyRegist(vo, subMap));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyModifyView(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

        // 설문정보조회
		srvyMainView.setSrvyEgovMap(srvyService.srvySelect(vo));

        // 설문그룹과목목록조회
        srvyMainView.setSrvyGrpSbjctList(srvyService.srvyGrpSbjctList(vo.getSrvyId()));

        return srvyMainView;
	}

	@Override
	public SrvyMainView srvyModify(SrvyVO vo, Map<String, String> subMap) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문수정
		srvyMainView.setSrvyVO(srvyService.srvyModify(vo, subMap));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSbjctMrkOynSrvyCnt(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 과목성적공개설문수조회
		vo.setTotalCnt(srvyService.sbjctMrkOynSrvyCntSelect(vo));
		srvyMainView.setSrvyVO(vo);

		return srvyMainView;
	}

	@Override
	public void srvyDtlModify(SrvyVO vo) throws Exception {
		// 설문세부정보수정
		srvyService.srvyDtlModify(vo);
	}

	@Override
	public void srvyMrkRfltrtListModify(List<SrvyVO> list) throws Exception {
		// 설문성적반영비율목록수정
		srvyService.srvyMrkRfltrtListModify(list);
	}

	@Override
	public SrvyMainView getSrvyLrnGrpSubAsmtList(Map<String, Object> params) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문학습그룹부과제목록조회
		srvyMainView.setSrvyLrnGrpSubAsmtList(srvyService.srvyLrnGrpSubAsmtList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfBfrSrvyCopyPopup(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문검색용학기기수목록조회
		srvyMainView.setSrvySearchSmstrList(examService.qstnCopySmstrList());

		return srvyMainView;
	}

	@Override
	public SrvyMainView getProfAuthrtSbjctSrvyList(Map<String, Object> params) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 교수권한과목설문목록조회
		srvyMainView.setProfAuthrtSbjctSrvyList(srvyService.profAuthrtSbjctSrvyList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvy(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		srvyMainView.setSrvyEgovMap(srvyService.srvySelect(vo));

		return srvyMainView;
	}

	@Override
	public void srvyDelete(SrvyVO vo) throws Exception {
		// 설문삭제
		srvyService.srvyDelete(vo);

		// 설문성적반영비율수정
		srvyService.srvyMrkRfltrtModify(vo);
	}

	@Override
	public SrvyMainView loadProfSrvypprPreviewPopup(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		String upSrvyId = vo.getUpSrvyId() != null ? vo.getUpSrvyId() : vo.getSrvyId();
		String srvyId = vo.getSrvyId();

		// 설문조회
		vo.setSrvyId(upSrvyId);
		EgovMap srvyMap = srvyService.srvySelect(vo);
		srvyId = vo.getUpSrvyId() != null ? srvyId : (String) srvyMap.get("subSrvyId");
		srvyMap.put("subSrvyId", srvyId);
		srvyMainView.setSrvyEgovMap(srvyMap);

		// 팀 설문
		if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
		    // 설문팀목록조회
			srvyMainView.setSrvyTeamList(srvyService.srvyTeamList(upSrvyId));
		}

		// 설문지목록조회
		srvyMainView.setSrvypprList(srvypprService.srvypprList(srvyId, ""));

		// 설문문항목록조회
		srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(srvyId, ""));

		// 설문보기항목일괄목록조회
		srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(srvyId, "", ""));

		// 설문문항보기항목레벨일괄조회
		srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(srvyId, ""));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyQstnMngView(SrvyVO vo, UserContext userCtx) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문정보조회
		srvyMainView.setSrvyEgovMap(srvyService.srvySelect(vo));

        if("SRVY_TEAM".equals(srvyMainView.getSrvyEgovMap().get("srvyGbn"))) {
            // 설문팀목록조회
        	srvyMainView.setSrvyTeamList(srvyService.srvyTeamList(vo.getSrvyId()));

            // 설문팀문제출제완료여부조회
        	srvyMainView.setIsQstnsCmptn(srvyService.srvyTeamQstnsCmptnynSelect(vo.getSrvyId()));
        }

        Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 문항답변유형코드 목록 조회
        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_RSPNS_TYCD").getReturnList();
        qstnRspnsTycdList.removeIf(item -> "QUIZ".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

        // 문항난이도유형코드 목록 조회
        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "QSTN_DFCTLV_TYCD").getReturnList();
        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

        srvyMainView.setCmmnCdList(cmmnCdList);

        return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvypprQstnList(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지 목록 조회
		srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

		// 설문문항 목록 조회
		srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), ""));

		return srvyMainView;
	}

	@Override
	public void srvypprRegist(SrvypprVO vo) throws Exception {
		// 설문지등록
		srvypprService.srvypprRegist(vo);
	}

	@Override
	public SrvyMainView loadProfSrvypprModifyPopup(SrvypprVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지조회
		srvyMainView.setSrvypprVO(srvypprService.srvypprSelect(vo.getSrvypprId()));

		return srvyMainView;
	}

	@Override
	public Integer getSrvypprPtcpCntSelect(SrvypprVO vo) throws Exception {
		return srvypprService.srvypprPtcpCntSelect(vo);
	}

	@Override
	public void srvypprDelete(SrvypprVO vo) throws Exception {
		// 1. 설문지문항목록조회
		List<SrvyQstnVO> qstnList = srvyQstnService.srvypprQstnList(vo.getSrvypprId());

		if(qstnList.size() > 0) {
			// 2. 설문문항목록보기항목레벨삭제
			srvyQstnVwitmLvlService.srvyQstnListVwitmLvlDelete(qstnList);

			// 3. 설문문항목록답변삭제
			srvyRspnsService.srvyQstnListRspnsDelete(qstnList);

			// 4. 설문문항목록보기항목삭제
			srvyVwitmService.srvyQstnListVwitmDelete(qstnList);
		}

		// 5. 설문지문항삭제
		srvyQstnService.srvypprQstnDelete(vo.getSrvypprId());

		// 6. 설문지삭제
		srvypprService.srvypprDelete(vo);
	}

	@Override
    public SrvyMainView loadProfSrvyQstnCopyPopup(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

    	// 설문검색용학기기수목록조회
		srvyMainView.setSrvySearchSmstrList(examService.qstnCopySmstrList());

    	return srvyMainView;
    }

	@Override
	public SrvyMainView getQstnCopySrvyList(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 문제가져오기설문목록조회
		srvyMainView.setQstnCopySrvyList(srvyService.qstnCopySrvyList(vo.getSbjctId()));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getQstnCopySrvypprList(SrvypprVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지목록조회
		srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getQstnCopySrvyQstnList(SrvyQstnVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문문항목록조회
		srvyMainView.setSrvyQstnList(srvyQstnService.profQstnCopySrvyQstnList(vo));

		return srvyMainView;
	}

	@Override
	public void srvyQstnCopy(List<Map<String, Object>> list) throws Exception {
		// 설문문항가져오기
		srvyQstnService.srvyQstnCopy(list);
	}

	@Override
	public void srvyQstnRegist(SrvyQstnVO vo, String qstnsStr, String lvlsStr) throws Exception {
		ObjectMapper mapper = new ObjectMapper();

		List<Map<String, Object>> qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});
		List<Map<String, Object>> lvls = mapper.readValue(lvlsStr, new TypeReference<List<Map<String, Object>>>() {});

		// 1. 설문문항등록
		vo = srvyQstnService.srvyQstnRegist(vo);

		// 2. 설문보기항목등록
		srvyVwitmService.srvyVwitmRegist(vo, qstns);

		// 레벨형
		if("LEVEL".equals(vo.getQstnRspnsTycd())) {
			// 3. 설문문항보기항목레벨등록
			srvyQstnVwitmLvlService.srvyQstnVwitmLvlRegist(vo, lvls);
		}
	}

	@Override
	public void srvyQstnModify(SrvyQstnVO vo, String qstnsStr, String lvlsStr) throws Exception {
		ObjectMapper mapper = new ObjectMapper();

		List<Map<String, Object>> qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});
		List<Map<String, Object>> lvls = mapper.readValue(lvlsStr, new TypeReference<List<Map<String, Object>>>() {});

		// 1. 설문문항수정
		if(vo.getEsntlRspnsyn() == null) vo.setEsntlRspnsyn("N");
		if(vo.getEtcInptUseyn() == null) vo.setEtcInptUseyn("N");
		if(vo.getSrvyMvmnUseyn() == null) vo.setSrvyMvmnUseyn("N");
		srvyQstnService.srvyQstnModify(vo);

		// 2. 설문보기항목수정
		srvyVwitmService.srvyVwitmModify(vo, qstns);

		// 3. 설문문항보기항목레벨삭제
		srvyQstnVwitmLvlService.srvyQstnVwitmLvlDelete(vo.getSrvyQstnId());

		// 레벨형
		if("LEVEL".equals(vo.getQstnRspnsTycd())) {
			// 3. 설문문항보기항목레벨등록
			srvyQstnVwitmLvlService.srvyQstnVwitmLvlRegist(vo, lvls);
		}
	}

	@Override
	public void srvyQstnDelete(SrvyQstnVO vo) throws Exception {
		// 설문문항삭제
		srvyQstnService.srvyQstnDelete(vo);
	}

	@Override
	public SrvyMainView getSrvyQstn(SrvyQstnVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 1. 설문문항조회
		srvyMainView.setSrvyQstnVO(srvyQstnService.srvyQstnSelect(vo));

		// 2. 설문보기항목목록조회
		srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmList(vo.getSrvyQstnId()));

		// 3. 설문문항보기항목레벨목록조회
		srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlList(vo.getSrvyQstnId()));

		return srvyMainView;
	}

	@Override
	public void srvySeqnoModify(SrvypprVO vo) throws Exception {
		// 설문지순번수정
		srvypprService.srvySeqnoModify(vo);
	}

	@Override
	public void qstnSeqnoModify(SrvyQstnVO vo) throws Exception {
		// 문항순번수정
		srvyQstnService.qstnSeqnoModify(vo);
	}

	@Override
	public void srvyQstnsCmptnModify(SrvyVO vo) throws Exception {
		// 설문문제출제완료수정
		srvyService.srvyQstnsCmptnModify(vo);
	}

	@Override
	public SrvyMainView loadProfSrvyEvlMngView(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문정보조회
		srvyMainView.setSrvyEgovMap(srvyService.srvySelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyPtcpList(Map<String, Object> params) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		srvyMainView.setSrvyPtcpList(srvyPtcpService.srvyPtcpList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyMemoPopup(Map<String, Object> params) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문정보조회
		SrvyVO srvy = new SrvyVO();
		srvy.setSrvyId((String) params.get("srvyId"));
		srvyMainView.setSrvyEgovMap(srvyService.srvySelect(srvy));

		// 설문참여자조회
		srvyMainView.setSrvyPtcpnt(srvyPtcpService.srvyPtcpntSelect((String) params.get("srvyId"), (String) params.get("userId")));

		// 교수메모조회
		srvyMainView.setProfMemo(srvyPtcpService.profMemoSelect((String) params.get("srvyPtcpId"), (String) params.get("userId")));

		return srvyMainView;
	}

	@Override
	public void profMemoModify(Map<String, Object> params) throws Exception {
		// 교수메모수정
		srvyPtcpService.profMemoModify(params);
	}

	@Override
	public void profSrvyEvlScrBulkModify(List<Map<String, Object>> list) throws Exception {
		// 교수설문평가점수일괄수정
		srvyPtcpService.profSrvyEvlScrBulkModify(list);
	}

	@Override
	public SrvyMainView loadProfSrvyPtcpStatusPopup(SrvyVO vo, UserContext userCtx) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		String upSrvyId = vo.getUpSrvyId() != null ? vo.getUpSrvyId() : vo.getSrvyId();
		String srvyId = vo.getSrvyId();

		// 설문조회
		vo.setSrvyId(upSrvyId);
        EgovMap srvyMap = srvyService.srvySelect(vo);
        srvyId = vo.getUpSrvyId() != null ? srvyId : (String) srvyMap.get("subSrvyId");
        srvyMap.put("subSrvyId", srvyId);
        srvyMainView.setSrvyEgovMap(srvyMap);

        // 팀 설문
        if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
            // 설문팀목록조회
        	srvyMainView.setSrvyTeamList(srvyService.srvyTeamList(upSrvyId));
        }

        Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();

        // 접속기기유형코드 목록 조회
        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "CNTN_DVC_TYCD").getReturnList();
        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("cntnDvcTycd", qstnDfctlvTycdList);

        srvyMainView.setCmmnCdList(cmmnCdList);

        // 설문참여장치별현황목록
        srvyMainView.setSrvyPtcpDvcStatusList(srvyPtcpService.srvyPtcpDvcStatusList(srvyId, vo.getSbjctId(), userCtx.getOrgId()));

        // 설문참여수조회
        srvyMainView.setSrvyPtcpCnt(srvyPtcpService.srvyPtcpCntSelect(srvyId, vo.getSbjctId()));

        // 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(srvyId, ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(srvyId, ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(srvyId, "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(srvyId, ""));

        // 설문선택형문항답변현황목록
        srvyMainView.setSrvyChcQstnRspnsStatusList(srvyRspnsService.srvyChcQstnRspnsStatusList(vo.getSbjctId(), srvyId, ""));

        // 설문서술형문항답변현황목록
        srvyMainView.setSrvyTextQstnRspnsStatusList(srvyRspnsService.srvyTextQstnRspnsStatusList(vo.getSbjctId(), srvyId, ""));

        // 설문레벨형문항답변현황목록
        srvyMainView.setSrvyLevelQstnRspnsStatusList(srvyRspnsService.srvyLevelQstnRspnsStatusList(vo.getSbjctId(), srvyId, ""));

        // 목록표시형 색상배열목록
        List<Map<String, Object>> colorList = new ArrayList<Map<String, Object>>();
        String[] colorTitleList = {"bcOrange", "bcYellow", "bcOlive", "bcGreen", "bcLblue", "bcTeal", "bcViolet", "bcBrown", "bcGrey", "bcPink"};
        String[] colorCodeList = {"#f2711c", "#fbbd08", "#b5cc18", "#21ba45", "#deeaf6", "#00b5ad", "#6435c9", "#a5673f", "#767676", "#e03997"};
        for(int i = 0; i < 10; i++) {
            Map<String, Object> colorMap = new HashMap<String, Object>();
            colorMap.put("title", colorTitleList[i]);
            colorMap.put("code", colorCodeList[i]);
            colorList.add(colorMap);
        }
        srvyMainView.setColorList(colorList);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyPtcpStatusExcelDownList(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		EgovMap srvyMap = srvyService.srvySelect(vo);
		srvyMainView.setSrvyEgovMap(srvyMap);

		// 팀 설문
		if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
		    // 설문팀목록조회
			srvyMainView.setSrvyTeamList(srvyService.srvyTeamList(vo.getSrvyId()));
		}

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), "EXCEL"));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), "EXCEL"));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getSrvyId(), "LEVEL", "EXCEL"));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getSrvyId(), "EXCEL"));

        // 설문선택형문항답변현황목록
        srvyMainView.setSrvyChcQstnRspnsStatusList(srvyRspnsService.srvyChcQstnRspnsStatusList(vo.getSbjctId(), vo.getSrvyId(), "EXCEL"));

        // 설문서술형문항답변현황목록
        srvyMainView.setSrvyTextQstnRspnsStatusList(srvyRspnsService.srvyTextQstnRspnsStatusList(vo.getSbjctId(), vo.getSrvyId(), "EXCEL"));

        // 설문레벨형문항답변현황목록
        srvyMainView.setSrvyLevelQstnRspnsStatusList(srvyRspnsService.srvyLevelQstnRspnsStatusList(vo.getSbjctId(), vo.getSrvyId(), "EXCEL"));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyRspnsStatusExcelDownList(SrvyVO vo) throws Exception {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		EgovMap srvyMap = srvyService.srvySelect(vo);
		srvyMainView.setSrvyEgovMap(srvyMap);

		// 팀 설문
		if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
		    // 설문팀목록조회
			srvyMainView.setSrvyTeamList(srvyService.srvyTeamList(vo.getSrvyId()));
		}

		srvyMainView.setSrvyExcelDownQstnList(srvyRspnsService.srvyExcelDownQstnList(vo.getSrvyId()));

		srvyMainView.setSrvyExcelDownQstnRspnsList(srvyRspnsService.srvyExcelDownQstnRspnsList(vo.getSrvyId()));

		return srvyMainView;
	}

}
