package knou.lms.mrk.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.dao.ExamAbsentDAO;
import knou.lms.mrk.service.MrkProcStatusService;
import knou.lms.mrk.vo.*;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.exception.BusinessException;
import knou.framework.util.IdGenUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.mrk.dao.MarkItemSettingDAO;
import knou.lms.mrk.dao.MarkSubjectDAO;
import knou.lms.mrk.service.MarkSubjectService;

@Service("markSubjectService")
public class MarkSubjectServiceImpl extends ServiceBase implements MarkSubjectService {

    @Resource(name="markSubjectDAO")
    private MarkSubjectDAO markSubjectDAO;

    @Resource(name="markItemSettingDAO")
    private MarkItemSettingDAO markItemSettingDAO;

    @Resource(name="examAbsentDAO")
    private ExamAbsentDAO examAbsentDAO;

    @Resource(name="examDAO")
    private ExamDAO examDAO;

    @Resource(name="mrkProcStatusService")
    private MrkProcStatusService mrkProcStatusService;

    /**
     * 학생 정보와 성적 상세정보 조회
     * @param sbjctId
     * @param userId
     * @return
     */
    @Override
    public EgovMap getStdMrkDetails(String sbjctId, String userId) {
        return markSubjectDAO.stdMrkSbjctDtlSelect(sbjctId, userId);
    }

