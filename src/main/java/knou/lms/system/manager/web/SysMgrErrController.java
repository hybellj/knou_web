package knou.lms.system.manager.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.dao.OrgInfoDAO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.system.manager.service.SysMgrErrService;
import knou.lms.system.manager.vo.SysMgrErrVO;
import knou.lms.user.dao.UsrDeptCdDAO;
import knou.lms.user.vo.UsrDeptCdVO;

@Controller
@RequestMapping(value = "/sys/sysMgr")
public class SysMgrErrController extends ControllerBase {

    private static final Logger LOGGER = LoggerFactory.getLogger(SysMgrErrController.class);
    
    @Resource(name="sysMgrErrService")
    private SysMgrErrService sysMgrErrService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    // 기관 Select Box 세팅용
    @Resource(name="orgInfoDAO")
    private OrgInfoDAO orgInfoDAO;

    // 학과/부서 Select Box 세팅용
    @Resource(name="usrDeptCdDAO")
    private UsrDeptCdDAO usrDeptCdDAO;
    
    /***************************************************** 
     * 시스템 오류현황 페이지 이동
     * @param vo
     * @param model
     * @param request
     * @return "err_list"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/wholSysErrorListView.do")
    public String sysMgrErrForm(SysMgrErrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        String authrtCd = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));

        String orgId = vo.getOrgId();
        String deptId = vo.getDeptId();
        String stdntNo = vo.getStdntNo();
        String usernm = vo.getUserNm();
        
        if(!authrtCd.contains("ADM")) {
            throw new AccessDeniedException(messageSource.getMessage("system.fail.auth.msg", null, locale)); // 페이지 접근 권한이 없습니다.
        }

        SysMgrErrVO sysMgrErrVO = new SysMgrErrVO();
        sysMgrErrVO.setOrgId(orgId);
        sysMgrErrVO.setDeptId(deptId);
        sysMgrErrVO.setStdntNo(stdntNo);
        sysMgrErrVO.setUserNm(usernm); 

        UsrDeptCdVO deptVO = new UsrDeptCdVO();

        List<OrgInfoVO> orgList = orgInfoDAO.listActiveOrg();       
        List<UsrDeptCdVO> deptList = usrDeptCdDAO.list(deptVO);

        // 기관 리스트
        model.addAttribute("orgList", orgList);
        // 학과/부서 리스트
        model.addAttribute("deptList", deptList);
        model.addAttribute("vo", vo);
        model.addAttribute("sysMgrErrVO", sysMgrErrVO);
        System.out.println("model is : " + model);

        return "sys/mgr/err_list";
    }

    /***************************************************** 
     * 시스템 오류현황 목록 페이징
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysMgrErrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysErrList.do")
    @ResponseBody
    public ProcessResultVO<SysMgrErrVO> listSysErrPaging(SysMgrErrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysMgrErrVO> resultVO = new ProcessResultVO<>();
        String orgId = vo.getOrgId();
        String deptId = vo.getDeptId();
        String stdntNo = vo.getStdntNo();
        String usernm = vo.getUsernm();

        vo.setOrgId(orgId);
        vo.setDeptId(deptId);
        vo.setStdntNo(stdntNo);
        vo.setUserNm(usernm);

        try {       
            resultVO = sysMgrErrService.listSysErrPaging(vo);
            resultVO.setResultSuccess(); // resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResultFailed(); // resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        return resultVO;
    }

    /*****************************************************
     * 시스템 오류현황 상세 조회
     * @param vo
     * @param model
     * @param request
     * @return ProcessResultVO<SysMgrErrVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysErrDtl.do")
    @ResponseBody
    public ProcessResultVO<SysMgrErrVO> selectSysErrDtl(SysMgrErrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysMgrErrVO> resultVO = new ProcessResultVO<>();
        try {
            // 필수 파라미터 체크
            String sysErrMsgId = vo.getSysErrMsgId();

            if(sysErrMsgId == null || sysErrMsgId.isEmpty()) {
                resultVO.setResultFailed(); // resultVO.setResult(-1);
                resultVO.setMessage("에러 메시지 ID가 필요합니다");
                return resultVO;
            }

            SysMgrErrVO sysErrVO = sysMgrErrService.selectSysErrDtl(vo);

            if(sysErrVO == null) {
                resultVO.setResultFailed(); // resultVO.setResult(-1);
                resultVO.setMessage("해당 오류 정보를 찾을 수 없습니다");
            } else {
                resultVO.setReturnVO(sysErrVO);
                resultVO.setResultSuccess(); // resultVO.setResult(1);
                resultVO.setMessage("성공 메시지");
            }
        } catch(Exception e) {
            LOGGER.error("시스템 오류 상세 조회 실패", e);
            resultVO.setResultFailed(); // resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage());
        }

        return resultVO;
    }

    /*****************************************************
     * 시스템 오류현황 엑셀 다운로드
     * @param vo
     * @param model
     * @param request
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/sysErrListExcelDown.do")
    public String excelSysErrList(SysMgrErrVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        // 1. 시스템 오류 현황 목록 조회
        List<SysMgrErrVO> list = sysMgrErrService.listSysErr(vo);

        // 2. Excel 데이터 세팅
        // String title = getMessage("bbs.label.viewr_list"); // message-bbs_ko.properties 에 등록된 메시지를 사용함
        String title = "시스템오류현황"; // 이 부분 확인해보고 수정 예정

        HashMap<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("sheetName", title);
        map.put("excelGrid", vo.getExcelGrid());
        map.put("list", list);
        map.put("ext", ".xlsx(big)");

        // 3. 현재 날짜 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());

        // 4. Excel 파일 생성 (파일명은 2번의 title + 3번의 날짜 생성된 값을 합쳤음)
        HashMap<String, Object> modelMap = new HashMap<>();
        modelMap.put("outFileName", title + "_" + currentDate);

        // 5. 엑셀화 작업
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap.put("workbook", excelUtilPoi.simpleGrid(map));

        model.addAllAttributes(modelMap);

        return "excelView";
    }

}

