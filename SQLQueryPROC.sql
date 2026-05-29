
/*CREATE PROC TenThuTuc(
	@<tham số 1> <kiểu dữ liệu> [= <mặc định>] [inPUT|OUT]
[, @<tham số 2> <kiểu dữ liệu> [= <mặc định>] [inPUT|OUT]]
...
)
AS
	BEGIN
		Lệnh thực thi SQL
END
*/
vd11: viet 1 thu tuc nhap vao ten cua minh sau do in ra chao + ten tuong ung
if object_id('p1') is not null
drop proc p1 go
create proc p1(@ten nvarchar(50))--procedure
as 
begin--{
print N'Chào bạn' + @ten
end--}
--gọi chạy proc
go 
exec p1 N'Nguyễn Phạm Đăng Huy'--execute
vd2: viết  proc p2 có 2 tham số đàu vào là số thực
tính tổng/tích/thương/hiệu của 2 số đó
tạo 3 lời gọi proc, truyền tham số đầu vào khác  nhau
if object_id('p2') is not null
drop proc p2
go
 create proc p2(@s1 float,@s2 float)
 as 
 begin
  /*print cast(@s1 as varchar(5))+ '+'+ cast(@s2 as varchar(5))+
  '=' + cast((@s1+@s2) as varchar(7))
  print cast(@s1 as varchar(5))+ '-'+ cast(@s2 as varchar(5))+
  '=' + cast((@s1-@s2) as varchar(7))
  print cast(@s1 as varchar(5))+ '*'+ cast(@s2 as varchar(5))+
  '=' + cast((@s1*@s2) as varchar(7))*/
  begin try
  print cast(@s1 as varchar(5))+ '/'+ cast(@s2 as varchar(5))+
  '=' + cast((@s1/@s2) as varchar(20))
  end try
  begin catch
   select ERROR_LINE() as N'dòng gây lỗi',
   error_message() as N'Lỗi', 
   error_severity() as N'Mức độ nghiêm trọng',
   error_procedure() as N'Lỗi ở proc nào'
  end catch
  end
  go
  exec p2 10.3,4.5
  exec p2 10.3,0

  vd3; viet proc them du lieu vao bang phong ban--ínert
  neu ko dc thi in ra tb
  select * from Phongban
IF OBJECT_ID('p3') IS NOT NULL
    DROP PROC p3;
GO

CREATE PROC p3
    @TENPHG NVARCHAR(15),
    @MAPHG INT,
    @TRPHG NVARCHAR(9),
    @NG_NHANCHUC DATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO PhongBan(TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
        VALUES(@TENPHG, @MAPHG, @TRPHG, @NG_NHANCHUC);

        PRINT N'Thêm dữ liệu thành công';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_LINE()      AS N'Dòng gây lỗi',
            ERROR_MESSAGE()   AS N'Lỗi',
            ERROR_SEVERITY()  AS N'Mức độ nghiêm trọng',
            ERROR_PROCEDURE() AS N'Lỗi ở proc nào';
    END CATCH
END;
GO

EXEC p3 N'Phòng Kế toán', 7 ,'005', '2026-05-28';
EXEC p3 N'Phòng Nhân sự', 102, '004', '2026-05-28';
EXEC p3 N'Phòng bảo vệ', 9, '01232131231213231', '2026-05-28';

SELECT * FROM PhongBan;
vd4: viet proc them du lieu vao bang nhan vien.
neu trung khoa chinh thi thong bao loi PK trung
IF OBJECT_ID('p4') IS NOT NULL
    DROP PROC p4;
GO

CREATE PROC p4
ì(@manv in(select manv fromnhanvien))
    @HONV NVARCHAR(15),
    @TENLOT NVARCHAR(15),
    @TENNV NVARCHAR(15),
    @MANV NVARCHAR(9),
    @NGSINH DATETIME,
    @DCHI NVARCHAR(30),
    @PHAI NVARCHAR(3),
    @LUONG FLOAT,
    @MA_NQL NVARCHAR(9),
    @PHG INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO NHANVIEN(HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
        VALUES(@HONV, @TENLOT, @TENNV, @MANV, @NGSINH, @DCHI, @PHAI, @LUONG, @MA_NQL, @PHG);

        PRINT N'Thêm dữ liệu thành công';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_LINE()      AS N'Dòng gây lỗi',
            ERROR_MESSAGE()   AS N'Lỗi',
            ERROR_SEVERITY()  AS N'Mức độ nghiêm trọng',
            ERROR_PROCEDURE() AS N'Lỗi ở proc nào';
    END CATCH
END;
GO
EXEC p4 N'Đinh', N'Quỳnh', N'Như', '001', '1967-02-01', N'291 Hồ Văn Huê, TP HCM', N'Nữ', 43000, '006', 4;
EXEC p4 N'Phan', N'Viet', N'The', '002', '1984-01-11', N'778 Nguyễn Kiệm, TP HCM', N'Nam', 30000, '001', 4;
select*from NHANVIEN