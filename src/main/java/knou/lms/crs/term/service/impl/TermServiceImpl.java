package knou.lms.crs.term.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.CrsTermLessonVO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.sys.dao.SysJobSchDAO;
import knou.lms.sys.vo.SysJobSchVO;

@Service("termService")
public class TermServiceImpl extends ServiceBase implements TermService {

    /** termDAO */
    @Resource(name="termDAO")
    private TermDAO termDAO;
    
    @Resource(name = "messageSource")
    private MessageSource messageSource;
    
    @Resource(name="sysJobSchDAO")
    private SysJobSchDAO sysJobSchDAO;
    
    /**
     * 학기 정보 저장.
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void add(TermVO vo) throws Exception {
        termDAO.insert(vo);
        
        // 외부기관인 경우 작업일정 등록
        if (!CommConst.KNOU_ORG_ID.equals(vo.getOrgId())) {
        	insertJobSch(vo);
        }
    }
    
    /**
     * 학기 정보 저장.
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void update(TermVO vo) throws Exception {
        termDAO.update(vo);
    }
    
    /**
     * 학기, 개설과목 수정
     * 
     * @param TermVO
     * @return void
     * @throws Exception
     */
    @Override
    public void updateTerm(TermVO vo) throws Exception {
        try {
            termDAO.update(vo);
            termDAO.updateCreCrs(vo);
            
            // 외부기관인 경우 작업일정 등록
            if (!CommConst.KNOU_ORG_ID.equals(vo.getOrgId())) {
            	insertJobSch(vo);
            }
            
        } catch(Exception e) {
            //e.printStackTrace();
            throw new Exception(e.getMessage());
        }
    }   
    
