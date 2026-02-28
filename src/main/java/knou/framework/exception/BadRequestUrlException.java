package knou.framework.exception;

public class BadRequestUrlException extends AuthorityException {

	private static final long serialVersionUID = -7954102320447154958L;
	private static final String	DEFAULT_MESSAGE	= "common.message.organization.badurl";
	
	public BadRequestUrlException() {
		super(DEFAULT_MESSAGE);
	}

	public BadRequestUrlException(String message, Throwable cause) {
		super(message, cause);
	}

	public BadRequestUrlException(String message) {
		super(message);
	}

	public BadRequestUrlException(Throwable cause) {
		super(DEFAULT_MESSAGE, cause);
	}

}
