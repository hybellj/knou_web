package knou.lms.resh.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.vo.ExamStareVO;
import knou.lms.resh.dao.ReshAnsrDAO;
import knou.lms.resh.dao.ReshDAO;
import knou.lms.resh.dao.ReshQstnDAO;
import knou.lms.resh.service.ReshAnsrService;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshScaleVO;
import knou.lms.resh.vo.ReshVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;

@Service("reshAnsrService")
public class ReshAnsrServiceImpl extends ServiceBase implements ReshAnsrService {

    @Resource(name="reshAnsrDAO")
    private ReshAnsrDAO reshAnsrDAO;
    
    @Resource(name="reshQstnDAO")
    private ReshQstnDAO reshQstnDAO;
    
    @Resource(name="reshDAO")
    private ReshDAO reshDAO;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;

    /*****************************************************
     * <p>
     * TODO 설문 참여 장치별 현황 조회
     * </p>
     * 설문 참여 장치별 현황 조회
     * 
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshJoinDeviceStatus(ReshVO vo) throws Exception {

        return reshAnsrDAO.listReshJoinDeviceStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항별 선택지 응답현황
     * </p>
     * 설문 문항별 선택지 응답현황
     * 
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshQstnItemAnswerStatus(ReshQstnVO vo) throws Exception {

        return reshAnsrDAO.listReshQstnItemAnswerStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항별 서술형 응답 리스트 조회
     * </p>
     * 설문 문항별 서술형 응답 리스트 조회
     * 
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshTextQstnAnswer(ReshQstnVO vo) throws Exception {

        return reshAnsrDAO.listReshTextQstnAnswer(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항별 척도형 응답현황
     * </p>
     * 설문 문항별 척도형 응답현황
     * 
     * @param ReshQstnVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshQstnScaleAnswerStatus(ReshQstnVO vo) throws Exception {

        return reshAnsrDAO.listReshQstnScaleAnswerStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지별 항목 응답 목록 조회
     * </p>
     * 설문 페이지별 항목 응답 목록 조회
     * 
     * @param ReshPageVO
     * @return List<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshPageVO> listReshAnswerStatus(ReshPageVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        
        // 설문 페이지 리스트 조회
        List<ReshPageVO> listReshPage = reshQstnDAO.listReshPage(vo);
        if (listReshPage == null || listReshPage.isEmpty() || listReshPage.size() == 0 ) {
            return listReshPage;
        }
        
        // 설문 페이지별 항목 리스트 조회
        for(ReshPageVO pageVo : listReshPage) {
            List<ReshQstnVO> listReshQstn = reshQstnDAO.listReshQstn(pageVo);
            if(listReshQstn != null && !listReshQstn.isEmpty() && listReshQstn.size() > 0) {
                for(ReshQstnVO qstnVo : listReshQstn) {
                    qstnVo.setCrsCreCd(crsCreCd);
                    // 항목별 응답현황 리스트 조회
                    if ("SINGLE".equals(qstnVo.getReschQstnTypeCd()) || "MULTI".equals(qstnVo.getReschQstnTypeCd()) || "OX".equals(qstnVo.getReschQstnTypeCd())) {
                        List<EgovMap> statusList = reshAnsrDAO.listReshQstnItemAnswerStatus(qstnVo);
                        qstnVo.setReschAnswerList(statusList);
                    } else if ("SCALE".equals(qstnVo.getReschQstnTypeCd()) ) {
                        List<EgovMap> statusList = reshAnsrDAO.listReshQstnScaleAnswerStatus(qstnVo);
                        qstnVo.setReschAnswerList(statusList);
                    } else if ("TEXT".equals(qstnVo.getReschQstnTypeCd()) ) {
                        List<EgovMap> statusList = reshAnsrDAO.listReshTextQstnAnswer(qstnVo);
                        qstnVo.setReschAnswerList(statusList);
                    }
                    
                    // 항목 척도등급 리스트 조회
                    List<ReshScaleVO> listReshScale = reshQstnDAO.listReshScale(qstnVo);
                    qstnVo.setReschScaleList(listReshScale);
                }
            }
            pageVo.setReschQstnList(listReshQstn);
        }

        return listReshPage;
    }

    /*****************************************************
     * <p>
     * TODO 설문 참여자 리스트 조회
     * </p>
     * 설문 참여자 리스트 조회
     * 
     * @param ReshVO
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> listReshJoinUser(ReshVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<EgovMap> reshAnsrList = reshAnsrDAO.listReshJoinUser(vo);
        
        paginationInfo.setTotalRecordCount(reshAnsrDAO.reshJoinUserCnt(vo));
        
        ProcessResultVO<EgovMap> returnVO = new ProcessResultVO<EgovMap>();
        
        returnVO.setReturnList(reshAnsrList);
        returnVO.setPageInfo(paginationInfo);
        
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 제출
     * </p>
     * 설문 제출
     * 
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> insertReshAnsr(ReshAnsrVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        // 설문 검사
        ReshVO reshVO = new ReshVO();
        reshVO.setReschCd(vo.getReschCd());
        reshVO = reshDAO.select(reshVO);
        
        if(reshVO == null) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.resh.not_exist", null, locale)); // 설문이 존재하지 않습니다.
            return resultVO;
        }
        
        if(reshVO.getDelYn() == null || "Y".equals(reshVO.getDelYn())) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.resh.not_exist", null, locale)); // 설문이 존재하지 않습니다.
            return resultVO;
        }
        
        if(reshVO.getReschStatus() == null || !"진행".equals(reshVO.getReschStatus())) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.resh.not_period", null, locale)); // 설문 참여 기간이 아닙니다.
            return resultVO;
        }
        
        if(reshVO.getUseYn() == null || !"Y".equals(reshVO.getUseYn())) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.resh.not_open", null, locale)); // 비공개 설문입니다.
            return resultVO;
        }
        
        // 설문 참여 정보 조회
        ReshAnsrVO joinUserVO = reshAnsrDAO.selectReshJoinUserInfo(vo);
        if(joinUserVO != null) {
            reshAnsrDAO.delReshJoinUser(joinUserVO);
        }
            
        String evalYn = "J".equals(reshVO.getEvalCtgr()) ? "Y" : "N";
        double score = "J".equals(reshVO.getEvalCtgr()) ? 100 : 0;
        vo.setEvalYn(evalYn);
        vo.setScore(score);
        reshAnsrDAO.insertReshJoinUser(vo);
        
        List<String> reshQstnCdList = vo.getReshQstnCdList();
        List<String> etcOpinionList = vo.getEtcOpinionList();
        List<String> reshAnswerList = vo.getReshAnswerList();
        int idx = 0;
        
        if(reshQstnCdList != null && !reshQstnCdList.isEmpty() && reshQstnCdList.size() > 0) {
            for(String reschQstnCd : reshQstnCdList) {
                // 문항 정보 조회
                ReshQstnVO qstnVO = new ReshQstnVO();
                qstnVO.setReschQstnCd(reschQstnCd);
                qstnVO = reshQstnDAO.selectReshQstn(qstnVO);
                
                ReshAnsrVO ansrVO = new ReshAnsrVO();
                ansrVO.setReschCd(vo.getReschCd());
                ansrVO.setReschQstnCd(reschQstnCd);
                ansrVO.setUserId(vo.getUserId());
                ansrVO.setRgtrId(vo.getRgtrId());
                ansrVO.setMdfrId(vo.getMdfrId());
                
                // 단일형, OX형
                if("SINGLE".equals(qstnVO.getReschQstnTypeCd()) || "OX".equals(qstnVO.getReschQstnTypeCd())) {
                    ansrVO.setReschAnsrCd(IdGenerator.getNewId("RSA"));
                    
                    if ("ETC".equals(reshAnswerList.get(idx)) && !"".equals(etcOpinionList.get(idx))) {
                        ansrVO.setReschQstnItemCd(qstnVO.getEtcItemCd());
                        ansrVO.setReschScaleCd(null);
                        ansrVO.setEtcOpinion(etcOpinionList.get(idx));
                    } else {
                        ansrVO.setReschQstnItemCd(reshAnswerList.get(idx));
                        ansrVO.setReschScaleCd(null);
                        ansrVO.setEtcOpinion(null);
                    }
                    reshAnsrDAO.insertReshAnsr(ansrVO);
                }
                
                // 다중형
                if("MULTI".equals(qstnVO.getReschQstnTypeCd())) {
                    String[] answerItemCdList = reshAnswerList.get(idx).split("\\,");
                    for(int i = 0; i < answerItemCdList.length; i++) {
                        ansrVO.setReschAnsrCd(IdGenerator.getNewId("RSA"));
                        
                        if ("ETC".equals(answerItemCdList[i]) && !"".equals(etcOpinionList.get(idx))) {
                            ansrVO.setReschQstnItemCd(qstnVO.getEtcItemCd());
                            ansrVO.setReschScaleCd(null);
                            ansrVO.setEtcOpinion(etcOpinionList.get(idx));
                        } else {
                            ansrVO.setReschQstnItemCd(answerItemCdList[i]);
                            ansrVO.setReschScaleCd(null);
                            ansrVO.setEtcOpinion(null);
                        }
                        reshAnsrDAO.insertReshAnsr(ansrVO);
                    }
                }
                
                // 척도형
                if("SCALE".equals(qstnVO.getReschQstnTypeCd())) {
                    String[] answerItemCdList = reshAnswerList.get(idx).split("\\,");
                    for(int i = 0; i < answerItemCdList.length; i++) {
                        String[] answerItemScaleList = answerItemCdList[i].split("\\|");
                        
                        ansrVO.setReschAnsrCd(IdGenerator.getNewId("RSA"));
                        ansrVO.setReschQstnItemCd(answerItemScaleList[0]);
                        ansrVO.setReschScaleCd(answerItemScaleList[1]);
                        ansrVO.setEtcOpinion(null);
                        reshAnsrDAO.insertReshAnsr(ansrVO);
                    }
                }
                
                // 서술형
                if("TEXT".equals(qstnVO.getReschQstnTypeCd())) {
                    ansrVO.setReschAnsrCd(IdGenerator.getNewId("RSA"));
                    ansrVO.setReschQstnItemCd(null);
                    ansrVO.setReschScaleCd(null);
                    ansrVO.setEtcOpinion(etcOpinionList.get(idx));
                    reshAnsrDAO.insertReshAnsr(ansrVO);
                }
                
                idx++;
            }
        }
        
        return resultVO;
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 수정
     * </p>
     * 설문 수정
     * 
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateReshAnsrByUser(ReshAnsrVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String reschCd = vo.getReschCd();
        String userId = vo.getUserId();
        
        if(ValidationUtils.isEmpty(reschCd) || ValidationUtils.isEmpty(userId)) {
            throw new ServiceProcessException(messageSource.getMessage("fail.common.msg", null, locale));
        }
        
        ReshAnsrVO reshAnsrVO = new ReshAnsrVO();
        reshAnsrVO.setReschCd(reschCd);
        reshAnsrVO.setUserId(userId);
        reshAnsrDAO.delReshAnsr(reshAnsrVO);
        reshAnsrDAO.delReshJoinUser(reshAnsrVO);
        
        return this.insertReshAnsr(vo, request);
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 수정
     * </p>
     * 설문 수정
     * 
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateReshAnsr(ReshAnsrVO vo, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String reschCd = vo.getReschCd();
        String userId = vo.getUserId();
        
        if(ValidationUtils.isEmpty(reschCd) || ValidationUtils.isEmpty(userId)) {
            throw new ServiceProcessException(messageSource.getMessage("fail.common.msg", null, locale));
        }
        
        ReshAnsrVO reshAnsrVO = new ReshAnsrVO();
        reshAnsrVO.setReschCd(reschCd);
        reshAnsrDAO.delReshAnsr(reshAnsrVO);
        
        reshAnsrVO.setUserId(userId);
        reshAnsrDAO.delReshJoinUser(reshAnsrVO);
        
        return this.insertReshAnsr(vo, request);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 참여자 수 조회
     * </p>
     * 설문 문항 참여자 수 조회
     * 
     * @param ReshAnsrVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int reshQstnJoinUserCnt(ReshAnsrVO vo) throws Exception {
        List<String> reschQstnCds = Arrays.asList(vo.getReschQstnCd().split("\\|"));
        vo.setReschQstnCds(reschQstnCds);
        return reshAnsrDAO.reshQstnJoinUserCnt(vo);
    }

    /*****************************************************
     * <p>
     * TODO 홈페이지 설문 참여자 목록 조회
     * </p>
     * 홈페이지 설문 참여자 목록 조회
     * 
     * @param ReshAnsrVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<EgovMap> listHomeReshJoinUser(ReshAnsrVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<EgovMap> joinUserList = reshAnsrDAO.listHomeReshJoinUser(vo);
        
        if(joinUserList.size() > 0) {
            paginationInfo.setTotalRecordCount(Integer.valueOf(joinUserList.get(0).get("totalCnt").toString()));
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<EgovMap> returnVO = new ProcessResultVO<EgovMap>();
        
        returnVO.setReturnList(joinUserList);
        returnVO.setPageInfo(paginationInfo);
        
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 홈페이지 설문 참여 현황 조회
     * </p>
     * 홈페이지 설문 참여 현황 조회
     * 
     * @param ReshVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectHomeReshJoinUserStatus(ReshVO vo) throws Exception {
        return reshAnsrDAO.selectHomeReshJoinUserStatus(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 답변 목록
     * </p>
     * 설문 답변 목록
     * 
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshAnswer(ReshVO vo) throws Exception {
        return reshAnsrDAO.listReshAnswer(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 및 척도 목록
     * </p>
     * 설문 문항 및 척도 목록
     * 
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshQstnAndScale(ReshVO vo) throws Exception {
        return reshAnsrDAO.listReshQstnAndScale(vo);
    }

    /*****************************************************
     * <p>
     * TODO 나의 설문 답변 목록
     * </p>
     * 나의 설문 답변 목록
     * 
     * @param ReshAnsrVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshMyAnswer(ReshAnsrVO vo) throws Exception {
        return reshAnsrDAO.listReshMyAnswer(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 점수 수정
     * </p>
     * 설문 점수 수정
     * 
     * @param ReshAnsrVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateReshScore(ReshAnsrVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        ReshAnsrVO ansrVO = new ReshAnsrVO();
        ansrVO.setReschCd(vo.getReschCd());
        ansrVO.setScore(vo.getScore());
        ansrVO.setScoreType(vo.getScoreType());
        ansrVO.setRgtrId(vo.getRgtrId());
        ansrVO.setMdfrId(vo.getMdfrId());
        
        if("".equals(StringUtil.nvl(vo.getUserIds()))) {
            StdVO stdVO = new StdVO();
            stdVO.setCrsCreCd(vo.getCrsCreCd());
            stdVO.setPagingYn("N");
            List<StdVO> stdList = stdDAO.stdList(stdVO);
            for(StdVO svo : stdList) {
                ansrVO.setUserId(svo.getUserId());
                ansrVO.setStdId(svo.getStdId());
                reshAnsrDAO.updateReshScore(ansrVO);
            }
        } else {
            for(String userId : vo.getUserIds().split(",")) {
                StdVO stdVO = new StdVO();
                stdVO.setUserId(userId);
                stdVO.setCrsCreCd(vo.getCrsCreCd());
                stdVO = stdDAO.selectStd(stdVO);
                ansrVO.setUserId(userId);
                ansrVO.setStdId(StringUtil.nvl(stdVO.getStdId()));
                reshAnsrDAO.updateReshScore(ansrVO);
            }
        }
        
        resultVO.setResult(1);
        return resultVO;
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 참여자 정보 조회
     * </p>
     * 설문 참여자 정보 조회
     * 
     * @param ReshAnsrVO
     * @return ReshAnsrVO
     * @throws Exception
     ******************************************************/
    @Override
    public ReshAnsrVO selectReshJoinUserInfo(ReshAnsrVO vo) throws Exception {
        return reshAnsrDAO.selectReshJoinUserInfo(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 메모 수정
     * </p>
     * 설문 메모 수정
     * 
     * @param ReshAnsrVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateReshUserMemo(ReshAnsrVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        StdVO stdVO = new StdVO();
        stdVO.setCrsCreCd(vo.getCrsCreCd());
        stdVO.setUserId(vo.getUserId());
        stdVO = stdDAO.selectStd(stdVO);
        vo.setStdId(stdVO.getStdId());
        reshAnsrDAO.updateReshUserMemo(vo);
        
        resultVO.setResult(1);
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 메모 조회
     * </p>
     * 설문 메모 조회
     * 
     * @param ReshAnsrVO
     * @return ReshAnsrVO
     * @throws Exception
     ******************************************************/
    @Override
    public ReshAnsrVO selectProfMemo(ReshAnsrVO vo) throws Exception {
        return reshAnsrDAO.selectProfMemo(vo);
    }

    /*****************************************************
     * <p>
     * TODO 엑셀 설문 성적 업로드
     * </p>
     * 엑셀 설문 성적 업로드
     * 
     * @param ReshAnsrVO, List<?>
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateExampleExcelScore(ReshAnsrVO vo, List<?> stdList) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        ReshAnsrVO ansrVO = new ReshAnsrVO();
        ansrVO.setReschCd(vo.getReschCd());
        ansrVO.setRgtrId(vo.getRgtrId());
        ansrVO.setMdfrId(vo.getMdfrId());
        
        //update 값 세팅
        if(stdList != null) {
            for (int i = 0; i < stdList.size(); i++){
                Map<String, Object> stdNoMap = (Map<String, Object>)stdList.get(i);
                String userId = StringUtil.nvl((String) stdNoMap.get("B"));
                double score     = (Math.floor(Double.parseDouble(StringUtil.nvl((String)stdNoMap.get("D"), "0"))));
                
                StdVO stdVO = new StdVO();
                stdVO.setUserId(userId);
                stdVO.setCrsCreCd(vo.getCrsCreCd());
                stdVO = stdDAO.selectStd(stdVO);
                
                ansrVO.setUserId(userId);
                ansrVO.setStdId(StringUtil.nvl(stdVO.getStdId()));
                ansrVO.setScore(score);
                reshAnsrDAO.updateReshScore(ansrVO);
            }
        }
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 참여자 리스트 조회(EZ-Grader)
     * </p>
     * 설문 참여자 리스트 조회(EZ-Grader)
     * 
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshJoinUserByEzGrader(ReshAnsrVO vo) throws Exception {
        return reshAnsrDAO.listReshJoinUserByEzGrader(vo);
    }
    
}