    /**
     * 과목의 성적 목록을 가져온다.
     * @param orgId
     * @param sbjctId
     * @param searchType
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdMrkList(String orgId, String sbjctId, String searchType) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 중간결시, 기말결시, 미평가 인원수 -> resultVO
        // 인원수 summary 작업 (중간/기말 결시, 미평가)
        List<EgovMap> absnceList = examDAO.listAbsnceBySbjctId(sbjctId);

        int midAplyCnt = 0; int midAprvCnt = 0; int lstAplyCnt = 0; int lstAprvCnt = 0;

        for (EgovMap absnceInfo : absnceList) {
            String absnceAplyStscd = (String) absnceInfo.get("absnceAplyStscd");
            String examGbncd = (String) absnceInfo.get("examGbncd");

            boolean isAprv = "APRV".equals(absnceAplyStscd);
            boolean isMid = examGbncd.indexOf("MID") > 0;

            if (isMid) {
                if (isAprv) midAprvCnt++;
                else        midAplyCnt++;
            } else {
                if (isAprv) lstAprvCnt++;
                else        lstAplyCnt++;
            }
        }

        Map<String, Integer> cntSummaryMap = new HashMap<>();
        cntSummaryMap.put("midAbsAplyCnt", midAplyCnt); // 중간 결시 제출 인원수
        cntSummaryMap.put("midAbsAprvCnt", midAprvCnt); // 중간 결시 승인 인원수
        cntSummaryMap.put("lstAbsAplyCnt", lstAplyCnt); // 기말 결시 제출 인원수
        cntSummaryMap.put("lstAbsAprvCnt", lstAprvCnt); // 기말 결시 승인 인원수
        cntSummaryMap.put("nonEvlCnt", markSubjectDAO.nonEvlStdCnt(sbjctId)); // 미평가 인원수
        resultVO.setReturnVO(cntSummaryMap);

        // searchType에 따른 조회대상 userId 추출
        List<String> targetUserIdList = new ArrayList<>();

        switch (searchType) {
            case "btnZero": // 미평가
                targetUserIdList = markSubjectDAO.nonEvlStdList(sbjctId);
                break;

            case "btnMidAbsnce": // 중간 결시
                for (EgovMap absnceInfo : absnceList) {
                    if ("MID".equals(absnceInfo.get("examGbncd"))) {
                        targetUserIdList.add((String) absnceInfo.get("userId"));
                    }
                }
                break;

            case "btnLstAbsnce": // 기말 결시
                for (EgovMap absnceInfo : absnceList) {
                    if ("LST".equals(absnceInfo.get("examGbncd"))) {
                        targetUserIdList.add((String) absnceInfo.get("userId"));
                    }
                }
                break;
        }

        // List -> Str
        String[] stdIdArr = null;
        if (!targetUserIdList.isEmpty()) {
            stdIdArr = targetUserIdList.toArray(new String[0]);
        }

        // 학생 성적목록 -> returnList
        EgovMap searchMap = new EgovMap();
        searchMap.put("sbjctId", sbjctId);
        searchMap.put("stdIdArr", stdIdArr);

        List<EgovMap> stdSbjctMrkList = markSubjectDAO.stdSbjctMrkList(searchMap);
        resultVO.setReturnList(stdSbjctMrkList);
        cntSummaryMap.put("totCnt", stdSbjctMrkList.size());    // 조회 인원수

        // 성적반영비율 목록 -> returnListSub
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");
        resultVO.setReturnListSub(markItemSettingDAO.mrkItmStngList(mrkItmStngVO));

        return resultVO;
    }

    /**
     * 학생들의 성적 및 상세성적을 초기화한다.
     * @param orgId
     * @param sbjctId
     * @param rgtrId
     * @throws Exception
     */
    @Override
    public void stdMrkInit(String orgId, String sbjctId, String rgtrId) {

        // 성적항목리스트 조회
        Map<String, BigDecimal> mrkItmStngInfo = getMrkItmStngInfoMap(orgId, sbjctId);

        // 기존 성적 초기화
        markSubjectDAO.allStdMrkSbjctDtlDelete(sbjctId);
        markSubjectDAO.allStdMrkSbjctDelete(sbjctId);

        // 성적 항목별 취득/산출점수 조회
        List<SubjectMarkDetailVO> midExamMrkDtlList;
        List<SubjectMarkDetailVO> lstExamMrkDtlList;
        List<SubjectMarkDetailVO> examMrkDtlList        = new ArrayList<>();
        List<SubjectMarkDetailVO> smnrMrkDtlList        = new ArrayList<>();
        List<SubjectMarkDetailVO> prgMrkDtlList         = new ArrayList<>(); // 진도
        List<SubjectMarkDetailVO> exrcsQstnMrkDtlList   = new ArrayList<>(); // 연습문제
        List<SubjectMarkDetailVO> asmtMrkDtlList        = new ArrayList<>();
        List<SubjectMarkDetailVO> dscsMrkDtlList        = new ArrayList<>();
        List<SubjectMarkDetailVO> quizMrkDtlList        = new ArrayList<>();
        List<SubjectMarkDetailVO> srvyMrkDtlList        = new ArrayList<>();

        midExamMrkDtlList = markSubjectDAO.examEvlScoreList(sbjctId, "MIDEXAM");
        lstExamMrkDtlList = markSubjectDAO.examEvlScoreList(sbjctId, "LSTEXAM");

        // 성적항목별 취득/산출점수 조회
        for (String mrkItmTycd : mrkItmStngInfo.keySet()) {

            switch (mrkItmTycd){
                case ("EXAM"):  //시험
                    examMrkDtlList = markSubjectDAO.normalExamEvlScoreList(sbjctId);
                    break;

                case ("SMNR"):  // 세미나 (작업 전으로 점수 하드코딩 해놓음)
                    smnrMrkDtlList = markSubjectDAO.smnrEvlScoreList(sbjctId);
                    break;

                case ("PRG"): // 진도
                    prgMrkDtlList = markSubjectDAO.prgScoreList(sbjctId);
                    break;

                case ("EXRCS_QSTN"): // 연습문제
                    // TODO: 테이블 작업 안되어있어서 추후 작업 예정 (현재 만점으로 하드코딩 해놓음).
                    exrcsQstnMrkDtlList = markSubjectDAO.exrcsQstnScoreList(sbjctId);
                    break;

                case ("ASMT"): // 과제
                    asmtMrkDtlList = markSubjectDAO.asmtEvlScoreList(sbjctId);
                    break;

                case ("DSCS"):  // 토론
                    dscsMrkDtlList = markSubjectDAO.dscsEvlScoreList(sbjctId);
                    break;

                case ("QUIZ"):  // 퀴즈
                    quizMrkDtlList = markSubjectDAO.quizEvlScoreList(sbjctId);
                    break;

                case ("SRVY"):  // 설문
                    srvyMrkDtlList = markSubjectDAO.srvyEvlScoreList(sbjctId);
                    break;
            }
        }

        // 일괄등록을 위한 리스트 통합
        List<SubjectMarkDetailVO> allDetails = new ArrayList<>();
        if (!midExamMrkDtlList.isEmpty())   allDetails.addAll(midExamMrkDtlList);
        if (!lstExamMrkDtlList.isEmpty())   allDetails.addAll(lstExamMrkDtlList);
        if (!examMrkDtlList.isEmpty())      allDetails.addAll(lstExamMrkDtlList);
        if (!smnrMrkDtlList.isEmpty())      allDetails.addAll(smnrMrkDtlList);
        if (!prgMrkDtlList.isEmpty())       allDetails.addAll(prgMrkDtlList);
        if (!exrcsQstnMrkDtlList.isEmpty()) allDetails.addAll(exrcsQstnMrkDtlList);
        if (!asmtMrkDtlList.isEmpty())      allDetails.addAll(asmtMrkDtlList);
        if (!dscsMrkDtlList.isEmpty())      allDetails.addAll(dscsMrkDtlList);
        if (!quizMrkDtlList.isEmpty())      allDetails.addAll(quizMrkDtlList);
        if (!srvyMrkDtlList.isEmpty())      allDetails.addAll(srvyMrkDtlList);

        // 전체 학생 목록
        List<MarkSubjectVO> sbjctMrkList = markSubjectDAO.stdMrkSbjctList(sbjctId);

        // 가산점수 조회 {userId : adtnScr}
        Map<String, BigDecimal> adtnScrMap = markSubjectDAO.adtnScoreList(sbjctId).stream()
                .collect(Collectors.toMap(MarkSubjectVO::getUserId, MarkSubjectVO::getAdtnScr));

        // {userId : MarkSubjectVO} 매핑  (-> MarkSubjectDetailVO 바인딩 용)
        Map<String, MarkSubjectVO> sbjctMrkMap = new HashMap<>();
        for (MarkSubjectVO mrkVO : sbjctMrkList) {
            mrkVO.setSbjctMrkId(IdGenUtil.genNewId(IdPrefixType.MRSBJ));
            mrkVO.setRgtrId(rgtrId);
            mrkVO.setScrCnvsStscd("MRK_CNVS_ING");
            mrkVO.setTotScr(BigDecimal.ZERO);
            mrkVO.setAdtnScr(adtnScrMap.getOrDefault(mrkVO.getUserId(), BigDecimal.ZERO));

            sbjctMrkMap.put(mrkVO.getUserId(), mrkVO);
        }

        BigDecimal minusOne = new BigDecimal("-1"); // 미평가용

        // 총점 계산 (= 성적항목별 점수 총합)

        for (SubjectMarkDetailVO dtlVO : allDetails) {
            dtlVO.setSbjctMrkDtlId(IdGenUtil.genNewId(IdPrefixType.MRSBD));

            String userId = dtlVO.getUserId();

            MarkSubjectVO mrkVO = sbjctMrkMap.get(userId);
            dtlVO.setSbjctMrkId(mrkVO.getSbjctMrkId());
            dtlVO.setRgtrId(rgtrId);

            BigDecimal acqsScr  = dtlVO.getAcqsScr();   // 원점수
            BigDecimal drvtnScr = dtlVO.getDrvtnScr();  // 산출점수

            //  미평가가 아니라면 부모의 총점에 산출점수 누적해서 합산
            if (acqsScr != null && acqsScr.compareTo(minusOne) != 0 && drvtnScr != null) {
                mrkVO.setTotScr(mrkVO.getTotScr().add(drvtnScr));
            }
        }

        // 최종점수 계산
        sbjctMrkList = new ArrayList<>(sbjctMrkMap.values());
        for (MarkSubjectVO mrkVO : sbjctMrkList) {
            mrkVO.setLstScr(mrkVO.getTotScr().add(mrkVO.getAdtnScr()));
        }

        // 성적과목(상세) Insert
        markSubjectDAO.mrkSbjctBatchInsert(sbjctMrkList);
        markSubjectDAO.mrkSbjctDtlBatchInsert(allDetails);

    }


