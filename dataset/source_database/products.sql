DROP TABLE IF EXISTS [products];
GO
CREATE TABLE [products]
(
    [product_id] INT IDENTITY(1,1) PRIMARY KEY,   
    [product_code] VARCHAR(255) NULL,
    [product_name] VARCHAR(255) NULL,
    [product_category] VARCHAR(MAX) NULL,
    [last_timestamp] DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
GO

INSERT INTO [products] ([product_code], [product_name], [product_category])  
VALUES  
    ('110', 'Inner tube', 'bike'),  
    ('120', 'Saddle', 'bike'),  
    ('130', 'Vacuum cleaner', 'agd'),  
    ('140', 'Microwave', 'agd'),  
    ('150', 'Blender', 'agd');  
