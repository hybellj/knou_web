package knou.lms.msg.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.msg.vo.PopupNtcVO;

@Mapper("popupNtcDAO")
public interface PopupNtcDAO {

    List<PopupNtcVO> selectPopupNtcList(PopupNtcVO vo);

    PopupNtcVO selectPopupNtc(PopupNtcVO vo);

    int insertPopupNtc(PopupNtcVO vo);

    int insertPopupNtcPstnSz(PopupNtcVO vo);

    int updatePopupNtc(PopupNtcVO vo);

    int updatePopupNtcPstnSz(PopupNtcVO vo);

    int updatePopupNtcUseyn(PopupNtcVO vo);

    int deletePopupNtcPstnSz(PopupNtcVO vo);

    int deletePopupNtc(PopupNtcVO vo);

    List<PopupNtcVO> selectOrgList(PopupNtcVO vo);
}
