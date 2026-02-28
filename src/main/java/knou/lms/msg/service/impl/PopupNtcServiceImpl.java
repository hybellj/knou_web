package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.PopupNtcDAO;
import knou.lms.msg.service.PopupNtcService;
import knou.lms.msg.vo.PopupNtcVO;

@Service("popupNtcService")
public class PopupNtcServiceImpl implements PopupNtcService {

    @Resource(name = "popupNtcDAO")
    private PopupNtcDAO popupNtcDAO;

    /**
     * 팝업공지 목록 조회 (페이징)
     * @param vo
     * @return
     */
    @Override
    public ProcessResultVO<PopupNtcVO> selectPopupNtcListPage(PopupNtcVO vo) {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex() + 1);
        vo.setLastIndex(paginationInfo.getFirstRecordIndex() + vo.getListScale());

        int totalCnt = popupNtcDAO.selectPopupNtcCnt(vo);
        paginationInfo.setTotalRecordCount(totalCnt);

        List<PopupNtcVO> list = popupNtcDAO.selectPopupNtcList(vo);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
    }

    /**
     * 팝업공지 단건 조회
     * @param vo
     * @return
     */
    @Override
    public PopupNtcVO selectPopupNtc(PopupNtcVO vo) {
        return popupNtcDAO.selectPopupNtc(vo);
    }

    /**
     * 팝업공지 등록
     * @param vo
     * @return
     */
    @Override
    public int registPopupNtc(PopupNtcVO vo) {
        String popupNtcId = IdGenerator.getNewId(IdPrefixType.PNTC.getCode());
        vo.setPopupNtcId(popupNtcId);

        int cnt = popupNtcDAO.registPopupNtc(vo);
        cnt += popupNtcDAO.registPopupNtcPstnSize(vo);

        return cnt;
    }

    /**
     * 팝업공지 수정
     * @param vo
     * @return
     */
    @Override
    public int modifyPopupNtc(PopupNtcVO vo) {
        int cnt = popupNtcDAO.modifyPopupNtc(vo);
        cnt += popupNtcDAO.modifyPopupNtcPstnSize(vo);

        return cnt;
    }

    /**
     * 팝업공지 삭제
     * @param vo
     * @return
     */
    @Override
    public int deletePopupNtc(PopupNtcVO vo) {
        popupNtcDAO.deletePopupNtcPstnSize(vo);
        return popupNtcDAO.deletePopupNtc(vo);
    }

    /**
     * 팝업공지 전시여부 변경
     * @param vo
     * @return
     */
    @Override
    public int modifyPopupNtcUseyn(PopupNtcVO vo) {
        return popupNtcDAO.modifyPopupNtcUseyn(vo);
    }

    /**
     * 기관 목록 조회
     * @param vo
     * @return
     */
    @Override
    public List<PopupNtcVO> selectOrgList(PopupNtcVO vo) {
        return popupNtcDAO.selectOrgList(vo);
    }
}
