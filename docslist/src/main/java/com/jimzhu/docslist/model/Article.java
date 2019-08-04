package com.jimzhu.docslist.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString


@Document(collection="articles")
public class Article {
	@Id
	private String id;
	private String title;
	private String content;
	private String author;
	private String crunchbase_url;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getCrunchbase_url() {
		return crunchbase_url;
	}
	public void setCrunchbase_url(String crunchbase_url) {
		this.crunchbase_url = crunchbase_url;
	}
	
	
	

}
