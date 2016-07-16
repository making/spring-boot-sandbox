package study.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.seasar.doma.jdbc.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import study.dao.TodoDao;
import study.domain.Content;
import study.domain.Key;
import study.entity.Todo;

@Service
public class TodoService {

    private final TodoDao dao;

    @Autowired
    public TodoService(TodoDao dao) {
        this.dao = dao;
    }

    public List<Todo> findAll() {
        return dao.selectAll(Collectors.toList());
    }

    public Optional<Todo> findById(Key<Todo> id) {
        return dao.selectById(id);
    }

    @Transactional
    public Todo create(Content content) {
        Todo entity = Todo.create(content);
        return dao.insert(entity).getEntity();
    }

    @Transactional
    public Optional<Todo> close(Key<Todo> id) {
        return dao.selectById(id).map(entity -> entity.close(LocalDateTime.now())).map(dao::update)
                .map(Result::getEntity);
    }
}
