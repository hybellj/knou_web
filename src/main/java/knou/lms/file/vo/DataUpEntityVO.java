package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.List;

public class DataUpEntityVO {	
	
	private String key;
	private String text1;
	private String radio1;
	private String checkbox1;
	private String checkbox2;
	private String checkbox3;
	private String select1;
	private List<FileUpEntityVO> files;
	private String deleteDescription;
	
	public DataUpEntityVO() {
		this.setFiles(new ArrayList<FileUpEntityVO>());
	}
	
	public String getKey() {
		return key;
	}
	
	public void setKey(String key) {
		this.key = key;
	}

	public String getText1() {
		return text1;
	}

	public void setText1(String text1) {
		this.text1 = text1;
	}	

	public String getRadio1() {
		return radio1;
	}

	public void setRadio1(String radio1) {
		this.radio1 = radio1;
	}

	public String getCheckbox1() {
		return checkbox1;
	}

	public void setCheckbox1(String checkbox1) {
		this.checkbox1 = checkbox1;
	}

	public String getCheckbox2() {
		return checkbox2;
	}

	public void setCheckbox2(String checkbox2) {
		this.checkbox2 = checkbox2;
	}

	public String getCheckbox3() {
		return checkbox3;
	}

	public void setCheckbox3(String checkbox3) {
		this.checkbox3 = checkbox3;
	}

	public String getSelect1() {
		return select1;
	}

	public void setSelect1(String select1) {
		this.select1 = select1;
	}
	
	public List<FileUpEntityVO> getFiles() {
		return files;
	}
	
	private void setFiles(List<FileUpEntityVO> files) {
		this.files = files;
	}
	
	public int getFileCount() {
		return files.size();
	}

	public String getDeleteDescription() {
		return deleteDescription;
	}

	public void setDeleteDescription(String deleteDescription) {
		this.deleteDescription = deleteDescription;
	}
}
