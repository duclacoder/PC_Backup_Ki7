#nullable disable
using System;
using System.Collections.Generic;
using EVCMS.Repositories.DucPV.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace EVCMS.Repositories.DucPV.DBContext;

public partial class FA25_PRN222_SE1834_G2_EVCMSContext : DbContext
{ 
    public FA25_PRN222_SE1834_G2_EVCMSContext()
    {
    }

    public FA25_PRN222_SE1834_G2_EVCMSContext(DbContextOptions<FA25_PRN222_SE1834_G2_EVCMSContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Admin> Admins { get; set; }

    public virtual DbSet<ChargingPoint> ChargingPoints { get; set; }

    public virtual DbSet<ChargingSession> ChargingSessions { get; set; }

    public virtual DbSet<ChargingStation> ChargingStations { get; set; }

    public virtual DbSet<Invoice> Invoices { get; set; }

    public virtual DbSet<IssueReport> IssueReports { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<PaymentMethodsDucPv> PaymentMethodsDucPvs { get; set; }

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Staff> Staff { get; set; }

    public virtual DbSet<Subscription> Subscriptions { get; set; }

    public virtual DbSet<SubscriptionType> SubscriptionTypes { get; set; }

    public virtual DbSet<TransactionsDucPv> TransactionsDucPvs { get; set; }

    public virtual DbSet<UserAccount> UserAccounts { get; set; }

    public virtual DbSet<UserSubscription> UserSubscriptions { get; set; }

    public virtual DbSet<Vehicle> Vehicles { get; set; }

    public static string GetConnectionString(string connectionStringName)
    {
        var config = new ConfigurationBuilder()
            .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
            .AddJsonFile("appsettings.json")
            .Build();

        string connectionString = config.GetConnectionString(connectionStringName);
        return connectionString;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer(GetConnectionString("DefaultConnection")).UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);

    //    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
    //        => optionsBuilder.UseSqlServer("Data Source=localhost;Initial Catalog=FA25_PRN222_SE1834_G2_EVCMS;Persist Security Info=True;User ID=sa;Password=12345;Encrypt=False");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admin>(entity =>
        {
            entity.HasKey(e => e.AdminId).HasName("PK__Admin__719FE488BEC7D59F");

            entity.ToTable("Admin");

            entity.Property(e => e.ContactEmail)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.ContactPhone)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<ChargingPoint>(entity =>
        {
            entity.HasKey(e => e.PointId).HasName("PK__Charging__40A977E1647283B9");

            entity.Property(e => e.ConnectorType)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.PointName)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.Station).WithMany(p => p.ChargingPoints)
                .HasForeignKey(d => d.StationId)
                .HasConstraintName("FkChargingPointsStation");
        });

