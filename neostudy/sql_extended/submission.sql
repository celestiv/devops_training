WITH author_posts_count AS (
    SELECT a.id AS author_id, COUNT(1) AS posts_count
    FROM authors a
    JOIN posts p ON p.author_id = a.id
    JOIN post_tag pt ON pt.post_id = p.id
    GROUP BY a.id
    ORDER BY posts_count DESC
    LIMIT 1
)
SELECT a.id AS author_id, a.first_name, a.last_name, apc.posts_count, p.title
FROM author_posts_count apc
JOIN authors a ON apc.author_id = a.id
JOIN posts p ON p.author_id = apc.author_id;