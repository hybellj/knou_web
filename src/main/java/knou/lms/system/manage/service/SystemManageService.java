package knou.lms.system.manage.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.system.manage.vo.SysErrVO;
import knou.lms.system.manage.vo.SysMgrErrVO;

public interface SystemManageService {
    
    public ResultDTO<EgovMap> admExceptionListPaging(PageInfo pageInfo);    
    
    public SysErrVO admExceptionDtl(SysErrVO vo);
    
    public List<SysMgrErrVO> exceptionList(SysMgrErrVO vo);
}