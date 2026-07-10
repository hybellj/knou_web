package knou.lms.msg.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.PopupNtcVO;

public interface PopupNtcService {

    ProcessResultVO<PopupNtcVO> selectPopupNtcListPage(PopupNtcVO vo) throws Exception;

    PopupNtcVO selectPopupNtc(PopupNtcVO vo);

    int insertPopupNtc(PopupNtcVO vo);

    int updatePopupNtc(PopupNtcVO vo);

    int deletePopupNtc(PopupNtcVO vo);

    int updatePopupNtcUseyn(PopupNtcVO vo);

    List<PopupNtcVO> selectOrgList(PopupNtcVO vo);
}
