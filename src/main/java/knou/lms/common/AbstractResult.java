package knou.lms.common;

/**
 * Result 관련 최상위 클래스
 * 
 * @author jamfam
 */
public class AbstractResult implements IAbstractResult {
	
	private int result = 0; // 처리 결과
	private String message; // 결과 메시지
	private int pageAuthor = 0; // 페이지 권한

	// 기본생성자
	public AbstractResult() {
	}

	/**
	 * {@code result}값을 설정하는 생성자
	 * 
	 * @param result
	 */
	public AbstractResult(int result) {
		super();
		this.result = result;
	}

	/**
	 * {@code result}값과 메시지를 설정하는 생성자
	 * 
	 * @param result
	 */
	public AbstractResult(int result, String message) {
		super();
		this.result = result;
		this.message = message;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public int getResult() {
		return result;
	}

	public void setResult(int result) {
		this.result = result;
	}

	public int getPageAuthor() {
		return pageAuthor;
	}

	public void setPageAuthor(int pageAuthor) {
		this.pageAuthor = pageAuthor;
	}
}
