-- ======================================
-- ADMIN (root table for many relations)
-- ======================================
use master
go

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FA25_PRN222_SE1834_G2_EVCMS')
	BEGIN
		ALTER DATABASE FA25_PRN222_SE1834_G2_EVCMS SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE FA25_PRN222_SE1834_G2_EVCMS;
	end
go

create database FA25_PRN222_SE1834_G2_EVCMS
go

use FA25_PRN222_SE1834_G2_EVCMS
go

CREATE TABLE Admin (
    AdminId INT IDENTITY(1,1) PRIMARY KEY,
    ContactEmail VARCHAR(255),
    ContactPhone VARCHAR(50),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT
);

-- ======================================
-- [UserAccount]
-- ======================================
CREATE TABLE [dbo].[UserAccount](
	[UserAccountID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[EmployeeCode] [nvarchar](50) NOT NULL,
	[RoleId] [int] NOT NULL,
	[RequestCode] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ApplicationCode] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_System.UserAccount] PRIMARY KEY CLUSTERED 
(
	[UserAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];

-- ======================================
-- STAFF
-- ======================================
CREATE TABLE Staff (
    StaffId INT IDENTITY(1,1) PRIMARY KEY,
    CreatedByAdminId INT,
	FirstName VARCHAR(100), 
    LastName VARCHAR(100),
    Email VARCHAR(255),
    StartDate DATETIME2,
    EndDate DATETIME2,
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkStaffAdmin FOREIGN KEY (CreatedByAdminId) REFERENCES Admin(AdminId)
);

-- ======================================
-- ROLES
-- ======================================
CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(100) NOT NULL
);

-- ======================================
-- SUBSCRIPTION TYPES
-- ======================================
CREATE TABLE SubscriptionTypes (
    TypeId INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT,
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2
);

-- ======================================
-- SUBSCRIPTION PLANS
-- ======================================
CREATE TABLE Subscription (
    SubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    PlanName VARCHAR(100),
    PlanCode VARCHAR(50),
    Description TEXT,
    Price DECIMAL(18,2),
    TypeId INT,
    DiscountRate DECIMAL(5,2),
    CreatedByAdminId INT,
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkSubscriptionPlansAdmin FOREIGN KEY (CreatedByAdminId) REFERENCES Admin(AdminId),
    CONSTRAINT FkSubscriptionPlansType FOREIGN KEY (TypeId) REFERENCES SubscriptionTypes(TypeId)
);

-- ======================================
-- VEHICLES
-- ======================================
CREATE TABLE Vehicles (
    VehicleId INT IDENTITY(1,1) PRIMARY KEY,
    [UserAccountID] INT,
    LicensePlate VARCHAR(50),
    VehicleModel VARCHAR(100),
    ConnectorType VARCHAR(50),
    Status BIT,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    CONSTRAINT FkVehiclesDriver FOREIGN KEY ([UserAccountID]) REFERENCES [UserAccount]([UserAccountID])
);

-- ======================================
-- NOTIFICATIONS
-- ======================================
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    [UserAccountID] INT,
    Title VARCHAR(200),
    Body TEXT,
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkNotificationsDriver FOREIGN KEY ([UserAccountID]) REFERENCES [UserAccount]([UserAccountID])
);

-- ======================================
-- USER SUBSCRIPTIONS
-- ======================================
CREATE TABLE UserSubscriptions (
    UserSubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    [UserAccountID] INT,
    SubscriptionId INT,
    StartDate DATETIME2,
    EndDate DATETIME2,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkUserSubscriptionsDriver FOREIGN KEY ([UserAccountID]) REFERENCES [UserAccount]([UserAccountID]),
    CONSTRAINT FkUserSubscriptionsPlan FOREIGN KEY (SubscriptionId) REFERENCES Subscription(SubscriptionId)
);

