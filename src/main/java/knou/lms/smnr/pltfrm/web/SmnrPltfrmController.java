package knou.lms.smnr.pltfrm.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.smnr.pltfrm.facade.SmnrPltfrmFacadeService;

@Controller
@RequestMapping(value="/smnr/pltfrm")
public class SmnrPltfrmController extends ControllerBase {

	@Resource(name="smnrPltfrmFacadeService")
	private SmnrPltfrmFacadeService smnrPltfrmFacadeService;

	/**
     * 대기중온라인플랫폼사용자수조회
     *
     * @param pltfrmGbncd		플랫폼구분코드
	 * @param meetngrmSdttm		회의실시작일시
	 * @param meetngrmEdttm		회의실종료일시
     * @return 대기중온라인플랫폼사용자수
     * @throws Exception
     */
    @RequestMapping(value="/pendingOnlnPltfrmUserCntSelectAjax.do")
    @ResponseBody
    public ProcessResultVO<DefaultVO> pendingOnlnPltfrmUserCntSelectAjax(@RequestParam(value="subSmnrs", defaultValue="[]") String subSmnrsStr, ModelMap model, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String orgId  = StringUtil.nvl(SessionInfo.getOrgId(request));

        try {
        	ObjectMapper mapper = new ObjectMapper();
        	List<Map<String, Object>> subSmnrs = mapper.readValue(subSmnrsStr, new TypeReference<List<Map<String, Object>>>() {});
        	subSmnrs.forEach(map -> map.put("orgId", orgId));
            resultVO.setResult(smnrPltfrmFacadeService.getPendingOnlnPltfrmUserCntSelect(subSmnrs));
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("정보 조회 중 에러가 발생하였습니다.");
        }

        return resultVO;
    }

}
