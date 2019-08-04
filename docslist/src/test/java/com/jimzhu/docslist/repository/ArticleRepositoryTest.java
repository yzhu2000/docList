package com.jimzhu.docslist.repository;


import static org.junit.Assert.*;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.jimzhu.docslist.model.Article;


@RunWith(SpringRunner.class)
@SpringBootTest
public class ArticleRepositoryTest {
	
	@Autowired
	private ArticleRepository articleRepository; 
	
	@Test
	public void getTest() {
		
		List<Article> articles = articleRepository.findAll();
		assertFalse(articles.isEmpty());
				
		
	}

}
