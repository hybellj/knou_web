package knou.lms.crs.semester.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.crs.semester.dao.SemesterDAO;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;

@Service("semesterService")
public class SemesterServiceImpl extends ServiceBase implements SemesterService {

	@Resource(name="semesterDAO")
	private SemesterDAO semesterDAO;

	/**
	 * 현재 학기기수 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@Override
	public SmstrChrtVO selectCurrentSemester(SmstrChrtVO vo) throws Exception {
		return semesterDAO.selectCurrentSemester(vo);
	}

	/**
	 * 학기기수조회
	 * @param	subjectId
	 * @return	SmstrChrtVO
	 * @throws	Exception
	 */
	@Override
	public SmstrChrtVO smstrChrtSelect(String subjectId) throws Exception {
		return semesterDAO.smstrChrtSelect(subjectId);
	}
	
	/**
	 * 개설된 학기기수 목록 조회(학위연도 기준)
	 * @param smstrChrtVO
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<SmstrChrtVO> listSmstrChrtByDgrsYr(SmstrChrtVO smstrChrtVO) throws Exception {
		return semesterDAO.listSmstrChrtByDgrsYr(smstrChrtVO);
	}

}
