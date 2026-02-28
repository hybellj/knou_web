package knou.lms.msg.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import knou.framework.common.IdPrefixType;
import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.msg.dao.MsgMgrDAO;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.org.dao.OrgCodeCtgrDAO;
import knou.lms.org.dao.OrgCodeLangDAO;
import knou.lms.org.vo.OrgCodeLangVO;

@Service("msgMgrService")
public class MsgMgrServiceImpl implements CmmnCdService {

	/** cmmnCdDAO */
	@Resource(name = "msgMgrDAO")
	private MsgMgrDAO msgMgrDAO;

	private final HashMap<String, List<CmmnCdVO>> codeCache = new HashMap<String, List<CmmnCdVO>>();
	private String codeVerDate = "19000101000001";

	@Override
	public List<CmmnCdVO> selectCmmnCdList(String cd) throws Exception {

		// 변경이 감지되면 캐쉬를 비운다.
		if (DateTimeUtil.getIntervalSecond(codeVerDate) > 360) {
			// -- 케시 검사한지 1시간이 지난 경우, 코드 검사 시간이 1시간이 지나지 않은 경우는 코드 버전을 체크 하지 않는다.
			// if(isCodeChanged()) {
			// this.codeCache.clear();
			// this.codeVersion = cmmnCdMapper.selectVersion();
			// log.debug("[ 코드 변경내용 감지.. 캐쉬를 초기화 합니다. ]");
			// }
			codeVerDate = DateTimeUtil.getCurrentString(); // -- 현재의 시간을 셋팅함.
		}

		// 메모리에 로드되어 있지 않으면 DB에서 로딩..
		if (!this.codeCache.containsKey(cd)) {
			// CmmnCdVO cmmnCdVo = new CmmnCdVO();
			// cmmnCdVo.setCd(cd);
			this.codeCache.put(cd, listCode(cd, true));
			// log.debug("캐쉬 적중 실패 DB에서 직접 CODE를 조회합니다. cd [" + cd + "]");
		} else {
			// log.debug("캐쉬 적중 성공 메모리에서 CODE를 불러옵니다. cd [" + cd + "]");
		}
		return this.codeCache.get(cd);
	}

	/**
	 * 코드 정보의 목록를 반환한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return ProcessResultListDTO<CmmnCdVO>
	 * @throws Exception
	 */
	@Override
	public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String upCd) throws Exception {
		return this.listCode(orgId, upCd, true);
	}

	@Override
	public CmmnCdVO viewCode(String orgId, String upCd, String cd, String langCd) throws Exception {

		// 코드 정보 조회는 다음이 조건을 가진다.
		// 1. params로 넘어온 langCd값을 기준으로 조회
		// 2. 해당 값이 존재하지 않다면, langCd=en (영문) 값으로 조회
		// 3. 영문 값도 존재하지 않다면, langCd=ko (한글, default) 값으로 조회
		// 4. 한글 값으로도 존재하지 않다면, 공백값을 넘겨줄 것이며, error 로그를 쌓는다.
		/*
		 * OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
		 * orgCodeLangVO.setOrgId(orgId); orgCodeLangVO.setCodeCtgrCd(codeCtgrCd);
		 * orgCodeLangVO.setCodeCd(codeCd); orgCodeLangVO.setLangCd(langCd);
		 * 
		 * return checkOrgCodeLangData(orgCodeLangDAO.select(orgCodeLangVO), "en");
		 */
		CmmnCdVO cmmnVO = new CmmnCdVO();
		return cmmnVO;
	}

	/**
	 * 코드 분류 페이징 목록을 조회한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @param pageIndex
	 * @param listScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */

	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex, int listScale) throws Exception {
		return this.listCmmnCdPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
	}

	@Override
	public List<CmmnCdVO> selectCmmnCdList(CreCrsVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<CmmnCdVO> listCode(String orgId, boolean use) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String codeCtgrCd, boolean use) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String codeCtgrCd, String langCd, boolean use)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCd(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex, int listScale, int pageScale)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int countUpCd(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int addUpCd(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public CmmnCdVO viewUpCd(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int editUpCd(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int removeUpCd(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodePageing(CmmnCdVO vo, int pageIndex, int listScale) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodePageing(CmmnCdVO vo, int pageIndex, int listScale, int pageScale)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int countCode(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int addCode(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public CmmnCdVO viewCode(String orgId, String upCd, String cd) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public CmmnCdVO viewCode(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int editCode(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int removeCode(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<CmmnCdVO> list(CreCrsVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<CmmnCdVO> list(String codeCtgrCd) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<CmmnCdVO> list(CmmnCdVO vo) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String codeCtgrCd) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String codeCtgrCd, boolean use) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String codeCtgrCd, String langCd, boolean use)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<CmmnCdVO> getCmmnCdList(String codeCtgrCd) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
