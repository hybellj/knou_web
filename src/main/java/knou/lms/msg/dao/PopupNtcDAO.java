package knou.lms.msg.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.msg.vo.PopupNtcVO;

@Mapper("popupNtcDAO")
public interface PopupNtcDAO {

    int selectPopupNtcCnt(PopupNtcVO vo);

    List<PopupNtcVO> selectPopupNtcList(PopupNtcVO vo);

    PopupNtcVO selectPopupNtc(PopupNtcVO vo);

    int registPopupNtc(PopupNtcVO vo);

    int registPopupNtcPstnSz(PopupNtcVO vo);

    int modifyPopupNtc(PopupNtcVO vo);

    int modifyPopupNtcPstnSz(PopupNtcVO vo);

    int modifyPopupNtcUseyn(PopupNtcVO vo);

    int deletePopupNtcPstnSz(PopupNtcVO vo);

    int deletePopupNtc(PopupNtcVO vo);

    List<PopupNtcVO> selectOrgList(PopupNtcVO vo);
}
