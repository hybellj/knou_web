package knou.lms.mrk.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.mrk.dao.MarkItemSettingDAO;
import knou.lms.mrk.dao.MarkSubjectDAO;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service("markSubjectService")
public class MarkSubjectServiceImpl extends ServiceBase implements MarkSubjectService {

    @Resource(name="markSubjectDAO")
    private MarkSubjectDAO markSubjectDAO;

    @Resource(name="markItemSettingDAO")
    private MarkItemSettingDAO markItemSettingDAO;

    @Autowired
    private ExamDAO examDAO;

    /**
     * 학습자의 성적 목록을 가져온다.
     * @param orgId
     * @param sbjctId
     * @param searchType
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdMrkList(String orgId, String sbjctId, String searchType) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 미평가, 결시신청 따로 조회
        String[] stdNos = null;

        switch (searchType) {
            case "btnZero": // 미평가

                // todo
                break;

            case "btnApprove": // 결시원 승인

                // todo

                break;

            case "btnApplicate": // 결시원 신청

                // todo

                break;

            default:
                stdNos = null;
                break;
        }

        EgovMap searchMap = new EgovMap();
        searchMap.put("searchType", searchType);
        searchMap.put("sbjctId", sbjctId);
        searchMap.put("stdNos", stdNos);

        // 학생 성적 목록 -> ReturnListVO
        List<EgovMap> listStdMrk = markSubjectDAO.stdMrkList(searchMap);
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

        List<EgovMap> mrkItmStngList = markItemSettingDAO.mrkItmStngList(mrkItmStngVO);
        resultVO.setReturnSubVO(mrkItmStngList);

        return resultVO;
    }

    /**
     * 학습자 성적 목록 갯수 조회
     * @param sbjctId
     * @return int
     * @throws Exception
     */
    @Override
    public int stdMrkListCntSelect(String sbjctId) throws Exception {
        return markSubjectDAO.stdMrkListCntSelect(sbjctId);
    }

    /**
     * 학생들의 성적 및 상세성적을 초기화한다.
     * @param orgId
     * @param sbjctId
     * @param rgtrId
     * @throws Exception
     */
    @Override
    public void stdMrkInit(String orgId, String sbjctId, String rgtrId) throws Exception {

        // 성적항목리스트 조회
        List<EgovMap> mrkItmStngList = getMrkItmStngList(orgId, sbjctId);

        // 기존 성적 초기화
        markSubjectDAO.allStdMrkSbjctDtlDelete(sbjctId);
        markSubjectDAO.allStdMrkSbjctDelete(sbjctId);

        // TB_LMS_MAK_SBJCT insert용 학생목록 조회
        List<MarkSubjectVO> mrkSbjctList = markSubjectDAO.stdMrkSbjctList(sbjctId);

        // MRK_SBJCT_ID FK 매핑용
        Map<String, String> stdToMrkSbjctIdMap = new HashMap<>();
        // (key: USER_ID, value: MRK_SBJCT_ID) 매핑작업
        for (MarkSubjectVO mrkSbjctVO : mrkSbjctList) {
            String stdId = mrkSbjctVO.getUserId();
            String mrkSbjctid = IdGenUtil.genNewId(IdPrefixType.MRSBJ);

            mrkSbjctVO.setMrkSbjctId(mrkSbjctid);
            mrkSbjctVO.setScrCnvsStscd("MRK_CNVS_ING"); // 성적환산중
            mrkSbjctVO.setUserId(stdId);
            mrkSbjctVO.setRgtrId(rgtrId);

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
        midExamMrkDtlList = setMrkSbjctDtlList("MIDEXAM", stdToMrkSbjctIdMap, markSubjectDAO.examEvlScoreList(sbjctId, "MID"), rgtrId);

        // 기말고사 평가점수 목록
        lstExamMrkDtlList = setMrkSbjctDtlList("LSTMEXAM", stdToMrkSbjctIdMap, markSubjectDAO.examEvlScoreList(sbjctId, "LST"), rgtrId);

        // 성적항목별 평가점수 목록
        for (EgovMap mrkItmStng : mrkItmStngList) {
            String mrkItmTycd = (String)mrkItmStng.get("mrkItmTycd");
            switch (mrkItmTycd){
                case ("SMNR"):  // 세미나 (작업 전으로 점수 하드코딩 해놓음)
                    smnrMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectDAO.smnrEvlScoreList(sbjctId), rgtrId);
                    break;

                case ("ATNDC"): // 출결
                    atndcMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, this.attdSummaryList(sbjctId), rgtrId);
                    break;

                case ("ASMT"): // 과제
                    asmtMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectDAO.asmtEvlScoreList(sbjctId), rgtrId);
                    break;

                case ("DSCS"):  // 토론
                    dscsMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectDAO.dscsEvlScoreList(sbjctId), rgtrId);
                    break;

