package connectus.board;

public class BoardSearchDTO {
	
	private String boardsearch; 
	private String searchOption;

	public BoardSearchDTO() {}
	public BoardSearchDTO(String boardsearch, String searchOption) {
		this.boardsearch = boardsearch;
		this.searchOption = searchOption;
	}
	public String getBoardsearch() {
		return boardsearch;
	}
	public void setBoardsearch(String boardsearch) {
		this.boardsearch = boardsearch;
	}
	public String getSearchOption() {
		return searchOption;
	}
	public void setSearchOption(String searchOption) {
		this.searchOption = searchOption;
	}
	@Override
	public String toString() {
		return "BoardSearchDTO [boardsearch=" + boardsearch + ", searchOption=" + searchOption + "]";
	}
	
	
	
	
	
	
	
	
	

}