    // 외부기관의 작업일정 등록
    private void insertJobSch(TermVO vo) throws Exception {
    	SysJobSchVO schVO = null; 
    	SysJobSchVO jobSchVO = new SysJobSchVO();
    	jobSchVO.setOrgId(vo.getOrgId());
    	jobSchVO.setHaksaYear(vo.getHaksaYear());
    	jobSchVO.setHaksaTerm(vo.getHaksaTerm());
    	jobSchVO.setRgtrId(vo.getRgtrId());
    	jobSchVO.setMdfrId(vo.getMdfrId());
    	
    	// 성적입력기간 - 00210206
    	if (!"".equals(StringUtil.nvl(vo.getScoInputStartDttm())) && !"".equals(StringUtil.nvl(vo.getScoInputEndDttm()))) {
    		jobSchVO.setSysjobSchdlId(null);
    		jobSchVO.setSysjobSchdlSymd(vo.getScoInputStartDttm());
    		jobSchVO.setSysjobSchdlEymd(vo.getScoInputEndDttm());
    		jobSchVO.setCalendarCtgr("00210206");
    		jobSchVO.setSysjobSchdlnm("성적입력기간");
    		jobSchVO.setSysjobSchdlCmnt(jobSchVO.getSysjobSchdlnm());
    		
    		schVO = sysJobSchDAO.select(jobSchVO);
    		if (schVO == null) {
    			jobSchVO.setSysjobSchdlId(IdGenerator.getNewId("ACAD"));
    			sysJobSchDAO.insert(jobSchVO);
    		}
    		else {
    			jobSchVO.setSysjobSchdlId(schVO.getSysjobSchdlId());
    			sysJobSchDAO.update(jobSchVO);
    		}
    	}
    	// 성적조회기간 - 00210210
    	if (!"".equals(StringUtil.nvl(vo.getScoViewStartDttm())) && !"".equals(StringUtil.nvl(vo.getScoViewEndDttm()))) {
    		jobSchVO.setSysjobSchdlId(null);
    		jobSchVO.setSysjobSchdlSymd(vo.getScoViewStartDttm());
    		jobSchVO.setSysjobSchdlEymd(vo.getScoViewEndDttm());
    		jobSchVO.setCalendarCtgr("00210210");
    		jobSchVO.setSysjobSchdlnm("성적조회기간");
    		jobSchVO.setSysjobSchdlCmnt(jobSchVO.getSysjobSchdlnm());
    		
    		schVO = sysJobSchDAO.select(jobSchVO);
    		if (schVO == null) {
    			jobSchVO.setSysjobSchdlId(IdGenerator.getNewId("ACAD"));
    			sysJobSchDAO.insert(jobSchVO);
    		}
    		else {
    			jobSchVO.setSysjobSchdlId(schVO.getSysjobSchdlId());
    			sysJobSchDAO.update(jobSchVO);
    		}
    	}
    	// 성적재확인신청기간 - 00210202
    	if (!"".equals(StringUtil.nvl(vo.getScoObjtStartDttm())) && !"".equals(StringUtil.nvl(vo.getScoObjtEndDttm()))) {
    		jobSchVO.setSysjobSchdlId(null);
    		jobSchVO.setSysjobSchdlSymd(vo.getScoObjtStartDttm());
    		jobSchVO.setSysjobSchdlEymd(vo.getScoObjtEndDttm());
    		jobSchVO.setCalendarCtgr("00210202");
    		jobSchVO.setSysjobSchdlnm("성적재확인신청기간");
    		jobSchVO.setSysjobSchdlCmnt(jobSchVO.getSysjobSchdlnm());
    		
    		schVO = sysJobSchDAO.select(jobSchVO);
    		if (schVO == null) {
    			jobSchVO.setSysjobSchdlId(IdGenerator.getNewId("ACAD"));
    			sysJobSchDAO.insert(jobSchVO);
    		}
    		else {
    			jobSchVO.setSysjobSchdlId(schVO.getSysjobSchdlId());
    			sysJobSchDAO.update(jobSchVO);
    		}
    	}
    	// 성적재확인신청정정기간 - 00210203
    	if (!"".equals(StringUtil.nvl(vo.getScoRechkStartDttm())) && !"".equals(StringUtil.nvl(vo.getScoRechkEndDttm()))) {
    		jobSchVO.setSysjobSchdlId(null);
    		jobSchVO.setSysjobSchdlSymd(vo.getScoRechkStartDttm());
    		jobSchVO.setSysjobSchdlEymd(vo.getScoRechkEndDttm());
    		jobSchVO.setCalendarCtgr("00210203");
    		jobSchVO.setSysjobSchdlnm("성적재확인신청정정기간");
    		jobSchVO.setSysjobSchdlCmnt(jobSchVO.getSysjobSchdlnm());
    		
    		schVO = sysJobSchDAO.select(jobSchVO);
    		if (schVO == null) {
    			jobSchVO.setSysjobSchdlId(IdGenerator.getNewId("ACAD"));
    			sysJobSchDAO.insert(jobSchVO);
    		}
    		else {
    			jobSchVO.setSysjobSchdlId(schVO.getSysjobSchdlId());
    			sysJobSchDAO.update(jobSchVO);
    		}
    	}
    }
    
    /**
     * 학기 정보 삭제
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void delete(TermVO vo) throws Exception {
        CrsTermLessonVO ctVo = new CrsTermLessonVO();
        ctVo.setTermCd(vo.getTermCd());
        try {
            termDAO.deleteTermLesson(vo);
            termDAO.delete(vo);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 한 학기 정보를 조회한다.
     * @param CrsVO
     * @return TermVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<TermVO> view(TermVO vo) throws Exception {
        ProcessResultVO<TermVO> resultVo = new ProcessResultVO<TermVO>(); 
        try {
            vo = termDAO.select(vo);
            resultVo.setResult(1);
            resultVo.setReturnVO(vo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
    
    /**
     * 학기 정보를 조회한다.
     * @param CrsVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<TermVO> listPageing(TermVO vo) throws Exception {
        ProcessResultListVO<TermVO> resultList = new ProcessResultListVO<TermVO>(); 
        
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex()); 
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = 0;
            totalCount = termDAO.countPageing(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<TermVO> crsTermList = termDAO.listPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(crsTermList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
        
    /**
     * 학기 주차를 조회한다.
     * @param CrsVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    @Override
    public List<CrsTermLessonVO> termLessonList(CrsTermLessonVO vo) throws Exception {
        return termDAO.termLessonSelect(vo);
    }
    
    @Override
    public int editCurTermYn(TermVO vo) throws Exception {
        return termDAO.editCurTermYn(vo);
    }
    @Override
    public int notEditCurTermYn(TermVO vo) throws Exception {
        return termDAO.notEditCurTermYn(vo);
    }
    
    /**
     * 학기 정보 중복 체크 .
     * @param vo 
     * @param CrsVO
     * @return TermVO
     * @throws Exception
     */
    @Override
    public TermVO crsTermCheck(TermVO vo) throws Exception {
        return termDAO.crsTermCheck(vo);
    }
    @Override
    public TermVO crsCurTermYnCheck(TermVO vo) throws Exception {
        return termDAO.crsTermCheck(vo);
    }
    
    
    /**
     * 학기 모든 목록 .
     * @param CrsTermLessonVO
     * @return CrsTermLessonVO
     * @throws Exception
     */
    @Override
    public List<TermVO> list(TermVO termVO) throws Exception {
        
        if(!"".equals(StringUtil.nvl(termVO.getCrsCreCd(), ""))) {
            String[] crsCreArray = termVO.getCrsCreCd().split(",");
            termVO.setSqlForeach(crsCreArray);
        }
        List<TermVO> resultList = termDAO.list(termVO);

        return resultList;
    }

