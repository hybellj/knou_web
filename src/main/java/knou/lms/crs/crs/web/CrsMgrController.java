package knou.lms.crs.crs.web;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.*;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.service.CrsService;
import knou.lms.crs.crs.vo.CrsInfoCntsVO;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.org.dao.OrgCodeDAO;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value="/crs/crsMgr")
public class CrsMgrController extends ControllerBase {

    /**
     * 과목(과정) 정보 service
     */
    @Autowired
    @Qualifier("crsService")
    private CrsService crsService;

    @Autowired
    @Qualifier("orgCodeService")
    private OrgCodeService orgCodeService;

    @Autowired
    @Qualifier("orgCodeMemService")
    private OrgCodeMemService orgCodeMemService;

    @Autowired
    @Qualifier("termService")
    private TermService termService;

    @Autowired
    @Qualifier("orgCodeDAO")
    private OrgCodeDAO orgCodeDAO;

    private Logger logger = LoggerFactory.getLogger(getClass());

    /***************************************************** 
     * @Method Name : crsListMain
     * @Method 설명 : 학기/과목 > 과목관리
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "crs/crs_list.jsp"
     * @throws Exception
     * /crs/crsMgr/crsListMain.do
     ******************************************************/
    @RequestMapping(value="/crsListMain.do")
    public String crsListMain(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        CreCrsVO vo1 = new CreCrsVO();

        vo1.setOrgId(SessionInfo.getOrgId(request));

        List<OrgCodeVO> orgList = crsService.selectOrgCodeList(vo1);

        model.addAttribute("orgList", orgList);

        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        return "crs/crs/crs_list";
    }

    // 과목조회
    @RequestMapping(value="/selectCrsList.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> selectCrsList(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsVO vo) throws Exception {
        return crsService.selectCrsList(vo);
    }

    // 사용여부 수정
    @RequestMapping(value="/updateUseYn.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> updateUseYn(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsVO vo) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        return crsService.updateUseYn(vo);
    }

    @RequestMapping(value="/selectCrsListExcelDown.do")
    public String selectCrsListExcelDown(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "과목관리");       // 과목관리
        map.put("sheetName", "과목관리목록");   // 과목관리목록
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", crsService.selectCrsListExcelDown(vo));

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", "과목관리목록");    // 과목관리목록

        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

    // 사용여부 수정
    @RequestMapping(value="/deleteCrs.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> deleteCrs(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsVO vo) throws Exception {
        vo.setUserId(SessionInfo.getUserId(request));
        return crsService.deleteCrs(vo);
    }

    @RequestMapping(value="/crsWrites.do")
    public String crsWrites(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        CreCrsVO vo1 = new CreCrsVO();

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
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        return "crs/crs/crs_write";
    }

    // 과목명 중복 체크
    @RequestMapping(value="/selectCrsNmCheck.do")
    @ResponseBody
    public int selectCrsNmCheck(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsVO vo) throws Exception {
        return crsService.selectCrsNmCheck(vo);
    }

    // 과목명 중복 체크
    @RequestMapping(value="/multiCrs.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> multiCrs(HttpServletRequest request, HttpServletResponse response, ModelMap model, CrsVO vo) throws Exception {
        vo.setOrgId(SessionInfo.getOrgId(request));
        vo.setUserId(SessionInfo.getUserId(request));
        return crsService.multiCrs(vo);
    }

    /*******************************************************************************************************************************************************/

    /**
     * @param
     * @param commandMap
     * @return "/crs/crs/crs_list_form".jsp"
     * @throws Exception
     * @Method Name : crsListForm
     * @Method 설명 : 과정 목록 폼
     */
    @RequestMapping(value="/Form/crsListForm.do")
    public String crsListForm(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        if(!menuType.contains("ADM")) {
            throw new AccessDeniedException(getCommonNoAuthMessage());/* 페이지 접근 권한이 없습니다. */
        }

        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);

        // 과정분류
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUseYn("Y");
        orgCodeVO.setUpCd("CRS_TYPE_CD");
        orgCodeVO.setLangCd(langCd);

        /*
        List<OrgCodeVO> crsTypeList = orgCodeService.selectOrgCodeList(orgCodeVO);
        request.setAttribute("crsTypeList", crsTypeList);
        */

