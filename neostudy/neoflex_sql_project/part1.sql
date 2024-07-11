SELECT m.id, m.name, b.name, os.name
FROM model m
JOIN brand b ON b.id = m.brand
JOIN os ON os.id = m.os;