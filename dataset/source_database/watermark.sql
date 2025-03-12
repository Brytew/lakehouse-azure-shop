DROP TABLE IF EXISTS [watermark];
GO
CREATE TABLE [watermark]
(
    [table_name] VARCHAR(255),
    [watermark_value] DATETIME,
);
GO

INSERT INTO [watermark]
VALUES ('[dbo].[products]','1/1/2023 10:00:00 AM'),('[dbo].[customers]','1/1/2023 10:00:00 AM'), ('[dbo].[orders]','1/1/2023 10:00:00 AM');
GO
