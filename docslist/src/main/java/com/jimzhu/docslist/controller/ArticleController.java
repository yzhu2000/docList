package com.jimzhu.docslist.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jimzhu.docslist.model.Article;
import com.jimzhu.docslist.repository.ArticleRepository;


@RestController
public class ArticleController {
	
	
	@Autowired
	private ArticleRepository articleRepository; 
	
	
	@GetMapping(value = "/findAllArticle", produces = "application/json")
	public HashMap<String, Object>  getArticles(){
		
		List<Article> articles =  articleRepository.findAll();
		
		HashMap<String, Object> map = new HashMap<>();
		
		map.put("rows", articles);
		map.put("total", articles.size());
		
		// articles.forEach(article -> System.out.println(article.getTitle()));
				
		return map;
	}
	
	

}
