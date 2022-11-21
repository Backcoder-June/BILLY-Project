package connectus.board;


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import connectus.member.MemberDAO;
import connectus.product.ProductService;



@Controller
public class BoardController {
	@Autowired
	BoardService boardService;
	@Autowired
	ProductService productService;
	@Autowired
	MemberDAO memberDAO;
	
	// 전체 리스트
	@GetMapping("/boardList")
	public String boardList(Model model, HttpSession session, @RequestParam(value="page", required = false, defaultValue = "1") int page) {

		
		int totalboard = boardService.getTotalBoard();
		
		int totalPage = page;
		if(totalboard % 10 == 0) {
			totalPage = totalboard/10;  
		}else {
			totalPage = totalboard/10 + 1; 
		}
		
	
		List<BoardDTO> boardlst = boardService.pagingList((page-1)*10);
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();

		model.addAttribute("option", "normal");
		model.addAttribute("boardlst", boardlst);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("searchLankingList", searchLankingList);
		return "board/list";
	}
	
	// 내 동네 리스트
		@GetMapping("/myRegionboardList")
		public String myRegionList(Model model, @RequestParam(value="page", required = false, defaultValue = "1") int page, HttpSession session) {
			String region = "동";
			String sessionid = (String)session.getAttribute("sessionid");
			// 지역 set 
			if(sessionid != null) {
			String extraaddr = memberDAO.getRegion(sessionid);
			region = extraaddr;
			}
			int totalboard = boardService.getMyRegionTotalBoard(region);
			
			int totalPage = page;
			if(totalboard % 10 == 0) {
				totalPage = totalboard/10;  
			}else {
				totalPage = totalboard/10 + 1; 
			}
			
		
			List<BoardDTO> boardlst = boardService.myRegionPagingList((page-1)*10, region);
			// 검색랭킹 
			List<String> searchLankingList = productService.searchLanking();
			
			model.addAttribute("region", region);
			model.addAttribute("option", "normal");
			model.addAttribute("boardlst", boardlst);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("searchLankingList", searchLankingList);
			return "board/myRegionList";
		}

	
	

	
	@GetMapping("/boardwrite")
	public String writingform(Model model, HttpSession session) {
		String region = "동";
		String sessionid = (String)session.getAttribute("sessionid");
		// 지역 set 
		if(sessionid != null) {
		String extraaddr = memberDAO.getRegion(sessionid);
		region = extraaddr;
		}
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();				
		model.addAttribute("searchLankingList", searchLankingList);
		model.addAttribute("region", region);
		return "board/writingform";
	}
	
	@PostMapping("/boardwrite")
	public String writingprocess(@RequestParam(value="page", required = false, defaultValue = "1") int page, BoardDTO dto, MultipartFile file1) throws IOException {
		String savePath = "c:/upload/";

		String newname = null;
		if(!file1.isEmpty()) {
			
			String originalname1 = file1.getOriginalFilename(); //a.txt
			String onlyfilename = originalname1.substring(0, originalname1.indexOf("."));
			String extname = originalname1.substring(originalname1.indexOf(".")); // .txt
			newname = onlyfilename +"("+UUID.randomUUID().toString()+")"+extname;
			File servefile1 = new File(savePath+newname); // a(012334434).txt
			file1.transferTo(servefile1);
			dto.setImg(newname);
		}

		boardService.registerBoard(dto); //
		
		return "redirect:boardList";
	}
	
	
	// 검색 
	@GetMapping("/boardSearch")
	public String boardSearch(String boardsearch, String searchOption, Model model, @RequestParam(value="page", required = false, defaultValue = "1") int page) {
		List<BoardDTO> boardlst = new ArrayList<>();
		int totalboard = 0; 
		if(searchOption.equals("전체")) {
			boardlst = boardService.getSearchListByAll(boardsearch, (page-1)*10);
			totalboard = boardService.getSearchByAllCount(boardsearch);
		}else {
			if(searchOption.equals("제목")) {
				searchOption = "title";
			}else if(searchOption.equals("작성자")) {
				searchOption = "writer";
			}
			
			HashMap map = new HashMap<>();
			map.put("searchOption", searchOption);
			map.put("boardsearch", boardsearch);
			map.put("limit", (page-1)*10);
			
			totalboard = boardService.getSearchCount(map);
			boardlst = boardService.getSearchList(map);
		}
			
		int totalPage = page;
		if(totalboard % 10 == 0) {
			totalPage = totalboard/10;  
		}else {
			totalPage = totalboard/10 + 1; 
		}
		
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
		
		model.addAttribute("searchOption", searchOption);
		model.addAttribute("boardsearch", boardsearch);
		model.addAttribute("option", "search");
		model.addAttribute("boardlst", boardlst);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("searchLankingList", searchLankingList);
		return "board/list";
	}
	
