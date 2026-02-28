package knou.lms.exam.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

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
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.exam.dao.ExamStareDAO;
import knou.lms.exam.dao.ExamStareHstyDAO;
import knou.lms.exam.dao.ExamStarePaperDAO;
import knou.lms.exam.dao.ExamStarePaperHstyDAO;
import knou.lms.exam.service.ExamService;
import knou.lms.exam.service.ExamStarePaperService;
import knou.lms.exam.vo.ExamStareHstyVO;
import knou.lms.exam.vo.ExamStarePaperHstyVO;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.exam.vo.ExamVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;

@Service("examStarePaperService")
public class ExamStarePaperServiceImpl extends ServiceBase implements ExamStarePaperService {

    @Resource(name="examStarePaperDAO")
    private ExamStarePaperDAO examStarePaperDAO;
    
    @Resource(name="examStareDAO")
    private ExamStareDAO examStareDAO;
    
    @Resource(name="examDAO")
    private ExamDAO examDAO;
    
    @Resource(name="examStareHstyDAO")
    private ExamStareHstyDAO examStareHstyDAO;
    
    @Resource(name="examStarePaperHstyDAO")
    private ExamStarePaperHstyDAO examStarePaperHstyDAO;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Autowired
    private ExamService examService;

    /*****************************************************
     * <p>
     * TODO 시험지 문제 목록 조회
     * </p>
     * 시험지 문제 목록 조회
     * 
     * @param ExamStarePaperVO
     * @return List<?>
     * @throws Exception
     ******************************************************/
    @Override
    public List<?> paperQstnlist(ExamStarePaperVO vo) throws Exception {
        List<?> paperList = examStarePaperDAO.paperQstnlist(vo);
        return paperList;
    }

