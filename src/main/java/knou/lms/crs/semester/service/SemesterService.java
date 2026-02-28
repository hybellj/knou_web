package knou.lms.crs.semester.service;

import java.util.List;

import knou.lms.crs.semester.vo.SmstrChrtVO;

public interface SemesterService {

	/**
	 * 현재 학기기수 조회
	 * @param 	SmstrChrtVO
	 * @return	SmstrChrtVO
	 * @throws 	Exception
	 */
	public SmstrChrtVO selectCurrentSemester(SmstrChrtVO vo) throws Exception;
	
	/**
	 * 학기기수조회
	 * @param	subjectId
	 * @return	SmstrChrtVO
	 * @throws	Exception
	 * @author	jinkoon
	 */
	public SmstrChrtVO smstrChrtSelect(String subjectId) throws Exception;
	
	/**
	 * 개설된 학기기수 목록 조회(학위연도 기준)
	 * @param smstrChrtVO
	 * @return
	 * @throws Exception
	 */
	public List<SmstrChrtVO> listSmstrChrtByDgrsYr(SmstrChrtVO smstrChrtVO) throws Exception;
}