IF OBJECT_ID('p1') IS NOT NULL
    DROP PROC p1
GO

CREATE PROC p1
    @MaBN VARCHAR(10),
    @HoTenBN NVARCHAR(50),
    @GioiTinh NVARCHAR(10),
    @NgaySinh DATE,
    @DiaChi NVARCHAR(100)
AS 
BEGIN
    BEGIN TRY
        IF @MaBN IS NULL OR @HoTenBN IS NULL
        BEGIN
            PRINT N'Lỗi: Mã bệnh nhân hoặc Họ tên không được để trống!'
            RETURN
        END
        INSERT INTO BENHNHAN (MaBN, HoTenBN, GioiTinh, NgaySinh, DiaChi)
        VALUES (@MaBN, @HoTenBN, @GioiTinh, @NgaySinh, @DiaChi)
        PRINT N'Chèn bệnh nhân ' + @MaBN + N' thành công.'
    END TRY 
    BEGIN CATCH
         select ERROR_MESSAGE() as 'sai o day'
    END CATCH
END
GO
EXEC p1 'BN01', N'Nguyễn Văn A', N'Nam', '1990-05-12', N'Hà Nội';
EXEC p1 'BN02', N'Trần Thị B', N'Nữ', '1995-08-20', N'Đà Nẵng';
EXEC p1 'BN03', N'Lê Hoàng C', N'Nam', '2000-01-01', N'TP HCM';
GO
IF OBJECT_ID('p2') IS NOT NULL
    DROP PROC p2
GO

CREATE PROC p2
    @MaBS VARCHAR(10),
    @HoTenBS NVARCHAR(50),
    @ChuyenKhoa NVARCHAR(50),
    @SoDienThoai VARCHAR(15)
AS 
BEGIN
    BEGIN TRY
        IF @MaBS IS NULL OR @HoTenBS IS NULL
        BEGIN
            PRINT N'Lỗi: Mã bác sĩ và Họ tên không được để trống (NULL)!';
            RETURN;
        END
        INSERT INTO BACSI (MaBS, HoTenBS, ChuyenKhoa, SoDT)
        VALUES (@MaBS, @HoTenBS, @ChuyenKhoa, @SoDienThoai);
        
        PRINT N'Chèn bác sĩ ' + @MaBS + N' thành công.';
    END TRY
    BEGIN CATCH
        select ERROR_MESSAGE() as 'sai o day'
    END CATCH
END
GO
EXEC p2 'HN123HSCC', N'Bác sĩ Tuấn', N'HSCC', '0912345678';
EXEC p2 'HP99999TM', N'Bác sĩ Lan', N'TM', '0987654321';
EXEC p2 'DN55555XQ', N'Bác sĩ Hùng', N'XQuang', '0905111222';
GO
IF OBJECT_ID('p3') IS NOT NULL
    DROP PROC p3
GO
CREATE PROC p3
    @MaBN VARCHAR(10),
    @MaBS VARCHAR(10),
    @NgayVaoVien DATE,
    @NgayRaVien DATE
AS 
BEGIN
    BEGIN TRY
        IF @MaBS IS NULL OR @MaBN IS NULL OR @NgayVaoVien IS NULL
        BEGIN
            raiserror N'Lỗi: Mã BN, Mã BS và Ngày vào viện không được để trống!';
         
        END
        INSERT INTO DIEUTRI1 (MaBN, MaBS, NgayVaoVien, NgayRaVien)
        VALUES (@MaBN, @MaBS, @NgayVaoVien, @NgayRaVien);
        
        PRINT N'Chèn lịch sử điều trị thành công.';
    END TRY
    BEGIN CATCH
        select ERROR_MESSAGE() as 'thong boa'
    END CATCH
