package knou.lms.system.manage.dao;

import java.util.List;

import javax.validation.Valid;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.system.manage.vo.AcademicScheduleVO;

@Mapper("academicScheduleDAO")
public interface AcademicScheduleDAO {

	int academicScheduleCnt(PageInfo pageInfo);

	List<EgovMap> academicScheduleListPaging(PageInfo pageInfo);

	Integer academicScheduleDelete(String acadSchdlId);

	int academicScheduleRegist(@Valid AcademicScheduleVO vo);

	int academicScheduleModify(@Valid AcademicScheduleVO vo);

	AcademicScheduleVO academicScheduleSelect(AcademicScheduleVO vo);
}