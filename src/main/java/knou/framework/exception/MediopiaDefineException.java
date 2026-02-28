package knou.framework.exception;
/**
 * 메디오피아 어플리케이션에서 직접 정의해서 사용하는 Exception중 최상위 Exception
 * @author SungKook
 *
 */
public class MediopiaDefineException
		extends RuntimeException {

	private static final long	serialVersionUID	= -1224554256587508757L;

	public MediopiaDefineException() {
		super();
	}

	public MediopiaDefineException(String message, Throwable cause) {
		super(message, cause);
	}

	public MediopiaDefineException(String message) {
		super(message);
	}

	public MediopiaDefineException(Throwable cause) {
		super(cause);
	}
}
