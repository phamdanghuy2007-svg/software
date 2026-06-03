CREATE DATABASE QUANLY_TIEMPHONG
GO

USE QUANLY_TIEMPHONG
GO

CREATE TABLE KHACHHANG(
	Makh VARCHAR(10) PRIMARY KEY,
	Hoten NVARCHAR(50),
	Ngaysinh DATE,
	Diachi NVARCHAR(100),
	Gioitinh NVARCHAR(10)
)

CREATE TABLE VACXIN(
	MaVX VARCHAR(10) PRIMARY KEY,
	TenVX NVARCHAR(50),
	Ngaysanxuat DATE,
	Ngayhethan DATE,
	Xuatsu NVARCHAR(50),
	Congdung NVARCHAR(100),
	Dongia FLOAT
)

CREATE TABLE TIEMPHONG(
	Makh VARCHAR(10),
	MaVX VARCHAR(10),
	Ngaytiem DATE,
	PRIMARY KEY(Makh,MaVX),
	FOREIGN KEY(Makh) REFERENCES KHACHHANG(Makh),
	FOREIGN KEY(MaVX) REFERENCES VACXIN(MaVX)
)
GO
-------------------------------------------------------------------------------------------------
IF OBJECT_ID('sp_ThemKH') IS NOT NULL
	DROP PROC sp_ThemKH
GO

CREATE PROC sp_ThemKH
	@Makh VARCHAR(10),
	@Hoten NVARCHAR(50),
	@Ngaysinh DATE,
	@Diachi NVARCHAR(100),
	@Gioitinh NVARCHAR(10)
AS
BEGIN
	IF @Makh = ''
		PRINT N'Mã khách hàng không hợp lệ'
	ELSE
		INSERT INTO KHACHHANG
		VALUES(@Makh,@Hoten,@Ngaysinh,@Diachi,@Gioitinh)
END
GO

EXEC sp_ThemKH 'KH01',N'Nguyễn Văn An','2000-01-01',N'Hà Nội',N'Nam'
EXEC sp_ThemKH 'KH02',N'Trần Thị Bình','2001-02-02',N'Hải Phòng',N'Nữ'
EXEC sp_ThemKH 'KH03',N'Lê Văn Cường','2002-03-03',N'Hà Nam',N'Nam'
EXEC sp_ThemKH 'KH04',N'Phạm Thị Dung','2003-04-04',N'Nam Định',N'Nữ'
GO

IF OBJECT_ID('sp_ThemVX') IS NOT NULL
	DROP PROC sp_ThemVX
GO

CREATE PROC sp_ThemVX
	@MaVX VARCHAR(10),
	@TenVX NVARCHAR(50),
	@Ngaysanxuat DATE,
	@Ngayhethan DATE,
	@Xuatsu NVARCHAR(50),
	@Congdung NVARCHAR(100),
	@Dongia FLOAT
AS
BEGIN
	IF @Dongia <= 0
		PRINT N'Đơn giá không hợp lệ'
	ELSE
		INSERT INTO VACXIN
		VALUES(@MaVX,@TenVX,@Ngaysanxuat,@Ngayhethan,@Xuatsu,@Congdung,@Dongia)
END
GO

EXEC sp_ThemVX 'VX01',N'Covid','2024-01-01','2026-01-01',N'Mỹ',N'Phòng Covid',300000
EXEC sp_ThemVX 'VX02',N'Cúm mùa','2024-02-01','2026-02-01',N'Nhật',N'Phòng cúm',200000
EXEC sp_ThemVX 'VX03',N'Sởi','2024-03-01','2026-03-01',N'Pháp',N'Phòng sởi',250000
EXEC sp_ThemVX 'VX04',N'Viêm gan B','2024-04-01','2026-04-01',N'Việt Nam',N'Phòng viêm gan B',350000
GO

IF OBJECT_ID('sp_ThemTP') IS NOT NULL
	DROP PROC sp_ThemTP
GO

CREATE PROC sp_ThemTP
	@Makh VARCHAR(10),
	@MaVX VARCHAR(10),
	@Ngaytiem DATE
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM KHACHHANG WHERE Makh=@Makh)
		PRINT N'Không có khách hàng'
	ELSE IF NOT EXISTS(SELECT * FROM VACXIN WHERE MaVX=@MaVX)
		PRINT N'Không có vắc xin'
	ELSE
		INSERT INTO TIEMPHONG
		VALUES(@Makh,@MaVX,@Ngaytiem)
END
GO

EXEC sp_ThemTP 'KH01','VX01','2025-01-01'
EXEC sp_ThemTP 'KH02','VX02','2025-01-02'
EXEC sp_ThemTP 'KH03','VX03','2025-01-03'
EXEC sp_ThemTP 'KH04','VX04','2025-01-04'
GO

SELECT * FROM KHACHHANG
SELECT * FROM VACXIN
SELECT * FROM TIEMPHONG