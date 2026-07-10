package knou.lms.msg.web;

import knou.framework.common.ControllerBase;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.service.PopupNtcService;
import knou.lms.msg.vo.PopupNtcVO;
import knou.lms.user.CurrentUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
public class PopupNtcController extends ControllerBase {

    @Resource(name = "popupNtcService")
    private PopupNtcService popupNtcService;

    /*****************************************************
     * 팝업공지 목록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/popup_ntc_list_view"
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcListView.do")
    public String popupNtcListView(PopupNtcVO vo, @CurrentUser UserContext userCtx, ModelMap model) {

        model.addAttribute("orgList", popupNtcService.selectOrgList(vo));
        model.addAttribute("vo", vo);

        return "msg/popup_ntc_list_view";
    }

    /*****************************************************
     * 팝업공지 목록 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<PopupNtcVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcListAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcListAjax(PopupNtcVO vo, @CurrentUser UserContext userCtx) throws Exception {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        resultVO = popupNtcService.selectPopupNtcListPage(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 팝업공지 상세보기 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/popup_ntc_select_view"
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcSelectView.do")
    public String popupNtcSelectView(PopupNtcVO vo, @CurrentUser UserContext userCtx, ModelMap model) {
        PopupNtcVO detailVO = popupNtcService.selectPopupNtc(vo);

        model.addAttribute("detailVO", detailVO);
        model.addAttribute("vo", vo);

        return "msg/popup_ntc_select_view";
    }

    /*****************************************************
     * 팝업공지 등록 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/popup_ntc_regist_view"
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcRegistView.do")
    public String popupNtcRegistView(PopupNtcVO vo, @CurrentUser UserContext userCtx, ModelMap model) {

        model.addAttribute("mode", "regist");
        model.addAttribute("vo", vo);

        return "msg/popup_ntc_regist_view";
    }

    /*****************************************************
     * 팝업공지 수정 화면
     * @param vo
     * @param userCtx
     * @param model
     * @return "msg/popup_ntc_regist_view"
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcModifyView.do")
    public String popupNtcModifyView(PopupNtcVO vo, @CurrentUser UserContext userCtx, ModelMap model) {

        PopupNtcVO detailVO = popupNtcService.selectPopupNtc(vo);

        model.addAttribute("detailVO", detailVO);
        model.addAttribute("mode", "modify");
        model.addAttribute("vo", vo);

        return "msg/popup_ntc_regist_view";
    }

    /*****************************************************
     * 팝업공지 등록
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<PopupNtcVO>
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcRegistAjax(PopupNtcVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();
        vo.setOrgId(userCtx.getOrgId());
        vo.setRgtrId(userCtx.getUserId());

        popupNtcService.insertPopupNtc(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 팝업공지 수정
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<PopupNtcVO>
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcModifyAjax(PopupNtcVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        vo.setMdfrId(userCtx.getUserId());

        popupNtcService.updatePopupNtc(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 팝업공지 삭제
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<PopupNtcVO>
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcDeleteAjax(PopupNtcVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        if (vo.getPopupNtcId() == null || vo.getPopupNtcId().isEmpty()) {
            resultVO.setResult(ProcessResultVO.RESULT_FAIL);
            resultVO.setMessage(getMessage("common.item.select.msg"));
            return resultVO;
        }

        popupNtcService.deletePopupNtc(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 팝업공지 전시여부 변경
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<PopupNtcVO>
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcUseynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcUseynModifyAjax(PopupNtcVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        vo.setMdfrId(userCtx.getUserId());

        popupNtcService.updatePopupNtcUseyn(vo);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }

    /*****************************************************
     * 팝업공지 단건 조회
     * @param vo
     * @param userCtx
     * @return ProcessResultVO<PopupNtcVO>
     ******************************************************/
    @RequestMapping(value = "/admPopupNtcSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<PopupNtcVO> popupNtcSelectAjax(PopupNtcVO vo, @CurrentUser UserContext userCtx) {
        ProcessResultVO<PopupNtcVO> resultVO = new ProcessResultVO<>();

        PopupNtcVO result = popupNtcService.selectPopupNtc(vo);
        resultVO.setReturnVO(result);
        resultVO.setResult(ProcessResultVO.RESULT_SUCC);
        resultVO.setEncParams(getEncParams());

        return resultVO;
    }
}
