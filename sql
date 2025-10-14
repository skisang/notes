Q) How to find all linked server references in SQL Server objects

-- This script searches stored procedures, functions, views, and triggers
-- First, get list of all linked servers
SELECT 
    name AS LinkedServerName,
    product,
    provider,
    data_source
FROM sys.servers
WHERE is_linked = 1;

-- Search in Stored Procedures
SELECT DISTINCT
    'Stored Procedure' AS ObjectType,
    OBJECT_SCHEMA_NAME(object_id) AS SchemaName,
    OBJECT_NAME(object_id) AS ObjectName,
    s.name AS LinkedServerName
FROM sys.sql_modules m
CROSS JOIN sys.servers s
WHERE s.is_linked = 1
    AND m.definition LIKE '%' + s.name + '%'
    AND OBJECTPROPERTY(m.object_id, 'IsProcedure') = 1

UNION ALL

-- Search in Functions
SELECT DISTINCT
    'Function' AS ObjectType,
    OBJECT_SCHEMA_NAME(object_id) AS SchemaName,
    OBJECT_NAME(object_id) AS ObjectName,
    s.name AS LinkedServerName
FROM sys.sql_modules m
CROSS JOIN sys.servers s
WHERE s.is_linked = 1
    AND m.definition LIKE '%' + s.name + '%'
    AND (OBJECTPROPERTY(m.object_id, 'IsScalarFunction') = 1
         OR OBJECTPROPERTY(m.object_id, 'IsTableFunction') = 1
         OR OBJECTPROPERTY(m.object_id, 'IsInlineFunction') = 1)

UNION ALL

-- Search in Views
SELECT DISTINCT
    'View' AS ObjectType,
    OBJECT_SCHEMA_NAME(object_id) AS SchemaName,
    OBJECT_NAME(object_id) AS ObjectName,
    s.name AS LinkedServerName
FROM sys.sql_modules m
CROSS JOIN sys.servers s
WHERE s.is_linked = 1
    AND m.definition LIKE '%' + s.name + '%'
    AND OBJECTPROPERTY(m.object_id, 'IsView') = 1

UNION ALL

-- Search in Triggers
SELECT DISTINCT
    'Trigger' AS ObjectType,
    OBJECT_SCHEMA_NAME(object_id) AS SchemaName,
    OBJECT_NAME(object_id) AS ObjectName,
    s.name AS LinkedServerName
FROM sys.sql_modules m
CROSS JOIN sys.servers s
WHERE s.is_linked = 1
    AND m.definition LIKE '%' + s.name + '%'
    AND OBJECTPROPERTY(m.object_id, 'IsTrigger') = 1

ORDER BY ObjectType, SchemaName, ObjectName;

-- Optional: Get detailed definition of specific objects
-- Uncomment and modify to see the full code of a specific object
/*
SELECT 
    OBJECT_SCHEMA_NAME(object_id) AS SchemaName,
    OBJECT_NAME(object_id) AS ObjectName,
    definition
FROM sys.sql_modules
WHERE OBJECT_NAME(object_id) = 'YourObjectName';
*/
