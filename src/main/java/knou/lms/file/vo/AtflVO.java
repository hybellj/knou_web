package knou.lms.file.vo;

import knou.lms.common.vo.DefaultVO;

/**
 * TB_LMS_ATFL (첨부파일)
 */
public class AtflVO extends DefaultVO {
	private static final long serialVersionUID = -5346764491591476746L;
	private String		atflId;			// 첨부파일아이디
	private String		refId;			// 참조아이디
	private String		atflRepoId;		// 첨부파일저장소아이디
	private int		atflSeqno;		// 파일순번
	private String		filenm;			// 파일명
	private String		fileExt;		// 파일확장자
	private String		filePath;		// 파일경로
	private String		fileSavnm;		// 파일저장명
	private long		fileSize;		// 파일크기
	private String		fileTycd;		// 파일유형코드
	private String		cnvsnFile;		// 변환파일
	private String		etcInfo1;		// 기타정보1
	private String		etcInfo2;		// 기타정보2
	private String		etcInfo3;		// 기타정보3
	private String		mimeTycd;		// 마임유형코드
	private String		thmbFilePath;	// 썸네일파일경로
	private String		thmbFilenm;		// 썸네일파일명
	private int		dwldCnt;		// 다운로드수
	private String		delyn;			// 삭제여부

	private String		downDttm;		// 다운로드 유효시간
	private int		atchFileCnt = 0;	// 첨부파일수

	public String getAtflId() {
		return atflId;
	}

	public void setAtflId(String atflId) {
		this.atflId = atflId;
	}

	public String getRefId() {
		return refId;
	}

	public void setRefId(String refId) {
		this.refId = refId;
	}

	public String getAtflRepoId() {
		return atflRepoId;
	}

	public void setAtflRepoId(String atflRepoId) {
		this.atflRepoId = atflRepoId;
	}

	public int getAtflSeqno() {
		return atflSeqno;
	}

	public void setAtflSeqno(int atflSeqno) {
		this.atflSeqno = atflSeqno;
	}

	public String getFilenm() {
		return filenm;
	}

	public void setFilenm(String filenm) {
		this.filenm = filenm;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFileSavnm() {
		return fileSavnm;
	}

	public void setFileSavnm(String fileSavnm) {
		this.fileSavnm = fileSavnm;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileTycd() {
		return fileTycd;
	}

	public void setFileTycd(String fileTycd) {
		this.fileTycd = fileTycd;
	}

	public String getCnvsnFile() {
		return cnvsnFile;
	}

	public void setCnvsnFile(String cnvsnFile) {
		this.cnvsnFile = cnvsnFile;
	}

	public String getEtcInfo1() {
		return etcInfo1;
	}

	public void setEtcInfo1(String etcInfo1) {
		this.etcInfo1 = etcInfo1;
	}

	public String getEtcInfo2() {
		return etcInfo2;
	}

	public void setEtcInfo2(String etcInfo2) {
		this.etcInfo2 = etcInfo2;
	}

	public String getEtcInfo3() {
		return etcInfo3;
	}

	public void setEtcInfo3(String etcInfo3) {
		this.etcInfo3 = etcInfo3;
	}

	public String getMimeTycd() {
		return mimeTycd;
	}

	public void setMimeTycd(String mimeTycd) {
		this.mimeTycd = mimeTycd;
	}

	public String getThmbFilePath() {
		return thmbFilePath;
	}

	public void setThmbFilePath(String thmbFilePath) {
		this.thmbFilePath = thmbFilePath;
	}

	public String getThmbFilenm() {
		return thmbFilenm;
	}

	public void setThmbFilenm(String thmbFilenm) {
		this.thmbFilenm = thmbFilenm;
	}

	public int getDwldCnt() {
		return dwldCnt;
	}

	public void setDwldCnt(int dwldCnt) {
		this.dwldCnt = dwldCnt;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDownDttm() {
		return downDttm;
	}

	public void setDownDttm(String downDttm) {
		this.downDttm = downDttm;
	}

	public int getAtchFileCnt() {
		return atchFileCnt;
	}

	public void setAtchFileCnt(int atchFileCnt) {
		this.atchFileCnt = atchFileCnt;
	}

	public String getDelyn() {
		return delyn;
	}

	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}

}
