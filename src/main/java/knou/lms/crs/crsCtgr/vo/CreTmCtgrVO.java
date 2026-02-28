package knou.lms.crs.crsCtgr.vo;

import java.util.ArrayList;
import java.util.List;

import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;

public class CreTmCtgrVO extends DefaultVO{
	
	private static final long serialVersionUID = 8502979470754269304L;
	private String  creTmCtgrCd;		/*과정 분류 코드*/
	private String  orgId;			/*기관 코드*/
	private String  parCreTmCtgrCd;	/*상위 과정 분류 코드*/
	private String  creTmCtgrNm;		/*과정 분류 명*/
	private String  creTmCtgrDesc;	/*강좌 분류 설명*/
	private Integer creTmCtgrLvl = 0;	/*과정 분류 레벨*/
	private Integer creTmCtgrOdr;		/*과정 분류 순서*/
	private String  useYn;			/*사용 여부*/		
	private String  rgtrId;			/*등록자 번호*/
	private String  regDttm;		/*등록 일시*/
	private String  mdfrId;			/*수정자 번호'*/
	private String  modDttm;		/*수정 일시*/
	private String  gubun;		
	private Integer subCnt = 0;
	private Integer parCreTmCtgrLvl = 0;
	private String  parCreTmCtgrNm;
	
	private List<CreTmCtgrVO>	subList;
	private CreTmCtgrVO parentCreTmCtgr;
	
	private String parCreTmCtgrCdLvl1;
	private String parCreTmCtgrCdLvl2;
	private String parCreTmCtgrCdLvl3;
	private String parCreTmCtgrNmLvl1;
	private String parCreTmCtgrNmLvl2;
	private String parCreTmCtgrNmLvl3;
	
	private String path;
	private String pathNm;
	
	public String getCreTmCtgrCd() {
		return creTmCtgrCd;
	}
	public void setCreTmCtgrCd(String creTmCtgrCd) {
		this.creTmCtgrCd = creTmCtgrCd;
	}
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getParCreTmCtgrCd() {
		return parCreTmCtgrCd;
	}
	public void setParCreTmCtgrCd(String parCreTmCtgrCd) {
		this.parCreTmCtgrCd = parCreTmCtgrCd;
	}
	public String getCreTmCtgrNm() {
		return creTmCtgrNm;
	}
	public void setCreTmCtgrNm(String creTmCtgrNm) {
		this.creTmCtgrNm = creTmCtgrNm;
	}
	public String getCreTmCtgrDesc() {
		return creTmCtgrDesc;
	}
	public void setCreTmCtgrDesc(String creTmCtgrDesc) {
		this.creTmCtgrDesc = creTmCtgrDesc;
	}
	public Integer getCreTmCtgrLvl() {
		return creTmCtgrLvl;
	}
	public void setCreTmCtgrLvl(Integer creTmCtgrLvl) {
		this.creTmCtgrLvl = creTmCtgrLvl;
	}
	public Integer getCreTmCtgrOdr() {
		return creTmCtgrOdr;
	}
	public void setCreTmCtgrOdr(Integer creTmCtgrOdr) {
		this.creTmCtgrOdr = creTmCtgrOdr;
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
	public Integer getSubCnt() {
		return subCnt;
	}
	public void setSubCnt(Integer subCnt) {
		this.subCnt = subCnt;
	}
	public Integer getParCreTmCtgrLvl() {
		return parCreTmCtgrLvl;
	}
	public void setParCreTmCtgrLvl(Integer parCreTmCtgrLvl) {
		this.parCreTmCtgrLvl = parCreTmCtgrLvl;
	}
	public String getParCreTmCtgrNm() {
		return parCreTmCtgrNm;
	}
	public void setParCreTmCtgrNm(String parCreTmCtgrNm) {
		this.parCreTmCtgrNm = parCreTmCtgrNm;
	}
	
	public List<CreTmCtgrVO> getSubList() {
		if(ValidationUtils.isEmpty(subList)) subList = new ArrayList<CreTmCtgrVO>();
		return subList;
	}
	public void setSubList(List<CreTmCtgrVO> subList) {
		this.subList = subList;
	}
	
	//-- vo 게체에 하위 겍체를 추가한다.
	public void addSubCtgr(CreTmCtgrVO vo) {
		vo.setParentCreTmCtgr(this);
		this.getSubList().add(vo);
	}
	
	public void setParentCreTmCtgr(CreTmCtgrVO parentCreTmCtgr) {
		this.parentCreTmCtgr = parentCreTmCtgr;
	}
	public String getParCreTmCtgrCdLvl1() {
		return parCreTmCtgrCdLvl1;
	}
	public void setParCreTmCtgrCdLvl1(String parCreTmCtgrCdLvl1) {
		this.parCreTmCtgrCdLvl1 = parCreTmCtgrCdLvl1;
	}
	public String getParCreTmCtgrCdLvl2() {
		return parCreTmCtgrCdLvl2;
	}
	public void setParCreTmCtgrCdLvl2(String parCreTmCtgrCdLvl2) {
		this.parCreTmCtgrCdLvl2 = parCreTmCtgrCdLvl2;
	}
	public String getParCreTmCtgrCdLvl3() {
		return parCreTmCtgrCdLvl3;
	}
	public void setParCreTmCtgrCdLvl3(String parCreTmCtgrCdLvl3) {
		this.parCreTmCtgrCdLvl3 = parCreTmCtgrCdLvl3;
	}
	public CreTmCtgrVO getParentCreTmCtgr() {
		return parentCreTmCtgr;
	}
	public String getParCreTmCtgrNmLvl1() {
		return parCreTmCtgrNmLvl1;
	}
	public void setParCreTmCtgrNmLvl1(String parCreTmCtgrNmLvl1) {
		this.parCreTmCtgrNmLvl1 = parCreTmCtgrNmLvl1;
	}
	public String getParCreTmCtgrNmLvl2() {
		return parCreTmCtgrNmLvl2;
	}
	public void setParCreTmCtgrNmLvl2(String parCreTmCtgrNmLvl2) {
		this.parCreTmCtgrNmLvl2 = parCreTmCtgrNmLvl2;
	}
	public String getParCreTmCtgrNmLvl3() {
		return parCreTmCtgrNmLvl3;
	}
	public void setParCreTmCtgrNmLvl3(String parCreTmCtgrNmLvl3) {
		this.parCreTmCtgrNmLvl3 = parCreTmCtgrNmLvl3;
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
