package knou.lms.org.service.impl;

import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import knou.framework.common.SessionInfo;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeVO;

/**
 *  <b>공통 - 공통 기관 코드 메모리 서비스</b> 영역  Service 클래스
 * @author Jamfam
 *
 */
@Service("orgCodeMemService")
public class OrgCodeMemServiceImpl extends EgovAbstractServiceImpl implements OrgCodeMemService {

    /**
     * 내부 변수 [캐쉬 저장소]
     * key : codeCtgrCd.orgId
     */
    private final Hashtable<String, List<OrgCodeVO>> cache = new Hashtable<String, List<OrgCodeVO>>();

    /**
     * 캐쉬저장소의 유효성을 판단하는 버젼값
     */
    private int version = -1;
    private int compareVersion = -2;
    
	@Autowired
	private OrgCodeService orgCodeService;
	
	/**
	 * 기관코드 리스트를 반환한다.
	 *
	 * @param codeCtgrCd
	 * @return
	 */
	@Override
	public synchronized List<OrgCodeVO> getOrgCodeList(String codeCtgrCd, String orgId) throws Exception {
	    
	    HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        String langCd = SessionInfo.getLocaleKey(request);
        OrgCodeVO ocvo = new OrgCodeVO();
        ocvo.setUpCd(codeCtgrCd);
        ocvo.setOrgId(orgId);

        String menuKey = codeCtgrCd+"."+orgId+"."+langCd;

        if(this.isCacheChanged(ocvo)) {
            this.cache.clear();
            this.version += 1;
            this.compareVersion = this.version;
        }
        
        if(!this.cache.containsKey(menuKey)) {
            List<OrgCodeVO> vo = orgCodeService.listCode(orgId,codeCtgrCd, langCd, true).getReturnList();

            for(OrgCodeVO ovo : vo) {
                ovo.setCdnm(ovo.getCodeLangVO().getCdnm());
            }
            this.cache.put(menuKey, vo); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }
        return this.cache.get(menuKey);
	}
	
	/**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    @SuppressWarnings("unused")
    private boolean isCacheChanged(OrgCodeVO vo) throws Exception {
        return (this.version != this.compareVersion) ? true : false;
    }

    /**
     * 버전값이 변경되었음을 저장한다.
     */
    @SuppressWarnings("unused")
    private void setCacheChanged(OrgCodeVO vo) throws Exception {
        int beforeVersion = this.version;
        this.cache.clear();
        this.compareVersion = beforeVersion+1;
    }
    
    /**
     * 메모리에서 기관 코드 정보를 검색하여 반환한다.
     * @param codeCtrgCd
     * @param codeCd
     * @return
     * @throws Exception
     */
    @Override
    public OrgCodeVO getCode(String codeCtrgCd, String codeCd, String orgId) throws Exception {
        
        List<OrgCodeVO> codeList = getOrgCodeList(codeCtrgCd,orgId);
        OrgCodeVO returnVO = null;
        
        for(OrgCodeVO codeVO : codeList){
            if((codeVO.getCd()).equals(codeCd)) {
                returnVO = codeVO;
                break;
            }
        }
        return returnVO;
    }
}
