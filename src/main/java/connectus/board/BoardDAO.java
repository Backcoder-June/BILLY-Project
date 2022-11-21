package connectus.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
//import org.apache.commons.collections.map.HashedMap;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Repository;


@Mapper
@Repository
public interface BoardDAO {
	
	  public int insertBoard(BoardDTO dto);

	  public int getTotalBoard();
	  
	  public int getMyRegionTotalBoard(String region);
	
	  public List<BoardDTO> pagingList(int limit);
	  
	  public List<BoardDTO> myRegionPagingList(int limit, String region);
	  
	  
	  public int updateSeq(int seq);
	  
	  public BoardDTO getBoardSeqLst(int seq);
	  
	  public int deleteBoard(int seq);
	  
	  public int updateBoard(BoardDTO dto);
	  
	  public int getTitleCount();
	  
	  public List<BoardDTO> pagingTitleList(int[] limit);
	  
	  public int getWriterCount();
	  
	  public List<BoardDTO> pagingWriterList(int[] limit);
	  
	  public int getTotalBoard2(String searchVal);
	  
	  public int getTotalTitleBoard2(String searchVal);
	  
	  public int getTotalWriterBoard2(String searchVal);
	  
	  // 검색
	  public int getSearchCount(HashMap<String, String> map);
	  
	  public int getMyRegionSearchCount(HashMap<String, String> map);
	  
	  public List<BoardDTO> getSearchList(HashMap<String, String> map);
	  
	  public List<BoardDTO> getMyRegionSearchList(HashMap<String, String> map);
	  
	

	  
	  
	  public int getSearchByAllCount(String boardsearch);
	  
	  public int getMyReionSearchByAllCount(String boardsearch, String region);
	  

	  public List<BoardDTO> getSearchListByAll(String boardsearch, int limit);
	  
	  public List<BoardDTO> getMyRegionSearchListByAll(String boardsearch, int limit, String region);
	  
	  
	  
	  
	  public List<BoardDTO> pagingList2(Map map); 
	  
	  public List<BoardDTO> pagingTitleList2(Map map); 
		  
	  
	  public List<BoardDTO> pagingWriterlist2(Map map); 
		  
	 	
}
