package com.jimzhu.docslist.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.jimzhu.docslist.model.Article;

@Repository
public interface ArticleRepository extends MongoRepository<Article, String> {

}
