package knou.lms.sys.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.erp.daoErp.ErpDAO;
import knou.lms.erp.vo.ErpJobScheduleVO;
import knou.lms.sys.dao.SysJobSchDAO;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;

@Service("sysJobSchService")
public class SysJobSchServiceImpl extends ServiceBase implements SysJobSchService {
    
    @Resource(name="sysJobSchDAO")
    private SysJobSchDAO sysJobSchDAO;
    
    @Resource(name="erpDAO")
    private ErpDAO erpDAO;

    /*****************************************************
     * <p>
     * TODO 업무일정 조회
     * </p>
     * 업무일정 조회
     * 
     * @param SysJobSchVO
     * @return SysJobSchVO
     * @throws Exception
     ******************************************************/
    @Override
    public SysJobSchVO select(SysJobSchVO vo) throws Exception {
        return sysJobSchDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 목록 조회
     * </p>
     * 업무일정 목록 조회
     * 
     * @param SysJobSchVO
     * @return List<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SysJobSchVO> list(SysJobSchVO vo) throws Exception {
        return sysJobSchDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 목록 조회 페이징
     * </p>
     * 업무일정 목록 조회 페이징
     * 
     * @param SysJobSchVO
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SysJobSchVO> listPaging(SysJobSchVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<SysJobSchVO> sysJobSchList = sysJobSchDAO.listPaging(vo);

        if(sysJobSchList.size() > 0) {
            paginationInfo.setTotalRecordCount(sysJobSchList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<SysJobSchVO>();

        resultVO.setReturnList(sysJobSchList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 등록
     * </p>
     * 업무일정 등록
     * 
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(SysJobSchVO vo) throws Exception {
        String jobSchSn = IdGenerator.getNewId("ACAD");
        vo.setSysjobSchdlId(jobSchSn);
        sysJobSchDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 수정
     * </p>
     * 업무일정 수정
     * 
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(SysJobSchVO vo) throws Exception {
        sysJobSchDAO.update(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 삭제
     * </p>
     * 업무일정 삭제
     * 
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(SysJobSchVO vo) throws Exception {
        sysJobSchDAO.delete(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 업무일정 조회
     * </p>
     * 업무일정 조회
     * 
     * @param SysJobSchVO
     * @return SysJobSchVO
     * @throws Exception
     ******************************************************/
    @Override
    public SysJobSchVO selectByEndDt(SysJobSchVO vo) throws Exception {
        return sysJobSchDAO.selectByEndDt(vo);
    }

    /*****************************************************
     * <p>
     * TODO ERP 업무일정 연동
     * </p>
     * ERP 업무일정 연동
     * 
     * @param SysJobSchVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void getEepLink(SysJobSchVO vo) throws Exception {
        ErpJobScheduleVO scheduleVO = new ErpJobScheduleVO();
        List<ErpJobScheduleVO> scheduleList = erpDAO.listJobSchedule(scheduleVO);
        
        for(ErpJobScheduleVO svo : scheduleList) {
            SysJobSchVO sjvo = new SysJobSchVO();
            sjvo.setCalendarCtgr(svo.getScheCd());
            sjvo.setOrgId(vo.getOrgId());
            sjvo.setHaksaYear(vo.getHaksaYear());
            sjvo.setHaksaTerm(vo.getHaksaTerm());
            sjvo = sysJobSchDAO.select(sjvo);
            vo.setCalendarCtgr(svo.getScheCd());
            vo.setSysjobSchdlSymd(StringUtil.nvl(svo.getFrDttm(), ""));
            vo.setSysjobSchdlEymd(StringUtil.nvl(svo.getToDttm(), ""));
            vo.setSysjobSchdlCmnt(svo.getNotiCtnt());
            vo.setSysjobSchdlnm(svo.getScheCdNm());
            if(sjvo != null) {
                vo.setSysjobSchdlId(sjvo.getSysjobSchdlId());
                sysJobSchDAO.update(vo);
            } else {
                vo.setSysjobSchdlId(IdGenerator.getNewId("ACAD"));
                sysJobSchDAO.insert(vo);
            }
        }
    }
    
}
