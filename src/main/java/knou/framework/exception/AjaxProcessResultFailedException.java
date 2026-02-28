package knou.framework.exception;

public class AjaxProcessResultFailedException extends AjaxProcessException {
	private static final long serialVersionUID = -7610804591809608221L;

	public AjaxProcessResultFailedException() {
		super("common.message.request.failed");
	}

	public AjaxProcessResultFailedException(String message, Throwable cause) {
		super(message, cause);
	}

	public AjaxProcessResultFailedException(String message) {
		super(message + ".failed");
	}

	public AjaxProcessResultFailedException(String message, boolean suffixDisabled) {
		super(message);
	}

	public AjaxProcessResultFailedException(Throwable cause) {
		super(cause);
	}
}
