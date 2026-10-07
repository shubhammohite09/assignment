package com.internal.tasktracker;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    // Search non-archived tasks by term (no status filter).
    // Two separate queries avoid the ":status IS NULL OR ..." pattern, whose null-parameter
    // typing is fragile across databases/drivers.
    @Query(value = "SELECT * FROM tasks WHERE archived = FALSE "
                 + "AND (LOWER(title) LIKE :term OR LOWER(description) LIKE :term) "
                 + "ORDER BY created_at DESC, id DESC",
           nativeQuery = true)
    List<Task> searchTasks(@Param("term") String term);

    // Same search, restricted to one status.
    @Query(value = "SELECT * FROM tasks WHERE archived = FALSE "
                 + "AND (LOWER(title) LIKE :term OR LOWER(description) LIKE :term) "
                 + "AND status = :status "
                 + "ORDER BY created_at DESC, id DESC",
           nativeQuery = true)
    List<Task> searchTasksByStatus(@Param("term") String term, @Param("status") String status);
}
