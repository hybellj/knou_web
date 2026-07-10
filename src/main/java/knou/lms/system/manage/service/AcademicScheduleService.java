package knou.lms.system.manage.service;

import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.system.manage.vo.AcademicScheduleVO;

public interface AcademicScheduleService {

	ResultDTO<EgovMap> academicScheduleList(PageInfo pageInfo);

	int academicScheduleDelete(String acadSchdlId);

	int academicScheduleRegist(@Valid AcademicScheduleVO vo);

	int academicScheduleModify(@Valid AcademicScheduleVO vo);

	AcademicScheduleVO academicScheduleSelect(AcademicScheduleVO vo);
}