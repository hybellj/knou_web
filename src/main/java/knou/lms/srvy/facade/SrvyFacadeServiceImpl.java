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
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.service.ExamService;
import knou.lms.org.service.OrgService;
import knou.lms.srvy.service.SrvyPtcpHstryService;
import knou.lms.srvy.service.SrvyPtcpService;
import knou.lms.srvy.service.SrvyQstnService;
import knou.lms.srvy.service.SrvyQstnVwitmLvlService;
import knou.lms.srvy.service.SrvyRspnsService;
import knou.lms.srvy.service.SrvyService;
import knou.lms.srvy.service.SrvyVwitmService;
import knou.lms.srvy.service.SrvypprService;
import knou.lms.srvy.vo.SrvyPtcpHstryVO;
import knou.lms.srvy.vo.SrvyPtcpVO;
import knou.lms.srvy.vo.SrvyQstnVO;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.vo.SrvypprVO;
import knou.lms.srvy.web.view.SrvyMainView;
import knou.lms.srvy.web.view.SrvyPageInfo;

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

	@Resource(name="srvyPtcpHstryService")
	private SrvyPtcpHstryService srvyPtcpHstryService;

	@Resource(name="examService")
	private ExamService examService;

	@Resource(name="cmmnCdService")
	private CmmnCdService cmmnCdService;

	@Resource(name="orgService")
	private OrgService orgService;

	@Override
	public SrvyMainView getProfSrvyList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 교수설문목록조회
		srvyMainView.setResultDTO(srvyService.profSrvyListPaging(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyRegistView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();

		// 과목분반목록조회
		egovListMap.put("dvclasList", examService.sbjctDvclasList(vo.getSbjctId()));

		// 강의주차목록조회
		egovListMap.put("lctrWknoList", examService.lctrWknoList(vo.getSbjctId()));

		srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView srvyRegist(SrvyVO vo, Map<String, String> subMap) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문등록
		srvyMainView.setSrvyVO(srvyService.srvyRegist(vo, subMap));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyModifyView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

        // 설문정보조회
		srvyMainView.setEgovMap(srvyService.srvySelect(vo));

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();

		// 설문그룹과목목록조회
		egovListMap.put("dvclasList", srvyService.srvyGrpSbjctList(vo.getSrvyId()));

		// 강의주차목록조회
		egovListMap.put("lctrWknoList", examService.lctrWknoList(vo.getSbjctId()));

		srvyMainView.setEgovListMap(egovListMap);

        return srvyMainView;
	}

	@Override
	public SrvyMainView srvyModify(SrvyVO vo, Map<String, String> subMap) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문수정
		srvyMainView.setSrvyVO(srvyService.srvyModify(vo, subMap));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSbjctMrkOynSrvyCnt(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 과목성적공개설문수조회
		vo.setTotalCnt(srvyService.sbjctMrkOynSrvyCntSelect(vo));
		srvyMainView.setSrvyVO(vo);

		return srvyMainView;
	}

	@Override
	public void srvyDtlModify(SrvyVO vo) {
		// 설문세부정보수정
		srvyService.srvyDtlModify(vo);
	}

	@Override
	public void srvyMrkRfltrtListModify(List<SrvyVO> list) {
		// 설문성적반영비율목록수정
		srvyService.srvyMrkRfltrtListModify(list);
	}

	@Override
	public SrvyMainView getSrvyTeamGrpSubSrvyList(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문팀그룹부설문목록조회
		srvyMainView.setEgovList(srvyService.srvyTeamGrpSubSrvyList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfBfrSrvyCopyPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문검색용학기기수목록조회
		srvyMainView.setEgovList(examService.qstnCopySmstrList(vo.getOrgId(), ""));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getProfAuthrtSbjctSrvyList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 교수권한과목설문목록조회
		srvyMainView.setEgovList(srvyService.profAuthrtSbjctSrvyList(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvy(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		srvyMainView.setEgovMap(srvyService.srvySelect(vo));

		return srvyMainView;
	}

	@Override
	public void srvyDelete(SrvyVO vo) {
		// 설문삭제
		srvyService.srvyDelete(vo);

		// 설문성적반영비율수정
		srvyService.srvyMrkRfltrtModify(vo);
	}

	@Override
	public SrvyMainView loadProfSrvypprPreviewPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		String upSrvyId = vo.getUpSrvyId() != null ? vo.getUpSrvyId() : vo.getSrvyId();
		String srvyId = vo.getSrvyId();

		// 설문조회
		vo.setSrvyId(upSrvyId);
		EgovMap srvyMap = srvyService.srvySelect(vo);	// 설문조회
		if("LCTR".equals(vo.getSearchValue())) srvyMap = srvyService.srvyLctrEvlSelect(vo);	// 설문강의평가조회
		if("WHOL".equals(vo.getSearchValue())) srvyMap = srvyService.admSrvySelect(vo);		// 관리자전체설문조회
		srvyId = vo.getUpSrvyId() != null ? srvyId : (String) srvyMap.get("subSrvyId");
		srvyMap.put("subSrvyId", srvyId);
		srvyMainView.setEgovMap(srvyMap);

		// 팀 설문
		if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
		    // 설문팀목록조회
			srvyMainView.setEgovList(srvyService.srvyTeamList(upSrvyId));
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
	public SrvyMainView loadProfSrvyQstnMngView(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문정보조회
		srvyMainView.setEgovMap(srvyService.srvySelect(vo));

        if("SRVY_TEAM".equals(srvyMainView.getEgovMap().get("srvyGbn"))) {
            // 설문팀목록조회
        	srvyMainView.setEgovList(srvyService.srvyTeamList(vo.getSrvyId()));

            // 설문팀문제출제완료여부조회
        	srvyMainView.setIsQstnsCmptn(srvyService.srvyTeamQstnsCmptnynSelect(vo.getSrvyId()));
        }

        try {
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
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvypprQstnList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지 목록 조회
		srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

		// 설문문항 목록 조회
		srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), ""));

		return srvyMainView;
	}

	@Override
	public void srvypprRegist(SrvypprVO vo) {
		// 설문지등록
		srvypprService.srvypprRegist(vo);
	}

	@Override
	public SrvyMainView loadProfSrvypprModifyPopup(SrvypprVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지조회
		srvyMainView.setSrvypprVO(srvypprService.srvypprSelect(vo.getSrvypprId()));

		return srvyMainView;
	}

	@Override
	public Integer getSrvypprPtcpCntSelect(SrvypprVO vo) {
		// 설문지참여수조회
		return srvypprService.srvypprPtcpCntSelect(vo);
	}

	@Override
	public void srvypprDelete(SrvypprVO vo) {
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
    public SrvyMainView loadProfSrvyQstnCopyPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

    	// 설문검색용학기기수목록조회
		srvyMainView.setEgovList(examService.qstnCopySmstrList(vo.getOrgId(), ""));

    	return srvyMainView;
    }

	@Override
	public SrvyMainView getQstnCopySrvyList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 문제가져오기설문목록조회
		srvyMainView.setSrvyList(srvyService.qstnCopySrvyList(vo.getSbjctId()));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getQstnCopySrvypprList(SrvypprVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지목록조회
		srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getQstnCopySrvyQstnList(SrvyQstnVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문문항목록조회
		srvyMainView.setEgovList(srvyQstnService.profQstnCopySrvyQstnList(vo));

		return srvyMainView;
	}

	@Override
	public void srvyQstnCopy(List<Map<String, Object>> list) {
		// 설문문항가져오기
		srvyQstnService.srvyQstnCopy(list);
	}

	@Override
	public void srvyQstnRegist(SrvyQstnVO vo, String qstnsStr, String lvlsStr) {
		ObjectMapper mapper = new ObjectMapper();

		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> lvls = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});
			lvls = mapper.readValue(lvlsStr, new TypeReference<List<Map<String, Object>>>() {});
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

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
	public void srvyQstnModify(SrvyQstnVO vo, String qstnsStr, String lvlsStr) {
		ObjectMapper mapper = new ObjectMapper();

		List<Map<String, Object>> qstns = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> lvls = new ArrayList<Map<String,Object>>();
		try {
			qstns = mapper.readValue(qstnsStr, new TypeReference<List<Map<String, Object>>>() {});
			lvls = mapper.readValue(lvlsStr, new TypeReference<List<Map<String, Object>>>() {});
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

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
	public void srvyQstnDelete(SrvyQstnVO vo) {
		// 설문문항삭제
		srvyQstnService.srvyQstnDelete(vo);
	}

	@Override
	public SrvyMainView getSrvyQstn(SrvyQstnVO vo) {
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
	public void srvySeqnoModify(SrvypprVO vo) {
		// 설문지순번수정
		srvypprService.srvySeqnoModify(vo);
	}

	@Override
	public void qstnSeqnoModify(SrvyQstnVO vo) {
		// 문항순번수정
		srvyQstnService.qstnSeqnoModify(vo);
	}

	@Override
	public void srvyQstnsCmptnModify(SrvyVO vo) {
		// 설문문제출제완료수정
		srvyService.srvyQstnsCmptnModify(vo);
	}

	@Override
	public SrvyMainView loadProfSrvyEvlMngView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문정보조회
		srvyMainView.setEgovMap(srvyService.srvySelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyPtcpList(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문참여목록조회
		srvyMainView.setEgovList(srvyPtcpService.srvyPtcpList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvypprEvlPopup(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 설문정보조회
		SrvyVO srvy = new SrvyVO();
		srvy.setSrvyId((String) params.get("upSrvyId"));
		eMap.put("srvyVO", srvyService.srvySelect(srvy));

		// 설문참여자조회
		eMap.put("ptcpnt", srvyPtcpService.srvyPtcpntSelect((String) params.get("srvyId"), (String) params.get("userId")));
		srvyMainView.seteMap(eMap);

		// 설문참여목록조회
		String userId = (String) params.get("userId");
		String srvyId = (String) params.get("srvyId");
        params.remove("userId");
        params.put("srvyId", params.get("upSrvyId"));
		srvyMainView.setEgovList(srvyPtcpService.srvyPtcpList(params));
		params.put("userId", userId);
		params.put("srvyId", srvyId);

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList((String) params.get("srvyId"), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList((String) params.get("srvyId"), ""));

     	// 설문보기항목일괄조회
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList((String) params.get("srvyId"), "", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList((String) params.get("srvyId"), ""));

        // 설문답변목록
        srvyMainView.setSrvyRspnsList(srvyRspnsService.srvyRspnsList((String) params.get("srvyPtcpId"), (String) params.get("srvyId"), (String) params.get("userId")));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadProfSrvyMemoPopup(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 설문정보조회
		SrvyVO srvy = new SrvyVO();
		srvy.setSrvyId((String) params.get("srvyId"));
		eMap.put("srvyVO", srvyService.srvySelect(srvy));

		// 설문참여자조회
		eMap.put("ptcpnt", srvyPtcpService.srvyPtcpntSelect((String) params.get("srvyId"), (String) params.get("userId")));

		// 교수메모조회
		eMap.put("profMemo", srvyPtcpService.profMemoSelect((String) params.get("srvyPtcpId"), (String) params.get("userId")));
		srvyMainView.seteMap(eMap);

		return srvyMainView;
	}

	@Override
	public void profMemoModify(Map<String, Object> params) {
		// 교수메모수정
		srvyPtcpService.profMemoModify(params);
	}

	@Override
	public void profSrvyEvlScrBulkModify(List<Map<String, Object>> list) {
		// 교수설문평가점수일괄수정
		srvyPtcpService.profSrvyEvlScrBulkModify(list);
	}

	@Override
	public SrvyMainView loadSrvyPtcpStatusPopup(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		String upSrvyId = vo.getUpSrvyId() != null ? vo.getUpSrvyId() : vo.getSrvyId();
		String srvyId = vo.getSrvyId();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 설문조회
		vo.setSrvyId(upSrvyId);
        EgovMap srvyMap = srvyService.srvySelect(vo);
        srvyId = vo.getUpSrvyId() != null ? srvyId : (String) srvyMap.get("subSrvyId");
        srvyMap.put("subSrvyId", srvyId);
        eMap.put("srvyVO", srvyMap);

        // 팀 설문
        if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
            // 설문팀목록조회
        	srvyMainView.setEgovList(srvyService.srvyTeamList(upSrvyId));
        }

        try {
        	Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();

            // 접속기기유형코드 목록 조회
            List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "CNTN_DVC_TYCD").getReturnList();
            qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
            cmmnCdList.put("cntnDvcTycd", qstnDfctlvTycdList);

            srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        // 설문참여장치별현황목록
        egovListMap.put("ptcpDvcList", srvyPtcpService.srvyPtcpDvcStatusList(srvyId, vo.getSbjctId()));

        // 설문참여수조회
        eMap.put("ptcpCnt", srvyPtcpService.srvyPtcpCntSelect(srvyId, vo.getSbjctId()));

        // 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(srvyId, ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(srvyId, ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(srvyId, "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(srvyId, ""));

        // 설문선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.srvyChcQstnRspnsStatusList(vo.getSbjctId(), srvyId, ""));

        // 설문서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.srvyTextQstnRspnsStatusList(vo.getSbjctId(), srvyId, ""));

        // 설문레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.srvyLevelQstnRspnsStatusList(vo.getSbjctId(), srvyId, ""));

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
        srvyMainView.setEgovListMap(egovListMap);
        srvyMainView.seteMap(eMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyPtcpStatusExcelDownList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		EgovMap srvyMap = srvyService.srvySelect(vo);
		srvyMainView.setEgovMap(srvyMap);

		// 팀 설문
		if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
		    // 설문팀목록조회
			srvyMainView.setEgovList(srvyService.srvyTeamList(vo.getSrvyId()));
		}

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), "EXCEL"));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), "EXCEL"));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getSrvyId(), "LEVEL", "EXCEL"));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getSrvyId(), "EXCEL"));

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        // 설문선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.srvyChcQstnRspnsStatusList(vo.getSbjctId(), vo.getSrvyId(), "EXCEL"));

        // 설문서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.srvyTextQstnRspnsStatusList(vo.getSbjctId(), vo.getSrvyId(), "EXCEL"));

        // 설문레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.srvyLevelQstnRspnsStatusList(vo.getSbjctId(), vo.getSrvyId(), "EXCEL"));
        srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyRspnsStatusExcelDownList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		EgovMap srvyMap = srvyService.srvySelect(vo);
		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		// 팀 설문
		if("SRVY_TEAM".equals(srvyMap.get("srvyGbn"))) {
			// 설문팀목록조회
			egovListMap.put("teamList", srvyService.srvyTeamList(vo.getSrvyId()));
		}
		srvyMainView.setEgovMap(srvyMap);

		// 설문엑셀다운문항목록조회
		egovListMap.put("qstnList", srvyRspnsService.srvyExcelDownQstnList(vo.getSrvyId()));

		// 설문엑셀다운문항답변목록조회
		egovListMap.put("rspnsList", srvyRspnsService.srvyExcelDownQstnRspnsList(vo.getSrvyId()));
		srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyQstnDistributionChart(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문문항답변분포목록
		srvyMainView.setEgovList(srvyRspnsService.srvyQstnRspnsDistributionList((String) params.get("sbjctId"), (String) params.get("srvyId"), (String) params.get("srvypprId"), (String) params.get("srvyQstnId")));

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
	public SrvyMainView loadProfSrvypprPrintPopup(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문참여자조회
		srvyMainView.setEgovMap(srvyPtcpService.srvyPtcpntSelect((String) params.get("srvyId"), (String) params.get("userId")));

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList((String) params.get("srvyId"), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList((String) params.get("srvyId"), ""));

     	// 설문보기항목일괄조회
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList((String) params.get("srvyId"), "", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList((String) params.get("srvyId"), ""));

        // 설문답변목록
        srvyMainView.setSrvyRspnsList(srvyRspnsService.srvyRspnsList((String) params.get("srvyPtcpId"), (String) params.get("srvyId"), (String) params.get("userId")));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadSrvyEzgraderPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문조회
		srvyMainView.setEgovMap(srvyService.srvySelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyPtcpListByEzGrader(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문참여목록조회 ( Ez-Grader )
		srvyMainView.setEgovList(srvyPtcpService.srvyPtcpListByEzGrader(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getProfSrvyRspnsListByEzGrader(SrvyPtcpVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), ""));

     	// 설문보기항목일괄조회
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getSrvyId(), "", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getSrvyId(), ""));

		// 설문답변목록
        srvyMainView.setSrvyRspnsList(srvyRspnsService.srvyRspnsList(vo.getSrvyPtcpId(), vo.getSrvyId(), vo.getUserId()));

		return srvyMainView;
	}

	@Override
	public void srvyScrExcelUpload(SrvyPtcpVO vo) {
		// 설문성적엑셀업로드
		srvyPtcpService.srvyScrExcelUpload(vo);
	}

	@Override
	public SrvyMainView getSrvyQstnExcelSampleData(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문문항엑셀샘플데이터
		srvyMainView.setSrvyQstnSampleMap(srvyQstnService.srvyQstnExcelSampleData(vo));

		return srvyMainView;
	}

	@Override
	public ResultDTO<SrvyVO> srvyQstnExcelUpload(SrvyVO vo) {
		// 설문문항엑셀업로드
		return srvyQstnService.srvyQstnExcelUpload(vo);
	}

	@Override
	public void profMemoBulkModify(List<Map<String, Object>> list) {
		srvyPtcpService.profMemoBulkModify(list);
	}

	@Override
	public SrvyMainView getStdntSrvyList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생설문목록조회
		srvyMainView.setResultDTO(srvyService.stdntSrvyListPaging(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadStdntSrvyInfoView(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생설문조회
		vo.setUserId(userCtx.getUserId());
		srvyMainView.setEgovMap(srvyService.stdntSrvySelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadSrvyPtcpPopup(SrvyVO srvy, SrvyPtcpVO ptcp, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생설문조회
		srvy.setUserId(userCtx.getUserId());
		srvyMainView.setEgovMap(srvyService.stdntSrvySelect(srvy));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("srvyId", srvy.getSrvyId());
		map.put("sbjctId", srvy.getSbjctId());
		map.put("userId", userCtx.getUserId());
		map.put("cntnIp", StringUtil.nvl(userCtx.getIP(), "0:0:0:0:0:0:0:1"));
		map.put("srvyPtcpId", ptcp.getSrvyPtcpId());
		map.put("cntnDvcTycd", ptcp.getCntnDvcTycd());
		map.put("rgtrId", userCtx.getUserId());

		// 학생설문참여
		srvyMainView.setResultDTO(srvyPtcpService.stdntSrvyPtcp(map));

		return srvyMainView;
	}

	@Override
	public void srvypprSbmsn(Map<String, Object> params) {
		// 설문지제출
		srvyPtcpService.srvypprSbmsn(params);
	}

	@Override
	public SrvyMainView getSrvyPtcpHstryList(SrvyPtcpHstryVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문참여이력목록조회
		srvyMainView.setEgovList(srvyPtcpHstryService.srvyPtcpHstryList(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlListView() {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvyLctrEvlList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 관리자설문강의평가목록조회
		srvyMainView.setResultDTO(srvyService.admSrvyLctrEvlListPaging(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlRegistView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlModifyView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		// 설문강의평가등록과목목록조회
		srvyMainView.setEgovList(srvyService.srvyLctrEvlRegistSbjctList(vo));

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		egovMap.put("vo", srvyService.srvyLctrEvlSelect(vo));			// 설문강의평가정보조회
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyLctrEvlNRegistSbjctList(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가미등록과목목록조회
		srvyMainView.setEgovList(srvyService.srvyLctrEvlNRegistSbjctList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView srvyLctrEvlRegist(SrvyVO vo, Map<String, String> subMap) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 강의평가등록
		srvyMainView.setSrvyVO(srvyService.srvyLctrEvlRegist(vo, subMap));

		return srvyMainView;
	}

	@Override
	public SrvyMainView srvyLctrEvlModify(SrvyVO vo, Map<String, String> subMap) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 강의평가수정
		srvyMainView.setSrvyVO(srvyService.srvyLctrEvlModify(vo, subMap));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlInfoView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가정보조회
		srvyMainView.setEgovMap(srvyService.srvyLctrEvlSelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyLctrEvlRegistSbjctList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가등록과목목록조회
		srvyMainView.setEgovList(srvyService.srvyLctrEvlRegistSbjctList(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmBfrSrvyLctrEvlCopyPopup() {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmRegistSrvyLctrEvlList(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 가져오기설문강의평가목록
		srvyMainView.setEgovList(srvyService.copySrvyLctrEvlList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyLctrEvlSelect(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가정보조회
		srvyMainView.setEgovMap(srvyService.srvyLctrEvlSelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlQstnMngView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가정보조회
		srvyMainView.setEgovMap(srvyService.srvyLctrEvlSelect(vo));

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
	        // 문항답변유형코드 목록 조회
	        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(srvyMainView.getEgovMap().get("orgId").toString(), "QSTN_RSPNS_TYCD").getReturnList();
	        qstnRspnsTycdList.removeIf(item -> "QUIZ".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

	        // 문항난이도유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(srvyMainView.getEgovMap().get("orgId").toString(), "QSTN_DFCTLV_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

	        srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlQstnCopyPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlMngPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

        // 설문정보조회
		srvyMainView.setEgovMap(srvyService.srvyLctrEvlSelect(vo));

        return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLtclEvlRsltListView() {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyLctrEvlRsltMngView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		egovMap.put("vo", srvyService.srvyLctrEvlSelect(vo));			// 설문강의평가조회
		srvyMainView.setEgovMap(egovMap);

        return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvyLctrEvlRsltList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 관리자설문강의평가결과목록조회
		srvyMainView.setResultDTO(srvyService.admSrvyLctrEvlRsltList(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvyLctrEvlPtcpStatus(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		String srvyId = params.get("srvyId").toString();

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();

	        // 접속기기유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(params.get("orgId").toString(), "CNTN_DVC_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("cntnDvcTycd", qstnDfctlvTycdList);

	        srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        // 강의평가참여장치별현황목록
        egovListMap.put("ptcpDvcList", srvyPtcpService.lctrEvlPtcpDvcStatusList(params));

        // 강의평가참여수조회
        srvyMainView.setEgovMap(srvyPtcpService.lctrEvlPtcpCntSelect(params));

        // 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(srvyId, ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(srvyId, ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(srvyId, "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(srvyId, ""));

        // 강의평가선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.lctrEvlChcQstnRspnsStatusList(params));

        // 강의평가서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.lctrEvlTextQstnRspnsStatusList(params));

        // 강의평가레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.lctrEvlLevelQstnRspnsStatusList(params));

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
        srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getLctrEvlRspnsStatusExcelDownList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가조회
		EgovMap srvyMap = srvyService.srvyLctrEvlSelect(vo);
		srvyMainView.setEgovMap(srvyMap);

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		// 설문엑셀다운문항목록조회
		egovListMap.put("qstnList", srvyRspnsService.srvyExcelDownQstnList(vo.getSrvyId()));

		// 설문강의평가엑셀다운문항답변목록
		egovListMap.put("rspnsList", srvyRspnsService.srvylctrEvlExcelDownQstnRspnsList(vo.getSrvyId()));
		srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getLctrEvlPtcpStatusExcelDownList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가조회
		EgovMap srvyMap = srvyService.srvyLctrEvlSelect(vo);
		srvyMainView.setEgovMap(srvyMap);

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getSrvyId(), "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getSrvyId(), ""));

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("srvyId", vo.getSrvyId());
        // 강의평가선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.lctrEvlChcQstnRspnsStatusList(params));

        // 강의평가서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.lctrEvlTextQstnRspnsStatusList(params));

        // 강의평가레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.lctrEvlLevelQstnRspnsStatusList(params));
        // 설문선택형문항답변현황목록
        srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyListView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvyList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 관리자전체설문목록조회
		srvyMainView.setResultDTO(srvyService.admSrvyListPaging(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyRegistView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView admSrvyRegist(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문등록
		srvyMainView.setSrvyVO(srvyService.admSrvyRegist(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyModifyView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		egovMap.put("vo", srvyService.admSrvySelect(vo));				// 관리자전체설문조회
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView admSrvyModify(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문수정
		srvyMainView.setSrvyVO(srvyService.admSrvyModify(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyInfoView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문조회
		srvyMainView.setEgovMap(srvyService.admSrvySelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmBfrSrvyCopyPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmRegistSrvyList(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 가져오기전체설문목록
		srvyMainView.setEgovList(srvyService.copySrvyList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvySelect(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문조회
		srvyMainView.setEgovMap(srvyService.admSrvySelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyQstnMngView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문조회
		srvyMainView.setEgovMap(srvyService.admSrvySelect(vo));

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
	        // 문항답변유형코드 목록 조회
	        List<CmmnCdVO> qstnRspnsTycdList = cmmnCdService.listCode(srvyMainView.getEgovMap().get("orgId").toString(), "QSTN_RSPNS_TYCD").getReturnList();
	        qstnRspnsTycdList.removeIf(item -> "QUIZ".equals(item.getGrpcd()) || item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnRspnsTycd", qstnRspnsTycdList);

	        // 문항난이도유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(srvyMainView.getEgovMap().get("orgId").toString(), "QSTN_DFCTLV_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("qstnDfctlvTycd", qstnDfctlvTycdList);

	        srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyQstnCopyPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSrvyRsltMngView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		egovMap.put("vo", srvyService.admSrvySelect(vo));				// 전체설문조회
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvyRsltList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 관리자전체설문결과목록조회
		srvyMainView.setResultDTO(srvyService.admSrvyRsltList(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getRspnsStatusExcelDownList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문조회
		EgovMap srvyMap = srvyService.admSrvySelect(vo);
		srvyMainView.setEgovMap(srvyMap);

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		// 설문엑셀다운문항목록조회
		egovListMap.put("qstnList", srvyRspnsService.srvyExcelDownQstnList(vo.getSrvyId()));

		// 설문엑셀다운문항답변목록조회
		egovListMap.put("rspnsList", srvyRspnsService.srvyExcelDownQstnRspnsList(vo.getSrvyId()));
		srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getPtcpStatusExcelDownList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 전체설문조회
		EgovMap srvyMap = srvyService.admSrvySelect(vo);
		srvyMainView.setEgovMap(srvyMap);

		// 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getSrvyId(), "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getSrvyId(), ""));

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("srvyId", vo.getSrvyId());
        // 강의평가선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.lctrEvlChcQstnRspnsStatusList(params));

        // 강의평가서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.lctrEvlTextQstnRspnsStatusList(params));

        // 강의평가레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.lctrEvlLevelQstnRspnsStatusList(params));
        // 설문선택형문항답변현황목록
        srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getAdmSrvyPtcpStatus(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		String srvyId = params.get("srvyId").toString();

		try {
			Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();

	        // 접속기기유형코드 목록 조회
	        List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(params.get("orgId").toString(), "CNTN_DVC_TYCD").getReturnList();
	        qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
	        cmmnCdList.put("cntnDvcTycd", qstnDfctlvTycdList);

	        srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        // 전체설문참여장치별현황목록
        egovListMap.put("ptcpDvcList", srvyPtcpService.wholSrvyPtcpDvcStatusList(params));

        // 전체설문참여수조회
        srvyMainView.setEgovMap(srvyPtcpService.wholSrvyPtcpCntSelect(params));

        // 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(srvyId, ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(srvyId, ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(srvyId, "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(srvyId, ""));

        // 전체설문선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.wholSrvyChcQstnRspnsStatusList(params));

        // 전체설문서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.wholSrvyTextQstnRspnsStatusList(params));

        // 전체설문레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.wholSrvyLevelQstnRspnsStatusList(params));

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
        srvyMainView.setEgovListMap(egovListMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadStdntMainSrvyLctrEvlListView() {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getStdntMainSrvyLctrEvlList(Map<String, Object> params) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생대시보드설문강의평가목록조회
		srvyMainView.setEgovList(srvyService.stdntMainSrvyLctrEvlList(params));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadSrvyPtcpInfoPopup(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가정보조회
		srvyMainView.setEgovMap(srvyService.srvyLctrEvlSelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadSrvyLctrEvlPtcpPopup(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생설문강의평가조회
		vo.setUserId(userCtx.getUserId());
		srvyMainView.setEgovMap(srvyService.stdntSrvyLctrEvlSelect(vo));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("srvyId", vo.getSrvyId());
		map.put("upSrvyId", vo.getUpSrvyId());
		map.put("userId", userCtx.getUserId());
		map.put("cntnIp", StringUtil.nvl(userCtx.getIP(), "0:0:0:0:0:0:0:1"));
		map.put("srvyPtcpId", srvyMainView.getEgovMap().get("srvyPtcpId"));
		map.put("cntnDvcTycd", vo.getSubParam());
		map.put("type", "LCTR");

		map.put("rgtrId", userCtx.getUserId());

		// 학생설문참여
		srvyMainView.setResultDTO(srvyPtcpService.stdntSrvyPtcp(map));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadSrvyLctrEvlPtcpStatusPopup(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 학생설문강의평가조회
		vo.setUserId(userCtx.getUserId());
        eMap.put("srvyVO", srvyService.stdntSrvyLctrEvlSelect(vo));

        try {
        	Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();

            // 접속기기유형코드 목록 조회
            List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "CNTN_DVC_TYCD").getReturnList();
            qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
            cmmnCdList.put("cntnDvcTycd", qstnDfctlvTycdList);

            srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        // 설문참여장치별현황목록
        egovListMap.put("ptcpDvcList", srvyPtcpService.srvyPtcpDvcStatusList(vo.getSrvyId(), eMap.get("srvyVO").get("sbjctId").toString()));

        // 학생강의평가참여수조회
        eMap.put("ptcpCnt", srvyPtcpService.stdntLctrEvlPtcpCntSelect(vo.getSrvyId(), vo.getSbjctId()));

        // 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getUpSrvyId(), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getUpSrvyId(), ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getUpSrvyId(), "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getUpSrvyId(), ""));

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("srvyId", vo.getUpSrvyId());
        map.put("sbjctId", eMap.get("srvyVO").get("sbjctId"));
        // 강의평가선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.lctrEvlChcQstnRspnsStatusList(map));

        // 강의평가서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.lctrEvlTextQstnRspnsStatusList(map));

        // 강의평가레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.lctrEvlLevelQstnRspnsStatusList(map));

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
        srvyMainView.setEgovListMap(egovListMap);
        srvyMainView.seteMap(eMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadStdntWholSrvyListView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getTrgtWholSrvyList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 대상전체설문목록조회
		srvyMainView.setResultDTO(srvyService.trgtWholSrvyListPaging(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadWholSrvyPtcpPopup(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 대상전체설문조회
		vo.setUserId(userCtx.getUserId());
		srvyMainView.setEgovMap(srvyService.trgtWholSrvySelect(vo));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("srvyId", vo.getSrvyId());
		map.put("userId", userCtx.getUserId());
		map.put("cntnIp", StringUtil.nvl(userCtx.getIP(), "0:0:0:0:0:0:0:1"));
		map.put("cntnDvcTycd", vo.getSubParam());
		map.put("userTycd", userCtx.getUserTycd());
		map.put("rgtrId", userCtx.getUserId());

		// 대상전체설문참여
		srvyMainView.setResultDTO(srvyPtcpService.trgtWholSrvyPtcp(map));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadWholSrvyPtcpStatusPopup(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 대상전체설문조회
		vo.setUserId(userCtx.getUserId());
        eMap.put("srvyVO", srvyService.trgtWholSrvySelect(vo));

        try {
        	Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();

            // 접속기기유형코드 목록 조회
            List<CmmnCdVO> qstnDfctlvTycdList = cmmnCdService.listCode(userCtx.getOrgId(), "CNTN_DVC_TYCD").getReturnList();
            qstnDfctlvTycdList.removeIf(item -> item.getCdSeqno() == 0);
            cmmnCdList.put("cntnDvcTycd", qstnDfctlvTycdList);

            srvyMainView.setCmmnCdList(cmmnCdList);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

        Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("srvyId", vo.getSrvyId());
        params.put("orgId", userCtx.getOrgId());
        // 전체설문참여장치별현황목록
        egovListMap.put("ptcpDvcList", srvyPtcpService.wholSrvyPtcpDvcStatusList(params));

        // 전체설문참여수조회
        eMap.put("ptcpCnt", srvyPtcpService.wholSrvyPtcpCntSelect(params));

        // 설문지 목록 조회
     	srvyMainView.setSrvypprList(srvypprService.srvypprList(vo.getSrvyId(), ""));

     	// 설문문항 목록 조회
     	srvyMainView.setSrvyQstnList(srvyQstnService.srvyQstnList(vo.getSrvyId(), ""));

     	// 설문보기항목일괄조회(레벨형)
     	srvyMainView.setSrvyVwitmList(srvyVwitmService.srvyVwitmBulkList(vo.getSrvyId(), "LEVEL", ""));

     	// 설문문항보기항목레벨일괄조회
        srvyMainView.setSrvyQstnVwitmLvlList(srvyQstnVwitmLvlService.srvyQstnVwitmLvlBulkList(vo.getSrvyId(), ""));

        // 전체설문선택형문항답변현황목록
        egovListMap.put("chcRspnsList", srvyRspnsService.wholSrvyChcQstnRspnsStatusList(params));

        // 전체설문서술형문항답변현황목록
        egovListMap.put("textRspnsList", srvyRspnsService.wholSrvyTextQstnRspnsStatusList(params));

        // 전체설문레벨형문항답변현황목록
        egovListMap.put("levelRspnsList", srvyRspnsService.wholSrvyLevelQstnRspnsStatusList(params));

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
        srvyMainView.setEgovListMap(egovListMap);
        srvyMainView.seteMap(eMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView getStdntSrvyLctrEvlList(SrvyPageInfo pageInfo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생설문강의평가목록페이징
		srvyMainView.setResultDTO(srvyService.stdntSrvyLctrEvlListPaging(pageInfo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadStdntLectSrvyLctrEvlInfoView(SrvyVO vo, UserContext userCtx) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 학생설문조회
		vo.setUserId(userCtx.getUserId());
		srvyMainView.setEgovMap(srvyService.stdntSrvyLctrEvlSelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSbjctSrvyLctrEvlListView() {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSbjctSrvyLctrEvlInfoView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가정보조회
		srvyMainView.setEgovMap(srvyService.srvyLctrEvlSelect(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView getSrvyLctrEvlSbjctPtcpList(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 설문강의평가과목참여목록조회
		srvyMainView.setEgovList(srvyService.srvyLctrEvlSbjctPtcpList(vo));

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSbjctSrvyLtclEvlRsltListView() {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("curYear", DateTimeUtil.getYear());					// 현재학기
		srvyMainView.setEgovMap(egovMap);

		return srvyMainView;
	}

	@Override
	public SrvyMainView loadAdmSbjctSrvyLtclEvlRsltMngView(SrvyVO vo) {
		SrvyMainView srvyMainView = new SrvyMainView();

		// 기관목록조회
		srvyMainView.setOrgList(orgService.orgListSelect());

		EgovMap egovMap = new EgovMap();
		egovMap.put("yearList", DateTimeUtil.getYearList(10, "mix"));	// 연도목록
		egovMap.put("vo", srvyService.srvyLctrEvlSelect(vo));			// 설문강의평가조회
		srvyMainView.setEgovMap(egovMap);

        return srvyMainView;
	}

}
