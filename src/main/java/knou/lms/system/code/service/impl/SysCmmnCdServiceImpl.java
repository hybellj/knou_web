package knou.lms.system.code.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.exception.MediopiaDefineException;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.system.code.dao.SysCmmnCdDAO;
import knou.lms.system.code.service.SysCmmnCdService;
import knou.lms.system.code.vo.SysCmmnCdVO;

@Service("sysCmmnCdService")
public class SysCmmnCdServiceImpl extends ServiceBase implements SysCmmnCdService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SysCmmnCdServiceImpl.class);

    @Resource(name="sysCmmnCdDAO")
    private SysCmmnCdDAO sysCmmnCdDAO;

    /*****************************************************
     * 상위 공통코드 관련
     *****************************************************/

    /*****************************************************
     * 시스템 상위 공통코드 등록
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public void insertSysCmmnUpCd(SysCmmnCdVO vo) throws Exception {
        sysCmmnCdDAO.insertSysCmmnUpCd(vo);
    }

    /*****************************************************
     * 시스템 상위 공통코드 목록 페이징
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SysCmmnCdVO> listSysCmmnUpCdPaging(SysCmmnCdVO vo) throws Exception {
        ProcessResultVO<SysCmmnCdVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = sysCmmnCdDAO.countSysCmmnUpCd(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<SysCmmnCdVO> resultList = sysCmmnCdDAO.listSysCmmnUpCdPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 시스템 상위 공통코드 수정
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public void updateSysCmmnUpCd(SysCmmnCdVO vo) throws Exception {
        sysCmmnCdDAO.updateSysCmmnUpCd(vo);
        sysCmmnCdDAO.updateSysCmmnCd(vo);
    }

    /*****************************************************
     * 시스템 상위 공통코드 삭제
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteSysCmmnUpCd(SysCmmnCdVO vo) throws Exception {
        int totCnt = sysCmmnCdDAO.countSysCmmnCd(vo);
        // 삭제 전 상위 코드의 하위 코드가 사용중이면 삭제가 불가능함
        if (totCnt == 0) {
            sysCmmnCdDAO.deleteSysCmmnUpCd(vo);
            sysCmmnCdDAO.deleteSysCmmnCd(vo);
        } else {
            throw new MediopiaDefineException("사용중인 하위 코드가 존재하여 삭제할 수 없습니다.");
        }            
    }

    /*****************************************************
     * 공통코드 관련
     *****************************************************/

    /*****************************************************
     * 시스템 공통코드 등록
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public void insertSysCmmnCd(SysCmmnCdVO vo) throws Exception {
        sysCmmnCdDAO.insertSysCmmnCd(vo);
    }

    /*****************************************************
     * 시스템 공통코드 목록 페이징
     * @param vo
     * @return SysCmmnCdVO
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SysCmmnCdVO> listSysCmmnCdPaging(SysCmmnCdVO vo) throws Exception {        
        ProcessResultVO<SysCmmnCdVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = sysCmmnCdDAO.countSysCmmnCd(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<SysCmmnCdVO> resultList = sysCmmnCdDAO.listSysCmmnUpCdPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 시스템 공통코드 등록
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public void updateSysCmmnCd(SysCmmnCdVO vo) throws Exception {
        sysCmmnCdDAO.updateSysCmmnCd(vo);
    }

    /*****************************************************
     * 시스템 공통코드 등록
     * @param vo
     * @return ProcessResultVO<SysCmmnCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteSysCmmnCd(SysCmmnCdVO vo) throws Exception {
        sysCmmnCdDAO.deleteSysCmmnCd(vo);
    }
}