-- ======================================
-- CHARGING STATIONS
-- ======================================
CREATE TABLE ChargingStations (
    StationId INT IDENTITY(1,1) PRIMARY KEY,
    StationName VARCHAR(255),
    NumberOfPoints INT,
    Address TEXT,
    PricePerKwh DECIMAL(18,2),
    OperatedByStaffId INT,
    AssignedByAdminId INT,
    OpeningHours TIME,
    ClosingHours TIME,
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkChargingStationsStaff FOREIGN KEY (OperatedByStaffId) REFERENCES Staff(StaffId),
    CONSTRAINT FkChargingStationsAdmin FOREIGN KEY (AssignedByAdminId) REFERENCES Admin(AdminId)
);

-- ======================================
-- CHARGING POINTS
-- ======================================
CREATE TABLE ChargingPoints (
    PointId INT IDENTITY(1,1) PRIMARY KEY,
    StationId INT,
    PointName VARCHAR(100),
    ConnectorType VARCHAR(50),
    InstalledDate DATE,
    LastUsedAt DATETIME2,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkChargingPointsStation FOREIGN KEY (StationId) REFERENCES ChargingStations(StationId)
);

-- ======================================
-- RESERVATIONS
-- ======================================
CREATE TABLE Reservations (
    ReservationId INT IDENTITY(1,1) PRIMARY KEY,
    [UserAccountID] INT,
    PointId INT,
    StartTime DATETIME2,
    EndTime DATETIME2,
    CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkReservationsDriver FOREIGN KEY ([UserAccountID]) REFERENCES [UserAccount]([UserAccountID]),
    CONSTRAINT FkReservationsPoint FOREIGN KEY (PointId) REFERENCES ChargingPoints(PointId)
);

-- ======================================
-- CHARGING SESSIONS
-- ======================================
CREATE TABLE ChargingSessions (
    SessionId INT IDENTITY(1,1) PRIMARY KEY,
    PointId INT,
    EnergyConsumedKwh DECIMAL(18,2),
    VehicleId INT,
    StartTime DATETIME2,
    EndTime DATETIME2,
    IsFullyCharged BIT,
    Status BIT,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    CONSTRAINT FkSessionsPoint FOREIGN KEY (PointId) REFERENCES ChargingPoints(PointId),
    CONSTRAINT FkSessionsVehicle FOREIGN KEY (VehicleId) REFERENCES Vehicles(VehicleId)
);

-- ======================================
-- PAYMENT METHODS
-- ======================================
CREATE TABLE PaymentMethodsDucPV (
    MethodDucPVId INT IDENTITY(1,1) PRIMARY KEY,
    MethodType VARCHAR(50),
    Status BIT,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2
);

-- ======================================
-- TRANSACTIONS
-- ======================================
CREATE TABLE TransactionsDucPV (
    TransactionTransactionsDucPVId INT IDENTITY(1,1) PRIMARY KEY,
    SessionId INT,
    [UserAccountID] INT,
    Amount DECIMAL(18,2),
    MethodDucPVId INT,
	Description NVARCHAR(255) NULL, 
    TransactionDate DATETIME2,
    Status BIT,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    CONSTRAINT FkTransactionsSession FOREIGN KEY (SessionId) REFERENCES ChargingSessions(SessionId),
    CONSTRAINT FkTransactionsDriver FOREIGN KEY ([UserAccountID]) REFERENCES [UserAccount]([UserAccountID]),
    CONSTRAINT FkTransactionsMethod FOREIGN KEY (MethodDucPVId) REFERENCES PaymentMethodsDucPV(MethodDucPVId)
);

-- ======================================
-- INVOICES
-- ======================================
CREATE TABLE Invoices (
    InvoiceId INT IDENTITY(1,1) PRIMARY KEY,
    TransactionTransactionsDucPVId INT,
    InvoiceData TEXT,
    IssuedDate DATETIME,
    Status BIT,
	CreatedAt DATETIME2,
    UpdatedAt DATETIME2,
    CONSTRAINT FkInvoicesTransaction FOREIGN KEY (TransactionTransactionsDucPVId) REFERENCES TransactionsDucPV(TransactionTransactionsDucPVId)
);

