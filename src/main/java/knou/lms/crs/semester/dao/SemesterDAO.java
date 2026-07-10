package knou.lms.crs.semester.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.crs.semester.vo.SmstrChrtSchdlVO;
import knou.lms.crs.semester.vo.SmstrChrtVO;

@Mapper("semesterDAO")
public interface SemesterDAO {
	
	/**
	 * 개설된 학기기수 목록 조회
	 * @param smstrChrtVO
	 * @return
	 * @throws Exception
	 */
	public List<SmstrChrtVO> listSmstrChrtByDgrsYr(SmstrChrtVO smstrChrtVO);

	/**
	 * 학기기수 일정 주차 목록 조회
	 * @param smstrChrtSchdlVO
	 * @return
	 * @throws Exception
	 */
	public List<SmstrChrtSchdlVO> listSmstrChrtSchdlWkno(SmstrChrtSchdlVO smstrChrtSchdlVO);

	/**
	 * 현재 학기기수 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public SmstrChrtVO selectCurrentSemester(SmstrChrtVO vo) throws Exception;

	
	/**
	 * 학기기수조회
	 * @param	sbjctId
	 * @return	SmstrChrtVO
	 * @throws 	Exception
	 * @author 	jinkoon
	 */
	public SmstrChrtVO smstrChrtSelect(String sbjctId) throws Exception;
}
