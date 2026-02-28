package knou.lms.resh.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.dao.OrgCodeDAO;
import knou.lms.org.vo.OrgCodeVO;
import knou.lms.resh.dao.ReshDAO;
import knou.lms.resh.dao.ReshQstnDAO;
import knou.lms.resh.service.ReshQstnService;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnItemVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshScaleVO;
import knou.lms.resh.vo.ReshVO;

@Service("reshQstnService")
public class ReshQstnServiceImpl extends ServiceBase implements ReshQstnService {

    @Resource(name="reshDAO")
    private ReshDAO reshDAO;
    
    @Resource(name="reshQstnDAO")
    private ReshQstnDAO reshQstnDAO;
    
    @Resource(name="orgCodeDAO")
    private OrgCodeDAO orgCodeDAO;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;

    /*****************************************************
     * <p>
     * TODO 설문 페이지 목록 조회 (항목 포함)
     * </p>
     * 설문 페이지 목록 조회 (항목 포함)
     * 
     * @param ReshPageVO
     * @return List<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshPageVO> listReshPage(ReshPageVO vo) throws Exception {
        
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
                    List<ReshQstnItemVO> listReshQstnItem = reshQstnDAO.listReshQstnItem(qstnVo);
                    qstnVo.setReschQstnItemList(listReshQstnItem);
                    
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
     * TODO 설문 페이지별 문항 목록 조회
     * </p>
     * 설문 페이지별 문항 목록 조회
     * 
     * @param ReshPageVO
     * @return List<ReshQstnVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshQstnVO> listReshQstn(ReshPageVO vo) throws Exception {

        return reshQstnDAO.listReshQstn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 아이템 목록 조회
     * </p>
     * 설문 문항 아이템 목록 조회
     * 
     * @param ReshQstnVO
     * @return List<ReshQstnItemVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshQstnItemVO> listReshQstnItem(ReshQstnVO vo) throws Exception {

        return reshQstnDAO.listReshQstnItem(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 척도 목록 조회
     * </p>
     * 설문 문항 척도 목록 조회
     * 
     * @param ReshQstnVO
     * @return List<ReshScaleVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshScaleVO> listReshScale(ReshQstnVO vo) throws Exception {

        return reshQstnDAO.listReshScale(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 정보 조회
     * </p>
     * 설문 문항 정보 조회
     * 
     * @param ReshQstnVO
     * @return ReshQstnVO
     * @throws Exception
     ******************************************************/
    @Override
    public ReshQstnVO selectReshQstn(ReshQstnVO vo) throws Exception {

        return reshQstnDAO.selectReshQstn(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지 조회
     * </p>
     * 설문 페이지 조회
     * 
     * @param ReshPageVO
     * @return ReshPageVO
     * @throws Exception
     ******************************************************/
    @Override
    public ReshPageVO selectReshPage(ReshPageVO vo) throws Exception {

        return reshQstnDAO.selectReshPage(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지 목록 조회
     * </p>
     * 설문 페이지 목록 조회
     * 
     * @param ReshPageVO
     * @return List<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshPageVO> listReshSimplePage(ReshPageVO vo) throws Exception {

        return reshQstnDAO.listReshPage(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 복사
     * </p>
     * 설문 문항 복사
     * 
     * @param ReshPageVO
     * @return ProcessResultVO<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ReshPageVO> copyReshQstn(ReshPageVO vo) throws Exception {
        ProcessResultVO<ReshPageVO> returnVO = new ProcessResultVO<ReshPageVO>();
        
        // 전체 복사 (기존 문항 삭제)
        if("Y".equals(vo.getEntireCopyYn())) {
            // 설문 페이지 조회
            List<ReshPageVO> reshPageList = reshQstnDAO.listReshPage(vo);
            if(reshPageList != null && !reshPageList.isEmpty() && reshPageList.size() > 0) {
                for(ReshPageVO pageVO : reshPageList) {
                    // 척도 등급 삭제
                    ReshScaleVO scaleVO = new ReshScaleVO();
                    scaleVO.setReschPageCd(pageVO.getReschPageCd());
                    reshQstnDAO.delReshScale(scaleVO);
                    
                    // 문항 아이템 삭제
                    ReshQstnItemVO qstnItemVO = new ReshQstnItemVO();
                    qstnItemVO.setReschPageCd(pageVO.getReschPageCd());
                    reshQstnDAO.delReshQstnItem(qstnItemVO);
                    
                    // 문항 삭제
                    ReshQstnVO qstnVO = new ReshQstnVO();
                    qstnVO.setReschPageCd(pageVO.getReschPageCd());
                    reshQstnDAO.delReshQstn(qstnVO);
                    
                    // 페이지 삭제
                    reshQstnDAO.delReshPage(pageVO);
                }
            }
            
            // 설문 정보 업데이트
            ReshVO reshVO = new ReshVO();
            reshVO.setItemCopyReschCd(vo.getCopyReschCd());
            reshVO.setItemCopyYn("Y");
            reshVO.setReschCd(vo.getReschCd());
            reshVO.setMdfrId(vo.getMdfrId());
            reshDAO.updateReshQstnCopy(reshVO);
            
            // 복사 설문 페이지 조회
            ReshPageVO copyReshPageVO = new ReshPageVO();
            copyReshPageVO.setReschCd(vo.getCopyReschCd());
            List<ReshPageVO> copyReshPageList = reshQstnDAO.listReshPage(copyReshPageVO);
            // 페이지 코드 생성
            Map<String, Object> reschPageCdMap = new HashMap<String, Object>();
            if(copyReshPageList != null && !copyReshPageList.isEmpty() && copyReshPageList.size() > 0) {
                for(ReshPageVO pageVO : copyReshPageList) {
                    reschPageCdMap.put(pageVO.getReschPageCd(), IdGenerator.getNewId("RSPG"));
                }
                
                for(ReshPageVO pageVO : copyReshPageList) {
                    pageVO.setReschCd(vo.getReschCd());
                    pageVO.setRgtrId(vo.getRgtrId());
                    // 해당 페이지 문항 리스트 조회
                    List<ReshQstnVO> reshQstnList = reshQstnDAO.listReshQstn(pageVO);
                    // 페이지 등록
                    pageVO.setReschPageCd(reschPageCdMap.get(pageVO.getReschPageCd()).toString());
                    reshQstnDAO.insertReshPage(pageVO);
                    
                    // 문항 등록
                    if(reshQstnList != null && !reshQstnList.isEmpty() && reshQstnList.size() > 0) {
                        for(ReshQstnVO qstnVO : reshQstnList) {
                            // 문항 아이템 리스트 조회
                            List<ReshQstnItemVO> copyReshQstnItemList = reshQstnDAO.listReshQstnItem(qstnVO);
                            
                            // 문항 척도 등급 조회
                            List<ReshScaleVO> copyReshScaleList = reshQstnDAO.listReshScale(qstnVO);
                            
                            // 문항 생성
                            String newReschQstnCd = IdGenerator.getNewId("RSQ");
                            qstnVO.setReschQstnCd(newReschQstnCd);
                            qstnVO.setRgtrId(vo.getRgtrId());
                            qstnVO.setReschPageCd(pageVO.getReschPageCd());
                            reshQstnDAO.insertReshQstn(qstnVO);
                            
                            // 문항 아이템 생성
                            if (copyReshQstnItemList != null && !copyReshQstnItemList.isEmpty() && copyReshQstnItemList.size() > 0) {
                                for(ReshQstnItemVO reshQstnItemVO : copyReshQstnItemList) {
                                    String newReshQstnItemCd = IdGenerator.getNewId("RSIT");
                                    reshQstnItemVO.setReschQstnItemCd(newReshQstnItemCd);
                                    reshQstnItemVO.setReschQstnCd(newReschQstnCd);
                                    reshQstnItemVO.setRgtrId(vo.getRgtrId());

                                    if (reshQstnItemVO.getJumpPage() != null 
                                        && !"NEXT".equals(reshQstnItemVO.getJumpPage()) 
                                        && !"END".equals(reshQstnItemVO.getJumpPage()) ) {
                                        String jumpPageCd = "NEXT";
                                        if (reschPageCdMap.get(reshQstnItemVO.getJumpPage()) != null ) {
                                            jumpPageCd = reschPageCdMap.get(reshQstnItemVO.getJumpPage()).toString();
                                        }
                                        reshQstnItemVO.setJumpPage(jumpPageCd);
                                    }
                                    reshQstnDAO.insertReshQstnItem(reshQstnItemVO);
                                }
                            }

                            // 문항 척도 등급  생성
                            if (copyReshScaleList != null && !copyReshScaleList.isEmpty() && copyReshScaleList.size() > 0) {
                                for(ReshScaleVO reshScaleVO : copyReshScaleList) {
                                    String newReshQstnScaleCd = IdGenerator.getNewId("RSSC");
                                    reshScaleVO.setReschScaleCd(newReshQstnScaleCd);
                                    reshScaleVO.setReschQstnCd(newReschQstnCd);
                                    reshScaleVO.setRgtrId(vo.getRgtrId());

                                    reshQstnDAO.insertReshScale(reshScaleVO);
                                }
                            }
                        }
                    }
                }
            }
            
        // 일부 복사
        } else if("N".equals(vo.getEntireCopyYn())) {
            String reschPageCd = IdGenerator.getNewId("RSPG");
            vo.setReschPageCd(reschPageCd);
            vo.setReschPageTitle("페이지");
            reshQstnDAO.insertReshPage(vo);
            
            List<String> copyReschQstnCdList = Arrays.asList(vo.getCopyReschQstnCds().split(","));
            if(copyReschQstnCdList != null && !copyReschQstnCdList.isEmpty() && copyReschQstnCdList.size() > 0) {
                for(String reschQstnCd : copyReschQstnCdList) {
                    ReshQstnVO qstnVO = new ReshQstnVO();
                    qstnVO.setReschQstnCd(reschQstnCd);
                    // 문항 조회
                    qstnVO = reshQstnDAO.selectReshQstn(qstnVO);
                    
                    // 문항 아이템 리스트 조회
                    List<ReshQstnItemVO> copyReshQstnItemList = reshQstnDAO.listReshQstnItem(qstnVO);
                    
                    // 문항 척도 등급 조회
                    List<ReshScaleVO> copyReshScaleList = reshQstnDAO.listReshScale(qstnVO);
                    
                    // 문항 생성
                    String newReschQstnCd = IdGenerator.getNewId("RSQ");
                    qstnVO.setReschQstnCd(newReschQstnCd);
                    qstnVO.setRgtrId(vo.getRgtrId());
                    qstnVO.setReschPageCd(vo.getReschPageCd());
                    if(qstnVO.getJumpChoiceYn() != null) {
                        qstnVO.setJumpChoiceYn("N");
                    }
                    reshQstnDAO.insertReshQstn(qstnVO);
                    
                    // 문항 아이템 생성
                    if(copyReshQstnItemList != null && !copyReshQstnItemList.isEmpty() && copyReshQstnItemList.size() > 0) {
                        int i = 0;
                        for(ReshQstnItemVO qstnItemVO : copyReshQstnItemList) {
                            String newReschQstnItemCd = IdGenerator.getNewId("RSIT");
                            qstnItemVO.setReschQstnItemCd(newReschQstnItemCd);
                            qstnItemVO.setReschQstnCd(newReschQstnCd);
                            qstnItemVO.setRgtrId(vo.getRgtrId());
                            qstnItemVO.setJumpPage(null);
                            qstnItemVO.setItemOdr(i+1);
                            reshQstnDAO.insertReshQstnItem(qstnItemVO);
                            i++;
                        }
                    }
                    
                    // 문항 척도 등급 생성
                    if(copyReshScaleList != null && !copyReshScaleList.isEmpty() && copyReshScaleList.size() > 0) {
                        int i = 0;
                        for(ReshScaleVO scaleVO : copyReshScaleList) {
                            String newReschQstnScaleCd = IdGenerator.getNewId("RSSC");
                            scaleVO.setReschScaleCd(newReschQstnScaleCd);
                            scaleVO.setReschQstnCd(newReschQstnCd);
                            scaleVO.setRgtrId(vo.getRgtrId());
                            scaleVO.setScaleOdr(i+1);
                            reshQstnDAO.insertReshScale(scaleVO);
                            i++;
                        }
                    }
                }
            }
        }
        
        returnVO.setReturnVO(vo);
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지 순서 변경
     * </p>
     * 설문 페이지 순서 변경
     * 
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> editReshPageOdr(ReshPageVO vo) throws Exception {
        ProcessResultVO<DefaultVO> returnVO = new ProcessResultVO<DefaultVO>();
        
        reshQstnDAO.updateReshPageOdr(vo);
        reshQstnDAO.updateReshPageOdrToNo(vo);
        
        return returnVO;
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 페이지별 항목 순서 변경
     * </p>
     * 설문 페이지별 항목 순서 변경
     * 
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> editReshQstnOdr(ReshQstnVO vo) throws Exception {
        ProcessResultVO<DefaultVO> returnVO = new ProcessResultVO<DefaultVO>();
        
        reshQstnDAO.updateReshQstnOdr(vo);
        reshQstnDAO.updateReshQstnOdrToNo(vo);
        
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지 등록
     * </p>
     * 설문 페이지 등록
     * 
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> insertReshPage(ReshPageVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        String reschPageCd = IdGenerator.getNewId("RSPG");
        vo.setReschPageCd(reschPageCd);
        reshQstnDAO.insertReshPage(vo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지 수정
     * </p>
     * 설문 페이지 수정
     * 
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateReshPage(ReshPageVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        reshQstnDAO.updateReshPage(vo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 페이지 삭제
     * </p>
     * 설문 페이지 삭제
     * 
     * @param ReshPageVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> deleteReshPage(ReshPageVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        // 페이지 번호 변경
        vo.setSearchKey("DOWN");
        vo.setNewReschPageOdr(9999);
        reshQstnDAO.updateReshPageOdr(vo);
        
        // 척도 등급 삭제
        ReshScaleVO scaleVO = new ReshScaleVO();
        scaleVO.setReschPageCd(vo.getReschPageCd());
        reshQstnDAO.delReshScale(scaleVO);
        
        // 문항 아이템 삭제
        ReshQstnItemVO qstnItemVO = new ReshQstnItemVO();
        qstnItemVO.setReschPageCd(vo.getReschPageCd());
        reshQstnDAO.delReshQstnItem(qstnItemVO);
        
        // 문항 삭제
        ReshQstnVO qstnVO = new ReshQstnVO();
        qstnVO.setReschPageCd(vo.getReschPageCd());
        reshQstnDAO.delReshQstn(qstnVO);
        
        // 페이지 삭제
        reshQstnDAO.delReshPage(vo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 등록
     * </p>
     * 설문 문항 등록
     * 
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> insertReshQstn(ReshQstnVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        // 문항 코드 생성
        String reschQstnCd = IdGenerator.getNewId("RSQ");
        vo.setReschQstnCd(reschQstnCd);
        
        // 척도 등급 삭제
        ReshScaleVO scVO = new ReshScaleVO();
        scVO.setReschQstnCd(vo.getReschQstnCd());
        reshQstnDAO.delReshScale(scVO);
        
        // 문항 선택지 삭제
        ReshQstnItemVO qiVO = new ReshQstnItemVO();
        qiVO.setReschQstnCd(vo.getReschQstnCd());
        reshQstnDAO.delReshQstnItem(qiVO);
        
        // 문항 등록
        reshQstnDAO.insertReshQstn(vo);
        
        // 문항 선택지 등록
        List<String> reschQstnItemTitles = vo.getReschQstnItemTitles();
        List<String> jumpPages =  vo.getJumpPages();
        if(reschQstnItemTitles != null && !reschQstnItemTitles.isEmpty() && reschQstnItemTitles.size() > 0) {
            int i = 0;
            ReshQstnItemVO qstnItemVO = new ReshQstnItemVO();
            qstnItemVO.setReschQstnCd(vo.getReschQstnCd());
            qstnItemVO.setRgtrId(vo.getRgtrId());
            for(String title : reschQstnItemTitles) {
                String reschQstnItemCd = IdGenerator.getNewId("RSLT");
                qstnItemVO.setReschQstnItemCd(reschQstnItemCd);
                qstnItemVO.setReschQstnItemTitle(title);
                qstnItemVO.setItemOdr(i+1);
                
                if(vo.getJumpChoiceYn() != null && "Y".equals(vo.getJumpChoiceYn())
                        && jumpPages != null && !jumpPages.isEmpty() && jumpPages.size() > 0) {
                    qstnItemVO.setJumpPage(jumpPages.get(i));
                }
                
                if(vo.getEtcOpinionYn() != null && "Y".equals(vo.getEtcOpinionYn())
                        && "SINGLE_ETC_ITEM".equals(title)) {
                    qstnItemVO.setEtcItemYn("Y");
                } else {
                    qstnItemVO.setEtcItemYn("N");
                }
                reshQstnDAO.insertReshQstnItem(qstnItemVO);
                i++;
            }
            
        }
        
        // 문항 척도 등록
        List<String> scaleTitles = vo.getScaleTitles();
        List<String> scaleScores = vo.getScaleScores();
        if(scaleTitles != null && !scaleTitles.isEmpty() && scaleTitles.size() > 0) {
            int i = 0;
            int scaleOdr = 0;
            ReshScaleVO scaleVO = new ReshScaleVO();
            scaleVO.setReschQstnCd(vo.getReschQstnCd());
            scaleVO.setRgtrId(vo.getRgtrId());
            for(String title : scaleTitles) {
                if(title != null && !"".equals(title.trim())) {
                    String reschScaleCd = IdGenerator.getNewId("RSSC");
                    scaleVO.setReschScaleCd(reschScaleCd);
                    scaleVO.setScaleTitle(title);
                    scaleVO.setScaleOdr(scaleOdr+1);
                    if("".equals(scaleScores.get(i).trim())) {
                        scaleVO.setScaleScore(0);
                    } else {
                        scaleVO.setScaleScore(Integer.parseInt(scaleScores.get(i)));
                    }
                    reshQstnDAO.insertReshScale(scaleVO);
                    scaleOdr++;
                }
                i++;
            }
        }
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 수정
     * </p>
     * 설문 문항 수정
     * 
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> updateReshQstn(ReshQstnVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        // 척도 등급 삭제
        ReshScaleVO scVO = new ReshScaleVO();
        scVO.setReschQstnCd(vo.getReschQstnCd());
        reshQstnDAO.delReshScale(scVO);
        
        // 문항 선택지 삭제
        ReshQstnItemVO qiVO = new ReshQstnItemVO();
        qiVO.setReschQstnCd(vo.getReschQstnCd());
        reshQstnDAO.delReshQstnItem(qiVO);
        
        // 문항 수정
        reshQstnDAO.updateReshQstn(vo);
        
        // 문항 선택지 등록
        List<String> reschQstnItemTitles = vo.getReschQstnItemTitles();
        List<String> jumpPages = vo.getJumpPages();
        if(reschQstnItemTitles != null && !reschQstnItemTitles.isEmpty() && reschQstnItemTitles.size() > 0) {
            int i = 0;
            ReshQstnItemVO qstnItemVO = new ReshQstnItemVO();
            qstnItemVO.setReschQstnCd(vo.getReschQstnCd());
            qstnItemVO.setRgtrId(vo.getRgtrId());
            for(String title : reschQstnItemTitles) {
                String reschQstnItemCd = IdGenerator.getNewId("RSLT");
                qstnItemVO.setReschQstnItemCd(reschQstnItemCd);
                qstnItemVO.setReschQstnItemTitle(title);
                qstnItemVO.setItemOdr(i+1);
                
                if(vo.getJumpChoiceYn() != null && "Y".equals(vo.getJumpChoiceYn())
                        && jumpPages != null && !jumpPages.isEmpty() && jumpPages.size() > 0) {
                    qstnItemVO.setJumpPage(jumpPages.get(i));
                }
                
                if (vo.getEtcOpinionYn() != null && "Y".equals(vo.getEtcOpinionYn()) 
                        && "SINGLE_ETC_ITEM".equals(title) ) {
                    qstnItemVO.setEtcItemYn("Y");
                } else {
                    qstnItemVO.setEtcItemYn("N");
                }
                
                reshQstnDAO.insertReshQstnItem(qstnItemVO);
                i++;
            }
        }
        
        // 문항 척도 등록
        List<String> scaleTitles = vo.getScaleTitles();
        List<String> scaleScores = vo.getScaleScores();
        if(scaleTitles != null && !scaleTitles.isEmpty() && scaleTitles.size() > 0) {
            int i = 0;
            int scaleOdr = 0;
            ReshScaleVO scaleVO = new ReshScaleVO();
            scaleVO.setReschQstnCd(vo.getReschQstnCd());
            scaleVO.setRgtrId(vo.getRgtrId());
            for(String title : scaleTitles) {
                if(title != null && !"".equals(title.trim())) {
                    String reschScaleCd = IdGenerator.getNewId("RSSC");
                    scaleVO.setReschScaleCd(reschScaleCd);
                    scaleVO.setScaleTitle(title);
                    scaleVO.setScaleOdr(scaleOdr+1);
                    if("".equals(scaleScores.get(i).trim())) {
                        scaleVO.setScaleScore(0);
                    } else {
                        scaleVO.setScaleScore(Integer.parseInt(scaleScores.get(i)));
                    }
                    reshQstnDAO.insertReshScale(scaleVO);
                    scaleOdr++;
                }
                i++;
            }
        }
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 삭제
     * </p>
     * 설문 문항 삭제
     * 
     * @param ReshQstnVO
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> deleteReshQstn(ReshQstnVO vo) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        vo.setSearchKey("DOWN");
        vo.setNewReschQstnOdr(9999);
        reshQstnDAO.updateReshQstnOdr(vo);
        
        // 척도 등급 삭제
        ReshScaleVO scaleVO = new ReshScaleVO();
        scaleVO.setReschQstnCd(vo.getReschQstnCd());
        reshQstnDAO.delReshScale(scaleVO);
        
        // 문항 선택지 삭제
        ReshQstnItemVO qstnItemVO = new ReshQstnItemVO();
        qstnItemVO.setReschQstnCd(vo.getReschQstnCd());
        reshQstnDAO.delReshQstnItem(qstnItemVO);
        
        // 문항 삭제
        reshQstnDAO.delReshQstn(vo);
        
        return resultVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 엑셀 업로드 샘플 파일 데이터 조회
     * </p>
     * 설문 엑셀 업로드 샘플 파일 데이터 조회
     * 
     * @param ReshPageVO
     * @return HashMap<String, Object>
     * @throws Exception
     ******************************************************/
    @Override
    public HashMap<String, Object> getReshQstnExcelSampleData(ReshPageVO vo) throws Exception {
        List<EgovMap> resultList = new ArrayList<EgovMap>();

        // 페이지 1 문항 1 ( 단일선택형)
        EgovMap egovMap = new EgovMap();
        egovMap.put("pageNo", "1");
        egovMap.put("pageNm", "페이지1");
        egovMap.put("pageCts", "페이지1입니다.");
        egovMap.put("qstnNo", "1");
        egovMap.put("qstnTypeCd", "SINGLE");
        egovMap.put("qstnNm", "문항1");
        egovMap.put("qstnCts", "문항1입니다");
        egovMap.put("reqQstnYn", "Y");
        egovMap.put("pageJumpYn", "Y");
        egovMap.put("etcOpinionQstnYn", "Y");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "문항1_보기1");
        egovMap.put("jumpPage", "2");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "문항1_보기2");
        egovMap.put("jumpPage", "3");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "3");
        egovMap.put("qstnItemNm", "문항1_보기3");
        egovMap.put("jumpPage", "NEXT");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "4");
        egovMap.put("qstnItemNm", "문항1_보기4");
        egovMap.put("jumpPage", "END");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "5");
        egovMap.put("qstnItemNm", "");
        egovMap.put("jumpPage", "END");
        egovMap.put("etcOpinionItemYn", "Y");
        resultList.add(egovMap);

        // 페이지 1 문항 2 ( 다중선택형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "2");
        egovMap.put("qstnTypeCd", "MULTI");
        egovMap.put("qstnNm", "문항2");
        egovMap.put("qstnCts", "문항2입니다");
        egovMap.put("reqQstnYn", "N");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "Y");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "문항2_보기1");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "문항2_보기2");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "3");
        egovMap.put("qstnItemNm", "문항2_보기3");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);


        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "4");
        egovMap.put("qstnItemNm", "문항2_보기4");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "N");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "5");
        egovMap.put("qstnItemNm", "");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "Y");
        resultList.add(egovMap);

        // 페이지 1 문항 3 ( OX형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "3");
        egovMap.put("qstnTypeCd", "OX");
        egovMap.put("qstnNm", "문항3");
        egovMap.put("qstnCts", "문항3입니다");
        egovMap.put("reqQstnYn", "N");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "Y");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "O");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "X");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        // 페이지 1 문항 4 ( 서술형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "4");
        egovMap.put("qstnTypeCd", "TEXT");
        egovMap.put("qstnNm", "문항4");
        egovMap.put("qstnCts", "문항4입니다");
        egovMap.put("reqQstnYn", "Y");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "N");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);


        // 페이지 1 문항 5 ( 척도형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "5");
        egovMap.put("qstnTypeCd", "SCALE");
        egovMap.put("qstnNm", "문항5");
        egovMap.put("qstnCts", "문항5입니다");
        egovMap.put("reqQstnYn", "Y");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "N");
        egovMap.put("scale", "1|매우그렇다|5, 2|그렇다|4, 3|그저그렇다|3, 4|아니다|2, 5|매우 아니다|1");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "문항5_보기1");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "문항5_보기2");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        // 페이지 2 문항 1 ( OX형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "2");
        egovMap.put("pageNm", "페이지2");
        egovMap.put("pageCts", "페이지2입니다.");
        egovMap.put("qstnNo", "1");
        egovMap.put("qstnTypeCd", "OX");
        egovMap.put("qstnNm", "문항2_1");
        egovMap.put("qstnCts", "문항2_1입니다");
        egovMap.put("reqQstnYn", "Y");
        egovMap.put("pageJumpYn", "Y");
        egovMap.put("etcOpinionQstnYn", "N");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "O");
        egovMap.put("jumpPage", "3");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "X");
        egovMap.put("jumpPage", "END");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        // 페이지 2 문항 2 ( 다중선택형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "2");
        egovMap.put("qstnTypeCd", "MULTI");
        egovMap.put("qstnNm", "문항2_2");
        egovMap.put("qstnCts", "문항2_2입니다");
        egovMap.put("reqQstnYn", "Y");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "N");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "문항2_2_보기1");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "문항2_2_보기2");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "3");
        egovMap.put("qstnItemNm", "문항2_2_보기3");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);


        // 페이지 3 문항 1 ( 단일선택형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "3");
        egovMap.put("pageNm", "페이지3");
        egovMap.put("pageCts", "페이지3입니다.");
        egovMap.put("qstnNo", "1");
        egovMap.put("qstnTypeCd", "SINGLE");
        egovMap.put("qstnNm", "문항3_1");
        egovMap.put("qstnCts", "문항3_1입니다");
        egovMap.put("reqQstnYn", "N");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "N");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "문항3_1_보기1");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "2");
        egovMap.put("qstnItemNm", "문항3_1_보기2");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "");
        egovMap.put("qstnTypeCd", "");
        egovMap.put("qstnNm", "");
        egovMap.put("qstnCts", "");
        egovMap.put("reqQstnYn", "");
        egovMap.put("pageJumpYn", "");
        egovMap.put("etcOpinionQstnYn", "");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "3");
        egovMap.put("qstnItemNm", "문항3_1_보기3");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);

        // 페이지 3 문항 2 ( 서술형)
        egovMap = new EgovMap();
        egovMap.put("pageNo", "");
        egovMap.put("pageNm", "");
        egovMap.put("pageCts", "");
        egovMap.put("qstnNo", "2");
        egovMap.put("qstnTypeCd", "TEXT");
        egovMap.put("qstnNm", "문항3_2");
        egovMap.put("qstnCts", "문항3_2입니다");
        egovMap.put("reqQstnYn", "N");
        egovMap.put("pageJumpYn", "N");
        egovMap.put("etcOpinionQstnYn", "N");
        egovMap.put("scale", "");
        egovMap.put("qstnItemNo", "1");
        egovMap.put("qstnItemNm", "");
        egovMap.put("jumpPage", "");
        egovMap.put("etcOpinionItemYn", "");
        resultList.add(egovMap);


        String[] searchValues = {
                  "⊙ 주의사항 : 엑셀로 문항 등록시 기존 등록된 설문 문항은 삭제됩니다."
                , "1. 페이지 번호 : 정수로 1부터 시작"
                , "2. 페이지 명 : 최대 50자 이내"
                , "3. 페이지 내용 : 입력하지 않아도 됨"
                , "4. 문항 번호 : 페이지 단위로, 정수로 1부터 시작. 페이지가 넘어가면 다시 1부터 시작"
                , "5. 문항유형 : 단일형(SINGLE), 다중형(MULTI), OX형(OX), 척도형(SCALE), 서술형(TEXT)"
                , "6. 문항 명 : 최대 100자 이내"
                , "7. 문항 내용 : 입력하지 않아도 됨"
                , "8. 필수문항여부 : Y이면 참여자가 반드시  해당문에 대한  답변을 해야함" 
                , "9. 페이지점프여부 : 해당문항에 대한  답변을 할때, 선택한 보기(선택지)에 따라 특정페이지로 이동 또는 설문종료 등의 처리를 할 것인지  여부"
                , "10. 기타의견입력가능여부 : 문항유형이 단일형 또는 다중형 일 경우에 주어진 보기(선택지) 이외의 기타 의견을 입력할 수 있도록 할것인지 여부"
                , "11. 척도 : 문항 유형이 척도형 일때만 입력.\r\n" + 
                        "아래 예시에서 \"1|매우그렇다|5\" 는 하나의 척도인데,\r\n" + 
                        "\"1\"은 척도의 순서이고, \"매우 그렇다\"는 척도명이고, \"5\"는 척도 점수이다.\r\n" + 
                        "(척도는 반드시  \"척도순서|척도명|척도점수\" 이 3개의 정보로 이루어 져야 한다.)\r\n" + 
                        "척도는 최대 10까지 입력될 수 있으며 척도와 척도 사이에 \",\"로 구분하면 된다."
                , "12. 문항보기번호 : 문항 단위로, 정수로 1부터 시작. 문항이 넘어가면  다시 1부터 시작"
                , "13. 문항보기명 : 최대 100자 이내. 기타의견 보기일 경우에는 빈칸으로 입력"
                , "14. 점프페이지 : 문항정보 중 페이지점프여부가 'Y'인 문항의 보기에만 설정한다.\r\n" + 
                        "입력하지 않아도 됨(입력하지 않으면 NEXT로 처리됨).\r\n" + 
                        "문항보기를 선택했을 때 특정 페이지로 이동하고자 한다면 특정 페이지 번호를 입력하고, \r\n" + 
                        "설문을 종료하고자 한다면 \"END\"를 입력하고 다음페이지로 이동하고자 한다면 \"NEXT\"를 입력하면 된다.\r\n" + 
                        "(아래 예제에서 2페이지로 이동하는 것과 NEXT로 이동하는 것은 동일하게 2페이지로 이동한다. NEXT 페이지가 2페이지이기 때문)"
                , "15. 기타의견여부 : 문항정보 중  기타의견입력가능여부가  \"Y\"로 설정되었을 경우에만 설정하면 됨.\r\n" + 
                        "기타의견여부가 \"Y\"인 문항보기는 보기명이 없어야 함."
        };

        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "설문 문항 엑셀 업로드 양식");
        map.put("sheetName", "sample");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", resultList);

        return map;
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 엑셀 업로드 처리
     * </p>
     * 설문 문항 엑셀 업로드 처리
     * 
     * @param ReshPageVO, List<?>
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<DefaultVO> uploadReshQstnExcel(ReshPageVO vo, List<?> qstnList, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        //0. 엑셀 업로드 건수가 없으면 바로 리턴
        if (qstnList == null || qstnList.isEmpty() || qstnList.size() == 0) {
            resultVo.setResult(1);
            return resultVo;
        }

        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setUseYn("Y");
        orgCodeVO.setOrgId("ORG0000001");
        orgCodeVO.setUpCd("RESCH_QSTN_TYPE_CD");
        List<OrgCodeVO> qstnTypeCdList = orgCodeDAO.selectOrgCodeList(orgCodeVO);

        //1. 엑셀에 등록된 건수만큼 loop 돌면서 페이지 CD 생성
        Map<String, Object> pageCdConversionMap = new HashMap<String, Object>();
        int etcOpinionCnt = 0;
        String strQstnNo = "";
        boolean isEtcOpipionQstn = false;
        String[] args = new String[1];
        for (int i = 0; i < qstnList.size(); i++) {
            Map<String, Object> qstnMap = (Map<String, Object>)qstnList.get(i);

            args[0] = "" + (vo.getExcelUploadSkipRows() + i);

            //1.1 페이지 번호 중복 검사
            if (qstnMap.get("A") != null && !"".equals(qstnMap.get("A").toString().trim()) ) {
                if (pageCdConversionMap.containsKey(qstnMap.get("A").toString()) ) { // 페이지 번호 중복 에러
                    resultVo.setResult(-1);
                    resultVo.setMessage(messageSource.getMessage("resh.error.dup.pageNo", args, locale));   // 라인의 페이지 번호는 중복 입력된 번호입니다.
                    return resultVo;
                }

                pageCdConversionMap.put(qstnMap.get("A").toString().trim(), IdGenerator.getNewId("RSPG"));
            }

            //1.2 문항 유형 검사 
            if (qstnMap.get("D") != null && !"".equals(qstnMap.get("D").toString().trim()) ) {
                if (qstnMap.get("E") == null || "".equals(qstnMap.get("E").toString().trim()) ) {
                    resultVo.setResult(-1);
                    resultVo.setMessage(messageSource.getMessage("resh.error.invalid.qstnTypeCd", args, locale));   // 라인의 문항 유형이 옳바르지 않습니다.
                    return resultVo;
                }

                boolean isValidTypeCd = false;
                for (OrgCodeVO qstnTypeCdVO : qstnTypeCdList) {
                    if (qstnTypeCdVO.getCd().equals(qstnMap.get("E").toString().trim())) {
                        isValidTypeCd = true;
                        break;
                    }
                }

                if (isValidTypeCd == false ) {
                    resultVo.setResult(-1);
                    resultVo.setMessage(messageSource.getMessage("resh.error.invalid.qstnTypeCd", args, locale));   // 라인의 문항 유형이 옳바르지 않습니다.
                    return resultVo;
                }

                // 척도형에 척도가 반드시 있어야 함.
                if ("SCALE".equals(qstnMap.get("E").toString().trim()) ) {
                    if (qstnMap.get("K") == null || "".equals(qstnMap.get("K").toString().trim())) {
                        resultVo.setResult(-1);
                        resultVo.setMessage(messageSource.getMessage("resh.error.scale.needed", args, locale)); // 라인의 문항에 척도가 등록되어야 합니다.
                        return resultVo;
                    }

                    String[] arrScale = qstnMap.get("K").toString().trim().split("\\,");
                    if (arrScale.length < 2) {
                        resultVo.setResult(-1);
                        resultVo.setMessage(messageSource.getMessage("resh.error.scale.more_two", args, locale));   // 라인의 문항에 척도는 최소 2개 이상이어야 합니다.
                        return resultVo;
                    }

                    for (String scale : arrScale ) {
                        String[] arrScaleItem = scale.trim().split("\\|");
                        if (arrScaleItem.length != 3) {
                            resultVo.setResult(-1);
                            resultVo.setMessage(messageSource.getMessage("resh.error.invalid.scale", args, locale));    // 라인의 척도가 옳바르지 않습니다.
                            return resultVo;
                        }

                        try {
                            Integer.parseInt(arrScaleItem[2]);
                        } catch(Exception e) {
                            resultVo.setResult(-1);
                            resultVo.setMessage(messageSource.getMessage("resh.error.notnum.scale_point", args, locale));   // 라인의 척도점수는 숫자로 입력해야 합니다.
                            return resultVo;
                        }
                    }
                }

                //1.3 기타 의견 보기가 하나인지 검사(기타 의견 보기 갯수는 문항별 최대 1개 이어야 한다.)
                if (isEtcOpipionQstn == true && etcOpinionCnt == 0 ) {
                    args[0] = strQstnNo;
                    resultVo.setResult(-1);
                    resultVo.setMessage(messageSource.getMessage("resh.error.etcOpipion.zero", args, locale));  // 라인의 문항에 기타의견 보기가 없습니다.
                    return resultVo;
                }

                if (isEtcOpipionQstn == true && etcOpinionCnt > 1 ) {
                    args[0] = strQstnNo;
                    resultVo.setResult(-1);
                    resultVo.setMessage(messageSource.getMessage("resh.error.etcOpipion.tooMany", args, locale));   // 라인의 문항에 기타의견 보기는 1개만 등록 할 수 있습니다.
                    return resultVo;
                }

                etcOpinionCnt = 0;
                strQstnNo = "" + (vo.getExcelUploadSkipRows() + i);
                isEtcOpipionQstn = false;

                if (("SINGLE".equals(qstnMap.get("E").toString().trim()) || "MULTI".equals(qstnMap.get("E").toString().trim())) 
                        && "Y".equals(qstnMap.get("J").toString().trim()) ) {
                    isEtcOpipionQstn = true;
                }

            }

            //1.3 기타 의견 보기가 하나인지 검사(기타 의견 보기 갯수는 문항별 최대 1개 이어야 한다.)
            if (isEtcOpipionQstn== true && qstnMap.get("O") != null && "Y".equals(qstnMap.get("O").toString().trim()) ) {
                etcOpinionCnt++;
            }
        } // for close

        if( pageCdConversionMap == null || pageCdConversionMap.isEmpty() ) {
            resultVo.setResult(1);
            return resultVo;
        }

        if (isEtcOpipionQstn == true && etcOpinionCnt == 0 ) {
            args[0] = strQstnNo;
            resultVo.setResult(-1);
            resultVo.setMessage(messageSource.getMessage("resh.error.etcOpipion.zero", args, locale));  // 라인의 문항에 기타의견 보기가 없습니다.
            return resultVo;
        }

        if (isEtcOpipionQstn == true && etcOpinionCnt > 1 ) {
            args[0] = strQstnNo;
            resultVo.setResult(-1);
            resultVo.setMessage(messageSource.getMessage("resh.error.etcOpipion.tooMany", args, locale));   // 라인의 문항에 기타의견 보기는 1개만 등록 할 수 있습니다.
            return resultVo;
        }


        //2. 기등록되어 있는 모든 문항을 삭제처리하다.(삭제 후 엑셀업로드)
        //2.1 설문 페이지 리스트 조회
        List<ReshPageVO> reshPageList = reshQstnDAO.listReshPage(vo);

        //2.2. 페이지 단위로 삭제
        if (reshPageList != null && !reshPageList.isEmpty() && reshPageList.size() > 0 ) {
            for(ReshPageVO reshPageVO : reshPageList) {

                //2.2.1. 척도 등급 삭제
                ReshScaleVO paramScaleVO = new ReshScaleVO();
                paramScaleVO.setReschPageCd(reshPageVO.getReschPageCd());
                reshQstnDAO.delReshScale(paramScaleVO);

                //2.2.2. 문항 선택지 삭제
                ReshQstnItemVO paramQstnItemVO = new ReshQstnItemVO();
                paramQstnItemVO.setReschPageCd(reshPageVO.getReschPageCd());
                reshQstnDAO.delReshQstnItem(paramQstnItemVO);

                //2.2.3. 문항  삭제
                ReshQstnVO paramQstnVO = new ReshQstnVO();
                paramQstnVO.setReschPageCd(reshPageVO.getReschPageCd());
                reshQstnDAO.delReshQstn(paramQstnVO);

                //2.2.4. 페이지  삭제
                reshQstnDAO.delReshPage(reshPageVO);
            }
        }


        //3. 페이지 단위로 등록 처리
        ReshPageVO paramPageVO = new ReshPageVO();
        paramPageVO.setReschCd(vo.getReschCd());
        paramPageVO.setRgtrId(vo.getRgtrId());

        ReshQstnVO paramQstnVO = new ReshQstnVO();
        paramQstnVO.setRgtrId(vo.getRgtrId());
        int itemOdr = 0;
        for (int i = 0; i < qstnList.size(); i++) {
            Map<String, Object> qstnMap = (Map<String, Object>)qstnList.get(i);

            //3.1 페이지 등록
            if (qstnMap.get("A") != null && !"".equals(qstnMap.get("A").toString().trim()) ) {
                paramPageVO.setReschPageCd(pageCdConversionMap.get(qstnMap.get("A").toString().trim()).toString());
                paramPageVO.setReschPageTitle(qstnMap.get("B").toString().trim());
                paramPageVO.setReschPageArtl(qstnMap.get("C").toString().trim());
                reshQstnDAO.insertReshPage(paramPageVO);
            }

            //3.2 문항 등록
            if (qstnMap.get("D") != null && !"".equals(qstnMap.get("D").toString().trim()) ) {
                String newReshQstnCd = IdGenerator.getNewId("RSQ");
                paramQstnVO.setReschQstnCd(newReshQstnCd);
                paramQstnVO.setRgtrId(vo.getRgtrId());
                paramQstnVO.setReschPageCd(paramPageVO.getReschPageCd());
                paramQstnVO.setReschQstnTypeCd(qstnMap.get("E").toString().trim());
                paramQstnVO.setReschQstnTitle(qstnMap.get("F").toString().trim());
                paramQstnVO.setReschQstnCts(qstnMap.get("G").toString().trim());
                if ("SINGLE".equals(qstnMap.get("E").toString().trim()) || "OX".equals(qstnMap.get("E").toString().trim())) {
                    if (qstnMap.get("I") != null && "Y".equals(qstnMap.get("I").toString().trim()) ) {
                        paramQstnVO.setReqChoiceYn("Y");
                        paramQstnVO.setJumpChoiceYn(qstnMap.get("I").toString().trim());
                    } else {
                        paramQstnVO.setReqChoiceYn(qstnMap.get("H").toString().trim());
                        paramQstnVO.setJumpChoiceYn("N");
                    }
                } else {
                    paramQstnVO.setReqChoiceYn(StringUtil.nvl(qstnMap.get("H").toString().trim(), "N"));
                    paramQstnVO.setJumpChoiceYn(null);
                }

                if ("SINGLE".equals(qstnMap.get("E").toString().trim()) || "MULTI".equals(qstnMap.get("E").toString().trim())) {
                    if (qstnMap.get("J") != null && "Y".equals(qstnMap.get("J").toString().trim()) ) {
                        paramQstnVO.setEtcOpinionYn(qstnMap.get("J").toString().trim());
                    } else {
                        paramQstnVO.setEtcOpinionYn("N");
                    }
                } else {
                    paramQstnVO.setEtcOpinionYn(null);
                }

                if ("SCALE".equals(qstnMap.get("E").toString().trim()) ) {
                    String[] arrScale = qstnMap.get("K").toString().trim().split("\\,");
                    paramQstnVO.setReschScaleLvl(arrScale.length < 5?3:5);
                } else {
                    paramQstnVO.setReschScaleLvl(0);
                }

                reshQstnDAO.insertReshQstn(paramQstnVO);
                itemOdr = 0;
            }

            //3.3 문항보기(선택지) 등록
            if (qstnMap.get("L") != null && !"".equals(qstnMap.get("L").toString().trim()) ) {
                itemOdr++;
                ReshQstnItemVO paramQstnItemVO = new ReshQstnItemVO();
                String newReshQstnItemCd = IdGenerator.getNewId("RSIT");
                paramQstnItemVO.setReschQstnItemCd(newReshQstnItemCd);
                paramQstnItemVO.setReschQstnCd(paramQstnVO.getReschQstnCd());
                paramQstnItemVO.setRgtrId(vo.getRgtrId());
                paramQstnItemVO.setReschQstnItemTitle(qstnMap.get("M").toString().trim());

                if (paramQstnVO.getJumpChoiceYn() != null && "Y".equals(paramQstnVO.getJumpChoiceYn())) {
                    if ("NEXT".equals(qstnMap.get("N").toString().trim()) || "END".equals(qstnMap.get("N").toString().trim())) {
                        paramQstnItemVO.setJumpPage(qstnMap.get("N").toString().trim());
                    } else if (pageCdConversionMap.containsKey(qstnMap.get("N").toString().trim())) {
                        paramQstnItemVO.setJumpPage(pageCdConversionMap.get(qstnMap.get("N").toString().trim()).toString());
                    } else {
                        paramQstnItemVO.setJumpPage("NEXT");
                    }
                }

                paramQstnItemVO.setEtcItemYn("N");
                if (paramQstnVO.getEtcOpinionYn() != null && "Y".equals(paramQstnVO.getEtcOpinionYn())) {
                    if (qstnMap.get("O") != null && "Y".equals(qstnMap.get("O").toString().trim())) {
                        paramQstnItemVO.setEtcItemYn(qstnMap.get("O").toString().trim());
                        paramQstnItemVO.setReschQstnItemTitle("SINGLE_ETC_ITEM");
                    } 
                }

                paramQstnItemVO.setItemOdr(itemOdr);
                if (!"TEXT".equals(paramQstnVO.getReschQstnTypeCd()) ) {
                    reshQstnDAO.insertReshQstnItem(paramQstnItemVO);
                }
            }

            //3.4 척도 등록
            if ("SCALE".equals(qstnMap.get("E").toString().trim()) ) {
                String[] arrScale = qstnMap.get("K").toString().trim().split("\\,");
                int scaleOdr = 0;
                for (String scale : arrScale ) {
                    scaleOdr++;
                    String[] arrScaleItem = scale.trim().split("\\|");
                    ReshScaleVO paramScaleVO = new ReshScaleVO();
                    paramScaleVO.setReschQstnCd(paramQstnVO.getReschQstnCd());
                    paramScaleVO.setRgtrId(vo.getRgtrId());
                    String newReshQstnScaleCd = IdGenerator.getNewId("RSSC");
                    paramScaleVO.setReschScaleCd(newReshQstnScaleCd);
                    paramScaleVO.setScaleOdr(scaleOdr);
                    paramScaleVO.setScaleTitle(arrScaleItem[1].trim());
                    paramScaleVO.setScaleScore(Integer.valueOf(arrScaleItem[2].trim()));
                    reshQstnDAO.insertReshScale(paramScaleVO);
                }
            } 
        }

        resultVo.setResult(1);
        return resultVo;
    }
    
}
