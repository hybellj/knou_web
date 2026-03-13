package knou.lms.srvy.facade;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.service.ExamService;
import knou.lms.srvy.service.SrvyService;
import knou.lms.srvy.vo.SrvyVO;
import knou.lms.srvy.web.view.SrvyMainView;

@Service("srvyFacadeService")
public class SrvyFacadeServiceImpl extends ServiceBase implements SrvyFacadeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SrvyFacadeServiceImpl.class);

	@Resource(name="srvyService")
	private SrvyService srvyService;

	@Resource(name="examService")
	private ExamService examService;

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
		return srvyMainView;
	}

}