    /**
     * 학생들의 성적을 업데이트한다.
     * @param stdMrkInfo
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> stdMrkModify(Map<String, Map<String, String>> stdMrkInfo, String orgId, String sbjctId, String mdfrId) {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 업데이트 대상 userId 배열
        String[] targetUserArr = stdMrkInfo.keySet().toArray(new String[0]);

        if (targetUserArr.length == 0) return resultVO.setResultSuccess();

        // 기존 성적 데이터 목록 (비교용)9
        List<MarkSubjectVO> oldMrkList = markSubjectDAO.mrkSbjctList(sbjctId, targetUserArr);
        List<SubjectMarkDetailVO> oldMrkDtlList = markSubjectDAO.mrkSbjctDtlList(sbjctId, targetUserArr);

        // 매핑용 key: userId, value: MarkSubjectVO
        Map<String, MarkSubjectVO> mrkVOMapping = new HashMap<>();

        // (구)점수 정보 세팅 (비교용) - key: userId, value: acqsScrInfo
        // 1. 기타점수
        Map<String, Map<String, BigDecimal>> oldMrkInfo = new HashMap<>();
        for (MarkSubjectVO oldVO : oldMrkList) {
            String userId = oldVO.getUserId();

            // key: mrkItmTycd, value: acqsScr
            Map<String, BigDecimal> acqsScrInfo = new HashMap<>();
            acqsScrInfo.put("etcScr", oldVO.getEtcScr());
            oldMrkInfo.put(userId, acqsScrInfo);

            MarkSubjectVO updatedVO = new MarkSubjectVO(sbjctId, oldVO.getSbjctMrkId(), userId);
            updatedVO.setMdfrId(mdfrId);
            updatedVO.setEtcScr(new BigDecimal(stdMrkInfo.get(userId).get("etcScr")));
            mrkVOMapping.put(userId, updatedVO);
        }

        // 2. 성적항목별 취득점수
        for (SubjectMarkDetailVO dtlVO : oldMrkDtlList) {
            String userId = dtlVO.getUserId();

            Map<String, BigDecimal> acqsScrInfo = oldMrkInfo.get(userId);
            acqsScrInfo.put(dtlVO.getMrkItmTycd(), dtlVO.getAcqsScr());
        }

        // (구)점수 - (신)점수 비교 (updated 더블체크)
        for (String userId : targetUserArr) {
            boolean isUpdated = false;

            Map<String, BigDecimal> oldScrs = oldMrkInfo.get(userId);
            Map<String, String> newScrs = stdMrkInfo.get(userId);

            for (String mrkItmTycd : newScrs.keySet()) {
                BigDecimal oldScr = oldScrs.get(mrkItmTycd);
                BigDecimal newScr = new BigDecimal(newScrs.get(mrkItmTycd));

                if (oldScr.compareTo(newScr) != 0) isUpdated = true; //업데이트여부 감지
            }

            if (!isUpdated)  {
                // 점수차이 없는 경우, 업데이트 제외
                mrkVOMapping.remove(userId);
                stdMrkInfo.remove(userId);
            }
        }

        if (mrkVOMapping.isEmpty()) return resultVO.setResultFailed("업데이트할 점수가 없음");

        /*  성적 업데이트 작업 시작  */
        List<MarkSubjectVO> updatedMrkList          = new ArrayList<>(); // 업데이트할 성적 데이터 목록
        List<SubjectMarkDetailVO> updatedMrkDtlList = new ArrayList<>(); // 업데이트할 성적 상세 데이터 목록
        List<MrkProcStatusVO> updateHstryList       = new ArrayList<>(); // 업데이트할 성적처리이력 데이터 목록