                case ("QUIZ"):  // 퀴즈
                    quizMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectDAO.quizEvlScoreList(sbjctId), rgtrId);
                    break;

                case ("SRVY"):  // 설문
                    srvyMrkDtlList = setMrkSbjctDtlList(mrkItmTycd, stdToMrkSbjctIdMap, markSubjectDAO.srvyEvlScoreList(sbjctId), rgtrId);
                    break;
            }
        }

        // 가산점수 조회
        Map<String, Double> adtnScrMap = adtnScrListToMap(markSubjectDAO.adtnScoreList(sbjctId));

        List<MarkSubjectDetailVO> allDetails = new ArrayList<>();
        if (!midExamMrkDtlList.isEmpty())  allDetails.addAll(midExamMrkDtlList);
        if (!lstExamMrkDtlList.isEmpty())  allDetails.addAll(lstExamMrkDtlList);
        if (!smnrMrkDtlList.isEmpty())     allDetails.addAll(smnrMrkDtlList);
        if (!atndcMrkDtlList.isEmpty())    allDetails.addAll(atndcMrkDtlList);
        if (!asmtMrkDtlList.isEmpty())     allDetails.addAll(asmtMrkDtlList);
        if (!dscsMrkDtlList.isEmpty())     allDetails.addAll(dscsMrkDtlList);
        if (!quizMrkDtlList.isEmpty())     allDetails.addAll(quizMrkDtlList);
        if (!srvyMrkDtlList.isEmpty())     allDetails.addAll(srvyMrkDtlList);

        /*
            학생별 MarkSubjectDetailVO 세팅
            - Outer Map Key: rgtrId
            - Inner Map Key: mrkItmTycd
            => {"user12": {
                    "ASMT": { "rawScore": 80, "finalScore": 8.0, "mrkItmTycd": "ASMT", ... },
                    "DSCS": { "rawScore": 90, "finalScore": 4.5, "mrkItmTycd": "DSCS", ... }, ...
                }
         */
        Map<String, Map<String, MarkSubjectDetailVO>> stdScoreDataMap = new HashMap<>();

        for (MarkSubjectDetailVO dtlVO : allDetails) {
            String stdId = dtlVO.getUserId();
            String mrkItmTycd = dtlVO.getMrkItmTycd();

            // stdId에 대한 데이터가 없으면 새로 만듦
            stdScoreDataMap.computeIfAbsent(stdId, k -> new HashMap<>());

            // stdId에 대해 성적항목별로 vo를 넣음
            stdScoreDataMap.get(stdId).put(mrkItmTycd, dtlVO);
        }

        // 학생별 총점, 가산점, 최종점수 계산
        for (MarkSubjectVO mrkSbjctVO : mrkSbjctList) {
            String userId = mrkSbjctVO.getUserId();
            double totScore = 0.0;

            // 총점 계산
            for (EgovMap mrkItmVO : mrkItmStngList) {
                double score = stdScoreDataMap.get(userId).get((String) mrkItmVO.get("mrkItmTycd")) == null ? 0 : stdScoreDataMap.get(userId).get((String) mrkItmVO.get("mrkItmTycd")).getScr();

                if (score == -1) score = 0; // 미평가는 총점 합산 제외

                totScore += score * ((Number)mrkItmVO.get("mrkRfltrt")).intValue() / 100;
            }
            mrkSbjctVO.setTotScr(totScore);

            // 가산점 계산
            double adtnScore = adtnScrMap.get(userId) == null ? 0.0 : adtnScrMap.get(userId);
            mrkSbjctVO.setAdtnScr(adtnScore);

            // 최종점수 계산
            mrkSbjctVO.setLstScr(totScore + adtnScore);

        }
        // 성적과목(상세) Insert
        markSubjectDAO.mrkSbjctBatchInsert(mrkSbjctList);
        markSubjectDAO.mrkSbjctDtlBatchInsert(allDetails);

    }

    /**
     * 학생들의 출석 평가점수 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> attdSummaryList(String sbjctId) throws Exception {
        List<EgovMap> resultMap = new ArrayList<>();

        List<EgovMap> attdSummaryMapList = markSubjectDAO.stdAttdSummaryByWeekSelect(sbjctId);

        for (EgovMap attdSummaryMap : attdSummaryMapList) {

            EgovMap stdAttdScrMap = new EgovMap();
            stdAttdScrMap.put("userId", attdSummaryMap.get("userId"));

            double score = 0; // 출석점수

            int lctrSchdlCnt = ((Number)attdSummaryMap.get("lctrSchdlCnt")).intValue(); // 강의컨텐츠가 있는 주차 수
            int completeCnt = ((Number)attdSummaryMap.get("completeCnt")).intValue(); // 수강 완료한 주차 수
            int lateCnt = ((Number)attdSummaryMap.get("lateCnt")).intValue(); // 지각한 주차 수

            if (lctrSchdlCnt <= 0 || completeCnt <= 0) {
                stdAttdScrMap.put("finalScore", 0);
                resultMap.add(stdAttdScrMap);
                continue;
            };

            /**
             * 출석점수 기준 비율계산 = { ( 출석 주차의 수 + 지각 주차의 수) / 전체 주차의 수 } * 100
             */
            // 학생 출석율
            double attdRatio = (double) (completeCnt + lateCnt) / lctrSchdlCnt * 100;

            // 출석 점수 기준 조회
            // todo: 아직 출석 점수 기준 세팅하는 부분 작업진행이 안되어 임의기준으로 계산함.
            score = getAttdScore(attdRatio);

            stdAttdScrMap.put("finalScore", score);
            resultMap.add(stdAttdScrMap);
        }

        return resultMap;
    }

