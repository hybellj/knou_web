package knou.framework.exception;

public class SessionTimeoutException extends Exception {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7709488569816323595L;

	public SessionTimeoutException(String message) {
		super(message);
	}
}
