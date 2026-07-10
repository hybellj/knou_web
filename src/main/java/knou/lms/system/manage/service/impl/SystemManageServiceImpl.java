package knou.lms.system.manage.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.system.manage.dao.SystemManageDAO;
import knou.lms.system.manage.service.SystemManageService;
import knou.lms.system.manage.vo.SysErrVO;
import knou.lms.system.manage.vo.SysMgrErrVO;

@Service("systemManageService")
public class SystemManageServiceImpl extends EgovAbstractServiceImpl implements SystemManageService {

    private static final Logger log = LoggerFactory.getLogger(SystemManageServiceImpl.class);

    @Resource(name="systemManageDAO")
    private SystemManageDAO systemManageDAO;

    /*****************************************************
     * 	관리자오류목록조회페이징
     * @param	vo
     * @return 	ProcessResultVO<EgovMap>
     * @throws 	Exception
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> admExceptionListPaging( PageInfo pageInfo ) {    	
        
    	ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>( pageInfo );
		
    	resultDto.getPageInfo().setTotalRecordCount( systemManageDAO.admExceptionCnt( (PageInfo) pageInfo) );
		
    	resultDto.setReturnList( systemManageDAO.admExceptionListPaging( (PageInfo) pageInfo ) );  

        return resultDto;
    }

    /*****************************************************
     * 오류목록조회
     * @param 	vo
     * @return 	SysMgrErrVO
     * @throws 	Exception
     ******************************************************/
    @Override
    public List<SysMgrErrVO> exceptionList(SysMgrErrVO vo) {
        return systemManageDAO.exceptionList(vo);
    }

    /*****************************************************
     * 시스템 오류현황 상세 조회
     * @param vo
     * @return SysErrVO
     * @throws Exception
     ******************************************************/
    @Override
    public SysErrVO admExceptionDtl(SysErrVO vo) {
        return systemManageDAO.admExceptionDtl(vo);
    }
}