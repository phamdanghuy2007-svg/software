create database SU25_COM2034_Ph650751
go
use SU25_COM2034_Ph650751
go
create table SanPham(
MaSP varchar(20) not null,
TenSp nvarchar(100) not null,
GiaHienHanh money not null,
SoLuongTon int not null,
constraint PK_SanPham primary key(MaSP)
)
go
create table HoaDon(
MaHD varchar(20) not null,
NgayLap date not null,
SoDT varchar(15) not null,
constraint PK_HoaDon primary key(MaHD)
)
go
create table HoaDonChiTiet(
MaSP varchar(20) not null,
MaHD varchar(20) not null,
SoLuongMua int not null,
GiaMua Money not null,
constraint PK_HoaDonChiTiet primary key(MaSp,MaHD),
constraint FK_HDCT_SanPham foreign key(MaSP) references SanPham(MaSP),
constraint FK_HDCT_HoaDon foreign key(MaHD) references HoaDon(MaHD)
)
go

if OBJECT_ID('p1') is not null
drop proc p1
go
Create proc p1
@MaSP varchar(20),
@TenSp nvarchar(100),
@GiaHienHanh money,
@SoLuongMua int
as begin
begin try
 if @MaSP is null or @TenSp is null or @GiaHienHanh is null or @SoLuongMua is null
 raiserror('Loi ko dc de trong du lieu',16,1)
 if @GiaHienHanh < 0 or @SoLuongMua<0
 raiserror('loi gia hien hanh va so luong phai bang 0',16,1)
 insert into SanPham
 values(@MaSP,@TenSp,@GiaHienHanh,@SoLuongMua)
 print'them sp thanh cong'
 end try
 begin catch
 select ERROR_LINE() as 'dong gay loi',
 ERROR_MESSAGE() as 'thong bao loi',
 ERROR_SEVERITY() as ' muc do nghiem trong'
 end catch
end
go
EXEC p1 'SP01', N'Giày Bóng Đá Nike', 1500000, 50
EXEC p1 'SP02', N'Áo Đấu Real Madrid', 850000, 120
EXEC p1 'SP03', N'Quả Bóng Động Lực', 350000, 80
GO
select*from SanPham

IF OBJECT_ID('p2') IS NOT NULL
    DROP PROC p2;
GO

CREATE PROC p2
    @MaHD VARCHAR(20),
    @NgayLap DATE,
    @SoDT VARCHAR(15)
AS 
BEGIN
    BEGIN TRY
        IF @MaHD IS NULL OR @NgayLap IS NULL OR @SoDT IS NULL
            RAISERROR('loi can dn gia tri vao!', 16, 1);

        INSERT INTO HoaDon (MaHD, NgayLap, SoDT)
        VALUES (@MaHD, @NgayLap, @SoDT);

        PRINT 'Them hoa don thanh cong!';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_LINE() AS ' dong gay loi',
            ERROR_MESSAGE() AS ' thong bao loi',
            ERROR_SEVERITY() AS ' muc do nghiem trong';
    END CATCH
END;
GO

EXEC p2 'HD01', '2026-06-10', '0987654321';
EXEC p2 'HD02', '2026-07-11', '0987654351';
EXEC p2 'HD03', '2026-01-11', '0287654351';
GO

SELECT * FROM HoaDon;
GO

IF OBJECT_ID('p3') IS NOT NULL
    DROP PROC p3;
GO

CREATE PROC p3
    @MaSP VARCHAR(20),
    @MaHD VARCHAR(20),
    @SoLuongMua INT,
    @GiaMua MONEY
