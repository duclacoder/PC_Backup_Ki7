use master
go

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SWD392_SE1834_G2_T1')
	BEGIN
		ALTER DATABASE SWD392_SE1834_G2_T1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE SWD392_SE1834_G2_T1;
	end
go

create database SWD392_SE1834_G2_T1
go

use SWD392_SE1834_G2_T1
go

CREATE TABLE Roles (
    RolesId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) UNIQUE,
);
go

CREATE TABLE Users (
    UsersId INT PRIMARY KEY IDENTITY(1,1),
	UserName NVARCHAR(255) UNIQUE,
    FullName NVARCHAR(255),
    Email NVARCHAR(255) UNIQUE,
    Phone NVARCHAR(50) UNIQUE,
    Password NVARCHAR(255),
    ImageUrl NVARCHAR(255),
    RoleId INT FOREIGN KEY REFERENCES Roles(RolesId),
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Wallet DECIMAL(18,2),
    Status NVARCHAR(50) --Active, InActive
);
go

--------------------------------------------------
-- BATTERIES
--------------------------------------------------

CREATE TABLE Batteries (
    BatteriesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId), -- seller
    BatteryName NVARCHAR(255),
    Description NVARCHAR(255),
    Brand NVARCHAR(255),
    Capacity INT,          -- in Ah
    Voltage DECIMAL(5,2),  -- e.g. 12.0, 48.0
    WarrantyMonths INT,
    Price DECIMAL(18,2),
    Currency NVARCHAR(100), --VND, USD
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50) -- available, sold, etc.
);
go

CREATE TABLE BatteryImages (
    BatteryImagesId INT PRIMARY KEY IDENTITY(1,1),
    BatteryId INT FOREIGN KEY REFERENCES Batteries(BatteriesId),
    ImageUrl NVARCHAR(255),
);
go

--------------------------------------------------
-- VEHICLES
--------------------------------------------------

CREATE TABLE Vehicles (
    VehiclesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    VehicleName NVARCHAR(255),
    Description NVARCHAR(255),
    Brand NVARCHAR(255),
    Model NVARCHAR(255),
	Color NVARCHAR(50),
	Seats INT,
	BodyType NVARCHAR(50),             -- SUV, Sedan, etc.
	BatteryCapacity DECIMAL(5,2),      -- in kWh
	RangeKm INT,                       -- range per charge
	ChargingTimeHours DECIMAL(4,2),    -- charging time
	FastChargingSupport BIT,
	MotorPowerKw DECIMAL(6,2),         -- motor output
	TopSpeedKph INT,
    Acceleration DECIMAL(4,2),         -- 0-100 km/h
	ConnectorType NVARCHAR(50),
    Year INT,
    Km INT,
    BatteryStatus NVARCHAR(100),
	WarrantyMonths INT,
    Price DECIMAL(18,2),
	Currency NVARCHAR(100), --VND, USD
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
	Verified BIT,
    Status NVARCHAR(50)
);
go

CREATE TABLE VehicleImages (
    VehicleImagesId INT PRIMARY KEY IDENTITY(1,1),
    VehicleId INT FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    ImageUrl NVARCHAR(255),
);
go

CREATE TABLE InspectionFees (
    InspectionFeesId INT PRIMARY KEY IDENTITY(1,1),
    Description NVARCHAR(255),
    FeeAmount DECIMAL(18,2),
    Currency NVARCHAR(100), --VND, USD
    Type NVARCHAR(50), --fixed, percentage
    InspectionDays INT,
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50) --Active, InActive
);
go

CREATE TABLE VehicleInspections (
    VehicleInspectionsId INT PRIMARY KEY IDENTITY(1,1),
    VehicleId INT FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    StaffId INT FOREIGN KEY REFERENCES Users(UsersId),
    InspectionDate DATETIME,
    Notes NVARCHAR(255),
	CancelReason NVARCHAR(255),
    InspectionFeeId INT FOREIGN KEY REFERENCES InspectionFees(InspectionFeesId),
    InspectionFee DECIMAL(18,2),
    Status NVARCHAR(50)
);
go

