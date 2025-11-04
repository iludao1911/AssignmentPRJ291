<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Custom Confirm Modal -->
<style>
    #confirmModal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 99999;
        justify-content: center;
        align-items: center;
        animation: fadeIn 0.2s ease;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    #confirmModal.show {
        display: flex;
    }
    
    .confirm-content {
        background: white;
        border-radius: 16px;
        padding: 0;
        max-width: 400px;
        width: 90%;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        animation: slideUp 0.3s ease;
        overflow: hidden;
    }
    
    @keyframes slideUp {
        from {
            transform: translateY(50px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }
    
    .confirm-header {
        padding: 24px;
        text-align: center;
        border-bottom: 1px solid #e5e7eb;
    }
    
    .confirm-icon {
        width: 60px;
        height: 60px;
        margin: 0 auto 16px;
        background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
    }
    
    .confirm-title {
        font-size: 20px;
        font-weight: 700;
        color: #1f2937;
        margin: 0;
    }
    
    .confirm-body {
        padding: 24px;
        text-align: center;
    }
    
    .confirm-message {
        font-size: 15px;
        color: #6b7280;
        line-height: 1.6;
        margin: 0;
    }
    
    .confirm-actions {
        display: flex;
        gap: 12px;
        padding: 20px 24px 24px;
    }
    
    .confirm-modal-btn {
        flex: 1;
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .confirm-btn-cancel {
        background: #f3f4f6;
        color: #6b7280;
    }
    
    .confirm-btn-cancel:hover {
        background: #e5e7eb;
    }
    
    .confirm-btn-confirm {
        background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
        color: white;
        box-shadow: 0 4px 12px rgba(20, 184, 166, 0.4);
    }
    
    .confirm-btn-confirm:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(20, 184, 166, 0.5);
    }
    
    .confirm-btn-confirm:active {
        transform: translateY(0);
    }
</style>

<div id="confirmModal">
    <div class="confirm-content">
        <div class="confirm-header">
            <div class="confirm-icon">❓</div>
            <h3 class="confirm-title" id="confirmTitle">Xác nhận</h3>
        </div>
        <div class="confirm-body">
            <p class="confirm-message" id="confirmMessage">Bạn có chắc chắn muốn thực hiện hành động này?</p>
        </div>
        <div class="confirm-actions">
            <button class="confirm-modal-btn confirm-btn-cancel" onclick="closeConfirm(false)">Hủy</button>
            <button class="confirm-modal-btn confirm-btn-confirm" onclick="closeConfirm(true)">Xác nhận</button>
        </div>
    </div>
</div>

<script>
    (function() {
        if (window.showConfirm) return; // Already loaded
        
        var confirmCallback = null;
        
        window.showConfirm = function(message, title, onConfirm) {
            title = title || 'Xác nhận';
            confirmCallback = onConfirm;
            
            document.getElementById('confirmTitle').textContent = title;
            document.getElementById('confirmMessage').textContent = message;
            document.getElementById('confirmModal').classList.add('show');
        };
        
        window.closeConfirm = function(result) {
            document.getElementById('confirmModal').classList.remove('show');
            if (confirmCallback) {
                confirmCallback(result);
                confirmCallback = null;
            }
        };
        
        // Close on backdrop click
        document.getElementById('confirmModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeConfirm(false);
            }
        });
        
        // ESC key to close
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && document.getElementById('confirmModal').classList.contains('show')) {
                closeConfirm(false);
            }
        });
    })();
</script>