//
    /**
     * 학생들의 성적을 업데이트한다.
     * @param stdMrkList
     * @throws Exception
     */
    @Override
    public void stdMrkModify(Map<String, Map<String, String>> stdMrkList,String orgId, String sbjctId, String mdfrId) throws Exception {

        // 학생 기존 성적과목 데이터
        List<MarkSubjectVO> mrkVOList = markSubjectDAO.mrkSbjctList(sbjctId);
        List<MarkSubjectDetailVO> allDetails = new ArrayList<>();

        // 매핑작업 key: rgtrId, value: mrkSbjctId
        Map<String, String> stdToMrkSbjctIdMap = new HashMap<>();
        mrkVOList.forEach(vo -> stdToMrkSbjctIdMap.put(vo.getUserId(), vo.getMrkSbjctId()));

        // key: rgtrId, value: 해당 학생의 List<MarkSubjectDetailVO>
        Map<String,List<MarkSubjectDetailVO>> mrkDtlVOListByUserId = new HashMap<>();

        /*
            ***stdMrkList***
            - Outer Map Key: rgtrId
            - Inner Map Key: mrkItmTycd
            => {"user12": { "ASMT": 90, "DSCS": 80, ... , "etcScr": 5},
                "user13": { "ASMT": 90, "DSCS": 80, ... , "etcScr": 5},
                ...
               }
         */
        for (String userId : stdMrkList.keySet()) {

            Map<String, String> innerMap = stdMrkList.get(userId);
            List<MarkSubjectDetailVO> stdMrkDtlVOList = new ArrayList<>();

            for (Map.Entry<String, String> scoreInfoMap : innerMap.entrySet()) {
                String mrkItmtycd = scoreInfoMap.getKey();

                if ("etcScr".equals(mrkItmtycd)) continue;

                Double scr = Double.parseDouble(scoreInfoMap.getValue());

                MarkSubjectDetailVO dtlVO = new MarkSubjectDetailVO(userId, stdToMrkSbjctIdMap.get(userId), mrkItmtycd, scr);
                dtlVO.setMdfrId(mdfrId);
                stdMrkDtlVOList.add(dtlVO);
            }
            allDetails.addAll(stdMrkDtlVOList);
            mrkDtlVOListByUserId.put(userId, stdMrkDtlVOList);
        }

        // 성적 항목
        Map<String, Integer> mrkItmStngMap = this.getMrkItmStngMap(orgId, sbjctId);

        // 가산점수 조회
        Map<String, Double> adtnScrMap = adtnScrListToMap(markSubjectDAO.adtnScoreList(sbjctId));

        for (MarkSubjectVO mrkVO : mrkVOList) {
            String userId = mrkVO.getUserId();
            double etcScr = Double.parseDouble( stdMrkList.get(userId).get("etcScr") );
            double adtnScr = adtnScrMap.get(userId) == null ? 0.0 : adtnScrMap.get(userId);
            double totScr = 0;

            // 학생의 성적항목별 최종점수 계산 및 총점 산정
            List<MarkSubjectDetailVO> stdMrkDtlVOList = mrkDtlVOListByUserId.get(userId);
            for (MarkSubjectDetailVO dtlVO : stdMrkDtlVOList) {
                //  etcScr 제외 총점 가산
                totScr += dtlVO.getScr() * mrkItmStngMap.get(dtlVO.getMrkItmTycd()) / 100;
            }
            double lstScr = totScr + etcScr + adtnScr;

            mrkVO.setEtcScr(etcScr);
            mrkVO.setAdtnScr(adtnScr);
            mrkVO.setTotScr(totScr);
            mrkVO.setLstScr(lstScr);
            mrkVO.setMdfrId(mdfrId);
        };

        // 일괄 업데이트
        markSubjectDAO.mrkSbjctBatchUpdate(mrkVOList);
        markSubjectDAO.mrkSbjctDtlBatchUpdate(allDetails);
    }

    /**
     * 해당 과목의 성적 반영비율 목록을 조회한다.
     * @param orgId
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> getMrkItmStngList (String orgId, String sbjctId) throws Exception{

        // 성적 반영비율 목록 조회
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");

        List<EgovMap> mrkItmStngList = markItemSettingDAO.mrkItmStngList(mrkItmStngVO);

        if(ValidationUtils.isNull(mrkItmStngList)) {
            throw processException("score.label.process.msg19"); // 해당과목의 평가기준을 먼저 입력해주세요.
        }

        int totMrkRfltrt = 0;

        // 성적 반영 비율 0 이상인 항목만 남기기
        for (EgovMap mrkItmStng : mrkItmStngList) {
            int mrkRfltrt = ((Number) mrkItmStng.get("mrkRfltrt")).intValue();

            if ( mrkRfltrt <= 0) {
                mrkItmStng.clear();
                continue;
            }

            // 각 성적항목별 성적반영비율 합 100 맞는지 체크
            switch ((String)mrkItmStng.get("mrkItmTycd")) {
                case "ASMT":
                    if (markSubjectDAO.invalidMrkRfltrtSumAsmtSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.asmt"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "QUIZ":
                    if (markSubjectDAO.invalidMrkRfltrtSumQuizSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.quiz"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "DSCS":
                    if (markSubjectDAO.invalidMrkRfltrtSumDscsSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.dscs"); // 토론의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SRVY":
                    if (markSubjectDAO.invalidMrkRfltrtSumSrvySelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.srvy"); // 설문의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SMNR":
                    if (markSubjectDAO.invalidMrkRfltrtSumSmnrSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.smnr"); // 세미나의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
            }

            totMrkRfltrt += mrkRfltrt;
        }

        if (totMrkRfltrt != 100) throw processException("해당 과목의 성적항목 비율 총합을 100으로 설정한 후 성적처리 가능합니다.");

        return mrkItmStngList;
    }

    /**
     * 성적항목비율 조회
     * (key: mrkItmTycd, value: mrkRfltrt)
     * @param orgId
     * @param sbjctId
     * @return
     * @throws Exception
     */
    public Map<String, Integer> getMrkItmStngMap(String orgId, String sbjctId) throws Exception {
        Map<String, Integer> mrkItmStngMap = new HashMap<>();

        // 성적 반영비율 목록 조회
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");

        List<EgovMap> mrkItmStngList = markItemSettingDAO.mrkItmStngList(mrkItmStngVO);

        if (ValidationUtils.isNull(mrkItmStngList)) {
            throw processException("score.label.process.msg19"); // 해당과목의 평가기준을 먼저 입력해주세요.
        }

        int totMrkRfltrt = 0;

        // 성적 반영 비율 0 이상인 항목만 남기기
        String mrkItmTycd = null;
        for (EgovMap mrkItmStng : mrkItmStngList) {
            mrkItmTycd = (String) mrkItmStng.get("mrkItmTycd");
            Integer mrkRfltrt = ((BigDecimal) mrkItmStng.get("mrkRfltrt")).intValue();

            if (mrkRfltrt <= 0) {
                mrkItmStng.clear();
                continue;
            }

            // 각 성적항목별 성적반영비율 합 100 맞는지 체크
            switch (mrkItmTycd) {
                case "ASMT":
                    if (markSubjectDAO.invalidMrkRfltrtSumAsmtSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.asmt"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "QUIZ":
                    if (markSubjectDAO.invalidMrkRfltrtSumQuizSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.quiz"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "DSCS":
                    if (markSubjectDAO.invalidMrkRfltrtSumDscsSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.dscs"); // 토론의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SRVY":
                    if (markSubjectDAO.invalidMrkRfltrtSumSrvySelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.srvy"); // 설문의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SMNR":
                    if (markSubjectDAO.invalidMrkRfltrtSumSmnrSelect(sbjctId) > 0) {
                        throw processException("score.alert.invalid.ratio.smnr"); // 세미나의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
            }
            mrkItmStngMap.put(mrkItmTycd, mrkRfltrt);

            totMrkRfltrt += mrkRfltrt;
        }

        if (totMrkRfltrt != 100) throw processException("해당 과목의 성적항목 비율 총합을 100으로 설정한 후 성적처리 가능합니다.");

        return mrkItmStngMap;
    };

    /**
     * 임의 출결 기준 계산...
     * @param attdRatio
     * @return
     */
    private int getAttdScore(double attdRatio) {
        int score = 0;

        if (attdRatio == 100){
            score = 100;
        } else if (attdRatio >= 90) {
            score = 90;
        } else if (attdRatio >= 80) {
            score = 80;
        } else if (attdRatio >= 70) {
            score = 70;
        } else {
            score = 0;
        }

        return score;
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

    /**
     * 가산점 리스트를 맵형태로 변환한다.
     * List<EgovMap> -> Map<String, Double> (key:userId, value:adtnScr)
     * @param adtnScoreList
     * @return
     */
    public Map<String, Double> adtnScrListToMap(List<EgovMap> adtnScoreList) {
        Map<String, Double> resultMap = new HashMap<>();

        if (adtnScoreList.isEmpty()) return resultMap;

        for (EgovMap stdAdtnScr : adtnScoreList) {
            String userId = (String) stdAdtnScr.get("userId");
            double adtnScr = ((Number) stdAdtnScr.get("objctAplyScr")).doubleValue();
            resultMap.put(userId, adtnScr);
        }

        return resultMap;
    }
}


