package knou.lms.exam.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamDsblReqDAO;
import knou.lms.exam.service.ExamDsblReqService;
import knou.lms.exam.vo.ExamDsblReqVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("examDsblReqService")
public class ExamDsblReqServiceImpl extends ServiceBase implements ExamDsblReqService {

    @Resource(name="examDsblReqDAO")
    private ExamDsblReqDAO examDsblReqDAO;
    
    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Autowired
    MessageSource messageSource;

    /*****************************************************
     * <p>
     * 장애 지원 신청 리스트 조회
     * </p>
     * 장애 지원 신청 리스트 조회
     * 
     * @param ExamDsblReqVO
     * @return List<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamDsblReqVO> list(ExamDsblReqVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamDsblReqVO> examDsblReqList = examDsblReqDAO.list(vo);
        
        if(examDsblReqList.size() > 0) {
            paginationInfo.setTotalRecordCount(examDsblReqList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamDsblReqVO> resultVO = new ProcessResultVO<>();
        
        resultVO.setReturnList(examDsblReqList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * 장애 지원 신청 정보 조회
     * </p>
     * 장애 지원 신청 정보 조회
     * 
     * @param ExamDsblReqVO
     * @return ExamDsblReqVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamDsblReqVO select(ExamDsblReqVO vo) throws Exception {
        return examDsblReqDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 내 강의에 등록된 장애 시험 지원 리스트 조회
     * </p>
     * 내 강의에 등록된 장애 시험 지원 리스트 조회
     * 
     * @param ExamDsblReqVO
     * @return ProcessResultVO<ExamDsblReqVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamDsblReqVO> listMyCreCrsExamDsblReq(ExamDsblReqVO vo) throws Exception {
        List<ExamDsblReqVO> examDsblReqList = examDsblReqDAO.listMyCreCrsExamDsblReq(vo);
        ProcessResultVO<ExamDsblReqVO> resultVO = new ProcessResultVO<ExamDsblReqVO>();
        resultVO.setReturnList(examDsblReqList);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 장애인 지원 신청 승인/반려
     * </p>
     * 장애인 지원 신청 승인/반려
     * 
     * @param ExamDsblReqVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertExamDsblReq(ExamDsblReqVO vo) throws Exception {
        if(!"".equals(StringUtil.nvl(vo.getDsblReqCd()))) {
            vo.setProfEditYn("Y");
            examDsblReqDAO.updateExamDsblReq(vo);
        } else {
            String dsblReqCd = IdGenerator.getNewId("DSBL");
            vo.setDsblReqCd(dsblReqCd);
            vo.setProfEditYn("Y");
            examDsblReqDAO.insertExamDsblReq(vo);
        }
    }  

    /*****************************************************
     * <p>
     * 장애 지원 신청 리스트 조회 ( 관리자 )
     * </p>
     * 장애 지원 신청 리스트 조회 ( 관리자 )
     * 
     * @param ExamDsblReqVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamDsblReqVO> listExamDsblReqByAdmin(ExamDsblReqVO vo) throws Exception {
        return examDsblReqDAO.listExamDsblReqByAdmin(vo);
    }
    
    /*****************************************************
     * <p>
     * 장애인 시험지원 수정
     * </p>
     * 장애인 시험지원 수정
     * 
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void updateDisability(UsrUserInfoVO vo) throws Exception {
        ProcessResultVO<UsrUserInfoVO> resultVO = new ProcessResultVO<>();
        
        if(!"NONCANCEL".equals(StringUtil.nvl(vo.getSearchKey()))) {
            UsrUserInfoVO uuivo = usrUserInfoDAO.selectUserByDisabilityCancelGbn(vo);
            if(uuivo == null) {
                throw processException("exam.alert.not.cancel.dsbl.req"); // 장애학생 시험지원 취소 대상이 아닙니다.
            }
            vo.setUserNm(uuivo.getUserNm());
            ExamDsblReqVO dvo = new ExamDsblReqVO();
            dvo.setUserId(vo.getUserId());
            dvo.setSearchKey(StringUtil.nvl(vo.getSearchKey()));
            examDsblReqDAO.updateExamDsblReqByModDttm(dvo);
        } else {
            List<EgovMap> egovList = examDsblReqDAO.listStdByDsblReq(vo);
            for(EgovMap emap : egovList) {
                // 장애 등급별 지원시간 차등저장
                float stareTmTimes = Float.valueOf(emap.get("stareTmTimes").toString());
                int midAddTime = Math.round(Integer.valueOf(emap.get("midStareTm").toString()) * stareTmTimes);
                int endAddTime = Math.round(Integer.valueOf(emap.get("endStareTm").toString()) * stareTmTimes);
                ExamDsblReqVO dsblVO = new ExamDsblReqVO();
                dsblVO.setDsblReqCd(IdGenerator.getNewId("DSBL"));
                dsblVO.setCrsCreCd(emap.get("crsCreCd").toString());
                dsblVO.setStdId(emap.get("stdNo").toString());
                dsblVO.setMidApprStat("APPROVE");
                dsblVO.setMidAddTime(midAddTime);
                dsblVO.setEndApprStat("APPROVE");
                dsblVO.setEndAddTime(endAddTime);
                dsblVO.setRgtrId(emap.get("userId").toString());
                dsblVO.setMdfrId(emap.get("userId").toString());
                examDsblReqDAO.insertExamDsblReq(dsblVO);
            }
            ExamDsblReqVO dvo = new ExamDsblReqVO();
            dvo.setUserId(vo.getUserId());
            examDsblReqDAO.updateExamDsblReqByModDttm(dvo);
        }
        
        usrUserInfoDAO.updateDisability(vo);
    }
    
}