-- ======================================
-- ISSUE REPORTS
-- ======================================
CREATE TABLE IssueReports (
    ReportId INT IDENTITY(1,1) PRIMARY KEY,
    PointId INT,
    ReportedByStaffId INT,
    Description TEXT,
    CreatedAt DATETIME2,
    ResolvedAt DATETIME2,
    Status BIT,
    CONSTRAINT FkIssueReportsPoint FOREIGN KEY (PointId) REFERENCES ChargingPoints(PointId),
    CONSTRAINT FkIssueReportsStaff FOREIGN KEY (ReportedByStaffId) REFERENCES Staff(StaffId)
);

GO


SET IDENTITY_INSERT Roles ON;
GO

-- ======================================
-- ADD SAMPLE DATA
-- ======================================

-- 1. Thêm Admin
INSERT INTO Admin (ContactEmail, ContactPhone, FirstName, LastName, CreatedAt, UpdatedAt, Status)
VALUES 
('admin@email.com', '0901234567', 'System', 'Admin', GETDATE(), GETDATE(), 1);

-- 2. Thêm Roles
--INSERT INTO Roles (RoleName) VALUES ('Admin'), ('Staff'), ('Customer');

-- 3. Thêm UserAccount
INSERT INTO UserAccount (UserName, Password, FullName, Email, Phone, EmployeeCode, RoleId, CreatedDate, IsActive)
VALUES 
('user1', '123456', N'Nguyen Van A', 'user1@email.com', '0901111111', 'EMP001', 1, GETDATE(), 1),
('user2', '123456', N'Tran Thi B', 'user2@email.com', '0902222222', 'EMP002', 2, GETDATE(), 1),
('user3', '123456', N'Le Van C', 'user3@email.com', '0903333333', 'EMP003', 3, GETDATE(), 1),
('user4', '123456', N'Pham Thi D', 'user4@email.com', '0904444444', 'EMP004', 3, GETDATE(), 1),
('user5', '123456', N'Hoang Van E', 'user5@email.com', '0905555555', 'EMP005', 3, GETDATE(), 1);

-- 4. Thêm Staff (liên kết với AdminId = 1)
INSERT INTO Staff (CreatedByAdminId, FirstName, LastName, Email, StartDate, CreatedAt, UpdatedAt, Status)
VALUES 
(1, 'Nguyen', 'Van A', 'staff1@email.com', GETDATE(), GETDATE(), GETDATE(), 1);

-- 5. Thêm SubscriptionTypes
INSERT INTO SubscriptionTypes (TypeName, Description, CreatedAt, UpdatedAt)
VALUES 
('Basic', 'Basic subscription plan', GETDATE(), GETDATE()),
('Premium', 'Premium subscription plan', GETDATE(), GETDATE());

-- 6. Thêm Subscription (liên kết với AdminId=1, TypeId)
INSERT INTO Subscription (PlanName, PlanCode, Description, Price, TypeId, DiscountRate, CreatedByAdminId, CreatedAt, UpdatedAt, Status)
VALUES 
('Basic Plan', 'BASIC01', 'Basic package', 100000, 1, 0, 1, GETDATE(), GETDATE(), 1),
('Premium Plan', 'PREM01', 'Premium package', 200000, 2, 10, 1, GETDATE(), GETDATE(), 1);

-- 7. Thêm Vehicles (gán cho các UserAccount đã có)
INSERT INTO Vehicles (UserAccountID, LicensePlate, VehicleModel, ConnectorType, Status, CreatedAt, UpdatedAt)
VALUES 
(1, '51A-11111', 'Tesla Model 3', 'Type2', 1, GETDATE(), GETDATE()),
(2, '51A-22222', 'Nissan Leaf', 'CHAdeMO', 1, GETDATE(), GETDATE()),
(3, '51A-33333', 'BMW i3', 'CCS', 1, GETDATE(), GETDATE()),
(4, '51A-44444', 'Hyundai Kona EV', 'Type2', 1, GETDATE(), GETDATE()),
(5, '51A-55555', 'Kia EV6', 'CCS', 1, GETDATE(), GETDATE());

-- 8. Thêm 1 trạm sạc
INSERT INTO ChargingStations (StationName, NumberOfPoints, Address, PricePerKwh, OperatedByStaffId, AssignedByAdminId, OpeningHours, ClosingHours, CreatedAt, UpdatedAt, Status)
VALUES 
('Station 1', 10, '123 Main St', 5000, 1, 1, '06:00', '22:00', GETDATE(), GETDATE(), 1);

