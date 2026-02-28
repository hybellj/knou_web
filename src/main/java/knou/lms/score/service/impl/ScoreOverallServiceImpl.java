package knou.lms.score.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import knou.framework.common.SessionInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.dao.TermDAO;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.erp.vo.ErpScoreTestVO;
import knou.lms.grade.dao.GradeDAO;
import knou.lms.grade.vo.GradeVO;
import knou.lms.score.dao.ScoreOverallDAO;
import knou.lms.score.service.ScoreOverallService;
import knou.lms.score.vo.ScoreOverallListVO;
import knou.lms.score.vo.ScoreOverallScoreCalVO;
import knou.lms.score.vo.ScoreOverallVO;
import knou.lms.score.vo.StdScoreHistVO;
import knou.lms.sys.dao.SysJobSchDAO;
import knou.lms.sys.vo.SysJobSchVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("scoreOverallService")
public class ScoreOverallServiceImpl extends EgovAbstractServiceImpl implements ScoreOverallService {
    @Resource(name="scoreOverallDAO")
    private ScoreOverallDAO scoreOverallDAO;

    @Autowired
    private GradeDAO gradeDAO;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;

    @Autowired
    private SysFileService sysFileService;

    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;
    
    @Resource(name="termDAO")
    private TermDAO termDAO;
    
    @Resource(name="sysJobSchDAO")
    private SysJobSchDAO sysJobSchDAO;

    @Override
    public ProcessResultVO<ScoreOverallVO> selectOverallList(ScoreOverallVO vo) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<ScoreOverallVO>();
        ScoreOverallVO pVo = null;
        GradeVO result = null;

        List<ScoreOverallVO> resultList = null;
        int totCnt = 0;
        String searchType = StringUtils.isEmpty(vo.getSearchType()) ? "" : vo.getSearchType();
        String[] stdNos = null;

        pVo = new ScoreOverallVO();
        pVo.setCrsCreCd(vo.getCrsCreCd());
        pVo.setSearchType(searchType);
        
        if("btnZero".equals(searchType)) {
            //미평가
            stdNos = scoreOverallDAO.selectScoreZero(pVo);
        } else if("btnApprove".equals(searchType)) {
            //결시원승인
            String[] apprstats = new String[]{"APPROVE"};
            pVo.setApprStats(apprstats);
            stdNos = scoreOverallDAO.selectExamAbsent(pVo);
        } else if("btnApplicate".equals(searchType)) {
            //결시원신청
            String[] apprstats = new String[]{"APPLICATE", "RAPPLICATE"};
            pVo.setApprStats(apprstats);
            stdNos = scoreOverallDAO.selectExamAbsent(pVo);
        } else if("btnReExam".equals(searchType)) {
            //재시험 대상자
            stdNos = scoreOverallDAO.selectReExamStd(pVo);
        } else if("btnF".equals(searchType)) {
            
        }

        if(stdNos != null && stdNos.length == 0) {
            stdNos = new String[]{""};
        }

        vo.setStdIds(stdNos);
        vo.setStdIds2(stdNos);
        vo.setSearchMenu("selectOverallList");
        resultList = scoreOverallDAO.selectOverallList(vo);
        totCnt = scoreOverallDAO.selectOverallTotalCnt(vo);

        GradeVO gpVo = new GradeVO();

        gpVo.setCrsCreCd(vo.getCrsCreCd());

        result = gradeDAO.selectStdScoreItemConfInfo(gpVo);

        pVo = new ScoreOverallVO();

        pVo.setTotalCnt(totCnt);
        resultVO.setReturnVO(pVo);
        resultVO.setReturnSubVO(result);
        resultVO.setReturnList(resultList);
 
