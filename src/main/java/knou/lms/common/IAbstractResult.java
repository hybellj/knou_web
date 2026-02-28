package knou.lms.common;

public interface IAbstractResult {

	public abstract String getMessage();

	public abstract void setMessage(String message);

	public abstract int getResult();

	public abstract void setResult(int result);

	public abstract int getPageAuthor();

	public abstract void setPageAuthor(int pageAuthor);

}