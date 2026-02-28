package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.List;

public class DataDownEntityVO {
	
	private String key;
	private String name;
	private String gender;
	private String ages;	
	private String married;
	private List<FileDownEntityVO> attachements;

	public DataDownEntityVO() {
		this.setAttachements(new ArrayList<FileDownEntityVO>());
	}
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getAges() {
		return ages;
	}
	public void setAges(String ages) {
		this.ages = ages;
	}
	
	public String getMarried() {
		return married;
	}
	public void setMarried(String married) {
		this.married = married;
	}	
	
	public List<FileDownEntityVO> getAttachements() {
		return attachements;
	}
	public void setAttachements(List<FileDownEntityVO> attachements) {
		this.attachements = attachements;
	}
	
	public int getAttachCount() {
		return attachements == null ? 0 : attachements.size();
	}
}
