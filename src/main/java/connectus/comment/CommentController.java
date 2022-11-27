package connectus.comment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class CommentController {
	@Autowired
	CommentDAO commentDAO;
	
	//전체 댓글 가져오기
	@ResponseBody
	@PostMapping("/boarddetail/{boardSeq}/getAllComment")
	public Object getAllComment(@PathVariable("boardSeq") int seq) {
		List<CommentDTO> commentList = commentDAO.getAllComment(seq);
		return commentList;
	}
	
	//댓글 작성
	@ResponseBody
	@RequestMapping("/boarddetail/{boardSeq}/insertComment")
	public CommentDTO insertComment(@PathVariable("boardSeq") int seq, CommentDTO dto) throws Exception{
		commentDAO.insertComment(dto);
		return commentDAO.getComment(dto.getComment_seq());
	}
	
	//댓글 수정
	@ResponseBody
	@PostMapping("/boarddetail/{boardSeq}/updateComment")
	public CommentDTO updateComment(CommentDTO dto, String updateContents, int updateSecret, String commentSeq) {
		int commentSeqInt = Integer.parseInt(commentSeq);
		dto.setContents(updateContents);
		dto.setSecret(updateSecret);
		dto.setComment_seq(commentSeqInt);
		commentDAO.updateComment(dto);
		return commentDAO.getComment(commentSeqInt);
	}
	
	//댓글 삭제
	@ResponseBody
	@PostMapping("/boarddetail/{boardSeq}/deleteComment")
	public void deleteComment(int commentSeq) {
		commentDAO.deleteComment(commentSeq);
	}
	
	
}
