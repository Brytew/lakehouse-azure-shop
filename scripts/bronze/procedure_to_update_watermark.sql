DROP PROCEDURE IF EXISTS [update_watermark];
GO

CREATE PROCEDURE [update_watermark] @new_watermark datetime, @TableName varchar(50)
AS
BEGIN

UPDATE [watermark]
SET [watermark_value] = @new_watermark
WHERE [table_name] = @TableName

END;
GO