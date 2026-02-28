package knou.lms.cmmn.service.Impl;

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
import knou.lms.cmmn.dao.CmmnCdDAO;
import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.org.dao.OrgCodeCtgrDAO;
import knou.lms.org.dao.OrgCodeLangDAO;
import knou.lms.org.vo.OrgCodeLangVO;

@Service("cmmnCdService")
public class CmmnCdServiceImpl implements CmmnCdService {

	/** cmmnCdDAO */
	@Resource(name = "cmmnCdDAO")
	private CmmnCdDAO cmmnCdDAO;

	/** orgCodeLangDAO */
	@Resource(name = "orgCodeLangDAO")
	private OrgCodeLangDAO orgCodeLangDAO;

	/** orgCodeCtgrDAO */
	@Resource(name = "orgCodeCtgrDAO")
	private OrgCodeCtgrDAO orgCodeCtgrDAO;

	private final HashMap<String, List<CmmnCdVO>> codeCache = new HashMap<String, List<CmmnCdVO>>();
	private String codeVerDate = "19000101000001";

	@Override
	public List<CmmnCdVO> selectCmmnCdList(CreCrsVO vo) throws Exception {

		CmmnCdVO cmmnCdVO = new CmmnCdVO();
		cmmnCdVO.setOrgId("ORG0000001");
		cmmnCdVO.setUseyn("Y");
		cmmnCdVO.setUpCd("CRS_TYCD");
		List<CmmnCdVO> crsTypeList = cmmnCdDAO.selectCmmnCdList(cmmnCdVO);

		return crsTypeList;
	}

