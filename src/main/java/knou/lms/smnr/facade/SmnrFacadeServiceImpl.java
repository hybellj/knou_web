package knou.lms.smnr.facade;

import java.util.ArrayList;
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
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.exam.service.ExamService;
import knou.lms.smnr.pltfrm.zoom.api.meetings.vo.ZoomPastMeetingVO;
import knou.lms.smnr.pltfrm.zoom.service.ZoomApiService;
import knou.lms.smnr.service.SmnrAtndHstryService;
import knou.lms.smnr.service.SmnrAtndService;
import knou.lms.smnr.service.SmnrFdbkService;
import knou.lms.smnr.service.SmnrService;
import knou.lms.smnr.service.SmnrTeamService;
import knou.lms.smnr.service.SmnrTrgtrService;
import knou.lms.smnr.vo.SmnrAtndHstryVO;
import knou.lms.smnr.vo.SmnrAtndVO;
import knou.lms.smnr.vo.SmnrFdbkVO;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrMainView;
import knou.lms.smnr.web.view.SmnrPageInfo;
import knou.lms.subject.service.SubjectService;

@Service("smnrFacadeService")
public class SmnrFacadeServiceImpl extends ServiceBase implements SmnrFacadeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SmnrFacadeServiceImpl.class);

	@Resource(name="smnrService")
	private SmnrService smnrService;

	@Resource(name="smnrAtndService")
	private SmnrAtndService smnrAtndService;

	@Resource(name="smnrTeamService")
	private SmnrTeamService smnrTeamService;

	@Resource(name="smnrTrgtrService")
	private SmnrTrgtrService smnrTrgtrService;

	@Resource(name="smnrFdbkService")
	private SmnrFdbkService smnrFdbkService;

	@Resource(name="examService")
	private ExamService examService;

	@Resource(name="subjectService")
	private SubjectService subjectService;

	@Resource(name="cmmnCdService")
	private CmmnCdService cmmnCdService;

	@Resource(name="smnrAtndHstryService")
	private SmnrAtndHstryService smnrAtndHstryService;

	@Resource(name="zoomApiService2")
	private ZoomApiService zoomApiService;

	@Override
	public SmnrMainView getProfSmnrList(SmnrPageInfo pageInfo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 교수세미나목록조회
		smnrMainView.setResultDTO(smnrService.profSmnrListPaging(pageInfo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView loadProfSmnrRegistView(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		SubjectDTO sbjctDto = new SubjectDTO(vo.getSbjctId());
		// 과목조회
		smnrMainView.setSubjectVO(subjectService.subjectSelect(sbjctDto));

		// 강의주차목록조회
		smnrMainView.setEgovList(examService.lctrWknoList(vo.getSbjctId()));

		return smnrMainView;
	}

	@Override
	public void smnrRegist(SmnrVO vo, Map<String, String> subMap) {
		// 세미나등록
		smnrService.smnrRegist(vo, subMap);
	}

	@Override
	public SmnrMainView loadProfSmnrModifyView(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		SubjectDTO sbjctDto = new SubjectDTO(vo.getSbjctId());

		// 세미나정보조회
		smnrMainView.setEgovMap(smnrService.smnrSelect(vo));

		// 과목조회
		smnrMainView.setSubjectVO(subjectService.subjectSelect(sbjctDto));

		// 강의주차목록조회
		smnrMainView.setEgovList(examService.lctrWknoList(vo.getSbjctId()));

		return smnrMainView;
	}

	@Override
	public void smnrModify(SmnrVO vo, Map<String, String> subMap) {
		// 세미나수정
		smnrService.smnrModify(vo, subMap);
	}

	@Override
	public void smnrDelete(SmnrVO vo) {
		// 세미나삭제
		smnrService.smnrDelete(vo);
	}

	@Override
	public void smnrMrkRfltrtListModify(List<SmnrVO> list) {
		// 세미나성적반영비율목록수정
		smnrService.smnrMrkRfltrtListModify(list);
	}

	@Override
	public void smnrDtlModify(SmnrVO vo) {
		// 세미나세부정보수정
		smnrService.smnrDtlModify(vo);
	}

	@Override
	public SmnrMainView getSmnrTeamGrpSubSmnrList(Map<String, Object> params) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 설문팀그룹부과제목록조회
		smnrMainView.setEgovList(smnrService.smnrTeamGrpSubSmnrList(params));

		return smnrMainView;
	}

	@Override
	public SmnrMainView loadProfSmnrEvlMngView(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나정보조회
		smnrMainView.setEgovMap(smnrService.smnrSelect(vo));

		Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 세미나구분코드 목록 조회
		List<CmmnCdVO> smnrGbncdList = null;
		try {
			smnrGbncdList = cmmnCdService.listCode(vo.getOrgId(), "SMNR_GBNCD").getReturnList();
		} catch(Exception e) {
			e.printStackTrace();
		}
        smnrGbncdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("smnrGbncd", smnrGbncdList);

        smnrMainView.setCmmnCdList(cmmnCdList);

		return smnrMainView;
	}

	@Override
	public SmnrMainView getSmnrAtndList(Map<String, Object> params) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나참석목록조회
		smnrMainView.setEgovList(smnrAtndService.smnrAtndList(params));

		return smnrMainView;
	}

	@Override
	public void profSmnrEvlScrBulkModify(List<Map<String, Object>> list) {
		// 교수세미나평가점수일괄수정
		smnrAtndService.profSmnrEvlScrBulkModify(list);
	}

	@Override
	public void smnrScrExcelUpload(SmnrAtndVO vo) {
		// 세미나성적엑셀업로드
		smnrAtndService.smnrScrExcelUpload(vo);
	}

	@Override
	public SmnrMainView loadProfSmnrAtndHstryListPopup(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나정보조회
		smnrMainView.setEgovMap(smnrService.smnrSelect(vo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView getSmnrAtndHstryList(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나참석이력목록
		smnrMainView.setEgovList(smnrAtndHstryService.smnrAtndHstryList(vo));

		return smnrMainView;
	}

	@Override
	public void profSmnrAtndBulkModify(List<Map<String, Object>> list) {
		// 세미나참석일괄수정
		smnrAtndService.smnrAtndBulkModify(list);
	}

	@Override
	public SmnrMainView loadProfSmnrAtndMngPopup(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 세미나정보조회
		eMap.put("vo", smnrService.smnrSelect(vo));

		// 세미나참석자조회
		eMap.put("atndVO", smnrAtndService.smnrAtndeSelect(vo));
		smnrMainView.seteMap(eMap);

		// 온라인세미나
		if("ONLN_SMNR".equals(eMap.get("vo").get("smnrGbncd"))) {
			// 회의진행시간조회
			smnrMainView.setZoomPastMeetingVO((ZoomPastMeetingVO) zoomApiService.zoomPastMeetingSelect(vo).getData());
		}

		return smnrMainView;
	}

	@Override
	public SmnrMainView getSmnrAtndSelect(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나참석조회
		smnrMainView.setSmnrAtndVO(smnrAtndService.smnrAtndSelect(vo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView getUserSmnrAtndHstryList(SmnrAtndHstryVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 사용자세미나참석이력목록
		smnrMainView.setEgovList(smnrAtndHstryService.userSmnrAtndHstryList(vo));

		return smnrMainView;
	}

	@Override
	public void profSmnrAtndModify(SmnrAtndVO vo) {
		Map<String, Object> map = new HashMap<>();
		if(!"".equals(vo.getSmnrAtndId())) map.put("smnrAtndId", vo.getSmnrAtndId());
		map.put("smnrId", vo.getSmnrId());
		map.put("userId", vo.getAtndeId());
		map.put("atndStscd", vo.getAtndStscd());
		map.put("rgtrId", vo.getRgtrId());
		List<Map<String, Object>> list = new ArrayList<>();
		list.add(map);

		// 세미나참석일괄수정
		smnrAtndService.smnrAtndBulkModify(list);
	}

	@Override
	public void profSmnrAtndMemoModify(SmnrAtndVO vo) {
		Map<String, Object> map = new HashMap<>();
		if(!"".equals(vo.getSmnrAtndId())) map.put("smnrAtndId", vo.getSmnrAtndId());
		map.put("smnrId", vo.getSmnrId());
		map.put("userId", vo.getAtndeId());
		map.put("atndMemo", vo.getAtndMemo());
		map.put("rgtrId", vo.getRgtrId());
		List<Map<String, Object>> list = new ArrayList<>();
		list.add(map);

		// 세미나참석메모일괄수정
		smnrAtndService.smnrAtndMemoBulkModify(list);
	}

	@Override
	public void smnrFdbkRegist(SmnrFdbkVO vo, String fdbkUsersStr) {
		// 세미나피드백등록
		smnrFdbkService.smnrFdbkRegist(vo, fdbkUsersStr);
	}

	@Override
	public SmnrMainView loadProfSmnrFdbkPopup(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		Map<String, EgovMap> eMap = new HashMap<String, EgovMap>();
		// 세미나정보조회
		eMap.put("vo", smnrService.smnrSelect(vo));

		// 세미나참석자조회
		eMap.put("atndVO", smnrAtndService.smnrAtndeSelect(vo));
		smnrMainView.seteMap(eMap);

		return smnrMainView;
	}

	@Override
	public SmnrMainView getSmnrFdbkList(SmnrFdbkVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나피드백목록
		smnrMainView.setSmnrFdbkList(smnrFdbkService.smnrFdbkList(vo));

		return smnrMainView;
	}

	@Override
	public void smnrFdbkModify(SmnrFdbkVO vo) {
		// 세미나피드백수정
		smnrFdbkService.smnrFdbkModify(vo);
	}

	@Override
	public SmnrMainView getSmnrFdbk(SmnrFdbkVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나피드백조회
		smnrMainView.setSmnrFdbkVO(smnrFdbkService.smnrFdbkSelect(vo));

		return smnrMainView;
	}

	@Override
	public void smnrFdbkDelete(SmnrFdbkVO vo) {
		// 세미나피드백삭제
		smnrFdbkService.smnrFdbkDelete(vo);
	}

	@Override
	public SmnrMainView loadSmnrEzgraderPopup(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나정보조회
		smnrMainView.setEgovMap(smnrService.smnrSelect(vo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView getSmnrAtndListByEzGrader(SmnrVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나참석목록조회 ( Ez-Grader )
		smnrMainView.setEgovList(smnrAtndService.smnrAtndListByEzGrader(vo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView getProfSmnrAtndHstryListByEzGrader(Map<String, Object> params, UserContext userCtx) {
		SmnrMainView smnrMainView = new SmnrMainView();

		Map<String, List<EgovMap>> egovListMap = new HashMap<String, List<EgovMap>>();
		// 대상자세미나참석목록조회 ( Ez-Grader )
		List<EgovMap> trgtrList = smnrAtndService.trgtrSmnrAtndListByEzGrader(params);

		// 온라인세미나
		if("ONLN_SMNR".equals(trgtrList.get(0).get("smnrGbncd"))) {
			// 회의진행시간조회
			SmnrVO smnr = new SmnrVO();
			smnr.setSmnrId(trgtrList.get(0).get("upSmnrId").toString());
			smnr.setOrgId(userCtx.getOrgId());
			smnr.setRgtrId(userCtx.getUserId());
			smnrMainView.setZoomPastMeetingVO((ZoomPastMeetingVO) zoomApiService.zoomPastMeetingSelect(smnr).getData());
		}
		egovListMap.put("trgtrList", trgtrList);

		// 대상자세미나참석이력목록조회 ( Ez-Grader )
		egovListMap.put("hstryList", smnrAtndHstryService.trgtrSmnrAtndHstryListByEzGrader(params));
		smnrMainView.setEgovListMap(egovListMap);

		return smnrMainView;
	}

	@Override
	public void smnrAtndMemoBulkModify(List<Map<String, Object>> list) {
		// 세미나참석메모일괄수정
		smnrAtndService.smnrAtndMemoBulkModify(list);
	}

	@Override
	public void profSmnrFdbkBulkRegist(List<Map<String, Object>> list) {
		// 세미나피드백일괄등록
		smnrFdbkService.smnrFdbkBulkRegist(list);
	}

	@Override
	public SmnrMainView getStdntSmnrList(SmnrPageInfo pageInfo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 학생세미나목록조회
		smnrMainView.setResultDTO(smnrService.stdntSmnrListPaging(pageInfo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView loadStdntSmnrInfoView(SmnrVO vo, UserContext userCtx) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 학생세미나조회
		vo.setUserId(userCtx.getUserId());
		smnrMainView.setEgovMap(smnrService.stdntSmnrSelect(vo));

		Map<String, List<CmmnCdVO>> cmmnCdList = new HashMap<String, List<CmmnCdVO>>();
        // 세미나구분코드 목록 조회
		List<CmmnCdVO> smnrGbncdList = null;
		try {
			smnrGbncdList = cmmnCdService.listCode(vo.getOrgId(), "SMNR_GBNCD").getReturnList();
		} catch(Exception e) {
			e.printStackTrace();
		}
        smnrGbncdList.removeIf(item -> item.getCdSeqno() == 0);
        cmmnCdList.put("smnrGbncd", smnrGbncdList);

        smnrMainView.setCmmnCdList(cmmnCdList);

		return smnrMainView;
	}

	@Override
	public SmnrMainView getSmnrAtndHstryList(SmnrAtndHstryVO vo) {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 사용자세미나참석이력목록
		smnrMainView.setEgovList(smnrAtndHstryService.userSmnrAtndHstryList(vo));

		return smnrMainView;
	}

}
