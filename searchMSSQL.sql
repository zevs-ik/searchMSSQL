-- Поиск текста всей MS SQL базе

DECLARE @TableName NVARCHAR(256), 
        @ColumnName NVARCHAR(128), 
        @SearchTerm NVARCHAR(100),
        @SQL NVARCHAR(MAX)

-- Поиск текста
SET @SearchTerm = 'Text_here'


CREATE TABLE #Results (TableName NVARCHAR(256), ColumnName NVARCHAR(128), FoundValue NVARCHAR(MAX))

DECLARE TableCursor CURSOR FOR
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')

OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName, @ColumnName

WHILE @@FETCH_STATUS = 0
BEGIN
    
    SET @SQL = 'INSERT INTO #Results (TableName, ColumnName, FoundValue) SELECT ''' 
               + @TableName + ''', ''' + @ColumnName + ''', ' + QUOTENAME(@ColumnName) 
               + ' FROM [' + @TableName + '] WHERE [' + @ColumnName + '] LIKE ''%' + @SearchTerm + '%'''
    
    
    EXEC sp_executesql @SQL

    FETCH NEXT FROM TableCursor INTO @TableName, @ColumnName
END

CLOSE TableCursor
DEALLOCATE TableCursor


SELECT * FROM #Results

DROP TABLE #Results
