package knou.lms.resh.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.resh.dao.ReshAnsrDAO;
import knou.lms.resh.dao.ReshDAO;
import knou.lms.resh.dao.ReshQstnDAO;
import knou.lms.resh.service.ReshService;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnItemVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshScaleVO;
import knou.lms.resh.vo.ReshVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;

@Service("reshService")
public class ReshServiceImpl extends ServiceBase implements ReshService {

    @Resource(name="reshDAO")
    private ReshDAO reshDAO;
    
    @Resource(name="reshQstnDAO")
    private ReshQstnDAO reshQstnDAO;
    
    @Resource(name="reshAnsrDAO")
    private ReshAnsrDAO reshAnsrDAO;
    
    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;
    
    @Resource(name="stdDAO")
    private StdDAO stdDAO;
    
    @Autowired
    private SysFileService sysFileService;

    /*****************************************************
     * <p>
     * TODO 설문 정보 조회
     * </p>
     * 설문 정보 조회
     * 
     * @param ReshVO
     * @return ReshVO
     * @throws Exception
     ******************************************************/
    @Override
    public ReshVO select(ReshVO vo) throws Exception {
        vo = reshDAO.select(vo);
        if(vo != null) {
            List<FileVO> fileList = new ArrayList<FileVO>();
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("RESH");
            fileVO.setFileBindDataSn(vo.getReschCd());
            fileList = sysFileService.list(fileVO).getReturnList();
            vo.setFileList(fileList);
        }
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 설문 목록 조회
     * </p>
     * 설문 목록 조회
     * 
     * @param ReshVO
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshVO> list(ReshVO vo) throws Exception {
        return reshDAO.list(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 목록 조회 페이징
     * </p>
     * 설문 목록 조회 페이징
     * 
     * @param ReshVO
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ReshVO> listPaging(ReshVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ReshVO> reshList = reshDAO.listPaging(vo);
        
        if(reshList.size() > 0) {
            paginationInfo.setTotalRecordCount(reshList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ReshVO> returnVO = new ProcessResultVO<ReshVO>();
        
        returnVO.setReturnList(reshList);
        returnVO.setPageInfo(paginationInfo);
        
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 개수 조회
     * </p>
     * 설문 개수 조회
     * 
     * @param ReshVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int count(ReshVO vo) throws Exception {
        return reshDAO.count(vo);
    }

    /*****************************************************
     * <p>
     * TODO 내 강의에 등록된 설문 목록 조회
     * </p>
     * 내 강의에 등록된 설문 목록 조회
     * 
     * @param ReshVO
     * @return List<ReshVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<ReshVO> listMyCreCrsResh(ReshVO vo) throws Exception {
        return reshDAO.listMyCreCrsResh(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 내 강의에 등록된 설문 목록 조회 페이징
     * </p>
     * 내 강의에 등록된 설문 목록 조회 페이징
     * 
     * @param ReshVO
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<ReshVO> listMyCreCrsReshPaging(ReshVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ReshVO> reshList = reshDAO.listMyCreCrsReshPaging(vo);
        ProcessResultVO<ReshVO> returnVO = new ProcessResultVO<ReshVO>();
        
        if(reshList.size() > 0) {
            paginationInfo.setTotalRecordCount(reshList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        returnVO.setReturnList(reshList);
        returnVO.setPageInfo(paginationInfo);
        
        return returnVO;
    }

    /*****************************************************
     * <p>
     * TODO 설문 등록
     * </p>
     * 설문 등록
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public ReshVO insertResh(ReshVO vo) throws Exception {
        
        // 성적 조회 연동 설정을 한 경우 다른 설문에 이미 설정되어 있는지 검사
        // (과목당 하나의 설문만 가능)
        if("Y".equals(vo.getScoreViewYn())) {
            int scoreViewReshCnt = reshDAO.selectScoreViewReshCount(vo);
            if(scoreViewReshCnt > 0) {
                vo.setScoreViewYn("N");
            }
        }
        
        if(vo.getCrsCreCds().size() > 1) {
            vo.setDeclsRegYn("Y");
        } else {
            vo.setDeclsRegYn("N");
        }
        
        String reschCd = IdGenerator.getNewId("RESH");
        vo.setReschCd(reschCd);
        vo.setDelYn("N");
        if(vo.getUseYn() == null || "".equals(vo.getUseYn())) {
            vo.setUseYn("Y");
        }
        String grpCd = IdGenerator.getNewId("GRP");
        vo.setGrpCd(grpCd);
        
        // 설문 등록
        reshDAO.insertResh(vo);
        reshDAO.insertReshCreCrsRltn(vo);
        // 수강생 설문 참여 기록 생성
        insertReshJoinUser(vo);
        // 설문 성적 반영 비율 계산
        setScoreRatio(vo);
        
        // 성적 조회 설문 정보 등록
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsDAO.selectCreCrs(creCrsVO);
        if("Y".equals(vo.getScoreViewYn())) {
            creCrsVO.setMdfrId(vo.getMdfrId());
            creCrsVO.setScoreViewReschYn("Y");
            creCrsVO.setScoreViewReschCd(vo.getReschCd());
            crecrsDAO.update(creCrsVO);
        }
        
        // 설문 복사
        if("Y".equals(vo.getItemCopyYn())) {
            ReshPageVO pageVO = new ReshPageVO();
            pageVO.setRgtrId(vo.getRgtrId());
            pageVO.setReschCd(vo.getReschCd());
            pageVO.setCopyReschCd(vo.getItemCopyReschCd());
            copyReshQstn(pageVO);
        }
        
        // 분반 같이 등록
        if("Y".equals(vo.getDeclsRegYn())) {
            String oriCrsCreCd = vo.getCrsCreCd();
            String oriScoreViewYn = vo.getScoreViewYn();
            for(String crsCreCd : vo.getCrsCreCds()) {
                if(!crsCreCd.equals(oriCrsCreCd)) {
                    String newReschCd = IdGenerator.getNewId("RESH");
                    vo.setReschCd(newReschCd);
                    vo.setCrsCreCd(crsCreCd);
                    vo.setScoreViewYn("N");
                    if("Y".equals(oriScoreViewYn)) {
                        int scoreViewYnCnt = reshDAO.selectScoreViewReshCount(vo);
                        if(scoreViewYnCnt == 0) {
                            vo.setScoreViewYn("Y");
                        }
                    }
                    
                    reshDAO.insertResh(vo);
                    reshDAO.insertReshCreCrsRltn(vo);
                    // 수강생 설문 참여 기록 생성
                    insertReshJoinUser(vo);
                    // 설문 성적 반영 비율 계산
                    setScoreRatio(vo);
                    
                    if("Y".equals(vo.getItemCopyYn())) {
                        ReshPageVO pageVO = new ReshPageVO();
                        pageVO.setRgtrId(vo.getRgtrId());
                        pageVO.setReschCd(vo.getReschCd());
                        pageVO.setCopyReschCd(vo.getItemCopyReschCd());
                        copyReshQstn(pageVO);
                    }
                }
            }
            vo.setCrsCreCd(oriCrsCreCd);
        }
        
        return vo;
    }
    
    /*****************************************************
     * 설문 복사
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void copyResh(ReshVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String copyReschCd = vo.getCopyReschCd();
        String rgtrId = vo.getRgtrId();
        String lineNo = vo.getLineNo();
        
        if(ValidationUtils.isEmpty(orgId) 
            || ValidationUtils.isEmpty(crsCreCd) 
            || ValidationUtils.isEmpty(copyReschCd) 
            || ValidationUtils.isEmpty(rgtrId)
            || ValidationUtils.isEmpty(lineNo)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }
        
        // 설문 복사
        String reschCd = IdGenerator.getNewId("RESH");
        
        ReshVO copyReschVO = new ReshVO();
        copyReschVO.setCopyReschCd(copyReschCd);
        copyReschVO.setReschCd(reschCd);
        copyReschVO.setCrsCreCd(crsCreCd);
        copyReschVO.setRgtrId(rgtrId);
        copyReschVO.setLineNo(lineNo);
        
        reshDAO.copyResh(copyReschVO);
        
        ReshVO reschRltnVO = new ReshVO();
        reschRltnVO.setGrpCd(IdGenerator.getNewId("GRP"));
        reschRltnVO.setCrsCreCd(crsCreCd);
        reschRltnVO.setReschCd(reschCd);
        reshDAO.insertReshCreCrsRltn(reschRltnVO);
        
        // 문항 복사
        ReshPageVO pageVO = new ReshPageVO();
        pageVO.setRgtrId(rgtrId);
        pageVO.setReschCd(reschCd);
        pageVO.setCopyReschCd(copyReschCd);
        copyReshQstn(pageVO);
        
        FileVO copyFileVO;
        copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd("RESH");
        copyFileVO.setFileBindDataSn(reschCd);
        copyFileVO.setCopyFileBindDataSn(copyReschCd);
        copyFileVO.setRgtrId(rgtrId);
        
        sysFileService.copyFileInfoFromOrigin(copyFileVO);
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 수정
     * </p>
     * 설문 수정
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public ReshVO updateResh(ReshVO vo) throws Exception {
        // 설문 정보 조회
        ReshVO reshVO = reshDAO.select(vo);
        
        // 성적 조회 연동 설정을 한 경우 다른 설문에 이미 설정되어 있는지 검사
        // (과목당 하나의 설문만 가능)
        if("Y".equals(vo.getScoreViewYn())) {
            int scoreViewReshCnt = reshDAO.selectScoreViewReshCount(vo);
            if(!"Y".equals(reshVO.getScoreViewYn()) && scoreViewReshCnt > 0) {
                vo.setScoreViewYn("N");
            }
        }
        
        vo.setDeclsRegYn(StringUtil.nvl(reshVO.getDeclsRegYn()));
        vo.setDelYn("N");
        if(vo.getUseYn() == null || "".equals(vo.getUseYn())) {
            vo.setUseYn("Y");
        }
        
        // 설문 수정
        reshDAO.updateResh(vo);
        // 설문 성적 반영 비율 계산
        setScoreRatio(vo);
        
        // 성적 조회 설문 정보 등록
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsDAO.selectCreCrs(creCrsVO);
        if("Y".equals(vo.getScoreViewYn())) {
            creCrsVO.setMdfrId(vo.getMdfrId());
            creCrsVO.setScoreViewReschYn("Y");
            creCrsVO.setScoreViewReschCd(vo.getReschCd());
        } else if("Y".equals(reshVO.getScoreViewYn())) {
            creCrsVO.setScoreViewReschYn("N");
        }
        crecrsDAO.update(creCrsVO);
        
        // 설문 복사
        if("Y".equals(vo.getItemCopyYn()) && !vo.getItemCopyReschCd().equals(reshVO.getItemCopyReschCd())) {
            ReshPageVO pageVO = new ReshPageVO();
            pageVO.setRgtrId(vo.getRgtrId());
            pageVO.setReschCd(vo.getReschCd());
            pageVO.setCopyReschCd(vo.getItemCopyReschCd());
            copyReshQstn(pageVO);
        }
        
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 설문 삭제 상태로 수정
     * </p>
     * 설문 삭제 상태로 수정
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateReshDelYn(ReshVO vo) throws Exception {
        ReshAnsrVO ansrVO = new ReshAnsrVO();
        ansrVO.setReschCd(vo.getReschCd());
        // 설문 응답 삭제
        reshAnsrDAO.delReshAnsr(ansrVO);
        // 설문 참여자 삭제
        reshAnsrDAO.delReshJoinUser(ansrVO);
        
        // 설문 강의 연결 삭제 상태 수정
        reshDAO.updateReshCreCrsRltnDelYn(vo);
        // 설문 삭제 상태 수정
        reshDAO.updateReshDelYn(vo);
        
        // 설문 성적 반영 비율 계산
        setScoreRatio(vo);
    }

    /*****************************************************
     * <p>
     * TODO 강의에 연결된 설문중에서 설문에 참여해야 성적을 조회할수 있도록 설정한 설문의 카운트
     * </p>
     * 강의에 연결된 설문중에서 설문에 참여해야 성적을 조회할수 있도록 설정한 설문의 카운트
     * 
     * @param ReshVO
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int selectScoreViewReshCount(ReshVO vo) throws Exception {

        return reshDAO.selectScoreViewReshCount(vo);
    }
    
    /*****************************************************
     * <p>
     * TODO 설문 복사
     * </p>
     * 설문 복사
     * 
     * @param ReshPageVO
     * @return void
     * @throws Exception
     ******************************************************/
    private void copyReshQstn(ReshPageVO vo) throws Exception {
        // 설문 페이지 목록 조회
        List<ReshPageVO> listReshPage = reshQstnDAO.listReshPage(vo);
        // 설문 페이지 단위 삭제
        if(listReshPage != null && !listReshPage.isEmpty() && listReshPage.size() > 0) {
            for(ReshPageVO pageVO : listReshPage) {
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
        
        ReshPageVO pageVO = new ReshPageVO();
        pageVO.setReschCd(vo.getCopyReschCd());
        // 복사할 설문 페이지 리스트 조회
        List<ReshPageVO> copyReshPageList = reshQstnDAO.listReshPage(pageVO);
        Map<String, Object> reshPageCdMap = new HashMap<String, Object>();
        if(copyReshPageList != null && !copyReshPageList.isEmpty() && copyReshPageList.size() > 0) {
            for(ReshPageVO reshPageVO : copyReshPageList) {
                reshPageCdMap.put(reshPageVO.getReschPageCd(), IdGenerator.getNewId("RSPG"));
            }
            
            // 설문 페이지 단위 복사
            for(ReshPageVO reshPageVO : copyReshPageList) {
               // 페이지 복사 문항 리스트 조회
                reshPageVO.setReschCd(vo.getReschCd());
                reshPageVO.setRgtrId(vo.getRgtrId());
                List<ReshQstnVO> copyReshQstnList = reshQstnDAO.listReshQstn(reshPageVO);
                
                // 페이지 등록
                reshPageVO.setReschPageCd(reshPageCdMap.get(reshPageVO.getReschPageCd()).toString());
                reshQstnDAO.insertReshPage(reshPageVO);
                
                // 문항 코드 생성 및 항목 조회
                if(copyReshQstnList != null && !copyReshQstnList.isEmpty() && copyReshQstnList.size() > 0) {
                    for(ReshQstnVO qstnVO : copyReshQstnList) {
                        // 문항 아이템 조회
                        List<ReshQstnItemVO> copyReshQstnItemList = reshQstnDAO.listReshQstnItem(qstnVO);
                        // 문항 척도 등급 조회
                        List<ReshScaleVO> copyReshScaleList = reshQstnDAO.listReshScale(qstnVO);
                        
                        // 문항 등록
                        String reschQstnCd = IdGenerator.getNewId("RSQ");
                        qstnVO.setReschQstnCd(reschQstnCd);
                        qstnVO.setReschPageCd(reshPageVO.getReschPageCd());
                        qstnVO.setRgtrId(vo.getRgtrId());
                        reshQstnDAO.insertReshQstn(qstnVO);
                        
                        // 문항 아이템 코드 생성
                        if(copyReshQstnItemList != null && !copyReshQstnItemList.isEmpty() && copyReshQstnItemList.size() > 0) {
                            for(ReshQstnItemVO qstnItemVO : copyReshQstnItemList) {
                                String reschQstnItemCd = IdGenerator.getNewId("RSIT");
                                qstnItemVO.setReschQstnItemCd(reschQstnItemCd);
                                qstnItemVO.setReschQstnCd(reschQstnCd);
                                qstnItemVO.setRgtrId(vo.getRgtrId());
                                if (qstnItemVO.getJumpPage() != null && !"NEXT".equals(qstnItemVO.getJumpPage()) && !"END".equals(qstnItemVO.getJumpPage())) {
                                    String jumpPageCd = "NEXT";
                                    if (reshPageCdMap.get(qstnItemVO.getJumpPage()) != null)
                                    {
                                        jumpPageCd = reshPageCdMap.get(qstnItemVO.getJumpPage()).toString();
                                    }
                                    qstnItemVO.setJumpPage(jumpPageCd);
                                }
                                // 문항 아이템 등록
                                reshQstnDAO.insertReshQstnItem(qstnItemVO);
                            }
                        }
                        
                        // 문항 척도 등급 코드 생성
                        if(copyReshScaleList != null && !copyReshScaleList.isEmpty() && copyReshScaleList.size() > 0) {
                            for(ReshScaleVO scaleVO : copyReshScaleList) {
                                String reschScaleCd = IdGenerator.getNewId("RSSC");
                                scaleVO.setReschScaleCd(reschScaleCd);
                                scaleVO.setReschQstnCd(reschQstnCd);
                                scaleVO.setRgtrId(vo.getRgtrId());
                                // 문항 척도 등급 등록
                                reshQstnDAO.insertReshScale(scaleVO);
                            }
                        }
                    }
                }
            }
        }
    }

    /*****************************************************
     * <p>
     * TODO 설문과 같이 등록된 분반 또는 다른 과목 목록 조회
     * </p>
     * 설문과 같이 등록된 분반 또는 다른 과목 목록 조회
     * 
     * @param ReshVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listReshCreCrsDecls(ReshVO vo) throws Exception {
        return reshDAO.listReshCreCrsDecls(vo);
    }

    /*****************************************************
     * <p>
     * TODO 설문 문항 출제 완료 처리
     * </p>
     * 설문 문항 출제 완료 처리
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateReschSubmitYn(ReshVO vo) throws Exception {
        String reschSubmitYn = "edit".equals(StringUtil.nvl(vo.getSearchGubun())) ? "N" : "Y";
        vo.setReschSubmitYn(reschSubmitYn);
        reshDAO.updateReschSubmitYn(vo);
    }

    /*****************************************************
     * <p>
     * 강의평가/만족도조사 설문 참여가능 여부 체크
     * </p>
     * 강의평가/만족도조사 설문 참여가능 여부 체크
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectEvalJoinCheck(ReshVO vo) throws Exception {
        return reshDAO.selectEvalJoinCheck(vo);
    }

    /*****************************************************
     * <p>
     * 홈페이지 설문 등록
     * </p>
     * 홈페이지 설문 등록
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertHomeResh(ReshVO vo) throws Exception {
        vo.setDelYn("N");
        vo.setUseYn("Y");
        vo.setDeclsRegYn("N");
        String reschCd = IdGenerator.getNewId("RESH");
        vo.setReschCd(reschCd);
        reshDAO.insertResh(vo);
        
        // 설문 복사
        if("Y".equals(vo.getItemCopyYn())) {
            ReshPageVO pageVO = new ReshPageVO();
            pageVO.setRgtrId(vo.getRgtrId());
            pageVO.setReschCd(vo.getReschCd());
            pageVO.setCopyReschCd(vo.getItemCopyReschCd());
            copyReshQstn(pageVO);
        }
    }

    /*****************************************************
     * <p>
     * 홈페이지 설문 수정
     * </p>
     * 홈페이지 설문 수정
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateHomeResh(ReshVO vo) throws Exception {
        // 설문 정보 조회
        ReshVO reshVO = reshDAO.select(vo);
        if(vo.getUseYn() == null || "".equals(vo.getUseYn())) {
            vo.setUseYn("Y");
        }
        
        // 설문 수정
        reshDAO.updateResh(vo);
        
        // 설문 복사
        if("Y".equals(vo.getItemCopyYn()) && !vo.getItemCopyReschCd().equals(reshVO.getItemCopyReschCd())) {
            ReshPageVO pageVO = new ReshPageVO();
            pageVO.setRgtrId(vo.getRgtrId());
            pageVO.setReschCd(vo.getReschCd());
            pageVO.setCopyReschCd(vo.getItemCopyReschCd());
            copyReshQstn(pageVO);
        }
    }

    /*****************************************************
     * <p>
     * 홈페이지 설문 삭제
     * </p>
     * 홈페이지 설문 삭제
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteHomeResh(ReshVO vo) throws Exception {
        ReshAnsrVO ansrVO = new ReshAnsrVO();
        ansrVO.setReschCd(vo.getReschCd());
        // 설문 응답 삭제
        reshAnsrDAO.delReshAnsr(ansrVO);
        // 설문 참여자 삭제
        reshAnsrDAO.delReshJoinUser(ansrVO);
        
        // 설문 삭제 상태 수정
        reshDAO.updateReshDelYn(vo);
    }

    /*****************************************************
     * <p>
     * 설문 성적공개여부 수정 
     * </p>
     * 설문 성적공개여부 수정 
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateScoreOpenYn(ReshVO vo) throws Exception {
        reshDAO.updateScoreOpenYn(vo);
    }

    /*****************************************************
     * <p>
     * 설문 성적 반영비율 수정
     * </p>
     * 설문 성적 반영비율 수정
     * 
     * @param ReshVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateScoreRatio(ReshVO vo) throws Exception {
        reshDAO.updateScoreRatio(vo);
    }
    
    // 수강생 설문 참여 기록 생성
    public void insertReshJoinUser(ReshVO vo) throws Exception {
        StdVO stdVO = new StdVO();
        stdVO.setCrsCreCd(vo.getCrsCreCd());
        stdVO.setPagingYn("N");
        List<StdVO> stdList = stdDAO.stdList(stdVO);
        ReshAnsrVO ansrVO = new ReshAnsrVO();
        ansrVO.setReschCd(vo.getReschCd());
        ansrVO.setEvalYn("N");
        ansrVO.setRgtrId(vo.getRgtrId());
        ansrVO.setMdfrId(vo.getMdfrId());
        for(StdVO svo : stdList) {
            ansrVO.setUserId(svo.getUserId());
            ansrVO.setStdId(svo.getStdId());
            reshAnsrDAO.insertReshJoinUser(ansrVO);
        }
    }
    
    // 설문 성적 비율 자동 계산
    public void setScoreRatio(ReshVO vo) throws Exception {
        List<ReshVO> reshList = reshDAO.listReshScoreAply(vo);
        if(reshList.size() > 0) {
            int total = 100;
            int scoreRatio = (int)(total / reshList.size());
            for(int i = 0; i < reshList.size(); i++) {
                if(i == reshList.size() - 1) {
                    scoreRatio = total;
                }
                total -= scoreRatio;
                ReshVO rvo = reshList.get(i);
                rvo.setScoreRatio(scoreRatio);
                rvo.setMdfrId(vo.getMdfrId());
                reshDAO.updateScoreRatio(rvo);
            }
        }
    }
}
