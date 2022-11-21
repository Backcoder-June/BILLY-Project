package connectus.board;

public class BoardDTO {
	private int seq;
	private String title, contents, writer;
	private int viewcount;
	private String writingtime;
	private String img;
	private String region;
   
   
   
   
public BoardDTO() {}  
public BoardDTO(int seq, String title, String contents, String writer, int viewcount, String writingtime,
		String img, String region) {
	this.seq = seq;
	this.title = title;
	this.contents = contents;
	this.writer = writer;
	this.viewcount = viewcount;
	this.writingtime = writingtime;
	this.img = img;
	this.region = region;
}


public String getRegion() {
	return region;
}
public void setRegion(String region) {
	this.region = region;
}
public String getImg() {
	return img;
}
public void setImg(String img) {
	this.img = img;
}
public int getSeq() {
	return seq;
}
public void setSeq(int seq) {
	this.seq = seq;
}
public String getTitle() {
	return title;
}
public void setTitle(String title) {
	this.title = title;
}
public String getContents() {
	return contents;
}
public void setContents(String contents) {
	this.contents = contents;
}
public String getWriter() {
	return writer;
}
public void setWriter(String writer) {
	this.writer = writer;
}

public int getViewcount() {
	return viewcount;
}
public void setViewcount(int viewcount) {
	this.viewcount = viewcount;
}
public String getWritingtime() {
	return writingtime;
}
public void setWritingtime(String writingtime) {
	this.writingtime = writingtime;
}
@Override
public String toString() {
	return "BoardDTO [seq=" + seq + ", title=" + title + ", contents=" + contents + ", writer=" + writer
			+ ", viewcount=" + viewcount + ", writingtime=" + writingtime + ", img=" + img + "]";
}
   
   
   
	

	
	
}
