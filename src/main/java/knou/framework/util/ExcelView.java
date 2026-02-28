package knou.framework.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.poifs.crypt.EncryptionInfo;
import org.apache.poi.poifs.crypt.EncryptionMode;
import org.apache.poi.poifs.crypt.Encryptor;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractXlsxView;


public class ExcelView extends AbstractXlsxView {
    
    public static String HSSF_CONTENT_TYPE = "application/vnd.ms-excel";
    public static String XSSF_CONTENT_TYPE = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

	@Override
	protected Workbook createWorkbook(Map<String, Object> model, HttpServletRequest request) {
		return (Workbook) model.get("workbook"); //HSSFWorkbook(xls) , XSSFWorkbook(xlsx)
	}

	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String excelName = model.get("outFileName").toString();
		if(workbook instanceof HSSFWorkbook) {
			excelName +=".xls";
		}else if(workbook instanceof XSSFWorkbook){
			excelName +=".xlsx";
		}else if (workbook instanceof SXSSFWorkbook) {
		    excelName +=".xlsx";
        }
	    
		String password = (String) model.get("password");
		
	    try {
	    	response.setHeader("Content-Disposition", "attachement; filename=\""+ java.net.URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", "%20") + "\";charset=\"UTF-8\"");
	    	
	    	// 엑셀파일 암호 적용
	    	if(!"".equals(StringUtil.nvl(password))) {
	    	    ByteArrayOutputStream fileOut = new ByteArrayOutputStream();
	    	    if(workbook instanceof HSSFWorkbook) {
	    	        ((HSSFWorkbook) workbook).write(fileOut);
	            }else if(workbook instanceof XSSFWorkbook) {
	                ((XSSFWorkbook) workbook).write(fileOut);
	            }else if (workbook instanceof SXSSFWorkbook) {
	                ((SXSSFWorkbook) workbook).write(fileOut);
	            }
	            
	            ByteArrayInputStream fileIn = new ByteArrayInputStream(fileOut.toByteArray());
	            POIFSFileSystem fs = new POIFSFileSystem();
	            EncryptionInfo info = new EncryptionInfo(EncryptionMode.agile);
	            Encryptor enc = info.getEncryptor();
	           
	            enc.confirmPassword(password);
	            
	            OPCPackage opc = OPCPackage.open(fileIn);
	            OutputStream os = enc.getDataStream(fs);
	            opc.save(os);
	            opc.close();
	            
	            ServletOutputStream out = null;
	            
	            out = response.getOutputStream();
	            fs.writeFilesystem(out);
	            out.close();
	            fileOut.close();
	    	}
	    } catch (UnsupportedEncodingException e) {
	        e.printStackTrace();
	    }
	}
	
    @Override
    protected void renderWorkbook(Workbook workbook, HttpServletResponse response) throws IOException {
        ServletOutputStream out = response.getOutputStream();

        if(workbook instanceof HSSFWorkbook) {
            setContentType(HSSF_CONTENT_TYPE);
            ((HSSFWorkbook) workbook).write(out);
        } else if(workbook instanceof XSSFWorkbook){
            setContentType(XSSF_CONTENT_TYPE);
            ((XSSFWorkbook) workbook).write(out);
        }else if (workbook instanceof SXSSFWorkbook) {
            setContentType(XSSF_CONTENT_TYPE);
            ((SXSSFWorkbook) workbook).write(out);
        }
        
        // Closeable only implemented as of POI 3.10
        if (workbook instanceof Closeable) {
            ((Closeable) workbook).close();
        }
    }
}
