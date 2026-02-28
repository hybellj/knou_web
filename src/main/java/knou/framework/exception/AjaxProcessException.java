package knou.framework.exception;


/**
 * Ajax처리중 발생하는 Exception중 최상위 Exception.
 * DispatchAction에서 캐치해서 메시지를 alert으로 표시한다.
 */
public class AjaxProcessException
		extends MediopiaDefineException {

	private static final long	serialVersionUID	= 7972012849071886436L;

	public AjaxProcessException() {
		super();
	}

	public AjaxProcessException(String message, Throwable cause) {
		super(message, cause);
	}

	public AjaxProcessException(String message) {
		super(message);
	}

	public AjaxProcessException(Throwable cause) {
		super(cause);
	}
}
