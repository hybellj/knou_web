package knou.lms.sch.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sch.dao.PopupNoticeDAO;
import knou.lms.sch.service.PopupNoticeService;
import knou.lms.sch.vo.PopupNoticeVO;

@Service("popupNoticeService")
public class PopupNoticeServiceImpl extends ServiceBase implements PopupNoticeService {

    @Resource(name="popupNoticeDAO")
    private PopupNoticeDAO popupNoticeDAO;
    
    /***************************************************** 
     * 팝업공지 정보 조회
     * @param vo
     * @return PopupNoticeVO
     * @throws Exception
     ******************************************************/
    @Override
    public PopupNoticeVO select(PopupNoticeVO vo) throws Exception {
        return popupNoticeDAO.select(vo);
    }
    
    /***************************************************** 
     * 팝업공지  목록 조회
     * @param vo
     * @return List<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    public List<PopupNoticeVO> list(PopupNoticeVO vo) throws Exception {
        return popupNoticeDAO.list(vo);
    }
    
    /***************************************************** 
     * 팝업공지 페이징 목록 조회
     * @param vo
     * @return ProcessResultVO<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<PopupNoticeVO> listPaging(PopupNoticeVO vo) throws Exception {
        ProcessResultVO<PopupNoticeVO> processResultVO = new ProcessResultVO<>();
        
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        int totCnt = popupNoticeDAO.count(vo);
        
        paginationInfo.setTotalRecordCount(totCnt);
        
        List<PopupNoticeVO> resultList = popupNoticeDAO.listPaging(vo);
        
        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);
        
        return processResultVO;
    }
    
    /***************************************************** 
     * 팝업공지 상위 목록 조회
     * @param vo
     * @return List<PopupNoticeVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<PopupNoticeVO> listTop(PopupNoticeVO vo) throws Exception {
        return popupNoticeDAO.listTop(vo);
    }
    
    /***************************************************** 
     * 팝업공지 등록
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(PopupNoticeVO vo) throws Exception {
//        if(ValidationUtils.isEmpty(vo.getPopupNtcId())) {
//            throw new ServiceProcessException("");
//        }
        
        String popupNtcId = IdGenerator.getNewId("POP");
        
        vo.setPopupNtcId(popupNtcId);
        
        if("N".equals(vo.getPopupNtcTdstopUseyn())) {
            vo.setPopupNtcTdstopDayCnt(0);
        }
        
        if(ValidationUtils.isEmpty(vo.getPopupWinWdthRatio())) {
            vo.setPopupWinWdthRatio("50");
        }
        
        // TODO:세로비율은 없었어서 임시로 추가함
        if(ValidationUtils.isEmpty(vo.getPopupWinHghtRatio())) {
        	vo.setPopupWinHghtRatio("50");
        }
        
        popupNoticeDAO.insert(vo);
        popupNoticeDAO.insertPstnSize(vo);
    }   
    
    /***************************************************** 
     * 팝업공지 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void update(PopupNoticeVO vo) throws Exception {
        
        if("N".equals(vo.getPopupNtcTdstopUseyn())) {
            vo.setPopupNtcTdstopDayCnt(0);
        }
        
        if(ValidationUtils.isEmpty(vo.getPopupWinWdthRatio())) {
            vo.setPopupWinWdthRatio(null);
        }
        
        popupNoticeDAO.update(vo);
        popupNoticeDAO.updatePstnSize(vo);
    }
    
    /***************************************************** 
     * 팝업공지 사용여부 수정
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    public void updateUseYn(PopupNoticeVO vo) throws Exception {
        popupNoticeDAO.updateUseYn(vo);
    }
    
    /***************************************************** 
     * 팝업공지 삭제
     * @param vo
     * @return 
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(PopupNoticeVO vo) throws Exception {
        popupNoticeDAO.delete(vo);
    }
    
    /***************************************************** 
     * 활성 팝업공지 정보 조회
     * @param request
     * @param vo
     * @return PopupNoticeVO
     * @throws Exception
     ******************************************************/
    @Override
    public PopupNoticeVO selectAcitvePop(HttpServletRequest request, PopupNoticeVO vo) throws Exception {
        PopupNoticeVO popupNoticeVO = null;
        
        String orgId = SessionInfo.getOrgId(request);
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        List<String> popTargetCdArr = new ArrayList<>();
        
        for(String authGrpCd : userType.split("\\|")) {
            if(!"".equals(StringUtil.nvl(authGrpCd))) {
                popTargetCdArr.add(authGrpCd);
            }
        }
        
        if(popTargetCdArr.size() > 0) {
            vo.setOrgId(orgId);
            vo.setPopupNtcTrgtCdList(popTargetCdArr.toArray(new String[popTargetCdArr.size()]));
            popupNoticeVO = popupNoticeDAO.selectAcitvePop(vo);
            
            // 닫기여부 체크
            if(popupNoticeVO != null && "Y".equals(popupNoticeVO.getPopupNtcTdstopUseyn())) {
                String popNoticeSn = popupNoticeVO.getPopupNtcId();
                
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if (cookie.getName().equals(popNoticeSn) && cookie.getValue().equals("Y")) {
                            popupNoticeVO = null;
                        }
                    }
                }
            }
            
            // 세션당 1번 체크
            if(popupNoticeVO != null && "Y".equals(popupNoticeVO.getSnglSessUseyn())) {
                String popNoticeSn = popupNoticeVO.getPopupNtcId();
                String popNoticeOpenYn = SessionInfo.getPopNoticeOpenYn(request, popNoticeSn);
                
                if("Y".equals(StringUtil.nvl(popNoticeOpenYn))) {
                    popupNoticeVO = null;
                } else {
                    SessionInfo.setPopNoticeOpenYn(request, popNoticeSn);
                }
            }
        }
        
        return popupNoticeVO;
    }
}