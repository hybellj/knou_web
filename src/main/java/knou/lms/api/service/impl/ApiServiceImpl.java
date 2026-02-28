package knou.lms.api.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.util.JsonUtil;
import knou.framework.util.RedisUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.api.dao.ApiDAO;
import knou.lms.api.service.ApiService;
import knou.lms.api.vo.ApiCountInfoVO;
import knou.lms.api.vo.ApiListInfoVO;
import knou.lms.api.vo.CntsPreviewVO;
import knou.lms.api.vo.PagePreviewVO;
import knou.lms.api.vo.ZipcontentUploadVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.service.DashboardService;
import knou.lms.dashboard.vo.DashboardVO;
import knou.lms.dashboard.vo.MainCreCrsVO;
import knou.lms.erp.daoErp.ErpDAO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;

@Service("apiService")
public class ApiServiceImpl extends ServiceBase implements ApiService {

    private boolean USE_REDIS = true;

    @Resource(name = "apiDAO")
    private ApiDAO apiDAO;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="termDAO")
    private TermDAO termDAO;

    @Resource(name = "dashboardService")
    private DashboardService dashboardService;

    @Resource(name = "erpDAO")
    private ErpDAO erpDAO;

    @Resource(name = "apiService")
    private ApiService apiService;
    
    // 년도 학기 기본값 세팅
    private ApiCountInfoVO setDefaultYearSemester(ApiCountInfoVO vo) {
        try {
            if(vo != null && ValidationUtils.isNotEmpty(vo.getOrgId()) && (ValidationUtils.isEmpty(vo.getYear()) || ValidationUtils.isEmpty(vo.getSemester()))) {
                ApiCountInfoVO apiCountInfoVO = apiDAO.selectApiTerm(vo);
                
                if(apiCountInfoVO != null) {
                    String year = apiCountInfoVO.getYear();
                    String semester = apiCountInfoVO.getSemester();
                    
                    if(ValidationUtils.isEmpty(vo.getYear())) {
                        vo.setYear(year);
                    }
                    if(ValidationUtils.isEmpty(vo.getSemester())) {
                        vo.setSemester(semester);
                    }
                }
            }
        } catch (Exception e) {
            // 
        }
        
        return vo;
    }
    
    // 년도 학기 기본값 세팅
    private ApiListInfoVO setDefaultYearSemester(ApiListInfoVO vo) {
        try {
            if(vo != null && ValidationUtils.isNotEmpty(vo.getOrgId()) && (ValidationUtils.isEmpty(vo.getYear()) || ValidationUtils.isEmpty(vo.getSemester()))) {
                ApiCountInfoVO apiCountInfoVO = new ApiCountInfoVO();
                apiCountInfoVO.setOrgId(vo.getOrgId());
                apiCountInfoVO = apiDAO.selectApiTerm(apiCountInfoVO);
                
                if(apiCountInfoVO != null) {
                    String year = apiCountInfoVO.getYear();
                    String semester = apiCountInfoVO.getSemester();
                    
                    if(ValidationUtils.isEmpty(vo.getYear())) {
                        vo.setYear(year);
                    }
                    if(ValidationUtils.isEmpty(vo.getSemester())) {
                        vo.setSemester(semester);
                    }
                }
            }
        } catch (Exception e) {
            // 
        }
        
        return vo;
    }
    
    /**
     * ZIP 콘텐츠 업로드 로그 저장
     * @param vo
     * @throws Exception
     */
    @Override
    public void insertZipcontUploadLog(ZipcontentUploadVO vo) throws Exception {

        apiDAO.insertZipcontUploadLog(vo);
    }

    /*****************************************************
     * 학생 강의 알림 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ApiCountInfoVO> selectStuCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception {

        ProcessResultVO<ApiCountInfoVO> resultVO = new ProcessResultVO<ApiCountInfoVO>();
        ApiCountInfoVO vo = new ApiCountInfoVO();
        String alarmType = StringUtil.nvl(apiCountInfoVO.getAlarmType());

        if("NOTICE".equals(alarmType)) {
            // 강의공지
            vo = apiDAO.selectStuNoticeCountInfo(apiCountInfoVO);
        } else if("QNA".equals(alarmType)) {
            //  Q&A
            vo = apiDAO.selectStuQnaCountInfo(apiCountInfoVO);
        } else if("SECRET".equals(alarmType)) {
            // SECRET(일대일문의)
            vo = apiDAO.selectStuSecretCountInfo(apiCountInfoVO);
        } else if("ASMT".equals(alarmType)) {
            // 과제
            vo = apiDAO.selectStuAsmtCountInfo(apiCountInfoVO);
        } else if("FORUM".equals(alarmType)) {
            // 토론
            vo = apiDAO.selectStuForumCountInfo(apiCountInfoVO);
        } else if("QUIZ".equals(alarmType)) {
            // 퀴즈
            vo = apiDAO.selectStuQuizCountInfo(apiCountInfoVO);
        } else if("RESCH".equals(alarmType)) {
            // 설문
            vo = apiDAO.selectStuReschCountInfo(apiCountInfoVO);
        }
        resultVO.setReturnVO(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 교수들 강의 알림 건수
     * 1. 담당과목의 Q&A 미답변 건수
     * 2. 담당과목의 1:1 상담 미답변 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ApiCountInfoVO> selectProfCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception {

        ProcessResultVO<ApiCountInfoVO> resultVO = new ProcessResultVO<ApiCountInfoVO>();

        ApiCountInfoVO vo = apiDAO.selectProfBbsCountInfo(apiCountInfoVO);

        resultVO.setReturnVO(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 신청받은 결시원 개수 (교수/조교)
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectProfExamAbsentRequestCountInfo(ApiCountInfoVO vo) throws Exception {
        vo = this.setDefaultYearSemester(vo);
        ProcessResultVO<ApiCountInfoVO> resultVO = new ProcessResultVO<>();

        ApiCountInfoVO apiCountInfoVO = apiDAO.selectProfExamAbsentRequestCountInfo(vo);

        resultVO.setReturnVO(apiCountInfoVO);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 재확인 신청 받은 건수 (교수)
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectProfScoreObjtRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception {

        ProcessResultVO<ApiCountInfoVO> resultVO = new ProcessResultVO<ApiCountInfoVO>();

        ApiCountInfoVO vo = apiDAO.selectProfScoreObjtRequestCountInfo(apiCountInfoVO);

        resultVO.setReturnVO(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 장애인지원신청 건수
     * 
     * @param apiCountInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiCountInfoVO> selectDisabledPersonRequestCountInfo(ApiCountInfoVO apiCountInfoVO) throws Exception {

        ProcessResultVO<ApiCountInfoVO> resultVO = new ProcessResultVO<ApiCountInfoVO>();

        ApiCountInfoVO vo = apiDAO.selectDisabledPersonRequestCountInfo(apiCountInfoVO);

        resultVO.setReturnVO(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 강의실 전체 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAllNoticeList(ApiListInfoVO apiListInfoVO) throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        List<ApiListInfoVO> resultList = apiDAO.selectAllNoticeList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 학생별로 과목 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStuLessonNoticeList(ApiListInfoVO apiListInfoVO) throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        List<ApiListInfoVO> resultList = apiDAO.selectStuLessonNoticeList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 학생 과목 QNA 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStuLessonQnaList(ApiListInfoVO apiListInfoVO) throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        List<ApiListInfoVO> resultList = apiDAO.selectStuLessonQnaList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;  
    }

    /*****************************************************
     * 교수별로 과목 공지사항 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfLessonNoticeList(ApiListInfoVO apiListInfoVO) throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        List<ApiListInfoVO> resultList = apiDAO.selectProfLessonNoticeList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;  
    }

    /*****************************************************
     * 조교, 교수 강의 Q&A 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfLessonQnaList(ApiListInfoVO apiListInfoVO) throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        List<ApiListInfoVO> resultList = apiDAO.selectProfLessonQnaList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 직원 과목 QNA 내역
     * 
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStaffLessonQnaList(ApiListInfoVO apiListInfoVO) throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        List<ApiListInfoVO> resultList = apiDAO.selectStaffLessonQnaList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 학생 학습 진도율 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStdProgressRatio(ApiListInfoVO vo) throws Exception {
        vo = this.setDefaultYearSemester(vo);
        
        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<>();
        ApiListInfoVO result = new ApiListInfoVO();
        List<ApiListInfoVO> resultList = new ArrayList<>();

        if("A".equals(vo.getProgressType())) {
        	String redisKey = "StdAvgProgress:"+vo.getYear()+":"+vo.getSemester()+":"+vo.getUserId();
        	boolean rdsChk = false; // 가져오기 비활성, 임시
        	
        	// Redis에 데이터가 있으면 읽어오기
            if (CommConst.REDIS_USE && rdsChk && RedisUtil.exists(redisKey)) {
            	Map<String, Object> infoMap = null;
            	String data = RedisUtil.getValue(redisKey);
                
            	infoMap = JsonUtil.getJsonObject(data);
            	result.setStdProgRatio((String)infoMap.get("stdProgRatio"));
            }
            else {
	            // 1. 나의 평균 진도율
	            result = apiDAO.selectStdAvgAllProgressRatio(vo);
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getStdProgRatio(),"0")) == 0.0) {
	            	result.setStdProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getStdProgRatio()) == 100.0) {
	            	result.setStdProgRatio("100");
	            }
	            
	            // Redis에 값 저장
	            if (CommConst.REDIS_USE) {
		            Map<String, Object> infoMap = new HashMap<>();
	            	infoMap.put("stdProgRatio", StringUtil.nvl(result.getStdProgRatio(),"0"));
		            
		            RedisUtil.setValue(redisKey, JsonUtil.getJsonString(infoMap));
		            RedisUtil.expireEndDay(redisKey);
	            }
            }
        }
        else if("B".equals(vo.getProgressType())) {
        	String redisKey = "TotProgress:"+vo.getYear()+":"+vo.getSemester()+":"+vo.getProgressType()+":"+vo.getUniCd();
        	
        	// Redis에 데이터가 있으면 읽어오기
            if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
            	Map<String, Object> infoMap = null;
            	String data = RedisUtil.getValue(redisKey);
                
            	infoMap = JsonUtil.getJsonObject(data);
            	result.setColleageProgRatio((String)infoMap.get("colleageProgRatio"));
            	result.setGradProgRatio((String)infoMap.get("gradProgRatio"));
            	result.setTotalProgRatio((String)infoMap.get("totalProgRatio"));
            }
            else {
	            if("C".equals(vo.getUniCd())) {
	                // 2.1. 학부, 전체 평균 진도율
	                result = apiDAO.selectTotCollProgressRatio(vo);
	                
	            } else if ("G".equals(vo.getUniCd())) {
	                
	                // 2.2. 대학원 전체 평균 진도율
	                result = apiDAO.selectTotGradProgressRatio(vo);
	            } else {
	                result = apiDAO.selectTotProgressRatio(vo);
	            }
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getTotalProgRatio(),"0")) == 0.0) {
	            	result.setTotalProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getTotalProgRatio()) == 100.0) {
	            	result.setTotalProgRatio("100");
	            }
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getColleageProgRatio(),"0")) == 0.0) {
	            	result.setColleageProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getColleageProgRatio()) == 100.0) {
	            	result.setColleageProgRatio("100");
	            }
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getGradProgRatio(),"0")) == 0.0) {
	            	result.setGradProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getGradProgRatio()) == 100.0) {
	            	result.setGradProgRatio("100");
	            }
	            
	            // Redis에 값 저장
	            if (CommConst.REDIS_USE) {
		            Map<String, Object> infoMap = new HashMap<>();
	            	infoMap.put("totalProgRatio", result.getTotalProgRatio());
	            	infoMap.put("colleageProgRatio", result.getColleageProgRatio());
	            	infoMap.put("gradProgRatio", result.getGradProgRatio());
		            
		            RedisUtil.setValue(redisKey, JsonUtil.getJsonString(infoMap));
		            RedisUtil.expireEndDay(redisKey);
	            }
            }
            
        }
        else if("C".equals(vo.getProgressType())) {
        	String redisKey = "StdProgress:"+vo.getYear()+":"+vo.getSemester()+":"+vo.getUserId();
        	
        	// Redis에 데이터가 있으면 읽어오기
            if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
            	Map<String, Object> infoMap = null;
            	ApiListInfoVO infoVO = null;
                List<String> dataList = RedisUtil.getList(redisKey);
                
                for (String data : dataList) {
                	infoMap = JsonUtil.getJsonObject(data);
                	infoVO = new ApiListInfoVO();
                	infoVO.setCrsCreNm((String)infoMap.get("crsCreNm"));
                	infoVO.setDeclsNo((String)infoMap.get("declsNo"));
                	infoVO.setCmplWeekCnt(Integer.parseInt((String)infoMap.get("cmplWeekCnt")));
                	infoVO.setTotWeekCnt(Integer.parseInt((String)infoMap.get("totWeekCnt")));
                	infoVO.setProgRatio(((String)infoMap.get("progRatio")));
                	infoVO.setCorsUrl(((String)infoMap.get("corsUrl")));
                	infoVO.setUserId(((String)infoMap.get("userId")));
                	resultList.add(infoVO);
                }
            }
            else {
	            if("C".equals(vo.getUniCd())) {
	
	                // 3.1. 대학교 수강과목 내역 및 과목별 진도율 : 과목명, 분반, 학습주차수, 전체주차수, 진도율, 링크 URL
	                resultList = apiDAO.selectCollDetailProgressRatio(vo);
	
	            } else if ("G".equals(vo.getUniCd())) {
	
	                // 3.2. 대학원 수강과목 내역 및 과목별 진도율 : 과목명, 분반, 학습주차수, 전체주차수, 진도율, 링크 URL
	                resultList = apiDAO.selectGridDetailProgressRatio(vo);
	
	            } else {
	                // 3.3. 수강과목 내역 및 과목별 진도율 : 과목명, 분반, 학습주차수, 전체주차수, 진도율, 링크 URL
	                resultList = apiDAO.selectStdDetailProgressRatio(vo);
	            }
	            
	            // Redis에 값 저장
	            if (CommConst.REDIS_USE && resultList.size() > 0) {
		            List<String> dataList = new ArrayList<>();
		            Map<String, Object> infoMap = null;
		            for (ApiListInfoVO infoVO : resultList) {
		            	infoMap = new HashMap<>();
		            	infoMap.put("crsCreNm", infoVO.getCrsCreNm());
		            	infoMap.put("declsNo", infoVO.getDeclsNo());
		            	infoMap.put("cmplWeekCnt", infoVO.getCmplWeekCnt()+"");
		            	infoMap.put("totWeekCnt", infoVO.getTotWeekCnt()+"");
		            	infoMap.put("progRatio", infoVO.getProgRatio().toString());
		            	infoMap.put("corsUrl", infoVO.getCorsUrl());
		            	infoMap.put("userId", infoVO.getUserId());
		            	dataList.add(JsonUtil.getJsonString(infoMap));
		            }
		            
		            RedisUtil.setList(redisKey, dataList);
		            RedisUtil.expire(redisKey, 24*60*60);
	            }
            }
        }
        
        result.setYear(vo.getYear());                // 년도
        result.setSemester(vo.getSemester());        // 학기
        result.setCourseCode(vo.getCourseCode());    // 과목코드
        result.setSection(vo.getSection());          // 분반
        result.setUserId(vo.getUserId());            // 사용자번호

        resultVO.setReturnVO(result);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 교수 학습 진도율 조회
     * @param vo
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfProgressRatio(ApiListInfoVO vo) throws Exception {
        vo = this.setDefaultYearSemester(vo);
        
        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<>();

        ApiListInfoVO result = new ApiListInfoVO();
        List<ApiListInfoVO> resultList = new ArrayList<>();

        if("A".equals(vo.getProgressType())) {
        	String redisKey = "ProfAvgProgress:"+vo.getYear()+":"+vo.getSemester()+":"+vo.getUserId();
        	
        	// Redis에 데이터가 있으면 읽어오기
            if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
            	Map<String, Object> infoMap = null;
            	String data = RedisUtil.getValue(redisKey);
                
            	infoMap = JsonUtil.getJsonObject(data);
            	result.setProfProgRatio((String)infoMap.get("profProgRatio"));
            }
            else {
	            // 교수 나의 평균 진도율 
	            result = apiDAO.selectProfAvgProgressRatio(vo);
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getProfProgRatio(),"0")) == 0.0) {
	            	result.setProfProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getProfProgRatio()) == 100.0) {
	            	result.setProfProgRatio("100");
	            }
	            
	            // Redis에 값 저장
	            if (CommConst.REDIS_USE) {
		            Map<String, Object> infoMap = new HashMap<>();
	            	infoMap.put("profProgRatio", StringUtil.nvl(result.getProfProgRatio(),"0"));
		            
		            RedisUtil.setValue(redisKey, JsonUtil.getJsonString(infoMap));
		            RedisUtil.expireEndDay(redisKey);
	            }
            }
        }
        else if("B".equals(vo.getProgressType())) {
        	String redisKey = "TotProgress:"+vo.getYear()+":"+vo.getSemester()+":"+vo.getProgressType()+":"+vo.getUniCd();
        	
        	// Redis에 데이터가 있으면 읽어오기
            if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
            	Map<String, Object> infoMap = null;
            	String data = RedisUtil.getValue(redisKey);
                
            	infoMap = JsonUtil.getJsonObject(data);
            	result.setColleageProgRatio((String)infoMap.get("colleageProgRatio"));
            	result.setGradProgRatio((String)infoMap.get("gradProgRatio"));
            	result.setTotalProgRatio((String)infoMap.get("totalProgRatio"));
            }
            else {
                if("C".equals(vo.getUniCd())) {

                    // 1. 학부 전체 평균 진도율
                    result = apiDAO.selectTotCollProgressRatio(vo);
                } else if("G".equals(vo.getUniCd())) {

                    // 2. 대학원 전체 평균 진도율
                    result = apiDAO.selectTotGradProgressRatio(vo);
                } else {
                    result = apiDAO.selectTotProgressRatio(vo);
                }

                if (Float.parseFloat(StringUtil.nvl(result.getTotalProgRatio(),"0")) == 0.0) {
	            	result.setTotalProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getTotalProgRatio()) == 100.0) {
	            	result.setTotalProgRatio("100");
	            }
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getColleageProgRatio(),"0")) == 0.0) {
	            	result.setColleageProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getColleageProgRatio()) == 100.0) {
	            	result.setColleageProgRatio("100");
	            }
	            
	            if (Float.parseFloat(StringUtil.nvl(result.getGradProgRatio(),"0")) == 0.0) {
	            	result.setGradProgRatio("0");
	            }
	            else if (Float.parseFloat(result.getGradProgRatio()) == 100.0) {
	            	result.setGradProgRatio("100");
	            }
                
                // Redis에 값 저장
	            if (CommConst.REDIS_USE) {
		            Map<String, Object> infoMap = new HashMap<>();
	            	infoMap.put("totalProgRatio", result.getTotalProgRatio());
	            	infoMap.put("colleageProgRatio", result.getColleageProgRatio());
	            	infoMap.put("gradProgRatio", result.getGradProgRatio());
		            
		            RedisUtil.setValue(redisKey, JsonUtil.getJsonString(infoMap));
		            RedisUtil.expireEndDay(redisKey);
	            }
            }
        }
        else if("C".equals(vo.getProgressType())) {
        	String redisKey = "StdProgress:"+vo.getYear()+":"+vo.getSemester()+":"+vo.getUserId();
        	
        	// Redis에 데이터가 있으면 읽어오기
            if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
            	Map<String, Object> infoMap = null;
            	ApiListInfoVO infoVO = null;
                List<String> dataList = RedisUtil.getList(redisKey);
                
                for (String data : dataList) {
                	infoMap = JsonUtil.getJsonObject(data);
                	infoVO = new ApiListInfoVO();
                	infoVO.setCrsCreNm((String)infoMap.get("crsCreNm"));
                	infoVO.setDeclsNo((String)infoMap.get("declsNo"));
                	infoVO.setCmplWeekCnt(Integer.parseInt((String)infoMap.get("cmplWeekCnt")));
                	infoVO.setTotWeekCnt(Integer.parseInt((String)infoMap.get("totWeekCnt")));
                	infoVO.setProgRatio(((String)infoMap.get("progRatio")));
                	infoVO.setCorsUrl(((String)infoMap.get("corsUrl")));
                	infoVO.setUserId(((String)infoMap.get("userId")));
                	resultList.add(infoVO);
                }
            }
            else {
            	 // 3.3. 수강과목 내역 및 과목별 진도율 : 과목명, 분반, 학습주차수, 전체주차수, 진도율, 링크 URL
                resultList = apiDAO.selectStdDetailProgressRatio(vo);
                
                // Redis에 값 저장
	            if (CommConst.REDIS_USE && resultList.size() > 0) {
		            List<String> dataList = new ArrayList<>();
		            Map<String, Object> infoMap = null;
		            for (ApiListInfoVO infoVO : resultList) {
		            	infoMap = new HashMap<>();
		            	infoMap.put("crsCreNm", infoVO.getCrsCreNm());
		            	infoMap.put("declsNo", infoVO.getDeclsNo());
		            	infoMap.put("cmplWeekCnt", infoVO.getCmplWeekCnt()+"");
		            	infoMap.put("totWeekCnt", infoVO.getTotWeekCnt()+"");
		            	infoMap.put("progRatio", infoVO.getProgRatio().toString());
		            	infoMap.put("corsUrl", infoVO.getCorsUrl());
		            	infoMap.put("userId", infoVO.getUserId());
		            	dataList.add(JsonUtil.getJsonString(infoMap));
		            }
		            
		            RedisUtil.setList(redisKey, dataList);
		            RedisUtil.expire(redisKey, 24*60*60);
	            }
            }
        }
        result.setYear(vo.getYear());                // 년도
        result.setSemester(vo.getSemester());        // 학기
        result.setCourseCode(vo.getCourseCode());    // 과목코드
        result.setSection(vo.getSection());          // 분반
        result.setUserId(vo.getUserId());            // 사용자번호

        resultVO.setReturnVO(result);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 교수 과목별 진도율 조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectProfSubjectProgressRatio(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = new ArrayList<>();
        String redisKey = "ProfSubjectProgressRatio:"+apiListInfoVO.getYear()+":"+apiListInfoVO.getSemester()+":"
        		+StringUtil.nvl(apiListInfoVO.getCourseCode())+":"+StringUtil.nvl(apiListInfoVO.getSection())+":"+apiListInfoVO.getUserId();
        
        // Redis에 데이터가 있으면 읽어오기
        if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
        	Map<String, Object> infoMap = null;
        	ApiListInfoVO infoVO = null;
            List<String> dataList = RedisUtil.getList(redisKey);
            
            for (String data : dataList) {
            	infoMap = JsonUtil.getJsonObject(data);
            	infoVO = new ApiListInfoVO();
            	infoVO.setCrsCreCd((String)infoMap.get("crsCreCd"));
            	infoVO.setCrsCreNm((String)infoMap.get("crsCreNm"));
            	infoVO.setDeclsNo((String)infoMap.get("declsNo"));
            	infoVO.setCrsProgRatio((String)infoMap.get("crsProgRatio"));
            	infoVO.setCorsUrl((String)infoMap.get("corsUrl"));
            	resultList.add(infoVO);
            }
        }
        else {
        	resultList = apiDAO.selectProfSubjectProgressRatio(apiListInfoVO);
        	
        	// Redis에 값 저장
            if (CommConst.REDIS_USE && resultList.size() > 0) {
	            List<String> dataList = new ArrayList<>();
	            Map<String, Object> infoMap = null;
	            for (ApiListInfoVO infoVO : resultList) {
	            	infoMap = new HashMap<>();
	            	infoMap.put("crsCreCd", infoVO.getCrsCreCd());
	            	infoMap.put("crsCreNm", infoVO.getCrsCreNm());
	            	infoMap.put("declsNo", infoVO.getDeclsNo());
	            	infoMap.put("crsProgRatio", infoVO.getCrsProgRatio().toString());
	            	infoMap.put("corsUrl", infoVO.getCorsUrl());
	            	dataList.add(JsonUtil.getJsonString(infoMap));
	            }
	            
	            RedisUtil.setList(redisKey, dataList);
	            RedisUtil.expireEndDay(redisKey);
            }
        }

        resultVO.setReturnVO(apiListInfoVO);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 과목별 출석현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectDepartPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception {
        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = new ArrayList<ApiListInfoVO>();
        String redisKey = "DepartPerWeekAttend:"+apiListInfoVO.getYear()+":"+apiListInfoVO.getProgressType()+":"+apiListInfoVO.getUserId();
        
        // Redis에 데이터가 있으면 읽어오기
        if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
        	Map<String, Object> infoMap = null;
        	ApiListInfoVO infoVO = null;
            List<String> dataList = RedisUtil.getList(redisKey);
            
            for (String data : dataList) {
            	infoMap = JsonUtil.getJsonObject(data);
            	infoVO = new ApiListInfoVO();
            	infoVO.setDeptId((String)infoMap.get("deptId"));
            	infoVO.setDeptNm((String)infoMap.get("deptNm"));
            	infoVO.setLessonScheduleOrder((Integer)infoMap.get("lessonScheduleOrder"));
            	infoVO.setLastYearAvgAttendRate(Double.parseDouble((String)infoMap.get("lastYearAvgAttendRate")));
            	infoVO.setThisYearAvgAttendRate(Double.parseDouble((String)infoMap.get("thisYearAvgAttendRate")));
            	resultList.add(infoVO);
            }
        }
        else {
	        if("A".equals(apiListInfoVO.getProgressType())) {
	            // 교수, 조교
	            resultList = apiDAO.selectProfDepartPerWeekAttend(apiListInfoVO);
	        } else if("B".equals(apiListInfoVO.getProgressType())) {
	            // 교수 전체 평균 진도율
	            resultList = apiDAO.selectDeanDepartPerWeekAttend(apiListInfoVO);
	        }
	        
	        // Redis에 값 저장
            if (CommConst.REDIS_USE && resultList.size() > 0) {
	            List<String> dataList = new ArrayList<>();
	            Map<String, Object> infoMap = null;
	            for (ApiListInfoVO infoVO : resultList) {
	            	infoMap = new HashMap<>();
	            	infoMap.put("deptId", infoVO.getDeptId());
	            	infoMap.put("deptNm", infoVO.getDeptNm());
	            	infoMap.put("lessonScheduleOrder", infoVO.getLessonScheduleOrder());
	            	infoMap.put("lastYearAvgAttendRate", infoVO.getLastYearAvgAttendRate().toString());
	            	infoMap.put("thisYearAvgAttendRate", infoVO.getThisYearAvgAttendRate().toString());
	            	dataList.add(JsonUtil.getJsonString(infoMap));
	            }
	            
	            RedisUtil.setList(redisKey, dataList);
	            RedisUtil.expireEndDay(redisKey);
            }
        }

        resultVO.setReturnVO(apiListInfoVO);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 전체 주차별 출석현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = new ArrayList<>();
        String redisKey = "TotalPerWeekAttend:"+apiListInfoVO.getYear();
        
        // Redis에 데이터가 있으면 읽어오기
        if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
        	Map<String, Object> infoMap = null;
        	ApiListInfoVO infoVO = null;
            List<String> dataList = RedisUtil.getList(redisKey);
            
            for (String data : dataList) {
            	infoMap = JsonUtil.getJsonObject(data);
            	infoVO = new ApiListInfoVO();
            	infoVO.setLessonScheduleOrder((Integer)infoMap.get("lessonScheduleOrder"));
            	infoVO.setLastYearAvgAttendRate(Double.parseDouble((String)infoMap.get("lastYearAvgAttendRate")));
            	infoVO.setThisYearAvgAttendRate(Double.parseDouble((String)infoMap.get("thisYearAvgAttendRate")));
            	resultList.add(infoVO);
            }
        }
        else {
            resultList = apiDAO.selectTotalPerWeekAttend(apiListInfoVO);
            
            // Redis에 값 저장
            if (CommConst.REDIS_USE && resultList.size() > 0) {
	            List<String> dataList = new ArrayList<>();
	            Map<String, Object> infoMap = null;
	            for (ApiListInfoVO infoVO : resultList) {
	            	infoMap = new HashMap<>();
	            	infoMap.put("lessonScheduleOrder", infoVO.getLessonScheduleOrder());
	            	infoMap.put("lastYearAvgAttendRate", infoVO.getLastYearAvgAttendRate().toString());
	            	infoMap.put("thisYearAvgAttendRate", infoVO.getThisYearAvgAttendRate().toString());
	            	dataList.add(JsonUtil.getJsonString(infoMap));
	            }
	            
	            RedisUtil.setList(redisKey, dataList);
	            RedisUtil.expireEndDay(redisKey);
            }
        }
        
        resultVO.setReturnVO(apiListInfoVO);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 주차별 학습현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = new ArrayList<>();
        String redisKey = "PerWeekAttend";
        
        // Redis에 데이터가 있으면 읽어오기
        if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
        	Map<String, Object> infoMap = null;
        	ApiListInfoVO infoVO = null;
            List<String> dataList = RedisUtil.getList(redisKey);
            
            for (String data : dataList) {
            	infoMap = JsonUtil.getJsonObject(data);
            	infoVO = new ApiListInfoVO();
            	infoVO.setLessonScheduleOrder((Integer)infoMap.get("lessonScheduleOrder"));
            	infoVO.setColleageAvgAttendRate((String)infoMap.get("colleageAvgAttendRate"));
            	infoVO.setGradAvgAttendRate((String)infoMap.get("gradAvgAttendRate"));
            	resultList.add(infoVO);
            }
        }
        else {
        	resultList = apiDAO.selectPerWeekAttend(apiListInfoVO);
            
            // Redis에 값 저장
            if (CommConst.REDIS_USE && resultList.size() > 0) {
	            List<String> dataList = new ArrayList<>();
	            Map<String, Object> infoMap = null;
	            for (ApiListInfoVO infoVO : resultList) {
	            	infoMap = new HashMap<>();
	            	infoMap.put("lessonScheduleOrder", infoVO.getLessonScheduleOrder());
	            	infoMap.put("colleageAvgAttendRate", infoVO.getColleageAvgAttendRate().toString());
	            	infoMap.put("gradAvgAttendRate", infoVO.getGradAvgAttendRate().toString());
	            	dataList.add(JsonUtil.getJsonString(infoMap));
	            }
	            
	            RedisUtil.setList(redisKey, dataList);
	            RedisUtil.expireEndDay(redisKey);
            }
        }

        resultVO.setReturnVO(apiListInfoVO);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 과목별 출석현황
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectSubjectPerWeekAttend(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = new ArrayList<ApiListInfoVO>();
        String redisKey = "SubjectPerWeekAttend:"+apiListInfoVO.getProgressType()+":"+apiListInfoVO.getUserId();

        // Redis에 데이터가 있으면 읽어오기
        if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
        	Map<String, Object> infoMap = null;
        	ApiListInfoVO infoVO = null;
            List<String> dataList = RedisUtil.getList(redisKey);
            
            for (String data : dataList) {
            	infoMap = JsonUtil.getJsonObject(data);
            	infoVO = new ApiListInfoVO();
            	
            	infoVO.setCrsCreCd((String)infoMap.get("crsCreCd"));
            	infoVO.setCrsCreNm((String)infoMap.get("crsCreNm"));
            	infoVO.setSubjectAttendRate(Double.parseDouble((String)infoMap.get("subjectAttendRate")));
            	resultList.add(infoVO);
            }
        }
        else {
	        if("A".equals(apiListInfoVO.getProgressType())) {
	            // 교수, 조교
	            resultList = apiDAO.selectProfSubjectPerWeekAttend(apiListInfoVO);
	        } else if("B".equals(apiListInfoVO.getProgressType())) {
	            // 교수 전체 평균 진도율
	            resultList = apiDAO.selectDeanSubjectPerWeekAttend(apiListInfoVO);
	        }
	        
	        // Redis에 값 저장
            if (CommConst.REDIS_USE && resultList.size() > 0) {
	            List<String> dataList = new ArrayList<>();
	            Map<String, Object> infoMap = null;
	            for (ApiListInfoVO infoVO : resultList) {
	            	infoMap = new HashMap<>();
	            	infoMap.put("crsCreCd", infoVO.getCrsCreCd());
	            	infoMap.put("crsCreNm", infoVO.getCrsCreNm());
	            	infoMap.put("subjectAttendRate", infoVO.getSubjectAttendRate().toString());
	            	dataList.add(JsonUtil.getJsonString(infoMap));
	            }
	            
	            RedisUtil.setList(redisKey, dataList);
	            RedisUtil.expireEndDay(redisKey);
            }
        }

        resultVO.setReturnVO(apiListInfoVO);
        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 실시간 세미나 내역
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectRealSeminarList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = apiDAO.selectRealSeminarList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 학생 수강 과목조회
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectStuCrsCreNmList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();
        List<ApiListInfoVO> resultList = apiDAO.selectStuCrsCreNmList(apiListInfoVO);

        resultVO.setReturnList(resultList);
        resultVO.setResult(1);

        return resultVO;
    }

    /*****************************************************
     * 전체 학생 진도율 정보 입력
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public void insertStdProgressRatio()throws Exception {

        apiDAO.insertStdProgressRatio();
    }

    /*****************************************************
     * 전체 학생 출석율 정보 입력
     * 
     * @param 
     * @throws Exception
     ******************************************************/
    public void insertStdAttendRatio() throws Exception {

        apiDAO.insertStdAttendRatio();
    }

    /*****************************************************
     * 미리보기 콘텐츠 조회
     * @param LessonCntsVO
     * @throws Exception
     ******************************************************/
    public LessonCntsVO selectPreviewCnts(LessonCntsVO vo) throws Exception {

        return apiDAO.selectPreviewCnts(vo);
    }

    /*****************************************************
     * 미리보기 콘텐츠 페이지목록 조회
     * @param LessonCntsVO
     * @throws Exception
     ******************************************************/
    public List<LessonPageVO> listPreviewLessonPage(LessonPageVO vo) throws Exception {

        return apiDAO.listPreviewLessonPage(vo);
    }

    /*****************************************************
     * 학생별 학습현황 목록
     * @param TermVO
     * @throws Exception
     ******************************************************/
    public List<MainCreCrsVO> listLearningStatus(TermVO vo) throws Exception {

        String orgId = vo.getOrgId();
        String userId = vo.getUserId();

        // 학기 코드 조회
        TermVO termVO = termDAO.selectTermByHaksa(vo);
        String termCd = termVO.getTermCd();

        DashboardVO dashboardVO = new DashboardVO();
        dashboardVO.setOrgId(orgId);
        dashboardVO.setUserId(userId);
        dashboardVO.setTermCd(termCd);
        dashboardVO.setSearchType("Y");

        ProcessResultVO<DashboardVO> resultVO2 = dashboardService.stdCourseInfo(dashboardVO);
        DashboardVO crsDashboardVO = (DashboardVO) resultVO2.getReturnVO();
        List<MainCreCrsVO> corsList = crsDashboardVO.getCreCrsList();

        return corsList;
    }

    /*****************************************************
     * 학생별 학습현황(1과목)
     * @param CreCrsVO
     * @throws Exception
     ******************************************************/
    public List<MainCreCrsVO> listLearningStatusOne(CreCrsVO vo) throws Exception {

        ProcessResultVO<DashboardVO> resultVO2 = dashboardService.stdCourseInfoOne(vo);
        DashboardVO crsDashboardVO = (DashboardVO) resultVO2.getReturnVO();
        List<MainCreCrsVO> corsList = crsDashboardVO.getCreCrsList();

        return corsList;
    }

    /*****************************************************
     * LCDMS 콘텐츠 미리보기 조회
     * @param CntsPreviewVO
     * @throws Exception
     ******************************************************/
    public CntsPreviewVO selectLcdmsCntsPreview(CntsPreviewVO vo) throws Exception {

        return erpDAO.selectLcdmsCntsPreview(vo);
    }

    /*****************************************************
     * LCDMS 콘텐츠 페이지 미리보기 목록 조회
     * @param List<PagePreviewVO>
     * @throws Exception
     ******************************************************/
    public List<PagePreviewVO> listLcdmsPagePreview(PagePreviewVO vo) throws Exception {

        return erpDAO.listLcdmsPagePreview(vo);
    }

    /*****************************************************
     * 주차별 수강현황(카운트)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectWeekCount(ApiListInfoVO apiListInfoVO) throws Exception {

        return apiDAO.selectWeekCount(apiListInfoVO);
    }
    /*****************************************************
     * 주차별 수강현황(목록)
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectWeekList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectWeekCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectWeekList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동 과제카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalAsmntCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectTotalAsmntCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동 과제목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalAsmntList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectTotalAsmntCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectTotalAsmntList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동 토론카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalForumCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectTotalForumCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동 토론목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalForumList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectTotalForumCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectTotalForumList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동 퀴즈카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalQuizCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectTotalQuizCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동 퀴즈목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalQuizList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectTotalQuizCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectTotalQuizList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동 설문카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalReschCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectTotalReschCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동 설문목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalReschList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectTotalReschCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectTotalReschList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동 세미나카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectTotalSeminarCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectTotalSeminarCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동 세미나목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectTotalSeminarList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectTotalSeminarCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex()); 

            List<ApiListInfoVO> resultList = apiDAO.selectTotalSeminarList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습진도카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectLearnProgressCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectLearnProgressCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습진도목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectLearnProgressList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectLearnProgressCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectLearnProgressList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }
    
    /*****************************************************
     * 학습활동이력 과제카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyAsmntCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectAcademyAsmntCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동이력 과제목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyAsmntList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectAcademyAsmntCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectAcademyAsmntList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동이력 토론카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyForumCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectAcademyForumCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동이력 토론목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyForumList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectAcademyForumCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectAcademyForumList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동이력 퀴즈카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyQuizCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectAcademyQuizCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동이력 퀴즈목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyQuizList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectAcademyQuizCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectAcademyQuizList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동이력 설문카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademyReschCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectAcademyReschCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동이력 설문목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademyReschList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectAcademyReschCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex());

            List<ApiListInfoVO> resultList = apiDAO.selectAcademyReschList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }

    /*****************************************************
     * 학습활동이력 세미나카운트
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public int selectAcademySeminarCount(ApiListInfoVO apiListInfoVO) throws Exception {
        return apiDAO.selectAcademySeminarCount(apiListInfoVO);
    }
    /*****************************************************
     * 학습활동이력 세미나목록
     * @param apiListInfoVO
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<ApiListInfoVO> selectAcademySeminarList(ApiListInfoVO apiListInfoVO)throws Exception {

        ProcessResultVO<ApiListInfoVO> resultVO = new ProcessResultVO<ApiListInfoVO>();

        try {

            /** start of paging */
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(apiListInfoVO.getPageIndex());
            paginationInfo.setRecordCountPerPage(apiListInfoVO.getListScale());
            paginationInfo.setPageSize(apiListInfoVO.getPageScale());
            paginationInfo.setTotalRecordCount(apiService.selectAcademySeminarCount(apiListInfoVO));

            apiListInfoVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
            apiListInfoVO.setLastIndex(paginationInfo.getLastRecordIndex()); 

            List<ApiListInfoVO> resultList = apiDAO.selectAcademySeminarList(apiListInfoVO);

            resultVO.setReturnList(resultList);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setReturnVO(apiListInfoVO);
            resultVO.setResult(1);

        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVO.setReturnVO(apiListInfoVO);
        }
        return resultVO;
    }
}