--------------------------------------------------
-- TRANSACTIONS
--------------------------------------------------

CREATE TABLE BuySell (
    BuySellId INT PRIMARY KEY IDENTITY(1,1),
    BuyerId INT FOREIGN KEY REFERENCES Users(UsersId),
    SellerId INT FOREIGN KEY REFERENCES Users(UsersId),
    VehicleId INT NULL FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    BatteryId INT NULL FOREIGN KEY REFERENCES Batteries(BatteriesId),
    BuyDate DATETIME,
    CarPrice DECIMAL(18,2),
	Currency NVARCHAR(100), --VND, USD
    Status NVARCHAR(50)
);
go

CREATE TABLE PaymentsMethods (
    PaymentMethodId INT PRIMARY KEY IDENTITY(1,1),
    MethodCode NVARCHAR(50) UNIQUE NOT NULL,     -- Ví dụ: 'MOMO', 'ZALOPAY', 'BANK', 'CREDIT'
    MethodName NVARCHAR(100) NOT NULL,           -- Tên hiển thị: "Momo Wallet", "ZaloPay", ...
    Gateway NVARCHAR(255),                       -- Cổng kết nối (nếu có)
    Description NVARCHAR(500),                   -- Mô tả thêm
    LogoUrl NVARCHAR(500),                       -- Link logo để hiển thị trong UI
    IsActive BIT DEFAULT 1,                      -- Có đang được sử dụng hay không
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME
);
go

CREATE TABLE Payments (
    PaymentsId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    PaymentMethodId INT FOREIGN KEY REFERENCES PaymentsMethods(PaymentMethodId),
    Gateway NVARCHAR(255),
    TransactionDate DATETIME,
    AccountNumber NVARCHAR(100),
    Content NVARCHAR(500),
    TransferType NVARCHAR(50),
    TransferAmount DECIMAL(18,2),
    Currency NVARCHAR(100),          -- VND, USD
    Accumulated DECIMAL(18,2),       -- Remain cash in account
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    ReferenceId INT NULL,            
    ReferenceType NVARCHAR(100) NULL,    
    Status NVARCHAR(50)
);
GO

--------------------------------------------------
-- AUCTION
--------------------------------------------------

CREATE TABLE Auctions (
    AuctionsId INT PRIMARY KEY IDENTITY(1,1),
    VehicleId INT FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    SellerId INT FOREIGN KEY REFERENCES Users(UsersId),
    StartPrice DECIMAL(18,2),
    StartTime DATETIME,
    EndTime DATETIME,
    FeePerMinute DECIMAL(18,2),
    OpenFee DECIMAL(18,2),
    EntryFee DECIMAL(18,2),
    Status NVARCHAR(50)
);
go

CREATE TABLE AuctionsFee (
    AuctionsFeeId INT PRIMARY KEY IDENTITY(1,1),
    AuctionsId INT FOREIGN KEY REFERENCES Auctions(AuctionsId),
    Description NVARCHAR(255),
    FeePerMinute DECIMAL(18,2),
    EntryFee DECIMAL(18,2),
    Currency NVARCHAR(50),
    Type NVARCHAR(50), --fixed, percentage
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50)
);
go

CREATE TABLE AuctionParticipants (
    AuctionParticipantId INT IDENTITY PRIMARY KEY,
    PaymentsId INT FOREIGN KEY REFERENCES  Payments(PaymentsId),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    AuctionsId INT FOREIGN KEY REFERENCES Auctions(AuctionsId),
    DepositAmount DECIMAL(18,2) NOT NULL,
    DepositTime DATETIME,
    RefundStatus NVARCHAR(255),
    Status NVARCHAR(255), 
    IsWinningBid BIT DEFAULT 0,
    CONSTRAINT UQ_AuctionParticipant_UserAuction UNIQUE (AuctionsId, UserId)
);
go