    @Override
    public List<TermVO> listHaksaTerm(TermVO vo) throws Exception {
        return termDAO.listHaksaTerm(vo);
    }

    /**
     * 종료 아닌 학기의 모든 목록 .
     * @param CrsTermLessonVO
     * @return CrsTermLessonVO
     * @throws Exception
     */
    @Override
    public List<TermVO> listTermStatus(TermVO termVO) throws Exception {
        
        if(!"".equals(StringUtil.nvl(termVO.getCrsCreCd(), ""))) {
            String[] crsCreArray = termVO.getCrsCreCd().split(",");
            termVO.setSqlForeach(crsCreArray);
        }
        return termDAO.listTermStatus(termVO);
    }
    
    /**
     * 학기 모든 목록 .
     * @param CrsTermLessonVO
     * @return CrsTermLessonVO
     * @throws Exception
     */
    @Override
    public List<TermVO> listTermRltn(TermVO vo) throws Exception {
        return termDAO.listTermRltn(vo);
    }
    
    /**
     * 학기 조회 .
     * @param TermVO
     * @return TermVO
     * @throws Exception
     */
    @Override
    public TermVO termRltnView(TermVO vo) throws Exception {
        return termDAO.termRltnView(vo);
    }
    
    /**
     * 마이페이지 > 수강, 강의 리스트(학기부분에서 사용)
     * @param TermVO
     * @return List<TermVO>
     * @throws Exception
     */
    @Override
    public List<TermVO> listHomeTermStatus(TermVO vo) throws Exception {
        return termDAO.listHomeTermStatus(vo);
    }
    
    @Override
    public List<TermVO> selectListHomeTermStatus(TermVO vo) throws Exception {
        return termDAO.selectListHomeTermStatus(vo);
    }
    
    @Override
    public List<TermVO> listTermByProf(TermVO vo) throws Exception {
        return termDAO.listTermByProf(vo);
    }
    
    @Override
    public TermVO selectTermByCrsCreCd(TermVO vo) throws Exception {
        return termDAO.selectTermByCrsCreCd(vo);
    }
    
    @Override
    public TermVO selectCurrentTerm(TermVO vo) throws Exception {
        return termDAO.selectCurrentTerm(vo);
    }
    
    @Override
    public TermVO selectCurTermLesson(TermVO vo) throws Exception {
        return termDAO.selectCurTermLesson(vo);
    }
    
    @Override
    public TermVO select(TermVO vo) throws Exception {
        return termDAO.select(vo);
    }

    /**
     * 학사년도, 학기별  학기 정보 조회
     * @param  TermVO 
     * @return TermVO
     * @throws Exception
     */
    public TermVO selectTermByHaksa(TermVO vo) throws Exception {
        return termDAO.selectTermByHaksa(vo);
    }
    
    @Override
    public List<TermVO> selectListTermStatus(TermVO termVo) throws Exception {
        if(!"".equals(StringUtil.nvl(termVo.getCrsCreCd(), ""))) {
            String[] crsCreArray = termVo.getCrsCreCd().split(",");
            termVo.setCrsCreArray(crsCreArray);
        }
        
        return termDAO.selectListTermStatus(termVo);
    }
    
