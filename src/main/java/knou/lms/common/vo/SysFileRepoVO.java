package knou.lms.common.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;


public class SysFileRepoVO 
{

	private String repoCd; // REPO_CD,
	private String parTableNm; // PAR_TBL_NM,
	private String parFieldNm;
	private String repoNm; // REPO_NM,
	private String repoDfltPath; // REPO_DFLT_PATH,
	private String isUsingTable;

	private int fileCnt;

	public SysFileRepoVO() {
		super();
	}

	public SysFileRepoVO(String repoCd) {
		super();
		this.repoCd = repoCd;
	}

	public String getRepoCd() {
		return repoCd;
	}

	public void setRepoCd(String repoCd) {
		this.repoCd = repoCd;
	}

	public String getParTableNm() {
		return parTableNm;
	}

	public void setParTableNm(String parTableNm) {
		this.parTableNm = parTableNm;
	}

	public String getParFieldNm() {
		return parFieldNm;
	}

	public void setParFieldNm(String parFieldNm) {
		this.parFieldNm = parFieldNm;
	}

	public String getRepoNm() {
		return repoNm;
	}

	public void setRepoNm(String repoNm) {
		this.repoNm = repoNm;
	}

	public String getRepoDfltPath() {
		return repoDfltPath;
	}

	public void setRepoDfltPath(String repoDfltPath) {
		this.repoDfltPath = repoDfltPath;
	}

	public int getFileCnt() {
		return fileCnt;
	}

	public void setFileCnt(int fileCnt) {
		this.fileCnt = fileCnt;
	}

	/**
	 * 테이블 명칭이 "TB_"로 시작하는 명명규칙을 따르지 않는다면 실제로 존재하지 않는 테이블이라고 판단한다.
	 * 
	 * @return
	 */
	public String getIsUsingTable() {
		if(ValidationUtils.isEmpty(this.isUsingTable)) {
			String result = "false";
			if (this.getParTableNm().indexOf("TB_") == 0)
				result = "true";
			return result;
		} else {
			return this.isUsingTable;
		}
	}

	public void setIsUsingTable(String isUsingTable) {
		this.isUsingTable = isUsingTable;
	}
}