CREATE TABLE AuctionBids (
    AuctionBidsId INT PRIMARY KEY IDENTITY(1,1),
    AuctionId INT FOREIGN KEY REFERENCES Auctions(AuctionsId),
    AuctionParticipantId INT FOREIGN KEY REFERENCES AuctionParticipants(AuctionParticipantId),
    BidderId INT FOREIGN KEY REFERENCES Users(UsersId),
    BidAmount DECIMAL(18,2),
    BidTime DATETIME,
    Status NVARCHAR(50),
);
go

--------------------------------------------------
-- PACKAGES
--------------------------------------------------

CREATE TABLE PostPackages (
    PostPackagesId INT PRIMARY KEY IDENTITY(1,1),
    PackageName NVARCHAR(255),
    Description NVARCHAR(255),
    PostPrice DECIMAL(18,2),
	Currency NVARCHAR(100), --VND, USD
    PostDuration INT,
    Status NVARCHAR(50)
);
go

CREATE TABLE UserPackages (
    UserPackagesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    PackageId INT FOREIGN KEY REFERENCES PostPackages(PostPackagesId),
    PaymentsId INT FOREIGN KEY REFERENCES Payments(PaymentsId),
	PurchasedPostDuration INT,
    PurchasedAtPrice DECIMAL(18,2),
	Currency NVARCHAR(100), --VND, USD
    PurchasedAt DATETIME,
    Status NVARCHAR(50)
);
go
--------------------------------------------------
-- HISTORY
--------------------------------------------------

CREATE TABLE Activities (
    ActivitiesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    PaymentId INT NULL FOREIGN KEY REFERENCES Payments(PaymentsId),
    Action NVARCHAR(50),
    ReferenceId INT,
    ReferenceType NVARCHAR(100),
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50)
);
go

CREATE TABLE UserPosts (
    UserPostsId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    VehicleId INT NULL FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    BatteryId INT NULL FOREIGN KEY REFERENCES Batteries(BatteriesId),
    UserPackageId INT FOREIGN KEY REFERENCES UserPackages(UserPackagesId),
    PostedAt DATETIME,
    ExpiredAt DATETIME,
    Status NVARCHAR(50) -- active, expired, removed
);
go


-- Sample Data for SWD392_EV_Management_Project Database

--------------------------------------------------
-- ROLES DATA
--------------------------------------------------
-- Sử dụng database được chỉ định
USE SWD392_SE1834_G2_T1
GO

--------------------------------------------------
-- DỮ LIỆU CƠ BẢN (STATIC DATA)
--------------------------------------------------

-- 1. Bảng Roles
INSERT INTO Roles (Name) VALUES 
('Member'), 
('Staff'), 
('Admin');
GO

-- 2. Bảng PaymentsMethods
INSERT INTO PaymentsMethods (MethodCode, MethodName, Gateway, Description, LogoUrl, IsActive) VALUES
('VNPAY', N'Cổng thanh toán VNPAY', 'VNPAY', N'Thanh toán qua cổng VNPAY, hỗ trợ Internet Banking và mã QR.', 'https://vnpay.vn/logo.png', 1),
('MOMO', N'Ví điện tử Momo', 'MOMO', N'Thanh toán qua ví điện tử Momo.', 'https://momo.vn/logo.png', 1);
GO

-- 3. Bảng PostPackages (Gói đăng tin)
INSERT INTO PostPackages (PackageName, Description, PostPrice, Currency, PostDuration, Status) VALUES
(N'Gói Cơ Bản', N'Đăng tin trong 7 ngày', 50000.00, 'VND', 7, 'Active'),
(N'Gói Cao Cấp', N'Đăng tin nổi bật trong 30 ngày', 150000.00, 'VND', 30, 'Active');
GO

-- 4. Bảng InspectionFees (Phí giám định)
INSERT INTO InspectionFees (Description, FeeAmount, Currency, Type, InspectionDays, Status) VALUES
(N'Phí giám định xe tiêu chuẩn', 500000.00, 'VND', 'fixed', 3, 'Active');
GO

