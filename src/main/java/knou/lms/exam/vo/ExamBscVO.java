package knou.lms.exam.vo;

import java.util.List;

import knou.lms.common.vo.DefaultVO;

public class ExamBscVO extends DefaultVO {

	private static final long serialVersionUID = -5616434278166619575L;

	// TB_LMS_EXAM_BSC ( 시험기본 )
    private String 	examBscId;					// 시험기본아이디
    private String 	lctrWknoSchdlId;			// 강의주차일정아이디
    private String 	examGrpId;					// 시험그룹아이디
    private String 	examTycd;					// 시험유형코드 ( EXAM : 시험, QUIZ : 퀴즈 )
    private String 	examGbncd;					// 시험구분코드 ( EXAM_MID : 중간고사, EXAM_LST : 기말고사, QUIZ : 퀴즈, QUIZ_TEAM : 퀴즈 팀, QUIZ_EXAM_MID : 퀴즈 중간고사, QUIZ_EXAM_LST : 퀴즈 기말고사, QUIZ_SBST_EXAM_MID : 퀴즈 중간고사 대체, QUIZ_SBST_EXAM_LST : 퀴즈 기말고사 대체 )
    private String 	examTtl;					// 시험제목
    private String 	examCts;					// 시험내용
    private String 	tkexamMthdCd;				// 시험응시방법코드 ( OFLN : 오프라인시험, ONLN : 온라인시험, RLTM : 실시간시험, ETC : 기타 )
    private String 	qstnDsplyGbncd;				// 문항화면표시구분코드 ( WHOL : 전체화면표시, EACH : 한문제씩표시 )
    private String 	exampprOyn;					// 시험지공개여부
    private String 	avgMrkOyn;					// 평균성적공개여부
    private String 	mrkOpenSdttm;				// 성적공개시작일시
    private String 	pushNotiyn;					// 푸시알림여부
    private String 	secCertCd;					// SEC인증코드
    private String 	imdtAnswShtInqyn;			// 즉시답안조회여부
    private Integer maxTkexamCnt;				// 최대응시횟수
    private String 	useyn;						// 사용여부
    private String 	delyn;						// 삭제여부
    private String 	regyn;						// 등록여부
    private String 	qstnsDlgtnyn;				// 문제출제위임여부
    private String 	mrkOyn;						// 성적공개여부
    private String 	dvclasRegyn;				// 분반등록여부
    private String 	examQstnsCmptnyn;			// 시험문제출제완료여부
    private String 	qstnRndmyn;					// 문항무작위여부
    private String  qstnVwitmRndmyn;			// 문항보기항목무작위여부
    private String  qstnCnddtUseyn;				// 문항후보사용여부
    private String  mrkRfltyn;					// 성적반영여부
    private Integer	mrkRfltrt;					// 성적반영비율
    private String 	examtmAllocGbncd;			// 시험시간배정구분코드 ( REMAINDER : 남은시간배정, WHOLE : 전체시간배정 )
    private String 	examtmExpsrTycd;			// 시험시간노출유형코드 ( LEFT : 왼쪽, TOP : 상단, BOTTOM : 하단, RIGHT : 오른쪽, PRGR_BAR : 프로그레스바 )
    private String  lrnGrpSubasmtStngyn;		// 학습그룹부과제설정여부

    private String  examGbnnm;					// 시험구분코드명
    private Integer examExamneeCnt;				// 시험응시자수
    private Integer examEvlteeCnt;				// 시험피평가자수
    private Integer examTrgtrCnt;				// 시험대상자수
    private Integer tkexamStrtUserCnt;			// 시험응시 시작 사용자 수 ( 시험응시 후 미제출인 경우 )
    private Integer qstnCnt;					// 문항수
    private String  examPrgrsSts;				// 시험진행상태
    private String  parExamBscId;				// 대체퀴즈인 경우 시험정보 관리용
    private String  parExamPsblEdttm;			// 상위시험 종료일시
    private String  sbjctnm;					// 과목명
    private String  dvclasNo;					// 분반번호
    private List<String> sbjctIds;     			// 분반 같이 등록용 과목아이디 목록
    private List<String> lrnGrpIds;				// 팀 퀴즈 등록용 학습그룹아이디:개설과목아이디 목록
    private List<String> lrnGrpSubasmtStngyns;	// 학습그룹부과제설정여부용 여부:개설과목아이디 목록
    private String  lrnGrpId;					// 학습그룹아이디
    private String  lrnGrpnm;					// 학습그룹명
    private String  byteamSubrexamUseyn;        // 팀시험여부

    private ExamDtlVO examDtlVO;				// 시험상세정보VO

	public String getExamBscId() {
		return examBscId;
	}

	public String getLctrWknoSchdlId() {
		return lctrWknoSchdlId;
	}

	public String getExamGrpId() {
		return examGrpId;
	}

	public String getExamTycd() {
		return examTycd;
	}

