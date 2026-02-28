package knou.lms.file.web;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import devpia.dextuploadnj.FileItem;

import knou.lms.file.vo.FileUpEntityVO;
import knou.lms.file.vo.FileUpRepository;

@Controller
public class ExtensionFileServiceController {
	
	@RequestMapping(value = "/service/extension-upload.up", method = RequestMethod.POST)
	public void extensionupload(DEXTUploadX5Request x5, HttpServletResponse response) throws IOException {
		
		FileItem item = (FileItem)x5.getDEXTUploadX5_FileData().get(0);

		if (item.isEmpty() == false) {
			item.save();
			
			FileUpEntityVO file = new FileUpEntityVO();
			file.setFieldName(item.getFieldName());
			file.setFilename(item.getFilename());
			file.setMime(item.getContentType());
			file.setSize(item.getFileSize());
			file.setFile(new File(item.getLastSavedFilePath()));
			
			// 파일 정보를 DB에 등록했다고 가정하고 키값을 반환 받는다.
			String key = FileUpRepository.addFileEntity(file);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/plain");
			
			// 파일의 키를 응답 데이터에 기록한다.
			response.getWriter().write(key);
		} else {
			throw new IllegalStateException("올바른 요청이 아닙니다.");
		}
	}

	
}