--------------------------------------------------
-- DỮ LIỆU NGƯỜI DÙNG (USERS)
--------------------------------------------------
INSERT INTO Users (UserName, FullName, Email, Phone, Password, ImageUrl, RoleId, CreatedAt, UpdatedAt, Wallet, Status) VALUES
('admin', N'Quản Trị Viên', 'admin@gmail.com', '0987654321', '1', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJEqnKT0022XaMCyb6K37bte9OIjdUGLCHTA&s', 3, GETDATE(), GETDATE(), 0.00, 'Active'),
('staff01', N'Nhân Viên Giám Định', 'staff@gmail.com', '0123456789', '1', 'https://tiemchupanh.com/wp-content/uploads/2024/07/4ed9efe2b3fd60a339ec23-683x1024.jpg', 2, GETDATE(), GETDATE(), 0.00, 'Active'),
('nguyenvana', N'Nguyễn Văn An', 'user1@gmail.com', '0912345678', '1', 'https://chothuestudio.com/wp-content/uploads/2024/07/TCA_3837.jpg', 1, GETDATE(), GETDATE(), 0.00, 'Active'),
('tranthib', N'Trần Thị Bình', 'user2@gmail.com', '0912345679', '1', NULL, 1, GETDATE(), GETDATE(), 0.00, 'Active'),
('leminhc', N'Lê Minh Cường', 'user3@gmail.com', '0912345680', '1', NULL, 1, GETDATE(), GETDATE(), 0.00, 'Active'),
('ducpv', N'Phạm Văn Đức', 'ducpvse183843@fpt.edu.vn', '0345076573', '1', NULL, 1, GETDATE(), GETDATE(), 0.00, 'Active');
GO

--------------------------------------------------
-- DỮ LIỆU PHƯƠNG TIỆN VÀ PIN (VEHICLES & BATTERIES)
--------------------------------------------------

-- Xe của Nguyễn Văn An (UserId=3) - Đang có sẵn
INSERT INTO Vehicles (UserId, VehicleName, Description, Brand, Model, Color, Seats, BodyType, BatteryCapacity, RangeKm, ChargingTimeHours, FastChargingSupport, MotorPowerKw, TopSpeedKph, Acceleration, ConnectorType, Year, Km, BatteryStatus, WarrantyMonths, Price, Currency, CreatedAt, UpdatedAt, Verified, Status) VALUES
(3, N'VinFast VF8 Eco 2023', N'Xe nữ dùng, như mới 99%', N'VinFast', 'VF8 Eco', N'Trắng', 5, 'SUV', 82.0, 420, 8.0, 1, 150, 200, 5.5, 'CCS2', 2023, 15000, N'Tốt', 24, 850000000.00, 'VND', GETDATE(), GETDATE(), 1, 'Available');
GO

-- Xe của Trần Thị Bình (UserId=4) - Chờ giám định để đấu giá
INSERT INTO Vehicles (UserId, VehicleName, Description, Brand, Model, Color, Seats, BodyType, BatteryCapacity, RangeKm, ChargingTimeHours, FastChargingSupport, MotorPowerKw, TopSpeedKph, Acceleration, ConnectorType, Year, Km, BatteryStatus, WarrantyMonths, Price, Currency, CreatedAt, UpdatedAt, Verified, Status) VALUES
(4, N'Hyundai Ioniq 5 2022', N'Bản cao cấp, full option', N'Hyundai', 'Ioniq 5', N'Bạc', 5, 'SUV', 72.6, 480, 6.5, 1, 160, 185, 7.4, 'CCS2', 2022, 25000, N'Tốt', 12, 900000000.00, 'VND', GETDATE(), GETDATE(), 0, 'Pending Verification');
GO

-- Pin của Lê Minh Cường (UserId=5)
INSERT INTO Batteries (UserId, BatteryName, Description, Brand, Capacity, Voltage, WarrantyMonths, Price, Currency, CreatedAt, UpdatedAt, Status) VALUES
(5, N'Pin Lithium-ion 48V 100Ah', N'Pin thay thế cho xe máy điện', N'Generic', 100, 48.0, 6, 12000000.00, 'VND', GETDATE(), GETDATE(), 'Available');
GO

--------------------------------------------------------------------
-- KỊCH BẢN 1: NGUYỄN VĂN AN (UserId=3) MUA GÓI VÀ ĐĂNG TIN BÁN XE
--------------------------------------------------------------------

-- 1. Thanh toán cho gói đăng tin Cơ bản (PostPackagesId=1)
INSERT INTO Payments (UserId, PaymentMethodId, Gateway, TransactionDate, Content, TransferType, TransferAmount, Currency, Status, ReferenceType, ReferenceId) VALUES
(3, 1, 'VNPAY', GETDATE(), N'Thanh toán gói đăng tin Cơ Bản', N'DEPOSIT', 50000.00, 'VND', 'Paid', 'UserPackage', 1);
GO

-- 2. Tạo UserPackage cho Nguyễn Văn An sau khi thanh toán thành công
-- Giả sử ID của thanh toán trên là 1
INSERT INTO UserPackages (UserId, PackageId, PaymentsId, PurchasedPostDuration, PurchasedAtPrice, Currency, PurchasedAt, Status) VALUES
(3, 1, 1, 7, 50000.00, 'VND', GETDATE(), 'Active');
GO

-- 3. Tạo bài đăng bán xe (VehicleId=1) sử dụng gói vừa mua (UserPackagesId=1)
-- Giả sử ID của UserPackage trên là 1
INSERT INTO UserPosts (UserId, VehicleId, UserPackageId, PostedAt, ExpiredAt, Status) VALUES
(3, 1, 1, GETDATE(), DATEADD(day, 7, GETDATE()), 'active');
GO

-- 4. Ghi lại hoạt động
INSERT INTO Activities (UserId, PaymentId, Action, ReferenceId, ReferenceType, CreatedAt, UpdatedAt, Status) VALUES
(3, 1, N'Mua gói tin', 1, 'UserPackage', GETDATE(), GETDATE(), 'Completed'),
(3, NULL, N'Đăng bán xe', 1, 'UserPost', GETDATE(), GETDATE(), 'Completed');
GO

--------------------------------------------------------------------
-- KỊCH BẢN 2: TẠO PHIÊN ĐẤU GIÁ CHO XE CỦA TRẦN THỊ BÌNH (UserId=4)
--------------------------------------------------------------------

-- 1. Tạo phiên đấu giá cho xe VehicleId=2
INSERT INTO Auctions (VehicleId, SellerId, StartPrice, StartTime, EndTime, FeePerMinute, OpenFee, EntryFee, Status) VALUES
(2, 4, 900000000.00, DATEADD(day, 1, GETDATE()), DATEADD(day, 2, GETDATE()), 10000.00, 100000.00, 5000000.00, 'pending');
GO

-- 2. Tự động tạo phí đấu giá đi kèm
-- Giả sử AuctionId vừa tạo là 1
INSERT INTO AuctionsFee (AuctionsId, Description, FeePerMinute, EntryFee, Currency, Type, CreatedAt, Status) VALUES
(1, N'Phí cho phiên đấu giá xe Ioniq 5', 10000.00, 5000000.00, 'VND', 'fixed', GETDATE(), 'Active');
GO

-- 3. Lê Minh Cường (UserId=5) và Phạm Thu Dung (UserId=6) tham gia đấu giá

-- 3.1. Cường thanh toán phí tham gia
INSERT INTO Payments (UserId, PaymentMethodId, Gateway, TransactionDate, Content, TransferType, TransferAmount, Currency, Status, ReferenceType, ReferenceId) VALUES
(5, 1, 'VNPAY', GETDATE(), N'Thanh toán phí tham gia đấu giá xe Ioniq 5', N'DEPOSIT', 5000000.00, 'VND', 'Paid', 'AuctionFee', 1);
GO

-- 3.2. Cường được thêm vào danh sách tham gia
-- Giả sử PaymentId của Cường là 2
INSERT INTO AuctionParticipants (PaymentsId, UserId, AuctionsId, DepositAmount, DepositTime, RefundStatus, Status, IsWinningBid) VALUES
(2, 5, 1, 5000000.00, GETDATE(), 'NotRefunded', 'Active', 0);
GO

-- 3.3. Dung thanh toán phí tham gia
INSERT INTO Payments (UserId, PaymentMethodId, Gateway, TransactionDate, Content, TransferType, TransferAmount, Currency, Status, ReferenceType, ReferenceId) VALUES
(6, 1, 'VNPAY', GETDATE(), N'Thanh toán phí tham gia đấu giá xe Ioniq 5', N'DEPOSIT', 5000000.00, 'VND', 'Paid', 'AuctionFee', 1);
GO

-- 3.4. Dung được thêm vào danh sách tham gia
-- Giả sử PaymentId của Dung là 3
INSERT INTO AuctionParticipants (PaymentsId, UserId, AuctionsId, DepositAmount, DepositTime, RefundStatus, Status, IsWinningBid) VALUES
(3, 6, 1, 5000000.00, GETDATE(), 'NotRefunded', 'Active', 0);
GO

-- 4. Bắt đầu phiên đấu giá (Cập nhật status của Auction thành 'active')
UPDATE Auctions SET Status = 'active', StartTime = GETDATE() WHERE AuctionsId = 1;
GO

-- 5. Quá trình ra giá
-- Giả sử ParticipantId của Cường là 1, của Dung là 2
-- Cường ra giá đầu tiên
INSERT INTO AuctionBids (AuctionId, AuctionParticipantId, BidderId, BidAmount, BidTime, Status) VALUES
(1, 1, 5, 905000000.00, GETDATE(), 'Valid');
GO

-- Dung ra giá cao hơn
INSERT INTO AuctionBids (AuctionId, AuctionParticipantId, BidderId, BidAmount, BidTime, Status) VALUES
(1, 2, 6, 910000000.00, DATEADD(minute, 2, GETDATE()), 'Valid');
GO

-- Cường ra giá cao hơn nữa
INSERT INTO AuctionBids (AuctionId, AuctionParticipantId, BidderId, BidAmount, BidTime, Status) VALUES
(1, 1, 5, 915000000.00, DATEADD(minute, 5, GETDATE()), 'Valid');
GO

-- 6. Kết thúc phiên đấu giá
UPDATE Auctions SET Status = 'ended', EndTime = GETDATE() WHERE AuctionsId = 1;
GO

-- 7. Cập nhật người chiến thắng và người thua
-- Cường (UserId=5, ParticipantId=1) là người chiến thắng
UPDATE AuctionParticipants SET Status = 'Won', IsWinningBid = 1 WHERE AuctionParticipantId = 1;
-- Dung (UserId=6, ParticipantId=2) là người thua, chờ hoàn tiền cọc
UPDATE AuctionParticipants SET Status = 'Lose', RefundStatus = 'PendingConfirmation' WHERE AuctionParticipantId = 2;
GO

-- 8. Tạo giao dịch mua bán sau khi đấu giá thành công
INSERT INTO BuySell (BuyerId, SellerId, VehicleId, BuyDate, CarPrice, Currency, Status) VALUES
(5, 4, 2, GETDATE(), 915000000.00, 'VND', 'Completed');
GO

-- 9. Cập nhật trạng thái xe đã bán
UPDATE Vehicles SET Status = 'Sold' WHERE VehiclesId = 2;
GO

-- 10. Ghi lại các hoạt động
INSERT INTO Activities (UserId, PaymentId, Action, ReferenceId, ReferenceType, CreatedAt, UpdatedAt, Status) VALUES
(5, 2, N'Tham gia đấu giá', 1, 'Auction', GETDATE(), GETDATE(), 'Completed'),
(6, 3, N'Tham gia đấu giá', 1, 'Auction', GETDATE(), GETDATE(), 'Completed'),
(5, NULL, N'Thắng đấu giá', 1, 'Auction', GETDATE(), GETDATE(), 'Completed'),
(5, NULL, N'Mua xe', 1, 'BuySell', GETDATE(), GETDATE(), 'Completed');
GO

select * from Users

--select * from Payments

--select * from PaymentsMethods

--select * from UserPosts

--select * from PostPackages

select * from AuctionsFee

select * from Auctions

select * from AuctionBids

select * from AuctionParticipants


select * from AuctionParticipants