-- 9. Thêm ChargingPoints (thuộc StationId = 1)
INSERT INTO ChargingPoints (StationId, PointName, ConnectorType, InstalledDate, CreatedAt, UpdatedAt, Status)
VALUES 
(1, 'Point A1', 'Type2', GETDATE(), GETDATE(), GETDATE(), 1),
(1, 'Point A2', 'Type2', GETDATE(), GETDATE(), GETDATE(), 1),
(1, 'Point A3', 'CCS', GETDATE(), GETDATE(), GETDATE(), 1),
(1, 'Point A4', 'CHAdeMO', GETDATE(), GETDATE(), GETDATE(), 1);

-- 10. Thêm ChargingSessions (gắn VehicleId, PointId có thật)
INSERT INTO ChargingSessions (PointId, EnergyConsumedKwh, VehicleId, StartTime, EndTime, IsFullyCharged, Status, CreatedAt, UpdatedAt)
VALUES 
(1, 25.5, 1, DATEADD(HOUR,-2,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE()),
(2, 30.0, 2, DATEADD(HOUR,-3,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE()),
(3, 40.0, 3, DATEADD(HOUR,-4,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE());

-- 11. Thêm PaymentMethodsDucPV
INSERT INTO PaymentMethodsDucPV (MethodType, Status, CreatedAt, UpdatedAt)
VALUES 
('Cash', 1, GETDATE(), GETDATE()),
('Credit Card', 1, GETDATE(), GETDATE()),
('E-Wallet', 1, GETDATE(), GETDATE());

-- 12. Thêm TransactionsDucPV
INSERT INTO TransactionsDucPV (SessionId, UserAccountID, Amount, MethodDucPVId, Description, TransactionDate, Status, CreatedAt, UpdatedAt)
VALUES 
(1, 1, 120.00, 1, N'Payment for session 1 by user 1 (Cash)', GETDATE(), 1, GETDATE(), GETDATE()),
(2, 2, 200.00, 2, N'Payment for session 2 by user 2 (Credit Card)', GETDATE(), 1, GETDATE(), GETDATE()),
(3, 3, 175.50, 3, N'Payment for session 3 by user 3 (E-Wallet)', GETDATE(), 1, GETDATE(), GETDATE());

-- 13. Thêm Invoices (tham chiếu TransactionId)
INSERT INTO Invoices (TransactionTransactionsDucPVId, InvoiceData, IssuedDate, Status, CreatedAt, UpdatedAt)
VALUES 
(1, 'Invoice for session 1, amount 120.00', GETDATE(), 1, GETDATE(), GETDATE()),
(2, 'Invoice for session 2, amount 200.00', GETDATE(), 1, GETDATE(), GETDATE()),
(3, 'Invoice for session 3, amount 175.50', GETDATE(), 1, GETDATE(), GETDATE());
go 


select * from [dbo].UserAccount
go
-- ======================================
-- Bổ sung Roles
-- ======================================
INSERT INTO Roles (RoleName) VALUES 
(N'Admin'),
(N'Staff'),
(N'Customer');

-- ======================================
-- Bổ sung Notifications
-- ======================================
INSERT INTO Notifications ([UserAccountID], Title, Body, CreatedAt, UpdatedAt, Status)
VALUES
(1, 'Welcome', 'Welcome Nguyen Van A to the system!', GETDATE(), GETDATE(), 1),
(2, 'Subscription Expired', 'Your subscription has expired, please renew.', GETDATE(), GETDATE(), 1),
(3, 'Payment Success', 'Your last transaction was successful.', GETDATE(), GETDATE(), 1);

-- ======================================
-- Bổ sung UserSubscriptions
-- ======================================
INSERT INTO UserSubscriptions ([UserAccountID], SubscriptionId, StartDate, EndDate, CreatedAt, UpdatedAt, Status)
VALUES
(1, 1, DATEADD(DAY,-30,GETDATE()), GETDATE(), GETDATE(), GETDATE(), 1),
(2, 2, DATEADD(DAY,-60,GETDATE()), DATEADD(DAY,30,GETDATE()), GETDATE(), GETDATE(), 1),
(3, 1, DATEADD(DAY,-15,GETDATE()), DATEADD(DAY,45,GETDATE()), GETDATE(), GETDATE(), 1);

-- ======================================
-- Bổ sung Reservations
-- ======================================
INSERT INTO Reservations ([UserAccountID], PointId, StartTime, EndTime, CreatedAt, UpdatedAt, Status)
VALUES
(1, 1, DATEADD(HOUR,-1,GETDATE()), GETDATE(), GETDATE(), GETDATE(), 1),
(2, 2, DATEADD(HOUR,-2,GETDATE()), DATEADD(HOUR,-1,GETDATE()), GETDATE(), GETDATE(), 0),
(3, 3, DATEADD(HOUR,-3,GETDATE()), DATEADD(HOUR,-2,GETDATE()), GETDATE(), GETDATE(), 1);

-- ======================================
-- Bổ sung IssueReports
-- ======================================
INSERT INTO IssueReports (PointId, ReportedByStaffId, Description, CreatedAt, ResolvedAt, Status)
VALUES
(1, 1, 'Connector cable damaged', DATEADD(DAY,-10,GETDATE()), DATEADD(DAY,-9,GETDATE()), 1),
(2, 1, 'Slow charging issue', DATEADD(DAY,-5,GETDATE()), NULL, 0),
(3, 1, 'Payment terminal malfunction', DATEADD(DAY,-3,GETDATE()), NULL, 0);

-- ======================================
-- Bổ sung thêm Staff
-- ======================================
INSERT INTO Staff (CreatedByAdminId, FirstName, LastName, Email, StartDate, CreatedAt, UpdatedAt, Status)
VALUES
(1, 'Tran', 'Thi B', 'staff2@email.com', DATEADD(DAY,-100,GETDATE()), GETDATE(), GETDATE(), 1),
(1, 'Le', 'Van C', 'staff3@email.com', DATEADD(DAY,-200,GETDATE()), GETDATE(), GETDATE(), 1);

-- ======================================
-- Bổ sung thêm ChargingStations
-- ======================================
INSERT INTO ChargingStations (StationName, NumberOfPoints, Address, PricePerKwh, OperatedByStaffId, AssignedByAdminId, OpeningHours, ClosingHours, CreatedAt, UpdatedAt, Status)
VALUES
('Station 2', 8, '456 Second St', 5500, 2, 1, '07:00', '21:00', GETDATE(), GETDATE(), 1),
('Station 3', 12, '789 Third St', 6000, 3, 1, '08:00', '23:00', GETDATE(), GETDATE(), 1);

-- ======================================
-- Bổ sung thêm ChargingPoints
-- ======================================
INSERT INTO ChargingPoints (StationId, PointName, ConnectorType, InstalledDate, CreatedAt, UpdatedAt, Status)
VALUES
(2, 'Point B1', 'Type2', GETDATE(), GETDATE(), GETDATE(), 1),
(2, 'Point B2', 'CCS', GETDATE(), GETDATE(), GETDATE(), 1),
(3, 'Point C1', 'CHAdeMO', GETDATE(), GETDATE(), GETDATE(), 1),
(3, 'Point C2', 'Type2', GETDATE(), GETDATE(), GETDATE(), 1);

-- ======================================
-- Bổ sung thêm ChargingSessions
-- ======================================
INSERT INTO ChargingSessions (PointId, EnergyConsumedKwh, VehicleId, StartTime, EndTime, IsFullyCharged, Status, CreatedAt, UpdatedAt)
VALUES
(4, 15.0, 4, DATEADD(HOUR,-2,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE()),
(5, 22.0, 5, DATEADD(HOUR,-1,GETDATE()), GETDATE(), 0, 1, GETDATE(), GETDATE());

-- ======================================
-- Bổ sung thêm TransactionsDucPV
-- ======================================
INSERT INTO TransactionsDucPV (SessionId, UserAccountID, Amount, MethodDucPVId, Description, TransactionDate, Status, CreatedAt, UpdatedAt)
VALUES
(4, 4, 150.00, 2, N'Payment for session 4 by user 4 (Credit Card)', GETDATE(), 1, GETDATE(), GETDATE()),
(5, 5, 210.00, 3, N'Payment for session 5 by user 5 (E-Wallet)', GETDATE(), 1, GETDATE(), GETDATE());

-- ======================================
-- Bổ sung thêm Invoices
-- ======================================
INSERT INTO Invoices (TransactionTransactionsDucPVId, InvoiceData, IssuedDate, Status, CreatedAt, UpdatedAt)
VALUES
(4, 'Invoice for session 4, amount 150.00', GETDATE(), 1, GETDATE(), GETDATE()),
(5, 'Invoice for session 5, amount 210.00', GETDATE(), 1, GETDATE(), GETDATE());
GO

INSERT INTO TransactionsDucPV 
(SessionId, UserAccountID, Amount, MethodDucPVId, Description, TransactionDate, Status, CreatedAt, UpdatedAt)
VALUES
(1, 2, 130.50, 1, N'Payment for session 1 by user 2 (Cash)', GETDATE(), 1, GETDATE(), GETDATE()),
(2, 3, 210.00, 2, N'Payment for session 2 by user 3 (Credit Card)', GETDATE(), 1, GETDATE(), GETDATE()),
(3, 4, 180.75, 3, N'Payment for session 3 by user 4 (E-Wallet)', GETDATE(), 1, GETDATE(), GETDATE()),
(4, 5, 155.25, 1, N'Payment for session 4 by user 5 (Cash)', GETDATE(), 1, GETDATE(), GETDATE()),
(5, 1, 199.99, 2, N'Payment for session 5 by user 1 (Credit Card)', GETDATE(), 1, GETDATE(), GETDATE());


-- ===============================
-- 1. Bổ sung Admin
-- ===============================
INSERT INTO Admin (ContactEmail, ContactPhone, FirstName, LastName, CreatedAt, UpdatedAt, Status)
VALUES
('support1@evcms.com', '0906666666', 'Linh', 'Nguyen', GETDATE(), GETDATE(), 1),
('support2@evcms.com', '0907777777', 'Hai', 'Tran', GETDATE(), GETDATE(), 1);

-- ===============================
-- 2. Bổ sung Roles (nếu chưa đủ)
-- ===============================
IF NOT EXISTS (SELECT * FROM Roles WHERE RoleName = N'Manager')
    INSERT INTO Roles (RoleName) VALUES (N'Manager');

-- ===============================
-- 3. Bổ sung UserAccount (5 user mới)
-- ===============================
INSERT INTO UserAccount (UserName, Password, FullName, Email, Phone, EmployeeCode, RoleId, CreatedDate, IsActive)
VALUES
('user6', '123456', N'Pham Van F', 'user6@email.com', '0906666666', 'EMP006', 3, GETDATE(), 1),
('user7', '123456', N'Nguyen Thi G', 'user7@email.com', '0907777777', 'EMP007', 3, GETDATE(), 1),
('user8', '123456', N'Tran Van H', 'user8@email.com', '0908888888', 'EMP008', 2, GETDATE(), 1),
('user9', '123456', N'Le Thi I', 'user9@email.com', '0909999999', 'EMP009', 2, GETDATE(), 1),
('user10', '123456', N'Bui Van J', 'user10@email.com', '0910000000', 'EMP010', 3, GETDATE(), 1);

-- ===============================
-- 4. Bổ sung Staff
-- ===============================
INSERT INTO Staff (CreatedByAdminId, FirstName, LastName, Email, StartDate, EndDate, CreatedAt, UpdatedAt, Status)
VALUES
(1, 'Pham', 'Tuan', 'staff4@email.com', DATEADD(DAY,-120,GETDATE()), NULL, GETDATE(), GETDATE(), 1),
(2, 'Nguyen', 'Ha', 'staff5@email.com', DATEADD(DAY,-60,GETDATE()), NULL, GETDATE(), GETDATE(), 1);

-- ===============================
-- 5. Bổ sung SubscriptionTypes
-- ===============================
INSERT INTO SubscriptionTypes (TypeName, Description, CreatedAt, UpdatedAt)
VALUES
('Enterprise', 'Enterprise subscription plan', GETDATE(), GETDATE()),
('Trial', 'Trial subscription (7 days)', GETDATE(), GETDATE());

-- ===============================
-- 6. Bổ sung Subscription
-- ===============================
INSERT INTO Subscription (PlanName, PlanCode, Description, Price, TypeId, DiscountRate, CreatedByAdminId, CreatedAt, UpdatedAt, Status)
VALUES
('Enterprise Plan', 'ENT01', 'Enterprise level plan', 500000, 3, 15, 1, GETDATE(), GETDATE(), 1),
('Trial Plan', 'TRI01', '7-day trial', 0, 4, 0, 2, GETDATE(), GETDATE(), 1);

-- ===============================
-- 7. Bổ sung Vehicles
-- ===============================
INSERT INTO Vehicles ([UserAccountID], LicensePlate, VehicleModel, ConnectorType, Status, CreatedAt, UpdatedAt)
VALUES
(6, '51A-66666', 'VinFast VF8', 'Type2', 1, GETDATE(), GETDATE()),
(7, '51A-77777', 'Porsche Taycan', 'CCS', 1, GETDATE(), GETDATE()),
(8, '51A-88888', 'Audi e-tron', 'CHAdeMO', 1, GETDATE(), GETDATE()),
(9, '51A-99999', 'BYD Seal', 'Type2', 1, GETDATE(), GETDATE()),
(10, '51A-10101', 'MG4 EV', 'CCS', 1, GETDATE(), GETDATE());

-- ===============================
-- 8. Bổ sung ChargingStations
-- ===============================
INSERT INTO ChargingStations (StationName, NumberOfPoints, Address, PricePerKwh, OperatedByStaffId, AssignedByAdminId, OpeningHours, ClosingHours, CreatedAt, UpdatedAt, Status)
VALUES
('Station 4', 6, '123 Nguyen Van Linh', 5200, 4, 2, '06:00', '22:00', GETDATE(), GETDATE(), 1),
('Station 5', 9, '456 Le Loi St', 6000, 5, 2, '07:00', '23:00', GETDATE(), GETDATE(), 1);

-- ===============================
-- 9. Bổ sung ChargingPoints
-- ===============================
INSERT INTO ChargingPoints (StationId, PointName, ConnectorType, InstalledDate, CreatedAt, UpdatedAt, Status)
VALUES
(4, 'Point D1', 'Type2', GETDATE(), GETDATE(), GETDATE(), 1),
(4, 'Point D2', 'CCS', GETDATE(), GETDATE(), GETDATE(), 1),
(5, 'Point E1', 'CHAdeMO', GETDATE(), GETDATE(), GETDATE(), 1),
(5, 'Point E2', 'Type2', GETDATE(), GETDATE(), GETDATE(), 1);

-- ===============================
-- 10. Bổ sung ChargingSessions
-- ===============================
INSERT INTO ChargingSessions (PointId, EnergyConsumedKwh, VehicleId, StartTime, EndTime, IsFullyCharged, Status, CreatedAt, UpdatedAt)
VALUES
(6, 18.5, 6, DATEADD(HOUR,-2,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE()),
(7, 25.0, 7, DATEADD(HOUR,-1,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE()),
(8, 33.0, 8, DATEADD(HOUR,-3,GETDATE()), GETDATE(), 0, 1, GETDATE(), GETDATE()),
(9, 45.5, 9, DATEADD(HOUR,-4,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE()),
(10, 27.0, 10, DATEADD(HOUR,-2,GETDATE()), GETDATE(), 1, 1, GETDATE(), GETDATE());

-- ===============================
-- 11. Bổ sung PaymentMethodsDucPV
-- ===============================
INSERT INTO PaymentMethodsDucPV (MethodType, Status, CreatedAt, UpdatedAt)
VALUES
('Bank Transfer', 1, GETDATE(), GETDATE()),
('Crypto', 1, GETDATE(), GETDATE());

-- ===============================
-- 12. Bổ sung TransactionsDucPV (đảm bảo ≥10 dòng)
-- ===============================
INSERT INTO TransactionsDucPV (SessionId, UserAccountID, Amount, MethodDucPVId, Description, TransactionDate, Status, CreatedAt, UpdatedAt)
VALUES
(6, 6, 175.00, 1, N'Payment for session 6 by user 6 (Bank Transfer)', GETDATE(), 1, GETDATE(), GETDATE()),
(7, 7, 250.00, 2, N'Payment for session 7 by user 7 (Crypto)', GETDATE(), 1, GETDATE(), GETDATE()),
(8, 8, 300.00, 1, N'Payment for session 8 by user 8 (Bank Transfer)', GETDATE(), 1, GETDATE(), GETDATE()),
(9, 9, 280.50, 2, N'Payment for session 9 by user 9 (Crypto)', GETDATE(), 1, GETDATE(), GETDATE()),
(10, 10, 195.75, 1, N'Payment for session 10 by user 10 (Bank Transfer)', GETDATE(), 1, GETDATE(), GETDATE());

-- ===============================
-- 13. Bổ sung Invoices
-- ===============================
INSERT INTO Invoices (TransactionTransactionsDucPVId, InvoiceData, IssuedDate, Status, CreatedAt, UpdatedAt)
VALUES
(6, 'Invoice for session 6, amount 175.00', GETDATE(), 1, GETDATE(), GETDATE()),
(7, 'Invoice for session 7, amount 250.00', GETDATE(), 1, GETDATE(), GETDATE()),
(8, 'Invoice for session 8, amount 300.00', GETDATE(), 1, GETDATE(), GETDATE()),
(9, 'Invoice for session 9, amount 280.50', GETDATE(), 1, GETDATE(), GETDATE()),
(10, 'Invoice for session 10, amount 195.75', GETDATE(), 1, GETDATE(), GETDATE());

-- ===============================
-- 14. Bổ sung Notifications
-- ===============================
INSERT INTO Notifications ([UserAccountID], Title, Body, CreatedAt, UpdatedAt, Status)
VALUES
(6, 'Welcome', 'Welcome Pham Van F to EVCMS!', GETDATE(), GETDATE(), 1),
(7, 'Charging Complete', 'Your charging session has completed.', GETDATE(), GETDATE(), 1),
(8, 'Invoice Issued', 'Your invoice has been issued successfully.', GETDATE(), GETDATE(), 1);

-- ===============================
-- 15. Bổ sung UserSubscriptions
-- ===============================
INSERT INTO UserSubscriptions ([UserAccountID], SubscriptionId, StartDate, EndDate, CreatedAt, UpdatedAt, Status)
VALUES
(6, 3, DATEADD(DAY,-10,GETDATE()), DATEADD(DAY,50,GETDATE()), GETDATE(), GETDATE(), 1),
(7, 4, DATEADD(DAY,-5,GETDATE()), DATEADD(DAY,5,GETDATE()), GETDATE(), GETDATE(), 1);

-- ===============================
-- 16. Bổ sung Reservations
-- ===============================
INSERT INTO Reservations ([UserAccountID], PointId, StartTime, EndTime, CreatedAt, UpdatedAt, Status)
VALUES
(6, 6, DATEADD(HOUR,-2,GETDATE()), GETDATE(), GETDATE(), GETDATE(), 1),
(7, 7, DATEADD(HOUR,-1,GETDATE()), GETDATE(), GETDATE(), GETDATE(), 1);

-- ===============================
-- 17. Bổ sung IssueReports
-- ===============================
INSERT INTO IssueReports (PointId, ReportedByStaffId, Description, CreatedAt, ResolvedAt, Status)
VALUES
(6, 4, 'Loose connector detected', DATEADD(DAY,-4,GETDATE()), NULL, 0),
(7, 5, 'Overheating detected', DATEADD(DAY,-2,GETDATE()), DATEADD(DAY,-1,GETDATE()), 1);
GO