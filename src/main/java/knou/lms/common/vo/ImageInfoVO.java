package knou.lms.common.vo;

/**
 * getSize에서 반환할때 사용할 InnerClass.
 * 생성자로만 맴버변수를 설정할 수 있으며 이후 읽기만 가능하다.
 * @author Jamfam
 *
 * @see ImageUtil#getSize(java.io.File)
 */
public class ImageInfoVO {

	private final int width;
	private final int height;
	
	public ImageInfoVO(final int width, final int height) {
		this.width = width;
		this.height = height;
	}

	public int getWidth() {
		return width;
	}

	public int getHeight() {
		return height;
	}
}
