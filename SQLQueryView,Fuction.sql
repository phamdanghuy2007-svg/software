IF OBJECT_ID('p1') is not null
DROP PROC p1
go
CREATE PROC p1
    @MaVT VARCHAR(10), @TenVT NVARCHAR(50), @DVTinh NVARCHAR(20)
AS
BEGIN
    IF (@MaVT IS NULL OR @TenVT IS NULL OR @DVTinh IS NULL)
    BEGIN
        PRINT N'Lỗi: Tham số không được để trống (Null)!';
        RETURN;
    END
    INSERT INTO VATTU VALUES (@MaVT, @TenVT, @DVTinh);
END;
GO

IF OBJECT_ID('p2') is not null
DROP PROC p2
go
CREATE PROC p2
    @SoPX VARCHAR(10), @NgayXuat DATE
AS
BEGIN
    IF (@SoPX IS NULL OR @NgayXuat IS NULL)
    BEGIN
        PRINT N'Lỗi: Tham số không được để trống (Null)!';
        RETURN;
    END
    INSERT INTO PHIEUXUAT VALUES (@SoPX, @NgayXuat);
END;
GO

IF OBJECT_ID('p3') is not null
DROP PROC p3 
go
CREATE PROC p3
    @SoPX VARCHAR(10), @MaVT VARCHAR(10), @SLXuat INT, @DonGia MONEY
AS
BEGIN
    IF (@SoPX IS NULL OR @MaVT IS NULL OR @SLXuat IS NULL OR @DonGia IS NULL)
    BEGIN
        PRINT N'Lỗi: Tham số không được để trống (Null)!';
        RETURN;
    END
    INSERT INTO CTPXUAT VALUES (@SoPX, @MaVT, @SLXuat, @DonGia);
END;
GO
EXEC p1 'VT01', N'Sắt Phi 10', N'Cây';
EXEC p1'VT02', N'Xi Măng Hà Tiên', N'Bao';
EXEC p1 'VT03', N'Gạch Ống', N'Viên';

EXEC p2 'PX01', '2026-01-10';
EXEC p2 'PX02', '2026-02-15';
EXEC p2 'PX03', '2026-03-20';

EXEC p3 'PX01', 'VT01', 50, 150000;
EXEC p3 'PX02', 'VT02', 100, 90000;
EXEC p3 'PX03', 'VT03', 2000, 1200;
GO
go

CREATE FUNCTION TimMaVattu (
    @TenVT NVARCHAR(50),
    @DVTinh NVARCHAR(20)
)
RETURNS TABLE
AS
RETURN (
    SELECT MaVT 
    FROM VATTU 
    WHERE TenVT = @TenVT AND DVTinh = @DVTinh
);
GO

SELECT * FROM dbo.TimMaVattu(N'Sắt Phi 10', N'Cây');
GO

CREATE VIEW v_Top2PhieuXuatMax
AS
SELECT TOP 2 
    VT.MaVT,
    VT.TenVT,
    PX.NgayXuat,
    CT.SLXuat,
    CT.DonGia,
    (CT.SLXuat * CT.DonGia) AS [Gia Tri Max]
FROM CTPXUAT CT
JOIN VATTU VT ON CT.MaVT = VT.MaVT
JOIN PHIEUXUAT PX ON CT.SoPX = PX.SoPX
ORDER BY [Gia Tri Max] DESC;
GO
select*from VATTU
select*from PHIEUXUAT
select*from CTPXUAT
SELECT * FROM v_Top2PhieuXuatMax;
--cau 5
if object_id('xoa') is not null
drop proc xoa
go
create proc xoa(@SLXuat VARCHAR(20))
as
begin
    begin try
        begin tran
            if(@SLXuat is null or @SLXuat = '')
                raiserror (N'các tham số không được để trống',16,1)
            if(TRY_CAST(@SLXuat as int) is null)
                raiserror (N'SLXuat phải là kiểu số',16,1)

            select SoPX,MaVT 
            into #TempXoa 
            from CTPXUAT
            where SLXuat = @SLXuat

            delete from CTPXUAT where SLXUAT = @SLXUAT
            delete from PHIEUXUAT where SoPX in (select SoPX from #TempXoa)
            delete from VATTU where MaVT in (select MaVT from #TempXoa)
        commit
        select * from CTPXUAT
        select * from PHIEUXUAT
        select * from VATTU
    end try
    begin catch
        print N'lỗi'
        rollback
        select ERROR_LINE() as [dòng gây lỗi],
               ERROR_MESSAGE() AS [thông báo lỗi],
               ERROR_SEVERITY() AS [mức độ nghiêm trọng];
    end catch
end
go
exec xoa 5