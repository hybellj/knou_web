package knou.lms.msg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.PopupNtcDAO;
import knou.lms.msg.service.PopupNtcService;
import knou.lms.msg.vo.PopupNtcVO;

@Service("popupNtcService")
public class PopupNtcServiceImpl extends ServiceBase implements PopupNtcService {

    @Resource(name = "popupNtcDAO")
    private PopupNtcDAO popupNtcDAO;

    /*****************************************************
     * 팝업공지 목록 조회
     * @param vo
     * @return ProcessResultVO<PopupNtcVO>
     ******************************************************/
    @Override
    public ProcessResultVO<PopupNtcVO> selectPopupNtcListPage(PopupNtcVO vo) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<PopupNtcVO> list = popupNtcDAO.selectPopupNtcList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 팝업공지 단건 조회
     * @param vo
     * @return PopupNtcVO
     ******************************************************/
    @Override
    public PopupNtcVO selectPopupNtc(PopupNtcVO vo) {
        return popupNtcDAO.selectPopupNtc(vo);
    }

    /*****************************************************
     * 팝업공지 등록
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int insertPopupNtc(PopupNtcVO vo) {
        String popupNtcId = IdGenerator.getNewId(IdPrefixType.PNTC.getCode());
        vo.setPopupNtcId(popupNtcId);

        int cnt = popupNtcDAO.insertPopupNtc(vo);
        cnt += popupNtcDAO.insertPopupNtcPstnSz(vo);

        return cnt;
    }

    /*****************************************************
     * 팝업공지 수정
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updatePopupNtc(PopupNtcVO vo) {
        int cnt = popupNtcDAO.updatePopupNtc(vo);
        cnt += popupNtcDAO.updatePopupNtcPstnSz(vo);

        return cnt;
    }

    /*****************************************************
     * 팝업공지 삭제
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int deletePopupNtc(PopupNtcVO vo) {
        popupNtcDAO.deletePopupNtcPstnSz(vo);
        return popupNtcDAO.deletePopupNtc(vo);
    }

    /*****************************************************
     * 팝업공지 전시여부 변경
     * @param vo
     * @return int
     ******************************************************/
    @Override
    public int updatePopupNtcUseyn(PopupNtcVO vo) {
        return popupNtcDAO.updatePopupNtcUseyn(vo);
    }

    /*****************************************************
     * 기관 목록 조회
     * @param vo
     * @return List<PopupNtcVO>
     ******************************************************/
    @Override
    public List<PopupNtcVO> selectOrgList(PopupNtcVO vo) {
        return popupNtcDAO.selectOrgList(vo);
    }
}
