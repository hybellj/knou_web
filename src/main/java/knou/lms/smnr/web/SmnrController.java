package knou.lms.smnr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.RepoInfo;
import knou.framework.common.SessionInfo;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.smnr.facade.SmnrFacadeService;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrMainView;

@Controller
@RequestMapping(value="/smnr")
public class SmnrController extends ControllerBase {

	@Resource(name="smnrFacadeService")
	private SmnrFacadeService smnrFacadeService;

	/**
     * 교수세미나목록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_smnr_list_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSmnrListView.do")
    public String profSmnrListView(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	String userId = StringUtil.nvl(SessionInfo.getUserId(request));
    	String sbjctId = vo.getSbjctId() == null ? "SBJCT_OFRNG_ID1" : vo.getSbjctId();
    	model.addAttribute("userId", userId);
        model.addAttribute("sbjctId", sbjctId);    // 과목아이디
        model.addAttribute("menuTycd", "PROF");

        return "smnr/prof_smnr_list_view";
    }

    /**
     * 교수세미나목록조회
     *
     * @param sbjctId     과목아이디
     * @param searchValue 검색어 ( 세미나명 )
     * @return 교수 세미나목록
     * @throws Exception
     */
    @RequestMapping(value="/profSmnrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profSmnrListAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
            resultVO = smnrFacadeService.getProfSmnrList(vo).getProfSmnrList();
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수세미나등록화면
     *
     * @param sbjctId 과목아이디
     * @return prof_smnr_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSmnrRegistView.do")
    public String profSmnrRegistView(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrRegistView(vo);
    	model.addAttribute("subjectVO", smnrMainView.getSubjectVO());
    	EgovMap map = new EgovMap();
        map.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR));	// 첨부파일저장소 설정
        map.put("sbjctId", vo.getSbjctId());
        model.addAttribute("vo", map);

        model.addAttribute("menuTycd", "PROF");

        return "smnr/prof_smnr_regist_view";
    }

    /**
     * 세미나등록
     *
     * @param SmnrVO 				세미나정보
     * @param subSmnrsStr 			학습그룹부과제정보
     * @param lrnGrpIds 			학습그룹아이디:과목아이디목록
     * @param byteamSubsmnrUseyns 	팀별부세미나사용여부:과목아이디목록
     * @return ProcessResultVO<SmnrVO>
     * @throws Exception
     */
    @RequestMapping(value="/smnrRegistAjax.do")
    @ResponseBody
    public ProcessResultVO<SmnrVO> srvyRegistAjax(SmnrVO vo, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSmnrs", defaultValue="[]") String subSmnrsStr
    		, @RequestParam(value="lrnGrpIds", defaultValue="[]") String lrnGrpIds
    		) throws Exception {

        ProcessResultVO<SmnrVO> resultVO = new ProcessResultVO<SmnrVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);

            Map<String, String> subMap = new HashMap<>();
            subMap.put("subSmnrsStr", subSmnrsStr);
            subMap.put("lrnGrpIds", lrnGrpIds);
            smnrFacadeService.smnrRegist(vo, subMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("저장 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 교수세미나수정화면
     *
     * @param smnrId 	세미나아이디
     * @param sbjctId	과목아이디
     * @return prof_smnr_regist_view.jsp
     * @throws Exception
     */
    @RequestMapping(value="/profSmnrModifyView.do")
    public String profSmnrModifyView(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	SmnrMainView smnrMainView = smnrFacadeService.loadProfSmnrModifyView(vo);
    	EgovMap smnrEgovMap = smnrMainView.getSmnrEgovMap();
    	smnrEgovMap.put("uploadPath", RepoInfo.getAtflRepo(request, CommConst.REPO_SMNR, (String) smnrEgovMap.get("smnrId")));	// 첨부파일저장소 설정
        model.addAttribute("vo", smnrEgovMap);
    	model.addAttribute("subjectVO", smnrMainView.getSubjectVO());
        model.addAttribute("menuTycd", "PROF");

        return "smnr/prof_smnr_regist_view";
    }

    /**
     * 세미나수정
     *
     * @param SmnrVO 				세미나정보
     * @param subSmnrsStr 			학습그룹부과제정보
     * @param lrnGrpIds 			학습그룹아이디:과목아이디목록
     * @param byteamSubsmnrUseyns 	팀별부세미나사용여부:과목아이디목록
     * @return ProcessResultVO<SmnrVO>
     * @throws Exception
     */
    @RequestMapping(value="/smnrModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SmnrVO> smnrModifyAjax(SmnrVO vo, ModelMap model, HttpServletRequest request
    		, @RequestParam(value="subSmnrs", defaultValue="[]") String subSmnrsStr
    		, @RequestParam(value="lrnGrpIds", defaultValue="[]") String lrnGrpIds
    		) throws Exception {

        ProcessResultVO<SmnrVO> resultVO = new ProcessResultVO<SmnrVO>();

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
            if(ValidationUtils.isEmpty(userId)) {
                throw new BadRequestUrlException("시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.");
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);

            Map<String, String> subMap = new HashMap<>();
            subMap.put("subSmnrsStr", subSmnrsStr);
            subMap.put("lrnGrpIds", lrnGrpIds);
            subMap.put("meetngrmId", request.getParameter("meetngrmId"));
            smnrFacadeService.smnrModify(vo, subMap);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 세미나삭제
     *
     * @param sbjctId   과목아이디
     * @param smnrId 	세미나아이디
     * @return ProcessResultVO<SmnrVO>
     * @throws Exception
     */
    @RequestMapping(value="/smnrDeleteAjax.do")
    @ResponseBody
    public ProcessResultVO<SmnrVO> srvyDeleteAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
    	ProcessResultVO<SmnrVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
        	vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            smnrFacadeService.smnrDelete(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("삭제 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

    /**
     * 세미나학습그룹부세미나목록조회
     *
     * @param lrnGrpId  학습그룹아이디
     * @param smnrId	세미나아이디
     * @return 세미나학습그룹부세미나목록
     * @throws Exception
     */
    @RequestMapping(value="/smnrLrnGrpSubSmnrListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> smnrLrnGrpSubSmnrListAjax(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception {

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

        try {
        	SmnrMainView smnrMainView = smnrFacadeService.getSmnrLrnGrpSubSmnrList(params);
            resultVO.setReturnList(smnrMainView.getSmnrLrnGrpSubSmnrList());
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("리스트 조회 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 세미나성적공개여부수정
     *
     * @param smnrId	세미나아이디
     * @param mrkOyn    성적공개여부
     * @throws Exception
     */
    @RequestMapping(value="/smnrMrkOynModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SmnrVO> smnrMrkOynModifyAjax(SmnrVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SmnrVO> resultVO = new ProcessResultVO<SmnrVO>();

        try {
            vo.setMdfrId(userId);
            smnrFacadeService.smnrDtlModify(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

    /**
     * 세미나성적반영비율수정
     *
     * @param smnrId	세미나아이디
     * @param mrkRfltrt 성적반영비율
     * @throws Exception
     */
    @RequestMapping(value="/smnrMrkRfltrtModifyAjax.do")
    @ResponseBody
    public ProcessResultVO<SmnrVO> smnrMrkRfltrtModifyAjax(@RequestBody List<SmnrVO> list, ModelMap model, HttpServletRequest request) throws Exception {

        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<SmnrVO> resultVO = new ProcessResultVO<SmnrVO>();

        try {
            for(SmnrVO vo : list) {
                vo.setMdfrId(userId);
            }
            smnrFacadeService.smnrMrkRfltrtListModify(list);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정 중 에러가 발생하였습니다.");
        }
        return resultVO;
    }

}
