--------------------------------------------------
-- USERS & ROLES
--------------------------------------------------

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

CREATE TABLE Users (
    UsersId INT PRIMARY KEY IDENTITY(1,1),
	UserName NVARCHAR(255) UNIQUE,
    FullName NVARCHAR(255),
    Email NVARCHAR(255) UNIQUE,
    Phone NVARCHAR(50) UNIQUE,
    Password VARCHAR(255),
    ImageUrl text,
    RoleId INT FOREIGN KEY REFERENCES Roles(RolesId),
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50) --Active, InActive
);

--------------------------------------------------
-- BATTERIES
--------------------------------------------------

CREATE TABLE Batteries (
    BatteriesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId), -- seller
    BatteryName NVARCHAR(255),
    Description TEXT,
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

CREATE TABLE BatteryImages (
    BatteryImagesId INT PRIMARY KEY IDENTITY(1,1),
    BatteryId INT FOREIGN KEY REFERENCES Batteries(BatteriesId),
    ImageUrl TEXT,
);

--------------------------------------------------
-- VEHICLES
--------------------------------------------------

CREATE TABLE Vehicles (
    VehiclesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    VehicleName NVARCHAR(255),
    Description TEXT,
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

CREATE TABLE VehicleImages (
    VehicleImagesId INT PRIMARY KEY IDENTITY(1,1),
    VehicleId INT FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    ImageUrl text,
);

CREATE TABLE InspectionFees (
    InspectionFeesId INT PRIMARY KEY IDENTITY(1,1),
    Description TEXT,
    FeeAmount DECIMAL(18,2),
    Currency NVARCHAR(100), --VND, USD
    Type NVARCHAR(50), --fixed, percentage
    InspectionDays INT,
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50) --Active, InActive
);

CREATE TABLE VehicleInspections (
    VehicleInspectionsId INT PRIMARY KEY IDENTITY(1,1),
    VehicleId INT FOREIGN KEY REFERENCES Vehicles(VehiclesId),
    StaffId INT FOREIGN KEY REFERENCES Users(UsersId),
    InspectionDate DATETIME,
    Notes TEXT,
	CancelReason TEXT,
    InspectionFeeId INT FOREIGN KEY REFERENCES InspectionFees(InspectionFeesId),
    InspectionFee DECIMAL(18,2),
    Status NVARCHAR(50)
);

CREATE TABLE AuctionsFee (
    AuctionsFeeId INT PRIMARY KEY IDENTITY(1,1),
    Description TEXT,
    FeePerMinute DECIMAL(18,2),
    EntryFee DECIMAL(18,2),
    Currency NVARCHAR(50),
    Type NVARCHAR(50), --fixed, percentage
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50)
);

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

CREATE TABLE Payments (
    PaymentsId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    Gateway NVARCHAR(255),
    TransactionDate DATETIME,
    AccountNumber NVARCHAR(100),
    Content NVARCHAR(500),
    TransferType NVARCHAR(50),
    TransferAmount DECIMAL(18,2),
    Currency NVARCHAR(100), --VND, USD
    Accumulated DECIMAL(18,2), --Remain Cash in account
    CreatedAt DATETIME,
    UpdatedAt DATETIME,
    Status NVARCHAR(50)
);

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
    AuctionsFeeId INT FOREIGN KEY REFERENCES AuctionsFee(AuctionsFeeId),
    FeePerMinute DECIMAL(18,2),
    OpenFee DECIMAL(18,2),
    EntryFee DECIMAL(18,2),
    Status NVARCHAR(50)
);

CREATE TABLE AuctionBids (
    AuctionBidsId INT PRIMARY KEY IDENTITY(1,1),
    AuctionId INT FOREIGN KEY REFERENCES Auctions(AuctionsId),
    BidderId INT FOREIGN KEY REFERENCES Users(UsersId),
    BidAmount DECIMAL(18,2),
    BidTime DATETIME,
    Status NVARCHAR(50)
);

--------------------------------------------------
-- PACKAGES
--------------------------------------------------

CREATE TABLE PostPackages (
    PostPackagesId INT PRIMARY KEY IDENTITY(1,1),
    PackageName NVARCHAR(255),
    Description TEXT,
    PostPrice DECIMAL(18,2),
	Currency NVARCHAR(100), --VND, USD
    PostDuration INT,
    Status NVARCHAR(50)
);

