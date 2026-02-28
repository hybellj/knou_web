package knou.lms.seminar.api.users.vo;

import java.io.Serializable;
import java.util.Arrays;

import com.fasterxml.jackson.annotation.JsonProperty;

import knou.lms.seminar.api.users.UserType;

public class UsersInfoVO implements Serializable {

	private static final long serialVersionUID = 5740937554560243762L;
	
	@JsonProperty("id")
	private String id;
	
	@JsonProperty("email")
	private String email;
	
	@JsonProperty("type")
	private int type = UserType.BASIC.getUserType();
	
	@JsonProperty("first_name")
	private String firstName;
	
	@JsonProperty("last_name")
	private String lastName;
	
	@JsonProperty("password")
	private String password;
	
	@JsonProperty("role_name")
	private String roleName;
	
	@JsonProperty("verified")
	private int verified;
	
	@JsonProperty("login_types")
	private int[] loginTypes;
	
	@JsonProperty("timezone")
	private String timezone;
	
	@JsonProperty("language")
	private String language;
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getType() {
		return type;
	}
	public void setType(int i) {
		this.type = i;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getRoleName() {
		return roleName;
	}
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	public int getVerified() {
		return verified;
	}
	public void setVerified(int verified) {
		this.verified = verified;
	}
	public int[] getLoginTypes() {
		return loginTypes;
	}
	public void setLoginTypes(int[] loginTypes) {
		this.loginTypes = loginTypes;
	}	
	public String getTimezone() {
		return timezone;
	}

	public void setTimezone(String timezone) {
		this.timezone = timezone;
	}
	public String getLanguage() {
		return language;
	}
	
	public void setLanguage(String language) {
		this.language = language;
	}
	

	// Error 로그출력용
	@Override
	public String toString() {
		return "UserInfoVO [id=" + id + ", email=" + email + ", type=" + type + ", firstName=" + firstName
				+ ", lastName=" + lastName + ", password=" + password + ", roleName=" + roleName + ", verified="
				+ verified + ", loginTypes=" + Arrays.toString(loginTypes) + ", timezone=" + timezone + ", language="
				+ language + "]";
	}
}
