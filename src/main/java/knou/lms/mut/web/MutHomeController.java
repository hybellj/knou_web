package knou.lms.mut.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.mut.service.MutEvalRltnService;
import knou.lms.mut.service.MutEvalService;
import knou.lms.mut.vo.MutEvalRltnVO;
import knou.lms.mut.vo.MutEvalVO;

@Controller
@RequestMapping(value={"/mut/mutHome","/mut/mutLect","/mut/mutPop"})
public class MutHomeController extends ControllerBase {

    @Resource(name="mutEvalService")
    private MutEvalService mutEvalService;

    @Resource(name="mutEvalRltnService")
    private MutEvalRltnService mutEvalRltnService;

    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;

    // 기본루브릭 화면
    @RequestMapping(value="/listView")
    public String listView(HttpServletRequest request, HttpServletResponse response, ModelMap model, MutEvalRltnVO vo) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        request.setAttribute("vo", vo);

        return "mut/mut_eval_list";
    }

    // 조회
    @RequestMapping(value = "/getMut.do")
    @ResponseBody
    public ProcessResultVO<MutEvalVO> getMut(HttpServletRequest request, HttpServletResponse response, ModelMap model, MutEvalVO vo) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        return mutEvalService.selectMut(vo);
    }

    // 사용여부 수정
    @RequestMapping(value="/edtUseYn" )
    @ResponseBody
    public ProcessResultVO<MutEvalVO> edtUseYn(HttpServletRequest request, HttpServletResponse response, ModelMap model, MutEvalVO vo) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        return mutEvalService.updateUseYn(vo);
    }

    // 삭제
    @RequestMapping(value="/edtDelYn" )
    @ResponseBody
    public ProcessResultVO<MutEvalVO> edtDelYn(HttpServletRequest request, HttpServletResponse response, ModelMap model, MutEvalVO vo) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        vo.setUserId(SessionInfo.getUserId(request));
        return mutEvalService.updateDelYn(vo);
    }

    // 등록화면
    @RequestMapping(value="/writeView")
    public String writeView(MutEvalVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        vo.setSelectType("LIST");
        request.setAttribute("vo", vo);
        request.setAttribute("evalList", mutEvalService.selectMut(vo).getReturnList());
        request.setAttribute("orgId", SessionInfo.getOrgId(request));
        request.setAttribute("menuType", "ADM");
        request.setAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "mut/mut_eval_write";
    }

    // 등록
    @RequestMapping(value="/regEvalQstn.do")
    @ResponseBody
    public ProcessResultVO<MutEvalVO> regEvalQstn(MutEvalVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();
        vo.setUserId(SessionInfo.getUserId(request));

        try {
            resultVO = mutEvalService.regEvalQstn(request, vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }


    /*****************************************************
     * TODO 평가 기준 등록 팝업
     * @param  MutEvalRltnVO
     * @return "mut/popup/mut_eval_write_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/mutEvalWritePop.do")
    public String examListForm(MutEvalRltnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_ETC);
        
        vo.setUserId(SessionInfo.getUserId(request));

        List<MutEvalVO> evalList = mutEvalService.selectRegList(vo);
        request.setAttribute("evalList", evalList);

        if(!"".equals(StringUtil.nvl(vo.getRltnCd()))) {
            vo.setEvalDivCd("PROFESSOR_EVAL");
            vo = mutEvalRltnService.selectMutEvalRltn(vo);

        }
        request.setAttribute("vo", vo);

        return "mut/popup/mut_eval_write_pop";
    }


}
