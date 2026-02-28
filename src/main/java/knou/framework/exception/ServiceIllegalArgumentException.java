package knou.framework.exception;
/**
 * 일반 서비스 레이어에서 잘못된 인자가 넘어왔을 때 발생하는 Exception.
 * Assert 유틸에서 주로 발생시키며 잘못된 인자가 발생했을 때 사용하시면 됩니다.
 * @author SungKook
 */
public class ServiceIllegalArgumentException
		extends ServiceProcessException {

	private static final long	serialVersionUID	= -1405376205096757565L;

	public ServiceIllegalArgumentException() {
		super();
	}

	public ServiceIllegalArgumentException(String message, Throwable cause) {
		super(message, cause);
	}

	public ServiceIllegalArgumentException(String message) {
		super(message);
	}

	public ServiceIllegalArgumentException(Throwable cause) {
		super(cause);
	}

	
	
}
