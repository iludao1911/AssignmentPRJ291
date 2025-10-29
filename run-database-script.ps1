# =====================================================
# Script: Chạy SQL Script để xóa và tạo lại Database
# File: run-database-script.ps1
# =====================================================

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  XÓA VÀ TẠO LẠI DATABASE PROJECT" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Đường dẫn đến file SQL
$sqlFilePath = "d:\Ky8\PRJ\AssignmentPRJ291\SQLProject.sql"

# Kiểm tra file SQL có tồn tại không
if (-not (Test-Path $sqlFilePath)) {
    Write-Host "❌ Lỗi: Không tìm thấy file SQL tại: $sqlFilePath" -ForegroundColor Red
    exit
}

Write-Host "✅ Đã tìm thấy file SQL: $sqlFilePath" -ForegroundColor Green
Write-Host ""

# Thông tin kết nối SQL Server
$serverName = "localhost"  # Thay đổi nếu server khác
$username = "sa"           # Thay đổi username nếu cần
$password = "123456"       # Thay đổi password nếu cần

Write-Host "📊 Thông tin kết nối:" -ForegroundColor Yellow
Write-Host "   Server: $serverName"
Write-Host "   User: $username"
Write-Host ""

# Xác nhận trước khi chạy
Write-Host "⚠️  CẢNH BÁO: Script này sẽ XÓA HOÀN TOÀN database 'Project' và tạo lại!" -ForegroundColor Red
$confirmation = Read-Host "Bạn có chắc chắn muốn tiếp tục? (Y/N)"

if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "❌ Đã hủy thực thi." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "🚀 Đang chạy script SQL..." -ForegroundColor Green
Write-Host ""

try {
    # Chạy script SQL bằng sqlcmd
    sqlcmd -S $serverName -U $username -P $password -i $sqlFilePath -b
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host "  ✅ THÀNH CÔNG!" -ForegroundColor Green
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Database 'Project' đã được tạo lại thành công!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📝 Thông tin đăng nhập:" -ForegroundColor Cyan
        Write-Host "   🔑 Admin:" -ForegroundColor Yellow
        Write-Host "      Email: admin@email.com"
        Write-Host "      Password: admin123"
        Write-Host ""
        Write-Host "   👤 Customer:" -ForegroundColor Yellow
        Write-Host "      Email: nguyenvana@email.com"
        Write-Host "      Password: 123456"
        Write-Host ""
    } else {
        Write-Host "❌ Có lỗi xảy ra khi chạy script SQL!" -ForegroundColor Red
        Write-Host "Vui lòng kiểm tra lại:" -ForegroundColor Yellow
        Write-Host "  1. Thông tin đăng nhập SQL Server"
        Write-Host "  2. SQL Server có đang chạy không"
        Write-Host "  3. Quyền truy cập của user"
    }
} catch {
    Write-Host "❌ Lỗi: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Nhấn Enter để thoát..."
Read-Host
