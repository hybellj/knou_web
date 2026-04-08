package knou.lms.smnr.facade;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.exam.service.ExamService;
import knou.lms.smnr.service.SmnrAtndService;
import knou.lms.smnr.service.SmnrService;
import knou.lms.smnr.service.SmnrTeamService;
import knou.lms.smnr.service.SmnrTrgtrService;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrMainView;
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

	@Resource(name="examService")
	private ExamService examService;

	@Resource(name="subjectService")
	private SubjectService subjectService;

	@Override
	public SmnrMainView getProfSmnrList(SmnrVO vo) throws Exception {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 교수세미나목록조회
		smnrMainView.setProfSmnrList(smnrService.profSmnrListPaging(vo));

		return smnrMainView;
	}

	@Override
	public SmnrMainView loadProfSmnrRegistView(SmnrVO vo) throws Exception {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 과목조회
		smnrMainView.setSubjectVO(subjectService.subjectSelect(vo.getSbjctId()));

		return smnrMainView;
	}

	@Override
	public void smnrRegist(SmnrVO vo, Map<String, String> subMap) throws Exception {
		// 세미나등록
		smnrService.smnrRegist(vo, subMap);
	}

	@Override
	public SmnrMainView loadProfSmnrModifyView(SmnrVO vo) throws Exception {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 세미나정보조회
		smnrMainView.setSmnrEgovMap(smnrService.smnrSelect(vo));

		// 과목조회
		smnrMainView.setSubjectVO(subjectService.subjectSelect(vo.getSbjctId()));

		return smnrMainView;
	}

	@Override
	public void smnrModify(SmnrVO vo, Map<String, String> subMap) throws Exception {
		// 세미나수정
		smnrService.smnrModify(vo, subMap);
	}

	@Override
	public void smnrDelete(SmnrVO vo) throws Exception {
		// 세미나삭제
		smnrService.smnrDelete(vo);
	}

	@Override
	public void smnrMrkRfltrtListModify(List<SmnrVO> list) throws Exception {
		// 세미나성적반영비율목록수정
		smnrService.smnrMrkRfltrtListModify(list);
	}

	@Override
	public void smnrDtlModify(SmnrVO vo) throws Exception {
		// 세미나세부정보수정
		smnrService.smnrDtlModify(vo);
	}

	@Override
	public SmnrMainView getSmnrLrnGrpSubSmnrList(Map<String, Object> params) throws Exception {
		SmnrMainView smnrMainView = new SmnrMainView();

		// 설문학습그룹부과제목록조회
		smnrMainView.setSmnrLrnGrpSubSmnrList(smnrService.smnrLrnGrpSubSmnrList(params));

		return smnrMainView;
	}

}
