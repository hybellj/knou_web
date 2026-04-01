package knou.lms.mrk.facade;

import javax.annotation.Resource;

import knou.framework.common.IdPrefixType;
import knou.framework.util.IdGenUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("markFacadeService")
public class MarkFacadeServiceImpl extends ServiceBase implements MarkFacadeService {
	
	@Resource(name="semesterService")
    private SemesterService semesterService;
	
	@Resource(name="orgInfoService")
	private OrgInfoService orgInfoService;
	
	@Resource(name="usrDeptCdService")
	private UsrDeptCdService usrDeptCdService;

    @Resource(name="markItemSettingService")
    private MarkItemSettingService markItemSettingService;

    @Resource(name = "markSubjectService")
    private MarkSubjectService markSubjectService;


    @Override
	public EgovMap loadFilterOptions(UserContext userCtx) throws Exception {
		
		EgovMap filterOptions = new EgovMap();
		
		String orgId = userCtx.getOrgId();
		filterOptions.put("orgId", orgId);
		
		// 연도 목록
		filterOptions.put("yearList", DateTimeUtil.getYearList(10, "mix"));
		
		// 현재 연도 : yyyy
		String curYear = DateTimeUtil.getYear();
		filterOptions.put("curYear", curYear);
		
		// 조회기준연도에 개설된 학기기수 조회
		SmstrChrtVO curSmstrChrtVO = new SmstrChrtVO();
		curSmstrChrtVO.setOrgId(orgId);
		curSmstrChrtVO.setDgrsYr(curYear);
		filterOptions.put("smstrChrtList", semesterService.listSmstrChrtByDgrsYr(curSmstrChrtVO));
		
		// 기관 목록 조회
		OrgInfoVO orgInfoVO = new OrgInfoVO();
        orgInfoVO.setOrgId(orgId);
        filterOptions.put("orgList", orgInfoService.list(orgInfoVO));
        
        // 기관에 따른 학과 조회
        UsrDeptCdVO usrDeptCdVO = new UsrDeptCdVO();
        usrDeptCdVO.setOrgId(orgId);
        filterOptions.put("deptList", usrDeptCdService.list(usrDeptCdVO));
		
		return filterOptions;
	}

    @Override
    public ProcessResultVO<EgovMap> stdMrkListSelect(String orgId, String sbjctId, String searchType) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 미평가, 결시신청 따로 조회
        String[] stdNos = null;

        switch (searchType) {
            case "btnZero" :
                stdNos = new String[]{"user001", "user002"};
                break;

            case "btnApprove" :
                stdNos = new String[]{"user001", "user002"};
                break;

            case "btnApplicate" :
                stdNos = new String[]{"user001", "user002"};
                break;

            default:
                stdNos = new String[]{""};
                break;
        };

        // 학생 성적 목록 -> ReturnListVO
        EgovMap searchMap = new EgovMap();
        searchMap.put("searchType", searchType);
        searchMap.put("sbjctId", sbjctId);
        searchMap.put("stdNos", stdNos);

        List<EgovMap> listStdMrk =  markSubjectService.stdMrkList(searchMap);
        resultVO.setReturnList(listStdMrk);

        // 학생 수 -> ReturnVO
        int totCnt = listStdMrk.size();
//        totCnt = markSubjectService.stdMrkListCntSelect(sbjctId);
        EgovMap listCnt = new EgovMap();
        listCnt.put("totCnt", totCnt);
        resultVO.setReturnVO(listCnt);

        // 성적반영비율 -> ReturnSubVO
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");

        List<EgovMap> mrkItmStngList = markItemSettingService.mrkItmStngList(mrkItmStngVO);
        resultVO.setReturnSubVO(mrkItmStngList);