        modelBuilder.Entity<ChargingSession>(entity =>
        {
            entity.HasKey(e => e.SessionId).HasName("PK__Charging__C9F49290E34CC25B");

            entity.Property(e => e.EnergyConsumedKwh).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Point).WithMany(p => p.ChargingSessions)
                .HasForeignKey(d => d.PointId)
                .HasConstraintName("FkSessionsPoint");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.ChargingSessions)
                .HasForeignKey(d => d.VehicleId)
                .HasConstraintName("FkSessionsVehicle");
        });

        modelBuilder.Entity<ChargingStation>(entity =>
        {
            entity.HasKey(e => e.StationId).HasName("PK__Charging__E0D8A6BDB1DE13DC");

            entity.Property(e => e.Address).HasColumnType("text");
            entity.Property(e => e.PricePerKwh).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.StationName)
                .HasMaxLength(255)
                .IsUnicode(false);

            entity.HasOne(d => d.AssignedByAdmin).WithMany(p => p.ChargingStations)
                .HasForeignKey(d => d.AssignedByAdminId)
                .HasConstraintName("FkChargingStationsAdmin");

            entity.HasOne(d => d.OperatedByStaff).WithMany(p => p.ChargingStations)
                .HasForeignKey(d => d.OperatedByStaffId)
                .HasConstraintName("FkChargingStationsStaff");
        });

        modelBuilder.Entity<Invoice>(entity =>
        {
            entity.HasKey(e => e.InvoiceId).HasName("PK__Invoices__D796AAB5AD7E9A4A");

            entity.Property(e => e.InvoiceData).HasColumnType("text");
            entity.Property(e => e.IssuedDate).HasColumnType("datetime");
            entity.Property(e => e.TransactionTransactionsDucPvid).HasColumnName("TransactionTransactionsDucPVId");

            entity.HasOne(d => d.TransactionTransactionsDucPv).WithMany(p => p.Invoices)
                .HasForeignKey(d => d.TransactionTransactionsDucPvid)
                .HasConstraintName("FkInvoicesTransaction");
        });

        modelBuilder.Entity<IssueReport>(entity =>
        {
            entity.HasKey(e => e.ReportId).HasName("PK__IssueRep__D5BD480501001344");

            entity.Property(e => e.Description).HasColumnType("text");

            entity.HasOne(d => d.Point).WithMany(p => p.IssueReports)
                .HasForeignKey(d => d.PointId)
                .HasConstraintName("FkIssueReportsPoint");

            entity.HasOne(d => d.ReportedByStaff).WithMany(p => p.IssueReports)
                .HasForeignKey(d => d.ReportedByStaffId)
                .HasConstraintName("FkIssueReportsStaff");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.NotificationId).HasName("PK__Notifica__20CF2E32270C99EF");

            entity.Property(e => e.NotificationId).HasColumnName("NotificationID");
            entity.Property(e => e.Body).HasColumnType("text");
            entity.Property(e => e.Title)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.UserAccountId).HasColumnName("UserAccountID");

            entity.HasOne(d => d.UserAccount).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.UserAccountId)
                .HasConstraintName("FkNotificationsDriver");
        });

        modelBuilder.Entity<PaymentMethodsDucPv>(entity =>
        {
            entity.HasKey(e => e.MethodDucPvid).HasName("PK__PaymentM__C7614BD998238E7F");

            entity.ToTable("PaymentMethodsDucPV");

            entity.Property(e => e.MethodDucPvid).HasColumnName("MethodDucPVId");
            entity.Property(e => e.MethodType)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.ReservationId).HasName("PK__Reservat__B7EE5F24019DD8A6");

            entity.Property(e => e.UserAccountId).HasColumnName("UserAccountID");

            entity.HasOne(d => d.Point).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.PointId)
                .HasConstraintName("FkReservationsPoint");

            entity.HasOne(d => d.UserAccount).WithMany(p => p.Reservations)
                .HasForeignKey(d => d.UserAccountId)
                .HasConstraintName("FkReservationsDriver");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__8AFACE1ADAC1A4AB");

            entity.Property(e => e.RoleName)
                .IsRequired()
                .HasMaxLength(100);
        });

        modelBuilder.Entity<Staff>(entity =>
        {
            entity.HasKey(e => e.StaffId).HasName("PK__Staff__96D4AB172D15B30C");

            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.CreatedByAdmin).WithMany(p => p.Staff)
                .HasForeignKey(d => d.CreatedByAdminId)
                .HasConstraintName("FkStaffAdmin");
        });

        modelBuilder.Entity<Subscription>(entity =>
        {
            entity.HasKey(e => e.SubscriptionId).HasName("PK__Subscrip__9A2B249D3C39B00C");

            entity.ToTable("Subscription");

            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.DiscountRate).HasColumnType("decimal(5, 2)");
            entity.Property(e => e.PlanCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.PlanName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.CreatedByAdmin).WithMany(p => p.Subscriptions)
                .HasForeignKey(d => d.CreatedByAdminId)
                .HasConstraintName("FkSubscriptionPlansAdmin");

            entity.HasOne(d => d.Type).WithMany(p => p.Subscriptions)
                .HasForeignKey(d => d.TypeId)
                .HasConstraintName("FkSubscriptionPlansType");
        });

        modelBuilder.Entity<SubscriptionType>(entity =>
        {
            entity.HasKey(e => e.TypeId).HasName("PK__Subscrip__516F03B5438898E1");

            entity.HasIndex(e => e.TypeName, "UQ__Subscrip__D4E7DFA893709E7C").IsUnique();

            entity.Property(e => e.Description).HasColumnType("text");
            entity.Property(e => e.TypeName)
                .IsRequired()
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TransactionsDucPv>(entity =>
        {
            entity.HasKey(e => e.TransactionTransactionsDucPvid).HasName("PK__Transact__D637E8C12D668172");

            entity.ToTable("TransactionsDucPV");

            entity.Property(e => e.TransactionTransactionsDucPvid).HasColumnName("TransactionTransactionsDucPVId");
            entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.MethodDucPvid).HasColumnName("MethodDucPVId");
            entity.Property(e => e.UserAccountId).HasColumnName("UserAccountID");

            entity.HasOne(d => d.MethodDucPv).WithMany(p => p.TransactionsDucPvs)
                .HasForeignKey(d => d.MethodDucPvid)
                .HasConstraintName("FkTransactionsMethod");

            entity.HasOne(d => d.Session).WithMany(p => p.TransactionsDucPvs)
                .HasForeignKey(d => d.SessionId)
                .HasConstraintName("FkTransactionsSession");

            entity.HasOne(d => d.UserAccount).WithMany(p => p.TransactionsDucPvs)
                .HasForeignKey(d => d.UserAccountId)
                .HasConstraintName("FkTransactionsDriver");
        });

        modelBuilder.Entity<UserAccount>(entity =>
        {
            entity.HasKey(e => e.UserAccountId).HasName("PK_System.UserAccount");

            entity.ToTable("UserAccount");

            entity.Property(e => e.UserAccountId).HasColumnName("UserAccountID");
            entity.Property(e => e.ApplicationCode).HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.EmployeeCode)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.FullName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.ModifiedBy).HasMaxLength(50);
            entity.Property(e => e.ModifiedDate).HasColumnType("datetime");
            entity.Property(e => e.Password)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Phone)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.RequestCode).HasMaxLength(50);
            entity.Property(e => e.UserName)
                .IsRequired()
                .HasMaxLength(50);
        });

        modelBuilder.Entity<UserSubscription>(entity =>
        {
            entity.HasKey(e => e.UserSubscriptionId).HasName("PK__UserSubs__D1FD777C3F755738");

            entity.Property(e => e.UserAccountId).HasColumnName("UserAccountID");

            entity.HasOne(d => d.Subscription).WithMany(p => p.UserSubscriptions)
                .HasForeignKey(d => d.SubscriptionId)
                .HasConstraintName("FkUserSubscriptionsPlan");

            entity.HasOne(d => d.UserAccount).WithMany(p => p.UserSubscriptions)
                .HasForeignKey(d => d.UserAccountId)
                .HasConstraintName("FkUserSubscriptionsDriver");
        });

        modelBuilder.Entity<Vehicle>(entity =>
        {
            entity.HasKey(e => e.VehicleId).HasName("PK__Vehicles__476B54929652247F");

            entity.Property(e => e.ConnectorType)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LicensePlate)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.UserAccountId).HasColumnName("UserAccountID");
            entity.Property(e => e.VehicleModel)
                .HasMaxLength(100)
                .IsUnicode(false);

            entity.HasOne(d => d.UserAccount).WithMany(p => p.Vehicles)
                .HasForeignKey(d => d.UserAccountId)
                .HasConstraintName("FkVehiclesDriver");
        });         
        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}