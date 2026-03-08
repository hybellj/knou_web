package knou.framework.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflRepoVO;

/**
 * 첨부파일 저장소 정보
 */
public class RepoInfo {

	private static Map<String, AtflRepoVO> REPO_MAP = null;


	/**
	 * 첨부파일 저장소 경로 가져오기
	 * @param request
	 * @param atflRepoId
	 * @param addPath
	 * @return
	 * @throws Exception
	 */
	public static String getAtflRepo(HttpServletRequest request, String atflRepoId, String addPath) throws Exception {
		String repoPath = "/attach";

		if (REPO_MAP == null) {
			loadAtflRepo(request);
		}

		if (REPO_MAP != null && REPO_MAP.containsKey(atflRepoId)) {
			AtflRepoVO repoVO = (AtflRepoVO) REPO_MAP.get(atflRepoId);
			repoPath = repoVO.getAtflRepoPath();

			if (addPath != null && !"".equals(addPath)) {
				if (repoPath.endsWith("/")) {
				    repoPath += addPath;
				} else {
				    repoPath += "/" + addPath;
				}
			}
		}

		return repoPath;
	}


	/**
	 * 첨부파일 저장소 경로 가져오기
	 * @param request
	 * @param atflRepoId
	 * @return
	 * @throws Exception
	 */
	public static String getAtflRepo(HttpServletRequest request, String atflRepoId) throws Exception {
		return getAtflRepo(request, atflRepoId, null);
	}


	// 첨부파일 저장소 정보 로드
	private static void loadAtflRepo(HttpServletRequest request) throws Exception {
		ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
        AttachFileService attachFileService = (AttachFileService)applicationContext.getBean("attachFileService");
        List<AtflRepoVO> repoList = attachFileService.selectAtflRepoList();

        if (repoList != null && repoList.size() > 0) {
        	REPO_MAP = new HashMap<>();

	        for (AtflRepoVO repoVO : repoList) {
	        	REPO_MAP.put(repoVO.getAtflRepoId(), repoVO);
	        }
        }
	}
}
