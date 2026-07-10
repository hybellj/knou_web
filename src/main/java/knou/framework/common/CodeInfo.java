package knou.framework.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.lms.system.manage.service.CommonCodeService;
import knou.lms.system.manage.vo.CommonCodeVO;

/**
 * 시스템 공통코드 정보
 */
public class CodeInfo {

	private static Map<String, List<CommonCodeVO>> CODE_MAP = null;


	/**
	 * 코드명 가져오기 (기관미지정, 세션의 기관정보 참조)
	 * @param request
	 * @param upCd
	 * @param cd
	 * @return codeName
	 * @throws Exception
	 */
	public static String getCodeName(HttpServletRequest request, String upCd, String cd) throws Exception {
		return getOrgCodeName(request, SessionInfo.getOrgId(request), upCd, cd);
	}


	/**
	 * 코드명 가져오기 (기관지정)
	 * @param request
	 * @param orgId
	 * @param upCd
	 * @param cd
	 * @return codeName
	 * @throws Exception
	 */
	public static String getOrgCodeName(HttpServletRequest request, String orgId, String upCd, String cd) throws Exception {
		String codeName = "";

		// 코드맵이 비어있을 경우 DB에서 로드
		if (CODE_MAP == null) {
			loadCodeAll(request);
		}

		if (CODE_MAP != null) {
			String key = orgId + ":" + SessionInfo.getLocaleKey(request) + ":" + upCd;
			if (CODE_MAP.containsKey(key)) {
				List<CommonCodeVO> cdList = CODE_MAP.get(key);
				for (CommonCodeVO vo : cdList) {
					if (upCd.equals(vo.getUpCd())) {
						codeName = vo.getCdnm();
						break;
					}
				}
			}
		}

		return codeName;
	}


	/**
	 * 코드목록 가져오기 (기관미지정, 세션의 기관정보 참조)
	 * @param request
	 * @param upCd
	 * @return List<CommonCodeVO>
	 * @throws Exception
	 */
	public static List<CommonCodeVO> getCodeList(HttpServletRequest request, String upCd) throws Exception {
		return getOrgCodeList(request, SessionInfo.getOrgId(request), upCd);
	}


	/**
	 * 코드목록 가져오기 (기관지정)
	 * @param request
	 * @param orgId
	 * @param upCd
	 * @return List<CommonCodeVO>
	 * @throws Exception
	 */
	public static List<CommonCodeVO> getOrgCodeList(HttpServletRequest request, String orgId, String upCd) throws Exception {
		 List<CommonCodeVO> codeList = new ArrayList<>();

		// 코드맵이 비어있을 경우 DB에서 로드
		if (CODE_MAP == null) {
			loadCodeAll(request);
		}

		if (CODE_MAP != null) {
			String key = orgId + ":" + SessionInfo.getLocaleKey(request) + ":" + upCd;
			if (CODE_MAP.containsKey(key)) {
				codeList = CODE_MAP.get(key);
			}
		}

		return codeList;
	}


	// 공통코드 로드
	private static void loadCodeAll(HttpServletRequest request) throws Exception {
		ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
		CommonCodeService commonCodeService = (CommonCodeService)applicationContext.getBean("commonCodeService");

		// 코드 전체 목록 조회
		List<CommonCodeVO> codeList = commonCodeService.selectSysCmmnCdAll();

		if (codeList != null && codeList.size() > 0) {
			CODE_MAP = new HashMap<>();
			String key = "";

			for (CommonCodeVO vo : codeList) {
				key = vo.getOrgId() + ":" + vo.getLangCd() + ":" + vo.getUpCd();

				if (CODE_MAP.containsKey(key)) {
					CODE_MAP.get(key).add(vo);
				}
				else {
					List<CommonCodeVO> cdList = new ArrayList<>();
					cdList.add(vo);
					CODE_MAP.put(key, cdList);
				}
			}
		}
	}
}
