
DECLARE @hoten1 NVARCHAR(100) = N' tran thi        thu   nga '
SET @hoten1 = LTRIM(RTRIM(@hoten1))
SET @hoten1 = REPLACE(REPLACE(REPLACE(@hoten1, ' ', '><'), '<>', ''), '><', ' ')
SELECT LEFT(@hoten1, CHARINDEX(' ', @hoten1) - 1) AS [Ho]
SELECT SUBSTRING(@hoten1, CHARINDEX(' ', @hoten1) + 1, LEN(@hoten1) - CHARINDEX(' ', @hoten1) - CHARINDEX(' ', REVERSE(@hoten1))) AS [Dem]
SELECT RIGHT(@hoten1, CHARINDEX(' ', REVERSE(@hoten1)) - 1) AS [Ten]

select*from NHANVIEN
SELECT 
    DChi,
    LEFT(DChi, CHARINDEX(' ', DChi) - 1) AS [SoNha],
    TRIM(SUBSTRING(DChi, CHARINDEX(' ', DChi) + 1, CHARINDEX(',', DChi) - CHARINDEX(' ', DChi) - 1)) AS [TenDuong],
    
   
    TRIM(SUBSTRING(DChi, CHARINDEX(',', DChi) + 1, LEN(DChi))) AS [ThanhPho]

FROM NHANVIEN;