        final BigDecimal HUNDRED = new BigDecimal(100);

        // 성적항목리스트 조회
        Map<String, BigDecimal> mrkItmStng = getMrkItmStngInfoMap(orgId, sbjctId);

        // 가산점수 조회 {userId : adtnScr}
        Map<String, BigDecimal> adtnScrMap = markSubjectDAO.adtnScoreList(sbjctId).stream()
                .collect(Collectors.toMap(MarkSubjectVO::getUserId, MarkSubjectVO::getAdtnScr));

        // 업데이트할 객체 VO 세팅
        for (String userId : stdMrkInfo.keySet()) {
            MarkSubjectVO updatedMrkVO = mrkVOMapping.get(userId);

            BigDecimal totScr = BigDecimal.ZERO;
            BigDecimal adtnScr = adtnScrMap.get(userId) == null ? BigDecimal.ZERO : adtnScrMap.get("userId");
            updatedMrkVO.setAdtnScr(adtnScr);

            // 성적항목비율로 환산점수 계산
            for (String mrkItmTycd : mrkItmStng.keySet()) {

                BigDecimal mrkRfltrt = mrkItmStng.get(mrkItmTycd);
                BigDecimal acqsScr   = new BigDecimal(stdMrkInfo.get(userId).get(mrkItmTycd));

                SubjectMarkDetailVO updatedDtlVO = new SubjectMarkDetailVO( userId, updatedMrkVO.getSbjctMrkId(), mrkItmTycd, mrkRfltrt, acqsScr);
                updatedDtlVO.setMdfrId(mdfrId);
                updatedMrkDtlList.add(updatedDtlVO);

                BigDecimal drvtnScr = updatedDtlVO.getDrvtnScr(); // 취득점수(변경 후 점수)
                totScr = totScr.add(drvtnScr); // 총점에 누적

                // 변경 전 점수
                BigDecimal scrBfr = new BigDecimal(String.valueOf(oldMrkInfo.get(userId).get(mrkItmTycd)));
                scrBfr = scrBfr.multiply(mrkRfltrt).setScale(2, RoundingMode.HALF_UP);

                // 성적처리이력 데이터 추가
                MrkProcStatusVO mrkProcStsVO = new MrkProcStatusVO(sbjctId, userId, IdGenUtil.genNewId(IdPrefixType.MRHTR), mrkItmTycd, scrBfr, drvtnScr, mdfrId);
                updateHstryList.add(mrkProcStsVO);
            }
            // 기타점수
            BigDecimal etcScrBfr = new BigDecimal(String.valueOf(oldMrkInfo.get(userId).get("etcScr")));
            BigDecimal etcScrAft = new BigDecimal(stdMrkInfo.get(userId).get("etcScr"));
            MrkProcStatusVO mrkProcStsVO1 = new MrkProcStatusVO(sbjctId, userId, IdGenUtil.genNewId(IdPrefixType.MRHTR), "ETC_SCR", etcScrBfr, etcScrAft, mdfrId);
            updateHstryList.add(mrkProcStsVO1);

            // 기타점수
            BigDecimal adtnScrBfr = oldMrkInfo.get(userId).get("adtnScr") == null ? BigDecimal.ZERO : oldMrkInfo.get(userId).get("adtnScr");
            MrkProcStatusVO mrkProcStsVO2 = new MrkProcStatusVO(sbjctId, userId, IdGenUtil.genNewId(IdPrefixType.MRHTR), "ADTN_SCR", adtnScrBfr, adtnScr, mdfrId);
            updateHstryList.add(mrkProcStsVO2);

            BigDecimal lstScr = totScr.add(adtnScr).add(updatedMrkVO.getEtcScr()); // lstScr = totSCr + adtnScr + etcScr;

            if (lstScr.compareTo(HUNDRED) > 0) lstScr = HUNDRED; // 100점 초과인 경우 100으로 세팅 (반올림으로 인해 넘을 수 있음..)

            updatedMrkVO.setTotScr(totScr);
            updatedMrkVO.setLstScr(lstScr);

            updatedMrkList.add(updatedMrkVO);
        }

