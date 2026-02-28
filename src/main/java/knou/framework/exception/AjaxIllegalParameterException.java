package knou.framework.exception;


public class AjaxIllegalParameterException
		extends AjaxProcessException {

	private static final long	serialVersionUID	= -7924760429764770661L;

	public AjaxIllegalParameterException() {
		super();
	}

	public AjaxIllegalParameterException(String message, Throwable cause) {
		super(message, cause);
	}

	public AjaxIllegalParameterException(String message) {
		super(message);
	}

	public AjaxIllegalParameterException(Throwable cause) {
		super(cause);
	}
	
}
