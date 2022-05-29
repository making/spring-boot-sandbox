package com.example.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.filter.TypeExcludeFilters;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import com.example.excludefilter.ExcludeComExampleTestFilter;

@SpringBootTest
@AutoConfigureMockMvc
@TypeExcludeFilters(ExcludeComExampleTestFilter.class)
public class ExampleControllerTest {

	@Autowired
	MockMvc mvc;

	@Test
	void test() throws Exception {
		mvc.perform(get("/example"))
				.andExpectAll(
						status().isOk(),
						jsonPath("$.message").value("Hello World"));
	}
}
