package knou.lms.exam.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.exam.dao.ExamStareDAO;
import knou.lms.exam.dao.ExamStareHstyDAO;
import knou.lms.exam.dao.ExamStarePaperDAO;
import knou.lms.exam.dao.ExamStarePaperHstyDAO;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.service.ExamStareService;
import knou.lms.exam.vo.ExamIndustryConVO;
import knou.lms.exam.vo.ExamStareHstyVO;
import knou.lms.exam.vo.ExamStarePaperHstyVO;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;

@Service("examStareService")
public class ExamStareServiceImpl extends ServiceBase implements ExamStareService {

    @Resource(name="examStareDAO")
    private ExamStareDAO examStareDAO;
    
    @Resource(name="examStareHstyDAO")
    private ExamStareHstyDAO examStareHstyDAO;
    
    @Resource(name="examStarePaperDAO")
    private ExamStarePaperDAO examStarePaperDAO;
    
    @Resource(name="examStarePaperHstyDAO")
    private ExamStarePaperHstyDAO examStarePaperHstyDAO;
    
    @Resource(name="examDAO")
    private ExamDAO examDAO;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Autowired
    private ExamService examService;

    /*****************************************************
     * <p>
     * 시험응시 리스트 조회
     * </p>
     * 시험응시 리스트 조회
     * 
     * @param ForumStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamStareVO> list(ExamStareVO vo) throws Exception {
        
        return examStareDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * 시험응시 학습자 리스트 조회
     * </p>
     * 시험응시 학습자 리스트 조회
     * 
     * @param ForumStareVO
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamStareVO> listExamStareStd(ExamStareVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ExamStareVO> stareList = examStareDAO.listExamStareStd(vo);
        
        if(stareList.size() > 0) {
            paginationInfo.setTotalRecordCount(stareList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ExamStareVO> resultVO = new ProcessResultVO<ExamStareVO>();
        
        resultVO.setReturnList(stareList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }
    
    /*****************************************************
     * <p>
     * 시험응시 학습자 리스트 조회
     * </p>
     * 시험응시 학습자 리스트 조회
     * 
     * @param ExamStareVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listExamStareStdEgov(ExamStareVO vo) throws Exception {
        return examStareDAO.listExamStareStdEgov(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험응시 학습자 정보 조회
     * </p>
     * 시험응시 학습자 정보 조회
     * 
     * @param ForumStareVO
     * @return ExamStareVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamStareVO selectExamStareStd(ExamStareVO vo) throws Exception {

        return examStareDAO.selectExamStareStd(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 현황 조회
     * </p>
     * 시험 현황 조회
     * 
     * @param ForumStareVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectExamScoreStatus(ExamStareVO vo) throws Exception {

        return examStareDAO.selectExamScoreStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 재시험 설정
     * </p>
     * 재시험 설정
     * 
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> setReExamStare(ExamStareVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        
        // 재시험 일자, 적용률 수정
        ExamVO evo = new ExamVO();
        evo.setExamCd(vo.getExamCd());
        evo.setReExamStartDttm(vo.getReExamStartDttm());
        evo.setReExamEndDttm(vo.getReExamEndDttm());
        evo.setReExamAplyRatio(vo.getReExamAplyRatio());
        evo.setMdfrId(vo.getMdfrId());
        examDAO.updateExam(evo);
        
        // 시험일 경우 동일하게 기간 부여
        if("EXAM".equals(StringUtil.nvl(vo.getSearchGubun()))) {
            ExamVO examVO = new ExamVO();
            examVO.setInsRefCd(vo.getExamCd());
            examVO = examDAO.selectByInsRefCd(examVO);
            examVO.setReExamStartDttm(vo.getReExamStartDttm());
            examVO.setReExamEndDttm(vo.getReExamEndDttm());
            examVO.setReExamAplyRatio(vo.getReExamAplyRatio());
            examVO.setMdfrId(vo.getMdfrId());
            examDAO.updateExam(examVO);
        }
        
        // 학습자 선택 체크
        if(vo.getStdIds() == null || "".equals(vo.getStdIds())) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("exam.error.reexam.select.std", null, locale));    // 재응시 설정할 학습자를 선택해주세요.
            return resultVO;
        }
        
        // 재시험 설정
        List<String> stdNoList = Arrays.asList(StringUtil.nvl(vo.getStdIds()).split("\\,"));
        vo.setReExamYn("Y");
        vo.setStareTm(0);
        for(String stdNo : stdNoList) {
            vo.setStdId(stdNo);
            vo.setStareSn(stdNo+vo.getExamCd());    // 신규키값_모사
            examStareDAO.updateReExamStareByStdNo(vo);
        }
        
        // 재시험 이력 생성용
        ExamStareHstyVO examStareHstyVO = new ExamStareHstyVO();
        examStareHstyVO.setExamCd(vo.getExamCd());
        examStareHstyVO.setMdfrId(vo.getMdfrId());
        examStareHstyVO.setRgtrId(vo.getRgtrId());
        examStareHstyVO.setConnIp(connIp);
        examStareHstyVO.setHstyTypeCd("REEXAM");
        
        ExamStarePaperHstyVO examStarePaperHstyVO = new ExamStarePaperHstyVO();
        examStarePaperHstyVO.setExamCd(vo.getExamCd());
        examStarePaperHstyVO.setMdfrId(vo.getMdfrId());
        examStarePaperHstyVO.setRgtrId(vo.getRgtrId());
        
        // 문항 재출제
        ExamStarePaperVO examStarePaperVO = new ExamStarePaperVO();
        examStarePaperVO.setMdfrId(vo.getMdfrId());
        examStarePaperVO.setRgtrId(vo.getRgtrId());
        examStarePaperVO.setExamCd(vo.getExamCd());
        for(String stdNo : stdNoList) {
            examStarePaperVO.setStdNo(stdNo);
            examStarePaperDAO.deleteAll(examStarePaperVO);
            examStarePaperDAO.insertReExamStarePaper(examStarePaperVO);

            // 5.1 응시이력 생성(재시험)
            examStareHstyVO.setStdNo(stdNo);
            examStareHstyDAO.insertExamStareHsty(examStareHstyVO);

            // 5.2 문항이력 생성
            examStarePaperHstyVO.setStdNo(stdNo);
            examStarePaperHstyVO.setStareHstySn(examStareHstyVO.getStareHstySn());
            examStarePaperHstyDAO.insertExamStarePaperHsty(examStarePaperHstyVO);
        }
        
        resultVO.setResult(1);
        return resultVO;
    }
    
    /*****************************************************
     * <p>
     * TODO 중간/기말 실시간시험 재시험 등록, 수정, 삭제
     * </p>
     * 중간/기말 실시간시험 재시험 등록, 수정, 삭제
     * 
     * @param ExamStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> setMidEndReExamStare(ExamVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        // 시험 정보 조회
        ExamVO evo = new ExamVO();
        evo.setCrsCreCd(vo.getCrsCreCd());
        evo.setExamCtgrCd("EXAM");
        evo.setExamStareTypeCd(vo.getExamStareTypeCd());
        evo = examDAO.select(evo);
        
        if(evo != null) {
            evo.setMdfrId(vo.getMdfrId());
            // 삭제가 아닐 경우
            if(!"delete".equals(StringUtil.nvl(vo.getSearchKey()))) {
                // 학습자 선택 체크
                if(vo.getStdIds() == null || "".equals(vo.getStdIds())) {
                    resultVO.setResult(-1);
                    resultVO.setMessage(messageSource.getMessage("exam.error.reexam.select.std", null, locale));    // 재응시 설정할 학습자를 선택해주세요.
                    return resultVO;
                }
                
                // 재시험 일시 설정
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
                Date startDate = sdf.parse(vo.getReExamStartDttm());
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(startDate);
                calendar.add(Calendar.MINUTE, vo.getReExamStareTm());
                evo.setReExamStartDttm(vo.getReExamStartDttm());
                evo.setReExamEndDttm(sdf.format(calendar.getTime()));
                // 재시험 응시시간 설정
                evo.setReExamStareTm(vo.getReExamStareTm());
                // 장애인 시험지원 시간
                evo.setDsblAddTm(vo.getDsblAddTm());
                evo.setReExamYn("Y");
                // 시험 정보 변경
                examDAO.updateExam(evo);
            } else {
                // 시험 재시험 설정 취소
                examDAO.resetReExam(evo);
            }
            
            // 재시험 설정된 학생 제거
            ExamStareVO resetVO = new ExamStareVO();
            resetVO.setMdfrId(vo.getMdfrId());
            resetVO.setExamCd(evo.getExamCd());
            examStareDAO.resetReExamStare(resetVO);
            
            // 삭제가 아닐 경우
            if(!"delete".equals(StringUtil.nvl(vo.getSearchKey()))) {
                // 학생별 재시험 설정
                List<String> stdNoList = Arrays.asList(StringUtil.nvl(vo.getStdIds()).split("\\,"));
                for(String stdNo : stdNoList) {
                    ExamStareVO stareVO = new ExamStareVO();
                    stareVO.setStdId(stdNo);
                    stareVO.setExamCd(evo.getExamCd());
                    stareVO.setStareSn(stdNo+evo.getExamCd());  // 신규키값_모사
                    stareVO.setReExamYn("Y");
                    stareVO.setStareTm(vo.getReExamStareTm());
                    stareVO.setRgtrId(vo.getRgtrId());
                    stareVO.setMdfrId(vo.getMdfrId());
                    examStareDAO.updateReExamStareByStdNo(stareVO);
                }
            }
        } else {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("exam.label.empty.exam", null, locale));   /* 등록된 시험 정보가 없습니다. */
            return resultVO;
        }
        
        resultVO.setResult(1);
        
        return resultVO;
    }
    

    /*****************************************************
     * <p>
     * TODO 시험 초기화
     * </p>
     * 시험 초기화
     * 
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> initExamStare(ExamStareVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        // 1. 이력 생성용 vo 설정
        ExamStareHstyVO examStareHstyVO = new ExamStareHstyVO();
        examStareHstyVO.setExamCd(vo.getExamCd());
        examStareHstyVO.setMdfrId(vo.getMdfrId());
        examStareHstyVO.setRgtrId(vo.getRgtrId());
        examStareHstyVO.setConnIp(StringUtil.nvl(vo.getLoginIp(), "0:0:0:0:0:0:0:1"));
        examStareHstyVO.setHstyTypeCd("INIT");
        examStareHstyVO.setStdNo(vo.getStdId());

        ExamStarePaperHstyVO examStarePaperHstyVO = new ExamStarePaperHstyVO();
        examStarePaperHstyVO.setExamCd(vo.getExamCd());
        examStarePaperHstyVO.setMdfrId(vo.getMdfrId());
        examStarePaperHstyVO.setRgtrId(vo.getRgtrId());
        examStarePaperHstyVO.setStdNo(vo.getStdId());

        // 2. 시험 응시 / 문항 이력 생성(초기화 전에 이력생성해야함)
        examStareHstyDAO.insertExamStareHsty(examStareHstyVO);
        examStarePaperHstyVO.setStareHstySn(examStareHstyVO.getStareHstySn());
        examStarePaperHstyDAO.insertExamStarePaperHsty(examStarePaperHstyVO);

        // 3. 시험 웅시 초기화 업데이트
        List<String> stdList = new ArrayList<String>();
        stdList.add(vo.getStdId());
        vo.setStdNoList(stdList);
        examStareDAO.updateReExamStare(vo);

        // 4. 시험 문항 초기화 업데이트
        ExamStarePaperVO examStarePaperVO = new ExamStarePaperVO();
        examStarePaperVO.setMdfrId(vo.getMdfrId());
        examStarePaperVO.setRgtrId(vo.getRgtrId());
        examStarePaperVO.setExamCd(vo.getExamCd());
        examStarePaperVO.setStdNo(vo.getStdId());
        examStarePaperDAO.updateExamStarePaperInit(examStarePaperVO);

        resultVO.setResult(1);
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 답안 성적 반영
     * </p>
     * 답안 성적 반영
     * 
     * @param ForumStareVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateExamStareScore(ExamStareVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        ExamVO examVO = new ExamVO();
        examVO.setExamCd(vo.getExamCd());
        examVO.setMdfrId(vo.getMdfrId());
        examVO.setRgtrId(vo.getMdfrId());
        examService.insertExamStare(examVO, vo.getCrsCreCd());
        
        ExamStareVO examStareVO = new ExamStareVO();
        examStareVO.setExamCd(vo.getExamCd());
        examStareVO.setMdfrId(vo.getMdfrId());
        examStareVO.setScoreType(StringUtil.nvl(vo.getScoreType()));
        examStareVO.setTotGetScore(vo.getTotGetScore());
        
        if("".equals(StringUtil.nvl(vo.getStdIds()))) {
            List<ExamStareVO> examStareList =  examStareDAO.list(examStareVO);
            for(ExamStareVO esvo : examStareList) {
                examStareVO.setStdId(StringUtil.nvl(esvo.getStdId()));
                examStareDAO.updateExamStareScore(examStareVO);
            }
        } else {
            for(String stdNo : vo.getStdIds().split(",")) {
                examStareVO.setStdId(stdNo);
                examStareDAO.updateExamStareScore(examStareVO);
            }
        }
        resultVO.setResult(1);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험에 응시한 학습자의 점수대역별 통계정보 조회
     * </p>
     * 시험에 응시한 학습자의 점수대역별 통계정보 조회
     * 
     * @param ForumStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamStareVO> listStuExamScoreStatus(ExamStareVO vo) throws Exception {
        return examStareDAO.listStuExamScoreStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 정보 및 학생의 시험 응시정보 조회
     * </p>
     * 시험 정보 및 학생의 시험 응시정보 조회
     * 
     * @param ForumStareVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectStuExamInfo(ExamStareVO vo) throws Exception {
        return examStareDAO.selectStuExamInfo(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험응시 학습자 리스트 조회
     * </p>
     * 시험응시 학습자 리스트 조회
     * 
     * @param ForumStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> listExamStareStdPageing(ExamStareVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try
        {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            List<EgovMap> stdList = examStareDAO.listExamStareStdPageing(vo);
            int totalCount = examStareDAO.listExamStareStdCount(vo);
            paginationInfo.setTotalRecordCount(totalCount);

            resultVO.setResult(1);
            resultVO.setReturnList(stdList);
            resultVO.setPageInfo(paginationInfo);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 중간 기말 참여 현황 목록
     * </p>
     * 중간 기말 참여 현황 목록
     * 
     * @param ExamVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listExamStareStatus(ExamVO vo) throws Exception {
        String searchValue = StringUtil.nvl(vo.getSearchValue());
        vo.setExamCtgrCd("EXAM");
        vo.setSearchValue("");
        List<String> examCdList = new ArrayList<String>();
        if("ADMISSION".equals(StringUtil.nvl(vo.getExamType()))) {
            ExamVO admVO = examDAO.select(vo);
            examCdList.add(admVO != null ? admVO.getExamCd() : "");
        } else {
            vo.setExamStareTypeCd("M");
            ExamVO midVO = examDAO.select(vo);
            vo.setExamStareTypeCd("L");
            ExamVO endVO = examDAO.select(vo);
            examCdList.add(midVO != null ? midVO.getExamCd() : "");
            examCdList.add(endVO != null ? endVO.getExamCd() : "");
        }
        vo.setSearchValue(searchValue);
        vo.setExamCdList(examCdList);
        
        return examStareDAO.listExamStareStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험응시 수정
     * </p>
     * 시험응시 수정
     * 
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamStare(ExamStareVO vo) throws Exception {
        ExamStareVO stareVO = examStareDAO.selectExamStareStd(vo);
        if(stareVO == null) {
            vo.setStareCnt(0);
            vo.setEvalYn("N");
            examStareDAO.insertExamStare(vo);
        } else {
            vo.setTotGetScore(stareVO.getTotGetScore());
            examStareDAO.updateExamStare(vo);
        }
    }

    /*****************************************************
     * <p>
     * TODO 시험응시 교수 메모 수정
     * </p>
     * 시험응시 교수 메모 수정
     * 
     * @param ForumStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamStareMemo(ExamStareVO vo) throws Exception {
        examStareDAO.updateExamStareMemo(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업로드 된 엑셀 파일로 시험 성적 업데이트
     * </p>
     * 업로드 된 엑셀 파일로 시험 성적 업데이트
     * 
     * @param ExamStareVO, List<?>
     * @return ProcessResultVO<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @Override
    public ProcessResultVO<DefaultVO> updateExampleExcelStareScore(ExamStareVO vo, List<?> stdNoList) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String examCd = vo.getExamCd();
        
        // 시험 응시 사전 등록
        ExamVO examVO = new ExamVO();
        examVO.setExamCd(examCd);
        examVO = examService.selectCreCrsByExam(examVO);
        
        String crsCreCd = examVO.getCrsCreCd();
        examVO = new ExamVO();
        examVO.setExamCd(examCd);
        examVO.setCrsCreCd(crsCreCd);
        examService.insertExamStare(examVO, crsCreCd);
        
        //update 값 세팅
        if(stdNoList != null) {
            for (int i = 0; i < stdNoList.size(); i++){
                Map<String, Object> stdNoMap = (Map<String, Object>)stdNoList.get(i);
                String userId = StringUtil.nvl((String) stdNoMap.get("B"));
                float score = (float) (Math.round(Double.parseDouble(StringUtil.nvl((String) stdNoMap.get("D"),"0.0f")) * 10) / 10.0);
                
                //성적 토탈 점수 update
                ExamStareVO esvo = new ExamStareVO();
                esvo.setExamCd(vo.getExamCd());
                esvo.setUserId(userId);
                esvo.setTotGetScore(score);
                esvo.setMdfrId(vo.getMdfrId());
                examStareDAO.updateExamStareExcel(esvo);
            }
        }
        
        resultVO.setResult(1);
        return resultVO;
    }

    /*****************************************************
     * <p>
     * 시험 응시 가능여부 등의 정보 조회
     * </p>
     * 시험 응시 가능여부 등의 정보 조회
     * 
     * @param ExamStareVO
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void checkStdExamStare(ExamStareVO vo) throws Exception {
        EgovMap examStdStareMap = examStareDAO.selectExamStdStareInfo(vo);
        
        // 1. 학생의 시험응시 가능 정보 조회
        if (examStdStareMap == null || examStdStareMap.isEmpty())
        {
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setUserId(vo.getUserId());
            stdVO.setStdId(vo.getStdId());
            stdVO = stdDAO.selectStd(stdVO);
            if(stdVO == null) {
                throw processException("exam.error.not.stareuser"); // 응시 대상자가 아닙니다.
            } else {
                List<StdVO> stdList = new ArrayList<StdVO>();
                stdList.add(stdVO);
                ExamVO examVO = new ExamVO();
                examVO.setExamCd(StringUtil.nvl(vo.getExamCd()));
                examVO = examDAO.select(examVO);
                examVO.setSearchKey("ONE");
                examService.insertRandomPaper(examVO, stdList);
                examStdStareMap = examStareDAO.selectExamStdStareInfo(vo);
            }
        }
        
        // 2. 시험 기간 인지 검사
        if ("N".equals(examStdStareMap.get("starePeriodYn")))
        {
            throw processException("exam.error.not.exampeiod"); // 시험기간이 아닙니다.
        }
        
        // 3. 시험 응시 횟수 검사
        //if (Integer.parseInt(examStdStareMap.get("leftCnt").toString()) <= 0)
        //{
        //    throw processException("exam.error.exceed.starecount"); // 시험 응시 가능횟수를 모두 소진하여 더 이상 응시할 수 없습니다.
        //}
        
        // 4. 남은 시험 응시 시간 검사
        if (Integer.parseInt(examStdStareMap.get("leftTm").toString()) <= 0)
        {
            throw processException("exam.error.exceed.staretime"); // 시험 응시 시간을 초과하였습니다.
        }
        
        // 5. 이미 시험 응시를 완료했는지 검사
        if (examStdStareMap.get("endDttm") != null)
        {
            throw processException("exam.error.stare.finished"); // 시험지 제출을 이미 완료하였습니다.
        }
    }
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록
     * @param List<EgovMap>
     * @return void
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReExamStd(ExamStareVO vo) throws Exception {
        return examStareDAO.listReExamStd(vo);
    }
    
    /*****************************************************
     * 실시간 시험 미응시 학생 목록 페이징
     * @param List<ProcessResultVO<EgovMap>>
     * @return void
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<EgovMap> listPagingReExamStd(ExamStareVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        try
        {
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            List<EgovMap> list = examStareDAO.listPagingReExamStd(vo);
            int totalCount = examStareDAO.countPagingReExamStd(vo);
            paginationInfo.setTotalRecordCount(totalCount);

            resultVO.setResult(1);
            resultVO.setReturnList(list);
            resultVO.setPageInfo(paginationInfo);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }
    
    /*****************************************************
     * 실시간 시험 재시험 등록현황
     * @param EgovMap
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listReExamConfigStatus(ExamStareVO vo) throws Exception {
        return examStareDAO.listReExamConfigStatus(vo);
    }
    
    /*****************************************************
     * 학사 년도 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public List<ExamIndustryConVO> selectHaksaYear(ExamIndustryConVO vo) throws Exception {
        return examStareDAO.selectHaksaYear(vo);
    }
    
    /*****************************************************
     * 학사 학기 조회
     * @param ExamIndustryConVO
     * @return ProcessResultVO<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamIndustryConVO> selectHaksaTerm(ExamIndustryConVO vo) throws Exception {
        ProcessResultVO<ExamIndustryConVO> resultVO = new ProcessResultVO<ExamIndustryConVO>();

        try
        {
            List<ExamIndustryConVO> list = examStareDAO.selectHaksaTerm(vo);

            resultVO.setResult(1);
            resultVO.setReturnList(list);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;        
    }
    
    /*****************************************************
     * 진행중인 과목명 조회
     * @param ExamIndustryConVO
     * @return ProcessResultVO<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ExamIndustryConVO> selectCreCrsNm(ExamIndustryConVO vo) throws Exception {
        ProcessResultVO<ExamIndustryConVO> resultVO = new ProcessResultVO<>();

        try
        {
            List<ExamIndustryConVO> list = examStareDAO.selectCreCrsNm(vo);

            resultVO.setResult(1);
            resultVO.setReturnList(list);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }

        return resultVO;
    }

    /*****************************************************
     * 수업일정 차시 정보 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public ExamIndustryConVO selectLessonSchedule(ExamIndustryConVO vo) throws Exception {
        return examStareDAO.selectLessonSchedule(vo);
    }
    
    /*****************************************************
     * 산업체위탁생학습진행현황 조회
     * @param ExamIndustryConVO
     * @return List<ExamIndustryConVO>
     * @throws Exception
     ******************************************************/
    public List<ExamIndustryConVO> selectIndustryConLearningList(ExamIndustryConVO vo) throws Exception {
        return examStareDAO.selectIndustryConLearningList(vo);
    }

    /*****************************************************
     * 대체평가대상자 목록
     * @param ExamStareVO
     * @return List<ExamStareVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamStareVO> listExamNoStare(ExamStareVO vo) throws Exception {
        return examStareDAO.listExamNoStare(vo);
    }

    /*****************************************************
     * <p>
     * TODO 개별 학습자 시험 재시험 설정 취소
     * </p>
     * 개별 학습자 시험 재시험 설정 취소
     * 
     * @param ExamStareVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void resetReExamStareByStd(ExamStareVO vo) throws Exception {
        examStareDAO.resetReExamStareByStd(vo);
    }

    /*****************************************************
     * <p>
     * TODO 특정 학습자 시험 응시 여부
     * </p>
     * 특정 학습자 시험 응시 여부
     * 
     * @param ExamStareVO
     * @return ExamStareVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamStareVO examStareByStdNo(ExamStareVO vo) throws Exception {
        return examStareDAO.examStareByStdNo(vo);
    }
}
