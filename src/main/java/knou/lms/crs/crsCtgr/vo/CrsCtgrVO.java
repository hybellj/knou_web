package knou.lms.crs.crsCtgr.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;

public class CrsCtgrVO extends DefaultVO{
	
	private static final long serialVersionUID = 8502979470754269304L;
	private String  crsCtgrCd;		/*과정 분류 코드*/
	private String  orgId;			/*기관 코드*/
	private String  parCrsCtgrCd;	/*상위 과정 분류 코드*/
	private String  crsCtgrNm;		/*과정 분류 명*/
	private String  crsCtgrDesc;	/*강좌 분류 설명*/
	private Integer crsCtgrLvl = 0;	/*과정 분류 레벨*/
	private Integer crsCtgrOdr = 0;	/*과정 분류 순서*/
	private String  useYn;			/*사용 여부*/		
	private String  rgtrId;			/*등록자 번호*/
	private String  regDttm;		/*등록 일시*/
	private String  mdfrId;			/*수정자 번호'*/
	private String  modDttm;		/*수정 일시*/
	private String  gubun;
	private Integer subCnt = 0;
	private Integer parCrsCtgrLvl = 0;
	private String  parCrsCtgrNm;
	
	private String parCrsCtgrCdLvl1;
	private String parCrsCtgrCdLvl2;
	private String parCrsCtgrCdLvl3;
	private String parCrsCtgrNmLvl1;
	private String parCrsCtgrNmLvl2;
	private String parCrsCtgrNmLvl3;
	
	
	private List<CrsCtgrVO>	subList;
	private CrsCtgrVO parentCrsCtgr;
	
	private String path;
	private String pathNm;
	
	
	public String getCrsCtgrCd() {
		return crsCtgrCd;
	}
	public void setCrsCtgrCd(String crsCtgrCd) {
		this.crsCtgrCd = crsCtgrCd;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getParCrsCtgrCd() {
		return parCrsCtgrCd;
	}
	public void setParCrsCtgrCd(String parCrsCtgrCd) {
		this.parCrsCtgrCd = parCrsCtgrCd;
	}
	public String getCrsCtgrNm() {
		return crsCtgrNm;
	}
	public void setCrsCtgrNm(String crsCtgrNm) {
		this.crsCtgrNm = crsCtgrNm;
	}
	public String getCrsCtgrDesc() {
		return crsCtgrDesc;
	}
	public void setCrsCtgrDesc(String crsCtgrDesc) {
		this.crsCtgrDesc = crsCtgrDesc;
	}
	public Integer getCrsCtgrLvl() {
		return crsCtgrLvl;
	}
	public void setCrsCtgrLvl(Integer crsCtgrLvl) {
		this.crsCtgrLvl = crsCtgrLvl;
	}
	public Integer getCrsCtgrOdr() {
		return crsCtgrOdr;
	}
	public void setCrsCtgrOdr(Integer crsCtgrOdr) {
		this.crsCtgrOdr = crsCtgrOdr;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getRgtrId() {
		return rgtrId;
	}
	public void setRgtrId(String rgtrId) {
		this.rgtrId = rgtrId;
	}
	public String getRegDttm() {
		return regDttm;
	}
	public void setRegDttm(String regDttm) {
		this.regDttm = regDttm;
	}
	public String getMdfrId() {
		return mdfrId;
	}
	public void setMdfrId(String mdfrId) {
		this.mdfrId = mdfrId;
	}
	public String getModDttm() {
		return modDttm;
	}
	public void setModDttm(String modDttm) {
		this.modDttm = modDttm;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public CrsCtgrVO getParentCrsCtgr() {
		return parentCrsCtgr;
	}
	public Integer getSubCnt() {
		return subCnt;
	}
	public void setSubCnt(Integer subCnt) {
		this.subCnt = subCnt;
	}
	public Integer getParCrsCtgrLvl() {
		return parCrsCtgrLvl;
	}
	public void setParCrsCtgrLvl(Integer parCrsCtgrLvl) {
		this.parCrsCtgrLvl = parCrsCtgrLvl;
	}
	public String getParCrsCtgrNm() {
		return parCrsCtgrNm;
	}
	public void setParCrsCtgrNm(String parCrsCtgrNm) {
		this.parCrsCtgrNm = parCrsCtgrNm;
	}
	public List<CrsCtgrVO> getSubList() {
		if(ValidationUtils.isEmpty(subList)) subList = new ArrayList<CrsCtgrVO>();
		return subList;
	}
	public void setSubList(List<CrsCtgrVO> subList) {
		this.subList = subList;
	}
	
	//-- vo 게체에 하위 겍체를 추가한다.
	public void addSubCtgr(CrsCtgrVO vo) {
		vo.setParentCrsCtgr(this);
		this.getSubList().add(vo);
	}
	
	public void setParentCrsCtgr(CrsCtgrVO parentCrsCtgr) {
		this.parentCrsCtgr = parentCrsCtgr;
	}
	public String getParCrsCtgrCdLvl1() {
		return parCrsCtgrCdLvl1;
	}
	public void setParCrsCtgrCdLvl1(String parCrsCtgrCdLvl1) {
		this.parCrsCtgrCdLvl1 = parCrsCtgrCdLvl1;
	}
	public String getParCrsCtgrCdLvl2() {
		return parCrsCtgrCdLvl2;
	}
	public void setParCrsCtgrCdLvl2(String parCrsCtgrCdLvl2) {
		this.parCrsCtgrCdLvl2 = parCrsCtgrCdLvl2;
	}
	public String getParCrsCtgrCdLvl3() {
		return parCrsCtgrCdLvl3;
	}
	public void setParCrsCtgrCdLvl3(String parCrsCtgrCdLvl3) {
		this.parCrsCtgrCdLvl3 = parCrsCtgrCdLvl3;
	}
	public String getParCrsCtgrNmLvl1() {
		return parCrsCtgrNmLvl1;
	}
	public void setParCrsCtgrNmLvl1(String parCrsCtgrNmLvl1) {
		this.parCrsCtgrNmLvl1 = parCrsCtgrNmLvl1;
	}
	public String getParCrsCtgrNmLvl2() {
		return parCrsCtgrNmLvl2;
	}
	public void setParCrsCtgrNmLvl2(String parCrsCtgrNmLvl2) {
		this.parCrsCtgrNmLvl2 = parCrsCtgrNmLvl2;
	}
	public String getParCrsCtgrNmLvl3() {
		return parCrsCtgrNmLvl3;
	}
	public void setParCrsCtgrNmLvl3(String parCrsCtgrNmLvl3) {
		this.parCrsCtgrNmLvl3 = parCrsCtgrNmLvl3;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getPathNm() {
		return pathNm;
	}
	public void setPathNm(String pathNm) {
		this.pathNm = pathNm;
	}
	
	
}
