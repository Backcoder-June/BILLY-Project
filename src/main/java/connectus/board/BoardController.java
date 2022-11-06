package connectus.board;


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
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

import connectus.product.ProductService;



@Controller
public class BoardController {
	@Autowired
	BoardService boardService;
	@Autowired
	ProductService productService;
	
	// 전체 게시판 
	@GetMapping("/boardstart")
	public String boardList(Model model, @RequestParam(value="page", required = false, defaultValue = "1") int page) {
		int totalboard = boardService.getTotalBoard();
	
		List<BoardDTO> boardlst = boardService.paginglist(new int[] {(page-1)*10, 10});
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();
				
		model.addAttribute("boardlst", boardlst);
		model.addAttribute("boardUrl", "boardlist");
		model.addAttribute("totalboard",totalboard);
		model.addAttribute("searchLankingList", searchLankingList);
		return "board/list";
	}

	
	@GetMapping("/boardwrite")
	public String writingform(Model model) {
		// 검색랭킹 
		List<String> searchLankingList = productService.searchLanking();				
		model.addAttribute("searchLankingList", searchLankingList);
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
		}else {
			dto.setImg("noimage.png");
		}
		
		int totalboard = boardService.getTotalBoard();
		
		List<BoardDTO> boardlst = boardService.paginglist(new int[] {(page-1)*3, 3});

		boardService.registerBoard(dto); //
		
		return "redirect:boardstart";
	}
	
	
	// 검색 
	@GetMapping("/boardContent")
	public String boardContent(Model model, @RequestParam(value="page", required = false, defaultValue = "1") int page,HttpServletRequest request) {
		String selectVal = request.getParameter("selectOption");
		String searchVal = request.getParameter("boardsearch");
		List<BoardDTO> boardlst = new ArrayList<BoardDTO>();

		int totalboardCnt = 0;
		if("전체".equals(selectVal)) { // 내용 검색
			boardlst = boardService.paginglist2(new int[] {(page-1)*3, 3},searchVal);
			totalboardCnt = boardService.getTotalBoard2(searchVal);
		}
		else if("제목".equals(selectVal)) { // 제목 검색
			boardlst = boardService.pagingTitlelist2(new int[] {(page-1)*3, 3},searchVal);
			totalboardCnt = boardService.getTotalTitleBoard2(searchVal);
		}
		else if("작성자".equals(selectVal)) { // 작성자 검색
			boardlst = boardService.pagingWriterlist2(new int[] {(page-1)*3, 3},searchVal);
			totalboardCnt = boardService.getTotalWriterBoard2(searchVal);
			System.out.println(boardlst+"!!!!!!");
		}
		//3개만 조회
		model.addAttribute("boardlst", boardlst);
		model.addAttribute("boardUrl","boardContent");
		model.addAttribute("totalboard",totalboardCnt);
		model.addAttribute("SelectedValue",selectVal);
		model.addAttribute("SearchedValue",searchVal);
		return "board/list";
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
	public ModelAndView boardDelete(@RequestParam(value="page", required = false, defaultValue = "1") int page,int seq) {
		ModelAndView mv = new ModelAndView();
		int deleteCount = boardService.deleteBoard(seq);
		if(deleteCount == 1) {
			int totalboard = boardService.getTotalBoard();
			List<BoardDTO> boardlst = boardService.paginglist(new int[] {(page-1)*3, 3});
			mv.addObject("boardlst", boardlst);
			mv.addObject("boardUrl","boardlist");
			mv.addObject("totalboard",totalboard);
			mv.setViewName("redirect:/boardlist");
		}
		return mv;
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
		}else {
			dto.setImg("noimage.png");
		}
		
		boardService.updateBoard(dto);
		
		return "redirect:/boardstart";

	}
}