	public String getExamGbncd() {
		return examGbncd;
	}

	public String getExamTtl() {
		return examTtl;
	}

	public String getExamCts() {
		return examCts;
	}

	public String getTkexamMthdCd() {
		return tkexamMthdCd;
	}

	public String getQstnDsplyGbncd() {
		return qstnDsplyGbncd;
	}

	public String getExampprOyn() {
		return exampprOyn;
	}

	public String getAvgMrkOyn() {
		return avgMrkOyn;
	}

	public String getMrkOpenSdttm() {
		return mrkOpenSdttm;
	}

	public String getPushNotiyn() {
		return pushNotiyn;
	}

	public String getSecCertCd() {
		return secCertCd;
	}

	public String getImdtAnswShtInqyn() {
		return imdtAnswShtInqyn;
	}

	public Integer getMaxTkexamCnt() {
		return maxTkexamCnt;
	}

	public String getUseyn() {
		return useyn;
	}

	public String getDelyn() {
		return delyn;
	}

	public String getRegyn() {
		return regyn;
	}

	public String getQstnsDlgtnyn() {
		return qstnsDlgtnyn;
	}

	public String getMrkOyn() {
		return mrkOyn;
	}

	public String getDvclasRegyn() {
		return dvclasRegyn;
	}

	public String getExamQstnsCmptnyn() {
		return examQstnsCmptnyn;
	}

	public String getQstnRndmyn() {
		return qstnRndmyn;
	}

	public String getQstnVwitmRndmyn() {
		return qstnVwitmRndmyn;
	}

	public String getQstnCnddtUseyn() {
		return qstnCnddtUseyn;
	}

	public String getMrkRfltyn() {
		return mrkRfltyn;
	}

	public Integer getMrkRfltrt() {
		return mrkRfltrt;
	}

	public String getExamtmAllocGbncd() {
		return examtmAllocGbncd;
	}

	public String getExamtmExpsrTycd() {
		return examtmExpsrTycd;
	}

	public String getExamGbnnm() {
		return examGbnnm;
	}

	public Integer getExamExamneeCnt() {
		return examExamneeCnt;
	}

	public Integer getExamEvlteeCnt() {
		return examEvlteeCnt;
	}

	public Integer getExamTrgtrCnt() {
		return examTrgtrCnt;
	}

	public Integer getTkexamStrtUserCnt() {
		return tkexamStrtUserCnt;
	}

	public Integer getQstnCnt() {
		return qstnCnt;
	}

	public String getExamPrgrsSts() {
		return examPrgrsSts;
	}

	public String getParExamBscId() {
		return parExamBscId;
	}

	public String getParExamPsblEdttm() {
		return parExamPsblEdttm;
	}

	public String getSbjctnm() {
		return sbjctnm;
	}

	public String getDvclasNo() {
		return dvclasNo;
	}

	public List<String> getSbjctIds() {
		return sbjctIds;
	}

	public ExamDtlVO getExamDtlVO() {
		return examDtlVO;
	}

	public void setExamBscId(String examBscId) {
		this.examBscId = examBscId;
	}

	public void setLctrWknoSchdlId(String lctrWknoSchdlId) {
		this.lctrWknoSchdlId = lctrWknoSchdlId;
	}

	public void setExamGrpId(String examGrpId) {
		this.examGrpId = examGrpId;
	}

	public void setExamTycd(String examTycd) {
		this.examTycd = examTycd;
	}

	public void setExamGbncd(String examGbncd) {
		this.examGbncd = examGbncd;
	}

	public void setExamTtl(String examTtl) {
		this.examTtl = examTtl;
	}

	public void setExamCts(String examCts) {
		this.examCts = examCts;
	}

	public void setTkexamMthdCd(String tkexamMthdCd) {
		this.tkexamMthdCd = tkexamMthdCd;
	}

	public void setQstnDsplyGbncd(String qstnDsplyGbncd) {
		this.qstnDsplyGbncd = qstnDsplyGbncd;
	}

	public void setExampprOyn(String exampprOyn) {
		this.exampprOyn = exampprOyn;
	}

	public void setAvgMrkOyn(String avgMrkOyn) {
		this.avgMrkOyn = avgMrkOyn;
	}

	public void setMrkOpenSdttm(String mrkOpenSdttm) {
		this.mrkOpenSdttm = mrkOpenSdttm;
	}

	public void setPushNotiyn(String pushNotiyn) {
		this.pushNotiyn = pushNotiyn;
	}

	public void setSecCertCd(String secCertCd) {
		this.secCertCd = secCertCd;
	}

	public void setImdtAnswShtInqyn(String imdtAnswShtInqyn) {
		this.imdtAnswShtInqyn = imdtAnswShtInqyn;
	}

	public void setMaxTkexamCnt(Integer maxTkexamCnt) {
		this.maxTkexamCnt = maxTkexamCnt;
	}

