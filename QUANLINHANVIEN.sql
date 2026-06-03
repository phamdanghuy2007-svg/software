create database QlNHANVIEN_WD21301
go
use QlNHANVIEN_WD21301
go 
create table PhongBan(
MaPB varchar (10) not null primary key,
Ten_PB nvarchar(50),
Ma_TRP varchar(10)
)
go
create table Nhan_Vien1(
MaNV varchar(10) not null primary key,
Ho_NV nvarchar(50),
Ten_NV nvarchar(50),
NamSinh int,
DiaChi nvarchar(50),
GioiTinh nvarchar(10),
Luong float,
PHG varchar(10)
)
go
create table QUANLY_DUAN(
MaDUAN varchar(10) not null ,
MaNV varchar(10) not null ,
NgayTGia date,
NgayKThuc date,
SoGio int,
VaiTro nvarchar(20),
primary key(MaDUAN,MaNV)
)
go 
create table Du_An(
MaDA varchar(10) not null primary key,
Ten_DA nvarchar(50),
NgayBdau date,
NgayKThuc date
)
go
--tao khoa ngoai cho bang
alter table Nhan_Vien1 add constraint FK1 foreign key (PHG) references PhongBan(MaPB)
go
alter table QUANLY_DUAN add constraint FK2 foreign key (MaNV) references  Nhan_Vien1(MaNV)
go
alter table QUANLY_DUAN add constraint FK3 foreign key (MaDUAN) references  Du_An(MaDA)
go
--chen du lieu
insert into PhongBan
values
('PB1',N'Phong hanh chinh','Tp1'),
('PB2',N'Phong Du an','Tp1'),
('PB3',N'Phong Kinh Doanh','Tp1')
go
insert into Nhan_Vien1
values
('Nv1',N' Ta',N'Hoang',1980,N'Ha Noi',N'Nam',15000000,'PB1'),
('Nv2',N' Ta',N'Hong',1980,N'Ha Noi',N'Nu',14000000,'PB2'),
('Nv3',N' Ta',N'Hang',1980,N'Ha Noi',N'Nu',14000000,'PB3')
go
insert into Du_An
values
('Da1',N'Quan li ban hang','2021-12-12','2023-12-12'),
('Da2',N'Quan li Nv','2021-12-12','2023-12-12'),
('Da3',N'Quan li san bay','2021-12-12','2023-12-12')
go 
insert into QUANLY_DUAN
values
('Da2','Nv3','2021-12-12','2023-12-12',13,N'Quan li'),
('Da1','Nv2','2021-12-12','2023-12-12',12,N'Quan li2'),
('Da3','Nv1','2021-12-12','2023-12-12',11,N'Nhan vien')
go
--bai hoc hom nay
--truy van du lieu
select * from Nhan_Vien1
go
select * from PhongBan
go
select * from Du_An
go
select * from QUANLY_DUAN
--truy van lua chon so 1
--lay tt bang nhan vien gom ho ten va luong
go
select nv.Ho_NV,nv.Ten_NV,nv.Luong    from  Nhan_Vien1 as nv
go
--truy van gop cot
select nv.Ho_NV + ' '+nv.Ten_NV as 'Ho va ten' from  Nhan_Vien1 as nv
go
--truy van loai bo trung lap du lieu
select distinct nv.Ho_NV form Nhan_Vien1 as nv
--truy van top 3 nhan vien
select top(3) nv.Ten_NV,nv.Luong form Nhan_Vien1 as nv

