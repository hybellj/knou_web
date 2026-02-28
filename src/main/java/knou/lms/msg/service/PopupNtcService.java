package knou.lms.msg.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.vo.PopupNtcVO;

public interface PopupNtcService {

    ProcessResultVO<PopupNtcVO> selectPopupNtcListPage(PopupNtcVO vo);

    PopupNtcVO selectPopupNtc(PopupNtcVO vo);

    int registPopupNtc(PopupNtcVO vo);

    int modifyPopupNtc(PopupNtcVO vo);

    int deletePopupNtc(PopupNtcVO vo);

    int modifyPopupNtcUseyn(PopupNtcVO vo);

    List<PopupNtcVO> selectOrgList(PopupNtcVO vo);
}
