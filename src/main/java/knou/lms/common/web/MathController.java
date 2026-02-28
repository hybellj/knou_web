package knou.lms.common.web;

import java.io.File;
import java.util.Base64;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.nfbsoftware.latex.LaTeXConverter;

import knou.framework.util.StringUtil;

/**
 * 수식편집기 변환 Controller
 */
@Controller
@RequestMapping("/math")
public class MathController {

	/**
	 * 수식을 이미지로 변환 (Base64 인코딩)
	 * @param request
	 * @param response
	 * @param model
	 * @return imgSrc
	 * @throws Exception
	 */
    @RequestMapping(value = "/mathToImage.do")
	public ModelAndView mathToImage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String data = StringUtil.nvl(request.getParameter("data"));
		String imgSrc = "";
		
		try {
			File image = LaTeXConverter.convertToImage(data);
			byte[] fileContent = FileUtils.readFileToByteArray(image);
			imgSrc = "data:image/png;base64,"+Base64.getEncoder().encodeToString(fileContent);
		}
		catch (Exception e) {
			System.out.println("Latex to Image convert error : [ "+data+" ]");
			System.out.println(e.toString());
		}
		
		model.addAttribute("imgSrc", imgSrc);

		return new ModelAndView("jsonView", model);
	}
	
}