    @Override
    public List<TermVO> selectListTermRltn(TermVO termVo) throws Exception {
        return termDAO.selectListTermRltn(termVo);
    }
    
    @Override
    public List<TermVO> selectListStatus(TermVO termVo) throws Exception {
        return termDAO.selectListStatus(termVo);
    }
    
    @Override
    public TermVO selectUniTermByTermLink(TermVO vo) throws Exception {
        return termDAO.selectUniTermByTermLink(vo);
    }

    @Override
    public List<TermVO> listCreYearByProf(TermVO vo) throws Exception {
        return termDAO.listCreYearByProf(vo);
    }
    
    @Override
    public List<TermVO> listCreYearByProfCourse(TermVO vo) throws Exception {
        return termDAO.listCreYearByProfCourse(vo);
    }
    
    @Override
    public List<CrsTermLessonVO> listTermLesson(TermVO vo) throws Exception {
        return termDAO.listTermLesson(vo);
    }
    
    @Override
    public void saveTermLesson(HttpServletRequest request, List<CrsTermLessonVO> list) throws Exception {
        if(list.size() > 0) {
            Locale locale = LocaleUtil.getLocale(request);
            String userId = SessionInfo.getUserId(request);
            String termCd = null;
            List<String> lsnOdrList = new ArrayList<>();
            
            for(CrsTermLessonVO crsTermLessonVO : list) {
                termCd = crsTermLessonVO.getTermCd();
                
                String startDt = crsTermLessonVO.getStartDt();
                String endDt = crsTermLessonVO.getEndDt();
                String ltDetmFrDt = crsTermLessonVO.getLtDetmFrDt();
                String ltDetmToDt = crsTermLessonVO.getLtDetmToDt();
                
                if(ValidationUtils.isEmpty(startDt)) {
                    String[] args = {messageSource.getMessage("common.week", null, "", locale)}; // 주차
                    throw new ServiceProcessException(messageSource.getMessage("common.alert.input.eval_start_date", args, "", locale)); // [{0}] 시작일을 입력하세요.
                }

                if(ValidationUtils.isEmpty(endDt)) {
                    String[] args = {messageSource.getMessage("common.week", null, "", locale)}; // 주차
                    throw new ServiceProcessException(messageSource.getMessage("common.alert.input.eval_end_date", args, "", locale)); // [{0}] 종료일을 입력하세요.
                }
                
                if(ValidationUtils.isEmpty(ltDetmFrDt) && ValidationUtils.isNotEmpty(ltDetmToDt)) {
                    String[] args = {messageSource.getMessage("lesson.label.lt.dttm", null, "", locale)}; // 출석인정 기간
                    throw new ServiceProcessException(messageSource.getMessage("common.alert.input.eval_start_date", args, "", locale)); // [{0}] 시작일을 입력하세요.
                }
                
                if(ValidationUtils.isNotEmpty(ltDetmFrDt) && ValidationUtils.isEmpty(ltDetmToDt)) {
                    String[] args = {messageSource.getMessage("lesson.label.lt.dttm", null, "", locale)}; // 출석인정 기간
                    throw new ServiceProcessException(messageSource.getMessage("common.alert.input.eval_end_date", args, "", locale)); // [{0}] 종료일을 입력하세요.
                }
                
                crsTermLessonVO.setEnrlType("ONLINE");
                crsTermLessonVO.setRgtrId(userId);
                crsTermLessonVO.setMdfrId(userId);
                
                lsnOdrList.add(String.valueOf(crsTermLessonVO.getLsnOdr()));
            }
            
            termDAO.mergeTermLessonList(list);
            
            CrsTermLessonVO deleteTermLessonVO = new CrsTermLessonVO();
            deleteTermLessonVO.setTermCd(termCd);
            deleteTermLessonVO.setEnrlType("ONLINE");
            if(lsnOdrList.size() > 0) {
                deleteTermLessonVO.setSqlForeach(lsnOdrList.toArray(new String[lsnOdrList.size()]));
            }
            termDAO.deleteTermLessonNotInclude(deleteTermLessonVO);
        }
    }
}
