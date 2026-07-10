package knou.lms.user.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.PageInfo;
import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.CurrentUser;
import knou.lms.user.service.UsrDeptCdService;

import java.util.ArrayList;

@Controller
public class UserController extends ControllerBase {
	
	 @Resource(name="usrDeptCdService")
	 private UsrDeptCdService usrDeptCdService;
	
	 @RequestMapping(value={"/admByOrgDeptList.do", "/byOrgDeptList.do"})
	 @ResponseBody
	 public ProcessResultVO<EgovMap> admByOrgDeptList( PageInfo pageInfo, @CurrentUser UserContext userCtx, 
    		ModelMap model, HttpServletRequest request) throws Exception {
//		 return new ProcessResultVO<EgovMap>().setReturnList(usrDeptCdService.admByOrgDeptList(pageInfo)).setResultSuccess();
		 return new ProcessResultVO<EgovMap>().setReturnList(new ArrayList<>()).setResultSuccess();
     }
}