	// 내 동네 + 검색 
		@GetMapping("/myRegionBoardSearch")
		public String myRegionboardSearch(String region, String boardsearch, String searchOption, Model model, @RequestParam(value="page", required = false, defaultValue = "1") int page) {
			List<BoardDTO> boardlst = new ArrayList<>();
			int totalboard = 0; 
			if(searchOption.equals("전체")) {
				boardlst = boardService.getMyRegionSearchListByAll(boardsearch, (page-1)*10, region);
				totalboard = boardService.getMyReionSearchByAllCount(boardsearch, region);
			}else {
				if(searchOption.equals("제목")) {
					searchOption = "title";
				}else if(searchOption.equals("작성자")) {
					searchOption = "writer";
				}
				
				
				HashMap map = new HashMap<>();
				map.put("searchOption", searchOption);
				map.put("boardsearch", boardsearch);
				map.put("limit", (page-1)*10);
				map.put("region", region);
				
				totalboard = boardService.getMyRegionSearchCount(map);
				boardlst = boardService.getMyRegionSearchList(map);
			}
				
			int totalPage = page;
			if(totalboard % 10 == 0) {
				totalPage = totalboard/10;  
			}else {
				totalPage = totalboard/10 + 1; 
			}
			
			// 검색랭킹 
			List<String> searchLankingList = productService.searchLanking();
			
			model.addAttribute("region", region);
			model.addAttribute("searchOption", searchOption);
			model.addAttribute("boardsearch", boardsearch);
			model.addAttribute("option", "search");
			model.addAttribute("boardlst", boardlst);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("searchLankingList", searchLankingList);
			return "board/myRegionList";
		}
	
	
	
	
	
	
	// 상세페이지
	@GetMapping("/boarddetail")
	public ModelAndView boarddetail(int seq,HttpServletRequest request, HttpServletResponse response,String Clicked) {
		

		
		HttpSession session = request.getSession();
		String sessionId = (String)session.getAttribute("sessionid");
		
		int updateCount = boardService.updateSeq(seq);
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
					
		//조회 리턴
		BoardDTO dto = boardService.getBoardSeqLst(seq);
		ModelAndView mv = new ModelAndView();
		mv.addObject("searchLankingList", searchLankingList);
		mv.addObject("updateSeq",updateCount);
		mv.addObject("seqList",dto);
		mv.addObject("sId",sessionId);
		mv.setViewName("board/detail2");
		
		return mv;
		
		
	}
	
	@GetMapping("/boarddelete")
	public String boardDelete(@RequestParam(value="page", required = false, defaultValue = "1") int page,int seq) {
		int deleteCount = boardService.deleteBoard(seq);
		return "redirect:/boardList";
	}
	
	@GetMapping("/boardupdate/{boardid}")
	ModelAndView updateBoard(@PathVariable("boardid")int seq) {
		//seq 글 조회 (BoardDTO)
		BoardDTO dto = boardService.getBoardSeqLst(seq);
		
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();		
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("searchLankingList", searchLankingList);
		mv.addObject("updated_board",dto);
		mv.setViewName("board/updateform");
		return mv;
	}

	@PostMapping("/boardupdate/{boardid}")
	String updateBoardprocess(@PathVariable("boardid")int seq, BoardDTO dto, MultipartFile file1 ) throws IllegalStateException, IOException {
		


//		String savePath = "/Users/youngban/upload/";
		String savePath = "c:/upload/";


		String newname = null;
//		System.out.println(file1);
		if(!file1.isEmpty()) {
			
			String originalname1 = file1.getOriginalFilename(); //a.txt
			String onlyfilename = originalname1.substring(0, originalname1.indexOf("."));
			String extname = originalname1.substring(originalname1.indexOf(".")); // .txt
			newname = onlyfilename +"("+UUID.randomUUID().toString()+")"+extname;
			File servefile1 = new File(savePath+newname); // a(012334434).txt
			file1.transferTo(servefile1);
			dto.setImg(newname);
		}
		
		boardService.updateBoard(dto);
		
		return "redirect:/boardList";

	}
}
