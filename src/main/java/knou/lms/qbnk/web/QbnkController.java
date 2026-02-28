package knou.lms.qbnk.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.qbnk.service.QbnkCtgrService;
import knou.lms.qbnk.service.QbnkQstnService;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVO;

@Controller
@RequestMapping(value="/qbnk")
public class QbnkController extends ControllerBase {

	@Resource(name="qbnkCtgrService")
	private QbnkCtgrService qbnkCtgrService;

	@Resource(name="qbnkQstnService")
	private QbnkQstnService qbnkQstnService;

	/**
	* 교수문제은행분류목록조회
	*
	* @param sbjctId 		과목아이디
	* @param upQbnkCtgrId 	상위문제은행분류아이디
	* @param qbnkQstnGbncd 	문제은행문항구분코드
	* @return 문제은행분류 목록
	* @throws Exception
	*/
    @RequestMapping(value="/profQbnkCtgrListAjax.do")
    @ResponseBody
    public ProcessResultVO<QbnkCtgrVO> profQbnkCtgrListAjax(QbnkCtgrVO vo, ModelMap map, HttpServletRequest request) throws Exception {

        ProcessResultVO<QbnkCtgrVO> resultVO = new ProcessResultVO<QbnkCtgrVO>();

        try {
            List<QbnkCtgrVO> qbnkList = qbnkCtgrService.profQbnkCtgrList(vo);
            resultVO.setReturnList(qbnkList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
        }
        return resultVO;
    }

    /**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항목록
     * @throws Exception
     */
    @RequestMapping(value="/profQstnCopyQbnkQstnListAjax.do")
    @ResponseBody
    public ProcessResultVO<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo, ModelMap map, HttpServletRequest request) throws Exception {

    	ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();

    	try {
    		List<EgovMap> qbnkQstnList = qbnkQstnService.profQstnCopyQbnkQstnList(vo);
    		resultVO.setReturnList(qbnkQstnList);
    		resultVO.setResult(1);
    	} catch(Exception e) {
    		resultVO.setResult(-1);
    		resultVO.setMessage(getMessage("exam.error.list")); /* 리스트 조회 중 에러가 발생하였습니다. */
    	}
    	return resultVO;
    }

}