        return resultVO;
    }
    
    @Override
    public List<ScoreOverallVO> selectOverallExcelList(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO pVo = null;

        String searchType = StringUtils.isEmpty(vo.getSearchTypeExcel()) ? "" : vo.getSearchTypeExcel();
        String[] stdNos = null;

        pVo = new ScoreOverallVO();
        pVo.setCrsCreCd(vo.getCrsCreCd());
        pVo.setSearchType(searchType);

        if("btnZero".equals(searchType)) {
            //미평가
            stdNos = scoreOverallDAO.selectScoreZero(pVo);
        } else if("btnApprove".equals(searchType)) {
            //결시원승인
            String[] apprstats = new String[]{"APPROVE"};
            pVo.setApprStats(apprstats);
            stdNos = scoreOverallDAO.selectExamAbsent(pVo);
        } else if("btnApplicate".equals(searchType)) {
            //결시원신청
            String[] apprstats = new String[]{"APPLICATE", "RAPPLICATE"};
            pVo.setApprStats(apprstats);
            stdNos = scoreOverallDAO.selectExamAbsent(pVo);
        } else if("btnReExam".equals(searchType)) {
            //재시험 대상자
            stdNos = scoreOverallDAO.selectReExamStd(pVo);
        } if("btnF".equals(searchType)) {
            vo.setSearchType(searchType);
        }

        if(stdNos != null && stdNos.length == 0) {
            stdNos = new String[]{""};
        }

        vo.setStdIds(stdNos);
        vo.setStdIds2(stdNos);

        return scoreOverallDAO.selectOverallExcelList(vo);
    }
    
    @Override
    public ScoreOverallVO selectOverallStdInfo(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO result = scoreOverallDAO.selectOverallStdInfo(vo);
        UsrUserInfoVO uVo = new UsrUserInfoVO();
        String phtFile = "";

        uVo.setUserId(vo.getUserId());
        UsrUserInfoVO uuivo  = usrUserInfoDAO.select(uVo);

        // 사진파일이 있으면 변환
        if (result != null && uuivo.getPhtFileByte() != null && uuivo.getPhtFileByte().length > 0) {
            phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(uuivo.getPhtFileByte()));
            result.setPhtFile(phtFile);
        }

        return result;
    }
    
    @Override
    public ScoreOverallVO selectOverallScoreDtl(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectOverallScoreDtl(vo);
    }
    
    @Override
    public int selectScoreMustF(ScoreOverallScoreCalVO vo) throws Exception {
        return scoreOverallDAO.selectScoreMustF(vo);
    }
    
    @Override
    public ScoreOverallVO selectStdDetailScore(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectStdDetailScore(vo);
    }

    @Override
    public void updateOverallScoreStatus(ScoreOverallVO vo) throws Exception {
        scoreOverallDAO.updateOverallScoreStatus(vo);
    }

    @Override
    public void saveOverallList(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO pVo = null;
        ScoreOverallVO abScoreVo = null;
        ScoreOverallVO updVo = null;

        String creCrsEval = "";
        String prvScore = "";
        String prvGrade = "";
        String modScore = "";
        String modGrade = "";

        ScoreOverallVO prvInfo = null;

        List<ScoreOverallVO> scoreItemList = null;
        List<ScoreOverallVO> scoreList = null;

        for(ScoreOverallListVO item : vo.getList()) {
            if("Y".equals(item.getRowStatus())) {
                String crsCreCd = vo.getCrsCreCd();
                
                pVo = new ScoreOverallVO();
                pVo.setCrsCreCd(crsCreCd);
                pVo.setStdId(item.getStdId());

                creCrsEval = scoreOverallDAO.selectCreCrsEval(pVo);
                prvInfo = scoreOverallDAO.selectStdScorePrvInfo(pVo);

                prvScore = prvInfo.getPrvScore();
                prvGrade = prvInfo.getPrvGrade();

                modScore = item.getTotScoreData();
                pVo.setPrvScore( modScore );

                if("RELATIVE".equals(creCrsEval)) {
                    ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
                    String uniCd = baseInfoVO.getUniCd();
                    
                    if(trunc(modScore) < 60) {
                        modGrade = "F";
                    } else if(trunc(modScore) < 65) {
                        modGrade = "D";
                    } else if(trunc(modScore) < 70) {
                        modGrade = "D+";
                    } else if(trunc(modScore) < 75) {
                        modGrade = "C";
                    } else if(trunc(modScore) < 80) {
                        modGrade = "C+";
                    } else if(trunc(modScore) < 85) {
                        modGrade = "B";
                    } else if(trunc(modScore) < 90) {
                        modGrade = "B+";
                    } else if(trunc(modScore) < 95) {
                        modGrade = "A";
                    } else if(trunc(modScore) <= 100) {
                        modGrade = "A+";
                    }
                    
                    // 대학원 70점미만 F
                    if("G".equals(uniCd) && trunc(modScore) < 70) {
                        modGrade = "F";
                    }
                } else if("ABSOLUTE".equals(creCrsEval)) {
                    ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
                    String uniCd = baseInfoVO.getUniCd();
                    
                    abScoreVo = scoreOverallDAO.selectAbsoluteCalc(modScore);
                    modGrade = abScoreVo.getMrksGrdGbn();
                    
                    // 대학원 70점미만 F
                    if("G".equals(uniCd) && trunc(modScore) < 70) {
                        modGrade = "F";
                    }
                } else if("PF".equals(creCrsEval)) {
                    ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
                    String uniCd = baseInfoVO.getUniCd();
                    
                    // 등급과 평점 구함
                    if("C".equals(uniCd)) {
                        //학부 P/F과목 : 60점 기준
                        if(trunc(modScore) >= 60) {
                            modGrade = "P";
                        } else {
                            modGrade = "F";
                        }
                    } else {
                        //대학원 P/F과목 : 70점 기준
                        if(trunc(modScore) >= 70) {
                            modGrade = "P";
                        } else {
                            modGrade = "F";
                        }
                    }
                }
                
                updVo = new ScoreOverallVO();
                updVo.setStdId( item.getStdId() );
                updVo.setTotScore( modScore );
                updVo.setScoreGrade( modGrade );
                updVo.setMdfrId( vo.getMdfrId() );

                scoreOverallDAO.updateStdScoreGrade(updVo);

                this.spScorMrksHistCrea(crsCreCd, item.getUserId(), "[성적환산총점:변경]\r\n" + item.getStdId() + " : " + prvScore + "점 " + prvGrade  + " 에서 \r\n" + modScore + "점 " + modGrade  + " 으로 변경", vo.getMdfrId());
            } else {
                
            }
        }

        scoreItemList = this.updateTbLmsStdScoreItem(vo);
        scoreList = this.updateTbLmsStdScore(vo);

        scoreOverallDAO.updateTbLmsStdScoreItem(scoreItemList);
        scoreOverallDAO.updateTbLmsStdScore(scoreList);
    }

    @Override
    public ScoreOverallVO selectModGrade(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO resultVO = new ScoreOverallVO();
        
        String modScore = vo.getModScore();
        String modGrade = "";
        String creCrsEval = scoreOverallDAO.selectCreCrsEval(vo);
        
        if("RELATIVE".equals(creCrsEval)) {
            ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
            String uniCd = baseInfoVO.getUniCd();
            
            if(trunc(modScore) < 60) {
                modGrade = "F";
            } else if(trunc(modScore) < 65) {
                modGrade = "D";
            } else if(trunc(modScore) < 70) {
                modGrade = "D+";
            } else if(trunc(modScore) < 75) {
                modGrade = "C";
            } else if(trunc(modScore) < 80) {
                modGrade = "C+";
            } else if(trunc(modScore) < 85) {
                modGrade = "B";
            } else if(trunc(modScore) < 90) {
                modGrade = "B+";
            } else if(trunc(modScore) < 95) {
                modGrade = "A";
            } else if(trunc(modScore) <= 100) {
                modGrade = "A+";
            }
            
            // 대학원 70점미만 F
            if("G".equals(uniCd) && trunc(modScore) < 70) {
                modGrade = "F";
            }
        } else if("ABSOLUTE".equals(creCrsEval)) {
            ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
            String uniCd = baseInfoVO.getUniCd();
            
            ScoreOverallVO scoreOverallVO = scoreOverallDAO.selectAbsoluteCalc(modScore);
            modGrade = scoreOverallVO.getMrksGrdGbn();
            
            // 대학원 70점미만 F
            if("G".equals(uniCd) && trunc(modScore) < 70) {
                modGrade = "F";
            }
        } else if("PF".equals(creCrsEval)) {
            ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
            String uniCd = baseInfoVO.getUniCd();
            
            // 등급과 평점 구함
            if("C".equals(uniCd)) {
                //학부 P/F과목 : 60점 기준
                if(trunc(modScore) >= 60) {
                    modGrade = "P";
                } else {
                    modGrade = "F";
                }
            } else {
                //대학원 P/F과목 : 70점 기준
                if(trunc(modScore) >= 70) {
                    modGrade = "P";
                } else {
                    modGrade = "F";
                }
            }
        }
        
        resultVO.setModGrade(modGrade);
        
        return resultVO;
    }
    
    @Override
    public String selectCreCrsEval(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectCreCrsEval(vo);
    }

    private List<ScoreOverallVO> updateTbLmsStdScore(ScoreOverallVO vo) throws Exception {
        List<ScoreOverallVO> resultList = new ArrayList<ScoreOverallVO>();

        ScoreOverallVO pVo = null;

        String middleTestScoreAvg = "";
        String lastTestScoreAvg = "";
        String testScoreAvg = "";
        String lessonScoreAvg = "";
        String assignmentScoreAvg = "";
        String forumScoreAvg = "";
        String quizScoreAvg = "";
        String reshScoreAvg = "";

        for(ScoreOverallListVO item : vo.getList()) {
            if("Y".equals(item.getDataChk())) {
                middleTestScoreAvg = StringUtils.isEmpty(item.getMiddleTestScoreAvg()) ? "0" : "-".equals(item.getMiddleTestScoreAvg()) ? "0" : item.getMiddleTestScoreAvg();
                lastTestScoreAvg = StringUtils.isEmpty(item.getLastTestScoreAvg()) ? "0" : "-".equals(item.getLastTestScoreAvg()) ? "0" : item.getLastTestScoreAvg();
                testScoreAvg = StringUtils.isEmpty(item.getTestScoreAvg()) ? "0" : "-".equals(item.getTestScoreAvg()) ? "0" : item.getTestScoreAvg();
                lessonScoreAvg = StringUtils.isEmpty(item.getLessonScoreAvg()) ? "0" : "-".equals(item.getLessonScoreAvg()) ? "0" : item.getLessonScoreAvg();
                assignmentScoreAvg = StringUtils.isEmpty(item.getAssignmentScoreAvg()) ? "0" : "-".equals(item.getAssignmentScoreAvg()) ? "0" : item.getAssignmentScoreAvg();
                forumScoreAvg = StringUtils.isEmpty(item.getForumScoreAvg()) ? "0" : "-".equals(item.getForumScoreAvg()) ? "0" : item.getForumScoreAvg();
                quizScoreAvg = StringUtils.isEmpty(item.getQuizScoreAvg()) ? "0" : "-".equals(item.getQuizScoreAvg()) ? "0" : item.getQuizScoreAvg();
                reshScoreAvg = StringUtils.isEmpty(item.getReshScoreAvg()) ? "0" : "-".equals(item.getReshScoreAvg()) ? "0" : item.getReshScoreAvg();

                pVo = new ScoreOverallVO();
                pVo.setStdId(item.getStdId());
                //pVo.setTotScore(String.valueOf( Float.parseFloat(item.getFinalScore()) + Float.parseFloat(item.getEtcScoreInput()) ));
                pVo.setFinalScore(String.valueOf( Float.parseFloat(middleTestScoreAvg) + Float.parseFloat(lastTestScoreAvg) + Float.parseFloat(testScoreAvg)+ Float.parseFloat(lessonScoreAvg) + Float.parseFloat(assignmentScoreAvg) + Float.parseFloat(forumScoreAvg)+ Float.parseFloat(quizScoreAvg) + Float.parseFloat(reshScoreAvg)  ));
                pVo.setAddScore(item.getEtcScoreInput());
                pVo.setRgtrId(vo.getRgtrId());
                pVo.setMdfrId(vo.getMdfrId());

                resultList.add(pVo);
            }
        }

        return resultList;
    }

    private List<ScoreOverallVO> updateTbLmsStdScoreItem(ScoreOverallVO vo) throws Exception {
        List<ScoreOverallVO> resultList = new ArrayList<ScoreOverallVO>();

        //강의, 중간, 기말, 상시, 과제, 토론, 퀴즈, 설문
        String[] scoreType = {"1", "2", "3", "4", "5", "6", "7", "8"};

        ScoreOverallVO pVo = null;
        for(ScoreOverallListVO item : vo.getList()) {
            if("Y".equals(item.getDataChk())) {
                for(int i=0; i < scoreType.length; i++) {
                    pVo = new ScoreOverallVO();
                    pVo.setStdId(item.getStdId());
                    if("1".equals(scoreType[i])) {
                        String input = item.getLessonInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getLessonItemId() );
                        pVo.setGetScore(input);
                    } else if("2".equals(scoreType[i])) {
                        String input = item.getMiddleTestInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getMiddleTestItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 2, item.getMiddleTestInput(), vo.getMdfrId());
                    } else if("3".equals(scoreType[i])) {
                        pVo.setScoreItemId( item.getLastTestInput() );
                        String input = item.getLastTestInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getLastTestItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 3, item.getLastTestInput(), vo.getMdfrId());
                    } else if("4".equals(scoreType[i])) {
                        String input = item.getTestInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getTestItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 4, item.getTestInput(), vo.getMdfrId());
                    } else if("5".equals(scoreType[i])) {
                        String input = item.getAssignmentInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }

                        pVo.setScoreItemId( item.getAssignmentItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 5, item.getAssignmentInput(), vo.getMdfrId());
                    } else if("6".equals(scoreType[i])) {
                        String input = item.getForumInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getForumItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 6, item.getForumInput(), vo.getMdfrId());
                    } else if("7".equals(scoreType[i])) {
                        String input = item.getQuizInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getQuizItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 7, item.getQuizInput(), vo.getMdfrId());
                    } else if("8".equals(scoreType[i])) {
                        String input = item.getReshInput();
                        
                        if("-".equals(StringUtil.nvl(input, "-"))) {
                            input = "-1";
                        }
                        
                        pVo.setScoreItemId( item.getReshItemId() );
                        pVo.setGetScore(input);
                        
                        this.updateScoreItemChangeLog(vo.getCrsCreCd(), item.getUserId(), item.getStdId(), 8, item.getReshInput(), vo.getMdfrId());
                    }
                    pVo.setRgtrId(vo.getRgtrId());
                    pVo.setMdfrId(vo.getMdfrId());
                    resultList.add(pVo);
                }
            }
        }

        return resultList;
    }

    @Override
    public ScoreOverallScoreCalVO selectScoreRelConf(ScoreOverallScoreCalVO vo) throws Exception {
        ScoreOverallScoreCalVO resultVO = scoreOverallDAO.selectScoreRelConf(vo);
        int stdTotCnt = scoreOverallDAO.selectStdTotCnt(vo);

        resultVO.setStdTotCnt(stdTotCnt);
        return resultVO;
    }

    @Override
    public void saveRelativeScoreConvert(ScoreOverallScoreCalVO vo) throws Exception {
        /*
        ScoreOverallVO listVo = null;
        List<ScoreOverallVO> list = null;

        ScoreOverallScoreCalVO relVo = null;

        //각 성적에 stdNo 담을 List
        List<ScoreOverallVO> a1List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> a2List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> b1List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> b2List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> c1List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> c2List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> d1List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> d2List = new ArrayList<ScoreOverallVO>();
        List<ScoreOverallVO> fList = new ArrayList<ScoreOverallVO>();

        int a1Cnt = 0;
        int a2Cnt = 0;
        int b1Cnt = 0;
        int b2Cnt = 0;
        int c1Cnt = 0;
        int c2Cnt = 0;
        int d1Cnt = 0;
        int d2Cnt = 0;
        int fCnt = 0;
        */
        int vStdCntInt = 0;

        BigDecimal vStdCnt = null;

        BigDecimal vGradeapRatio = null;
        BigDecimal vGradeaRatio = null;
        BigDecimal vGradebpRatio = null;
        BigDecimal vGradebRatio = null;
        BigDecimal vGradecpRatio = null;
        BigDecimal vGradecRatio = null;
        BigDecimal vGradedpRatio = null;
        BigDecimal vGradedRatio = null;
        BigDecimal vGradefRatio = null;

        BigDecimal vGradeapRcnt = new BigDecimal(0);
        BigDecimal vGradeaRcnt = new BigDecimal(0);
        BigDecimal vGradebpRcnt = new BigDecimal(0);
        BigDecimal vGradebRcnt = new BigDecimal(0);
        BigDecimal vGradecpRcnt = new BigDecimal(0);
        BigDecimal vGradecRcnt = new BigDecimal(0);
        BigDecimal vGradedpRcnt = new BigDecimal(0);
        BigDecimal vGradedRcnt = new BigDecimal(0);
        BigDecimal vGradefRcnt = new BigDecimal(0);

        BigDecimal divide100 = new BigDecimal(100);
        BigDecimal divide94 = new BigDecimal(94);
        BigDecimal divide89 = new BigDecimal(89);
        BigDecimal divide84 = new BigDecimal(84);
        BigDecimal divide80 = new BigDecimal(80);
        BigDecimal divide79 = new BigDecimal(79);
        BigDecimal divide74 = new BigDecimal(74);
        BigDecimal divide69 = new BigDecimal(69);
        BigDecimal divide64 = new BigDecimal(64);
        BigDecimal divide59 = new BigDecimal(59);
        BigDecimal divide40 = new BigDecimal(40);
        BigDecimal divide9 = new BigDecimal(9);
        BigDecimal divide5 = new BigDecimal(5);
        BigDecimal divide4 = new BigDecimal(4);
        BigDecimal divide1 = new BigDecimal(1);

        BigDecimal vAclassRcnt = new BigDecimal(0);
        BigDecimal vBclassRcnt = new BigDecimal(0);

        BigDecimal vGradeAsumRcnt = new BigDecimal(0);
        BigDecimal vGradeAbpsumRcnt = new BigDecimal(0);
        BigDecimal vGradeAbsumRcnt = new BigDecimal(0);
        BigDecimal vGradeAcpsumRcnt = new BigDecimal(0);
        BigDecimal vGradeAcsumRcnt = new BigDecimal(0);
        BigDecimal vGradeAdpsumRcnt = new BigDecimal(0);
        BigDecimal vGradeAdsumRcnt = new BigDecimal(0);

        BigDecimal vAgapRcnt = new BigDecimal(0);
        BigDecimal vGradebpTempRcnt = new BigDecimal(0);

        BigDecimal vAbSumgap = new BigDecimal(0);

        ScoreOverallVO vStdCntVo = null;
        ScoreOverallScoreCalVO pScoreRelVo = null;
        ScoreOverallScoreCalVO rScoreRelVo = null;

        List<ScoreOverallVO> list = null;

        ScoreOverallVO exchPVo = null;
        List<ScoreOverallVO> exchPList = new ArrayList<ScoreOverallVO>();

        List<ScoreOverallVO> rankList = new ArrayList<ScoreOverallVO>();
        ScoreOverallVO rankPVo = null;

        BigDecimal vExchTotScr   = null;
        String     vMrksGrdGbn   = "";
        BigDecimal vMrks         = null;
        BigDecimal vExchGapScr   = null;
        BigDecimal vExchScrLesson     = null;
        BigDecimal vExchScrMidTest     = null;
        BigDecimal vExchScrLastTest     = null;
        BigDecimal vExchScrTest     = null;
        BigDecimal vExchScrAsmt     = null;
        BigDecimal vExchScrForum     = null;
        BigDecimal vExchScrQuiz     = null;
        BigDecimal vExchScrResh     = null;
        BigDecimal calTotScr     = null;
        BigDecimal calScrLesson   = null;
        BigDecimal calScrMidTest  = null;
        BigDecimal calScrLastTest = null;
        BigDecimal calScrTest     = null;
        BigDecimal calScrAsmt     = null;
        BigDecimal calScrForum    = null;
        BigDecimal calScrQuiz     = null;
        BigDecimal calScrResh     = null;

        BigDecimal curRank    = null;
        
        //성적평가대상 학생 수
        vStdCntVo = new ScoreOverallVO();
        vStdCntVo.setOrgId(vo.getOrgId());
        vStdCntVo.setCrsCreCd(vo.getCrsCreCd());
        vStdCntInt = scoreOverallDAO.selectStdCnt(vStdCntVo);
        
        // 성적환산 기준정보 저장
        /*
        String calcType = vo.getCalcType();
        
        // 인원 사용
        if("CNT".equals(StringUtil.nvl(calcType))) {
            BigDecimal stdCntBig = new BigDecimal(vStdCntInt);
            
            BigDecimal cntA1 = new BigDecimal(vo.getCntA1());
            BigDecimal cntA2 = new BigDecimal(vo.getCntA2());
            BigDecimal cntB1 = new BigDecimal(vo.getCntB1());
            BigDecimal cntB2 = new BigDecimal(vo.getCntB2());
            BigDecimal cntC1 = new BigDecimal(vo.getCntC1());
            BigDecimal cntC2 = new BigDecimal(vo.getCntC2());
            BigDecimal cntD1 = new BigDecimal(vo.getCntD1());
            BigDecimal cntD2 = new BigDecimal(vo.getCntD2());
            BigDecimal cntF = new BigDecimal(vo.getCntF());
            
            BigDecimal ratioA1 = cntA1.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioA2 = cntA2.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioB1 = cntB1.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioB2 = cntB2.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioC1 = cntC1.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioC2 = cntC2.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioD1 = cntD1.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioD2 = cntD2.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            BigDecimal ratioF = cntF.divide(stdCntBig, 5, RoundingMode.CEILING).multiply(divide100);
            
            vo.setRatioA1(ratioA1.toString());
            vo.setRatioA2(ratioA2.toString());
            vo.setRatioB1(ratioB1.toString());
            vo.setRatioB2(ratioB2.toString());
            vo.setRatioC1(ratioC1.toString());
            vo.setRatioC2(ratioC2.toString());
            vo.setRatioD1(ratioD1.toString());
            vo.setRatioD2(ratioD2.toString());
            vo.setRatioF(ratioF.toString());
        }
        */
        
        scoreOverallDAO.mergeScoreRel(vo);
        
        // 성적항목 조회
        List<ScoreOverallVO> scoreItemConfList = scoreOverallDAO.selectScoreItemConfList(vStdCntVo);
        for(ScoreOverallVO scoreItemConf : scoreItemConfList) {
            if("LESSON".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                vo.setLessonUseYn("N");
            }
        }

        vStdCnt = new BigDecimal(vStdCntInt);

        //순위계산 - RANK필드 안만들고 쿼리로 따로 계산 skip
        //rankList = scoreOverallDAO.selectRankList(vo);

        rankPVo = new ScoreOverallVO();
        rankPVo.setCrsCreCd(vo.getCrsCreCd());
        rankPVo.setRankRCnt(String.valueOf(vStdCntInt));
        scoreOverallDAO.updateRankList(rankPVo);

        //교수가 입력한 상대평가등급비율별 인원수 산정
        pScoreRelVo = new ScoreOverallScoreCalVO();
        pScoreRelVo.setCrsCreCd(vo.getCrsCreCd());
        rScoreRelVo = scoreOverallDAO.selectScoreRel(pScoreRelVo);
        
        /*
        vGradeapRatio = new BigDecimal(rScoreRelVo.getRatioA1());
        vGradeaRatio  = new BigDecimal(rScoreRelVo.getRatioA2());
        vGradebpRatio = new BigDecimal(rScoreRelVo.getRatioB1());
        vGradebRatio  = new BigDecimal(rScoreRelVo.getRatioB2());
        vGradecpRatio = new BigDecimal(rScoreRelVo.getRatioC1());
        vGradecRatio  = new BigDecimal(rScoreRelVo.getRatioC2());
        vGradedpRatio = new BigDecimal(rScoreRelVo.getRatioD1());
        vGradedRatio  = new BigDecimal(rScoreRelVo.getRatioD2());
        vGradefRatio  = new BigDecimal(rScoreRelVo.getRatioF());
        
        vGradeapRcnt = vStdCnt.multiply( vGradeapRatio.divide(divide100));
        vGradeaRcnt  = vStdCnt.multiply( vGradeaRatio.divide(divide100));
        vGradebpRcnt = vStdCnt.multiply( vGradebpRatio.divide(divide100));
        vGradebRcnt  = vStdCnt.multiply( vGradebRatio.divide(divide100));
        vGradecpRcnt = vStdCnt.multiply( vGradecpRatio.divide(divide100));
        vGradecRcnt  = vStdCnt.multiply( vGradecRatio.divide(divide100));
        vGradedpRcnt = vStdCnt.multiply( vGradedpRatio.divide(divide100));
        vGradedRcnt  = vStdCnt.multiply( vGradedRatio.divide(divide100));
        vGradefRcnt  = vStdCnt.multiply( vGradefRatio.divide(divide100));
        */
        
        vGradeapRcnt = new BigDecimal(vo.getCntA1());
        vGradeaRcnt  = new BigDecimal(vo.getCntA2());
        vGradebpRcnt = new BigDecimal(vo.getCntB1());
        vGradebRcnt  = new BigDecimal(vo.getCntB2());
        vGradecpRcnt = new BigDecimal(vo.getCntC1());
        vGradecRcnt  = new BigDecimal(vo.getCntC2());
        vGradedpRcnt = new BigDecimal(vo.getCntD1());
        vGradedRcnt  = new BigDecimal(vo.getCntD2());
        vGradefRcnt  = new BigDecimal(vo.getCntF());

        //A와 A+ 규정비율에 포함되는 인원수 산정
        vAclassRcnt = (vStdCnt.multiply( divide40.divide(divide100) )).setScale(0, RoundingMode.FLOOR);

        //A와 A+입력된 비율에 대한 인원수 산정
        vGradeAsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt)).doubleValue());
        //A,A+,B 입력된 비율에 대한 인원수 산정
        vGradeAbpsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt)).doubleValue());
        //A,A+,B,B+ 입력된 비율에 대한 인원수 산정
        vGradeAbsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt)).doubleValue());
        //A,A+,B,B+,C+ 입력된 비율에 대한 인원수 산정
        vGradeAcpsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt).add(vGradecpRcnt)).doubleValue());
        //A,A+,B,B+,C+,C 입력된 비율에 대한 인원수 산정
        vGradeAcsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt).add(vGradecpRcnt).add(vGradecRcnt)).doubleValue());
        //A,A+,B,B+,C+,C,D+ 입력된 비율에 대한 인원수 산정
        vGradeAdpsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt).add(vGradecpRcnt).add(vGradecRcnt).add(vGradedpRcnt)).doubleValue());
        //A,A+,B,B+,C+,C,D+ 입력된 비율에 대한 인원수 산정
        vGradeAdsumRcnt = this.sfScorCint((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt).add(vGradecpRcnt).add(vGradecRcnt).add(vGradedpRcnt).add(vGradedRcnt)).doubleValue());

        //A+인원수 조회
        if(vGradeapRcnt.compareTo(BigDecimal.ZERO) == 0) {
            vGradeapRcnt = new BigDecimal(0);
        } else {
            vGradeapRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "A+", (this.sfScorCint(vGradeapRcnt.doubleValue())).setScale(0, RoundingMode.FLOOR).intValue() );
        }

        int compareVal = vGradeaRcnt.compareTo(BigDecimal.ZERO);

        if(compareVal > 0) {
            /*
            //A이상 입력인원수가 규정인원수보다 많으면
            compareVal = vGradeAsumRcnt.compareTo(vAclassRcnt);
            if(compareVal > 0) {
                //규정인원수를 기준으로 A0이상 인원수 산정
                vAclassRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "A", vAclassRcnt.intValue());
            } else {
                //입력인원수를 기준으로 A0이상 인원수 산정
                vAclassRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "A", vGradeAsumRcnt.intValue());
            }
            */
            vAclassRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "A", vGradeAsumRcnt.intValue());

            vGradeaRcnt = vAclassRcnt.subtract( this.sfScorCint(vGradeapRcnt.doubleValue()) );
        } else {
            //A0인원수비율입력되지 않았으면 A이상 건수는 A+인원으로 입력
            //A0인원수는 0
            vAclassRcnt = vGradeapRcnt;
            vGradeaRcnt = BigDecimal.ZERO;
        }

        //실제 A이상 인원수보다 입력된 A이상 인원수가 크면
        /*
        compareVal = vGradeAsumRcnt.compareTo(vAclassRcnt);
        if(compareVal > 0) {
            vAgapRcnt = vGradeAsumRcnt.subtract(vAclassRcnt);
            vGradebpRcnt = this.sfScorCint( (vGradebpRcnt.add(vAgapRcnt)).doubleValue() );
        }
        */

        //입력인원수를 기준으로 B+ 인원수 산정
        vGradebpTempRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "B+",  vGradeAbpsumRcnt.intValue());

        //B+ = B+인원수 - (A+인원수 + A인원수)
        vGradebpRcnt = vGradebpTempRcnt.subtract( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt)).doubleValue() ) );

        //B0비율을 입력한 경우
        compareVal = vGradebRcnt.compareTo(BigDecimal.ZERO);
        if(compareVal > 0) {
            /*
            //B0이상 인원수가 규정인원수 초과인 경우
            compareVal = vGradeAbsumRcnt.compareTo((vStdCnt.multiply( divide80.divide(divide100) )).setScale(0, RoundingMode.FLOOR));
            if(compareVal > 0) {
                //B0이상 규정인원수 산정
                vBclassRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "B", (vStdCnt.multiply( divide80.divide(divide100) ).setScale(0, RoundingMode.FLOOR)).intValue());
            } else {

                //B0이상 입력값 인원수 산정
                vBclassRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "B", vGradeAbsumRcnt.intValue());
            }
            */
            
            //B0이상 입력값 인원수 산정
            if(vGradeAbsumRcnt.compareTo(BigDecimal.ZERO) == 0) {
                vGradebRcnt = BigDecimal.ZERO;
            } else {
                vBclassRcnt = this.sfScorGradeRcntCal(vo.getOrgId(), vo.getCrsCreCd(), "B", vGradeAbsumRcnt.intValue());

                //B0인원수 = B0이상인원수 - ( A+인원수 + A인원수 + B+인원수 )
                vGradebRcnt = vBclassRcnt.subtract( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt)).doubleValue() ).add( this.sfScorCint(vGradebpRcnt.doubleValue()) )  );
            }
        } else {
            //vBclassRcnt = this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt)).doubleValue() );
            vGradebRcnt = BigDecimal.ZERO;
        }


        /*
        //교수가 입력한 상대평가등급비율별 A+~B0까지의 인원수 산정
        vAbSumgap = vAbSumgap.add(vStdCnt.multiply( vGradeapRatio.divide(divide100)));
        vAbSumgap = vAbSumgap.add(vStdCnt.multiply( vGradeaRatio.divide(divide100)));
        vAbSumgap = vAbSumgap.add(vStdCnt.multiply( vGradebpRatio.divide(divide100)));
        vAbSumgap = vAbSumgap.add(vStdCnt.multiply( vGradebRatio.divide(divide100)));


        vAbSumgap = vAbSumgap.subtract( new BigDecimal(Math.round(vBclassRcnt.doubleValue())) );

        //A+에서 B0까지 배정 후 남은인원은 D0,D+,C0,C+순으로 배정함
        if((this.sfScorCint(vGradedRcnt.doubleValue())).compareTo(BigDecimal.ZERO) > 0) {
            vGradedRcnt = this.sfScorCint(vAbSumgap.doubleValue()).add(vGradedRcnt);
        } else if((this.sfScorCint(vGradedpRcnt.doubleValue())).compareTo(BigDecimal.ZERO) > 0 && (this.sfScorCint(vGradedRcnt.doubleValue())).compareTo(BigDecimal.ZERO) == 0) {
            vGradedpRcnt = this.sfScorCint(vAbSumgap.doubleValue()).add(this.sfScorCint(vGradedpRcnt.doubleValue()));
        } else if(this.sfScorCint(vGradecRcnt.doubleValue()).compareTo(BigDecimal.ZERO) > 0 && (this.sfScorCint(vGradedRcnt.doubleValue()).add(this.sfScorCint(vGradedpRcnt.doubleValue()))).compareTo(BigDecimal.ZERO) == 0 ) {
            vGradecRcnt = this.sfScorCint(vAbSumgap.doubleValue()).add(this.sfScorCint(vGradecRcnt.doubleValue()));
        } else if(this.sfScorCint(vGradecpRcnt.doubleValue()).compareTo(BigDecimal.ZERO) > 0 && (this.sfScorCint(vGradedRcnt.doubleValue()).add(this.sfScorCint(vGradedpRcnt.doubleValue())).add(this.sfScorCint(vGradecRcnt.doubleValue()))).compareTo(BigDecimal.ZERO) == 0 ) {
            vGradecpRcnt = this.sfScorCint(vAbSumgap.doubleValue()).add(this.sfScorCint(vGradecpRcnt.doubleValue()));
        }
        */
        
        BigDecimal vResultAbSumRCnt = vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt);
        
        if(vGradeAbsumRcnt.compareTo(vResultAbSumRCnt) > 0) {
            vAbSumgap = vGradeAbsumRcnt.subtract(vResultAbSumRCnt);
            
            if(vGradecpRcnt.compareTo(BigDecimal.ZERO) > 0) {
                vGradecpRcnt = vGradecpRcnt.add(vAbSumgap);
            } else if(vGradecRcnt.compareTo(BigDecimal.ZERO) > 0) {
                vGradecRcnt = vGradecRcnt.add(vAbSumgap);
            } else if(vGradedpRcnt.compareTo(BigDecimal.ZERO) > 0) {
                vGradedpRcnt = vGradedpRcnt.add(vAbSumgap);
            } else if(vGradedRcnt.compareTo(BigDecimal.ZERO) > 0) {
                vGradedRcnt = vGradedRcnt.add(vAbSumgap);
            }
        }

        //순위계산을 기준으로 등급과 환산점수 설정
        list = scoreOverallDAO.selectMrksRankList(vo);
        for(ScoreOverallVO listVo : list) {
            //초기화
            calTotScr = new BigDecimal(listVo.getCalTotScr());
            calScrLesson   = new BigDecimal(listVo.getLessonScoreAvg());
            calScrMidTest  = new BigDecimal(listVo.getMiddleTestScoreAvg());
            calScrLastTest = new BigDecimal(listVo.getLastTestScoreAvg());
            calScrTest     = new BigDecimal(listVo.getTestScoreAvg());
            calScrAsmt     = new BigDecimal(listVo.getAssignmentScoreAvg());
            calScrForum    = new BigDecimal(listVo.getForumScoreAvg());
            calScrQuiz     = new BigDecimal(listVo.getQuizScoreAvg());
            calScrResh     = new BigDecimal(listVo.getReshScoreAvg());

            vExchTotScr   = new BigDecimal(0);
            vMrksGrdGbn   = "";
            vMrks         = new BigDecimal(0);
            vExchGapScr   = new BigDecimal(0);
            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);

            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);

            curRank = new BigDecimal(listVo.getRanking());
            //A+등급 대상
            compareVal = curRank.compareTo( this.sfScorCint(vGradeapRcnt.doubleValue()) );
            if(compareVal < 0 || compareVal == 0) {
                // 100 - |5/|(동점자체크 값 - 1)| * (RANK - 1)|
                if(vGradeapRcnt.equals(divide1)) {
                    vExchTotScr = divide100.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide100.subtract((divide5.divide( (vGradeapRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract(divide1))).abs());
                }

                vMrksGrdGbn = "A+";
                vMrks = BigDecimal.valueOf(4.5);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(95) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(95);
                }
            //A0 등급 대상
            } else if(curRank.compareTo( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt)).doubleValue()) ) < 0
                    || curRank.compareTo( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt)).doubleValue()) ) == 0 ) {
                // 94 - |4/|(동점자체크 값 - 1)| * (RANK - A+ 결과 행 - 1)|
                if(vGradeaRcnt.equals(divide1)) {
                    vExchTotScr = divide94.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide94.subtract((divide4.divide( (vGradeaRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract(vGradeapRcnt.setScale(10, RoundingMode.UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "A";
                vMrks = BigDecimal.valueOf(4.0);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(90) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(90);
                }
            //B+ 등급 대상
            } else if(curRank.compareTo( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt)).doubleValue()) ) < 0
                        || curRank.compareTo( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt)).doubleValue()) ) == 0) {
                // 89 - |4/|(동점자체크 값 - 1)| * (RANK - A 결과 행 - 1)|
                if(vGradebpRcnt.equals(divide1)) {
                    vExchTotScr = divide89.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide89.subtract((divide4.divide( (vGradebpRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vGradeapRcnt.add(vGradeaRcnt)).setScale(10, RoundingMode.UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "B+";
                vMrks = BigDecimal.valueOf(3.5);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(85) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(85);
                }
            //B0 등급 대상
            } else if(curRank.compareTo( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt)).doubleValue()) ) < 0
                    || curRank.compareTo( this.sfScorCint( (vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt)).doubleValue()) ) == 0) {
                // 84 - |4/|(동점자체크 값 - 1)| * (RANK - B+ 결과 행 - 1)|
                if(vGradebRcnt.equals(divide1)) {
                    vExchTotScr = divide84.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide84.subtract((divide4.divide( (vGradebRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt)).setScale(10, RoundingMode.UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "B";
                vMrks = BigDecimal.valueOf(3.0);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(80) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(80);
                }
            //C+ 등급 대상
            } else if(curRank.compareTo( vGradeAcpsumRcnt ) < 0
                    || curRank.compareTo( vGradeAcpsumRcnt ) == 0) {
                // 79 - |4/|(입력 - 1)| * (RANK - 누적입력 - 1)|
                if(vGradecpRcnt.equals(divide1)) {
                    vExchTotScr = divide79.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide79.subtract((divide4.divide( (vGradecpRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vResultAbSumRCnt).setScale(10, RoundingMode.UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "C+";
                vMrks = BigDecimal.valueOf(2.5);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(75) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(75);
                }
                
                // System.out.println("테스트 : " + calTotScr + " , " + vExchTotScr);
            //C0 등급 대상
            } else if(curRank.compareTo( vGradeAcsumRcnt ) < 0
                    || curRank.compareTo( vGradeAcsumRcnt ) == 0) {
                // 74 - |4/|(입력 - 1)| * (RANK - 누적입력 - 1)|
                if(vGradecRcnt.equals(divide1)) {
                    vExchTotScr = divide74.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide74.subtract((divide4.divide( (vGradecRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vGradeAcpsumRcnt).setScale(10, RoundingMode.UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "C";
                vMrks = BigDecimal.valueOf(2.0);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(70) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(70);
                }
            //D+ 등급 대상
            } else if(curRank.compareTo( vGradeAdpsumRcnt ) < 0
                    || curRank.compareTo( vGradeAdpsumRcnt ) == 0) {
                // 69 - |4/|(입력 - 1)| * (RANK - 누적입력 - 1)|
                if(vGradedpRcnt.equals(divide1)) {
                    vExchTotScr = divide69.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide69.subtract((divide4.divide( (vGradedpRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vGradeAcsumRcnt).setScale(10, RoundingMode.UP)).subtract(divide1))).abs());

                }

                vMrksGrdGbn = "D+";
                vMrks = BigDecimal.valueOf(1.5);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(65) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(65);
                }
            //D0 등급 대상
            } else if(curRank.compareTo( vGradeAdsumRcnt ) < 0
                    || curRank.compareTo( vGradeAdsumRcnt ) == 0) {
                // 64 - |4/|(입력 - 1)| * (RANK - 누적입력 - 1)|
                if(vGradedRcnt.equals(divide1)) {
                    vExchTotScr = divide64.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide64.subtract((divide4.divide( (vGradedRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vGradeAdpsumRcnt).setScale(10, RoundingMode.UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "D";
                vMrks = BigDecimal.valueOf(1.0);

                compareVal = vExchTotScr.compareTo( BigDecimal.valueOf(60) );

                if(compareVal < 0) {
                    vExchTotScr = BigDecimal.valueOf(60);
                }
            } else {
                vGradefRcnt = vStdCnt.subtract( (vGradeapRcnt.add(vGradeaRcnt).add(vGradebpRcnt).add(vGradebRcnt).add(vGradecpRcnt).add(vGradecRcnt).add(vGradedpRcnt).add(vGradedRcnt)).setScale(0, RoundingMode.HALF_UP) );

                // 59 - |9/|(입력 - 1)| * (RANK - 누적입력 - 1)|
                if(vGradefRcnt.equals(divide1)) {
                    vExchTotScr = divide59.subtract((BigDecimal.ZERO).multiply(curRank.subtract(divide1)).abs());
                } else {
                    vExchTotScr = divide59.subtract((divide9.divide( (vGradefRcnt.subtract(divide1)).abs(), 10,RoundingMode.UP).multiply(curRank.subtract((vGradeAdsumRcnt).setScale(0, RoundingMode.HALF_UP)).subtract(divide1))).abs());
                }

                vMrksGrdGbn = "F";
                vMrks = BigDecimal.valueOf(0.0);
            }


            if(calTotScr.equals(BigDecimal.ZERO) || calTotScr.equals(BigDecimal.valueOf(0.0))) {
                vExchScrLesson   = new BigDecimal(0);
                vExchScrMidTest  = new BigDecimal(0);
                vExchScrLastTest = new BigDecimal(0);
                vExchScrTest     = new BigDecimal(0);
                vExchScrAsmt     = new BigDecimal(0);
                vExchScrForum    = new BigDecimal(0);
                vExchScrQuiz     = new BigDecimal(0);
                vExchScrResh     = new BigDecimal(0);
                vExchTotScr      = new BigDecimal(0);
                vMrksGrdGbn      = "F";
                vMrks            = new BigDecimal(0);
                vExchGapScr      = new BigDecimal(0);
            } else {
                vExchScrLesson   = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrLesson).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrMidTest  = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrMidTest).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrLastTest = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrLastTest).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrTest     = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrTest).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrAsmt     = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrAsmt).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrForum    = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrForum).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrQuiz     = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrQuiz).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
                vExchScrResh     = (((vExchTotScr.divide(calTotScr, 10,RoundingMode.UP)).multiply(calScrResh).multiply(divide100)).setScale(0, RoundingMode.FLOOR)).divide(divide100);
            }

            //합계 성적을 100.00을 맞추기 위해 모자라는 값을 출석점수에 더해준다. 수정 2002.10.08 서권식

            compareVal = vExchTotScr.compareTo( vExchScrLesson.add(vExchScrMidTest).add(vExchScrLastTest).add(vExchScrTest).add(vExchScrAsmt).add(vExchScrForum).add(vExchScrQuiz).add(vExchScrResh) );
            if(compareVal > 0) {
                vExchScrLesson = vExchScrLesson.add( vExchTotScr.subtract( vExchScrLesson.add(vExchScrMidTest).add(vExchScrLastTest).add(vExchScrTest).add(vExchScrAsmt).add(vExchScrForum).add(vExchScrQuiz).add(vExchScrResh) ) );
            }

            vExchTotScr = this.sfScorCint( (vExchTotScr.multiply(divide100)).doubleValue() );
            vExchTotScr = vExchTotScr.divide( divide100 );

            vExchGapScr = this.sfScorCint( (((vExchTotScr.subtract(calTotScr)).abs()).multiply(divide100)).doubleValue() );
            vExchGapScr = vExchGapScr.divide( divide100 );

            exchPVo = new ScoreOverallVO();

            exchPVo.setStdId(listVo.getStdId());

            exchPVo.setCalScrMidTest( String.valueOf(calScrMidTest) );
            exchPVo.setCalScrLastTest( String.valueOf(calScrLastTest) );
            exchPVo.setCalScrAsmnt( String.valueOf(calScrAsmt) );
            exchPVo.setCalScrLesson( String.valueOf(calScrLesson) );
            exchPVo.setCalScrForum(String.valueOf(calScrForum));
            exchPVo.setCalScrTest(String.valueOf(calScrTest));
            exchPVo.setCalScrQuiz(String.valueOf(calScrQuiz));
            exchPVo.setCalScrResh(String.valueOf(calScrResh));
            exchPVo.setCalTotScr(String.valueOf(calTotScr));
            exchPVo.setExchScrMidTest( String.valueOf(vExchScrMidTest) );
            exchPVo.setExchScrLastTest( String.valueOf(vExchScrLastTest) );
            exchPVo.setExchScrAsmnt( String.valueOf(vExchScrAsmt) );
            exchPVo.setExchScrLesson( String.valueOf(vExchScrLesson) );
            exchPVo.setExchScrForum(String.valueOf(vExchScrForum));
            exchPVo.setExchScrTest(String.valueOf(vExchScrTest));
            exchPVo.setExchScrQuiz(String.valueOf(vExchScrQuiz));
            exchPVo.setExchScrResh(String.valueOf(vExchScrResh));
            exchPVo.setExchTotScr(String.valueOf(vExchTotScr));
            exchPVo.setMrks(String.valueOf(vMrks));
            exchPVo.setScoreGrade(vMrksGrdGbn);
            exchPVo.setExchGapScr(String.valueOf(vExchGapScr));
            exchPVo.setTotScore(String.valueOf(vExchTotScr));
            exchPVo.setScoreStatus("3");
            exchPVo.setMdfrId(vo.getRgtrId());

            exchPList.add(exchPVo);
        }

        if(exchPList != null) {
            if(exchPList.size() > 0) {
                scoreOverallDAO.updateOverallExchData(exchPList);
            }
        }


        // 출결 F처리
        list = scoreOverallDAO.selectMrksNotRankList(vo);

        exchPList = new ArrayList<ScoreOverallVO>();
        for(ScoreOverallVO listVo : list) {
            //초기화
            calTotScr = new BigDecimal(listVo.getCalTotScr());
            calScrLesson   = new BigDecimal(listVo.getLessonScoreAvg());
            calScrMidTest  = new BigDecimal(listVo.getMiddleTestScoreAvg());
            calScrLastTest = new BigDecimal(listVo.getLastTestScoreAvg());
            calScrTest     = new BigDecimal(listVo.getTestScoreAvg());
            calScrAsmt     = new BigDecimal(listVo.getAssignmentScoreAvg());
            calScrForum    = new BigDecimal(listVo.getForumScoreAvg());
            calScrQuiz     = new BigDecimal(listVo.getQuizScoreAvg());
            calScrResh     = new BigDecimal(listVo.getReshScoreAvg());

            vExchTotScr   = new BigDecimal(0);
            vMrksGrdGbn   = "";
            vMrks         = new BigDecimal(0);
            vExchGapScr   = new BigDecimal(0);
            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);

            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);

            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);
            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);
            vExchTotScr      = new BigDecimal(0);
            vMrksGrdGbn      = "F";
            vMrks            = new BigDecimal(0);
            vExchGapScr      = new BigDecimal(0);

            exchPVo = new ScoreOverallVO();

            exchPVo.setStdId(listVo.getStdId());
            exchPVo.setCalScrMidTest( String.valueOf(calScrMidTest) );
            exchPVo.setCalScrLastTest( String.valueOf(calScrLastTest) );
            exchPVo.setCalScrAsmnt( String.valueOf(calScrAsmt) );
            exchPVo.setCalScrLesson( String.valueOf(calScrLesson) );
            exchPVo.setCalScrForum(String.valueOf(calScrForum));
            exchPVo.setCalScrTest(String.valueOf(calScrTest));
            exchPVo.setCalScrQuiz(String.valueOf(calScrQuiz));
            exchPVo.setCalScrResh(String.valueOf(calScrResh));
            exchPVo.setCalTotScr("0");
            exchPVo.setExchScrMidTest( String.valueOf(vExchScrMidTest) );
            exchPVo.setExchScrLastTest( String.valueOf(vExchScrLastTest) );
            exchPVo.setExchScrAsmnt( String.valueOf(vExchScrAsmt) );
            exchPVo.setExchScrLesson( String.valueOf(vExchScrLesson) );
            exchPVo.setExchScrForum(String.valueOf(vExchScrForum));
            exchPVo.setExchScrTest(String.valueOf(vExchScrTest));
            exchPVo.setExchScrQuiz(String.valueOf(vExchScrQuiz));
            exchPVo.setExchScrResh(String.valueOf(vExchScrResh));
            exchPVo.setExchTotScr(String.valueOf(vExchTotScr));
            exchPVo.setMrks(String.valueOf(vMrks));
            exchPVo.setScoreGrade(vMrksGrdGbn);
            exchPVo.setExchGapScr(String.valueOf(vExchGapScr));
            exchPVo.setTotScore(String.valueOf(vExchTotScr));
            exchPVo.setScoreStatus("3");
            exchPVo.setMdfrId(vo.getRgtrId());

            exchPList.add(exchPVo);
        }

        if(exchPList != null) {
            if(exchPList.size() > 0) {
                scoreOverallDAO.updateOverallExchData(exchPList);
            }
        }
        this.spScorMrksHistCrea(vo.getCrsCreCd(), vo.getRgtrId(), "[성적환산:상대평가]", vo.getRgtrId());
    }

    /*****************************************************************************************
       내용              : ASP의 CINT와 같은역할의 함수만듬
                           - 0.5  -> 0
                           - 1.5  -> 2
                           - 0.51 -> 1
                           - 2.5  -> 2
    RETURN 값       : 정수
    *******************************************************************************************/
    private BigDecimal sfScorCint(double scr) throws Exception{
        /*
        BigDecimal param = new BigDecimal(scr);

        BigDecimal result = new BigDecimal(0);

        BigDecimal tempScr = new BigDecimal(0);
        BigDecimal oriCutScr = new BigDecimal(0);
        BigDecimal upCutScr = new BigDecimal(0);

        BigDecimal multiply10 = new BigDecimal(10);


        BigDecimal compare5 = new BigDecimal(5);

        BigInteger oriCutScrInt = new BigInteger("1");
        BigInteger mod2 = new BigInteger("2");
        BigDecimal plus1 = new BigDecimal(1);

        String type = "CINT";

        //AS-IS로직으로 돌기
        if("CINT".equals(type)) {
            oriCutScr = param.setScale(0, RoundingMode.FLOOR);
            tempScr = ( (param.setScale(0, RoundingMode.FLOOR).subtract(param) ).abs() ).multiply(multiply10);
            upCutScr = tempScr.setScale(0, RoundingMode.FLOOR);
            oriCutScrInt = oriCutScr.toBigInteger();
            if(upCutScr.compareTo(compare5) == 0) {
                // .5이하의 자리수가 없는 경우(즉 소수점 2자리부터는 겂이 없는 경우 정확인 .5인 경우)
                if(upCutScr.compareTo(tempScr) == 0) {
                    if(oriCutScrInt.mod(mod2).equals(BigInteger.ZERO)) {
                        result = oriCutScr;
                    } else {
                        result = oriCutScr.add(plus1);
                    }
                } else {
                    result = param.setScale(0, RoundingMode.HALF_UP);
                }
            } else {
                result = param.setScale(0, RoundingMode.HALF_UP);
            }
        } else {
            result = param.setScale(0, RoundingMode.HALF_UP);
        }
        */
        ScoreOverallVO pVo = new ScoreOverallVO();

        pVo.setpScr(scr);

        float result2 = scoreOverallDAO.selectFnScorCint(pVo);

        BigDecimal result = new BigDecimal(result2);
        return result;
    }
    /*****************************************************************************************
       내용              : 성적등급별인원수 산출
    2020.12.18     김창섭     B+동점자범위내외 지정추가
                            (기존 CS에서 조직에서 변경)
   *******************************************************************************************/
    private BigDecimal sfScorGradeRcntCal(String orgId, String crsCreCd, String grade, int rcnt) throws Exception{
        BigDecimal result = new BigDecimal(0);

        int apobjRcnt = 0;
        int aobjRcnt = 0;
        int bobjRcnt = 0;

        int gapRcnt = 0;
        int rankRcnt = 0;

        ScoreOverallVO vo = new ScoreOverallVO();
        vo.setOrgId(orgId);
        vo.setCrsCreCd(crsCreCd);
        vo.setRcnt(String.valueOf(rcnt));
        int stdCnt = scoreOverallDAO.selectStdCnt(vo);

        apobjRcnt = (int) Math.floor( stdCnt * 0.2 ); // A+규정인원수
        aobjRcnt = (int) Math.floor( stdCnt * 0.4 ); // A+ ~ A규정인원수
        bobjRcnt = (int) Math.floor( stdCnt * 0.8 ); // A+ ~ B규정인원수

        ScoreOverallVO p1 = scoreOverallDAO.selectDenseRankMax(vo);

        String pRno = p1.getRno();
        String pMarkRank = p1.getMarkRank();

        /*
        String grade2 = "";
        String overYn = "";
        if("B+".equals(grade)) {
            grade2 = grade.substring(0, 1);
            overYn = "N";

            // B+등급인원이 B전체를 OVER하는 경우
            if(rcnt > bobjRcnt && "B".equals(grade2)) {
                overYn = "Y";
            }

            if("Y".equals(overYn) && "B".equals(grade2)) {
                pMarkRank = (this.sfScorGradeRcntCal(orgId, crsCreCd, grade2, rcnt)).toString();
            } else {
                vo.setGrade(pMarkRank);
                ScoreOverallVO p2 = scoreOverallDAO.selectDenseRankMaxForRank(vo);

                pRno = p2.getRno();
                pMarkRank = p2.getMarkRank();
            }

            // 추가
            vo.setRcnt( String.valueOf( rcnt+1 ) );
            ScoreOverallVO p3 = scoreOverallDAO.selectDenseRankMaxForRankPlus(vo);

            if(Integer.parseInt(pRno) > Integer.parseInt(pMarkRank) && "B".equals(grade2) ) {
                if(pMarkRank.equals(p3.getMarkRank())) {
                    pRno = String.valueOf(Integer.parseInt(pMarkRank) - 1);
                }
            }

            pMarkRank = pRno;
        }
        */

        if( "A+".equals(grade) || "A".equals(grade) || "B+".equals(grade) || "B".equals(grade)) {
            if("A+".equals(grade) && rcnt < apobjRcnt) {
                gapRcnt = apobjRcnt - rcnt; // A+규정인원수 - 입력한 수
            } else if("A".equals(grade) && rcnt < aobjRcnt) {
                gapRcnt = aobjRcnt - rcnt;  // A+ ~ A규정인원수 - 입력한 수
            } else if(("B+".equals(grade) || "B".equals(grade)) && rcnt < bobjRcnt) {
                gapRcnt = bobjRcnt - rcnt;  // A+ ~ B규정인원수 - 입력한 수
            }

            vo.setMarkRank(pMarkRank);
            vo.setRno(pRno);

            // 동점자 수
            rankRcnt = scoreOverallDAO.selectRankRcnt(vo);

            if(rankRcnt > 0) {
                if(gapRcnt >= rankRcnt) {
                    pMarkRank = pMarkRank;
                } else {
                    // 동점자 수가 규정인원수 갭보다 작으면, 랭크 - 1
                    pMarkRank = String.valueOf(Integer.parseInt(pMarkRank) - 1);
                }
            } else {
                pMarkRank = pMarkRank;
            }

            // 랭크의 동점자를 포함한 최대인원 수
            vo.setMarkRank(pMarkRank);
            String mrksRankTemp = scoreOverallDAO.selectMrksRankTemp(vo);

            if(mrksRankTemp != null) {
                pMarkRank =  mrksRankTemp;
            }
        }

        //return vMrksRank;
        pMarkRank = pMarkRank == null ? "0" : pMarkRank;
        result = new BigDecimal(pMarkRank);
        return result;
    }

    @Override
    public void saveAbsoluteScoreConvert(ScoreOverallScoreCalVO vo) throws Exception {
        ScoreOverallVO basePVo = null;
        ScoreOverallVO baseRVo = null;

        ScoreOverallVO absoluteCalcVo = null;

        int vStdCntInt = 0;
        BigDecimal vStdCnt = null;

        String     vMrksGrdGbn   = "";
        BigDecimal vMrks         = null;
        BigDecimal calTotScr     = null;
        BigDecimal calScrLesson   = null;
        BigDecimal calScrMidTest  = null;
        BigDecimal calScrLastTest = null;
        BigDecimal calScrTest     = null;
        BigDecimal calScrAsmt     = null;
        BigDecimal calScrForum    = null;
        BigDecimal calScrQuiz     = null;
        BigDecimal calScrResh     = null;

        BigDecimal vExchTotScr   = null;
        BigDecimal vExchGapScr   = null;
        BigDecimal vExchScrLesson     = null;
        BigDecimal vExchScrMidTest     = null;
        BigDecimal vExchScrLastTest     = null;
        BigDecimal vExchScrTest     = null;
        BigDecimal vExchScrAsmt     = null;
        BigDecimal vExchScrForum     = null;
        BigDecimal vExchScrQuiz     = null;
        BigDecimal vExchScrResh     = null;

        BigDecimal curRank    = null;

        ScoreOverallVO vStdCntVo = new ScoreOverallVO();

        ScoreOverallVO exchPVo = null;
        List<ScoreOverallVO> exchPList = new ArrayList<ScoreOverallVO>();


        List<ScoreOverallVO> list = null;

        // 1.기준 데이터 리스트 조회
        basePVo = new ScoreOverallVO();
        basePVo.setCrsCreCd(vo.getCrsCreCd());
        
        List<ScoreOverallVO> scoreItemConfList = scoreOverallDAO.selectScoreItemConfList(basePVo);
        for(ScoreOverallVO scoreItemConf : scoreItemConfList) {
            if("LESSON".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                vo.setLessonUseYn("N");
            }
        }

        // 성적부여방법구분, 성적등급부여구분, 상대평가여부 조회
        baseRVo = scoreOverallDAO.selectAbsoluteBaseInfo(basePVo);

        //성적평가대상 학생 수
        vStdCntVo = new ScoreOverallVO();
        vStdCntVo.setOrgId(vo.getOrgId());
        vStdCntVo.setCrsCreCd(vo.getCrsCreCd());
        vStdCntInt = scoreOverallDAO.selectStdCnt(vStdCntVo);

        vStdCnt = new BigDecimal(vStdCntInt);

        list = scoreOverallDAO.selectMrksRankList(vo);

        for(ScoreOverallVO listVo : list) {
            //초기화
            calTotScr = new BigDecimal(listVo.getCalTotScr());
            calScrLesson   = new BigDecimal(listVo.getLessonScoreAvg());
            calScrMidTest  = new BigDecimal(listVo.getMiddleTestScoreAvg());
            calScrLastTest = new BigDecimal(listVo.getLastTestScoreAvg());
            calScrTest     = new BigDecimal(listVo.getTestScoreAvg());
            calScrAsmt     = new BigDecimal(listVo.getAssignmentScoreAvg());
            calScrForum    = new BigDecimal(listVo.getForumScoreAvg());
            calScrQuiz     = new BigDecimal(listVo.getQuizScoreAvg());
            calScrResh     = new BigDecimal(listVo.getReshScoreAvg());

            vMrksGrdGbn   = "";
            vMrks         = new BigDecimal(0);

            // 등급과 평점 구함
            absoluteCalcVo = scoreOverallDAO.selectAbsoluteCalc(listVo.getFlExchScr());

            vMrksGrdGbn = absoluteCalcVo.getMrksGrdGbn();
            vMrks = new BigDecimal(absoluteCalcVo.getMrks());

            if("G".equals(baseRVo.getUniCd()) && trunc(listVo.getFlExchScr()) < 70) {
                //대학원 70점 미만인 경우 F 처리
                vMrksGrdGbn = "F";
                vMrks = new BigDecimal(0);
            }

            exchPVo = new ScoreOverallVO();

            exchPVo.setStdId(listVo.getStdId());
            exchPVo.setCalScrMidTest( String.valueOf(calScrMidTest) );
            exchPVo.setCalScrLastTest( String.valueOf(calScrLastTest) );
            exchPVo.setCalScrAsmnt( String.valueOf(calScrAsmt) );
            exchPVo.setCalScrLesson( String.valueOf(calScrLesson) );
            exchPVo.setCalScrForum(String.valueOf(calScrForum));
            exchPVo.setCalScrTest(String.valueOf(calScrTest));
            exchPVo.setCalScrQuiz(String.valueOf(calScrQuiz));
            exchPVo.setCalScrResh(String.valueOf(calScrResh));
            exchPVo.setCalTotScr(String.valueOf(calTotScr));
            exchPVo.setExchScrMidTest( listVo.getMiddleTestScoreAvg() );
            exchPVo.setExchScrLastTest( listVo.getLastTestScoreAvg() );
            exchPVo.setExchScrAsmnt( listVo.getAssignmentScoreAvg() );
            exchPVo.setExchScrLesson( listVo.getLessonScoreAvg() );
            exchPVo.setExchScrForum( listVo.getForumScoreAvg() );
            exchPVo.setExchScrTest( listVo.getTestScoreAvg() );
            exchPVo.setExchScrQuiz( listVo.getQuizScoreAvg() );
            exchPVo.setExchScrResh( listVo.getReshScoreAvg() );
            exchPVo.setExchTotScr( listVo.getFlExchScr() );
            exchPVo.setMrks(String.valueOf(vMrks));
            exchPVo.setScoreGrade(vMrksGrdGbn);
            exchPVo.setTotScore( listVo.getFlExchScr() );
            exchPVo.setScoreStatus("3");
            exchPVo.setMdfrId(vo.getRgtrId());

            exchPList.add(exchPVo);
        }

        if(exchPList != null) {
            if(exchPList.size() > 0) {
                scoreOverallDAO.updateOverallExchData(exchPList);
            }
        }
        
        // 출결 F처리
        list = scoreOverallDAO.selectMrksNotRankList(vo);

        exchPList = new ArrayList<ScoreOverallVO>();
        for(ScoreOverallVO listVo : list) {
            //초기화
            calTotScr = new BigDecimal(listVo.getCalTotScr());
            calScrLesson   = new BigDecimal(listVo.getLessonScoreAvg());
            calScrMidTest  = new BigDecimal(listVo.getMiddleTestScoreAvg());
            calScrLastTest = new BigDecimal(listVo.getLastTestScoreAvg());
            calScrTest     = new BigDecimal(listVo.getTestScoreAvg());
            calScrAsmt     = new BigDecimal(listVo.getAssignmentScoreAvg());
            calScrForum    = new BigDecimal(listVo.getForumScoreAvg());
            calScrQuiz     = new BigDecimal(listVo.getQuizScoreAvg());
            calScrResh     = new BigDecimal(listVo.getReshScoreAvg());

            vExchTotScr   = new BigDecimal(0);
            vMrksGrdGbn   = "";
            vMrks         = new BigDecimal(0);
            vExchGapScr   = new BigDecimal(0);
            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);

            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);

            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);
            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);
            vExchTotScr      = new BigDecimal(0);
            vMrksGrdGbn      = "F";
            vMrks            = new BigDecimal(0);
            vExchGapScr      = new BigDecimal(0);

            exchPVo = new ScoreOverallVO();

            exchPVo.setStdId(listVo.getStdId());
            exchPVo.setCalScrMidTest( String.valueOf(calScrMidTest) );
            exchPVo.setCalScrLastTest( String.valueOf(calScrLastTest) );
            exchPVo.setCalScrAsmnt( String.valueOf(calScrAsmt) );
            exchPVo.setCalScrLesson( String.valueOf(calScrLesson) );
            exchPVo.setCalScrForum(String.valueOf(calScrForum));
            exchPVo.setCalScrTest(String.valueOf(calScrTest));
            exchPVo.setCalScrQuiz(String.valueOf(calScrQuiz));
            exchPVo.setCalScrResh(String.valueOf(calScrResh));
            exchPVo.setCalTotScr("0");
            exchPVo.setExchScrMidTest( String.valueOf(vExchScrMidTest) );
            exchPVo.setExchScrLastTest( String.valueOf(vExchScrLastTest) );
            exchPVo.setExchScrAsmnt( String.valueOf(vExchScrAsmt) );
            exchPVo.setExchScrLesson( String.valueOf(vExchScrLesson) );
            exchPVo.setExchScrForum(String.valueOf(vExchScrForum));
            exchPVo.setExchScrTest(String.valueOf(vExchScrTest));
            exchPVo.setExchScrQuiz(String.valueOf(vExchScrQuiz));
            exchPVo.setExchScrResh(String.valueOf(vExchScrResh));
            exchPVo.setExchTotScr(String.valueOf(vExchTotScr));
            exchPVo.setMrks(String.valueOf(vMrks));
            exchPVo.setScoreGrade(vMrksGrdGbn);
            exchPVo.setExchGapScr(String.valueOf(vExchGapScr));
            exchPVo.setTotScore(String.valueOf(vExchTotScr));
            exchPVo.setScoreStatus("3");
            exchPVo.setMdfrId(vo.getRgtrId());

            exchPList.add(exchPVo);
        }

        if(exchPList != null) {
            if(exchPList.size() > 0) {
                scoreOverallDAO.updateOverallExchData(exchPList);
            }
        }

        this.spScorMrksHistCrea(vo.getCrsCreCd(), vo.getRgtrId(), "[성적환산:절대평가]", vo.getRgtrId());
    }

    @Override
    public void savePfScoreConvert(ScoreOverallScoreCalVO vo) throws Exception {
        ScoreOverallVO basePVo = null;
        ScoreOverallVO baseRVo = null;

        ScoreOverallVO absoluteCalcVo = null;

        int vStdCntInt = 0;
        BigDecimal vStdCnt = null;

        String     vMrksGrdGbn   = "";
        BigDecimal vMrks         = null;
        BigDecimal calTotScr     = null;
        BigDecimal calScrLesson   = null;
        BigDecimal calScrMidTest  = null;
        BigDecimal calScrLastTest = null;
        BigDecimal calScrTest     = null;
        BigDecimal calScrAsmt     = null;
        BigDecimal calScrForum    = null;
        BigDecimal calScrQuiz     = null;
        BigDecimal calScrResh     = null;

        BigDecimal vExchTotScr   = null;
        BigDecimal vExchGapScr   = null;
        BigDecimal vExchScrLesson     = null;
        BigDecimal vExchScrMidTest     = null;
        BigDecimal vExchScrLastTest     = null;
        BigDecimal vExchScrTest     = null;
        BigDecimal vExchScrAsmt     = null;
        BigDecimal vExchScrForum     = null;
        BigDecimal vExchScrQuiz     = null;
        BigDecimal vExchScrResh     = null;

        ScoreOverallVO vStdCntVo = new ScoreOverallVO();

        ScoreOverallVO exchPVo = null;
        List<ScoreOverallVO> exchPList = new ArrayList<ScoreOverallVO>();


        List<ScoreOverallVO> list = null;

        // 1.기준 데이터 리스트 조회
        basePVo = new ScoreOverallVO();
        basePVo.setCrsCreCd(vo.getCrsCreCd());
        
        List<ScoreOverallVO> scoreItemConfList = scoreOverallDAO.selectScoreItemConfList(basePVo);
        for(ScoreOverallVO scoreItemConf : scoreItemConfList) {
            if("LESSON".equals(StringUtil.nvl(scoreItemConf.getScoreTypeCd())) && Integer.valueOf(scoreItemConf.getScoreRatio()) == 0) {
                vo.setLessonUseYn("N");
            }
        }
        
        // 성적부여방법구분, 성적등급부여구분, 상대평가여부 조회
        baseRVo = scoreOverallDAO.selectAbsoluteBaseInfo(basePVo);

        //성적평가대상 학생 수
        vStdCntVo = new ScoreOverallVO();
        vStdCntVo.setOrgId(vo.getOrgId());
        vStdCntVo.setCrsCreCd(vo.getCrsCreCd());
        vStdCntInt = scoreOverallDAO.selectStdCnt(vStdCntVo);

        vStdCnt = new BigDecimal(vStdCntInt);

        list = scoreOverallDAO.selectMrksRankList(vo);

        for(ScoreOverallVO listVo : list) {
            //초기화
            calTotScr = new BigDecimal(listVo.getCalTotScr());
            calScrLesson   = new BigDecimal(listVo.getLessonScoreAvg());
            calScrMidTest  = new BigDecimal(listVo.getMiddleTestScoreAvg());
            calScrLastTest = new BigDecimal(listVo.getLastTestScoreAvg());
            calScrTest     = new BigDecimal(listVo.getTestScoreAvg());
            calScrAsmt     = new BigDecimal(listVo.getAssignmentScoreAvg());
            calScrForum    = new BigDecimal(listVo.getForumScoreAvg());
            calScrQuiz     = new BigDecimal(listVo.getQuizScoreAvg());
            calScrResh     = new BigDecimal(listVo.getReshScoreAvg());

            vMrksGrdGbn   = "";
            vMrks         = new BigDecimal(0);

            // 등급과 평점 구함
            if("C".equals(baseRVo.getUniCd())) {
                //학부 P/F과목 : 60점 기준
                if(trunc(listVo.getFlExchScr()) >= 60) {
                    vMrksGrdGbn = "P";
                    vMrks = new BigDecimal(0);
                } else {
                    vMrksGrdGbn = "F";
                    vMrks = new BigDecimal(0);
                }
            } else {
                //대학원 P/F과목 : 70점 기준
                if(trunc(listVo.getFlExchScr()) >= 70) {
                    vMrksGrdGbn = "P";
                    vMrks = new BigDecimal(0);
                } else {
                    vMrksGrdGbn = "F";
                    vMrks = new BigDecimal(0);
                }
            }

            exchPVo = new ScoreOverallVO();

            exchPVo.setStdId(listVo.getStdId());
            exchPVo.setCalScrMidTest( String.valueOf(calScrMidTest) );
            exchPVo.setCalScrLastTest( String.valueOf(calScrLastTest) );
            exchPVo.setCalScrAsmnt( String.valueOf(calScrAsmt) );
            exchPVo.setCalScrLesson( String.valueOf(calScrLesson) );
            exchPVo.setCalScrForum(String.valueOf(calScrForum));
            exchPVo.setCalScrTest(String.valueOf(calScrTest));
            exchPVo.setCalScrQuiz(String.valueOf(calScrQuiz));
            exchPVo.setCalScrResh(String.valueOf(calScrResh));
            exchPVo.setCalTotScr(String.valueOf(calTotScr));
            exchPVo.setExchScrMidTest( listVo.getMiddleTestScoreAvg() );
            exchPVo.setExchScrLastTest( listVo.getLastTestScoreAvg() );
            exchPVo.setExchScrAsmnt( listVo.getAssignmentScoreAvg() );
            exchPVo.setExchScrLesson( listVo.getLessonScoreAvg() );
            exchPVo.setExchScrForum( listVo.getForumScoreAvg() );
            exchPVo.setExchScrTest( listVo.getTestScoreAvg() );
            exchPVo.setExchScrQuiz( listVo.getQuizScoreAvg() );
            exchPVo.setExchScrResh( listVo.getReshScoreAvg() );
            exchPVo.setExchTotScr( listVo.getFlExchScr() );
            exchPVo.setMrks(String.valueOf(vMrks));
            exchPVo.setScoreGrade(vMrksGrdGbn);
            exchPVo.setTotScore( listVo.getFlExchScr() );
            exchPVo.setScoreStatus("3");
            exchPVo.setMdfrId(vo.getRgtrId());

            exchPList.add(exchPVo);
        }
        
        if(exchPList != null) {
            if(exchPList.size() > 0) {
                scoreOverallDAO.updateOverallExchData(exchPList);
            }
        }

        // 출결 F처리
        list = scoreOverallDAO.selectMrksNotRankList(vo);

        exchPList = new ArrayList<ScoreOverallVO>();
        for(ScoreOverallVO listVo : list) {
            //초기화
            calTotScr = new BigDecimal(listVo.getCalTotScr());
            calScrLesson   = new BigDecimal(listVo.getLessonScoreAvg());
            calScrMidTest  = new BigDecimal(listVo.getMiddleTestScoreAvg());
            calScrLastTest = new BigDecimal(listVo.getLastTestScoreAvg());
            calScrTest     = new BigDecimal(listVo.getTestScoreAvg());
            calScrAsmt     = new BigDecimal(listVo.getAssignmentScoreAvg());
            calScrForum    = new BigDecimal(listVo.getForumScoreAvg());
            calScrQuiz     = new BigDecimal(listVo.getQuizScoreAvg());
            calScrResh     = new BigDecimal(listVo.getReshScoreAvg());

            vExchTotScr   = new BigDecimal(0);
            vMrksGrdGbn   = "";
            vMrks         = new BigDecimal(0);
            vExchGapScr   = new BigDecimal(0);
            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);

            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);

            vExchScrLesson   = new BigDecimal(0);
            vExchScrMidTest  = new BigDecimal(0);
            vExchScrLastTest = new BigDecimal(0);
            vExchScrTest     = new BigDecimal(0);
            vExchScrAsmt     = new BigDecimal(0);
            vExchScrForum    = new BigDecimal(0);
            vExchScrQuiz     = new BigDecimal(0);
            vExchScrResh     = new BigDecimal(0);
            vExchTotScr      = new BigDecimal(0);
            vMrksGrdGbn      = "F";
            vMrks            = new BigDecimal(0);
            vExchGapScr      = new BigDecimal(0);

            exchPVo = new ScoreOverallVO();

            exchPVo.setStdId(listVo.getStdId());
            exchPVo.setCalScrMidTest( String.valueOf(calScrMidTest) );
            exchPVo.setCalScrLastTest( String.valueOf(calScrLastTest) );
            exchPVo.setCalScrAsmnt( String.valueOf(calScrAsmt) );
            exchPVo.setCalScrLesson( String.valueOf(calScrLesson) );
            exchPVo.setCalScrForum(String.valueOf(calScrForum));
            exchPVo.setCalScrTest(String.valueOf(calScrTest));
            exchPVo.setCalScrQuiz(String.valueOf(calScrQuiz));
            exchPVo.setCalScrResh(String.valueOf(calScrResh));
            exchPVo.setCalTotScr("0");
            exchPVo.setExchScrMidTest( String.valueOf(vExchScrMidTest) );
            exchPVo.setExchScrLastTest( String.valueOf(vExchScrLastTest) );
            exchPVo.setExchScrAsmnt( String.valueOf(vExchScrAsmt) );
            exchPVo.setExchScrLesson( String.valueOf(vExchScrLesson) );
            exchPVo.setExchScrForum(String.valueOf(vExchScrForum));
            exchPVo.setExchScrTest(String.valueOf(vExchScrTest));
            exchPVo.setExchScrQuiz(String.valueOf(vExchScrQuiz));
            exchPVo.setExchScrResh(String.valueOf(vExchScrResh));
            exchPVo.setExchTotScr(String.valueOf(vExchTotScr));
            exchPVo.setMrks(String.valueOf(vMrks));
            exchPVo.setScoreGrade(vMrksGrdGbn);
            exchPVo.setExchGapScr(String.valueOf(vExchGapScr));
            exchPVo.setTotScore(String.valueOf(vExchTotScr));
            exchPVo.setScoreStatus("3");
            exchPVo.setMdfrId(vo.getRgtrId());

            exchPList.add(exchPVo);
        }

        if(exchPList != null) {
            if(exchPList.size() > 0) {
                scoreOverallDAO.updateOverallExchData(exchPList);
            }
        }

        this.spScorMrksHistCrea(vo.getCrsCreCd(), vo.getRgtrId(), "[성적환산:PF]", vo.getRgtrId());
    }

    private int trunc(String str) {
        int result = 0;


        int valIdx = str.indexOf(".");

        if(valIdx < 0) {
            result = Integer.parseInt(str);
        } else {
            result = Integer.parseInt(str.substring(0, valIdx));

        }

        return result;
    }

    private void spScorMrksHistCrea(String crsCreCd, String userId, String chgCts, String rgtrId) throws Exception{
        StdScoreHistVO pVo = new StdScoreHistVO();

        pVo.setScoreHistSn(IdGenerator.getNewId("SCOH"));
        pVo.setCrsCreCd( crsCreCd );
        pVo.setUserId( userId );
        pVo.setChgCts( chgCts );
        pVo.setRgtrId( rgtrId );
        pVo.setMdfrId( rgtrId );
        scoreOverallDAO.insertTbLmsStdScoreHist(pVo);
    }

    @Override
    public ScoreOverallScoreCalVO selectScoreRel(ScoreOverallScoreCalVO vo) throws Exception {
        return scoreOverallDAO.selectScoreRel(vo);
    }

    @Override
    public List<ScoreOverallVO> selectOverallGraphList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectOverallGraphList(vo);
    }
    
    @Override
    public List<ScoreOverallVO> selectOverallGraphListByGrade(ScoreOverallVO vo) throws Exception {
        CreCrsVO cvo = new CreCrsVO();
        cvo.setCrsCreCd(vo.getCrsCreCd());
        cvo = crecrsDAO.selectCreCrs(cvo);
        vo.setUniCd(cvo.getUniCd());
        return scoreOverallDAO.selectOverallGraphListByGrade(vo);
    }

    @Override
    public ScoreOverallVO selectOverallGridCase(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO obj = scoreOverallDAO.selectOverallGridCase1(vo);
        String avg10Score = scoreOverallDAO.selectOverallGridCase2(vo);

        if(obj == null) {
            obj = new ScoreOverallVO();
            obj.setAvgScore("0");
            obj.setMaxScore("0");
            obj.setMinScore("0");
            obj.setTotStdCnt("0");
            obj.setAvg10Score("0");
        } else {
            obj.setAvg10Score(avg10Score);
        }

        return obj;
    }

    @Override
    public void updateOverallScoreOpenYn(ScoreOverallVO vo) throws Exception {
        scoreOverallDAO.updateOverallScoreOpenYn(vo);
    }

    @Override
    public String selectOverallScoreOpenYn(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectOverallScoreOpenYn(vo);
    }

    @Override
    public List<ScoreOverallVO> chartScoreList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.chartScoreList(vo);
    }

    @Override
    public List<ScoreOverallVO> avgScoreList(ScoreOverallVO vo) throws Exception {

        List<ScoreOverallVO> avgScoreItemList = scoreOverallDAO.listScoreItemConfNoZero(vo);

        for (int i = 0; i < avgScoreItemList.size(); i++)
        {
            avgScoreItemList.get(i).setUserId(vo.getUserId());
            avgScoreItemList.get(i).setAvgScore(scoreOverallDAO.avgScorebyItem(avgScoreItemList.get(i)).getAvgScore());
            avgScoreItemList.get(i).setGetScore(scoreOverallDAO.avgScorebyItem(avgScoreItemList.get(i)).getGetScore());
        }
        return avgScoreItemList;
    }

    @Override
    public ScoreOverallVO selectStdScore(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO pVo = new ScoreOverallVO();
        ScoreOverallVO result = new ScoreOverallVO();

        pVo.setCrsCreCd(vo.getCrsCreCd());
        result.setAvgScore(scoreOverallDAO.selectStdScore(pVo));
        pVo.setUserId(vo.getUserId());
        result.setGetScore(scoreOverallDAO.selectStdScore(vo));

        return result;
    }

    @Override
    public ScoreOverallVO selectExamAbsentCnt(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO resultVo = new ScoreOverallVO();
        String[] apprstats = null;
        ScoreOverallVO pVo = new ScoreOverallVO();
        pVo.setCrsCreCd(vo.getCrsCreCd());

        //중간결시원제출
        int m1 = 0;
        apprstats = new String[]{"APPLICATE", "RAPPLICATE"};
        pVo.setApprStats(apprstats);
        pVo.setExamStareTypeCd("M");
        m1 = scoreOverallDAO.selectExamAbsentCnt(pVo);
        //중간결시원승인
        int m2 = 0;
        apprstats = new String[]{"APPROVE"};
        pVo.setApprStats(apprstats);
        pVo.setExamStareTypeCd("M");
        m2 = scoreOverallDAO.selectExamAbsentCnt(pVo);
        //기말결시원제출
        int l1 = 0;
        apprstats = new String[]{"APPLICATE", "RAPPLICATE"};
        pVo.setApprStats(apprstats);
        pVo.setExamStareTypeCd("L");
        l1 = scoreOverallDAO.selectExamAbsentCnt(pVo);
        //기말결시원승인
        int l2 = 0;
        apprstats = new String[]{"APPROVE"};
        pVo.setApprStats(apprstats);
        pVo.setExamStareTypeCd("L");
        l2 = scoreOverallDAO.selectExamAbsentCnt(pVo);

        //미평가
        int zeroCnt = 0;
        zeroCnt = scoreOverallDAO.selectScoreZeroCnt(pVo);
        
        // 대체시험 대상자
        int reExamCnt = scoreOverallDAO.selectReExamStdCnt(pVo);
        
        // F대상자
        pVo = new ScoreOverallVO();
        pVo.setCrsCreCd(vo.getCrsCreCd());
        pVo.setSearchType("btnF");
        int fCnt = scoreOverallDAO.selectOverallList(pVo).size();
        
        ScoreOverallVO btnStatusVO = scoreOverallDAO.selectBtnStatus(pVo);

        if(btnStatusVO != null) {
            resultVo.setScoreStatus(btnStatusVO.getScoreStatus());
            resultVo.setInitDttm(btnStatusVO.getInitDttm());
            resultVo.setCalDttm(btnStatusVO.getCalDttm());
        }
        
        resultVo.setM1(String.valueOf(m1));
        resultVo.setM2(String.valueOf(m2));
        resultVo.setL1(String.valueOf(l1));
        resultVo.setL2(String.valueOf(l2));
        resultVo.setZeroCnt(String.valueOf(zeroCnt));
        resultVo.setReExamCnt(String.valueOf(reExamCnt));
        resultVo.setfCnt(String.valueOf(fCnt));

        return resultVo;
    }

    @Override
    public String[] selectSysJobSchStr(ScoreOverallVO vo) throws Exception {
        String[] returnStr = null;

        CreCrsVO crsCrePVo = new CreCrsVO();
        crsCrePVo.setCrsCreCd(vo.getCrsCreCd());

        CreCrsVO crsCreVo = crecrsDAO.select(crsCrePVo);

        vo.setHaksaYear(crsCreVo.getCreYear());
        vo.setHaksaTeam(crsCreVo.getCreTerm());
        vo.setCalendarCtgr("00210206"); //성적입력기간 (00210210   성적조회기간)
        int ctgr1 = scoreOverallDAO.selectSysJobSchCnt(vo);


        vo.setCalendarCtgr("00210202"); //성적재확인신청기간  (00210203    성적재확인신청정정기간)
        int ctgr2 = scoreOverallDAO.selectSysJobSchCnt(vo);

        returnStr = new String[] {String.valueOf(ctgr1), String.valueOf(ctgr2)};

        return returnStr;
    }

    @Override
    public ProcessResultVO<ScoreOverallVO> selectOverallBaseInfo(ScoreOverallVO vo) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<ScoreOverallVO>();
        ScoreOverallVO resultTch = null;
        ScoreOverallVO resultStd = null;

        try {
            resultTch = scoreOverallDAO.selectOverallBaseTchInfo(vo);
            resultStd = scoreOverallDAO.selectOverallBaseStdInfo(vo);

            resultVO.setReturnVO(resultTch);
            resultVO.setReturnSubVO(resultStd);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
            throw e;
        }
        return resultVO;
    }

    @Override
    public void insertStdScoreObjt(ScoreOverallVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        
        vo.setScoreObjtCd( IdGenerator.getNewId("SCORE_OBJT") );
        
        // 과목정보 조회
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);
        
        String uniCd = creCrsVO.getUniCd();
        
        // 성적재확인신청기간 조회
        String calendarCtgr = "";
        if(vo.getAuthrtGrpcd().contains("PROF")) {
            calendarCtgr = "00210203";
        } else {
            calendarCtgr = "00210202";
        }
        
        if("G".equals(uniCd)) {
            if(vo.getAuthrtGrpcd().contains("PROF")) {
                calendarCtgr = "00210205"; // 대학원
            } else {
                calendarCtgr = "00210204"; // 대학원
            }
        }

        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setOrgId(orgId);
        sysJobSchVO.setCalendarCtgr(calendarCtgr);
        sysJobSchVO.setHaksaYear(creCrsVO.getCreYear());
        sysJobSchVO.setHaksaTerm(creCrsVO.getCreTerm());
        sysJobSchVO = sysJobSchDAO.select(sysJobSchVO);
        
        // 성적재확인 신청기간 체크
        if(!"Y".equals(sysJobSchVO.getSysjobSchdlPeriodYn())) {
            throw processException("score.alert.no.objt.period"); // 성적재확인신청 기간이 아닙니다.
        }
        
        ScoreOverallVO sovo = new ScoreOverallVO();
        sovo.setStdId(vo.getStdId());
        sovo.setCrsCreCd(vo.getCrsCreCd());
        sovo = scoreOverallDAO.selectObjtProcCfmInfo(sovo);
        if(sovo != null) {
            // 이미 성적재확인 신청하였습니다.
            throw processException("score.alert.exist.objt.applicate");
        }
        
        try {
            scoreOverallDAO.insertStdScoreObjt(vo);
        } catch (DuplicateKeyException e) {
            // 이미 성적재확인 신청하였습니다.
            throw processException("score.alert.exist.objt.applicate");
        } catch (Exception e) {
            throw e;
        }

        if("USR".equals(StringUtil.nvl(vo.getAuthrtGrpcd()))) {
            FileVO fVo = new FileVO();
            fVo.setOrgId(vo.getOrgId());
            fVo.setUserId(vo.getUserId());
            fVo.setRepoCd("SCORE_OBJT");
            fVo.setFilePath(vo.getUploadPath());

            fVo.setFileBindDataSn(vo.getScoreObjtCd());
            fVo.setUploadFiles(vo.getUploadFiles());
            fVo.setCopyFiles(vo.getCopyFiles());
            fVo.setDelFileIds(vo.getDelFileIds());

            fVo.setOrginDelYn("Y");
            sysFileService.insertFileInfo(fVo);
        }
    }

    @Override
    public List<ScoreOverallVO> selectScoreObjtList(ScoreOverallVO vo) throws Exception {
        if(vo.getAuthrtGrpcd().contains("USR")) {
            vo.setSearchType("USR");
        } else {
            vo.setSearchType("PROF");
        }
        return scoreOverallDAO.selectScoreObjtList(vo);
    }
    
    @Override
    public List<ScoreOverallVO> selectScoreObjtTchList(ScoreOverallVO vo) throws Exception {
        List<ScoreOverallVO> list = null;
        String creYear = vo.getCreYear();
        String creTerm = vo.getCreTerm();
        
        if(!"".equals(StringUtil.nvl(creYear)) && !"".equals(StringUtil.nvl(creTerm))) {
            String orgId = vo.getOrgId();
            String userId = vo.getUserId();

            TermVO termVO = new TermVO();
            termVO.setOrgId(orgId);
            termVO.setHaksaYear(creYear);
            termVO.setHaksaTerm(creTerm);
            termVO = termDAO.selectTermByHaksa(termVO);
            
            List<CreCrsVO> crsCreList = null;
            
            if(termVO != null) {
                String termCd = termVO.getTermCd();
                CreCrsVO creCrsVO = new CreCrsVO();
                creCrsVO.setUserId(userId);
                creCrsVO.setTermCd(termCd);
                crsCreList = crecrsDAO.listMainMypageTch(creCrsVO);
            }
            
            if(crsCreList != null && crsCreList.size() > 0) {
                List<String> crsCreCdList = new ArrayList<>();
                
                for(CreCrsVO creCrsVO : crsCreList) {
                    crsCreCdList.add(creCrsVO.getCrsCreCd());
                }
                
                vo.setSqlForeach(crsCreCdList.toArray(new String[crsCreCdList.size()]));
                
                list = scoreOverallDAO.selectScoreObjtList(vo);
            }
        } else {
            list = scoreOverallDAO.selectScoreObjtList(vo);
        }
        
        return list;
    }

    @Override
    public ScoreOverallVO selectScoreObjtCtnt(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreObjtCtnt(vo);
    }

    @Override
    public ScoreOverallVO selectScoreObjtReg(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreObjtRegInfo(vo);
    }

    @Override
    public List<ScoreOverallVO> selectScoreObjtRegList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreObjtRegList(vo);
    }

    @Override
    public List<ScoreOverallVO> selectScoreObjtProcList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreObjtProcList(vo);
    }

    @Override
    public void updateScoreObjtProc(ScoreOverallVO vo) throws Exception {
        String creCrsEval = scoreOverallDAO.selectCreCrsEval(vo);
        ScoreOverallVO prvInfo = scoreOverallDAO.selectStdScorePrvInfo(vo); // 초기점수
        
        float prvScore = Float.parseFloat(prvInfo.getPrvScore()); // 변경 전 점수
        Float addedScore = prvScore + Float.parseFloat(vo.getAddScore());
        
        if(addedScore > 100) {
            throw processException("score.alert.over100"); // 가산점 적용 후 총점이 100보다 큽니다. 가산점을 변경하세요.
        }
        
        if(addedScore < 0) {
            throw processException("score.alert.under100"); // 가산점 적용 후 총점이 0보다 작습니다. 가산점을 변경하세요.
        }
        
        String modGrade = null;
        vo.setPrvScore( String.valueOf(prvScore) );

        if("RELATIVE".equals(creCrsEval)) {
            if("1".equals(vo.getProcCd())) {
                ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
                String uniCd = baseInfoVO.getUniCd();
                
                if(addedScore < 60) {
                    modGrade = "F";
                } else if(addedScore < 65) {
                    modGrade = "D";
                } else if(addedScore < 70) {
                    modGrade = "D+";
                } else if(addedScore < 75) {
                    modGrade = "C";
                } else if(addedScore < 80) {
                    modGrade = "C+";
                } else if(addedScore < 85) {
                    modGrade = "B";
                } else if(addedScore < 90) {
                    modGrade = "B+";
                } else if(addedScore < 95) {
                    modGrade = "A";
                } else if(addedScore <= 100) {
                    modGrade = "A+";
                }
                
                // 대학원 70점미만 F
                if("G".equals(uniCd) && addedScore < 70) {
                    modGrade = "F";
                }
            }
        } else if("ABSOLUTE".equals(creCrsEval)) {
            if("1".equals(vo.getProcCd())) {
                ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
                String uniCd = baseInfoVO.getUniCd();
                
                ScoreOverallVO abScoreVo = scoreOverallDAO.selectAbsoluteCalc(String.valueOf(addedScore));
                modGrade = abScoreVo.getMrksGrdGbn();
                
                // 대학원 70점미만 F
                if("G".equals(uniCd) && addedScore < 70) {
                    modGrade = "F";
                }
            }
        } else if("PF".equals(creCrsEval)) {
            Float pfScore = prvScore;
            if("1".equals(vo.getProcCd())) {
                pfScore = addedScore;
                
                ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
                String uniCd = baseInfoVO.getUniCd();
                
                // 등급과 평점 구함
                if("C".equals(uniCd)) {
                    //학부 P/F과목 : 60점 기준
                    if(pfScore >= 60) {
                        modGrade = "P";
                    } else {
                        modGrade = "F";
                    }
                } else {
                    //대학원 P/F과목 : 70점 기준
                    if(pfScore >= 70) {
                        modGrade = "P";
                    } else {
                        modGrade = "F";
                    }
                }
            }
        }

        ScoreOverallVO updVo = new ScoreOverallVO();
        updVo.setCrsCreCd( vo.getCrsCreCd() );
        updVo.setStdId( vo.getStdId() );
        updVo.setObjtUserId( vo.getObjtUserId() );
        updVo.setProcUserId( vo.getMdfrId() );
        updVo.setProcCtnt( vo.getProcCtnt() );
        if("1".equals(vo.getProcCd())) { 
            updVo.setModScore(String.valueOf(addedScore));
            updVo.setModGrade(modGrade);
        } else {
            updVo.setModScore(prvInfo.getPrvScore());
            updVo.setModGrade(prvInfo.getPrvGrade());
        }
        updVo.setPrvScore(prvInfo.getPrvScore());
        updVo.setPrvGrade(prvInfo.getPrvGrade());
        updVo.setProcCd( vo.getProcCd() );
        updVo.setAddScore(vo.getAddScore());
        updVo.setMdfrId(vo.getMdfrId());
        scoreOverallDAO.updateScoreObjtProc(updVo);
        
        updVo = new ScoreOverallVO();
        if("1".equals(vo.getProcCd())) { 
            updVo.setTotScore(String.valueOf(addedScore));
            updVo.setAddScore(vo.getAddScore());
            updVo.setScoreGrade(modGrade);
        } else {
            updVo.setTotScore(prvInfo.getPrvScore());
            updVo.setScoreGrade(prvInfo.getPrvGrade());
            updVo.setAddScore("0");
        }
        updVo.setStdId(vo.getStdId());
        updVo.setMdfrId(vo.getMdfrId());
        scoreOverallDAO.updateScoreObjtCfm(updVo);
    }

    @Override
    public ScoreOverallVO selectStdMemo(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectStdMemo(vo);
    }

    @Override
    public void updateStdMemo(ScoreOverallVO vo) throws Exception {
        scoreOverallDAO.updateStdMemo(vo);
    }

    @Override
    public ScoreOverallVO selectCurDateFmt() throws Exception {
        return scoreOverallDAO.selectCurDateFmt();
    }

    @Override
    public ScoreOverallVO selectLessonInfo(ScoreOverallVO vo) throws Exception {
        int lessonTotCnt = scoreOverallDAO.selectLessonTotCnt(vo);
        int absentCnt = scoreOverallDAO.selectLessonAbsentTotCnt(vo);
        int lateCnt = scoreOverallDAO.selectLessonLateTotCnt(vo);

        ScoreOverallVO resultVO = new ScoreOverallVO();

        resultVO.setLessonTotCnt(lessonTotCnt);
        resultVO.setAbsentCnt(absentCnt);
        resultVO.setLateCnt(lateCnt);
        resultVO.setLessonScore(scoreOverallDAO.selectLmsLessonScore(vo));


        return resultVO;
    }

    @Override
    public List<ScoreOverallVO> selectTestsDtlList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectTestsDtlList(vo);
    }

    @Override
    public List<ScoreOverallVO> selectQuizDtlList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectQuizDtlList(vo);
    }

    @Override
    public List<ScoreOverallVO> selectTestDtlList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectTestDtlList(vo);
    }

    @Override
    public List<ScoreOverallVO> selectAsmntDtlList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectAsmntDtlList(vo);
    }

    @Override
    public List<ScoreOverallVO> selectForumDtlList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectForumDtlList(vo);
    }

    @Override
    public ProcessResultVO<ScoreOverallVO> selectObjtProcCfmInfo(ScoreOverallVO vo) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<ScoreOverallVO>();
        ScoreOverallVO result = null;
        FileVO fileVO = null;

        try {

            result = scoreOverallDAO.selectObjtProcCfmInfo(vo);

            if(result != null) {
                fileVO = new FileVO();
                fileVO.setRepoCd("SCORE_OBJT");
                fileVO.setFileBindDataSn(result.getScoreObjtCd());
                result.setFileList(sysFileService.list(fileVO).getReturnList());
            }

            resultVO.setReturnVO(result);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public void updateTotScoreByStdNo(ScoreOverallVO vo) throws Exception {
        ScoreOverallVO abScoreVo = null;
        ScoreOverallVO updVo = null;

        String prvScore = "";
        String prvGrade = "";
        String modScore = "";
        String modGrade = "";

        String creCrsEval = scoreOverallDAO.selectCreCrsEval(vo);
        ScoreOverallVO prvInfo = scoreOverallDAO.selectStdScorePrvInfo(vo);

        prvScore = prvInfo.getPrvScore();
        prvGrade = prvInfo.getPrvGrade();

        modScore = vo.getModScore();
        vo.setPrvScore( modScore );

        if("RELATIVE".equals(creCrsEval)) {
            ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
            String uniCd = baseInfoVO.getUniCd();
            
            if(trunc(modScore) < 60) {
                modGrade = "F";
            } else if(trunc(modScore) < 65) {
                modGrade = "D";
            } else if(trunc(modScore) < 70) {
                modGrade = "D+";
            } else if(trunc(modScore) < 75) {
                modGrade = "C";
            } else if(trunc(modScore) < 80) {
                modGrade = "C+";
            } else if(trunc(modScore) < 85) {
                modGrade = "B";
            } else if(trunc(modScore) < 90) {
                modGrade = "B+";
            } else if(trunc(modScore) < 95) {
                modGrade = "A";
            } else if(trunc(modScore) <= 100) {
                modGrade = "A+";
            }
            
            // 대학원 70점미만 F
            if("G".equals(uniCd) && trunc(modScore) < 70) {
                modGrade = "F";
            }
        } else if("ABSOLUTE".equals(creCrsEval)) {
            ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
            String uniCd = baseInfoVO.getUniCd();
            
            abScoreVo = scoreOverallDAO.selectAbsoluteCalc(modScore);
            modGrade = abScoreVo.getMrksGrdGbn();
            
            // 대학원 70점미만 F
            if("G".equals(uniCd) && trunc(modScore) < 70) {
                modGrade = "F";
            }
        } else if("PF".equals(creCrsEval)) {
            ScoreOverallVO baseInfoVO = scoreOverallDAO.selectAbsoluteBaseInfo(vo);
            String uniCd = baseInfoVO.getUniCd();
            
            // 등급과 평점 구함
            if("C".equals(uniCd)) {
                //학부 P/F과목 : 60점 기준
                if(trunc(modScore) >= 60) {
                    modGrade = "P";
                } else {
                    modGrade = "F";
                }
            } else {
                //대학원 P/F과목 : 70점 기준
                if(trunc(modScore) >= 70) {
                    modGrade = "P";
                } else {
                    modGrade = "F";
                }
            }
        }

        updVo = new ScoreOverallVO();
        updVo.setStdId( vo.getStdId() );
        updVo.setTotScore( modScore );
        updVo.setScoreGrade( modGrade );
        updVo.setMdfrId( vo.getMdfrId() );

        scoreOverallDAO.updateStdScoreGrade(updVo);

        this.spScorMrksHistCrea(vo.getCrsCreCd(), vo.getMdfrId(), "[성적환산총점:변경]\r\n" + vo.getStdId() + " : " + prvScore + "점 " + prvGrade  + " 에서 \r\n" + modScore + "점 " + modGrade  + " 으로 변경", vo.getMdfrId());
    }

    @Override
    public void updateOverallScoreInit(ScoreOverallScoreCalVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        
        ScoreOverallVO checkRatioVO = new ScoreOverallVO();
        checkRatioVO.setCrsCreCd(crsCreCd);
        
        int invalidCntQuiz = scoreOverallDAO.selectInvalidRatioCntQuiz(checkRatioVO);
        
        if(invalidCntQuiz > 0) {
            throw processException("score.alert.invalid.ratio.quiz"); // 퀴즈의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다. 
        }
        
        
        int invalidCntForum = scoreOverallDAO.selectInvalidRatioCntForum(checkRatioVO);
        
        if(invalidCntForum > 0) {
            throw processException("score.alert.invalid.ratio.forum"); // 토론의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다. 
        }
        
        int invalidCntAsmnt = scoreOverallDAO.selectInvalidRatioCntAsmnt(checkRatioVO);
        
        if(invalidCntAsmnt > 0) {
            throw processException("score.alert.invalid.ratio.asmnt"); // 과제의 성적반영비율의 합을 100으로 설정한 후 성적처리 가능합니다.
        }
        
        // 성적항목 조회
        ScoreOverallVO scoreOverallVO = new ScoreOverallVO();
        scoreOverallVO.setCrsCreCd(crsCreCd);
        List<ScoreOverallVO> scoreItemConfList = scoreOverallDAO.selectScoreItemConfList(scoreOverallVO);
       
        if(scoreItemConfList == null || scoreItemConfList.size() == 0) {
            throw processException("score.label.process.msg19"); // 해당과목의 평가기준을 먼저 입력해주세요.
        }
        
        List<ScoreOverallVO> list = null;

        List<ScoreOverallVO> scoreItemList = new ArrayList<ScoreOverallVO>();

        ScoreOverallVO pVo = null;

        ScoreOverallVO pVo2 = null;

        ScoreOverallVO pVo3 = null;

        String lessonScore = "";
        String midTestScore = "";
        String lastTestScore = "";
        String asmntTestScore = "";
        String forumScore = "";
        String quizScore = "";
        String reshScore = "";
        String testScore = "";

        //초기화
        scoreOverallDAO.deleteOverallScoreInit(vo.getCrsCreCd());
        scoreOverallDAO.deleteOverallScoreItemInit(vo.getCrsCreCd());

        list = scoreOverallDAO.selectMrksList(vo);

        for(ScoreOverallVO listVo : list) {
            pVo = new ScoreOverallVO();
            scoreItemList = new ArrayList<ScoreOverallVO>();

            pVo.setCrsCreCd(vo.getCrsCreCd());
            pVo.setStdId(listVo.getStdId());

            // 1. 강의&출석
            lessonScore = scoreOverallDAO.selectLmsLessonScore(pVo);
            // 2. 중간고사
            pVo.setExamStareTypeCd("M");
            midTestScore = scoreOverallDAO.selectLmsTestsScore(pVo);
            // 3. 기말고사
            pVo.setExamStareTypeCd("L");
            lastTestScore = scoreOverallDAO.selectLmsTestsScore(pVo);
            // 4. 수시평가
            testScore = scoreOverallDAO.selectLmsTestScore(pVo);
            // 5. 과제
            asmntTestScore = scoreOverallDAO.selectLmsAsmntScore(pVo);
            // 6. 토론
            forumScore = scoreOverallDAO.selectLmsForumScore(pVo);
            // 7. 퀴즈
            quizScore = scoreOverallDAO.selectLmsQuizScore(pVo);
            // 8. 설문
            reshScore = scoreOverallDAO.selectLmsReshScore(pVo);

            pVo2 = new ScoreOverallVO();
            pVo2.setStdId(listVo.getStdId());
            pVo2.setCrsCreCd(vo.getCrsCreCd());
            pVo2.setLessonScore(lessonScore == null ? "0" : lessonScore );
            pVo2.setMidTestScore(midTestScore == null ? "-1" : midTestScore );
            pVo2.setLastTestScore(lastTestScore == null ? "-1" : lastTestScore );
            pVo2.setTestScore(testScore == null ? "-1" : testScore );
            pVo2.setAsmntTestScore(asmntTestScore == null ? "-1" : asmntTestScore );
            pVo2.setForumScore(forumScore == null ? "-1" : forumScore );
            pVo2.setQuizScore(quizScore == null ? "-1" : quizScore );
            pVo2.setReshScore(reshScore == null ? "-1" : reshScore );
            pVo2.setRgtrId(vo.getRgtrId());
            pVo2.setMdfrId(vo.getMdfrId());

            scoreItemList = this.scoreItemSettingCvt(pVo2);

            scoreOverallDAO.insertOverallScoreItem(scoreItemList);

            pVo3 = new ScoreOverallVO();
            pVo3.setStdId(listVo.getStdId());
            pVo3.setTotScore("0");
            pVo3.setFinalScore("0");
            pVo3.setAddScore("0");
            pVo3.setScoreStatus("2");
            pVo3.setExchScrMidTest("0");
            pVo3.setExchScrLastTest("0");
            pVo3.setExchScrAsmnt("0");
            pVo3.setExchScrLesson("0");
            pVo3.setExchScrForum("0");
            pVo3.setExchScrTest("0");
            pVo3.setExchScrQuiz("0");
            pVo3.setExchScrResh("0");
            pVo3.setExchTotScr("0");
            pVo3.setMrks("0");
            pVo3.setExchGapScr("0");
            pVo3.setRgtrId(vo.getRgtrId());
            pVo3.setMdfrId(vo.getMdfrId());

            scoreOverallDAO.insertOverallScore(pVo3);
        }

        this.spScorMrksHistCrea(vo.getCrsCreCd(), vo.getMdfrId(), "[성적환산:평가점수 가져오기" + vo.getRgtrId(), vo.getMdfrId());
    }

    private List<ScoreOverallVO> scoreItemSettingCvt(ScoreOverallVO pVo2) throws Exception{
        List<ScoreOverallVO> resultList = new ArrayList<ScoreOverallVO>();

        //강의, 중간, 기말, 상시, 과제, 토론, 퀴즈, 설문
        String[] scoreType = {"1", "2", "3", "4", "5", "6", "7", "8"};

        ScoreOverallVO pVo = null;
        for(int i=0; i < scoreType.length; i++) {
            pVo = new ScoreOverallVO();

            pVo.setStdId(pVo2.getStdId());
            pVo.setScoreItemId( "SCIT_" + pVo2.getCrsCreCd().replace("CE_", "") + "0" + scoreType[i]);

            if("1".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getLessonScore());
            } else if("2".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getMidTestScore());
            } else if("3".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getLastTestScore());
            } else if("4".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getTestScore());
            } else if("5".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getAsmntTestScore());
            } else if("6".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getForumScore());
            } else if("7".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getQuizScore());
            } else if("8".equals(scoreType[i])) {
                pVo.setGetScore(pVo2.getReshScore());
            }
            pVo.setRgtrId(pVo2.getRgtrId());
            pVo.setMdfrId(pVo2.getMdfrId());
            resultList.add(pVo);
        }


        return resultList;
    }

    public ScoreOverallVO selectScoreOverallStd(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreOverallStd(vo);
    }

    @Override
    public ProcessResultVO<ScoreOverallVO> selectOverallModStdInfo(ScoreOverallVO vo) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<ScoreOverallVO>();
        ScoreOverallVO resultTch = null;
        ScoreOverallVO resultStd = null;

        resultTch = scoreOverallDAO.selectOverallBaseTchInfo(vo);
        resultStd = scoreOverallDAO.selectOverallModStdInfo(vo);

        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("SCORE_OBJT");
        fileVO.setFileBindDataSn(resultStd.getScoreObjtCd());
        resultStd.setFileList(sysFileService.list(fileVO).getReturnList());

        resultVO.setReturnVO(resultTch);
        resultVO.setReturnSubVO(resultStd);
        
        return resultVO;
    }

    @Override
    public void updateStdScoreObjt(ScoreOverallVO vo) throws Exception {
        scoreOverallDAO.updateStdScoreObjt(vo);

        if(vo.getDelFileIds().length > 0) {
            for(String delFileId : vo.getDelFileIds()) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("SCORE_OBJT");
                fileVO.setFileBindDataSn(vo.getScoreObjtCd());
                List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
                for(FileVO fvo : fileList) {
                    if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }
                }
            }
        }
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd("SCORE_OBJT");
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getScoreObjtCd());
            sysFileService.addFile(fileVO);
        }
    }

    @Override
    public List<ScoreOverallVO> selectScoreObjtListAdmin(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreObjtListAdmin(vo);
    }

    @Override
    public List<ScoreOverallVO> selectStdScoreObjtList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectStdScoreObjtList(vo);
    }
    
    @Override
    public ScoreOverallVO selectBtnStatus(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectBtnStatus(vo);
    }

    @Override
    public ProcessResultVO<ScoreOverallVO> selectOverallStdInfoAdmin(ScoreOverallVO vo) throws Exception {
        ProcessResultVO<ScoreOverallVO> resultVO = new ProcessResultVO<ScoreOverallVO>();
        List<ScoreOverallVO> resultList = scoreOverallDAO.selectOverallStdInfoAdmin(vo);

        UsrUserInfoVO uVo = new UsrUserInfoVO();
        String phtFile = "";

        uVo.setUserId(vo.getUserId());
        UsrUserInfoVO uuivo  = usrUserInfoDAO.select(uVo);

        // 사진파일이 있으면 변환
        if (uuivo.getPhtFileByte() != null && uuivo.getPhtFileByte().length > 0) {
            phtFile = "data:image/png;base64," + new String(Base64.getEncoder().encode(uuivo.getPhtFileByte()));
            uuivo.setPhotoFileId(phtFile);
        }

        resultVO.setReturnList(resultList);
        resultVO.setReturnVO(uuivo);
       
        return resultVO;
    }

    @Override
    public List<ScoreOverallVO> selectScoreItemConfList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreItemConfList(vo);
    }
    
    @Override
    public List<ScoreOverallVO> selectScoreHistList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreHistList(vo);
    }
    
    @Override
    public List<ErpScoreTestVO> selectErpTestScoreList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectErpTestScoreList(vo);
    }
    
    @Override
    public EgovMap selectScoreExistsYnByUniCd(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectScoreExistsYnByUniCd(vo);
    }

    @Override
    public void updateScoreItemChangeLog(String crsCreCd, String userId, String stdNo, int scoreItemOrder, String modScore, String mdfrId) throws Exception {
        
        try {
            ScoreOverallVO scoreOverallVO = new ScoreOverallVO();
            scoreOverallVO.setCrsCreCd(crsCreCd);
            scoreOverallVO.setStdId(stdNo);
            scoreOverallVO.setScoreItemOrder(scoreItemOrder);
            scoreOverallVO.setModScore("-".equals(modScore) ? "-1" : modScore);
            String prvScore = scoreOverallDAO.selectOriginScoreItem(scoreOverallVO);
            
            if(prvScore != null) {
                modScore = "-1".equals(modScore) ? "-" : modScore;
                //중간, 기말, 상시, 과제, 토론, 퀴즈, 설문
                if(scoreItemOrder == 2) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:중간고사]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                } else if(scoreItemOrder == 3) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:기말고사]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                } else if(scoreItemOrder == 4) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:수시]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                } else if(scoreItemOrder == 5) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:과제]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                } else if(scoreItemOrder == 6) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:토론]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                } else if(scoreItemOrder == 7) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:퀴즈]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                } else if(scoreItemOrder == 8) {
                    this.spScorMrksHistCrea(crsCreCd, userId, "[산출점수변경:설문]\r\n" + " : " + prvScore + "점 에서 \r\n" + modScore + "점  으로 변경", mdfrId);
                }
            }
        } catch (Exception e) {
            
        }
    }
    
    @Override
    public List<ScoreOverallVO> selectOverallMainList(ScoreOverallVO vo) throws Exception {
        return scoreOverallDAO.selectOverallMainList(vo);
    }

    @Override
    public void updateScoreItemConfList(HttpServletRequest request, List<ScoreOverallVO> list) throws Exception {
        if(SessionInfo.isKnou(request) || list == null || list.size() == 0) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }
        
        String userId = SessionInfo.getUserId(request);
        Set<String> crsCreCdSet = new HashSet<>();
        Set<String> scoreTypeCdSet = new HashSet<>();
        int totalRate = 0;
        
        for(ScoreOverallVO vo : list) {
            if(ValidationUtils.isEmpty(vo.getCrsCreCd()) || ValidationUtils.isEmpty(vo.getScoreTypeCd()) || ValidationUtils.isEmpty(vo.getScoreRatio())) {
                throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
            }
            
            vo.setMdfrId(userId);
            
            totalRate += Integer.valueOf(vo.getScoreRatio());
            
            crsCreCdSet.add(vo.getCrsCreCd());
            scoreTypeCdSet.add(vo.getScoreTypeCd());
        }
        
        if(crsCreCdSet.size() != 1) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }
        
        if(totalRate != 100) {
            throw processException("score.alert.incorrect.rate.sum"); // 비율의 합계를 100으로 설정하세요.
        }
        
        scoreOverallDAO.updateScoreItemConfList(list);
    }
}