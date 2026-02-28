package knou.framework.exception;


public class AccessDeniedException
		extends AuthorityException {

	private static final long	serialVersionUID	= 1999844704184535897L;
	private static final String	DEFAULT_MESSAGE	= "common.message.framework.auth.noauth";
	
	public AccessDeniedException() {
		super(DEFAULT_MESSAGE);
	}

	public AccessDeniedException(String message, Throwable cause) {
		super(message, cause);
	}

	public AccessDeniedException(String message) {
		super(message);
	}

	public AccessDeniedException(Throwable cause) {
		super(DEFAULT_MESSAGE, cause);
	}

}
