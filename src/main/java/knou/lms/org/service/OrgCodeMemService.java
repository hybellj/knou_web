package knou.lms.org.service;

import java.util.List;

import knou.lms.org.vo.OrgCodeVO;

public interface OrgCodeMemService {

	/**
	 * 기관코드 리스트를 반환한다.
	 *
	 * @param codeCtgrCd
	 * @return
	 */
	public abstract List<OrgCodeVO> getOrgCodeList(String codeCtgrCd, String orgId) throws Exception;

	   /**
     * 메모리에서 기관 코드 정보를 검색하여 반환한다.
     * @param codeCtrgCd
     * @param codeCd
     * @return
     * @throws Exception
     */
    public abstract OrgCodeVO getCode(String codeCtrgCd, String codeCd , String orgId) throws Exception;
    
}