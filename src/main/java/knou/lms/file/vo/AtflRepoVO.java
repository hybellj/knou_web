package knou.lms.file.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * 첨부파일저장소 VO
 */
public class AtflRepoVO extends DefaultVO {
	private static final long serialVersionUID = -4434912130453333602L;
	private String		atflRepoId;			// 첨부파일저장소아이디
	private String		atflRepoPath;		// 첨부파일저장소경로
	private String		atflRepoExpln;		// 첨부파일저장소설명

	public String getAtflRepoId() {
		return atflRepoId;
	}

	public void setAtflRepoId(String atflRepoId) {
		this.atflRepoId = atflRepoId;
	}

	public String getAtflRepoPath() {
		return atflRepoPath;
	}

	public void setAtflRepoPath(String atflRepoPath) {
		this.atflRepoPath = atflRepoPath;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getAtflRepoExpln() {
		return atflRepoExpln;
	}

	public void setAtflRepoExpln(String atflRepoExpln) {
		this.atflRepoExpln = atflRepoExpln;
	}

}