        // 일괄 업데이트
        markSubjectDAO.mrkSbjctBatchUpdate(updatedMrkList);
        markSubjectDAO.mrkSbjctDtlBatchUpdate(updatedMrkDtlList);

        // 성적처리이력 업데이트
        mrkProcStatusService.mrkProcStsBatchInsert(sbjctId, updateHstryList);

        return resultVO.setResultSuccess();
    }


    /**
     * 학생 성적환산상태코드 수정 (최종확정 or 평가취소)
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<EgovMap> stdScrCnvsStsModify(MarkSubjectVO vo) {

        markSubjectDAO.scrCnvsStsModify(vo);

        return new ResultDTO<EgovMap>().setResultSuccess();
    }

    /**
     * 해당 과목의 성적 반영비율 목록을 조회한다.
     * @param orgId
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, BigDecimal> getMrkItmStngInfoMap(String orgId, String sbjctId)  {
        Map<String, BigDecimal> mrkItmStngMap = new HashMap<>();

        final BigDecimal HUNDRED = new BigDecimal(100);

        // 성적 반영비율 목록 조회
        MarkItemSettingVO mrkItmStngVO = new MarkItemSettingVO();
        mrkItmStngVO.setSbjctId(sbjctId);
        mrkItmStngVO.setOrgId(orgId);
        mrkItmStngVO.setMrkItmUseyn("Y");

        List<EgovMap> mrkItmStngList = markItemSettingDAO.mrkItmStngList(mrkItmStngVO);

        if(ValidationUtils.isNull(mrkItmStngList)) {
        	throw new BusinessException("score.label.process.msg19"); // 해당과목의 평가기준을 먼저 입력해주세요.
        }

        BigDecimal totMrkRfltrt = BigDecimal.ZERO;

        // 성적 반영 비율 0 이상인 항목만 남기기
        Iterator<EgovMap> iter = mrkItmStngList.iterator();
        while (iter.hasNext()) {
            EgovMap mrkItmStng = iter.next();

            String mrkItmTycd = (String) mrkItmStng.get("mrkItmTycd");
            BigDecimal mrkRfltrt = (BigDecimal) mrkItmStng.get("mrkRfltrt");

            if (mrkRfltrt.compareTo(BigDecimal.ZERO) <= 0 ) {
                iter.remove();
                continue;
            }

            // 각 성적항목별 성적반영비율 합 100 맞는지 체크
            switch (mrkItmTycd) {
                case "ASMT":
                    if (markSubjectDAO.invalidMrkRfltrtSumAsmtSelect(sbjctId) > 0) {
                        throw new BusinessException("score.alert.invalid.ratio.asmt"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "EXAM":
                    if (markSubjectDAO.invalidMrkRfltrtSumExamSelect(sbjctId) > 0) {
                        throw new BusinessException("score.alert.invalid.ratio.exam"); // 시험의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "QUIZ":
                    if (markSubjectDAO.invalidMrkRfltrtSumQuizSelect(sbjctId) > 0) {
                        throw new BusinessException("score.alert.invalid.ratio.quiz"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "DSCS":
                    if (markSubjectDAO.invalidMrkRfltrtSumDscsSelect(sbjctId) > 0) {
                        throw new BusinessException("score.alert.invalid.ratio.dscs"); // 토론의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SRVY":
                    if (markSubjectDAO.invalidMrkRfltrtSumSrvySelect(sbjctId) > 0) {
                        throw new BusinessException("score.alert.invalid.ratio.srvy"); // 설문의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
                case "SMNR":
                    if (markSubjectDAO.invalidMrkRfltrtSumSmnrSelect(sbjctId) > 0) {
                        throw new BusinessException("score.alert.invalid.ratio.smnr"); // 세미나의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
                    }
                    break;
            }
            mrkItmStngMap.put(mrkItmTycd, mrkRfltrt);

            totMrkRfltrt = totMrkRfltrt.add(mrkRfltrt);
        }

        if ( totMrkRfltrt.compareTo(HUNDRED) != 0 ) throw new BusinessException("해당 과목의 성적항목 비율 총합을 100으로 설정한 후 성적처리 가능합니다.");

        // 성적반영비율 계산 (소수점 둘째자리까지 표현, 나머지 버림)
        mrkItmStngMap.replaceAll( (key, mrkRfltrt) -> mrkRfltrt.divide(HUNDRED, 2, RoundingMode.DOWN) );

        return mrkItmStngMap;
    }


    /**
     * 과목의 성적항목별 평균점수 조회
     * (key: mrkItmTycd, value: avgScr)
     * @param sbjctId
     * @return
     */
    @Override
    public Map<String, Double> getAvgScrInfoByMrkItm(String sbjctId) {
        Map<String, Double> avgScrInfo = new HashMap<>();

        List<EgovMap> avgScrInfoMap = markSubjectDAO.AvgScrInfoByMrkItmSelect(sbjctId);
        for (EgovMap map : avgScrInfoMap) {
            avgScrInfo.put((String) map.get("mrkItmTycd"), Double.parseDouble(map.get("avgScr").toString()));
        }

        return avgScrInfo;
    }

    /**
     * 과목의 점수 구간별 인원수 조회
     * @param sbjctId
     * @return
     */
    @Override
    public EgovMap getMrkRangeStatus(String sbjctId) {
        return markSubjectDAO.mrkRangeStatusSelect(sbjctId);
    }

    /**
     * 성적처리 예외처리 페이징 목록 조회
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<EgovMap> mrkProcExcpProcListPaging(PageInfo pageInfo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<>(pageInfo);

        List<EgovMap> returnList = markSubjectDAO.mrkProcExcpProcListPaging(pageInfo);

        if(!returnList.isEmpty()) {
            resultDTO.getPageInfo().setTotalRecordCount(Integer.parseInt(returnList.get(0).get("totalCnt").toString()));
        } else {
            resultDTO.getPageInfo().setTotalRecordCount(0);
        }

        resultDTO.setReturnList(returnList);

        return resultDTO.setResultSuccess();
    }

    /**
     * 성적처리 예외처리 페이징 목록 조회
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<EgovMap> allMrkProcExcpProcListPaging(PageInfo pageInfo) {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<>(pageInfo);

        List<EgovMap> returnList = markSubjectDAO.allMrkProcExcpProcListPaging(pageInfo);

        if(!returnList.isEmpty()) {
            resultDTO.getPageInfo().setTotalRecordCount(Integer.parseInt(returnList.get(0).get("totalCnt").toString()));
        } else {
            resultDTO.getPageInfo().setTotalRecordCount(0);
        }

        resultDTO.setReturnList(returnList);

        return resultDTO.setResultSuccess();
    }

    /**
     * 성적처리 예외처리 건 일괄 등록
     * @param list
     * @param rgtrId
     */
    @Override
    public void mrkProcExcpProcRegist(List<MrkProcExcpProcVO> list, String rgtrId) {

        for (MrkProcExcpProcVO vo : list) {
            vo.setRgtrId(rgtrId);
            vo.setMrkProcExcpProcId(IdGenUtil.genNewId(IdPrefixType.MRPEP));
        }

        markSubjectDAO.mrkProcExcpProcListBatchInsert(list);
    }

    /**
     * 성적처리 예외처리 건 일괄 삭제
     * @param list (@required mrkProcExcpProcId, sbjctId)
     */
    @Override
    public void mrkProcExcpProcDelete(List<MrkProcExcpProcVO> list) {
        markSubjectDAO.mrkProcExcpProcListBatchDelete(list);
    }

    /**
     * 중간/기말 결시 인원 카운트
     * - 중간 결시 제출/승인
     * - 기말 결시 제출/승인
     * @param sbjctId
     * @return
     */
    public Map<String, Integer> getAbsnceCnt(String sbjctId) {
        Map<String, Integer> absnceCntSummary = new HashMap<>();

        List<EgovMap> absnceList = examDAO.listAbsnceBySbjctId(sbjctId);
        int midAplyCnt = 0; int midAprvCnt = 0; int lstAplyCnt = 0; int lstAprvCnt = 0;

        for (EgovMap absnceInfo : absnceList) {
            String absnceAplyStscd = (String) absnceInfo.get("absnceAplyStscd");
            String examGbncd = (String) absnceInfo.get("examGbncd");

            boolean isAprv = "APRV".equals(absnceAplyStscd);
            boolean isMid = "MID".equals(examGbncd);

            if (isAprv && isMid)       midAprvCnt++;
            else if (isAprv && !isMid) midAplyCnt++;
            else if (!isAprv && isMid) lstAprvCnt++;
            else                       lstAplyCnt++;
        }

        absnceCntSummary.put("midAplyCnt", midAplyCnt);
        absnceCntSummary.put("midAprvCnt", midAprvCnt);
        absnceCntSummary.put("lstAplyCnt", midAplyCnt);
        absnceCntSummary.put("lstAprvCnt", midAprvCnt);

        return absnceCntSummary;
    }
}