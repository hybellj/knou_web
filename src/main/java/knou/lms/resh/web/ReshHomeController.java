package knou.lms.resh.web;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.BadRequestUrlException;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.exception.SessionBrokenException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.URLBuilder;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.service.CrecrsService;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.resh.service.ReshAnsrService;
import knou.lms.resh.service.ReshQstnService;
import knou.lms.resh.service.ReshService;
import knou.lms.resh.vo.ReshAnsrVO;
import knou.lms.resh.vo.ReshPageVO;
import knou.lms.resh.vo.ReshQstnVO;
import knou.lms.resh.vo.ReshScaleVO;
import knou.lms.resh.vo.ReshVO;
import knou.lms.std.service.StdService;
import knou.lms.std.vo.StdVO;
import knou.lms.user.service.UsrUserInfoService;

@Controller
@RequestMapping(value="/resh")
public class ReshHomeController extends ControllerBase {
    
    @Resource(name="reshService")
    private ReshService reshService;
    
    @Resource(name="reshAnsrService")
    private ReshAnsrService reshAnsrService;
    
    @Resource(name="reshQstnService")
    private ReshQstnService reshQstnService;
    
    @Resource(name="crecrsService")
    private CrecrsService crecrsService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    @Resource(name="sysFileService")
    private SysFileService sysFileService;
    
    @Resource(name="usrUserInfoService")
    private UsrUserInfoService usrUserInfoService;
    
    @Resource(name="stdService")
    private StdService stdService;
    
    @Resource(name="logUserConnService")
    private LogUserConnService logUserConnService;
    
    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    /***************************************************** 
     * TODO 설문 목록 페이지 (교수)
     * @param ReshVO 
     * @return "resh/resh_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/reshList.do")
    public String reshListForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        vo.setCrsCreCd(crsCreCd);
        vo.setTotalCnt(reshService.count(vo));
        request.setAttribute("vo", vo);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "resh/resh_list";
    }
    
    /***************************************************** 
     * TODO 설문 목록 가져오기 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshList.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> reshList(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setUserId(userId);
            List<ReshVO> reshList = reshService.list(vo);
            resultVO.setReturnList(reshList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 목록 가져오기 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshListPaging.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> reshListPaging(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            resultVO = reshService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 정보 가져오기 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectReshInfo.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> selectReshInfo(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        
        try {
            ReshVO reshVO = reshService.select(vo);
            resultVO.setReturnVO(reshVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.info", null, locale));/* 설문 정보 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 미리보기 팝업 (교수)
     * @param ReshVO 
     * @return "resh/popup/resh_qstn_preview_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnPreviewPop.do")
    public String reshQstnPreviewPop(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        
        List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
        model.addAttribute("listReschPage", listReschPage);
        model.addAttribute("isHycu", true);
        return "resh/popup/resh_qstn_preview_pop";
    }

    /***************************************************** 
     * TODO 설문 등록 페이지 (교수)
     * @param ReshVO 
     * @return "resh/resh_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/writeResh.do")
    public String writeReshForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        request.setAttribute("vo", vo);
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        List<CreCrsVO> declsList = crecrsService.listCreCrsDeclsNoByTch(creCrsVO);
        request.setAttribute("declsList", declsList);
        
        int scoreViewReshCnt = reshService.selectScoreViewReshCount(vo);
        request.setAttribute("scoreViewReshCnt", scoreViewReshCnt);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        
        return "resh/resh_write";
    }
    
    /***************************************************** 
     * TODO 설문 등록 (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeResh.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> writeResh(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            resultVO.setReturnVO(reshService.insertResh(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.insert", null, locale));/* 설문 등록 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 수정 페이지 (교수)
     * @param ReshVO 
     * @return "resh/resh_write"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/editResh.do")
    public String editReshForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        List<CreCrsVO> declsList = crecrsService.listCreCrsDeclsNoByTch(creCrsVO);
        request.setAttribute("declsList", declsList);
        
        int scoreViewReshCnt = reshService.selectScoreViewReshCount(vo);
        request.setAttribute("scoreViewReshCnt", scoreViewReshCnt);
        
        List<EgovMap> reshCreCrsList = reshService.listReshCreCrsDecls(vo);
        request.setAttribute("creCrsList", reshCreCrsList);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        
        return "resh/resh_write";
    }
    
    /***************************************************** 
     * TODO 설문 수정 (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editResh.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> editResh(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            String userId = StringUtil.nvl(SessionInfo.getUserId(request));
            String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setOrgId(orgId);
            resultVO.setReturnVO(reshService.updateResh(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.update", null, locale));/* 설문 수정 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 삭제 (교수)
     * @param ReshVO 
     * @return "redirect:/resh/Form/reshList.do"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/delResh.do")
    public String delResh(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        reshService.updateReshDelYn(vo);
        
        return "redirect:"+new URLBuilder("resh", "/Form/reshList.do?crsCreCd="+vo.getCrsCreCd(),request).toString();
    }
    
    /***************************************************** 
     * 이전 설문 가져오기 팝업 (교수)
     * @param vo
     * @param model
     * @param request
     * @return "resh/popup/resh_copy_list_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshCopyListPop.do")
    public String reshCopyListPop(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        String orgId = SessionInfo.getOrgId(request);
        String crsCreCd = vo.getCrsCreCd();
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setOrgId(orgId);
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsService.select(creCrsVO);
        
        TermVO termVO = new TermVO();
        termVO.setCrsCreCd(crsCreCd);
        List<TermVO> termList = termService.listCreYearByProfCourse(termVO);
        
        model.addAttribute("vo", vo);
        model.addAttribute("creCrsVO", creCrsVO);
        model.addAttribute("creYearList", termList);
        model.addAttribute("termList", orgCodeService.selectOrgCodeList("HAKSA_TERM"));
        
        return "resh/popup/resh_copy_list_pop";
    }
    

    /***************************************************** 
     * TODO 설문 목록 가져오기 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/copyReshList.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> copyReshList(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        vo.setOrgId(orgId);
        
        try {
            resultVO = reshService.listMyCreCrsReshPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 이전 설문 가져오기 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshCopy.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> reshCopy(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        
        try {
            ReshVO reshVO = new ReshVO();
            reshVO = reshService.select(vo);
            resultVO.setReturnVO(reshVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.info", null, locale));/* 설문 정보 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 관리 페이지 (교수)
     * @param ReshVO 
     * @return "resh/resh_qstn_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnManage.do")
    public String reshQstnManage(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);
        
        ReshPageVO pageVO = new ReshPageVO();
        pageVO.setReschCd(vo.getReschCd());
        List<ReshPageVO> pageList = reshQstnService.listReshPage(pageVO);
        request.setAttribute("listReschPage", pageList);
        
        request.setAttribute("qstnTypeList", orgCodeService.selectOrgCodeList("RESCH_QSTN_TYPE_CD"));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        LocalDateTime today = LocalDateTime.now();
        request.setAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        
        return "resh/resh_qstn_manage";
    }
    
    /***************************************************** 
     * TODO 설문 문항 엑셀 업로드 팝업 (교수)
     * @param ReshVO 
     * @return "resh/popup/resh_qstn_excel_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnExcelUploadPop.do")
    public String reshQstnExcelUploadPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        request.setAttribute("vo", vo);
        
        return "resh/popup/resh_qstn_excel_upload";
    }
    
    /***************************************************** 
     * TODO 설문 엑셀 업로드 샘플 파일 다운로드.
     * @param vo
     * @param commandMap
     * @param model
     * @param request
     * @return
     * @throws Exception
     ******************************************************/ 
    @RequestMapping(value = "/reshExcelUploadSampleDownload")
    public String downloadReshExcelUploadSample(ReshPageVO vo, Map commandMap, ModelMap model, HttpServletRequest request)throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        HashMap<String, Object> map = reshQstnService.getReshQstnExcelSampleData(vo);
        List<EgovMap> list = null;
        if (map != null) {
            list = (List<EgovMap>) map.get("list");
        }

