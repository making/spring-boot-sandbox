package study.entity.listener;

import java.time.LocalDateTime;

import org.seasar.doma.jdbc.entity.EntityListener;
import org.seasar.doma.jdbc.entity.PreInsertContext;

import study.entity.Todo;

public class TodoListener implements EntityListener<Todo> {

    @Override
    public void preInsert(Todo entity, PreInsertContext<Todo> context) {
        entity.createdAt = LocalDateTime.now();
    }
}