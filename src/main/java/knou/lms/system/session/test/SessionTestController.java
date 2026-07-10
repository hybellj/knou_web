package knou.lms.system.session.test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SessionTestController {

	/**
     * 세션 강제 만료
     */
    @RequestMapping(value={"/test/sessionExpire.do", "/test/admSessionExpire.do"})
    public String sessionExpire(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        return "redirect:/";
    }
}