        //엑셀 정보값 세팅
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", messageSource.getMessage("resh.label.resh.item", null, locale));/* 설문문항 */
        modelMap.put("sheetName", "sample");
        modelMap.put("list", list);

        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleBigGrid(map));
        model.addAllAttributes(modelMap);

        return "excelView";
    }
    
    /***************************************************** 
     * TODO 설문 엑셀 업로드 ajax (교수)
     * @param ReshPageVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/uploadReshQstnExcel.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> uploadReshQstnExcel(ReshPageVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> returnVO = new ProcessResultVO<DefaultVO>();
        int skipRows = 21;
        vo.setExcelUploadSkipRows(skipRows);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        try
        {
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setCopyFiles(vo.getCopyFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            //등록된 파일 저장 후 가져오기
            fileVO = sysFileService.addFile(fileVO);

            //엑셀 읽기위한 정보값 세팅
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", skipRows);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");

            //엑셀 리더
            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);
            
            returnVO = reshQstnService.uploadReshQstnExcel(vo, list, request);
            
        }
        catch (Exception e)
        {
            e.printStackTrace();
            returnVO.setResult(-1);
            returnVO.setMessage(messageSource.getMessage("resh.error.excel.upload", null, locale));/* 엑셀 파일 업로드 중 에러가 발생하였습니다. */
        }
        
        return returnVO;
    }
    
    /***************************************************** 
     * TODO 설문 페이지 리스트 가져오기 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listReshPage.do")
    @ResponseBody
    public ProcessResultVO<ReshPageVO> listReshPage(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshPageVO> resultVO = new ProcessResultVO<ReshPageVO>();
        
        try {
            ReshPageVO pageVO = new ReshPageVO();
            pageVO.setReschCd(vo.getReschCd());
            List<ReshPageVO> pageList = reshQstnService.listReshPage(pageVO);
            resultVO.setReturnList(pageList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 출제 완료 처리 ajax (교수)
     * @param ReshVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReshSubmitYn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editReshSubmitYn(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            vo.setMdfrId(userId);
            reshService.updateReschSubmitYn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.qstn.submit", null, locale));/* 설문 문항 출제 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 참여자 수 가져오기 ajax (교수)
     * @param ReshAnsrVO 
     * @return ProcessResultVO<ReshAnsrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnJoinUserCnt.do")
    @ResponseBody
    public ProcessResultVO<ReshAnsrVO> reshQstnJoinUserCnt(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshAnsrVO> resultVO = new ProcessResultVO<ReshAnsrVO>();
        
        try {
            int joinUserCnt = reshAnsrService.reshQstnJoinUserCnt(vo);
            resultVO.setResult(joinUserCnt);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 정보 가져오기 ajax (교수)
     * @param ReshQstnVO 
     * @return ProcessResultVO<ReshQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/selectReshQstn.do")
    @ResponseBody
    public ProcessResultVO<ReshQstnVO> selectReshQstn(ReshQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshQstnVO> resultVO = new ProcessResultVO<ReshQstnVO>();
        
        try {
            ReshQstnVO qstnVO = reshQstnService.selectReshQstn(vo);
            qstnVO.setReschQstnItemList(reshQstnService.listReshQstnItem(qstnVO));
            qstnVO.setReschScaleList(reshQstnService.listReshScale(qstnVO));
            resultVO.setReturnVO(qstnVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.info", null, locale));/* 설문 정보 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 등록 ajax (교수자)
     * @param ReshQstnVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeReshQstn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> writeReshQstn(ReshQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            vo.setRgtrId(userId);
            reshQstnService.insertReshQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.qstn.insert", null, locale));/* 설문 문항 추가 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 수정 ajax (교수자)
     * @param ReshQstnVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReshQstn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editReshQstn(ReshQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            reshQstnService.updateReshQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.qstn.update", null, locale));/* 설문 문항 수정 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 삭제 ajax (교수자)
     * @param ReshQstnVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteReshQstn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteReshQstn(ReshQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            vo.setRgtrId(userId);
            reshQstnService.deleteReshQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.qstn.delete", null, locale));/* 설문 문항 삭제 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 페이지 순서 변경 ajax (교수)
     * @param ReshPageVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReshPageOdr.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateReshPageOdr(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            reshQstnService.editReshPageOdr(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.page.sort", null, locale));/* 설문 페이지 순서 변경 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 페이지별 항목 순서 변경 ajax (교수)
     * @param ReshQstnVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReshQstnOdr.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateReshQstnOdr(ReshQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            reshQstnService.editReshQstnOdr(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.qstn.sort", null, locale));/* 설문 문항 순서 변경 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 페이지 삭제 ajax (교수)
     * @param ReshPageVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/deleteReshPage.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> deleteReshPage(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            reshQstnService.deleteReshPage(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.page.delete", null, locale));/* 설문 페이지 삭제 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 결과 페이지 (교수)
     * @param ReshVO 
     * @return "resh/resh_result_manage"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshResultManage.do")
    public String reshResultManage(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale    = LocaleUtil.getLocale(request);
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
        }
        
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.select(creCrsVO);
        model.addAttribute("creCrsVO", creCrsVO);
        
        ReshVO reshVo = reshService.select(vo);
        model.addAttribute("vo", reshVo);
        model.addAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", orgId);
        model.addAttribute("authGrpCd", authGrpCd);
        model.addAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        model.addAttribute("userInfoPopUrl", CommConst.USER_INFO_POP_URL);
        
        return "resh/resh_result_manage";
    }
    
    /***************************************************** 
     * TODO 제출 설문 엑셀다운로드 (교수)
     * @param ReshVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshJoinUserAnswerExcelDown.do")
    public String reshJoinUserAnswerExcelDown(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        
        List<EgovMap> joinUserAnswerList = reshAnsrService.listReshAnswer(vo);
        List<EgovMap> qstnAndScaleList = reshAnsrService.listReshQstnAndScale(vo);

        // 엑셀 파일 생성
        String title = messageSource.getMessage("resh.label.join.user.stare.answer", null, locale); // 참여자 답변 목록
        HashMap<String, Object> dataMap = new HashMap<String, Object>();
        dataMap.put("title", title); 
        dataMap.put("joinUserAnswerList", joinUserAnswerList);
        dataMap.put("qstnAndScaleList", qstnAndScaleList);

        Map<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", messageSource.getMessage("resh.label.submit.label", null, locale)+"_" + date.format(today));  // 제출설문

        modelMap.put("workbook", makeJoinUserAnswerExcel(dataMap, request));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * TODO 설문 결과 엑셀다운로드 (교수)
     * @param ReshVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshResultExcelDown.do")
    public String reshResultExcelDown(ReshPageVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        Date today = new Date();
        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");

        List<ReshPageVO> joinStatusList = reshAnsrService.listReshAnswerStatus(vo);

        // 엑셀 파일 생성
        String title = messageSource.getMessage("resh.label.resh.result", null, locale);  // 설문결과
        Map<String, Object> dataMap = new HashMap<String, Object>();
        dataMap.put("title", title); 
        dataMap.put("list", joinStatusList);

        Map<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", title + "_" + date.format(today));

        modelMap.put("workbook", makeReshResultExcel(dataMap, request));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * TODO 제출 설문  엑셀 생성.
     * @param dataMap
     * @return workbook
     * @throws Exception
     ******************************************************/ 
    public Workbook makeJoinUserAnswerExcel(Map<String, Object> dataMap, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String title = StringUtil.nvl(dataMap.get("title"));
        String sheetName = StringUtil.nvl(dataMap.get("sheetName"),"sheet1");

        String ext = StringUtil.nvl(dataMap.get("ext"));
        if(StringUtil.isNull(ext)) {
           ext = ".xlsx";
        }

        Workbook workbook = null;
        if(".xls".equals(ext)) {
            workbook = new HSSFWorkbook();
        }else if(".xlsx".equals(ext)){
            workbook = new XSSFWorkbook();
        }

        Sheet worksheet = null;
        Row row = null;

        //타이틀 폰트 설정
        Font titleFont = workbook.createFont();
        titleFont.setFontHeight((short)(16*25)); //사이즈
        titleFont.setBold(true);

        //헤더 폰트 설정
        Font headerFont = workbook.createFont();
        headerFont.setFontHeight((short)(16*12)); //사이즈
        headerFont.setBold(true);

        //답변 폰트 설정(헤더가 아닌 나머지 row)
        Font answerFont = workbook.createFont();
        answerFont.setFontHeight((short)(16*12)); //사이즈
        answerFont.setBold(false);
        

        // 타이틀 셀 스타일 및 폰트 설정
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.LEFT);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setBorderRight(BorderStyle.NONE);
        titleStyle.setBorderLeft(BorderStyle.NONE);
        titleStyle.setBorderTop(BorderStyle.NONE);
        titleStyle.setBorderBottom(BorderStyle.NONE);
        titleStyle.setFont(titleFont);

        // 헤더 셀 스타일 및 폰트 설정
        HSSFCellStyle styleHeaderHSS = null;
        XSSFCellStyle styleHeaderXSS = null;
        if(workbook instanceof HSSFWorkbook) {
            styleHeaderHSS = (HSSFCellStyle) workbook.createCellStyle();
            styleHeaderHSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
            styleHeaderHSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
            styleHeaderHSS.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            styleHeaderHSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            styleHeaderHSS.setBorderRight(BorderStyle.THIN);
            styleHeaderHSS.setBorderLeft(BorderStyle.THIN);
            styleHeaderHSS.setBorderTop(BorderStyle.THIN);
            styleHeaderHSS.setBorderBottom(BorderStyle.THIN);
            styleHeaderHSS.setFont(headerFont);
        } else {
            styleHeaderXSS = (XSSFCellStyle) workbook.createCellStyle();
            styleHeaderXSS.setAlignment(HorizontalAlignment.CENTER); //가운데 정렬
            styleHeaderXSS.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
            styleHeaderXSS.setFillForegroundColor(new XSSFColor(new java.awt.Color(192, 192, 192) ));
            styleHeaderXSS.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            styleHeaderXSS.setBorderRight(BorderStyle.THIN);
            styleHeaderXSS.setBorderLeft(BorderStyle.THIN);
            styleHeaderXSS.setBorderTop(BorderStyle.THIN);
            styleHeaderXSS.setBorderBottom(BorderStyle.THIN);
            styleHeaderXSS.setFont(headerFont);
        }

        // 답변  셀 스타일 및 폰트 설정
        CellStyle answerStyle = workbook.createCellStyle();
        answerStyle.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        answerStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        answerStyle.setBorderRight(BorderStyle.THIN);
        answerStyle.setBorderLeft(BorderStyle.THIN);
        answerStyle.setBorderTop(BorderStyle.THIN);
        answerStyle.setBorderBottom(BorderStyle.THIN);
        answerStyle.setFont(answerFont);


        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);
        List<EgovMap> qstnAndScaleList = (List<EgovMap>) dataMap.get("qstnAndScaleList");
        int offset = 2;
        worksheet.setColumnWidth(0, 1000);
        worksheet.setColumnWidth(1, 5000);
        for (EgovMap qstnMap : qstnAndScaleList) {
            worksheet.setColumnWidth(offset, 10000);
            offset++;
        }

        // title
        int rowNum = -1;
        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue(title); 
        row.getCell(0).setCellStyle(titleStyle);
        row = worksheet.createRow(++rowNum); // 빈 row

        //header
        row = worksheet.createRow(++rowNum);
        row.createCell(0).setCellValue("No");
        row.createCell(1).setCellValue(messageSource.getMessage("resh.label.join.user", null, locale)); // 참여자
        if(workbook instanceof HSSFWorkbook) {
            row.getCell(0).setCellStyle(styleHeaderHSS);
            row.getCell(1).setCellStyle(styleHeaderHSS);
        } else {
            row.getCell(0).setCellStyle(styleHeaderXSS);
            row.getCell(1).setCellStyle(styleHeaderXSS);
        }


        int i = 2;
        for (EgovMap qstnMap : qstnAndScaleList) {
            if ("SCALE".equals(qstnMap.get("reschQstnTypeCd")) ) {
                row.createCell(i).setCellValue(qstnMap.get("reschPageOdr").toString() + "_" + qstnMap.get("reschQstnOdr").toString() + "_" + qstnMap.get("itemOdr").toString());
            } else {
                row.createCell(i).setCellValue(qstnMap.get("reschPageOdr").toString() + "_" + qstnMap.get("reschQstnOdr").toString());
            }

            if(workbook instanceof HSSFWorkbook) {
                row.getCell(i).setCellStyle(styleHeaderHSS);
            } else {
                row.getCell(i).setCellStyle(styleHeaderXSS);
            }
            i++;
        }

        // 참여자 및 답변
        List<EgovMap> joinUserAnswerList = (List<EgovMap>) dataMap.get("joinUserAnswerList");
        if (joinUserAnswerList != null && !joinUserAnswerList.isEmpty() && joinUserAnswerList.size() > 0) {
            int idx = 1;
            for (EgovMap userMap : joinUserAnswerList) {
                row = worksheet.createRow(++rowNum);
                row.createCell(0).setCellValue(idx);
                row.getCell(0).setCellStyle(answerStyle);
                row.createCell(1).setCellValue((String)userMap.get("userNm"));
                row.getCell(1).setCellStyle(answerStyle);

                int j = 2;
                List<EgovMap> answerList = (List<EgovMap>) userMap.get("answerList");
                for (EgovMap qstnMap : qstnAndScaleList) {
                    String answer = "";
                    for (EgovMap answerMap : answerList) {
                        if ("SCALE".equals(qstnMap.get("reschQstnTypeCd")) 
                                && answerMap.get("reschPageCd").toString().equals(qstnMap.get("reschPageCd"))
                                && answerMap.get("reschQstnCd").toString().equals(qstnMap.get("reschQstnCd"))
                                && answerMap.get("reschQstnItemCd").toString().equals(qstnMap.get("reschQstnItemCd")) ) {
                            answer += answerMap.get("scaleTitle").toString();
                        } else if (!"SCALE".equals(qstnMap.get("reschQstnTypeCd")) 
                                && answerMap.get("reschPageCd").toString().equals(qstnMap.get("reschPageCd"))
                                && answerMap.get("reschQstnCd").toString().equals(qstnMap.get("reschQstnCd"))  ) {
                            if (!"".equals(answer) ) {
                                answer += ", ";
                            }
                            answer += answerMap.get("reschQstnItemTitle").toString();
                        }
                    }
                    row.createCell(j).setCellValue(answer);
                    row.getCell(j).setCellStyle(answerStyle);

                    j++;
                }
                idx++;
            }
        }

        return workbook;
    }
    
    /***************************************************** 
     * TODO 설문 결과 엑셀 생성.
     * @param dataMap
     * @return workbook
     * @throws Exception
     ******************************************************/ 
    public Workbook makeReshResultExcel(Map<String, Object> dataMap, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String title = StringUtil.nvl(dataMap.get("title"));
        String sheetName = StringUtil.nvl(dataMap.get("sheetName"),"sheet1");

        String ext = StringUtil.nvl(dataMap.get("ext"));
        if(StringUtil.isNull(ext)) {
           ext = ".xlsx";
        }

        Workbook workbook = null;
        if(".xls".equals(ext)) {
            workbook = new HSSFWorkbook();
        }else if(".xlsx".equals(ext)){
            workbook = new XSSFWorkbook();
        }

        Sheet worksheet = null;
        Row row = null;

        //페이지 제목 폰트 설정
        Font pageTitleFont = workbook.createFont();
        pageTitleFont.setFontHeight((short)(16*22)); //사이즈
        pageTitleFont.setBold(true);

        //문항 제목 폰트 설정
        Font titleFont = workbook.createFont();
        titleFont.setFontHeight((short)(16*12)); //사이즈
        titleFont.setBold(true);

        //문항 아이템 폰트 설정
        Font itemFont = workbook.createFont();
        itemFont.setFontHeight((short)(16*12)); //사이즈
        itemFont.setBold(true);

        //답변현황 폰트 설정
        Font answerFont = workbook.createFont();
        answerFont.setFontHeight((short)(16*12)); //사이즈
        answerFont.setBold(false);

        //척도 타이틀 폰트 설정
        Font scaleFont = workbook.createFont();
        scaleFont.setFontHeight((short)(16*12)); //사이즈
        scaleFont.setBold(true);

        // 페이지 제목 셀 스타일 및 폰트 설정
        CellStyle pageTitleStyle = workbook.createCellStyle();
        pageTitleStyle.setAlignment(HorizontalAlignment.LEFT);
        pageTitleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        pageTitleStyle.setBorderRight(BorderStyle.NONE);
        pageTitleStyle.setBorderLeft(BorderStyle.NONE);
        pageTitleStyle.setBorderTop(BorderStyle.NONE);
        pageTitleStyle.setBorderBottom(BorderStyle.NONE);
        pageTitleStyle.setFont(pageTitleFont);

        // 문항 제목 셀 스타일 및 폰트 설정
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.LEFT);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setBorderRight(BorderStyle.NONE);
        titleStyle.setBorderLeft(BorderStyle.NONE);
        titleStyle.setBorderTop(BorderStyle.NONE);
        titleStyle.setBorderBottom(BorderStyle.NONE);
        titleStyle.setFont(titleFont);

        // 문항 아이템 셀 스타일 및 폰트 설정
        CellStyle itemStyle = workbook.createCellStyle();
        itemStyle.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        itemStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        itemStyle.setBorderRight(BorderStyle.THIN);
        itemStyle.setBorderLeft(BorderStyle.THIN);
        itemStyle.setBorderTop(BorderStyle.THIN);
        itemStyle.setBorderBottom(BorderStyle.THIN);
        itemStyle.setFont(itemFont);

        // 답변 현황 셀 스타일 및 폰트 설정
        CellStyle answerStyle = workbook.createCellStyle();
        answerStyle.setAlignment(HorizontalAlignment.LEFT); //왼쪽 정렬
        answerStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        answerStyle.setBorderRight(BorderStyle.THIN);
        answerStyle.setBorderLeft(BorderStyle.THIN);
        answerStyle.setBorderTop(BorderStyle.THIN);
        answerStyle.setBorderBottom(BorderStyle.THIN);
        answerStyle.setFont(answerFont);

        // 답변 카운트 셀 스타일 및 폰트 설정
        CellStyle answerCntStyle = workbook.createCellStyle();
        answerCntStyle.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        answerCntStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        answerCntStyle.setBorderRight(BorderStyle.THIN);
        answerCntStyle.setBorderLeft(BorderStyle.THIN);
        answerCntStyle.setBorderTop(BorderStyle.THIN);
        answerCntStyle.setBorderBottom(BorderStyle.THIN);
        answerCntStyle.setFont(answerFont);

        // 척도 타이틀 셀 스타일 및 폰트 설정
        CellStyle scaleStyle = workbook.createCellStyle();
        scaleStyle.setAlignment(HorizontalAlignment.CENTER); //왼쪽 정렬
        scaleStyle.setVerticalAlignment(VerticalAlignment.CENTER); //높이 가운데 정렬
        scaleStyle.setBorderRight(BorderStyle.THIN);
        scaleStyle.setBorderLeft(BorderStyle.THIN);
        scaleStyle.setBorderTop(BorderStyle.THIN);
        scaleStyle.setBorderBottom(BorderStyle.THIN);
        scaleStyle.setFont(scaleFont);

        // 새로운 sheet를 생성한다.
        worksheet = workbook.createSheet(sheetName);
        worksheet.setColumnWidth(0, 15000);
        worksheet.setColumnWidth(1, 5000);
        worksheet.setColumnWidth(2, 5000);
        worksheet.setColumnWidth(3, 5000);
        worksheet.setColumnWidth(4, 5000);
        worksheet.setColumnWidth(5, 5000);
        worksheet.setColumnWidth(6, 5000);
        worksheet.setColumnWidth(7, 5000);
        worksheet.setColumnWidth(8, 5000);
        worksheet.setColumnWidth(9, 5000);
        worksheet.setColumnWidth(10, 5000);


        List<ReshPageVO> joinStatusList = (List<ReshPageVO>) dataMap.get("list");
        if ( joinStatusList == null || joinStatusList.isEmpty() || joinStatusList.size() == 0) {
            return workbook;
        }

        int rowNum = -1;
        for (ReshPageVO reshPageVO : joinStatusList) {
            row = worksheet.createRow(++rowNum);
            row.createCell(0).setCellValue(reshPageVO.getReschPageOdr() + ". " + reshPageVO.getReschPageTitle()); 
            row.getCell(0).setCellStyle(pageTitleStyle);
            List<ReshQstnVO> qstnList = reshPageVO.getReschQstnList();
            if ( qstnList != null && !qstnList.isEmpty() && qstnList.size() > 0) {
                for (ReshQstnVO reshQstnVO : qstnList) {
                    row = worksheet.createRow(++rowNum);
                    StringBuilder qstnTitle = new StringBuilder()
                    .append(reshPageVO.getReschPageOdr())
                    .append("-")
                    .append(reshQstnVO.getReschQstnOdr())
                    .append(". ")
                    .append(reshQstnVO.getReschQstnTitle())
                    .append(" [")
                    .append(reshQstnVO.getReschQstnTypeNm())
                    .append("]");

                    row.createCell(0).setCellValue(qstnTitle.toString());
                    row.getCell(0).setCellStyle(titleStyle);

                    String reschQstnTypeCd = reshQstnVO.getReschQstnTypeCd();

                    // 단일형/다중형/OX형 
                    if ("SINGLE".equals(reschQstnTypeCd) || "MULTI".equals(reschQstnTypeCd) || "OX".equals(reschQstnTypeCd)) {
                        List<EgovMap> answerList = reshQstnVO.getReschAnswerList();
                        for (EgovMap answerMap : answerList ) {
                            row = worksheet.createRow(++rowNum);

                            // 문항아이템(문항 선택지)
                            String itemTitle = answerMap.get("reschQstnItemTitle").toString();
                            if ("SINGLE_ETC_ITEM".equals(itemTitle) ) {
                                itemTitle = messageSource.getMessage("resh.label.choice.etc", null, locale);    // 기타 항목
                            }
                            row.createCell(0).setCellValue(itemTitle);
                            row.getCell(0).setCellStyle(itemStyle);

                            // 문항 답변 현황
                            StringBuilder answerStatus = new StringBuilder(answerMap.get("ratio").toString())
                                    .append("%")
                                    .append(" (")
                                    .append(answerMap.get("totJoinCnt").toString())
                                    .append(messageSource.getMessage("resh.label.nm", null, locale))    // 명
                                    .append(" ")
                                    .append(messageSource.getMessage("resh.label.of", null, locale))    // 중
                                    .append(" ")
                                    .append(answerMap.get("joinCnt").toString())
                                    .append(messageSource.getMessage("resh.label.nm", null, locale))    // 명
                                    .append(")");
                            row.createCell(1).setCellValue(answerStatus.toString());
                            row.getCell(1).setCellStyle(answerStyle);

                            // 문항 답변 카운트
                            row.createCell(2).setCellValue(answerMap.get("joinCnt").toString() + messageSource.getMessage("resh.label.nm", null, locale));  // 명
                            row.getCell(2).setCellStyle(answerCntStyle);
                        }
                    } // 단일형/다중형/OX형 

                    // 서술형 
                    if ("TEXT".equals(reschQstnTypeCd)) {
                        List<EgovMap> answerList = reshQstnVO.getReschAnswerList();
                        if (answerList != null && !answerList.isEmpty() && answerList.size() > 0) {
                            for (EgovMap answerMap : answerList ) {
                                row = worksheet.createRow(++rowNum);
                                row.createCell(0).setCellValue(answerMap.get("rnum").toString());
                                row.getCell(0).setCellStyle(answerCntStyle);

                                row.createCell(1).setCellValue(answerMap.get("etcOpinion").toString());
                                row.getCell(1).setCellStyle(answerStyle);
                            }
                        }
                    } // 서술형

                    // 척도형 
                    if ("SCALE".equals(reschQstnTypeCd)) {
                        List<ReshScaleVO> scaleList = reshQstnVO.getReschScaleList();
                        row = worksheet.createRow(++rowNum);
                        row.createCell(0).setCellValue("");
                        row.getCell(0).setCellStyle(scaleStyle);

                        int idx = 1;
                        for (ReshScaleVO reshScaleVO : scaleList) {
                            row.createCell(idx).setCellValue(reshScaleVO.getScaleTitle());
                            row.getCell(idx).setCellStyle(scaleStyle);
                            idx++;
                        }

                        List<EgovMap> answerList = reshQstnVO.getReschAnswerList();
                        if (answerList != null && !answerList.isEmpty() && answerList.size() > 0) {
                            for (EgovMap answerMap : answerList ) {
                                row = worksheet.createRow(++rowNum);
                                row.createCell(0).setCellValue(answerMap.get("reschQstnItemTitle").toString());
                                row.getCell(0).setCellStyle(itemStyle);

                                int scaleCnt = 10; // 최대 척도의 갯수는 10개
                                for(int i = 1; i <= scaleCnt; i++) {
                                    if (!"".equals(StringUtil.nvl(answerMap.get("ratio" + i), ""))) {
                                        StringBuilder answerStatus = new StringBuilder(answerMap.get("ratio" + i).toString())
                                                .append("%")
                                                .append(" (")
                                                .append(answerMap.get("totJoinCnt" + i).toString())
                                                .append(messageSource.getMessage("resh.label.nm", null, locale))    // 명
                                                .append(" ")
                                                .append(messageSource.getMessage("resh.label.of", null, locale))    // 중
                                                .append(" ")
                                                .append(answerMap.get("joinCnt" + i).toString())
                                                .append(messageSource.getMessage("resh.label.nm", null, locale))    // 명
                                                .append(")");
    
                                        row.createCell(i).setCellValue(answerStatus.toString());
                                        row.getCell(i).setCellStyle(answerStyle);
                                    }
                                }
                            }
                        }
                    } // 척도형

                    row = worksheet.createRow(++rowNum); // 빈 row(문항과 문항 사이에 한깐 띄운다)
                }
            }
            row = worksheet.createRow(++rowNum); // 빈 row(페이지와 페이지 사이에 한깐 띄운다)
        }

        return workbook;
    }
    
    /***************************************************** 
     * TODO 설문 참여자 목록 가져오기 ajax (교수자)
     * @param ReshVO 
     * @return ProcessResultVO<EgovMap>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshJoinUserList.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> reshJoinUserList(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        
        try {
            resultVO = reshAnsrService.listReshJoinUser(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 문항 가져오기 팝업 (교수)
     * @param ReshVO 
     * @return "resh/popup/resh_qstn_copy_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnCopyPop.do")
    public String reshQstnCopyPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));
        vo.setOrgId(orgId);
        vo.setRgtrId(userId);
        List<ReshVO> reshList = new ArrayList<ReshVO>();
        if("HOME".equals(StringUtil.nvl(vo.getReschTypeCd()))) {
            vo.setPagingYn("N");
            reshList = reshService.listPaging(vo).getReturnList();
        } else {
            reshList = reshService.listMyCreCrsResh(vo);
        }
        reshService.listPaging(vo).getReturnList();
        request.setAttribute("reshList", reshList);
        request.setAttribute("vo", vo);
        
        return "resh/popup/resh_qstn_copy_pop";
    }
    
    /***************************************************** 
     * TODO 설문 문항 복사 ajax (교수)
     * @param ReshPageVO 
     * @return ProcessResultVO<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/copyReshQstn.do")
    @ResponseBody
    public ProcessResultVO<ReshPageVO> copyReshQstn(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale  = LocaleUtil.getLocale(request);
        String userId  = StringUtil.nvl(SessionInfo.getUserId(request));
        String reschCd = StringUtil.nvl(vo.getReschCd());
        ProcessResultVO<ReshPageVO> resultVO = new ProcessResultVO<ReshPageVO>();
        
        if(ValidationUtils.isEmpty(reschCd)) {
            // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
            throw new BadRequestUrlException(getMessage("common.system.error"));
        }
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            resultVO = reshQstnService.copyReshQstn(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.qstn.copy", null, locale));/* 설문 문항 가져오기 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 특정 페이지 문항 목록 가져오기 ajax (교수)
     * @param ReshPageVO 
     * @return ProcessResultVO<ReshQstnVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listReshQstn.do")
    @ResponseBody
    public ProcessResultVO<ReshQstnVO> listReshQstn(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshQstnVO> resultVO = new ProcessResultVO<ReshQstnVO>();
        
        try {
            List<ReshQstnVO> qstnList = reshQstnService.listReshQstn(vo);
            resultVO.setReturnList(qstnList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }

    /***************************************************** 
     * TODO 설문 페이지 목록 가져오기 ajax (교수)
     * @param ReshPageVO 
     * @return ProcessResultVO<ReshPageVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/listReshSimplePage.do")
    @ResponseBody
    public ProcessResultVO<ReshPageVO> listReshSimplePage(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<ReshPageVO> resultVO = new ProcessResultVO<ReshPageVO>();
        
        try {
            List<ReshPageVO> pageList = reshQstnService.listReshSimplePage(vo);
            resultVO.setReturnList(pageList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 페이지 추가 팝업 (교수)
     * @param ReshPageVO
     * @return "resh/popup/resh_qstn_write_page_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnWritePagePop.do")
    public String reshQstnWritePagePop(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        request.setAttribute("vo", vo);
        
        return "resh/popup/resh_qstn_write_page_pop";
    }
    
    /***************************************************** 
     * TODO 설문 페이지 수정 팝업 (교수)
     * @param ReshPageVO 
     * @return "resh/popup/resh_qstn_write_page_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshQstnEditPagePop.do")
    public String reshQstnEditPagePop(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        ReshPageVO pageVO = reshQstnService.selectReshPage(vo);
        request.setAttribute("vo", vo);
        request.setAttribute("pageVO", pageVO);
        
        return "resh/popup/resh_qstn_write_page_pop";
    }

    /***************************************************** 
     * TODO 설문 페이지 등록 ajax (교수자)
     * @param ReshPageVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/writeReshPage.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> writeReshPage(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(vo.getReschCd()) || "".equals(StringUtil.nvl(vo.getReschCd()))) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            vo.setRgtrId(userId);
            reshQstnService.insertReshPage(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.page.insert", null, locale));/* 설문 페이지 추가 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 페이지 수정 ajax (교수자)
     * @param ReshPageVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReshPage.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editReshPage(ReshPageVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            if(ValidationUtils.isEmpty(userId) || ValidationUtils.isEmpty(vo.getReschCd()) || "".equals(StringUtil.nvl(vo.getReschCd()))) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            vo.setMdfrId(userId);
            reshQstnService.updateReshPage(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.page.update", null, locale));/* 설문 페이지 수정 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 목록 페이지 (학습자)
     * @param ReshVO 
     * @return "resh/stu_resh_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/stuReshList.do")
    public String stuReshListForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_RESCH, "설문 목록");
        
        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        vo.setCrsCreCd(crsCreCd);
        vo.setUserId(userId);
        vo.setStdNo(stdVO.getStdId());
        request.setAttribute("vo", vo);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "resh/stu_resh_list";
    }
    
    /***************************************************** 
     * TODO 설문 목록 가져오기 ajax (학습자)
     * @param ReshVO 
     * @return ProcessResultVO<ReshVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuReshList.do")
    @ResponseBody
    public ProcessResultVO<ReshVO> stuReshList(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<ReshVO> resultVO = new ProcessResultVO<ReshVO>();
        
        try {
            vo.setSearchMenu("LEARNER");
            vo.setUserId(userId);
            resultVO = reshService.listPaging(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.list", null, locale));/* 설문 리스트 조회 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 정보 페이지 (학습자)
     * @param ReshVO 
     * @return "resh/stu_resh_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/stuReshView.do")
    public String stuReshViewForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String crsCreCd  = vo.getCrsCreCd();
        vo.setUserId(userId);
        ReshVO reshVo = reshService.select(vo);
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_RESCH, "["+reshVo.getReschTitle()+"] 설문 정보 확인");
        
        StdVO stdVO = new StdVO();
        stdVO.setUserId(userId);
        stdVO.setCrsCreCd(crsCreCd);
        stdVO = stdService.selectStd(stdVO);
        
        request.setAttribute("vo", reshVo);
        request.setAttribute("stdVO", stdVO);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        
        return "resh/stu_resh_view";
    }
    
    /***************************************************** 
     * TODO 설문 참여 팝업 (학습자)
     * @param ReshVO 
     * @return "resh/popup/resh_join_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshJoinPop.do")
    public String reshJoinPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
        
        request.setAttribute("vo", vo);
        request.setAttribute("listReschPage", listReschPage);
        
        ReshVO reshVO = reshService.select(vo);
        request.setAttribute("crsCreCd", reshVO.getCrsCreCd());
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, reshVO.getCrsCreCd(), CommConst.ACTN_HSTY_RESCH, "["+reshVO.getReschTitle()+"] 설문 참여");
        
        return "resh/popup/resh_join_pop";
    }
    
    /***************************************************** 
     * TODO 설문 재참여 팝업 (학습자)
     * @param ReshVO 
     * @return "resh/popup/resh_join_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshEditPop.do")
    public String reshEditPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
        
        ReshAnsrVO reshAnsrVO = new ReshAnsrVO();
        reshAnsrVO.setUserId(userId);
        reshAnsrVO.setReschCd(vo.getReschCd());
        
        request.setAttribute("vo", vo);
        request.setAttribute("listReschPage", listReschPage);
        request.setAttribute("answerList", reshAnsrService.listReshMyAnswer(reshAnsrVO));
        
        return "resh/popup/resh_join_pop";
    }

    /***************************************************** 
     * TODO 설문 제출 ajax (학습자)
     * @param ReshAnsrVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshJoin.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> reshJoin(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String connIp = StringUtil.nvl(SessionInfo.getLoginIp(request));
        String userAgent = request.getHeader("User-Agent").toUpperCase();
        String crsCreCd  = vo.getCrsCreCd();
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        
        try {
            vo.setRgtrId(vo.getUserId());
            vo.setMdfrId(vo.getUserId());
            if(userAgent.indexOf("MOBILE") > -1) {
                vo.setDeviceTypeCd("MOBILE");
            } else {
                vo.setDeviceTypeCd("PC");
            }
            vo.setConnIp(connIp);
            ReshVO reshVO = new ReshVO();
            reshVO.setReschCd(vo.getReschCd());
            reshVO.setUserId(vo.getUserId());
            reshVO.setCrsCreCd(crsCreCd);
            reshVO = reshService.select(reshVO);
            double score = "J".equals(StringUtil.nvl(reshVO.getEvalCtgr())) ? 100 : 0;
            vo.setScore(score);
            if("Y".equals(StringUtil.nvl(reshVO.getJoinYn()))) {
                reshAnsrService.updateReshAnsrByUser(vo, request);
            } else {
                reshAnsrService.insertReshAnsr(vo, request);
            }
            
            // 강의실 활동 로그 등록
            logLessonActnHstyService.saveLessonActnHsty(request, StringUtil.nvl(reshVO.getCrsCreCd()), CommConst.ACTN_HSTY_RESCH, "["+reshVO.getReschTitle()+"] 설문 참여");
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.submit", null, locale));/* 설문 제출 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 결과 팝업 (학습자)
     * @param ReshVO 
     * @return "resh/popup/resh_result_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshResultPop.do")
    public String reshResultPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> reschAnswerList = reshAnsrService.listReshAnswerStatus(pageVo);
        request.setAttribute("reschAnswerList", reschAnswerList);
        
        List<Map<String, Object>> colorList = new ArrayList<Map<String, Object>>();
        String[] colorTitleList = {"bcOrange", "bcYellow", "bcOlive", "bcGreen", "bcLblue", "bcPurple", "bcViolet", "bcBrown", "bcGrey", "bcPink"};
        String[] colorCodeList = {"#f2711c", "#fbbd08", "#b5cc18", "#21ba45", "#deeaf6", "#a333c8", "#6435c9", "#a5673f", "#767676", "#e03997"};
        
        for(int i = 0; i < 10; i++) {
            Map<String, Object> colorMap = new HashMap<String, Object>();
            colorMap.put("title", colorTitleList[i]);
            colorMap.put("code", colorCodeList[i]);
            colorList.add(colorMap);
        }
        
        request.setAttribute("colorList", colorList);
        
        return "resh/popup/resh_result_pop";
    }
    
    /***************************************************** 
     * TODO 홈페이지 설문 목록 페이지 (공통)
     * @param ReshVO 
     * @return "resh/home_resh_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/Form/homeReshList.do")
    public String homeReshListForm(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String userId    = StringUtil.nvl(SessionInfo.getUserId(request));
        String joinTrgt  = "";
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        if(menuType.contains("PROF")) {
            joinTrgt = "PROF";
        } else if(menuType.contains("USR")) {
            joinTrgt = "LEARNER";
        }
        vo.setUserId(userId);
        vo.setJoinTrgt(joinTrgt);
        vo.setTotalCnt(reshService.count(vo));
        request.setAttribute("vo", vo);
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        
        return "resh/home_resh_list";
    }
    
    /***************************************************** 
     * TODO 홈페이지 설문 결과 페이지 (공통)
     * @param ReshVO 
     * @return "resh/home_resh_result"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/homeReshResult.do")
    public String homeReshResult(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String orgId     = StringUtil.nvl(SessionInfo.getOrgId(request));
        String menuType  = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        String authGrpCd = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        request.setAttribute("joinStatus", reshAnsrService.selectHomeReshJoinUserStatus(vo));
        
        vo.setOrgId(orgId);
        vo.setReschTypeCd("HOME");
        List<EgovMap> joinDeviceList = reshAnsrService.listReshJoinDeviceStatus(vo);
        request.setAttribute("joinDeviceList", joinDeviceList);
        
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> reschAnswerList = reshAnsrService.listReshAnswerStatus(pageVo);
        request.setAttribute("reschAnswerList", reschAnswerList);
        
        List<Map<String, Object>> colorList = new ArrayList<Map<String, Object>>();
        String[] colorTitleList = {"bcOrange", "bcYellow", "bcOlive", "bcGreen", "bcLblue", "bcPurple", "bcViolet", "bcBrown", "bcGrey", "bcPink"};
        String[] colorCodeList = {"#f2711c", "#fbbd08", "#b5cc18", "#21ba45", "#deeaf6", "#a333c8", "#6435c9", "#a5673f", "#767676", "#e03997"};
        
        for(int i = 0; i < 10; i++) {
            Map<String, Object> colorMap = new HashMap<String, Object>();
            colorMap.put("title", colorTitleList[i]);
            colorMap.put("code", colorCodeList[i]);
            colorList.add(colorMap);
        }
        
        request.setAttribute("colorList", colorList);
        request.setAttribute("deviceList", orgCodeService.selectOrgCodeList("DEVICE_TYPE_CD"));
        request.setAttribute("menuType", menuType.contains("USR") ? "USR" : "PROF");
        request.setAttribute("orgId", orgId);
        request.setAttribute("authGrpCd", authGrpCd);
        request.setAttribute("crsCreCd", StringUtil.nvl(vo.getCrsCreCd()));
        
        return "resh/home_resh_result";
    }
    
    /***************************************************** 
     * 강의평가 설문 리스트
     * @param ReshVO 
     * @return "resh/lect_eval_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/lectEvalList.do")
    public String lectEvalList(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String crsCreCd = vo.getCrsCreCd();
        String userId = SessionInfo.getUserId(request);
        
        // 수강중인 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);
        
        if(stdVO != null) {
            String stdNo = stdVO.getStdId();
            model.addAttribute("stdNo", stdNo);
        }
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_RESCH, "강의평가 목록");
        
        // 강의평가 설문 카테고리 코드
        model.addAttribute("reschCtgrCd", CommConst.LECT_EVAL_RESCH_CTGR_CD);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "resh/lect_eval_list";
    }
    
    /***************************************************** 
     * 강의평가 설문 상세
     * @param ReshVO 
     * @return "resh/lect_eval_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/lectEvalView.do")
    public String lectEvalView(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String reschCd = vo.getReschCd();
        
        ReshVO reshVO = new ReshVO();
        reshVO.setCrsCreCd(crsCreCd);
        reshVO.setReschCd(reschCd);
        reshVO.setUserId(userId);
        reshVO = reshService.select(reshVO);
        
        model.addAttribute("reshVO", reshVO);
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_RESCH, "["+reshVO.getReschTitle()+"] 강의평가정보 확인");
        
        reshVO = new ReshVO();
        reshVO.setReschCd(reschCd);
        reshVO.setOrgId(orgId);
        List<EgovMap> joinDeviceList = reshAnsrService.listReshJoinDeviceStatus(reshVO);
        
        model.addAttribute("joinDeviceList", joinDeviceList);
        model.addAttribute("vo", vo);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "resh/lect_eval_view";
    }
    
    /***************************************************** 
     * 만족도조사 설문 리스트
     * @param ReshVO 
     * @return "resh/level_eval_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/levelEvalList.do")
    public String levelEvalList(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String crsCreCd = vo.getCrsCreCd();
        String userId = SessionInfo.getUserId(request);
        
        // 수강중인 학생정보 조회
        StdVO stdVO = new StdVO();
        stdVO.setOrgId(SessionInfo.getOrgId(request));
        stdVO.setCrsCreCd(crsCreCd);
        stdVO.setUserId(userId);
        stdVO = stdService.selectStd(stdVO);
        
        if(stdVO != null) {
            String stdNo = stdVO.getStdId();
            model.addAttribute("stdNo", stdNo);
        }
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_RESCH, "만족도평가 목록");
        
        // 만족도조사 설문 카테고리 코드
        model.addAttribute("reschCtgrCd", CommConst.LEVEL_EVAL_RESCH_CTGR_CD);
        model.addAttribute("menuType", menuType);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "resh/level_eval_list";
    }
    
    /***************************************************** 
     * 만족도조사 설문 상세
     * @param ReshVO 
     * @return "resh/level_eval_view"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value = "/Form/levelEvalView.do")
    public String levelEvalView(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String crsCreCd = vo.getCrsCreCd();
        String reschCd = vo.getReschCd();
        
        ReshVO reshVO = new ReshVO();
        reshVO.setCrsCreCd(crsCreCd);
        reshVO.setReschCd(reschCd);
        reshVO.setUserId(userId);
        reshVO = reshService.select(reshVO);
        
        model.addAttribute("reshVO", reshVO);
        
        // 강의실 활동 로그 등록
        logLessonActnHstyService.saveLessonActnHsty(request, crsCreCd, CommConst.ACTN_HSTY_RESCH, "["+reshVO.getReschTitle()+"] 만족도평가정보 확인");
        
        reshVO = new ReshVO();
        reshVO.setReschCd(reschCd);
        reshVO.setOrgId(orgId);
        List<EgovMap> joinDeviceList = reshAnsrService.listReshJoinDeviceStatus(reshVO);
        
        model.addAttribute("joinDeviceList", joinDeviceList);
        model.addAttribute("vo", vo);
        
        model.addAttribute("menuType", SessionInfo.getAuthrtGrpcd(request).contains("USR") ? "USR" : "PROF");
        model.addAttribute("orgId", SessionInfo.getOrgId(request));
        model.addAttribute("authGrpCd", SessionInfo.getAuthrtCd(request));
        model.addAttribute("crsCreCd", vo.getCrsCreCd());
        
        return "resh/level_eval_view";
    }
    
    /***************************************************** 
     * 강의평가/만족도조사 설문 참여 팝업 (학습자)
     * @param ReshVO 
     * @return "resh/popup/resh_join_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/evalReshJoinPop.do")
    public String evalReshJoinPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        String userId = SessionInfo.getUserId(request);
        String reschCd = vo.getReschCd();
        String reschCtgrCd = vo.getReschCtgrCd();
        
        vo.setUserId(userId);
        
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        
        List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
        
        // 강의평가
        if(CommConst.LECT_EVAL_RESCH_CTGR_CD.equals(StringUtil.nvl(reschCtgrCd))) {
            vo.setReschTypeCd("EVAL");
        }
        
        // 만족도 평가
        if(CommConst.LEVEL_EVAL_RESCH_CTGR_CD.equals(StringUtil.nvl(reschCtgrCd))) {
            vo.setReschTypeCd("LEVEL");
        }
        
        // 학생 답변 조회
        ReshVO reshVO = new ReshVO();
        reshVO.setReschCd(reschCd);
        reshVO.setUserId(userId);
        List<EgovMap> listReshAnswer = reshAnsrService.listReshAnswer(reshVO);
        if(listReshAnswer != null && listReshAnswer.size() > 0) {
            EgovMap reshAnswerMap = listReshAnswer.get(0);
            String answerUserId = (String) reshAnswerMap.get("userId");
            @SuppressWarnings("unchecked")
            List<EgovMap> answerList = (List<EgovMap>) reshAnswerMap.get("answerList");
            
            if(userId.equals(StringUtil.nvl(answerUserId))) {
                request.setAttribute("answerList", answerList);
            }
        }
        
        request.setAttribute("vo", vo);
        request.setAttribute("listReschPage", listReschPage);
        
        return "resh/popup/resh_join_pop";
    }
    
    /***************************************************** 
     * 강의평가 만족도조사 설문 제출 ajax (학습자)
     * @param ReshAnsrVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/evalReshJoin.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> evalReshJoin(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        //logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        Locale locale = LocaleUtil.getLocale(request);
        String orgId = SessionInfo.getOrgId(request);
        String userId = SessionInfo.getUserId(request);
        String reschCd = vo.getReschCd();
        String reschTypeCd = request.getParameter("reschTypeCd");
        String loginIp = SessionInfo.getLoginIp(request);
        String deviceType = SessionInfo.getDeviceType(request);
        
        try {
            // 세션 체크
            if(ValidationUtils.isEmpty(userId)) {
                throw new SessionBrokenException(messageSource.getMessage("common.system.no_auth", null, locale));
            }
            
            // 파라미터 체크
            if(ValidationUtils.isEmpty(reschCd) || ValidationUtils.isEmpty(reschTypeCd) || !("EVAL".equals(reschTypeCd) || "LEVEL".equals(reschTypeCd))) {
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            
            // 세션의 값과 화면의 값 체크 - 탭2개 이상 방지
            if(!userId.equals(StringUtil.nvl(vo.getUserId()))) {
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            
            // 설문기간 및 설문의 대상자(수강생 여부) 체크
            ReshVO reshVO = new ReshVO();
            reshVO.setOrgId(orgId);
            reshVO.setReschCd(reschCd);
            reshVO.setReschTypeCd(reschTypeCd);
            reshVO.setUserId(userId);
            EgovMap evalJoinCheck = reshService.selectEvalJoinCheck(reshVO);
            
            if(evalJoinCheck == null) {
                // 설문 정보 조회 중 에러가 발생하였습니다.
                throw new BadRequestUrlException(messageSource.getMessage("resh.error.info", null, locale));
            }
            
            reshVO = reshService.select(reshVO);
            // 강의실 활동 로그 등록
            String typeStr = "EVAL".equals(reschTypeCd) ? "강의평가" : "만족도평가";
            logLessonActnHstyService.saveLessonActnHsty(request, StringUtil.nvl(reshVO.getCrsCreCd()), CommConst.ACTN_HSTY_RESCH, "["+reshVO.getReschTitle()+"] "+typeStr+" 제출");
            
            // 설문참여대상 수강생 여부
            String stdYn = (String) evalJoinCheck.get("stdYn");
            // 유효한 설문기간 여부
            String reschDateYn = (String) evalJoinCheck.get("reschDateYn");
            // 설문 참여 여부
            String joinYn = (String) evalJoinCheck.get("joinYn");
            
            if(!"Y".equals(stdYn)) {
                // 설문 대상자가 아닙니다.
                throw new AccessDeniedException(messageSource.getMessage("resh.error.resh.not_user", null, locale));
            }
            
            if(!"Y".equals(reschDateYn)) {
                // 설문 참여 기간이 아닙니다.
                throw new AccessDeniedException(messageSource.getMessage("resh.error.resh.not_period", null, locale));
            }
            
            // 한양사이버대
            if("ORG0000001".equals(orgId)) {
                // TODO ERP의 강의평가 기간 체크 (TODO 세션값 체크)
            }
            
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setDeviceTypeCd(deviceType);
            vo.setConnIp(loginIp);
            
            if("Y".equals(joinYn)) {
                reshAnsrService.updateReshAnsr(vo, request);
            } else {
                reshAnsrService.insertReshAnsr(vo, request);
            }
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 설문 성적반영여부 수정 (교수)
     * @param ReshVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editScoreOpenYn.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editScoreOpenYn(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        
        String menuType = SessionInfo.getAuthrtGrpcd(request);
        String userId = SessionInfo.getUserId(request);
        String reschCd = vo.getReschCd();
        String scoreOpenYn = vo.getScoreOpenYn();
        
        try {
            // 파라미터 체크
            if(ValidationUtils.isEmpty(reschCd) || ValidationUtils.isEmpty(scoreOpenYn)) {
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            
            if(!(menuType.contains("PROF") || menuType.contains("ADM"))) {
                throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale));/* 페이지 접근 권한이 없습니다. */
            }
            
            if(ValidationUtils.isEmpty(userId)) {
                // 시스템 오류가 발생하였거나 비정상적인 접근입니다.<br><br>웹브라우저를 다시 시작하여 접속하세요.<br>오류가 지속되면 관리자에게 문의하세요.
                throw new BadRequestUrlException(messageSource.getMessage("common.system.error", null, locale));
            }
            
            vo.setMdfrId(userId);
            reshService.updateScoreOpenYn(vo);
            
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 설문 성적 반영비율 수정
     * @param ReshVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editScoreRatio.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editScoreRatio(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        
        try {
            vo.setMdfrId(userId);
            String[] reschCds = StringUtil.nvl(vo.getReschCds()).split("\\|");
            String[] scoreRatios = StringUtil.nvl(vo.getScoreRatios()).split("\\|");
            for(int i = 0; i < reschCds.length; i++) {
                vo.setReschCd(reschCds[i]);
                vo.setScoreRatio(Integer.valueOf(scoreRatios[i]));
                reshService.updateScoreRatio(vo);
            }
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 참여현황 팝업
     * @param ReshVO 
     * @return "resh/popup/resh_result_chart_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshResultChartPop.do")
    public String reshResultChartPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        String orgId = StringUtil.nvl(SessionInfo.getOrgId(request));
        ReshVO reshVo = reshService.select(vo);
        request.setAttribute("vo", reshVo);

        vo.setOrgId(orgId);
        List<EgovMap> joinDeviceList = reshAnsrService.listReshJoinDeviceStatus(vo);
        request.setAttribute("joinDeviceList", joinDeviceList);
        
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> reschAnswerList = reshAnsrService.listReshAnswerStatus(pageVo);
        request.setAttribute("reschAnswerList", reschAnswerList);
        
        List<Map<String, Object>> colorList = new ArrayList<Map<String, Object>>();
        String[] colorTitleList = {"bcOrange", "bcYellow", "bcOlive", "bcGreen", "bcLblue", "bcPurple", "bcViolet", "bcBrown", "bcGrey", "bcPink"};
        String[] colorCodeList = {"#f2711c", "#fbbd08", "#b5cc18", "#21ba45", "#deeaf6", "#a333c8", "#6435c9", "#a5673f", "#767676", "#e03997"};
        
        for(int i = 0; i < 10; i++) {
            Map<String, Object> colorMap = new HashMap<String, Object>();
            colorMap.put("title", colorTitleList[i]);
            colorMap.put("code", colorCodeList[i]);
            colorList.add(colorMap);
        }
        
        request.setAttribute("colorList", colorList);
        request.setAttribute("deviceList", orgCodeService.selectOrgCodeList("DEVICE_TYPE_CD"));
        
        return "resh/popup/resh_result_chart_pop";
    }
    
    /***************************************************** 
     * 설문 점수 수정
     * @param ReshAnsrVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/updateReshScore.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> updateReshScore(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setCrsCreCd(crsCreCd);
            resultVO = reshAnsrService.updateReshScore(vo);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 참여 현황 엑셀 다운로드
     * @param ExamVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshJoinUserExcelDown.do")
    public String reshJoinUserExcelDown(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("title", messageSource.getMessage("resh.label.status.join", null, locale));   // 참여목록
        map.put("sheetName", messageSource.getMessage("resh.label.status.join", null, locale));    // 참여목록
        map.put("excelGrid", vo.getExcelGrid());
        
        vo.setPagingYn("N");
        map.put("list", reshAnsrService.listReshJoinUser(vo).getReturnList());
        
        HashMap<String, Object> modelMap = new HashMap<String, Object>();
        modelMap.put("outFileName", messageSource.getMessage("resh.label.status.join", null, locale));   // 참여목록
        
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));
        model.addAllAttributes(modelMap);
        
        return "excelView";
    }
    
    /***************************************************** 
     * TODO 퀴즈 교수 메모 팝업 (교수)
     * @param ForumStareVO 
     * @return "resh/popup/resh_prof_memo"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshProfMemoPop.do")
    public String reshProfMemoPop(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(vo.getCrsCreCd());
        creCrsVO = crecrsService.selectCreCrs(creCrsVO);
        request.setAttribute("creCrsVO", creCrsVO);
        
        vo = reshAnsrService.selectProfMemo(vo);
        request.setAttribute("userVo", vo);
        
        return "resh/popup/resh_prof_memo";
    }
    
    /***************************************************** 
     * 설문 점수 수정
     * @param ReshAnsrVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/editReshProfMemo.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> editReshProfMemo(ReshAnsrVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        
        try {
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);
            vo.setCrsCreCd(crsCreCd);
            resultVO = reshAnsrService.updateReshUserMemo(vo);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("resh.error.memo.insert", null, locale));/* 메모 저장 중 에러가 발생하였습니다. */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 설문 엑셀 성적 등록 팝업
     * @param ReshVO 
     * @return "resh/popup/resh_score_excel_upload"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshScoreExcelUploadPop.do")
    public String reshScoreExcelUploadPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        request.setAttribute("vo", vo);
        
        return "resh/popup/resh_score_excel_upload";
    }
    
    /***************************************************** 
     * TODO 설문 성적 등록 샘플 엑셀 다운로드
     * @param ReshVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/quizScoreSampleDownload.do")
    public String quizScoreSampleDownload(ReshVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale = LocaleUtil.getLocale(request);
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        vo.setMdfrId(userId);
        vo.setRgtrId(userId);
        vo.setPagingYn("N");
        
        ProcessResultVO<EgovMap> resultList = reshAnsrService.listReshJoinUser(vo);
        
        String[] searchValues = {};
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", messageSource.getMessage("resh.label.resh.std.list", null, locale));  // 설문학습자목록
        map1.put("sheetName", messageSource.getMessage("resh.label.std.list", null, locale));   // 학습자목록
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", resultList.getReturnList());
     
        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", messageSource.getMessage("resh.label.std.list", null, locale));  // 학습자목록
        modelMap1.put("sheetName", messageSource.getMessage("resh.label.std.list", null, locale));    // 학습자목록
        modelMap1.put("list", resultList.getReturnList());
      
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleBigGrid(map1));
        model.addAllAttributes(modelMap1);
        
        return "excelView";
    }
    
    /***************************************************** 
     * TODO 설문 성적 엑셀 업로드 ajax
     * @param ReshAnsrVO 
     * @return ProcessResultVO<ReshAnsrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/uploadReshScoreExcel.do")
    @ResponseBody
    public ProcessResultVO<ReshAnsrVO> uploadReshScoreExcel(ReshAnsrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 사용자 접속상태 저장
        logUserConnService.saveUserConnState(request, CommConst.CONN_RESH);
        
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        String crsCreCd = vo.getCrsCreCd();
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setCrsCreCd(crsCreCd);
        ProcessResultVO<ReshAnsrVO> resultVO = new ProcessResultVO<ReshAnsrVO>();
        
        try {
            //등록된 파일 가져오기
            FileVO fileVO = new FileVO();
            fileVO.setUploadFiles(vo.getUploadFiles());
            fileVO.setCopyFiles(vo.getCopyFiles());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            //등록된 파일 저장 후 가져오기
            fileVO = sysFileService.addFile(fileVO);
            
            //엑셀 읽기위한 정보값 세팅
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("startRaw", 5);
            map.put("excelGrid", vo.getExcelGrid());
            map.put("fileVO", fileVO);
            map.put("searchKey", "excelUpload");
            
            //엑셀 리더
            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(map);
               
            //읽어온 값으로 update
            reshAnsrService.updateExampleExcelScore(vo, list);
            resultVO.setResult(1);
            resultVO.setMessage(messageSource.getMessage("resh.alert.save.score", null, locale));/* 점수 저장이 완료되었습니다. */
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 학습자 설문지 보기 팝업
     * @param ReshVO 
     * @return "resh/popup/resh_paper_view_pop"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/reshPaperViewPop.do")
    public String reshPaperViewPop(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ReshPageVO pageVo = new ReshPageVO();
        pageVo.setReschCd(vo.getReschCd());
        List<ReshPageVO> listReschPage = reshQstnService.listReshPage(pageVo);
        
        ReshAnsrVO reshAnsrVO = new ReshAnsrVO();
        reshAnsrVO.setUserId(vo.getUserId());
        reshAnsrVO.setReschCd(vo.getReschCd());
        
        request.setAttribute("vo", vo);
        request.setAttribute("listReschPage", listReschPage);
        request.setAttribute("answerList", reshAnsrService.listReshMyAnswer(reshAnsrVO));
        
        return "resh/popup/resh_paper_view_pop";
    }
    
    /***************************************************** 
     * 강의평가/만족도조사 url
     * @param ReshVO 
     * @return ProcessResultVO<DefaultVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/evalLectReschCrypto.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> evalLectReschCrypto(ReshVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        Locale locale   = LocaleUtil.getLocale(request);
        String userId   = StringUtil.nvl(SessionInfo.getUserId(request));
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<>();
        
        try {
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
            creCrsVO = crecrsService.selectCreCrs(creCrsVO);
            String reshParam = "{\"sGbn\":\""+creCrsVO.getUniCd()+"\",\"sYear\":\""+creCrsVO.getCreYear()+"\",\"sSmt\":\""+creCrsVO.getCreTerm()+"\",\"sCuriNum\":\""+creCrsVO.getCrsCreCd()+"\",\"sCuriCls\":\""+creCrsVO.getDeclsNo()+"\",\"sStudentCD\":\""+userId+"\"}";
            reshParam = (new Base64()).encodeToString(reshParam.getBytes());
            String reshUrl = CommConst.EXT_URL_LSNEVAL+reshParam;
            DefaultVO returnVO = new DefaultVO();
            returnVO.setGoUrl(reshUrl);
            resultVO.setReturnVO(returnVO);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
}
