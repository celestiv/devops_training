# XML

**Extensible markup language** - расширяемый язык разметки

- язык разметки для создания логической структуры данных, их хранения и передачи в виде удобном и для компьютера, и для человека

- Представляет из себя древовидную структуру

- совместим с UNICODE

- платформонезависим

Пример:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--Комментарий к документу xml-->
<catalog name="Каталог книг">
    <book id="1">
        <name>Книга 1</name>
        <author>Иван</author>
        <comment>Комментарий 1</comment>
    </book>
    <book id="2">
        <name>Книга 2</name>
        <author>Сергей</author>
        <comment>Комментарий 2</comment>
    </book>
    <book id="3">
        <name>Книга 3</name>
        <author>Андрей</author>
        <comment>Комментарий 3</comment>
    </book>
</catalog>
```