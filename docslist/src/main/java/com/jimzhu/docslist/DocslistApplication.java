package com.jimzhu.docslist;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import com.jimzhu.docslist.repository.ArticleRepository;

// @SpringBootApplication(exclude = {MongoAutoConfiguration.class, MongoDataAutoConfiguration.class})
@EnableMongoRepositories(basePackageClasses = ArticleRepository.class)
@SpringBootApplication
public class DocslistApplication extends SpringBootServletInitializer {
	
//	@Override
//	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
//		return application.sources(DocslistApplication.class);
//	}

	public static void main(String[] args) {

		SpringApplication.run(DocslistApplication.class, args);

	}

}
