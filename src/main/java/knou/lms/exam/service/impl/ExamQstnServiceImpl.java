package knou.lms.exam.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.exam.dao.ExamQbankQstnDAO;
import knou.lms.exam.dao.ExamQstnDAO;
import knou.lms.exam.dao.ExamStareDAO;
import knou.lms.exam.dao.ExamStarePaperDAO;
import knou.lms.exam.service.ExamQstnService;
import knou.lms.exam.vo.ExamQbankQstnVO;
import knou.lms.exam.vo.ExamQstnVO;
import knou.lms.exam.vo.ExamStarePaperVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.exam.vo.ExamVO;

@Service("examQstnService")
public class ExamQstnServiceImpl extends ServiceBase implements ExamQstnService {
    
    @Resource(name="examQstnDAO")
    private ExamQstnDAO examQstnDAO;
    
    @Resource(name="examQbankQstnDAO")
    private ExamQbankQstnDAO examQbankQstnDAO;
    
    @Resource(name="examStarePaperDAO")
    private ExamStarePaperDAO examStarePaperDAO;
    
    @Resource(name="examStareDAO")
    private ExamStareDAO examStareDAO;
    
    @Resource(name="examDAO")
    private ExamDAO examDAO;

    /*****************************************************
     * <p>
     * TODO 시험 문제 목록 조회
     * </p>
     * 시험 문제 목록 조회
     * 
     * @param ExamQstnVO
     * @return List<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamQstnVO> list(ExamQstnVO vo) throws Exception {
        List<ExamQstnVO> qstnList = examQstnDAO.list(vo);
        if(qstnList.size() > 0) {
            for(ExamQstnVO list : qstnList) {
                if("MATCH".equals(StringUtil.nvl(list.getQstnTypeCd()))) {
                    String[] rgtAnsrList = StringUtil.nvl(list.getRgtAnsr1()).split("\\|");
                    Collections.shuffle(Arrays.asList(rgtAnsrList));
                    list.setRandomRgtAnsr(rgtAnsrList);
                }
            }
        }

        return qstnList;
    }

    /*****************************************************
     * <p>
     * TODO 시험 문제 랜덤 목록 조회
     * </p>
     * 시험 문제 랜덤 목록 조회
     * 
     * @param ExamQstnVO
     * @return List<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamQstnVO> randomQstnList(ExamQstnVO vo) throws Exception {

        return examQstnDAO.randomQstnList(vo);
    }

    /*****************************************************
     * <p>
     * TODO 시험 문제 순차 목록 조회
     * </p>
     * 시험 문제 순차 목록 조회
     * 
     * @param ExamQstnVO
     * @return List<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ExamQstnVO> seqQstnList(ExamQstnVO vo) throws Exception {

        return examQstnDAO.seqQstnList(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제 개수 조회
     * </p>
     * 문제 개수 조회
     * 
     * @param ExamVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int qstnCount(ExamQstnVO vo) throws Exception {

        return examQstnDAO.qstnCount(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제 조회
     * </p>
     * 문제 조회
     * 
     * @param ExamQstnVO
     * @return ExamQstnVO
     * @throws Exception
     ******************************************************/
    @Override
    public ExamQstnVO select(ExamQstnVO vo) throws Exception {

        return examQstnDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제 순서 변경
     * </p>
     * 문제 순서 변경
     * 
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> editQstnNo(ExamQstnVO vo) throws Exception {
        ProcessResultVO<DefaultVO> returnVO = new ProcessResultVO<DefaultVO>();
        
        if(!"".equals(StringUtil.nvl(vo.getExamQstnSns()))) {
            vo.setExamQstnSnList(vo.getExamQstnSns().split("\\|"));
        }
        examQstnDAO.updateQstnNo(vo);
        examQstnDAO.updateQstnNoToNo(vo);

        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 문제 후보 순서 변경
     * </p>
     * 문제 후보 순서 변경
     * 
     * @param ExamQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> editSubNo(ExamQstnVO vo) throws Exception {
        ProcessResultVO<DefaultVO> returnVO = new ProcessResultVO<DefaultVO>();
        
        examQstnDAO.updateSubNo(vo);
        examQstnDAO.updateSubNoToNo(vo);
        
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 문제 등록
     * </p>
     * 문제 등록
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertExamQstn(ExamQstnVO vo) throws Exception {
        if("ALL".equals(vo.getQstnDiff())) {
            vo.setQstnDiff(null);
        }
        int examQstnSn = examQstnDAO.selectKey();
        vo.setExamQstnSn(examQstnSn);
        examQstnDAO.insertExamQstn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제 수정
     * </p>
     * 문제 수정
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamQstn(ExamQstnVO vo) throws Exception {
        if("ALL".equals(vo.getQstnDiff())) {
            vo.setQstnDiff(null);
        }
        examQstnDAO.updateExamQstn(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 문제 수정 옵션 포함
     * </p>
     * 문제 수정 옵션 포함
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamQstnOption(ExamQstnVO vo) throws Exception {
        // 이전 내용 조회
        ExamQstnVO qstnVO = examQstnDAO.select(vo);
        if("ALL".equals(vo.getQstnDiff())) {
            vo.setQstnDiff(null);
        }
        if("errorAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
            vo.setErrorAnsrYn("Y");
        }
        examQstnDAO.updateExamQstn(vo);
        
        ExamStarePaperVO espvo = new ExamStarePaperVO();
        espvo.setExamCd(vo.getExamCd());
        espvo.setExamQstnSn(vo.getExamQstnSn());
        List<EgovMap> paperList = (List<EgovMap>)examStarePaperDAO.paperQstnlist(espvo);
        espvo.setMdfrId(vo.getMdfrId());
        
        for(EgovMap emap : paperList) {
            if(emap.get("stareAnsr") != null && !"".equals(emap.get("stareAnsr"))) {
                espvo.setStdNo(emap.get("stdNo").toString());
                espvo.setExamQstnSn(Integer.parseInt(emap.get("examQstnSn").toString()));
                espvo.setGetScore(0.0F);
                // 모든 정답 점수 부여
                if("errorAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                    espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                } else {
                    if ("CHOICE".equals(emap.get("qstnTypeCd")) || "MULTICHOICE".equals(emap.get("qstnTypeCd")) || "MATCH".equals(emap.get("qstnTypeCd")))
                    { // 객관식, 짝짓기형 문제
                        List<String> choiceTitleList = new ArrayList<String>(); // 문항의 보기 제목(원래 순서)
                        choiceTitleList.add(emap.get("empl1")==null?"":emap.get("empl1").toString());
                        choiceTitleList.add(emap.get("empl2")==null?"":emap.get("empl2").toString());
                        choiceTitleList.add(emap.get("empl3")==null?"":emap.get("empl3").toString());
                        choiceTitleList.add(emap.get("empl4")==null?"":emap.get("empl4").toString());
                        choiceTitleList.add(emap.get("empl5")==null?"":emap.get("empl5").toString());
                        choiceTitleList.add(emap.get("empl6")==null?"":emap.get("empl6").toString());
                        choiceTitleList.add(emap.get("empl7")==null?"":emap.get("empl7").toString());
                        choiceTitleList.add(emap.get("empl8")==null?"":emap.get("empl8").toString());
                        choiceTitleList.add(emap.get("empl9")==null?"":emap.get("empl9").toString());
                        choiceTitleList.add(emap.get("empl10")==null?"":emap.get("empl10").toString());

                        // 랜던하게 섞인 선택지를 리스트에 담기
                        List<String> choiceList = new ArrayList<String>();
                        List<String> oppositeList = new ArrayList<String>();
                        List<String> oldOppositeList = new ArrayList<String>();
                        String[] randomQstn = emap.get("examOdr").toString().split("\\,");
                        String[] arrOpposite = emap.get("rgtAnsr1").toString().split("\\|");
                        String[] oldOpposite = qstnVO.getRgtAnsr1().split("\\|");
                        for (String qstnNo : randomQstn)
                        {
                            if (StringUtil.isNotNull(choiceTitleList.get(Integer.parseInt(qstnNo) - 1)))
                            {
                                choiceList.add(qstnNo);
                                if ("MATCH".equals(emap.get("qstnTypeCd"))) {
                                    oppositeList.add(arrOpposite[Integer.parseInt(qstnNo) - 1]);
                                    oldOppositeList.add(oldOpposite[Integer.parseInt(qstnNo) - 1]);
                                }
                            }
                        }


                        if ("CHOICE".equals(emap.get("qstnTypeCd")) || "MULTICHOICE".equals(emap.get("qstnTypeCd")))
                        { // 객관식
                            String[] arrAnswer = emap.get("stareAnsr").toString().split("\\,");
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

                            // 이전, 현재 정답 모두 점수 부여
                            if("prevAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                                if (convertAnswer.equals(emap.get("rgtAnsr1")) || convertAnswer.equals(qstnVO.getRgtAnsr1())) {
                                    espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                                }
                            // 현재 정답에만 점수 부여
                            } else if("newAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                                if (convertAnswer.equals(emap.get("rgtAnsr1"))) {
                                    espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                                }
                            }
                        }
                        else // 짝짓기 형
                        {
                            String convertAnswer = String.join("|", oppositeList);
                            String oldConvert = String.join("|", oldOppositeList);
                            // 이전, 현재 정답 모두 점수 부여
                            if("prevAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                                if (convertAnswer.equals(emap.get("stareAnsr")) || oldConvert.equals(emap.get("stareAnsr"))) {
                                    espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                                }
                            // 현재 정답에만 점수 부여
                            } else if("newAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                                if (convertAnswer.equals(emap.get("stareAnsr"))) {
                                    espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                                }
                            }
                        }

                    }
                    else if ("SHORT".equals(emap.get("qstnTypeCd")))
                    { // 주관식(단답형) 문제
                        if (emap.get("stareAnsr") != null && StringUtil.isNotNull(emap.get("stareAnsr").toString()))
                        { // 제출한 답이 있으면
                            String[] arrRgt1Answer = StringUtil.nvl(emap.get("rgtAnsr1")).split("\\|");
                            String[] arrRgt2Answer = StringUtil.nvl(emap.get("rgtAnsr2")).split("\\|");
                            String[] arrRgt3Answer = StringUtil.nvl(emap.get("rgtAnsr3")).split("\\|");
                            String[] arrRgt4Answer = StringUtil.nvl(emap.get("rgtAnsr4")).split("\\|");
                            String[] arrRgt5Answer = StringUtil.nvl(emap.get("rgtAnsr5")).split("\\|");
                            String[] oldRgt1Answer = StringUtil.nvl(qstnVO.getRgtAnsr1()).split("\\|");
                            String[] oldRgt2Answer = StringUtil.nvl(qstnVO.getRgtAnsr2()).split("\\|");
                            String[] oldRgt3Answer = StringUtil.nvl(qstnVO.getRgtAnsr3()).split("\\|");
                            String[] oldRgt4Answer = StringUtil.nvl(qstnVO.getRgtAnsr4()).split("\\|");
                            String[] oldRgt5Answer = StringUtil.nvl(qstnVO.getRgtAnsr5()).split("\\|");
                            String[] arrAnswer = emap.get("stareAnsr").toString().split("\\|");
                            String[][] rgtAnswer = {arrRgt1Answer, arrRgt2Answer, arrRgt3Answer, arrRgt4Answer, arrRgt5Answer};
                            String[][] oldAnswer = {oldRgt1Answer, oldRgt2Answer, oldRgt3Answer, oldRgt4Answer, oldRgt5Answer};
                            Boolean isAnswer = false;
                            Boolean isArr = false;
                            int[] arrRgt = {6, 6, 6, 6, 6};
                            
                            for(int i = 0; i < arrAnswer.length; i++) {
                                if(i+1 < arrAnswer.length) {
                                    isAnswer = false;
                                    isArr = false;
                                }
                                // 순서에 맞게
                                if("A".equals(StringUtil.nvl(emap.get("multiRgtChoiceTypeCd")))) {
                                    for(String rgtAnsr : rgtAnswer[i]) {
                                        if(rgtAnsr.equals(arrAnswer[i])) {
                                            isAnswer = true;
                                            break;
                                        }
                                    }
                                    // 이전, 현재 정답 모두 점수 부여
                                    if("prevAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                                        if(!isAnswer) {
                                            for(String rgtAnsr : oldAnswer[i]) {
                                                if(rgtAnsr.equals(arrAnswer[i])) {
                                                    isAnswer = true;
                                                    break;
                                                }
                                            }
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
                                            if(rgtAnsr.equals(arrAnswer[i])) {
                                                isAnswer = true;
                                                arrRgt[i] = j;
                                                break;
                                            }
                                        }
                                        // 이전, 현재 정답 모두 점수 부여
                                        if("prevAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                                            if(!isAnswer) {
                                                for(String rgtAnsr : oldAnswer[j]) {
                                                    if(rgtAnsr.equals(arrAnswer[i])) {
                                                        isAnswer = true;
                                                        arrRgt[i] = j;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if(!isAnswer) {
                                        break;
                                    }
                                }
                            }
                            if(isAnswer) {
                                espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                            }
                        } 
                    }
                    else if ("OX".equals(emap.get("qstnTypeCd")))
                    {
                        // 이전, 현재 정답 모두 점수 부여
                        if("prevAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                            if (emap.get("rgtAnsr1").toString().equals(emap.get("stareAnsr")) || qstnVO.getRgtAnsr1().equals(emap.get("stareAnsr"))) {
                                espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                            }
                        // 현재 정답에만 점수 부여
                        } else if("newAnsr".equals(StringUtil.nvl(vo.getSearchKey()))) {
                            if (emap.get("rgtAnsr1").toString().equals(emap.get("stareAnsr"))) {
                                espvo.setGetScore(Float.parseFloat(emap.get("qstnScore").toString()));
                            }
                        }
                    }
                }
                // 문항 시험지 점수 수정
                examStarePaperDAO.updateExamStarePaperTempSave(espvo);
                // 총점 수정
                ExamStareVO stareVO = new ExamStareVO();
                stareVO.setExamCd(vo.getExamCd());
                stareVO.setStdId(emap.get("stdNo").toString());
                stareVO = examStareDAO.selectExamStareStd(stareVO);
                stareVO.setMdfrId(vo.getMdfrId());
                stareVO.setTotGetScore(stareVO.getTotGetScore() + (espvo.getGetScore() - Float.parseFloat(emap.get("getScore").toString())));
                examStareDAO.updateExamStareTempSave(stareVO);
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 문제 삭제 상태로 수정
     * </p>
     * 문제 삭제 상태로 수정
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamQstnDelYn(ExamQstnVO vo) throws Exception {
        vo.setExamQstnSnList(vo.getExamQstnSns().split("\\|"));
        for(String examQstnSn : vo.getExamQstnSns().split("\\|")) {
            ExamQstnVO qstnVO = new ExamQstnVO();
            qstnVO.setExamCd(vo.getExamCd());
            qstnVO.setExamQstnSn(Integer.valueOf(examQstnSn));
            qstnVO = examQstnDAO.select(qstnVO);
            int qstnCount = examQstnDAO.selectOtherSubCount(qstnVO);
            qstnVO.setSearchKey("DOWN");
            if(qstnCount == 0) {
                qstnVO.setNewQstnNo(9999);
                examQstnDAO.updateQstnNo(qstnVO);
            } else {
                qstnVO.setNewSubNo(9999);
                examQstnDAO.updateSubNo(qstnVO);
            }
        }
        examQstnDAO.updateExamQstnDelYn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 문제 점수 수정
     * </p>
     * 문제 점수 수정
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamQstnScore(ExamQstnVO vo) throws Exception {
        ExamVO checkExamVO = null;
        
        if(ValidationUtils.isEmpty(vo.getExamCd())) {
            throw processException("common.system.error"); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
        }
        
        if(ValidationUtils.isNotEmpty(vo.getCrsCreCd())) {
            checkExamVO = new ExamVO();
            checkExamVO.setExamCd(vo.getExamCd());
            checkExamVO.setCrsCreCd(vo.getCrsCreCd());
            checkExamVO = examDAO.select(checkExamVO);
        } else {
            ExamVO examVO = new ExamVO();
            examVO.setExamCd(vo.getExamCd());
            examVO = examDAO.select(examVO);
            
            if(examVO == null) {
                throw processException("exam.error.not.exists.exam"); // 시험정보를 찾을 수 없습니다.
            }
            
            checkExamVO = new ExamVO();
            checkExamVO.setExamCd(vo.getExamCd());
            checkExamVO.setCrsCreCd(examVO.getCrsCreCd());
            checkExamVO = examDAO.select(checkExamVO);
        }
        
        if(checkExamVO.getExamStartUserCnt() > 0) {
            throw processException("exam.error.submit.join.user"); // 시험 응시 학생이 있으므로 변경이 불가능합니다.
        }
        
        if(vo.getExamQstnSns() != null) {
            String[] examQstnSns = vo.getExamQstnSns().split("\\|");
            String[] qstnScores = vo.getQstnScores().split("\\|");
            
            for(int i = 0; i < examQstnSns.length; i++) {
                ExamQstnVO qstnVO = new ExamQstnVO();
                qstnVO.setExamCd(vo.getExamCd());
                qstnVO.setMdfrId(vo.getMdfrId());
                qstnVO.setExamQstnSn(Integer.parseInt(examQstnSns[i]));
                if(qstnScores.length > 1) {
                    qstnVO.setQstnScore((float)(Math.round(Float.parseFloat(qstnScores[i]) * 10) / 10.0));
                } else {
                    qstnVO.setQstnScore((float)(Math.round(Float.parseFloat(qstnScores[0]) * 10) / 10.0));
                }
                examQstnDAO.updateExamQstnScore(qstnVO);
            }
        } else {
            List<ExamQstnVO> qstnList = examQstnDAO.list(vo);
            int qstnCount = examQstnDAO.qstnCount(vo);
            
            if(qstnCount > 0) {
                float qstnScore = (float)(Math.round(100.0f / qstnCount * 10) / 10.0);
                for(ExamQstnVO qvo : qstnList) {
                    float score = qstnScore;
                    if(qvo.getQstnNo() == qstnCount) {
                        score = (float)(Math.round((qstnScore + 100.0f - (qstnScore * qstnCount)) * 10) / 10.0);
                    }
                    ExamQstnVO qstnVO = new ExamQstnVO();
                    qstnVO.setExamCd(vo.getExamCd());
                    qstnVO.setMdfrId(vo.getMdfrId());
                    qstnVO.setExamQstnSn(qvo.getExamQstnSn());
                    qstnVO.setQstnScore(score);
                    examQstnDAO.updateExamQstnScore(qstnVO);
                }
            }
        }
    }
    
    /*****************************************************
     * 문제 점수 수정 일괄
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateExamQstnScoreBatch(HttpServletRequest request, List<ExamQstnVO> list) throws Exception {
        String userId = SessionInfo.getUserId(request);
        float totalScore = 0f;
        List<ExamQstnVO> updateList = new ArrayList<>();
        
        if(list == null || list.size() == 0) {
            throw processException("common.nodata.msg"); // 등록된 내용이 없습니다.
        }
        
        ExamVO checkExamVO = null;
        
        for(ExamQstnVO examQstnVO : list) {
            String examCd = examQstnVO.getExamCd();
            String crsCreCd = examQstnVO.getCrsCreCd();
            String[] examQstnSnList = examQstnVO.getExamQstnSns().split("\\|");
            float qstnScore = examQstnVO.getQstnScore();
            
            if(ValidationUtils.isEmpty(crsCreCd) || ValidationUtils.isEmpty(examCd) || ValidationUtils.isEmpty(examQstnVO.getExamQstnSns())) {
                throw processException("common.system.error"); // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            }
            
            if(checkExamVO == null) {
                checkExamVO = new ExamVO();
                checkExamVO.setCrsCreCd(crsCreCd);
                checkExamVO.setExamCd(examCd);
                checkExamVO = examDAO.select(checkExamVO);
                
                if(checkExamVO == null) {
                    throw processException("exam.error.not.exists.exam"); // 시험정보를 찾을 수 없습니다.
                }
            }
            
            totalScore += qstnScore;
            
            for(String examQstnSn : examQstnSnList) {
                ExamQstnVO updateVO = new ExamQstnVO();
                updateVO.setExamCd(examCd);
                updateVO.setExamQstnSn(Integer.parseInt(examQstnSn));
                updateVO.setQstnScore(qstnScore);
                updateVO.setMdfrId(userId);
                
                updateList.add(updateVO);
            }
        }
        
        if(totalScore != 100f) {
            throw processException("exam.alert.score.ratio.100"); // 배점 점수가 100점과 맞지 않습니다. 다시 확인해 주세요.
        }
        
        if(checkExamVO.getExamStartUserCnt() > 0) {
            throw processException("exam.error.submit.join.user"); // 시험 응시 학생이 있으므로 변경이 불가능합니다.
        }
        
        for(ExamQstnVO examQstnVO : updateList) {
            examQstnDAO.updateExamQstnScore(examQstnVO);
        }
    }
    
    /*****************************************************
     * <p>
     * TODO 문제 점수 1점 부여
     * </p>
     * 문제 점수 1점 부여
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateExamQstnScore1(ExamQstnVO vo) throws Exception {
         List<ExamQstnVO> qstnList = examQstnDAO.list(vo);
         int qstnCount = examQstnDAO.qstnCount(vo);
         
         if(qstnCount > 0) {
             for(ExamQstnVO qvo : qstnList) {
                 ExamQstnVO qstnVO = new ExamQstnVO();
                 qstnVO.setExamCd(vo.getExamCd());
                 qstnVO.setMdfrId(vo.getMdfrId());
                 qstnVO.setExamQstnSn(qvo.getExamQstnSn());
                 qstnVO.setQstnScore(Float.parseFloat("1"));
                 examQstnDAO.updateExamQstnScore(qstnVO);
             }
         }
    }

    /*****************************************************
     * <p>
     * TODO 문항 가져오기
     * </p>
     * 문항 가져오기
     * 
     * @param ExamQstnVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertCopyQstn(ExamQstnVO vo) throws Exception {
        ExamQstnVO examQstnVO = examQstnDAO.select(vo);
        String[] qstnSnList = StringUtil.nvl(vo.getCopyQstnSn()).split("\\|");
        int qstnNo = vo.getQstnNo();
        for(int i = 0; i < qstnSnList.length; i++) {
            EgovMap qstnMap = new EgovMap();
            // 문제은행
            if("qbank".equals(StringUtil.nvl(vo.getCopyType()).split("\\|")[i])) {
                ExamQbankQstnVO qbankQstnVO = new ExamQbankQstnVO();
                qbankQstnVO.setExamQbankQstnSn(Integer.valueOf(qstnSnList[i]));
                qbankQstnVO.setExamQbankCtgrCd(StringUtil.nvl(vo.getCopyCd()).split("\\|")[i]);
                qstnMap = examQbankQstnDAO.egovSelect(qbankQstnVO);
                qstnMap.put("rgtrId", vo.getRgtrId());
                qstnMap.put("mdfrId", vo.getRgtrId());
                // 다른시험
            } else if("another".equals(StringUtil.nvl(vo.getCopyType()).split("\\|")[i])) {
                ExamQstnVO qstnVO = new ExamQstnVO();
                qstnVO.setExamQstnSn(Integer.valueOf(qstnSnList[i]));
                qstnVO.setExamCd(StringUtil.nvl(vo.getCopyCd()).split("\\|")[i]);
                qstnMap = examQstnDAO.egovSelect(qstnVO);
                qstnMap.put("rgtrId", vo.getRgtrId());
                qstnMap.put("mdfrId", vo.getRgtrId());
            }
            
            int examQstnSn = examQstnDAO.selectKey();
            qstnMap.put("examCd", vo.getExamCd());
            qstnMap.put("examQstnSn", examQstnSn);
            if(examQstnVO == null) {
                qstnMap.put("qstnNo", qstnNo++);
                qstnMap.put("qstnScore", "0");
                qstnMap.put("subNo", "1");
            } else {
                qstnMap.put("qstnNo", vo.getQstnNo());
                qstnMap.put("qstnScore", examQstnVO.getQstnScore());
                int subNo = examQstnDAO.selectNextSubNo(vo);
                qstnMap.put("subNo", subNo);
            }
            examQstnDAO.insertExamQstnEgov(qstnMap);
            
        }
    }

    /*****************************************************
     * <p>
     * TODO 엑셀 다운로드를 위한 문제 리스트
     * </p>
     * 엑셀 다운로드를 위한 문제 리스트
     * 
     * @param ExamQstnVO
     * @return HashMap<String, Object>
     * @throws Exception
     ******************************************************/
    @Override
    public HashMap<String, Object> exampleExcelQstnList(ExamQstnVO vo) throws Exception {
        List<EgovMap> resultList = new ArrayList<>();
        EgovMap egovMap = new EgovMap();
        
        //단일선택형
        egovMap.put("qstnNo", "1");
        egovMap.put("subNo", "1");
        egovMap.put("qstnCts", "sample");
        egovMap.put("qstnTypeCd", "CHOICE");
        egovMap.put("empl1", "단일선택형 1번 보기");
        egovMap.put("empl2", "단일선택형 2번 보기");
        egovMap.put("empl3", "단일선택형 3번 보기");
        egovMap.put("empl4", "단일선택형 4번 보기");
        egovMap.put("rgtAnsr1", "3");
        egovMap.put("qstnExpl", "객관식 정답해설");
        egovMap.put("qstnScore", "20");
        egovMap.put("multiRgtChoiceYn", "N");
        resultList.add(egovMap);
        
        //짝짓기
        egovMap = new EgovMap();
        egovMap.put("qstnNo", "1");
        egovMap.put("subNo", "2");
        egovMap.put("qstnCts", "sample");
        egovMap.put("qstnTypeCd", "MATCH");
        egovMap.put("empl1", "짝짓기 1번 보기");
        egovMap.put("empl2", "짝짓기 2번 보기");
        egovMap.put("empl3", "짝짓기 3번 보기");
        egovMap.put("empl4", "짝짓기 4번 보기");
        egovMap.put("empl5", "짝짓기 5번 보기");
        egovMap.put("rgtAnsr1", "나비|참새|비둘기|제비|잉꼬");
        egovMap.put("qstnExpl", "짝짓기 정답해설");
        egovMap.put("qstnScore", "20");
        resultList.add(egovMap);
        
        //OX
        egovMap = new EgovMap();
        egovMap.put("qstnNo", "1");
        egovMap.put("subNo", "3");
        egovMap.put("qstnCts", "sample");
        egovMap.put("qstnTypeCd", "OX");
        egovMap.put("rgtAnsr1", "1");
        egovMap.put("qstnExpl", "OX 정답해설");
        egovMap.put("qstnScore", "20");
        resultList.add(egovMap);
        
        //선다형
        egovMap = new EgovMap();
        egovMap.put("qstnNo", "2");
        egovMap.put("subNo", "1");
        egovMap.put("qstnCts", "sample");
        egovMap.put("qstnTypeCd", "MULTICHOICE");
        egovMap.put("empl1", "선다형 1번 보기");
        egovMap.put("empl2", "선다형 2번 보기");
        egovMap.put("empl3", "선다형 3번 보기");
        egovMap.put("empl4", "선다형 4번 보기");
        egovMap.put("rgtAnsr1", "1,3");
        egovMap.put("qstnExpl", "객관식 정답해설");
        egovMap.put("qstnScore", "25");
        egovMap.put("multiRgtChoiceYn", "Y");
        egovMap.put("multiRgtChoiceTypeCd", "A");
        resultList.add(egovMap);
        
        //단답형
        egovMap = new EgovMap();
        egovMap.put("qstnNo", "3");
        egovMap.put("subNo", "1");
        egovMap.put("qstnCts", "sample");
        egovMap.put("qstnTypeCd", "SHORT");
        egovMap.put("rgtAnsr1", "강|river");
        egovMap.put("rgtAnsr2", "산|mountain");
        egovMap.put("rgtAnsr3", "바다|ocean");
        egovMap.put("qstnExpl", "단답형 정답해설");
        egovMap.put("qstnScore", "25");
        egovMap.put("multiRgtChoiceYn", "Y");
        egovMap.put("multiRgtChoiceTypeCd", "B");
        resultList.add(egovMap);
        
        //서술형
        egovMap = new EgovMap();
        egovMap.put("qstnNo", "4");
        egovMap.put("subNo", "1");
        egovMap.put("qstnCts", "sample");
        egovMap.put("qstnTypeCd", "DESCRIBE");
        egovMap.put("qstnExpl", "단답형 정답해설");
        egovMap.put("qstnScore", "30");
        resultList.add(egovMap);
        
        String[] searchValues = {"파일로 사용자를 추가 합니다. 아래의 사항을 준수하여 파일을 작성하기 바랍니다."
                ,"파일의 구성은 다음과 같아야합니다."
                ,""
                ,"⊙ 주의사항\r\n" +
                "- 명시사항을 지우지 마시고 12번째 줄부터 입력, 저장후 등록해 주세요.\r\n" +
                "- 엑셀로 문항을 등록하게 되면 기존 등록된 문항은 모두 삭제됩니다."
                ,"* 필수 입력사항"
                ,"1. 문제번호, 후보문제번호, 문제내용, 문제구분, 보기1, 보기2, 보기3, 보기4, 보기5, 보기6, 보기7, 보기8, 보기9, 보기10, 정답, 정답해설, 점수, 복수정답여부, 복수정답타입"
                ,"2. 문제번호가 동일하면 후보문제로 등록됨"
                ,"3.\r\n" +
                "* 줄바꿈이 필요하면 엔터키대신 \"<BR>\" 입력\r\n" + 
                "* 문제 번호, 후보문제 번호 : (1~9999 까지)\r\n" + 
                "* 문제구분 : 주관식(서술형):DESCRIBE, 주관식(단답형):SHORT, 단일선택형:CHOICE, 선다형:MULTICHOICE, OX형:OX, 짝짓기형:MATCH\r\n" + 
                "* 문제보기 : 객관식,짝짓기형 일때만 보기1~보기10 를 등록\r\n" + 
                "* 정답\r\n" + 
                "- OX 일때 : 'O' 이면 1, 'X'이면 2 입력\r\n" + 
                "- 선다형 :  답이 두개이상이면 콤마로 구분\r\n" + 
                "- 서술형 : 공백\r\n" + 
                "- 짝짓기 : 답이 두개이상이면 | 로 구분\r\n" + 
                "- 복수정답타입 : 순서가 일치하면 정답  : A, 순서와 상관없이 같으면 정답 : B"
                };
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "시험문제");
        map.put("sheetName", "시험문제");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);
        
        return map;
    }

    /*****************************************************
     * <p>
     * TODO 업로드 된 엑셀 파일로 시험문제 등록
     * </p>
     * 업로드 된 엑셀 파일로 시험문제 등록
     * 
     * @param ExamQstnVO, List<?>
     * @return ProcessResultVO<ExamQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ExamQstnVO> insertExcelQstnList(ExamQstnVO vo, List<?> qstnList) throws Exception {
        ProcessResultVO<ExamQstnVO> resultVO = new ProcessResultVO<ExamQstnVO>();
        
        //성적 토탈 점수 update
        if(qstnList != null) {
            examQstnDAO.updateExamQstnDelYn(vo);
            
            for (int i = 0; i < qstnList.size(); i++){
                ExamQstnVO eqvo = new ExamQstnVO();
                Map<String, Object> qstnMap = (Map<String, Object>)qstnList.get(i);
                eqvo.setQstnNo((int)Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) qstnMap.get("A"),"1")))));
                eqvo.setSubNo((int)Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) qstnMap.get("B"),"1")))));
                eqvo.setTitle(eqvo.getQstnNo() + "-" + eqvo.getSubNo() + " 문제");
                eqvo.setQstnCts(StringUtil.nvl((String) qstnMap.get("C")));           
                eqvo.setQstnTypeCd(StringUtil.nvl((String) qstnMap.get("D")));
                eqvo.setEmpl1(StringUtil.nvl((String) qstnMap.get("E")));
                eqvo.setEmpl2(StringUtil.nvl((String) qstnMap.get("F")));
                eqvo.setEmpl3(StringUtil.nvl((String) qstnMap.get("G")));
                eqvo.setEmpl4(StringUtil.nvl((String) qstnMap.get("H")));
                eqvo.setEmpl5(StringUtil.nvl((String) qstnMap.get("I")));
                eqvo.setEmpl6(StringUtil.nvl((String) qstnMap.get("J")));
                eqvo.setEmpl7(StringUtil.nvl((String) qstnMap.get("K")));
                eqvo.setEmpl8(StringUtil.nvl((String) qstnMap.get("L")));
                eqvo.setEmpl9(StringUtil.nvl((String) qstnMap.get("M")));
                eqvo.setEmpl10(StringUtil.nvl((String) qstnMap.get("N")));
                eqvo.setRgtAnsr1(StringUtil.nvl((String) qstnMap.get("O")));
                eqvo.setRgtAnsr2(StringUtil.nvl((String) qstnMap.get("P")));
                eqvo.setRgtAnsr3(StringUtil.nvl((String) qstnMap.get("Q")));
                eqvo.setRgtAnsr4(StringUtil.nvl((String) qstnMap.get("R")));
                eqvo.setRgtAnsr5(StringUtil.nvl((String) qstnMap.get("S")));
                eqvo.setQstnExpl(StringUtil.nvl((String) qstnMap.get("T")));
                eqvo.setQstnScore((float)Math.round(Math.floor(Double.parseDouble(StringUtil.nvl((String) qstnMap.get("U"),"0")))));
                eqvo.setMultiRgtChoiceYn(StringUtil.nvl((String) qstnMap.get("V")));
                eqvo.setMultiRgtChoiceTypeCd(StringUtil.nvl((String) qstnMap.get("W")));
                
                eqvo.setExamCd(vo.getExamCd());
                eqvo.setMdfrId(vo.getMdfrId());
                eqvo.setRgtrId(vo.getMdfrId());
                eqvo.setDelYn("N");
                
                //문항 등록
                int examQstnSn = examQstnDAO.selectKey(); //-- 문항키를 생성한다.
                eqvo.setExamQstnSn(examQstnSn);
                examQstnDAO.insertExamQstn(eqvo);
            }
        }
        
        resultVO.setResult(1);
        return resultVO;
    }

}
