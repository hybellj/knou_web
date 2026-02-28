package knou.framework.exception;




public class AuthorityException
		extends MediopiaDefineException {

	private static final long	serialVersionUID	= -111287558424266784L;
	
	public AuthorityException() {
		super();
	}

	public AuthorityException(String message, Throwable cause) {
		super(message, cause);
	}

	public AuthorityException(String message) {
		super(message);
	}

	public AuthorityException(Throwable cause) {
		super(cause);
	}

}
