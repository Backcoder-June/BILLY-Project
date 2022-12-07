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
	
	// 페이징 totalPage Set
	public int setTotalPage(int totalboard, int totalPage) {
		if(totalboard % 10 == 0) {
			totalPage = totalboard/10;  
		}else {
			totalPage = totalboard/10 + 1; 
		}
		return totalPage;
	}
	
	// 파일 업로드 
	public void copyUploadFile(MultipartFile file1, String savePath, BoardDTO dto) throws IllegalStateException, IOException {
		String newname = null;
		String originalname1 = file1.getOriginalFilename(); 
		String onlyfilename = originalname1.substring(0, originalname1.indexOf("."));
		String extname = originalname1.substring(originalname1.indexOf("."));
		newname = onlyfilename +"("+UUID.randomUUID().toString()+")"+extname;
		File servefile1 = new File(savePath+newname); 
		file1.transferTo(servefile1);
		dto.setImg(newname);
	}
	
	
/* MAPPIPNG */	
	// 전체 리스트
	@GetMapping("/boardList")
	public String boardList(Model model, HttpSession session, @RequestParam(value="page", required = false, defaultValue = "1") int page) {
		// 페이징 수 Set
		int totalboard = boardService.getTotalBoard();
		int totalPage = page;
		totalPage = setTotalPage(totalboard, totalPage); 
		
		List<BoardDTO> boardlst = boardService.pagingList((page-1)*10);
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
		
		model.addAttribute("page", page);
		model.addAttribute("option", "normal");
		model.addAttribute("boardlst", boardlst);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("searchLankingList", searchLankingList);
		return "board/list";
	}
	
	// 내 동네 리스트
		@GetMapping("/myRegionboardList")
		public String myRegionList(Model model, @RequestParam(value="page", required = false, defaultValue = "1") int page, HttpSession session) {
			// 세션 Set
			String sessionid = "";
			if(session.getAttribute("sessionid")!=null) {
				sessionid = (String)session.getAttribute("sessionid");
			}
			
			//지역 Set 
			String region = "";
			if(sessionid != "") {
				String extraaddr = memberDAO.getRegion(sessionid);
				region = extraaddr;
			}
			
			// 페이징 수 Set
			int totalboard = boardService.getMyRegionTotalBoard(region);
			int totalPage = page;
			totalPage = setTotalPage(totalboard, totalPage);
			
			List<BoardDTO> boardlst = boardService.myRegionPagingList((page-1)*10, region);
			// 검색랭킹 
			List<String> searchLankingList = productService.searchLanking();
			
			model.addAttribute("page", page);
			model.addAttribute("region", region);
			model.addAttribute("option", "normal");
			model.addAttribute("boardlst", boardlst);
			model.addAttribute("totalPage", totalPage);
			model.addAttribute("searchLankingList", searchLankingList);
			return "board/myRegionList";
		}

	
	//글 작성 페이지
	@GetMapping("/boardwrite")
	public String writingform(Model model, HttpSession session) {
		// 세션 Set
		String sessionid = "";
		if(session.getAttribute("sessionid")!=null) {
			sessionid = (String)session.getAttribute("sessionid");
		}
		
		//지역 Set 
		String region = "";
		if(sessionid != "") {
			String extraaddr = memberDAO.getRegion(sessionid);
			region = extraaddr;
		}
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();				
		
		model.addAttribute("searchLankingList", searchLankingList);
		model.addAttribute("region", region);
		return "board/writingform";
	}
	
	
	//글 작성 
	@PostMapping("/boardwrite")
	public String writingprocess(@RequestParam(value="page", required = false, defaultValue = "1") int page, BoardDTO dto, MultipartFile file1) throws IOException {
//		String savePath = "c:/upload/";
		String savePath = "/upload/";
		
		// 파일 업로드
		if(!file1.isEmpty()) {
			copyUploadFile(file1, savePath, dto);
		}
		
		boardService.registerBoard(dto); 
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
		// 페이징 Set 	
		int totalPage = page;
		totalPage = setTotalPage(totalboard, totalPage);
		
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
		
		model.addAttribute("page", page);
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
		// 페이징 Set 	
		int totalPage = page;
		totalPage = setTotalPage(totalboard, totalPage);
		
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
		
		model.addAttribute("page", page);
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
	public String boarddetail(Model model, int seq, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String sessionId = (String)session.getAttribute("sessionid");
		
		int updateCount = boardService.updateSeq(seq);
		BoardDTO dto = boardService.getBoardSeqLst(seq);

		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
		
		model.addAttribute("searchLankingList", searchLankingList);
		model.addAttribute("updateSeq",updateCount);
		model.addAttribute("seqList",dto);
		model.addAttribute("sessionId",sessionId);
		return "board/detail2";
	}
	
	//글 삭제
	@GetMapping("/boarddelete")
	public String boardDelete(@RequestParam(value="page", required = false, defaultValue = "1") int page,int seq) {
		boardService.deleteBoard(seq);
		return "redirect:/boardList";
	}
	
	//글 수정 페이지
	@GetMapping("/boardupdate/{boardid}")
	public String updateBoard(@PathVariable("boardid")int seq, Model model) {
		BoardDTO dto = boardService.getBoardSeqLst(seq);
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();		
		
		model.addAttribute("searchLankingList", searchLankingList);
		model.addAttribute("updated_board",dto);
		return "board/updateform";
	}
	
	//글 수정
	@PostMapping("/boardupdate/{boardid}")
	public String updateBoardprocess(@PathVariable("boardid")int seq, BoardDTO dto, MultipartFile file1) throws IllegalStateException, IOException {
//		String savePath = "c:/upload/";
		String savePath = "/upload/";
		// 파일 업로드 
		if(!file1.isEmpty()) {
			copyUploadFile(file1, savePath, dto);
		}
		
		boardService.updateBoard(dto);
		return "redirect:/boardList";
	}

	
}