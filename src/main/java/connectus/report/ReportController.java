package connectus.report;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ReportController {
	@Autowired
	ReportDAO ReportDAO;
	
	@GetMapping("/reportregister")
	public String insertReportform() {
		return "report/allreport";
	}
	
	@PostMapping("/reportregister")
	public String  insertReport(ReportDTO dto) {
		 ReportDAO.insertReport(dto);
		return "redirect:/reportregister";
	}
	

	// 약관 정책 페이지 
	@RequestMapping(value = "/customer")
	public String customer() {
		return "report/customer";
	}
	
	@RequestMapping(value = "/story")
	public String story() {
		return "report/story";
	}
	
}