CREATE TABLE UserPackages (
    UserPackagesId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UsersId),
    PackageId INT FOREIGN KEY REFERENCES PostPackages(PostPackagesId),
	PurchasedPostDuration INT,
    PurchasedAtPrice DECIMAL(18,2),
	Currency NVARCHAR(100), --VND, USD
    PurchasedAt DATETIME,
    Status NVARCHAR(50)
);

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
INSERT INTO Roles (Name) VALUES 
('Member'),
('Staff'),
('Admin')
--------------------------------------------------
-- USERS DATA
--------------------------------------------------
INSERT INTO Users (UserName, FullName, Email, Phone, Password, ImageUrl, RoleId, CreatedAt, UpdatedAt, Status) VALUES 
-- Admin
('admin', N'Bố Admin', 'admin@gm.c', '0901234567', '1', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJEqnKT0022XaMCyb6K37bte9OIjdUGLCHTA&s', 3, '2024-01-15 08:00:00', '2024-01-15 08:00:00', 'Active'),

-- Staff
('staff', N'Má Staff ', 'staff1@gm.c', '0901234568', '1', 'https://tiemchupanh.com/wp-content/uploads/2024/07/4ed9efe2b3fd60a339ec23-683x1024.jpg', 2, '2024-01-20 08:00:00', '2024-01-20 08:00:00', 'Active'),
('staff01', N'Bố Staff', 'staff2@gm.c', '0901234569', '1', 'https://chothuestudio.com/wp-content/uploads/2024/07/TCA_3837.jpg', 2, '2024-01-25 08:00:00', '2024-01-25 08:00:00', 'Active'),

-- Customers/Sellers
('seller01', N'Phạm Minh Hải', 'hai.pham@gmail.com', '0912345678', 'hashed_password_seller1', 'https://example.com/images/seller1.jpg', 1, '2024-02-01 10:00:00', '2024-02-01 10:00:00', 'Active'),
('customer01', N'Võ Thị Lan', 'lan.vo@gmail.com', '0923456789', 'hashed_password_customer1', 'https://example.com/images/customer1.jpg', 1, '2024-02-05 14:30:00', '2024-02-05 14:30:00', 'Active'),
('seller02', N'Hoàng Văn Thắng', 'thang.hoang@gmail.com', '0934567890', 'hashed_password_seller2', 'https://example.com/images/seller2.jpg', 1, '2024-02-10 09:15:00', '2024-02-10 09:15:00', 'Active'),
('customer02', N'Nguyễn Thị Mai', 'mai.nguyen@gmail.com', '0945678901', 'hashed_password_customer2', 'https://example.com/images/customer2.jpg', 1, '2024-02-15 16:20:00', '2024-02-15 16:20:00', 'Active'),
('seller03', N'Đỗ Minh Tuấn', 'tuan.do@gmail.com', '0956789012', 'hashed_password_seller3', 'https://example.com/images/seller3.jpg', 1, '2024-02-20 11:45:00', '2024-02-20 11:45:00', 'Active');

--------------------------------------------------
-- BATTERIES DATA
--------------------------------------------------
INSERT INTO Batteries (UserId, BatteryName, Description, Brand, Capacity, Voltage, WarrantyMonths, Price, Currency, CreatedAt, UpdatedAt, Status) VALUES 
(4, N'Pin Lithium VinFast 50Ah', N'Pin lithium chất lượng cao cho xe điện VinFast', 'VinFast', 50, 48.0, 24, 15000000, 'VND', '2024-03-01 09:00:00', '2024-03-01 09:00:00', 'Available'),
(6, N'Tesla Model 3 Battery Pack', N'Genuine Tesla battery pack, excellent condition', 'Tesla', 75, 350.0, 36, 8500, 'USD', '2024-03-05 14:20:00', '2024-03-05 14:20:00', 'Available'),
(8, N'BYD Blade Battery 60Ah', N'Advanced BYD Blade battery technology', 'BYD', 60, 52.0, 30, 18000000, 'VND', '2024-03-10 10:30:00', '2024-03-10 10:30:00', 'Available'),
(4, N'LiFePO4 Battery 40Ah', N'Long-lasting lithium iron phosphate battery', 'CATL', 40, 48.0, 60, 12000000, 'VND', '2024-03-15 08:45:00', '2024-03-15 08:45:00', 'Sold');

--------------------------------------------------
-- BATTERY IMAGES DATA
--------------------------------------------------
INSERT INTO BatteryImages (BatteryId, ImageUrl) VALUES 
(1, 'https://example.com/batteries/vinfast_battery_1.jpg'),
(1, 'https://example.com/batteries/vinfast_battery_2.jpg'),
(2, 'https://example.com/batteries/tesla_battery_1.jpg'),
(2, 'https://example.com/batteries/tesla_battery_2.jpg'),
(3, 'https://example.com/batteries/byd_battery_1.jpg'),
(4, 'https://example.com/batteries/lifepo4_battery_1.jpg');

--------------------------------------------------
-- VEHICLES DATA
--------------------------------------------------
INSERT INTO Vehicles (UserId, VehicleName, Description, Brand, Model, Color, Seats, BodyType, BatteryCapacity, RangeKm, ChargingTimeHours, FastChargingSupport, MotorPowerKw, TopSpeedKph, Acceleration, ConnectorType, Year, Km, BatteryStatus, WarrantyMonths, Price, Currency, CreatedAt, UpdatedAt, Verified, Status) VALUES 
(4, N'VinFast VF8 Plus', N'SUV điện cao cấp, tình trạng như mới', 'VinFast', 'VF8 Plus', N'Xanh đen', 5, 'SUV', 87.7, 420, 6.5, 1, 300, 200, 5.9, 'CCS2', 2023, 5000, N'Excellent', 48, 1250000000, 'VND', '2024-03-01 10:00:00', '2024-03-01 10:00:00', 1, 'Available'),
(6, N'Tesla Model Y Long Range', N'Premium electric SUV with autopilot', 'Tesla', 'Model Y', 'Pearl White', 7, 'SUV', 75.0, 526, 5.0, 1, 346, 217, 4.8, 'CCS2', 2022, 15000, 'Very Good', 24, 52000, 'USD', '2024-03-05 11:30:00', '2024-03-05 11:30:00', 1, 'Available'),
(8, N'BYD Tang EV', N'7-seat electric SUV with luxury features', 'BYD', 'Tang EV', 'Midnight Black', 7, 'SUV', 86.4, 505, 7.0, 1, 380, 180, 6.2, 'GB/T', 2023, 8000, 'Excellent', 36, 980000000, 'VND', '2024-03-10 09:15:00', '2024-03-10 09:15:00', 1, 'Available'),
(4, N'VinFast VF9 Premium', N'Flagship electric SUV', 'VinFast', 'VF9', N'Trắng ngọc trai', 7, 'SUV', 123.0, 594, 8.0, 1, 408, 200, 6.5, 'CCS2', 2024, 2000, 'Like New', 60, 1690000000, 'VND', '2024-03-15 14:00:00', '2024-03-15 14:00:00', 0, 'Pending Verification'),
(6, N'Hyundai IONIQ 6', N'Sleek electric sedan with great efficiency', 'Hyundai', 'IONIQ 6', 'Gravity Gold', 5, 'Sedan', 77.4, 614, 4.5, 1, 239, 185, 7.4, 'CCS2', 2023, 12000, 'Good', 24, 45000, 'USD', '2024-03-20 16:30:00', '2024-03-20 16:30:00', 1, 'Sold');

--------------------------------------------------
-- VEHICLE IMAGES DATA
--------------------------------------------------
INSERT INTO VehicleImages (VehicleId, ImageUrl) VALUES 
(1, 'https://example.com/vehicles/vf8_exterior_1.jpg'),
(1, 'https://example.com/vehicles/vf8_exterior_2.jpg'),
(1, 'https://example.com/vehicles/vf8_interior_1.jpg'),
(2, 'https://example.com/vehicles/tesla_model_y_1.jpg'),
(2, 'https://example.com/vehicles/tesla_model_y_2.jpg'),
(3, 'https://example.com/vehicles/byd_tang_1.jpg'),
(3, 'https://example.com/vehicles/byd_tang_2.jpg'),
(4, 'https://example.com/vehicles/vf9_premium_1.jpg'),
(5, 'https://example.com/vehicles/ioniq6_1.jpg');

--------------------------------------------------
-- INSPECTION FEES DATA
--------------------------------------------------
INSERT INTO InspectionFees (Description, FeeAmount, Currency, Type, InspectionDays, CreatedAt, UpdatedAt, Status) VALUES 
(N'Phí kiểm định xe điện cơ bản', 2000000, 'VND', 'fixed', 3, '2024-01-01 00:00:00', '2024-01-01 00:00:00', 'Active'),
(N'Phí kiểm định xe điện cao cấp', 3500000, 'VND', 'fixed', 5, '2024-01-01 00:00:00', '2024-01-01 00:00:00', 'Active'),
(N'Premium Vehicle Inspection', 150, 'USD', 'fixed', 7, '2024-01-01 00:00:00', '2024-01-01 00:00:00', 'Active');

--------------------------------------------------
-- VEHICLE INSPECTIONS DATA
--------------------------------------------------
INSERT INTO VehicleInspections (VehicleId, StaffId, InspectionDate, Notes, CancelReason, InspectionFeeId, InspectionFee, Status) VALUES 
(1, 2, '2024-03-02 09:00:00', N'Xe trong tình trạng tốt, pin hoạt động bình thường', NULL, 2, 3500000, 'Completed'),
(2, 3, '2024-03-06 10:30:00', N'Vehicle in excellent condition, autopilot features working perfectly', NULL, 3, 150, 'Completed'),
(3, 2, '2024-03-11 14:00:00', N'All systems operational, battery health at 95%', NULL, 2, 3500000, 'Completed'),
(4, 3, '2024-03-18 11:00:00', N'New vehicle, all systems check passed', NULL, 2, 3500000, 'Scheduled');

--------------------------------------------------
-- AUCTIONS FEE DATA
--------------------------------------------------
INSERT INTO AuctionsFee (Description, FeePerMinute, EntryFee, Currency, Type, CreatedAt, UpdatedAt, Status) VALUES 
(N'Phí đấu giá tiêu chuẩn', 50000, 500000, 'VND', 'fixed', '2024-01-01 00:00:00', '2024-01-01 00:00:00', 'Active'),
(N'Premium auction fee', 2, 25, 'USD', 'fixed', '2024-01-01 00:00:00', '2024-01-01 00:00:00', 'Active');

--------------------------------------------------
-- POST PACKAGES DATA
--------------------------------------------------
INSERT INTO PostPackages (PackageName, Description, PostPrice, Currency, PostDuration, Status) VALUES 
(N'Gói Cơ Bản', N'Đăng tin 30 ngày, hiển thị thông thường', 100000, 'VND', 30, 'Active'),
(N'Gói Nổi Bật', N'Đăng tin 45 ngày, ưu tiên hiển thị', 200000, 'VND', 45, 'Active'),
(N'Gói VIP', N'Đăng tin 60 ngày, hiển thị đầu trang', 350000, 'VND', 60, 'Active'),
('Basic Package', 'Standard 30-day listing', 5, 'USD', 30, 'Active'),
('Premium Package', 'Featured 60-day listing', 15, 'USD', 60, 'Active');

--------------------------------------------------
-- PAYMENTS DATA
--------------------------------------------------
INSERT INTO Payments (UserId, Gateway, TransactionDate, AccountNumber, Content, TransferType, TransferAmount, Currency, Accumulated, CreatedAt, UpdatedAt, Status) VALUES 
(4, 'VNPay', '2024-02-25 10:30:00', '1234567890', N'Nạp tiền vào tài khoản', 'Deposit', 5000000, 'VND', 5000000, '2024-02-25 10:30:00', '2024-02-25 10:30:00', 'Success'),
(5, 'Momo', '2024-02-28 14:15:00', '0923456789', N'Thanh toán gói đăng tin', 'Payment', -200000, 'VND', 1800000, '2024-02-28 14:15:00', '2024-02-28 14:15:00', 'Success'),
(6, 'PayPal', '2024-03-01 09:45:00', 'thang.hoang@paypal.com', 'Account top-up', 'Deposit', 100, 'USD', 100, '2024-03-01 09:45:00', '2024-03-01 09:45:00', 'Success'),
(7, 'VNPay', '2024-03-05 16:20:00', '9876543210', N'Thanh toán phí kiểm định', 'Payment', -3500000, 'VND', 1500000, '2024-03-05 16:20:00', '2024-03-05 16:20:00', 'Success'),
(8, 'Momo', '2024-03-08 11:30:00', '0956789012', N'Nạp tiền tài khoản', 'Deposit', 3000000, 'VND', 3000000, '2024-03-08 11:30:00', '2024-03-08 11:30:00', 'Success');

--------------------------------------------------
-- USER PACKAGES DATA
--------------------------------------------------
INSERT INTO UserPackages (UserId, PackageId, PurchasedPostDuration, PurchasedAtPrice, Currency, PurchasedAt, Status) VALUES 
(4, 2, 45, 200000, 'VND', '2024-02-28 09:00:00', 'Active'),
(6, 5, 60, 15, 'USD', '2024-03-01 10:30:00', 'Active'),
(8, 3, 60, 350000, 'VND', '2024-03-08 14:15:00', 'Active'),
(5, 1, 30, 100000, 'VND', '2024-02-28 14:15:00', 'Used');

--------------------------------------------------
-- USER POSTS DATA
--------------------------------------------------
INSERT INTO UserPosts (UserId, VehicleId, BatteryId, UserPackageId, PostedAt, ExpiredAt, Status) VALUES 
(4, 1, NULL, 1, '2024-03-01 10:00:00', '2024-04-15 10:00:00', 'Active'),
(6, 2, NULL, 2, '2024-03-05 11:30:00', '2024-05-04 11:30:00', 'Active'),
(8, 3, NULL, 3, '2024-03-10 09:15:00', '2024-05-09 09:15:00', 'Active'),
(4, NULL, 1, 1, '2024-03-01 11:00:00', '2024-04-15 11:00:00', 'Active'),
(5, 5, NULL, 4, '2024-03-20 16:30:00', '2024-04-19 16:30:00', 'Expired');

--------------------------------------------------
-- AUCTIONS DATA
--------------------------------------------------
INSERT INTO Auctions (VehicleId, SellerId, StartPrice, StartTime, EndTime, AuctionsFeeId, FeePerMinute, OpenFee, EntryFee, Status) VALUES 
(2, 6, 50000, '2024-03-25 10:00:00', '2024-03-25 12:00:00', 2, 2, 50, 25, 'Completed'),
(3, 8, 900000000, '2024-03-28 14:00:00', '2024-03-28 16:00:00', 1, 50000, 1000000, 500000, 'Active');

--------------------------------------------------
-- AUCTION BIDS DATA
--------------------------------------------------
INSERT INTO AuctionBids (AuctionId, BidderId, BidAmount, BidTime, Status) VALUES 
(1, 5, 50500, '2024-03-25 10:15:00', 'Valid'),
(1, 7, 51000, '2024-03-25 10:30:00', 'Valid'),
(1, 5, 51500, '2024-03-25 11:00:00', 'Valid'),
(1, 7, 52000, '2024-03-25 11:45:00', 'Winning'),
(2, 4, 920000000, '2024-03-28 14:30:00', 'Valid'),
(2, 7, 950000000, '2024-03-28 15:15:00', 'Leading');

--------------------------------------------------
-- BUY SELL DATA
--------------------------------------------------
INSERT INTO BuySell (BuyerId, SellerId, VehicleId, BatteryId, BuyDate, CarPrice, Currency, Status) VALUES 
(7, 6, 5, NULL, '2024-03-21 10:30:00', 45000, 'USD', 'Completed'),
(5, 4, NULL, 4, '2024-03-16 14:20:00', 12000000, 'VND', 'Completed'),
(7, 6, 2, NULL, '2024-03-26 15:30:00', 52000, 'USD', 'Pending');

--------------------------------------------------
-- ACTIVITIES DATA
--------------------------------------------------
INSERT INTO Activities (UserId, PaymentId, Action, ReferenceId, ReferenceType, CreatedAt, UpdatedAt, Status) VALUES 
(4, 1, 'DEPOSIT', 1, 'Payment', '2024-02-25 10:30:00', '2024-02-25 10:30:00', 'Completed'),
(5, 2, 'PURCHASE_PACKAGE', 4, 'UserPackage', '2024-02-28 14:15:00', '2024-02-28 14:15:00', 'Completed'),
(6, 3, 'DEPOSIT', 3, 'Payment', '2024-03-01 09:45:00', '2024-03-01 09:45:00', 'Completed'),
(4, NULL, 'POST_VEHICLE', 1, 'Vehicle', '2024-03-01 10:00:00', '2024-03-01 10:00:00', 'Completed'),
(6, NULL, 'POST_VEHICLE', 2, 'Vehicle', '2024-03-05 11:30:00', '2024-03-05 11:30:00', 'Completed'),
(7, NULL, 'BID_AUCTION', 4, 'AuctionBid', '2024-03-25 11:45:00', '2024-03-25 11:45:00', 'Completed'),
(7, NULL, 'BUY_VEHICLE', 1, 'BuySell', '2024-03-21 10:30:00', '2024-03-21 10:30:00', 'Completed'),
(5, NULL, 'BUY_BATTERY', 2, 'BuySell', '2024-03-16 14:20:00', '2024-03-16 14:20:00', 'Completed');
go

select * from Users