AS 
BEGIN
    BEGIN TRY
        IF @MaSP IS NULL OR @MaHD IS NULL OR @SoLuongMua IS NULL OR @GiaMua IS NULL
            RAISERROR('Lỗi: Không được để trống dữ liệu đầu vào!', 16, 1);
            
        IF @SoLuongMua <= 0 OR @GiaMua < 0
            RAISERROR('Lỗi: Số lượng mua phải > 0 và giá mua phải >= 0!', 16, 1);

      
        INSERT INTO HoaDonChiTiet (  MaSP,   MaHD,   SoLuongMua,   GiaMua)
        VALUES                    (@MaSP, @MaHD, @SoLuongMua, @GiaMua);

        PRINT 'Them chi tiet hoa don thanh cong!';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_LINE() AS ' dong gay loi',
            ERROR_MESSAGE() AS ' thong bao loi',
            ERROR_SEVERITY() AS ' muc do nghiem trong';
    END CATCH
END;
GO

EXEC p3 'SP01', 'HD01', 2, 1450000;
EXEC p3 'SP02', 'HD01', 1, 850000;
EXEC p3 'SP03', 'HD02', 5, 340000;
GO 

SELECT * FROM HoaDonChiTiet;
GO

if OBJECT_ID('p4') is not null
drop view p4
go 
create view p4 as 
select
MaSP,
MaHD,
SoLuongMua,
GiaMua,
(SoLuongMua * GiaMua) as ThanhTien
from HoaDonChiTiet
go
select * from p4
go
IF OBJECT_ID('V_TopSP', 'V') IS NOT NULL
    DROP VIEW V_TopSP;
GO

CREATE VIEW V_TopSP AS
SELECT TOP 10 
    hdct.MaSP,
    sp.TenSp,
    MONTH(hd.NgayLap) AS Thang,
    YEAR(hd.NgayLap) AS Nam,
    SUM(hdct.SoLuongMua) AS TongSoLuongBan
FROM HoaDonChiTiet hdct
JOIN HoaDon hd ON hdct.MaHD = hd.MaHD
JOIN SanPham sp ON hdct.MaSP = sp.MaSP
GROUP BY hdct.MaSP, sp.TenSp, MONTH(hd.NgayLap), YEAR(hd.NgayLap)
ORDER BY TongSoLuongBan DESC;
GO


SELECT * FROM V_TopSP;
GO
IF OBJECT_ID('F_Vnd2Usd') IS NOT NULL
    DROP FUNCTION F_Vnd2Usd;
GO

CREATE FUNCTION F_Vnd2Usd (@GiaVND MONEY)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @GiaVND / 23000.0;
END;
GO



SELECT 
    MaSP, 
    TenSp, 
    GiaHienHanh AS [Giá VNĐ], 
    dbo.F_Vnd2Usd(GiaHienHanh) AS [Giá USD] 
FROM SanPham;
GO
IF OBJECT_ID('SP_XoaSP') IS NOT NULL
    DROP PROC SP_XoaSP;
GO

CREATE PROC SP_XoaSP
    @MaSP VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN
            
            IF NOT EXISTS (SELECT * FROM SanPham WHERE MaSP = @MaSP)
                RAISERROR(N'Lỗi: Mã sản phẩm cần xóa không tồn tại', 16, 1);

            SELECT MaSP, MaHD
            INTO #TempXoa
            FROM HoaDonChiTiet
            WHERE MaSP = @MaSP;

            DELETE FROM HoaDonChiTiet
            WHERE MaSP = @MaSP;

         
            DELETE FROM SanPham
            WHERE MaSP IN 
            (
                SELECT MaSP 
                FROM #TempXoa
            );

        COMMIT
        
    
        PRINT N'Xóa sản phẩm và các dữ liệu liên quan thành công!';
        SELECT * FROM HoaDonChiTiet;
        SELECT * FROM SanPham;

    END TRY
    BEGIN CATCH
        PRINT N'Đã xảy ra lỗi trong quá trình xóa dữ liệu!';
        ROLLBACK;
        
        SELECT
            ERROR_LINE() AS [Dòng gây lỗi],
            ERROR_MESSAGE() AS [Thông báo lỗi];      
    END CATCH
END;
GO

EXEC SP_XoaSP 'SP03';
GO