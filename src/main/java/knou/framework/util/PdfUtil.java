package knou.framework.util;

import java.io.File;
import java.io.IOException;

import org.apache.fontbox.ttf.TrueTypeCollection;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.font.PDType0Font;

/**
 * PDF 유틸리티
 * 
 * @author shil
 */
public class PdfUtil {
	private static File fontFileBatang = null;
	private static File fontFileGulim = null;
	private static File fontFileMalgun = null;
	private static File fontFileNanum = null;

	public final static String FONT_GULIM = "Gulim";			// 굴림
	public final static String FONT_DOTUM = "Dotum";			// 돋움
	public final static String FONT_BATANG = "Batang";		// 바탕
	public final static String FONT_GUNGSUH = "Gungsuh";		// 궁서
	public final static String FONT_MALGUN = "Malgun";		// 맑은 고딕
	public final static String FONT_NANUM = "Nanum";			// 나눔 고딕
	
	
	/**
	 * 폰트 가져오기
	 * @param doc
	 * @param fontName
	 * @return font
	 */
	@SuppressWarnings("resource")
	public static PDType0Font getFont(PDDocument doc, String fontName) {
		PDType0Font font = null;
		try {
			File fontFile = null;
			if (fontName == null || fontName.equals("") || fontName.equals(FONT_MALGUN)) {
				if (fontFileMalgun == null) {
					fontFileMalgun = getFontFile("malgun.ttf");
				}
				fontFile = fontFileMalgun;
			}
			else if (fontName.equals(FONT_GULIM) || fontName.equals(FONT_DOTUM)) {
				if (fontFileGulim == null) {
					fontFileGulim = getFontFile("gulim.ttc");
				}
				fontFile = fontFileGulim;
			}
			else if (fontName.equals(FONT_BATANG) || fontName.equals(FONT_GUNGSUH)) {
				if (fontFileBatang == null) {
					fontFileBatang = getFontFile("batang.ttc");
				}
				fontFile = fontFileBatang;
			}
			else if (fontName.equals(FONT_NANUM)) {
				if (fontFileNanum == null) {
					fontFileNanum = getFontFile("NanumGothic.ttf");
				}
				fontFile = fontFileNanum;
			}
			else {
				if (fontFileMalgun == null) {
					fontFileMalgun = getFontFile("malgun.ttf");
				}
				fontFile = fontFileMalgun;
			}
			
			if (fontFile.getName().indexOf(".ttf") > 0) {
				font = PDType0Font.load(doc,fontFile);
			}
			else {
				font = PDType0Font.load(doc, new TrueTypeCollection(fontFile).getFontByName(fontName), true);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return font;
	}
	
	
	/**
	 * 폰트파일 가져오기
	 * @param fileName
	 * @return
	 */
	private static File getFontFile(String fileName) {
		String path = PdfUtil.class.getResource(".").getPath();
		path = path.substring(0, path.indexOf("WEB-INF")) + "web-resources/fonts/";
		
		File fontFile =  new File(path + fileName);
		return fontFile;
	}
	
}