	public void setUseyn(String useyn) {
		this.useyn = useyn;
	}

	public void setDelyn(String delyn) {
		this.delyn = delyn;
	}

	public void setRegyn(String regyn) {
		this.regyn = regyn;
	}

	public void setQstnsDlgtnyn(String qstnsDlgtnyn) {
		this.qstnsDlgtnyn = qstnsDlgtnyn;
	}

	public void setMrkOyn(String mrkOyn) {
		this.mrkOyn = mrkOyn;
	}

	public void setDvclasRegyn(String dvclasRegyn) {
		this.dvclasRegyn = dvclasRegyn;
	}

	public void setExamQstnsCmptnyn(String examQstnsCmptnyn) {
		this.examQstnsCmptnyn = examQstnsCmptnyn;
	}

	public void setQstnRndmyn(String qstnRndmyn) {
		this.qstnRndmyn = qstnRndmyn;
	}

	public void setQstnVwitmRndmyn(String qstnVwitmRndmyn) {
		this.qstnVwitmRndmyn = qstnVwitmRndmyn;
	}

	public void setQstnCnddtUseyn(String qstnCnddtUseyn) {
		this.qstnCnddtUseyn = qstnCnddtUseyn;
	}

	public void setMrkRfltyn(String mrkRfltyn) {
		this.mrkRfltyn = mrkRfltyn;
	}

	public void setMrkRfltrt(Integer mrkRfltrt) {
		this.mrkRfltrt = mrkRfltrt;
	}

	public void setExamtmAllocGbncd(String examtmAllocGbncd) {
		this.examtmAllocGbncd = examtmAllocGbncd;
	}

	public void setExamtmExpsrTycd(String examtmExpsrTycd) {
		this.examtmExpsrTycd = examtmExpsrTycd;
	}

	public void setExamGbnnm(String examGbnnm) {
		this.examGbnnm = examGbnnm;
	}

	public void setExamExamneeCnt(Integer examExamneeCnt) {
		this.examExamneeCnt = examExamneeCnt;
	}

	public void setExamEvlteeCnt(Integer examEvlteeCnt) {
		this.examEvlteeCnt = examEvlteeCnt;
	}

	public void setExamTrgtrCnt(Integer examTrgtrCnt) {
		this.examTrgtrCnt = examTrgtrCnt;
	}

	public void setTkexamStrtUserCnt(Integer tkexamStrtUserCnt) {
		this.tkexamStrtUserCnt = tkexamStrtUserCnt;
	}

	public void setQstnCnt(Integer qstnCnt) {
		this.qstnCnt = qstnCnt;
	}

	public void setExamPrgrsSts(String examPrgrsSts) {
		this.examPrgrsSts = examPrgrsSts;
	}

	public void setParExamBscId(String parExamBscId) {
		this.parExamBscId = parExamBscId;
	}

	public void setParExamPsblEdttm(String parExamPsblEdttm) {
		this.parExamPsblEdttm = parExamPsblEdttm;
	}

	public void setSbjctnm(String sbjctnm) {
		this.sbjctnm = sbjctnm;
	}

	public void setDvclasNo(String dvclasNo) {
		this.dvclasNo = dvclasNo;
	}

	public void setSbjctIds(List<String> sbjctIds) {
		this.sbjctIds = sbjctIds;
	}

	public void setExamDtlVO(ExamDtlVO examDtlVO) {
		this.examDtlVO = examDtlVO;
	}

	public List<String> getLrnGrpIds() {
		return lrnGrpIds;
	}

	public void setLrnGrpIds(List<String> lrnGrpIds) {
		this.lrnGrpIds = lrnGrpIds;
	}

	public String getLrnGrpId() {
		return lrnGrpId;
	}

	public String getLrnGrpnm() {
		return lrnGrpnm;
	}

	public void setLrnGrpId(String lrnGrpId) {
		this.lrnGrpId = lrnGrpId;
	}

	public void setLrnGrpnm(String lrnGrpnm) {
		this.lrnGrpnm = lrnGrpnm;
	}

	public String getLrnGrpSubasmtStngyn() {
		return lrnGrpSubasmtStngyn;
	}

	public void setLrnGrpSubasmtStngyn(String lrnGrpSubasmtStngyn) {
		this.lrnGrpSubasmtStngyn = lrnGrpSubasmtStngyn;
	}

	public List<String> getLrnGrpSubasmtStngyns() {
		return lrnGrpSubasmtStngyns;
	}

	public void setLrnGrpSubasmtStngyns(List<String> lrnGrpSubasmtStngyns) {
		this.lrnGrpSubasmtStngyns = lrnGrpSubasmtStngyns;
	}

    public String getByteamSubrexamUseyn() {
        return byteamSubrexamUseyn;
    }
    public void setByteamSubrexamUseyn(String byteamSubrexamUseyn) {
        this.byteamSubrexamUseyn = byteamSubrexamUseyn;
    }
}