        return resultVO;
    }

    @Override
    public void profStdMrkInitAjax(String sbjctId, String orgId, String userId) throws Exception {

        // 성적 반영비율 목록 조회
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");

        List<EgovMap> mrkItmStngList = markItemSettingService.mrkItmStngList(mrkItmStngVO);

        if(ValidationUtils.isNull(mrkItmStngList)) {
            throw processException("score.label.process.msg19"); // 해당과목의 평가기준을 먼저 입력해주세요.
        }

        // 성적 반영 비율 0 이상인 항목만 남기기
        for (EgovMap mrkItmStng : mrkItmStngList) {
            if (((Number) mrkItmStng.get("mrkRfltrt")).intValue() <= 0) {
                mrkItmStng.clear();
                break;
            }

            // 각 성적항목별 성적반영비율 합 100 맞는지 체크
            String mrkItmTycd = (String)mrkItmStng.get("mrkItmTycd");

            switch (mrkItmTycd) {
                case "ASMT":
                    if (markSubjectService.invalidMrkRfltrtSumAsmtSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.asmt"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "QUIZ":
                    if (markSubjectService.invalidMrkRfltrtSumQuizSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.quiz"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "DSCS":
                    if (markSubjectService.invalidMrkRfltrtSumDscsSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.dscs"); // 토론의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SRVY":
                    if (markSubjectService.invalidMrkRfltrtSumSrvySelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.srvy"); // 설문의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SMNR":
                    if (markSubjectService.invalidMrkRfltrtSumSmnrSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.smnr"); // 세미나의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
            }
        }

        // 기존 성적 초기화
        markSubjectService.allStdMrkSbjctDelete(sbjctId);
        markSubjectService.allStdMrkSbjctDtlDelete(sbjctId);


        List<MarkSubjectVO> mrkSbjctList = markSubjectService.stdMrkSbjctList(sbjctId);  // TB_LMS_MAK_SBJCT insert용 학생목록 조회
        Map<String, String> stdToMrkSbjctIdMap = new HashMap<>();  // MRK_SBJCT_ID FK 매핑용 (key: USER_ID, value: MRK_SBJCT_ID)

        for (MarkSubjectVO mrkSbjctVO : mrkSbjctList) {
            String stdId = mrkSbjctVO.getUserId();
            String mrkSbjctid = IdGenUtil.genNewId(IdPrefixType.MRSBJ);

            mrkSbjctVO.setMrkSbjctId(mrkSbjctid);
            mrkSbjctVO.setScrCnvsStscd("MRK_CNVS_ING"); // 성적환산중
            mrkSbjctVO.setUserId(stdId);
            mrkSbjctVO.setRgtrId(userId);

            stdToMrkSbjctIdMap.put(stdId, mrkSbjctid);
        }

        List<MarkSubjectDetailVO> midExamMrkDtlList = null;
        List<MarkSubjectDetailVO> lstExamMrkDtlList = null;
        List<MarkSubjectDetailVO> smnrMrkDtlList    = null;
        List<MarkSubjectDetailVO> atndcMrkDtlList   = null;
        List<MarkSubjectDetailVO> asmtMrkDtlList    = null;
        List<MarkSubjectDetailVO> dscsMrkDtlList    = null;
        List<MarkSubjectDetailVO> quizMrkDtlList    = null;
        List<MarkSubjectDetailVO> srvyMrkDtlList    = null;

        // 중간고사 평가점수 목록
        midExamMrkDtlList = setMrkSbjctDtlList("MIDEXAM", stdToMrkSbjctIdMap, markSubjectService.examEvlScoreList(sbjctId, "MID"), userId);

        // 기말고사 평가점수 목록
        lstExamMrkDtlList = setMrkSbjctDtlList("LSTMEXAM", stdToMrkSbjctIdMap, markSubjectService.examEvlScoreList(sbjctId, "LST"), userId);


        // 성적항목별 평가점수 목록
        for (EgovMap mrkItmStng : mrkItmStngList) {
            String mrkItmTycd = (String)mrkItmStng.get("mrkItmTycd");
            switch (mrkItmTycd){
                case ("SMNR"):  // 세미나 (작업 전으로 점수 하드코딩 해놓음)
                    smnrMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectService.smnrScoreEvlList(sbjctId), userId);
                    break;

                case ("ATNDC"): // 출결
                    atndcMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectService.attdSummaryList(sbjctId), userId);
                    break;

                case ("ASMT"): // 과제
                    asmtMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectService.asmtScoreEvlList(sbjctId), userId);
                    break;

                case ("DSCS"):  // 토론
                    dscsMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectService.dscsScoreEvlList(sbjctId), userId);
                    break;

                case ("QUIZ"):  // 퀴즈
                    quizMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectService.quizScoreEvlList(sbjctId), userId);
                    break;

                case ("SRVY"):  // 설문
                    srvyMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectService.srvyScoreEvlList(sbjctId), userId);
                    break;
           }
        }

        // 가산점수 조회
        Map<String, Double> adtnScrMap = markSubjectService.adtnScoreList(sbjctId);

        /*
            학생별 성적상세VO 세팅
            - Outer Map Key: userId
            - Inner Map Key: mrkItmTycd
            => {"user12": {
                    "ASMT": { "rawScore": 80, "finalScore": 8.0, "mrkItmTycd": "ASMT", ... },
                    "DSCS": { "rawScore": 90, "finalScore": 4.5, "mrkItmTycd": "DSCS", ... }, ...
                }
         */
        Map<String, Map<String, MarkSubjectDetailVO>> stdScoreDataMap = new HashMap<>();
        
        List<MarkSubjectDetailVO> allDetails = new ArrayList<>();
        if (!midExamMrkDtlList.isEmpty())  allDetails.addAll(midExamMrkDtlList);
        if (!lstExamMrkDtlList.isEmpty())  allDetails.addAll(lstExamMrkDtlList);
        if (!smnrMrkDtlList.isEmpty())     allDetails.addAll(smnrMrkDtlList);
        if (!atndcMrkDtlList.isEmpty())    allDetails.addAll(atndcMrkDtlList);
        if (!asmtMrkDtlList.isEmpty())     allDetails.addAll(asmtMrkDtlList);
        if (!dscsMrkDtlList.isEmpty())     allDetails.addAll(dscsMrkDtlList);
        if (!quizMrkDtlList.isEmpty())     allDetails.addAll(quizMrkDtlList);
        if (!srvyMrkDtlList.isEmpty())     allDetails.addAll(srvyMrkDtlList);

        for (MarkSubjectDetailVO dtlVO : allDetails) {
            String stdId = dtlVO.getUserId();
            String mrkItmTycd = dtlVO.getMrkItmTycd();

            // stdId에 대한 데이터가 없으면 새로 만듦
            stdScoreDataMap.computeIfAbsent(stdId, k -> new HashMap<>());

            // stdId에 대해 성적항목별로 vo를 넣음
            stdScoreDataMap.get(stdId).put(mrkItmTycd, dtlVO);
        }


        for (MarkSubjectVO mrkSbjctVO : mrkSbjctList) {
            String key = mrkSbjctVO.getUserId();
            double totScore = 0.0;

            // 총점 계산
            for (EgovMap mrkItmVO : mrkItmStngList) {
                double score = stdScoreDataMap.get(key).get((String) mrkItmVO.get("mrkItmTycd")) == null ? 0 : stdScoreDataMap.get(key).get((String) mrkItmVO.get("mrkItmTycd")).getScr();

                if (score == -1) score = 0; // 미평가는 총점 합산 제외

                totScore += score * ((Number)mrkItmVO.get("mrkRfltrt")).intValue() / 100;
            }
            mrkSbjctVO.setTotScr(totScore);

            // 가산점 계산
            double adtnScore = adtnScrMap.get(key) == null ? (double) 0.0 : adtnScrMap.get(key);
            mrkSbjctVO.setAdtnScr(adtnScore);

            // 최종점수 계산
            mrkSbjctVO.setLstScr(totScore + adtnScore);
        }

        // 성적과목(상세) Insert
        markSubjectService.mrkSbjctBatchInsert(mrkSbjctList);
        markSubjectService.mrkSbjctDtlBatchInsert(allDetails);

    }


    /**
     * 성적항목별 평가점수 목록 세팅
     * List<EgovMap> -> List<MarkSubjectDetailVO>
     * @param mrkItmTycd
     * @param stdToMrkSbjctIdMap
     * @param scoreList
     * @param rgtrId
     * @return List<MarkSubjectDetailVO>
     * @throws Exception
     */
    public List<MarkSubjectDetailVO> setMrkSbjctDtlList(String mrkItmTycd, Map<String, String>stdToMrkSbjctIdMap, List<EgovMap> scoreList, String rgtrId) throws Exception {
        List<MarkSubjectDetailVO> mrkDtlList = new ArrayList<>();

        if (scoreList.isEmpty()) return mrkDtlList;

        for (EgovMap scoreInfo : scoreList) {
            MarkSubjectDetailVO mrkDtlVO = new MarkSubjectDetailVO();
            mrkDtlVO.setMrkSbjctId(stdToMrkSbjctIdMap.get((String) scoreInfo.get("userId")));
            mrkDtlVO.setMrkSbjctDtlId(IdGenUtil.genNewId(IdPrefixType.MRSBD));
            mrkDtlVO.setUserId((String) scoreInfo.get("userId"));
            mrkDtlVO.setMrkItmTycd(mrkItmTycd);
            mrkDtlVO.setScr(((Number) scoreInfo.get("finalScore")).doubleValue());
            mrkDtlVO.setRgtrId(rgtrId);

            mrkDtlList.add(mrkDtlVO);
        }


        return mrkDtlList;
    }
}