    /*****************************************************
     * <p>
     * TODO 학생의 시험지 문제 조회
     * </p>
     * 학생의 시험지 문제 조회
     * 
     * @param ExamStarePaperVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listStdStarePaper(ExamStarePaperVO vo) throws Exception {
        List<EgovMap> egovList = examStarePaperDAO.listStdStarePaper(vo);
        for(EgovMap emap : egovList) {
            byte[] phtFile = (byte[]) emap.get("regPhtFile");
            if (phtFile != null && phtFile.length > 0) {
                emap.put("regPhtFile", "data:image/png;base64," + new String(Base64.getEncoder().encode(phtFile)));
            }
        }
        if("EVAL".equals(StringUtil.nvl(vo.getSearchType()))) {
            ExamStarePaperVO qstnVo = new ExamStarePaperVO();
            qstnVo.setMdfrId(vo.getMdfrId());
            qstnVo.setExamCd(vo.getExamCd());
            qstnVo.setStdNo(vo.getStdNo());
            for (EgovMap paperMap : egovList)
            {
                if ("CHOICE".equals(paperMap.get("qstnTypeCd")) || "MULTICHOICE".equals(paperMap.get("qstnTypeCd")) || "MATCH".equals(paperMap.get("qstnTypeCd")))
                { // 객관식, 짝짓기형 문제
                    List<String> choiceTitleList = new ArrayList<String>(); // 문항의 보기 제목(원래 순서)
                    choiceTitleList.add(paperMap.get("empl1")==null?"":paperMap.get("empl1").toString());
                    choiceTitleList.add(paperMap.get("empl2")==null?"":paperMap.get("empl2").toString());
                    choiceTitleList.add(paperMap.get("empl3")==null?"":paperMap.get("empl3").toString());
                    choiceTitleList.add(paperMap.get("empl4")==null?"":paperMap.get("empl4").toString());
                    choiceTitleList.add(paperMap.get("empl5")==null?"":paperMap.get("empl5").toString());
                    choiceTitleList.add(paperMap.get("empl6")==null?"":paperMap.get("empl6").toString());
                    choiceTitleList.add(paperMap.get("empl7")==null?"":paperMap.get("empl7").toString());
                    choiceTitleList.add(paperMap.get("empl8")==null?"":paperMap.get("empl8").toString());
                    choiceTitleList.add(paperMap.get("empl9")==null?"":paperMap.get("empl9").toString());
                    choiceTitleList.add(paperMap.get("empl10")==null?"":paperMap.get("empl10").toString());

                    // 랜던하게 섞인 선택지를 리스트에 담기
                    List<String> choiceList = new ArrayList<String>();
                    List<String> oppositeList = new ArrayList<String>();
                    String[] randomQstn = paperMap.get("examOdr").toString().split("\\,");
                    String[] arrOpposite = paperMap.get("rgtAnsr1").toString().split("\\|");
                    for (String qstnNo : randomQstn)
                    {
                        if (StringUtil.isNotNull(choiceTitleList.get(Integer.parseInt(qstnNo) - 1)))
                        {
                            choiceList.add(qstnNo);
                            if ("MATCH".equals(paperMap.get("qstnTypeCd"))) {
                                oppositeList.add(arrOpposite[Integer.parseInt(qstnNo) - 1]);
                            }
                        }
                    }


                    if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                    { // 제출한 답이 있으면
                        if ("CHOICE".equals(paperMap.get("qstnTypeCd")) || "MULTICHOICE".equals(paperMap.get("qstnTypeCd")))
                        { // 객관식
                            String[] arrAnswer = paperMap.get("stareAnsr").toString().split("\\,");
                            String convertAnswer = "";
                            for (int i = 0; i < arrAnswer.length; i++)
                            {
                                if (i > 0)
                                {
                                    convertAnswer += ",";
                                }
                                convertAnswer += choiceList.get(Integer.parseInt(arrAnswer[i]) - 1);
                            }
                            String[] answers = convertAnswer.split("\\,");
                            Arrays.sort(answers);
                            convertAnswer = String.join(",", answers);

                            if (convertAnswer.equals(paperMap.get("rgtAnsr1"))) {
                                paperMap.put("ansrYn", "Y");
                            } 
                            
                            if ("Y".equals(paperMap.get("errorAnsrYn"))) {
                                paperMap.put("ansrYn", "Y");
                            }
                        }
                        else // 짝짓기 형
                        {
                            String convertAnswer = String.join("|", oppositeList);
                            if (convertAnswer.equals(paperMap.get("stareAnsr"))) {
                                paperMap.put("ansrYn", "Y");
                            } 
                        }
                    }

                }
                else if ("SHORT".equals(paperMap.get("qstnTypeCd")))
                { // 주관식(단답형) 문제
                    if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                    { // 제출한 답이 있으면
                        if("Y".equals(StringUtil.nvl(paperMap.get("multiRgtChoiceYn")))) {//복수정답 여부(복수)
                            boolean grading = false;
                            if("A".equals(StringUtil.nvl(paperMap.get("multiRgtChoiceTypeCd")))) {//복수정답 유형(순서에 맞게정담)
                                String[] ansrArr = paperMap.get("stareAnsr").toString().split("\\|");
                                for(int k = 0; k < ansrArr.length; k++) {
                                    String[] rgtAnsrArr = StringUtil.nvl(paperMap.get("rgtAnsr"+(k+1))).split("\\|");
                                    for(int t = 0; t < rgtAnsrArr.length; t++) {
                                        if(ansrArr[k].equals(rgtAnsrArr[t])) { // 정답비교
                                            grading = true;
                                        }
                                    }
                                    if(!grading) {
                                        break;
                                    } else if(k != ansrArr.length - 1) {
                                        grading = false;
                                    } else {
                                        paperMap.put("ansrYn", "Y");
                                    }
                                }
                            }else if("B".equals(StringUtil.nvl(paperMap.get("multiRgtChoiceTypeCd")))||"C".equals(StringUtil.nvl(paperMap.get("multiRgtChoiceTypeCd")))) {//복수정답 유형(순서에 상관없이 정답)
                                String[] ansrArr = paperMap.get("stareAnsr").toString().split("\\|");
                                if(!"".equals(ansrArr[0])) {
                                    HashMap<String, String> ansrMap = new HashMap<String, String>();
                                    for (int k = 0; k < ansrArr.length; k++) {
                                        ansrMap.put(StringUtil.nvl(paperMap.get("rgtAnsr"+(k+1))), "N");
                                    }
                                    for (int k = 0; k < ansrArr.length; k++) {
                                        for(int t = 0; t < ansrArr.length; t++) {
                                            if(!"Y".equals(ansrMap.get(StringUtil.nvl(paperMap.get("rgtAnsr"+(t+1)))))) {
                                                String[] rgtAnsrArr = StringUtil.nvl(paperMap.get("rgtAnsr"+(t+1))).split("\\|");
                                                for(int o = 0; o < rgtAnsrArr.length; o++) {
                                                    if(ansrArr[k].equals(rgtAnsrArr[o])) {
                                                        grading = true;
                                                        ansrMap.put(StringUtil.nvl(paperMap.get("rgtAnsr"+(t+1))), "Y");
                                                    }
                                                }
                                            }
                                        }
                                        if(!grading) {
                                            break;
                                        } else if(k != ansrArr.length - 1) {
                                            grading = false;
                                        } else {
                                            paperMap.put("ansrYn", "Y");
                                        }
                                    }
                                }
                            }
                        }else {//복수정답 여부(단수)
                            String[] rgtAnsrArr = StringUtil.nvl(paperMap.get("rgtAnsr1")).split("\\|");
                            for(int k = 0; k < rgtAnsrArr.length; k++) {
                                if(StringUtil.nvl(paperMap.get("stareAnsr")).equals(rgtAnsrArr[k])) {
                                    paperMap.put("ansrYn", "Y");
                                    break;
                                }
                            }
                        }
                    } 
                }
                else if ("OX".equals(paperMap.get("qstnTypeCd")))
                {
                    if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                    { // 제출한 답이 있으면
                        if (paperMap.get("rgtAnsr1").toString().equals(paperMap.get("stareAnsr"))) {
                            paperMap.put("ansrYn", "Y");
                        }
                    }
                }
            } // 문항별 for문 종료
        }
        
        return egovList;
    }

    /*****************************************************
     * <p>
     * TODO 시험문항 학습자 점수 수정 (단일)
     * </p>
     * 시험문항 학습자 점수 수정 (단일)
     * 
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateQstnPaperScore(ExamStarePaperVO vo) throws Exception {
        String[] stdScoreList = StringUtil.nvl(vo.getStdScores()).split(",");
        float totGetScore = 0.0f;
        
        for(int i = 0; i < stdScoreList.length; i++) {
            Integer examQstnSn = Integer.parseInt(StringUtil.nvl(stdScoreList[i], "0").split("\\|")[0]);
            float getScore = Float.parseFloat(StringUtil.nvl(stdScoreList[i], "0").split("\\|")[1]);
            vo.setExamQstnSn(examQstnSn);
            vo.setGetScore(getScore);
            examStarePaperDAO.updateStarePaper(vo);
        }
        
        ExamStarePaperVO pvo = new ExamStarePaperVO();
        pvo.setExamCd(vo.getExamCd());
        pvo.setStdNo(vo.getStdNo());
        List<EgovMap> paperList = (List<EgovMap>)examStarePaperDAO.paperQstnlist(pvo);
        for(EgovMap egov : paperList) {
            float getScore = 0.0f;
            if(egov.get("getScore") != null) {
                getScore = Float.parseFloat(egov.get("getScore").toString());
            }
            totGetScore += getScore;
        }
        
        if(totGetScore > 100) {
            totGetScore = 100.0f;
        } else if(totGetScore < 0) {
            totGetScore = 0.0f;
        }
        
        ExamStareVO stareVO = new ExamStareVO();
        stareVO.setExamCd(vo.getExamCd());
        stareVO.setStdId(vo.getStdNo());
        stareVO.setMdfrId(vo.getMdfrId());
        stareVO.setTotGetScore(totGetScore);
        stareVO.setEvalYn("Y");
        examStareDAO.updateExamStare(stareVO);
    }
    
    /*****************************************************
     * <p>
     * TODO 시험문항별 학습자 점수 수정 (다수)
     * </p>
     * 시험문항별 학습자 점수 수정 (다수)
     * 
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateQstnPaperStdScore(ExamStarePaperVO vo) throws Exception {
        //학습자정보
        ExamStareVO esvo = new ExamStareVO();
        esvo.setExamCd(vo.getExamCd());
        esvo.setStareStatusCd("C");
        List<EgovMap> listStdVo = examStareDAO.listExamTargetStd(esvo);
        
        
        String[] stdScoreList = vo.getStdScores().split(",");
        for(int i=0; i<stdScoreList.length; i++) {
            String[] stdScore = StringUtil.nvl(stdScoreList[i]).split("\\|");
            String stdNo = stdScore[0];
            float getScore = Float.parseFloat(StringUtil.nvl(stdScore[1],"0.0f"));
            
            vo.setExamCd(vo.getExamCd());
            vo.setExamQstnSn(vo.getExamQstnSn());
            vo.setStdNo(stdNo);
            vo.setGetScore(getScore);
            vo.setMdfrId(vo.getMdfrId());
            ExamStarePaperVO espvo = examStarePaperDAO.select(vo);
            examStarePaperDAO.updateStarePaper(vo);
            
            //전체점수 가감
            for (int j = 0; j < listStdVo.size(); j++) {
                EgovMap egovMap = listStdVo.get(j);
                String mapStdNo = StringUtil.nvl(egovMap.get("stdNo"));
                if(stdNo.equals(mapStdNo)) {
                    ExamStareVO examStareVO = new ExamStareVO();
                    examStareVO.setExamCd(vo.getExamCd());
                    examStareVO.setMdfrId(vo.getMdfrId());
                    examStareVO.setStareStatusCd("C");
                    
                    float preSumGetScore = Float.parseFloat(StringUtil.nvl(egovMap.get("stareScore"),"0.0f"));     //응시점수 합산
                    float preGetScore = espvo.getGetScore();
                    
                    float scoreGap = getScore - preGetScore;                                                      //해당 문제의 부여응시점수 와 전점수 차이
                    
                    //점수계산
                    examStareVO.setTotGetScore(preSumGetScore + scoreGap);
                    
                    if(examStareVO.getTotGetScore() > 100) {
                        //최대 평가점수 초과 방지
                        examStareVO.setTotGetScore(100.0f);
                    }else if(examStareVO.getTotGetScore() < 0) {
                        //최소 평가점수 미만 방지
                        examStareVO.setTotGetScore(0.0f);
                    }
                    
                    List<String> listTargetStdNo = new ArrayList<>();
                    listTargetStdNo.add(mapStdNo);
                    examStareVO.setStdNoList(listTargetStdNo);
                    examStareDAO.updateExamStareScore(examStareVO);
                }
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 시험 응시 시작
     * </p>
     * 시험 응시 시작
     * 
     * @param ForumStareVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> startStdExamStare(ExamStareVO vo, HttpServletRequest request) throws Exception {
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        Map<String, Object> convertMap = new HashMap<>();
        convertMap.put("1", "A");
        convertMap.put("2", "B");
        convertMap.put("3", "C");
        convertMap.put("4", "D");
        convertMap.put("5", "E");
        convertMap.put("6", "F");
        convertMap.put("7", "G");
        convertMap.put("8", "H");
        convertMap.put("9", "I");
        convertMap.put("10", "J");

        ProcessResultVO<EgovMap> resultMap = new ProcessResultVO<>();

        // 0. 시험 기본정보 조회
        ExamVO examParamVO = new ExamVO();
        examParamVO.setExamCd(vo.getExamCd());
        ExamVO examVO = examDAO.select(examParamVO);
        if (examVO == null)
        {
            throw processException("exam.error.invalid"); // 유효하지 않은 시험입니다.
        }

        // 1. 시험시간 업데이트(제한시간 배정여부가 Y이면 시험창이 닫혀 있어도 시간이 흘러야 하기 때문에 업데이트 한다)
        vo.setStareTm(1);
        examStareDAO.updateExamStart(vo);
        
        // 2. 학생의 시험응시 가능 정보 조회
        EgovMap examStdStareMap = examStareDAO.selectExamStdStareInfo(vo);
        if (examStdStareMap == null || examStdStareMap.isEmpty())
        {
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setUserId(userId);
            stdVO.setStdId(vo.getStdId());
            stdVO = stdDAO.selectStd(stdVO);
            if(stdVO == null) {
                throw processException("exam.error.not.stareuser"); // 응시 대상자가 아닙니다.
            } else {
                List<StdVO> stdList = new ArrayList<>();
                stdList.add(stdVO);
                examVO.setSearchKey("ONE");
                examService.insertRandomPaper(examVO, stdList);
                examStdStareMap = examStareDAO.selectExamStdStareInfo(vo);
            }
        } else {
            // 시험지 등록 안되어 있으면 추가
            ExamStarePaperVO espvo = new ExamStarePaperVO();
            espvo.setExamCd(vo.getExamCd());
            espvo.setStdNo(vo.getStdId());
            List<?> paperList = examStarePaperDAO.paperQstnlist(espvo);
            if(paperList.size() == 0) {
                StdVO stdVO = new StdVO();
                stdVO.setCrsCreCd(vo.getCrsCreCd());
                stdVO.setUserId(userId);
                stdVO.setStdId(vo.getStdId());
                stdVO = stdDAO.selectStd(stdVO);
                List<StdVO> stdList = new ArrayList<>();
                stdList.add(stdVO);
                examVO.setSearchKey("ONE");
                examService.insertRandomPaper(examVO, stdList);
            }
        }

        // 3. 시험 기간 인지 검사
        if ("N".equals(examStdStareMap.get("starePeriodYn")))
        {
            throw processException("exam.error.not.exampeiod"); // 시험기간이 아닙니다.
        }

        // 4. 시험 응시 횟수 검사
        //if (Integer.parseInt(examStdStareMap.get("leftCnt").toString()) <= 0)
        //{
        //    resultMap.setResult(-1);
        //    resultMap.setMessage(messageSource.getMessage("exam.error.exceed.starecount", null, locale));   // 시험 응시 가능횟수를 모두 소진하여 더 이상 응시할 수 없습니다.
        //    return resultMap;
        //}

        // 5. 남은 시험 응시 시간 검사
        if (Integer.parseInt(examStdStareMap.get("leftTm").toString()) <= 0)
        {
            throw processException("exam.error.exceed.staretime"); // 시험 응시 시간을 초과하였습니다.
        }

        // 6. 이미 시험 응시를 완료했는지 검사
        if (examStdStareMap.get("endDttm") != null)
        {
            throw processException("exam.error.stare.finished"); // 시험지 제출을 이미 완료하였습니다.
        }

        // 7. 시험 문항 조회
        ExamStarePaperVO starePaperVO = new ExamStarePaperVO();
        starePaperVO.setExamCd(vo.getExamCd());
        starePaperVO.setStdNo(vo.getStdId());
        List<EgovMap> paperList = examStarePaperDAO.listStdStarePaper(starePaperVO);
        for (EgovMap paperMap : paperList)
        {

            if ("CHOICE".equals(paperMap.get("qstnTypeCd")) || "MULTICHOICE".equals(paperMap.get("qstnTypeCd")) || "MATCH".equals(paperMap.get("qstnTypeCd")))
            { // 객관식, 짝짓기형 문제
                List<String> choiceTitleList = new ArrayList<>(); // 문항의 보기 제목(원래 순서)
                choiceTitleList.add(paperMap.get("empl1")==null?"":paperMap.get("empl1").toString());
                choiceTitleList.add(paperMap.get("empl2")==null?"":paperMap.get("empl2").toString());
                choiceTitleList.add(paperMap.get("empl3")==null?"":paperMap.get("empl3").toString());
                choiceTitleList.add(paperMap.get("empl4")==null?"":paperMap.get("empl4").toString());
                choiceTitleList.add(paperMap.get("empl5")==null?"":paperMap.get("empl5").toString());
                choiceTitleList.add(paperMap.get("empl6")==null?"":paperMap.get("empl6").toString());
                choiceTitleList.add(paperMap.get("empl7")==null?"":paperMap.get("empl7").toString());
                choiceTitleList.add(paperMap.get("empl8")==null?"":paperMap.get("empl8").toString());
                choiceTitleList.add(paperMap.get("empl9")==null?"":paperMap.get("empl9").toString());
                choiceTitleList.add(paperMap.get("empl10")==null?"":paperMap.get("empl10").toString());

                // 랜던하게 섞인 선택지를 리스트에 담기
                List<Map<String, Object>> choiceList = new ArrayList<>();
                String[] randomQstn = paperMap.get("examOdr").toString().split("\\,");
                int idx = 0;
                for (String qstnNo : randomQstn)
                {
                    if (StringUtil.isNotNull(choiceTitleList.get(Integer.parseInt(qstnNo) - 1)))
                    {
                        Map<String, Object> examQstnChoiceMap = new HashMap<>();
                        examQstnChoiceMap.put("qstnNo", idx + 1);
                        examQstnChoiceMap.put("title", StringUtil.fn_html_text_convert(choiceTitleList.get(Integer.parseInt(qstnNo) - 1)));
                        choiceList.add(examQstnChoiceMap);
                        idx++;
                    }
                }
                paperMap.put("choiceList", choiceList);

                if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                { // 제출한 답이 있으면
                    if ("CHOICE".equals(paperMap.get("qstnTypeCd")) || "MULTICHOICE".equals(paperMap.get("qstnTypeCd")))
                    { // 객관식
                        paperMap.put("arrAnswer", paperMap.get("stareAnsr").toString().split("\\,"));
                        String formattedAnswers = "";
                        String[] arrAnswer = (String[])paperMap.get("arrAnswer");
                        for (int i = 0; i < arrAnswer.length; i++)
                        {
                            if (i > 0)
                            {
                                formattedAnswers += ",";
                            }
                            formattedAnswers += convertMap.get(arrAnswer[i]);
                        }
                        paperMap.put("formattedStareAnsr", formattedAnswers);
                    }
                    else
                    {
                        paperMap.put("arrAnswer", paperMap.get("stareAnsr").toString().split("\\|"));
                    }
                }
                else
                { // 제출한 답이 없을때
                    if ("MATCH".equals(paperMap.get("qstnTypeCd")))
                    { // 짝짓기형
                        List<Map<String, Object>> oppsiteList = new ArrayList<>();
                        String[] arrOppsite = paperMap.get("rgtAnsr1").toString().split("\\|");
                        List<Integer> randomList = getRandomList(arrOppsite.length);
                        for (Integer i : randomList)
                        {
                            Map<String, Object> examQstnChoiceMap = new HashMap<>();
                            examQstnChoiceMap.put("qstnNo", i + 1);
                            examQstnChoiceMap.put("title", arrOppsite[i]);
                            oppsiteList.add(examQstnChoiceMap);
                        }
                        paperMap.put("oppositeList", oppsiteList);
                    }
                }

            }
            else if ("SHORT".equals(paperMap.get("qstnTypeCd")))
            { // 주관식(단답형) 문제
                if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                { // 제출한 답이 있으면
                    paperMap.put("arrAnswer", paperMap.get("stareAnsr").toString().split("\\|"));
                }
            }
        }
        examStdStareMap.put("qstns", paperList);

        // 8. 시험 응시 시작일시 및 응시횟수 업데이트
        // 제한시간 배정여부가 Y이면 (현재시간 - 최초응시시간)으로 업데이트
        // 제한시간 배정여부가 N이면 시간 업데이트 하지 않음
        vo.setStareTm(-1);
        examStareDAO.updateExamStart(vo);

        // 9. 시험 응시 이력 생성
        ExamStareHstyVO examStareHstyVO = new ExamStareHstyVO();
        examStareHstyVO.setExamCd(vo.getExamCd());
        examStareHstyVO.setStdNo(vo.getStdId());
        examStareHstyVO.setMdfrId(vo.getMdfrId());
        examStareHstyVO.setRgtrId(vo.getRgtrId());
        examStareHstyVO.setConnIp(StringUtil.nvl(connIp, "0:0:0:0:0:0:0:1"));
        examStareHstyVO.setHstyTypeCd("START");
        examStareHstyDAO.insertExamStareHsty(examStareHstyVO);

        // 10. 시험 응시 문항 이력 생성
        ExamStarePaperHstyVO examStarePaperHstyVO = new ExamStarePaperHstyVO();
        examStarePaperHstyVO.setExamCd(vo.getExamCd());
        examStarePaperHstyVO.setStdNo(vo.getStdId());
        examStarePaperHstyVO.setMdfrId(vo.getMdfrId());
        examStarePaperHstyVO.setRgtrId(vo.getRgtrId());
        examStarePaperHstyVO.setStareHstySn(examStareHstyVO.getStareHstySn());
        examStarePaperHstyDAO.insertExamStarePaperHsty(examStarePaperHstyVO);

        // 11. 리턴
        examStdStareMap.put("examInfo", examVO);
        resultMap.setResult(1);
        resultMap.setReturnVO(examStdStareMap);

        return resultMap;
    }
    
    /*****************************************************
     * <p>
     * TODO 랜덤한 숫자 리스트 생성 및 반환.
     * </p>
     * 랜덤한 숫자 리스트 생성 및 반환.
     * 
     * @param int
     * @return List<Integer>
     * @throws Exception
     ******************************************************/
    private List<Integer> getRandomList(int size) throws Exception
    {
        Set<Integer> set = new HashSet<>();
        int setSize = 0;
        List<Integer> list = new ArrayList<Integer>();
        while (set.size() < size)
        {
            Double d = Math.random() * size;
            set.add(d.intValue());
            if (set.size() > setSize)
            {
                list.add(d.intValue());
                setSize = set.size();
            }
        }

        return list;
    }

