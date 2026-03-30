package knou.lms.crs.sbjct.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.crs.sbjct.vo.DgrsYrChrtVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctUseYnUpdateVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.subject.vo.SubjectVO;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping(value="/crs/sbjct")
public class SbjctController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(SbjctController.class);

    @Resource(name="sbjctService")
    private SbjctService sbjctService;

    @Autowired
    @Qualifier("orgInfoService")
    private OrgInfoService orgInfoService;

    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;

    @Resource(name="subjectService")
    private SubjectService subjectService;

    /**
     * 과목 등록 > 목록 화면
     *
     * @param searchVo
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/adminSbjctListView.do")
    public String adminSbjctListView(SbjctVO searchVo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String orgNm = SessionInfo.getOrgNm(request);

        List<OrgInfoVO> orgList = orgInfoService.listActiveOrg();

        List<DgrsYrChrtVO> dgrsYrChrtList = sbjctService.selectDgrsYrChrtList(orgId);

        model.addAttribute("orgList", orgList);
        model.addAttribute("dgrsYrChrtList", dgrsYrChrtList);

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/sbjct/admin_sbjct_list_view";
    }

    /**
     * 과목분류목록을 조회한다.
     *
     * @param CmmnCdVO 년도/학기(기수) 조회 정보
     * @return 코드 목록
     * @throws Exception
     */
    @RequestMapping("/adminSbjctTyCdList.do")
    @ResponseBody
    public ProcessResultVO<CmmnCdVO> adminSbjctTyCdList(CmmnCdVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<CmmnCdVO> resultVO = new ProcessResultVO<>();
        String orgId = StringUtil.nvl(vo.getOrgId(), SessionInfo.getOrgId(request));

        try {
            vo.setOrgId(orgId);
            List<CmmnCdVO> sbjctTycdList = cmmnCdService.listCode(orgId, "SBJCT_TYCD").getReturnList();        // 학기유형코드 조회
            sbjctTycdList.removeIf(item -> item.getCdSeqno() == 0);
            resultVO.setReturnList(sbjctTycdList);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage());/* 에러가 발생했습니다! */
        }
        return resultVO;
    }

    /**
     * 과목목록조회
     *
     * @param SbjctListVO 목록검색조건
     * @return 코드 목록
     * @throws Exception
     */
    @RequestMapping(value="/adminSbjctList.do")
    @ResponseBody
    public ProcessResultVO<SbjctListVO> adminSbjctList(SbjctListVO sbjctListVO, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SbjctListVO> resultVO = new ProcessResultVO<>();

        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        try {
            sbjctListVO.setOrgId(orgId);

            // TODO : Validation check.
            resultVO = sbjctService.selectSbjctList(sbjctListVO);
            resultVO.setResultSuccess();
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResultFailed();
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /**
     * 과목등록화면
     *
     * @param SbjctVO 과목등록정보
     * @return 코드 목록
     * @throws Exception
     */
    @RequestMapping(value="/adminSbjctWriteView.do")
    public String adminSbjctWriteView(SbjctVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        /*CreCrsVO vo1 = new CreCrsVO();

        vo1.setOrgId(SessionInfo.getOrgId(request));

        List<OrgCodeVO> orgList = crsService.selectOrgCodeList(vo1);

        model.addAttribute("orgList", orgList);

        CrsVO crsVo = new CrsVO();
        crsVo = crsService.selectCrsInfo(vo);
        if(crsVo != null) {
            crsVo.setGubun("E");
            model.addAttribute("crsVo", crsVo);

        } else {
            vo.setGubun("A");
            model.addAttribute("crsVo", vo);
        }

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));*/
        return "crs/sbjct/admin_sbjct_write_view";
    }

    /**
     * 과목목록사용여부수정
     *
     * @param SbjctUseYnUpdateVO 과목수정정보
     * @return 코드 목록
     * @throws Exception
     */
    @RequestMapping(value="/sbjctListUseYnModify.do")
    @ResponseBody
    public ProcessResultVO<SbjctUseYnUpdateVO> sbjctListUseYnModify(SbjctListVO sbjctListVO) throws Exception {
        ProcessResultVO<SbjctUseYnUpdateVO> resultVO = new ProcessResultVO<>();

        try {
            sbjctService.updateSbjctUseYn(sbjctListVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }
        return resultVO;
    }

    /**
     * 과목목록삭제
     *
     * @param sbjctListVO 과목삭제정보
     * @return 코드 목록
     * @throws Exception
     */
    @RequestMapping(value="/sbjctListDelete.do")
    @ResponseBody
    public ProcessResultVO<Integer> sbjctListDelete(SbjctListVO sbjctListVO) throws Exception {
        ProcessResultVO<Integer> vo = new ProcessResultVO<Integer>();

        /*int delCnt = sbjctService.deleteSbjct(sbjctListVO);

        vo.setOk(delCnt > 0);
        vo.setMessage(delCnt > 0 ? "정상 처리되었습니다." : "처리 대상이 없습니다.");
        vo.setData(Integer.valueOf(delCnt));
        vo.setTotal(delCnt);*/
        return vo;
    }


    /**
     * 과목 정보 조회
     * @param sbjctId
     * @return
     * @throws Exception
     */
    @RequestMapping("/sbjctMrkProcPeriodSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> sbjctMrkProcPeriodSelectAjax(@RequestParam("sbjctId") String sbjctId) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        SubjectVO sbjctVO = subjectService.subjectSelect(sbjctId);

        if (ValidationUtils.isNull(sbjctVO)) {
            resultVO.setResultFailed(getMessage("exam.error.not.exists.crs"));
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime sDttm = LocalDateTime.parse(sbjctVO.getMrkProcSdttm(), formatter);
        LocalDateTime eDttm = LocalDateTime.parse(sbjctVO.getMrkProcEdttm(), formatter);

        String isMrkProcPeriod = (now.compareTo(sDttm) >= 0 && eDttm.compareTo(now) >= 0) ? "Y" : "N";
        String mrkProcSdttm = sDttm.format(formatter);
        String mrkProcEdttm = eDttm.format(formatter);

        EgovMap map = new EgovMap();
        map.put("mrkProcSdttm", mrkProcSdttm);
        map.put("mrkProcEdttm", mrkProcEdttm);
        map.put("isMrkProcPeriod", isMrkProcPeriod);

        resultVO.setReturnVO(map);
        resultVO.setResultSuccess();

        return resultVO;
    }
}