END
GO
EXEC p3 'BN01', 'HN123HSCC', '2026-01-01', '2026-01-15';
EXEC p3 'BN02', 'HP99999TM', '2026-02-10', '2026-02-20';  
EXEC p3 'BN03', 'HN123HSCC', '2026-03-01', '2026-03-25';
GO
select*from BACSI
select*from BENHNHAN
select*from DIEUTRI1
go
if OBJECT_ID('fn_SoNgayDtri') is not null
drop function fn_SoNgayDtri
go
--cau 3 so ngay dieu tri
create function fn_SoNgayDtri(
@MaBN varchar(10),
@MaBS varchar(10)
)
returns int
as
begin
declare @SoNgay int
select @SoNgay =DATEDIFF(day,NgayVaoVien,NgayRaVien)
from DIEUTRI1
Where MaBN=@MABN and MaBS=@MaBS
return isnull(@SoNgay,0);
end
go
SELECT dbo.fn_SoNgayDtri('BN01', 'HN123HSCC') AS SoNgayDieuTri;
--Cau 4 Lay chuyen khoa
IF OBJECT_ID('fn_GetChuyenKhoaFromDatabase') IS NOT NULL
    DROP FUNCTION fn_GetChuyenKhoaFromDatabase;
GO

CREATE FUNCTION fn_GetChuyenKhoaFromDatabase (
    @MaBS VARCHAR(10)
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @ChuyenKhoa NVARCHAR(50);
    SELECT @ChuyenKhoa = ChuyenKhoa 
    FROM BACSI 
    WHERE MaBS = @MaBS;

    RETURN ISNULL(@ChuyenKhoa, N'Không tìm thấy bác sĩ');
END;
GO
SELECT dbo.fn_GetChuyenKhoaFromDatabase('HN123HSCC') AS ChuyenKhoa_Database;
go
--cau 5
IF OBJECT_ID('v_Top2BenhNhanLauNhat') IS NOT NULL
    DROP VIEW v_Top2BenhNhanLauNhat;
GO

CREATE VIEW v_Top2BenhNhanLauNhat
AS
SELECT TOP 2
    bn.MaBN,
    bn.HoTenBN,
    DATEDIFF(day, dt.NgayVaoVien, dt.NgayRaVien) AS SoNgayDieuTri,
    bn.DiaChi,
    bs.HoTenBS,
    bs.ChuyenKhoa,
    bs.SoDT
FROM DIEUTRI1 dt 
JOIN BENHNHAN bn ON dt.MaBN = bn.MaBN
JOIN BACSI bs ON dt.MaBS = bs.MaBS
ORDER BY SoNgayDieuTri DESC;
GO
SELECT * FROM v_Top2BenhNhanLauNhat;
IF OBJECT_ID('xoa') IS NOT NULL
DROP PROC xoa
GO
--cau 6
CREATE PROC xoa(@NgayRaVien VARCHAR(20))
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN
            --IF(@NgayRaVien IS NULL OR TRIM(@NgayRaVien) = '')
               -- RAISERROR(N'Các tham số không được để trống',16,1)
           -- IF(TRY_CAST(@NgayRaVien AS DATE) IS NULL)
               -- RAISERROR(N'NgàyRaVien phải đúng định dạng ngày',16,1)
            SELECT MaBN, MaBS
            INTO #TempXoa
            FROM DIEUTRI1
            WHERE NgayRaVien = @NgayRaVien
            DELETE FROM DIEUTRI1
            WHERE NgayRaVien = @NgayRaVien
            DELETE FROM BENHNHAN
            WHERE MaBN IN
            (
                SELECT MaBN
                FROM #TempXoa
            )
            DELETE FROM BACSI
            WHERE MaBS IN
            (
                SELECT MaBS
                FROM #TempXoa
            )
        COMMIT
        SELECT * FROM DIEUTRI1
        SELECT * FROM BENHNHAN
        SELECT * FROM BACSI
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi'
        ROLLBACK
        SELECT
            ERROR_LINE() AS [Dòng gây lỗi],
            ERROR_MESSAGE() AS [Thông báo lỗi];      
    END CATCH
END
GO
EXEC xoa '2026-06-10'