    /*****************************************************
     * <p>
     * TODO 시험 제출
     * </p>
     * 시험 제출
     * 
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> complateExamStare(ExamStarePaperVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        ProcessResultVO<EgovMap> resultMap = new ProcessResultVO<EgovMap>();

        // 1. 시험 기본정보 조회
        ExamVO examParamVO = new ExamVO();
        examParamVO.setExamCd(vo.getExamCd());
        ExamVO examVO = examDAO.select(examParamVO);
        if (examVO == null)
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.invalid", null, locale)); // 유효하지 않은 시험입니다.
            return resultMap;
        }

       // 2. 학생의 시험응시 가능 정보 조회
        ExamStareVO stareVo = new ExamStareVO();
        stareVo.setExamCd(vo.getExamCd());
        stareVo.setStdId(vo.getStdNo());
        stareVo.setMdfrId(vo.getMdfrId());
        EgovMap examStdStareMap = examStareDAO.selectExamStdStareInfo(stareVo);
        if (examStdStareMap == null || examStdStareMap.isEmpty())
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.not.stareuser", null, locale));   // 응시 대상자가 아닙니다.
            return resultMap;
        }

        // 4. 시험 응시 횟수 검사
        //if (Integer.parseInt(examStdStareMap.get("leftCnt").toString()) <= 0)
        //{
        //    resultMap.setResult(-1);
        //    resultMap.setMessage(messageSource.getMessage("exam.error.exceed.starecount", null, locale));   // 시험 응시 가능횟수를 모두 소진하여 더 이상 응시할 수 없습니다.
        //    return resultMap;
        //}

        // 5. 남은 시험 응시 시간 검사
        if (Integer.parseInt(examStdStareMap.get("leftTm").toString()) <= 0)
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.exceed.staretime", null, locale));    // 시험 응시 시간을 초과하였습니다.
            return resultMap;
        }

        // 6. 이미 시험 응시를 완료했는지 검사
        if (examStdStareMap.get("endDttm") != null)
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.stare.finished", null, locale));  // 시험지 제출을 이미 완료하였습니다.
            return resultMap;
        }

        // 7. 응시를 하지 않고 완료하려는지 검사
        if (examStdStareMap.get("startDttm") == null || "".equals(examStdStareMap.get("startDttm")) )
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.no.stare", null, locale));    // 아직 응시하지 않은 시험입니다.
            return resultMap;
        }

        // 8. 시험 응시 상태 및 종료시간 업데이트.
        // 시간계산은 이력 테이블에서 해야 함. 또한 상태 컬럼도 추가해야 함.
        ExamStareHstyVO examStareHstyVO = new ExamStareHstyVO();
        examStareHstyVO.setExamCd(vo.getExamCd());
        examStareHstyVO.setStdNo(vo.getStdNo());
        examStareHstyVO.setMdfrId(vo.getMdfrId());
        examStareHstyVO.setRgtrId(vo.getRgtrId());
        ExamStareHstyVO stareTmVo = examStareHstyDAO.selectLastStareTm(examStareHstyVO);

        stareVo.setStareTm(stareTmVo.getStareTm());
        stareVo.setEndDttm("complete");
        stareVo.setTotGetScore(-1);
        examStareDAO.updateExamStareTempSave(stareVo);

        // 9. 시험 응시 문항 저장.
        List<String> examQstnSnList = vo.getExamQstnSnList();
        List<String> stareAnsrList = vo.getStareAnsrList();
        if (examQstnSnList != null && !examQstnSnList.isEmpty() && examQstnSnList.size() > 0)
        {
            ExamStarePaperVO qstnVo = new ExamStarePaperVO();
            qstnVo.setMdfrId(vo.getMdfrId());
            qstnVo.setExamCd(vo.getExamCd());
            qstnVo.setStdNo(vo.getStdNo());
            qstnVo.setGetScore(-1f);
            int idx = 0;
            for (String examQstnSn : examQstnSnList)
            {
                qstnVo.setExamQstnSn(Integer.parseInt(examQstnSn));
                qstnVo.setStareAnsr(stareAnsrList.get(idx));
                examStarePaperDAO.updateExamStarePaperTempSave(qstnVo);
                idx++;
            }
        }

        // 10. 정오답에 따른 문항별 점수 계산
        vo.setSearchGubun("COMPLETE");
        quizQstnScoreUpdate(vo);

        // 12. 시험 응시  이력 생성
        examStareHstyVO.setConnIp(connIp);
        examStareHstyVO.setHstyTypeCd("COMPLETE");
        examStareHstyDAO.insertExamStareHsty(examStareHstyVO);

        // 13. 시험 응시 문항 이력 생성
        ExamStarePaperHstyVO examStarePaperHstyVO = new ExamStarePaperHstyVO();
        examStarePaperHstyVO.setExamCd(vo.getExamCd());
        examStarePaperHstyVO.setStdNo(vo.getStdNo());
        examStarePaperHstyVO.setMdfrId(vo.getMdfrId());
        examStarePaperHstyVO.setRgtrId(vo.getRgtrId());
        examStarePaperHstyVO.setStareHstySn(examStareHstyVO.getStareHstySn());
        examStarePaperHstyDAO.insertExamStarePaperHsty(examStarePaperHstyVO);

        // 14. 리턴
        resultMap.setResult(1);
        return resultMap;
    }

    /*****************************************************
     * <p>
     * TODO 시험 임시 저장
     * </p>
     * 시험 임시 저장
     * 
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> saveTemporaryExamStare(ExamStarePaperVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        ProcessResultVO<EgovMap> resultMap = new ProcessResultVO<EgovMap>();

        // 1. 시험 기본정보 조회
        ExamVO examParamVO = new ExamVO();
        examParamVO.setExamCd(vo.getExamCd());
        ExamVO examVO = examDAO.select(examParamVO);
        if (examVO == null)
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.invalid", null, locale)); // 유효하지 않은 시험입니다.
            return resultMap;
        }

       // 2. 학생의 시험응시 가능 정보 조회
        ExamStareVO stareVo = new ExamStareVO();
        stareVo.setExamCd(vo.getExamCd());
        stareVo.setStdId(vo.getStdNo());
        stareVo.setMdfrId(vo.getMdfrId());
        EgovMap examStdStareMap = examStareDAO.selectExamStdStareInfo(stareVo);
        if (examStdStareMap == null || examStdStareMap.isEmpty())
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.not.stareuser", null, locale));   // 응시 대상자가 아닙니다.
            return resultMap;
        }

        // 4. 시험 응시 횟수 검사
        //if (Integer.parseInt(examStdStareMap.get("leftCnt").toString()) <= 0)
        //{
        //    resultMap.setResult(-1);
        //    resultMap.setMessage(messageSource.getMessage("exam.error.exceed.starecount", null, locale));   // 시험 응시 가능횟수를 모두 소진하여 더 이상 응시할 수 없습니다.
        //    return resultMap;
        //}

        // 5. 남은 시험 응시 시간 검사
        if (Integer.parseInt(examStdStareMap.get("leftTm").toString()) <= 0)
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.exceed.staretime", null, locale));    // 시험 응시 시간을 초과하였습니다.
            return resultMap;
        }

        // 6. 이미 시험 응시를 완료했는지 검사
        if (examStdStareMap.get("endDttm") != null)
        {
            resultMap.setResult(-1);
            resultMap.setMessage(messageSource.getMessage("exam.error.stare.finished", null, locale));  // 시험지 제출을 이미 완료하였습니다.
            return resultMap;
        }

        // 7. 시험 응시 임시저장.
        // 시간계산은 이력 테이블에서 해야 함.
        ExamStareHstyVO examStareHstyVO = new ExamStareHstyVO();
        examStareHstyVO.setExamCd(vo.getExamCd());
        examStareHstyVO.setStdNo(vo.getStdNo());
        examStareHstyVO.setMdfrId(vo.getMdfrId());
        examStareHstyVO.setRgtrId(vo.getRgtrId());
        ExamStareHstyVO stareTmVo = examStareHstyDAO.selectLastStareTm(examStareHstyVO);

        stareVo.setStareTm(stareTmVo.getStareTm());
        stareVo.setTotGetScore(-1);
        examStareDAO.updateExamStareTempSave(stareVo);

        // 8. 시험 응시 문항 임시저장.
        List<String> examQstnSnList = vo.getExamQstnSnList();
        List<String> stareAnsrList = vo.getStareAnsrList();
        if (examQstnSnList != null && !examQstnSnList.isEmpty() && examQstnSnList.size() > 0)
        {
            ExamStarePaperVO qstnVo = new ExamStarePaperVO();
            qstnVo.setMdfrId(vo.getMdfrId());
            qstnVo.setExamCd(vo.getExamCd());
            qstnVo.setStdNo(vo.getStdNo());
            qstnVo.setGetScore(-1f);
            int idx = 0;
            for (String examQstnSn : examQstnSnList)
            {
                qstnVo.setExamQstnSn(Integer.parseInt(examQstnSn));
                qstnVo.setStareAnsr(stareAnsrList.get(idx));
                examStarePaperDAO.updateExamStarePaperTempSave(qstnVo);
                idx++;
            }
        }
        
        // 정오답에 따른 문항별 점수 계산
        vo.setSearchGubun("RESTORE");
        quizQstnScoreUpdate(vo);

        // 9. 시험 응시 이력 생성
        examStareHstyVO.setConnIp(connIp);
        examStareHstyVO.setHstyTypeCd("RESTORE");
        examStareHstyDAO.insertExamStareHsty(examStareHstyVO);

        // 10. 시험 응시 문항 이력 생성
        ExamStarePaperHstyVO examStarePaperHstyVO = new ExamStarePaperHstyVO();
        examStarePaperHstyVO.setExamCd(vo.getExamCd());
        examStarePaperHstyVO.setStdNo(vo.getStdNo());
        examStarePaperHstyVO.setMdfrId(vo.getMdfrId());
        examStarePaperHstyVO.setRgtrId(vo.getRgtrId());
        examStarePaperHstyVO.setStareHstySn(examStareHstyVO.getStareHstySn());
        if("ONE".equals(StringUtil.nvl(vo.getSearchFrom()))) {
            String[] examQstnList = vo.getExamQstnSnList().toArray(new String[vo.getExamQstnSnList().size()]);
            examStarePaperHstyVO.setExamQstnSnList(examQstnList);
        }
        examStarePaperHstyDAO.insertExamStarePaperHsty(examStarePaperHstyVO);

        // 11. 리턴
        resultMap.setResult(1);

        return resultMap;
    }
    
    // 문항 점수 부여
    public void quizQstnScoreUpdate(ExamStarePaperVO vo) throws Exception {
        ExamStareVO stvo = new ExamStareVO();
        stvo.setExamCd(vo.getExamCd());
        stvo.setStdId(vo.getStdNo());
        stvo = examStareDAO.selectExamStareStd(stvo);
        int reExamAplyRatio = stvo != null && "Y".equals(stvo.getReExamYn()) ? stvo.getReExamAplyRatio() : 100;
        ExamStarePaperVO starePaperVO = new ExamStarePaperVO();
        starePaperVO.setExamCd(vo.getExamCd());
        starePaperVO.setStdNo(vo.getStdNo());
        List<EgovMap> paperList = examStarePaperDAO.listStdStarePaper(starePaperVO);
        ExamStarePaperVO qstnVo = new ExamStarePaperVO();
        qstnVo.setMdfrId(vo.getMdfrId());
        qstnVo.setExamCd(vo.getExamCd());
        qstnVo.setStdNo(vo.getStdNo());
        Boolean isDescribe = false;
        float totGetScore = 0.0f;
        for (EgovMap paperMap : paperList)
        {
            if ("DESCRIBE".equals(paperMap.get("qstnTypeCd")))
            {
                isDescribe = true;
                // 서술형은 제출시 채점하지 않음. 교수자가 평가시 채점함.
                continue;
            }
            
            qstnVo.setGetScore(0.0f);
            if ("CHOICE".equals(paperMap.get("qstnTypeCd")) || "MULTICHOICE".equals(paperMap.get("qstnTypeCd")) || "MATCH".equals(paperMap.get("qstnTypeCd")))
            { // 객관식, 짝짓기형 문제
                List<String> choiceTitleList = new ArrayList<String>(); // 문항의 보기 제목(원래 순서)
                choiceTitleList.add(paperMap.get("empl1")==null?"":paperMap.get("empl1").toString());
                choiceTitleList.add(paperMap.get("empl2")==null?"":paperMap.get("empl2").toString());
                choiceTitleList.add(paperMap.get("empl3")==null?"":paperMap.get("empl3").toString());
                choiceTitleList.add(paperMap.get("empl4")==null?"":paperMap.get("empl4").toString());
                choiceTitleList.add(paperMap.get("empl5")==null?"":paperMap.get("empl5").toString());
                choiceTitleList.add(paperMap.get("empl6")==null?"":paperMap.get("empl6").toString());
                choiceTitleList.add(paperMap.get("empl7")==null?"":paperMap.get("empl7").toString());
                choiceTitleList.add(paperMap.get("empl8")==null?"":paperMap.get("empl8").toString());
                choiceTitleList.add(paperMap.get("empl9")==null?"":paperMap.get("empl9").toString());
                choiceTitleList.add(paperMap.get("empl10")==null?"":paperMap.get("empl10").toString());

                // 랜던하게 섞인 선택지를 리스트에 담기
                List<String> choiceList = new ArrayList<String>();
                List<String> oppositeList = new ArrayList<String>();
                String[] randomQstn = paperMap.get("examOdr").toString().split("\\,");
                String[] arrOpposite = paperMap.get("rgtAnsr1").toString().split("\\|");
                for (String qstnNo : randomQstn)
                {
                    if (StringUtil.isNotNull(choiceTitleList.get(Integer.parseInt(qstnNo) - 1)))
                    {
                        choiceList.add(qstnNo);
                        if ("MATCH".equals(paperMap.get("qstnTypeCd"))) {
                            oppositeList.add(arrOpposite[Integer.parseInt(qstnNo) - 1]);
                        }
                    }
                }

                if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                { // 제출한 답이 있으면
                    if ("CHOICE".equals(paperMap.get("qstnTypeCd")) || "MULTICHOICE".equals(paperMap.get("qstnTypeCd")))
                    { // 객관식
                        String[] arrAnswer = paperMap.get("stareAnsr").toString().split("\\,");
                        String convertAnswer = "";
                        for (int i = 0; i < arrAnswer.length; i++)
                        {
                            if (i > 0)
                            {
                                convertAnswer += ",";
                            }
                            convertAnswer += choiceList.get(Integer.parseInt(arrAnswer[i]) - 1);
                        }
                        String[] arrConvert = convertAnswer.split("\\,");
                        Arrays.sort(arrConvert);
                        convertAnswer = "";
                        for(int i = 0; i < arrConvert.length; i++) {
                            if(i > 0) convertAnswer += ",";
                            convertAnswer += arrConvert[i];
                        }

                        if (convertAnswer.equals(paperMap.get("rgtAnsr1"))) {
                            qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                        } 
                        
                        if ("Y".equals(paperMap.get("errorAnsrYn"))) {
                            qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                        }
                    }
                    else // 짝짓기 형
                    {
                        String convertAnswer = String.join("|", oppositeList);
                        if (convertAnswer.equals(paperMap.get("stareAnsr"))) {
                            qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                        }
                        
                        if ("Y".equals(paperMap.get("errorAnsrYn"))) {
                            qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                        }
                        
                    }
                }

            }
            else if ("SHORT".equals(paperMap.get("qstnTypeCd")))
            { // 주관식(단답형) 문제
                if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                { // 제출한 답이 있으면
                    String[] arrRgt1Answer = StringUtil.nvl(paperMap.get("rgtAnsr1")).split("\\|");
                    String[] arrRgt2Answer = StringUtil.nvl(paperMap.get("rgtAnsr2")).split("\\|");
                    String[] arrRgt3Answer = StringUtil.nvl(paperMap.get("rgtAnsr3")).split("\\|");
                    String[] arrRgt4Answer = StringUtil.nvl(paperMap.get("rgtAnsr4")).split("\\|");
                    String[] arrRgt5Answer = StringUtil.nvl(paperMap.get("rgtAnsr5")).split("\\|");
                    String[] arrAnswer = paperMap.get("stareAnsr").toString().split("\\|");
                    String[][] rgtAnswer = {arrRgt1Answer, arrRgt2Answer, arrRgt3Answer, arrRgt4Answer, arrRgt5Answer};
                    Boolean isAnswer = false;
                    Boolean isArr = false;
                    int[] arrRgt = {6, 6, 6, 6, 6};
                    
                    for(int i = 0; i < arrAnswer.length; i++) {
                        if(i+1 < arrAnswer.length) {
                            isAnswer = false;
                            isArr = false;
                        }
                        // 순서에 맞게
                        if("A".equals(StringUtil.nvl(paperMap.get("multiRgtChoiceTypeCd")))) {
                            for(String rgtAnsr : rgtAnswer[i]) {
                                if(rgtAnsr.replaceAll(" ", "").equals(arrAnswer[i].replaceAll(" ", ""))) {
                                    isAnswer = true;
                                    break;
                                }
                            }
                            if(!isAnswer) {
                                break;
                            }
                        // 순서 상관없이
                        } else {
                            for(int j = 0; j < arrAnswer.length; j++) {
                                for(int arr : arrRgt) {
                                    if(arr == j) {
                                        isArr = true;
                                        break;
                                    }
                                }
                                if(isArr || isAnswer) {
                                    continue;
                                }
                                for(String rgtAnsr : rgtAnswer[j]) {
                                    if(rgtAnsr.replaceAll(" ", "").equals(arrAnswer[i].replaceAll(" ", ""))) {
                                        isAnswer = true;
                                        arrRgt[i] = j;
                                        break;
                                    }
                                }
                            }
                            if(!isAnswer) {
                                break;
                            }
                        }
                    }
                    if(isAnswer) {
                        qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                    }
                    
                    if ("Y".equals(paperMap.get("errorAnsrYn"))) {
                        qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                    }
                } 
            }
            else if ("OX".equals(paperMap.get("qstnTypeCd")))
            {
                if (paperMap.get("stareAnsr") != null && StringUtil.isNotNull(paperMap.get("stareAnsr").toString()))
                { // 제출한 답이 있으면
                    if (paperMap.get("rgtAnsr1").toString().equals(paperMap.get("stareAnsr"))) {
                        qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                    }
                    
                    if ("Y".equals(paperMap.get("errorAnsrYn"))) {
                        qstnVo.setGetScore(Float.parseFloat(paperMap.get("qstnScore").toString()) * reExamAplyRatio / 100);
                    }
                }
            }

            // 채점 저장
            totGetScore += qstnVo.getGetScore();
            qstnVo.setExamQstnSn(Integer.parseInt(paperMap.get("examQstnSn").toString()));
            examStarePaperDAO.updateExamStarePaperTempSave(qstnVo);
        } // 문항별 for문 종료

        // 11. 총점 업데이트
        ExamStareVO stareVo = new ExamStareVO();
        stareVo.setExamCd(vo.getExamCd());
        stareVo.setStdId(vo.getStdNo());
        stareVo.setMdfrId(vo.getMdfrId());
        stareVo.setStareTm(-1);
        stareVo.setEndDttm(null);
        stareVo.setTotGetScore(totGetScore);
        if(!isDescribe && "COMPLETE".equals(StringUtil.nvl(vo.getSearchGubun()))) {
            stareVo.setEvalYn("Y");
        }
        examStareDAO.updateExamStareTempSave(stareVo);
    }

    /*****************************************************
     * <p>
     * TODO 시험문제 배정된 학습자 리스트 조회
     * </p>
     * 시험문제 배정된 학습자 리스트 조회
     * 
     * @param ExamStarePaperVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> listStdPageing(ExamStarePaperVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<EgovMap> stdList = examStarePaperDAO.listStdPageing(vo);
        
        if(stdList.size() > 0) {
            int totalCnt = Integer.parseInt(StringUtil.nvl(stdList.get(0).get("totalCnt")));
            paginationInfo.setTotalRecordCount(totalCnt);
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        
        resultVO.setReturnList(stdList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 시험지 수정
     * </p>
     * 시험지 수정
     * 
     * @param ExamStarePaperVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateStarePaper(ExamStarePaperVO vo) throws Exception {
        examStarePaperDAO.updateStarePaper(vo);
    }

    /*****************************************************
     * <p>
     * TODO 응시 시험지 답안 이력
     * </p>
     * 응시 시험지 답안 이력
     * 
     * @param ExamStarePaperHstyVO
     * @return ProcessResultVO<ExamStarePaperHstyVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamStarePaperHstyVO> listPaperHstyLog(ExamStarePaperHstyVO vo) throws Exception {
        ProcessResultVO<ExamStarePaperHstyVO> resultVO = new ProcessResultVO<ExamStarePaperHstyVO>();
        
        try {
            List<ExamStarePaperHstyVO> logList = examStarePaperHstyDAO.listPaperHstyLog(vo);
            resultVO.setReturnList(logList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        
        return resultVO;
    }

}
