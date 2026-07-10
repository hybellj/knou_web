package knou.lms.system.manage.service.impl;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.system.manage.dao.AcademicScheduleDAO;
import knou.lms.system.manage.service.AcademicScheduleService;
import knou.lms.system.manage.vo.AcademicScheduleVO;

@Service("acadSchdlService")
public class AcademicScheduleServiceImpl extends EgovAbstractServiceImpl implements AcademicScheduleService{

	@Resource(name="academicScheduleDAO")
	private AcademicScheduleDAO academicScheduleDAO;
	 
	@Override	
	public ResultDTO<EgovMap> academicScheduleList(PageInfo pageInfo) {		
		ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>( pageInfo );		
    	resultDto.getPageInfo().setTotalRecordCount( academicScheduleDAO.academicScheduleCnt( (PageInfo) pageInfo) );		
    	resultDto.setReturnList( academicScheduleDAO.academicScheduleListPaging( (PageInfo) pageInfo ) );  
        return resultDto;
	}

	@Override
	public int academicScheduleDelete(String acadSchdlId) {
		return academicScheduleDAO.academicScheduleDelete(acadSchdlId);
	}

	@Override
	public int academicScheduleRegist(@Valid AcademicScheduleVO vo) {
		return academicScheduleDAO.academicScheduleRegist(vo);
	}

	@Override
	public int academicScheduleModify(@Valid AcademicScheduleVO vo) {
		return academicScheduleDAO.academicScheduleModify(vo);
	}

	@Override
	public AcademicScheduleVO academicScheduleSelect(AcademicScheduleVO vo) {
		return academicScheduleDAO.academicScheduleSelect(vo);
	}
}