        // 교육 방법
        /*
        orgCodeVO.setCodeCtgrCd("LEARNING_TYPE");
        List<OrgCodeVO> learningTypeList =  orgCodeService.selectOrgCodeList(orgCodeVO);
        request.setAttribute("learningTypeList", learningTypeList);
        */

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crs/crs_info_list_form";
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return "/crs/crs/crs_writeForm".jsp"
     * @throws Exception
     * @Method Name : /crsList
     * @Method 설명 : 과정 목록
     */
    @RequestMapping(value="/crsList.do")
    public String crsList(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        String langCd = SessionInfo.getLocaleKey(request);
        vo.setOrgId(orgId);
        vo.setLangCd(langCd);

        String crsTypeCds = vo.getCrsTypeCds();
        if(!"".equals(StringUtil.nvl(crsTypeCds))) {
            vo.setCrsTypeCdList(crsTypeCds.split(","));
        }

        ProcessResultListVO<CrsVO> resultList = new ProcessResultListVO<CrsVO>();
        resultList = crsService.crsListPageing(vo, vo.getPageIndex(), vo.getListScale(), vo.getPageScale());

        request.setAttribute("crsList", resultList.getReturnList());
        request.setAttribute("pageInfo", resultList.getPageInfo());

        return "crs/crs/crs_info_list";
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return "/crs/crs/crs_writeForm".jsp"
     * @throws Exception
     * @Method Name : editUseYn
     * @Method 설명 : 과정 목록
     */
    @RequestMapping(value="/editUseYn.do")
    public String editUseYn(CrsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userId = SessionInfo.getUserId(request);
        vo.setMdfrId(userId);

        ProcessResultVO<CrsVO> crsVo = new ProcessResultVO<CrsVO>();
        int result = 0;

        try {
            result = crsService.editUseYn(vo);
            crsVo.setResult(1);
        } catch(Exception e) {
            crsVo.setResult(-1);
        }
        return JsonUtil.responseJson(response, crsVo);
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return "/crs/crs/crs_writeForm".jsp"
     * @throws Exception
     * @Method Name : crsWriteForm
     * @Method 설명 : 과정등록
     */
    @RequestMapping(value="/Form/crsWriteForm.do")
    public String crsWriteForm(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        // 과정 조회
        ProcessResultVO<CrsVO> crsVo = new ProcessResultVO<CrsVO>();
        crsVo = crsService.viewCrs(vo);

        if(crsVo.getReturnVO() != null) {
            ((CrsVO) crsVo.getReturnVO()).setGubun("E");
            request.setAttribute("crsVo", crsVo.getReturnVO());
        } else {
            vo.setGubun("A");
            request.setAttribute("crsVo", vo);
        }

        model.addAttribute("orgId", orgId);
        model.addAttribute("menuType", "ADM");
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));

        return "crs/crs/crs_info_write_form";
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return "/crs/crs/crs_writeForm".jsp"
     * @throws Exception
     * @Method Name : crsWrite
     * @Method 설명 : 과정등록 정보 폼
     */
    @RequestMapping(value="/crsWrite.do")
    public String crsWrite(CrsVO vo, ModelMap model, HttpServletRequest request) throws Exception {

        CrsInfoCntsVO crsInfoCntsVo = new CrsInfoCntsVO();
        List<CrsInfoCntsVO> cntsInfoList = new ArrayList<CrsInfoCntsVO>();

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);
        crsInfoCntsVo.setOrgId(orgId);

        // 학기제, 기수제 초기값 설정
        if(vo.getCrsTypeCd() == null || "".equals(vo.getCrsTypeCd())) {
            vo.setCrsTypeCd("UNI");
        }

        // 타입 조회
        List<OrgCodeVO> menuTypeList = orgCodeMemService.getOrgCodeList("CRS_TYPE_CD", orgId);
        request.setAttribute("menuTypeList", menuTypeList);

        List<OrgCodeVO> crsOperCoList = orgCodeMemService.getOrgCodeList("CRS_OPER_CO_CD", orgId);
        request.setAttribute("crsOperCoList", crsOperCoList);

        List<OrgCodeVO> crsOperUniList = orgCodeMemService.getOrgCodeList("CRS_OPER_UNI_CD", orgId);
        request.setAttribute("crsOperUniList", crsOperUniList);

        ProcessResultVO<CrsVO> crsVo = new ProcessResultVO<CrsVO>();

        // 과정 조회
        crsVo = crsService.viewCrs(vo);

        // 컨텐츠 미리보기 조회
        /*
        if(crsVo.getReturnVO() != null) {
            if(!"".equals(StringUtil.nvl(((CrsVO) crsVo.getReturnVO()).getCrsCd(), ""))) {
                crsInfoCntsVo.setCrsCd(StringUtil.nvl(((CrsVO) crsVo.getReturnVO()).getCrsCd(), ""));
                cntsInfoList = crsService.listCrsPreview(crsInfoCntsVo);
            }
        }
        request.setAttribute("cntsInfoList", cntsInfoList);
        */

        if(crsVo.getReturnVO() == null) {
            request.setAttribute("vo", vo);
        } else {
            ((CrsVO) crsVo.getReturnVO()).setGubun("E");
            request.setAttribute("vo", crsVo.getReturnVO());
        }
        return "crs/crs/crs_info_write";
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return "/crs/crs/crs_writeForm".jsp"
     * @throws Exception
     * @Method Name : crsWriteAdd
     * @Method 설명 : 과정등록 > 과정등록
     */
    @RequestMapping(value="/crsAdd.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> crsAdd(CrsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ProcessResultVO<CrsVO> returnVO = new ProcessResultVO<>();

        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        try {
            if(vo.getCrsCd() == null || vo.getCrsCd().equals("")) {
                vo.setCrsCd(IdGenerator.getNewId("CRS"));
                crsService.add(vo);
            } else {
                crsService.edit(vo);
            }

            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getCommonFailMessage());
        }

        return returnVO;
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return "/crs/crs/crs_writeForm".jsp"
     * @throws Exception
     * @Method Name : crsWriteAdd
     * @Method 설명 : 과정등록 > 과목명 중복 체크
     */
    @RequestMapping(value="/crsEdit.do")
    @ResponseBody
    public ProcessResultVO<CrsVO> crsEdit(CrsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ProcessResultVO<CrsVO> returnVO = new ProcessResultVO<>();

        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        try {
            crsService.edit(vo);
            returnVO.setResult(1);
        } catch(Exception e) {
            returnVO.setResult(-1);
            returnVO.setMessage(getCommonFailMessage());
        }


        return returnVO;
    }

    /**
     * @param
     * @param commandMap
     * @param model
     * @return JsonUtil.responseJson
     * @throws Exception
     * @Method Name : crsWriteAdd
     * @Method 설명 : 과목 목록 > 과목 삭제
     */
    @RequestMapping(value="/removeCrs.do")
    public String removeCrs(CrsVO vo, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        ProcessResultVO<CrsVO> result = new ProcessResultVO<CrsVO>();

        try {
            crsService.remove(vo);
            result.setResult(1);
        } catch(Exception e) {
            result.setResult(-1);
        }
        return JsonUtil.responseJson(response, result);
    }

    /**
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     * @Method Name : crsListExcel
     * @Method 설명 : 과목 리스트(엑셀 다운로드)
     */
    @RequestMapping(value="/crsListExcel.do")
    public String crsListExcel(CrsVO vo, ModelMap model,
                               HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {

        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        vo.setPagingYn("N"); // 페이지 처리 안함

        String langCd = SessionInfo.getLocaleKey(request);
        vo.setLangCd(langCd);

        String orgId = SessionInfo.getOrgId(request);
        vo.setOrgId(orgId);

        String crsTypeCds = vo.getCrsTypeCds();
        if(!"".equals(StringUtil.nvl(crsTypeCds))) {
            vo.setCrsTypeCdList(crsTypeCds.split(","));
        }

        // 과목 리스트
        ProcessResultListVO<CrsVO> resultList = crsService.crsListPageing(vo, vo.getPageIndex(), vo.getListScale());

        String[] searchValues = {"검색어 : " + StringUtil.nvl(vo.getSearchValue())};

        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", "과목 목록");
        map.put("sheetName", "과목 목록");
        map.put("searchValues", searchValues);
        map.put("excelGrid", vo.getExcelGrid());

        map.put("list", resultList.getReturnList());

        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        String name = "";
        name = StringUtil.nvl("과목 목록_" + date.format(today));

        modelMap.put("outFileName", name);

        CrsExcelUtilPoi excelUtilPoi = new CrsExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }

}
