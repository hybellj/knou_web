package knou.framework.exception;

public class SessionExpiredException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2381253854273948270L;

	public SessionExpiredException(String message) {
        super(message);
    }
}