package knou.lms.file.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import devpia.dextuploadnj.FileItem;
import knou.lms.file.vo.DataDownEntityVO;
import knou.lms.file.vo.DataDownRepository;
import knou.lms.file.vo.FileDownEntityVO;
import knou.lms.file.vo.FileDownRepository;
import knou.lms.file.vo.FileUtils;

@Controller
public class FileDextUploadController {

	@RequestMapping(value = "/upload/upload-single.do", method = RequestMethod.POST)
	public String upload(@RequestParam(value = "file1") MultipartFile file1) {

		String key = "NONE";

		// devpia.dextuploadnj.FileItem 인터페이스로 캐스팅한다.
		FileItem item = (FileItem)file1;

		if(!item.isEmpty()) {
			// 실제 저장할 위치로 임시 파일을 저장(복사 혹은 이동)한다.
			// 인자로 주어진 디렉터리 경로가 없다면 Environment#setDefaultRepository 메소드로 설정된 경로가 타겟이 된다.
			item.save();

			// FileDextEntity 클래스는 업로드된 파일 정보를 담고 있는 엔티티 형식의 클래스이다.
			// 그러나 이 클래스는 샘플 구성을 위해 작성된 클래스로써 DEXTUploadNJ 컴포넌트에 포함된 클래스가 아니다.
			// 파일을 업로드/다운로드하는 과정의 이해를 돕기 위해서 사용된다.
			FileDownEntityVO entity = new FileDownEntityVO();
			entity.setFieldName(item.getFieldName());
			entity.setOriginalFilename(item.getFilename());
			entity.setFileSize(item.getFileSize());
			entity.setMimeType(item.getContentType());
			entity.setFilePath(item.getLastSavedFilePath());

			// FileDextRepository 클래스는 업로드된 파일 정보들을 기록하는 레파지토리(일종의 DB 역할의 의미) 클래스이다.
			// FileDextEntity 클래스와 마찬가지로 샘플 구성과 이해를 돕기 위해서 작성되었다.
			key = FileDownRepository.addFileEntity(entity);
		}
		return "redirect:/upload/view-single.do?key=".concat(key);
	}

	@RequestMapping(value = "/upload/upload-multiple.do", method = RequestMethod.POST)
	public String upload(
			@RequestParam(value = "file1") MultipartFile file1, 
			@RequestParam(value = "files") MultipartFile[] files) {

		List<String> keys = new ArrayList<String>();

		FileItem item = (FileItem)file1;

		if(!item.isEmpty()) {

			item.save();

			FileDownEntityVO entity = new FileDownEntityVO();
			entity.setFieldName(item.getFieldName());
			entity.setOriginalFilename(item.getFilename());
			entity.setFileSize(item.getFileSize());
			entity.setMimeType(item.getContentType());
			entity.setFilePath(item.getLastSavedFilePath());

			keys.add(FileDownRepository.addFileEntity(entity));
		}

		for(MultipartFile next : files) {

			item = (FileItem)next;

			if(item.isEligibleFile()) {

				item.save();

				FileDownEntityVO entity = new FileDownEntityVO();
				entity.setFieldName(item.getFieldName());
				entity.setOriginalFilename(item.getFilename());
				entity.setFileSize(item.getFileSize());
				entity.setMimeType(item.getContentType());
				entity.setFilePath(item.getLastSavedFilePath());

				keys.add(FileDownRepository.addFileEntity(entity));
			}

		}
		return "redirect:/upload/view-multiple.do?keys=".concat(FileUtils.join(keys, ","));
	}
	
	@RequestMapping(value = "/upload/upload-form.do", method = RequestMethod.POST)
	public String upload(
			// DataEntity 클래스는 VO 클래스이다.
			DataDownEntityVO data,
			@RequestParam(value = "files") MultipartFile[] files) {

		FileItem item = null;

		for(MultipartFile next : files) {

			item = (FileItem)next;

			if(!item.isEmpty()) {
		
				item.save();

				FileDownEntityVO file = new FileDownEntityVO();
				file.setFieldName(item.getFieldName());
				file.setOriginalFilename(item.getFilename());
				file.setFileSize(item.getFileSize());
				file.setMimeType(item.getContentType());
				file.setFilePath(item.getLastSavedFilePath());

				data.getAttachements().add(file);
			}

		}

		// DataRepository 클래스는 업로드된 정보들을 기록하는 레파지토리(일종의 DB 역할의 의미) 클래스이다.
		// DataEntity 클래스와 마찬가지로 샘플 구성과 이해를 돕기 위해서 작성되었다.
		String dataKey = DataDownRepository.addDataEntity(data);

		return "redirect:/upload/view-form.do?dkey=".concat(dataKey);
	}
	
	@RequestMapping(value = "/upload/view-single.do", method = RequestMethod.GET)
	public ModelAndView viewSingle(@RequestParam(value = "key") String key) {
		FileDownEntityVO entity = FileDownRepository.getFileEntity(key);
		return new ModelAndView("/upload/view-single", "file", entity);
	}

	@RequestMapping(value = "/upload/view-multiple.do", method = RequestMethod.GET)
	public ModelAndView viewMultiple(@RequestParam(value = "keys") String keys) {
		List<FileDownEntityVO> files = FileDownRepository.getFileEntities(FileUtils.toList(keys.split(",")));
		return new ModelAndView("/upload/view-multiple", "files", files);
	}

	@RequestMapping(value = "/upload/view-form.do", method = RequestMethod.GET)
	public ModelAndView viewForm(@RequestParam(value = "dkey") String dkey) {
		DataDownEntityVO data = DataDownRepository.getDataEntity(dkey);
		return new ModelAndView("/upload/view-form", "data", data);
	}

	@RequestMapping(value = "/upload/exam-001.do", method = RequestMethod.GET)
	public String exam0001() {
		return "/upload/001";
	}
	
	@RequestMapping(value = "/upload/exam-002.do", method = RequestMethod.GET)
	public String exam0002() {
		return "/upload/002";
	}
	
	@RequestMapping(value = "/upload/exam-003.do", method = RequestMethod.GET)
	public String exam0003() {
		return "/upload/003";
	}

}