	@Override
	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO vo) throws Exception {

		List<CmmnCdVO> cmmnCdList = cmmnCdDAO.selectCmmnCdList(vo);

		return cmmnCdList;
	}

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

	@Override
	public List<CmmnCdVO> listCode(String cd, boolean use) throws Exception {

		List<CmmnCdVO> codeList = listCodeByDB(cd);
		List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();

		for (CmmnCdVO scvo : codeList) {
			if (use) {
				if ("Y".equals(scvo.getUseyn())) {
					returnList.add(scvo);
				}
			} else {
				returnList.add(scvo);
			}
		}
		return returnList;
	}

	public List<CmmnCdVO> listCodeByDB(String cd) throws Exception {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
		String orgId = null;

		if (request != null) {
			orgId = SessionInfo.getOrgId(request);
		}

		CmmnCdVO scvo = new CmmnCdVO();
		scvo.setCd(cd);
		scvo.setOrgId(orgId);

		List<CmmnCdVO> codeList = cmmnCdDAO.selectCmmnCdList(scvo);
		// TO-DO JY Lang테이블 조회 임시 주석
		/*
		 * List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();
		 * 
		 * for(CmmnCdVO svo : codeList) { OrgCodeLangVO sclvo = new OrgCodeLangVO();
		 * sclvo.setUpCd(svo.getUpCd()); sclvo.setCd(svo.getCd()); List<OrgCodeLangVO>
		 * codeLangList = orgCodeLangDAO.list(sclvo); svo.setCodeLangList(codeLangList);
		 * returnList.add(svo); } return returnList;
		 */
		return codeList;
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

	/**
	 * 코드 정보의 목록를 반환한다.
	 * 
	 * @param upCd
	 * @return ProcessResultListDTO<CmmnCdVO>
	 * @throws Exception
	 */
	@Override
	public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String upCd, boolean use) throws Exception {
		// List<CmmnCdVO> codeList = listCodeWithCache(upCd);
		CmmnCdVO cmmnCdVO = new CmmnCdVO();
		cmmnCdVO.setOrgId(orgId);
		cmmnCdVO.setUpCd(upCd);

		List<CmmnCdVO> codeList = cmmnCdDAO.list(cmmnCdVO);

		ProcessResultListVO<CmmnCdVO> result = new ProcessResultListVO<CmmnCdVO>();
		List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();
		for (CmmnCdVO ocvo : codeList) {
			if (use) {
				if ("Y".equals(ocvo.getUseyn()))
					returnList.add(ocvo);
			} else {
				returnList.add(ocvo);
			}
		}

		result.setResult(1);
		result.setReturnList(returnList);

		return result;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCode(String orgId, String upCd, String langCd, boolean use)
			throws Exception {

		// tb_org_code에 조회헤서 사용 여부를 확인한다. Y값인 경우에만 사용한다.
		CmmnCdVO cmmnCdVO = new CmmnCdVO();
		cmmnCdVO.setOrgId(orgId);
		cmmnCdVO.setUpCd(upCd);
		cmmnCdVO.setLangCd(langCd);

		List<CmmnCdVO> cmmnCdList = cmmnCdDAO.list(cmmnCdVO); // org table 조회

		ProcessResultListVO<CmmnCdVO> result = new ProcessResultListVO<CmmnCdVO>();
		List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();

		for (CmmnCdVO vo : cmmnCdList) {
			if (use) {
				// 사용값이 Y인지 확인한다. Y값이라면 org code lang 테이블을 조회한다.
				if ("Y".equals(vo.getUseyn())) {
					// TO-DO JY Lang테이블 조회 임시 주석
					/*
					 * OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
					 * orgCodeLangVO.setOrgId(orgId); orgCodeLangVO.setCd(vo.getCd());
					 * orgCodeLangVO.setUpCd(upCd); orgCodeLangVO.setLangCd(langCd);
					 * 
					 * vo.setCodeLangVO(checkCmmnCdLangData(orgCodeLangDAO.select(orgCodeLangVO),
					 * "en"));
					 */
					returnList.add(vo);
				}
			} else {
				returnList.add(vo);
			}
		}

		result.setResult(1);
		result.setReturnList(returnList);
		return result;
	}

	/**
	 * 코드의 정보를 조회한다.
	 * 
	 * @param cdCtgrCd
	 * @param cdCd
	 * @return CmmnCdVO
	 */
	@Override
	public CmmnCdVO viewCode(CmmnCdVO vo) throws Exception {
		return cmmnCdDAO.select(vo);
	}

	@Override
	public CmmnCdVO viewCode(String orgId, String upCd, String cd) throws Exception {

		CmmnCdVO cmmCdVO = new CmmnCdVO();
		cmmCdVO.setOrgId(orgId);
		cmmCdVO.setUpCd(upCd);
		cmmCdVO.setCd(cd);
		cmmCdVO = cmmnCdDAO.select(cmmCdVO);

		/*
		 * OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
		 * orgCodeLangVO.setOrgId(orgId); orgCodeLangVO.setUpCd(upCd);
		 * orgCodeLangVO.setCd(cd);
		 * 
		 * List<OrgCodeLangVO> codeLangList = orgCodeLangDAO.list(orgCodeLangVO);
		 * 
		 * if(codeLangList != null && !codeLangList.isEmpty() && codeLangList.size() >
		 * 0) { cmmnCdVO.setCodeLangList(codeLangList); }
		 */

		return cmmCdVO;
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
	 * 상위 코드 전체 목록을 조회한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return ProcessResultListVO
	 * @throws Exception
	 */

	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCd(CmmnCdVO vo) throws Exception {

		ProcessResultListVO<CmmnCdVO> resultList = new ProcessResultListVO<CmmnCdVO>();

		try {
			List<CmmnCdVO> upCdList = cmmnCdDAO.list(vo);
			resultList.setResult(1);
			resultList.setReturnList(upCdList);
		} catch (Exception e) {
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
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

	/**
	 * 코드 분류 페이징 목록을 조회한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @param pageIndex
	 * @param listScale
	 * @param pageScale
	 * @return ProcessResultListVO
	 * @throws Exception
	 */

	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex, int listScale, int pageScale)
			throws Exception {

		ProcessResultListVO<CmmnCdVO> resultList = new ProcessResultListVO<CmmnCdVO>();

		try {
			/** start of paging */
			PagingInfo paginationInfo = new PagingInfo();
			paginationInfo.setCurrentPageNo(pageIndex);
			paginationInfo.setRecordCountPerPage(listScale);
			paginationInfo.setPageSize(pageScale);

			vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
			vo.setLastIndex(paginationInfo.getLastRecordIndex());

			// 전체 목록 수
			int totalCount = cmmnCdDAO.count(vo);
			paginationInfo.setTotalRecordCount(totalCount);

			List<CmmnCdVO> upCdRootList = cmmnCdDAO.listPageing(vo);
			resultList.setResult(1);
			resultList.setReturnList(upCdRootList);
			resultList.setPageInfo(paginationInfo);

		} catch (Exception e) {
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
	}

	/**
	 * 코드 카테고리 수를 조회 한다.
	 *
	 * @param vo
	 * @return int
	 * @throws Exception
	 */

	@Override
	public int countUpCd(CmmnCdVO vo) throws Exception {
		return cmmnCdDAO.count(vo);
	}

	/**
	 * 코드 분류 정보를 등록한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return String
	 * @throws Exception
	 */

	@Override
	public int addUpCd(CmmnCdVO vo) throws Exception {
		vo.setCmmnCdId(IdGenUtil.genNewId(IdPrefixType.CMCOD));
		return cmmnCdDAO.insert(vo);
	}

	/**
	 * 코드 분류 상세 정보를 조회한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return OrgCodeCtgrVO
	 * @throws Exception
	 */
	@Override
	public CmmnCdVO viewUpCd(CmmnCdVO vo) throws Exception {
		return cmmnCdDAO.select(vo);
	}

	/**
	 * 코드 분류 정보를 수정한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return int
	 * @throws Exception
	 */
	@Override
	public int editUpCd(CmmnCdVO vo) throws Exception {
		return cmmnCdDAO.update(vo);
	}

	/**
	 * 코드 분류 정보를 삭제 한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return int
	 * @throws Exception
	 */

	@Override
	public int removeUpCd(CmmnCdVO vo) throws Exception {

		// 분류 하위의 모든 언어 정보를 삭제함.
		/*
		 * OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
		 * orgCodeLangVO.setOrgId(orgId); orgCodeLangVO.setUpCd(upCd);
		 * orgCodeLangDAO.deleteAllByCtgr(orgCodeLangVO);
		 */

		// 분류 하위의 모든 코드 정보를 삭제함.
		cmmnCdDAO.deleteAll(vo);
		return cmmnCdDAO.delete(vo);
	}

	/**
	 * 코드 페이징 목록을 가져온다.
	 */
	@Override
	public ProcessResultListVO<CmmnCdVO> listCmmnCdPageing(CmmnCdVO vo, int pageIndex) throws Exception {
		return this.listCodePageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodePageing(CmmnCdVO vo, int pageIndex, int listScale) throws Exception {
		return this.listCodePageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodePageing(CmmnCdVO vo, int pageIndex, int listScale, int pageScale)
			throws Exception {
		ProcessResultListVO<CmmnCdVO> resultList = new ProcessResultListVO<CmmnCdVO>();

		try {
			/** start of paging */
			PagingInfo paginationInfo = new PagingInfo();
			paginationInfo.setCurrentPageNo(pageIndex);
			paginationInfo.setRecordCountPerPage(listScale);
			paginationInfo.setPageSize(pageScale);

			vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
			vo.setLastIndex(paginationInfo.getLastRecordIndex());

			// 전체 목록 수
			int totalCount = cmmnCdDAO.count(vo);
			paginationInfo.setTotalRecordCount(totalCount);

			List<CmmnCdVO> returnList = cmmnCdDAO.listPageing(vo);
			resultList.setResult(1);
			resultList.setReturnList(returnList);
			resultList.setPageInfo(paginationInfo);

		} catch (Exception e) {
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
	}

	/**
	 * 코드 수를 조회 한다.
	 *
	 * @param vo
	 * @return int
	 * @throws Exception
	 */
	@Override
	public int countCode(CmmnCdVO vo) throws Exception {
		return cmmnCdDAO.count(vo);
	}

	/**
	 * 코드 정보를 등록한다.
	 * 
	 * @param MsgMgrVO
	 * @return int
	 * @throws Exception
	 */
	@Override
	public int addCode(CmmnCdVO vo) throws Exception {
//		String codeCtgr = "";
		/*
		 * if ("Y".equals(vo.getAutoMakeYn())) {
		 * 
		 * if (vo.getUpCd().equals("USER_DIV_CD")) { codeCtgr = "UDIV"; } else if
		 * (vo.getUpCd().equals("AREA_CD")) { codeCtgr = "AREA"; } else if
		 * (vo.getUpCd().equals("DEPT_CD")) { codeCtgr = "DEPT"; } else if
		 * (vo.getUpCd().equals("JOB_CD")) { codeCtgr = "JOB"; } else { codeCtgr =
		 * "CODE"; } CmmnCdVO vo2 = new CmmnCdVO(); vo2.setUpCd(codeCtgr);
		 * vo.setCd(cmmnCdDAO.selectKey(vo2)); }
		 */
		vo.setCmmnCdId(IdGenUtil.genNewId(IdPrefixType.CMCOD));
		return cmmnCdDAO.insert(vo);
	}

	/**
	 * 특정 언어키 값에 해당하는 코드의 정보를 조회한다.
	 * 
	 * @param cdCtgrCd
	 * @param cdCd
	 * @param langCd
	 * @return CmmnCdVO
	 */
	/*
	 * @Override public OrgCodeLangVO viewCode(String orgId, String upCd, String cd,
	 * String langCd) throws Exception { // 코드 정보 조회는 다음이 조건을 가진다. // 1. params로 넘어온
	 * langCd값을 기준으로 조회 // 2. 해당 값이 존재하지 않다면, langCd=en (영문) 값으로 조회 // 3. 영문 값도 존재하지
	 * 않다면, langCd=ko (한글, default) 값으로 조회 // 4. 한글 값으로도 존재하지 않다면, 공백값을 넘겨줄 것이며,
	 * error 로그를 쌓는다. OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
	 * orgCodeLangVO.setOrgId(orgId); orgCodeLangVO.setUpCd(upCd);
	 * orgCodeLangVO.setCd(cd); orgCodeLangVO.setLangCd(langCd);
	 * 
	 * return checkCmmnCdLangData(orgCodeLangDAO.select(orgCodeLangVO), "en"); }
	 */

	/**
	 * 코드 정보를 수정한다.
	 * 
	 * @param MsgMgrVO
	 * @return int
	 * @throws Exception
	 */
	
	@Override
	public int editCode(CmmnCdVO vo) throws Exception {

		int result = cmmnCdDAO.update(vo);
		/*
		 * List<OrgCodeLangVO> codeLangList = vo.getCodeLangList();
		 * 
		 * for (OrgCodeLangVO oclvo : codeLangList) { try {
		 * orgCodeLangDAO.insert(oclvo); } catch (Exception e) {
		 * orgCodeLangDAO.update(oclvo); } }
		 */
		return result;
	}

	/**
	 * 코드 정보를 삭제한다.
	 * 
	 * @param upCd
	 * @param cd
	 * @return int
	 * @throws Exception
	 */

	@Override
	public int removeCode(CmmnCdVO vo) throws Exception {
		/*
		 * OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
		 * orgCodeLangVO.setOrgId(orgId); orgCodeLangVO.setUpCd(upCd);
		 * orgCodeLangVO.setCd(cd); orgCodeLangDAO.deleteAll(orgCodeLangVO);
		 */
		cmmnCdDAO.deleteAll(vo);
		return cmmnCdDAO.delete(vo);
	}

	// vo는 cmmnCd 정보를 가지고 있는 object다.
	// langCd에 해당하는 값이 없다면(null), 외국어의 기본값인 영어(en)값으로 다시 호출한다.
	// en에 해당하는 값도 없다면 system default 값인 한국어(ko)값으로 다시 호출한다.
	private OrgCodeLangVO checkCmmnCdLangData(OrgCodeLangVO vo, String nextLangCd) throws Exception {
		if (vo.getCdnm() == null) {
			vo.setLangCd(nextLangCd);

			if (orgCodeLangDAO.select(vo).getCdnm() == null) {
				vo.setLangCd(CommConst.LANG_DEFAULT);
				return orgCodeLangDAO.select(vo);
			} else {
				return vo;
			}
		} else {
			return vo;
		}
	}

	@Override
	public List<CmmnCdVO> list(CreCrsVO vo) throws Exception {

		CmmnCdVO cmmnCdVO = new CmmnCdVO();
		cmmnCdVO.setOrgId("ORG0000001");
		cmmnCdVO.setUseyn("Y");
		cmmnCdVO.setUpCd("CRS_TYPE_CD");

		List<CmmnCdVO> crsTypeList = cmmnCdDAO.list(cmmnCdVO);

		return crsTypeList;
	}

	@Override
	public List<CmmnCdVO> list(CmmnCdVO vo) throws Exception {

		List<CmmnCdVO> cmmnCdList = cmmnCdDAO.list(vo);

		return cmmnCdList;
	}

	@Override
	public List<CmmnCdVO> list(String upCd) throws Exception {

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
		if (!this.codeCache.containsKey(upCd)) {
			// CmmnCdVO cmmnCdVo = new CmmnCdVO();
			// cmmnCdVo.setUpCd(upCd);
			this.codeCache.put(upCd, listCode(upCd, true));
			// log.debug("캐쉬 적중 실패 DB에서 직접 CODE를 조회합니다. upCd [" + upCd + "]");
		} else {
			// log.debug("캐쉬 적중 성공 메모리에서 CODE를 불러옵니다. upCd [" + upCd + "]");
		}
		return this.codeCache.get(upCd);
	}

	/*
	 * @Override public CmmnCdVO select(CmmnCdVO vo) throws Exception { CmmnCdVO
	 * cmmnCdVO = new CmmnCdVO(); cmmnCdVO = cmmnCdDAO.select(cmmnCdVO);
	 * 
	 * OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO(); List<OrgCodeLangVO>
	 * codeLangList = orgCodeLangDAO.list(orgCodeLangVO);
	 * cmmnCdVO.setCodeLangList(codeLangList);
	 * 
	 * return cmmnCdVO; }
	 */

	/**
	 * 코드 정보의 목록를 반환한다.
	 * 
	 * @param upCd
	 * @return ProcessResultListDTO<CmmnCdVO>
	 * @throws Exception
	 */
	public ProcessResultListVO<CmmnCdVO> listCodes(String upCd, boolean use) throws Exception {
		List<CmmnCdVO> codeList = listCodeByDBs(upCd).getReturnList();
		ProcessResultListVO<CmmnCdVO> result = new ProcessResultListVO<CmmnCdVO>();
		List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();
		for (CmmnCdVO scvo : codeList) {
			if (use) {
				if ("Y".equals(scvo.getUseyn())) {
					returnList.add(scvo);
				}
			} else {
				returnList.add(scvo);
			}
		}
		result.setResult(1);
		result.setReturnList(returnList);
		return result;
	}

	/**
	 * 코드 정보의 목록를 반환한다.
	 * 
	 * @param OrgCodeCtgrVO
	 * @return ProcessResultListDTO<CmmnCdVO>
	 * @throws Exception
	 */
	@Override
	public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String upCd) throws Exception {
		return this.listCodes(orgId, upCd, true);
	}

	/**
	 * 코드 정보의 목록를 반환한다.
	 * 
	 * @param upCd
	 * @return ProcessResultListDTO<CmmnCdVO>
	 * @throws Exception
	 */
	@Override
	public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String upCd, boolean use) throws Exception {

		// List<CmmnCdVO> codeList = listCodeWithCache(upCd);
		CmmnCdVO cmmnCdVO = new CmmnCdVO();
		cmmnCdVO.setOrgId(orgId);
		cmmnCdVO.setUpCd(upCd);
		List<CmmnCdVO> codeList = cmmnCdDAO.list(cmmnCdVO);
		ProcessResultListVO<CmmnCdVO> result = new ProcessResultListVO<CmmnCdVO>();
		List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();

		for (CmmnCdVO ocvo : codeList) {
			if (use) {
				if ("Y".equals(ocvo.getUseyn()))
					returnList.add(ocvo);
			} else {
				returnList.add(ocvo);
			}
		}

		result.setResult(1);
		result.setReturnList(returnList);
		return result;
	}

	@Override
	public ProcessResultListVO<CmmnCdVO> listCodes(String orgId, String upCd, String langCd, boolean use)
			throws Exception {

		// tb_org_code에 조회헤서 사용 여부를 확인한다. Y값인 경우에만 사용한다.
		CmmnCdVO cmmnCdVO = new CmmnCdVO();
		cmmnCdVO.setOrgId(orgId);
		cmmnCdVO.setUpCd(upCd);
		cmmnCdVO.setLangCd(langCd);

		List<CmmnCdVO> cmmnCdList = cmmnCdDAO.list(cmmnCdVO); // org table 조회

		ProcessResultListVO<CmmnCdVO> result = new ProcessResultListVO<CmmnCdVO>();
		List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>();

		// TO-DO JY Lang테이블 주석
		/*
		 * for (CmmnCdVO vo : cmmnCdList) { if (use) { // 사용값이 Y인지 확인한다. Y값이라면 org code
		 * lang 테이블을 조회한다. if ("Y".equals(vo.getUseyn())) { OrgCodeLangVO orgCodeLangVO
		 * = new OrgCodeLangVO(); orgCodeLangVO.setOrgId(orgId);
		 * orgCodeLangVO.setCd(vo.getCd()); orgCodeLangVO.setUpCd(upCd);
		 * orgCodeLangVO.setLangCd(langCd);
		 * 
		 * vo.setCodeLangVO(checkCmmnCdLangData(orgCodeLangDAO.select(orgCodeLangVO),
		 * "en")); returnList.add(vo); } } else { returnList.add(vo); } }
		 */

		result.setResult(1);
//		result.setReturnList(returnList);
		result.setReturnList(cmmnCdList);
		return result;
	}

	public ProcessResultListVO<CmmnCdVO> listCodeByDBs(String upCd) throws Exception {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
		String orgId = SessionInfo.getOrgId(request);

		CmmnCdVO scvo = new CmmnCdVO();
		scvo.setUpCd(upCd);
		scvo.setOrgId(orgId);

		List<CmmnCdVO> codeList = cmmnCdDAO.list(scvo);
		ProcessResultListVO<CmmnCdVO> result = new ProcessResultListVO<CmmnCdVO>();
		/*
		 * List<CmmnCdVO> returnList = new ArrayList<CmmnCdVO>(); for (CmmnCdVO svo :
		 * codeList) { OrgCodeLangVO sclvo = new OrgCodeLangVO(); sclvo.setOrgId(orgId);
		 * sclvo.setUpCd(svo.getUpCd()); sclvo.setCd(svo.getCd());
		 * sclvo.setLangCd(svo.getLangCd()); List<OrgCodeLangVO> codeLangList =
		 * orgCodeLangDAO.list(sclvo); svo.setCodeLangList(codeLangList);
		 * returnList.add(svo); }
		 */
		result.setResult(1);
//		result.setReturnList(returnList);
		result.setReturnList(codeList);

		return result;
	}

	/**
	 * 시스템 코드 리스트를 반환한다.
	 *
	 * @param upCd
	 * @return
	 */
	@Override
	public synchronized List<CmmnCdVO> getCmmnCdList(String upCd) throws Exception {

		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
		String langCd = SessionInfo.getLocaleKey(request);
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
		if (!this.codeCache.containsKey(upCd)) {

			// CmmnCdVO cmmnCdVo = new CmmnCdVO();
			// cmmnCdVo.setUpCd(upCd);

			this.codeCache.put(upCd, listCodes(upCd, true).getReturnList());

			// log.debug("캐쉬 적중 실패 DB에서 직접 CODE를 조회합니다. upCd [" + upCd + "]");
		} else {
			// log.debug("캐쉬 적중 성공 메모리에서 CODE를 불러옵니다. upCd [" + upCd + "]");
		}

		List<CmmnCdVO> vo = this.codeCache.get(upCd);
		// TO-DO JY Lang테이블 주석
		/*
		 * for (CmmnCdVO codeVO : vo) { for (OrgCodeLangVO codeLangVO :
		 * codeVO.getCodeLangList()) { if (langCd.equals(codeLangVO.getLangCd()))
		 * codeVO.setCodeNm(codeLangVO.getCodeNm()); } }
		 */
		return vo;
	}

}
