package knou.lms.sys.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sys.dao.SysCodeDAO;
import knou.lms.sys.dao.SysCodeLangDAO;
import knou.lms.sys.service.SysCodeService;
import knou.lms.sys.vo.SysCodeLangVO;
import knou.lms.sys.vo.SysCodeVO;

@Service("sysCodeService")
public class SysCodeServiceImpl extends ServiceBase implements SysCodeService {

    @Resource(name="sysCodeDAO")
    private SysCodeDAO sysCodeDAO;
    
    @Resource(name="sysCodeLangDAO")
    private SysCodeLangDAO sysCodeLangDAO;

    /**
     * 코드 정보의 목록를 반환한다.
     * @param SysCodeCtgrVO
     * @return ProcessResultVO<SysCodeVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<SysCodeVO> listCode(String codeCtgrCd) throws Exception {
        return this.listCode(codeCtgrCd, true);
    }

    /**
     * 코드 정보의 목록를 반환한다.
     * @param SysCodeCtgrVO
     * @return ProcessResultVO<SysCodeVO>
     * @throws Exception
     */
    @Override
    public ProcessResultVO<SysCodeVO> listCode(String codeCtgrCd, boolean use) throws Exception {
        List<SysCodeVO> codeList = listCodeByDB(codeCtgrCd).getReturnList();
        ProcessResultVO<SysCodeVO> resultVO = new ProcessResultVO<SysCodeVO>();
        List<SysCodeVO> returnList = new ArrayList<SysCodeVO>();
        for(SysCodeVO scvo : codeList) {
            if(use) {
                if("Y".equals(scvo.getUseYn())) {
                    returnList.add(scvo);
                }
            } else {
                returnList.add(scvo);
            }
        }
        resultVO.setResult(1);
        resultVO.setReturnList(returnList);
        return resultVO;
    }

    @Override
    public ProcessResultVO<SysCodeVO> listCodeByDB(String codeCtgrCd) throws Exception {
        SysCodeVO scvo = new SysCodeVO();
        scvo.setCmmnCdId(codeCtgrCd);
        
        List<SysCodeVO> codeList = sysCodeDAO.list(scvo);
        ProcessResultVO<SysCodeVO> resultVO = new ProcessResultVO<SysCodeVO>();
        List<SysCodeVO> returnList = new ArrayList<SysCodeVO>();
        for(SysCodeVO svo : codeList) {
            SysCodeLangVO sclvo = new SysCodeLangVO();
            sclvo.setCodeCtgrCd(svo.getCmmnCdId());
            sclvo.setCodeCd(svo.getCd());
            List<SysCodeLangVO> codeLangList = sysCodeLangDAO.list(sclvo);
            svo.setCodeLangList(codeLangList);
            returnList.add(svo);
        }
        resultVO.setResult(1);
        resultVO.setReturnList(returnList);
        return resultVO;
    }

    // 업무구분  목록
	@Override
	public ProcessResultListVO<SysCodeVO> jobSchCalendarCtgrNmList(String orgId) throws Exception {
		ProcessResultListVO<SysCodeVO> resultList = new ProcessResultListVO<SysCodeVO>();
		
		try {
			List<SysCodeVO> calendarCtgrNmList = sysCodeDAO.jobSchCalendarCtgrNmList(orgId);
			resultList.setResult(1);
			resultList.setReturnList(calendarCtgrNmList);
		} catch (Exception e) {
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
	}
    
}
