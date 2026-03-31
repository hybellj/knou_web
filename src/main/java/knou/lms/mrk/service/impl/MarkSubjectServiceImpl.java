package knou.lms.mrk.service.impl;

import knou.framework.util.StringUtil;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.mrk.dao.MarkSubjectDAO;
import knou.lms.mrk.service.MarkSubjectService;
import knou.lms.mrk.vo.MarkSubjectDetailVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("markSubjectService")
public class MarkSubjectServiceImpl implements MarkSubjectService {

    @Resource(name="markSubjectDAO")
    private MarkSubjectDAO markSubjectDAO;
    @Autowired
    private ExamDAO examDAO;

    /**
     * 학습자의 성적 목록을 가져온다.
     * @param searchMap
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> stdMrkList(EgovMap searchMap) throws Exception {
        List<EgovMap> stdMrkList = new ArrayList<>();

        String searchType = StringUtil.nvl(searchMap.get("searchType"));

        // 해당하는 학생 목록 가져오기
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
        }

        searchMap.put("stdNos", stdNos);

        stdMrkList = markSubjectDAO.stdMrkList(searchMap);

        return stdMrkList;
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
     * 과제 성적비율 합 100% 여부 체크
     *  1 : 성적비율 합 != 100%
     *  0 : 성적비율 합 = 100%
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public int invalidMrkRfltrtSumAsmtSelect(String sbjctId) throws Exception {
        return markSubjectDAO.invalidMrkRfltrtSumAsmtSelect(sbjctId);
    }

    /**
     * 퀴즈 성적비율 합 100% 여부 체크
     *  1 : 성적비율 합 != 100%
     *  0 : 성적비율 합 = 100%
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public int invalidMrkRfltrtSumQuizSelect(String sbjctId) throws Exception {
        return markSubjectDAO.invalidMrkRfltrtSumQuizSelect(sbjctId);
    }

    /**
     * 토론 성적비율 합 100% 여부 체크
     *  1 : 성적비율 합 != 100%
     *  0 : 성적비율 합 = 100%
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public int invalidMrkRfltrtSumDscsSelect(String sbjctId) throws Exception {
        return markSubjectDAO.invalidMrkRfltrtSumDscsSelect(sbjctId);
    }

    /**
     * 세미나 성적비율 합 100% 여부 체크
     *  1 : 성적비율 합 != 100%
     *  0 : 성적비율 합 = 100%
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public int invalidMrkRfltrtSumSmnrSelect(String sbjctId) throws Exception {
        return markSubjectDAO.invalidMrkRfltrtSumSmnrSelect(sbjctId);
    }

    /**
     * 설문 성적비율 합 100% 여부 체크
     *  1 : 성적비율 합 != 100%
     *  0 : 성적비율 합 = 100%
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public int invalidMrkRfltrtSumSrvySelect(String sbjctId) throws Exception {
        return markSubjectDAO.invalidMrkRfltrtSumSrvySelect(sbjctId);
    }

    /**
     * 해당 과정 내 전체 학생들의 성적 삭제
     * @param sbjctId
     * @throws Exception
     */
    @Override
    public void allStdMrkSbjctDelete(String sbjctId) throws Exception {
        markSubjectDAO.allStdMrkSbjctDelete(sbjctId);
    }

    /**
     * 해당 과정 내 전체 학생들의 상세 성적 삭제
     * @param sbjctId
     * @throws Exception
     */
    @Override
    public void allStdMrkSbjctDtlDelete(String sbjctId) throws Exception {
        markSubjectDAO.allStdMrkSbjctDtlDelete(sbjctId);
    }

    /**
     * 해당 과정 내 전체 학생들의 아이디 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
//    public List<EgovMap> stdMrkSbjctList(String sbjctId) throws Exception {
    public List<MarkSubjectVO> stdMrkSbjctList(String sbjctId) throws Exception {
        return markSubjectDAO.stdMrkSbjctList(sbjctId);
    }


    /**
     * 학생들의 중간or기말 고사 평가점수 조회
     * @param sbjctId
     * @param searchKey //MID or LST
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> examEvlScoreList(String sbjctId, String searchKey) throws Exception {

        return markSubjectDAO.examEvlScoreList(sbjctId, searchKey);
    }

    /**
     * 학생들의 세미나 평가점수 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> smnrScoreEvlList(String sbjctId) throws Exception {

        return markSubjectDAO.smnrEvlScoreList(sbjctId);
    }

    /**
     * 성적이의 신청으로 승인된 학생들의 가산점 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public Map<String, Double> adtnScoreList(String sbjctId) throws Exception {
        Map<String, Double> resultMap = new HashMap<>();

        List<EgovMap> adtnScoreList = markSubjectDAO.adtnScoreList(sbjctId);

        if (adtnScoreList.isEmpty()) return resultMap;

        for (EgovMap stdAdtnScr : adtnScoreList) {
            String userId = (String) stdAdtnScr.get("userId");
            double adtnScr = ((Number) stdAdtnScr.get("objctAplyScr")).doubleValue();
            resultMap.put(userId, adtnScr);
        }

        return resultMap;
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

    /**
     * 학생들의 과제 평가점수 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> asmtScoreEvlList(String sbjctId) throws Exception {
        return markSubjectDAO.asmtEvlScoreList(sbjctId);
    }

    /**
     * 학생들의 토론 평가점수 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> dscsScoreEvlList(String sbjctId) throws Exception {
        return markSubjectDAO.dscsEvlScoreList(sbjctId);
    }

    /**
     * 학생들의 퀴즈 평가점수 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> quizScoreEvlList(String sbjctId) throws Exception {
        return markSubjectDAO.quizEvlScoreList(sbjctId);
    }

    /**
     * 학생들의 설문 평가점수 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> srvyScoreEvlList(String sbjctId) throws Exception {
        return markSubjectDAO.srvyEvlScoreList(sbjctId);
    }

    /**
     * 학생 성적과목 리스트 INSERT
     * @param mrksbjctList
     * @return
     * @throws Exception
     */
    @Override
    public int mrkSbjctBatchInsert(List<MarkSubjectVO> mrksbjctList) throws Exception {
        return markSubjectDAO.mrkSbjctBatchInsert(mrksbjctList);
    }

    /**
     * 학생 성적과목상세 리스트 INSERT
     * @param mrksbjctDtlList
     * @return
     * @throws Exception
     */
    @Override
    public int mrkSbjctDtlBatchInsert(List<MarkSubjectDetailVO> mrksbjctDtlList) throws Exception {
        return markSubjectDAO.mrkSbjctDtlBatchInsert(mrksbjctDtlList);
    }

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
}


