<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- AI Chatbot Widget -->
<style>
    .chatbot-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 9999;
    }

    .chatbot-button {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
        border: none;
        box-shadow: 0 4px 12px rgba(8, 145, 178, 0.4);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.8rem;
        transition: all 0.3s;
    }

    .chatbot-button:hover {
        transform: scale(1.1);
        box-shadow: 0 6px 20px rgba(8, 145, 178, 0.6);
    }

    .chatbot-button.active {
        background: #0d9488;
    }

    .chatbot-window {
        position: fixed;
        bottom: 90px;
        right: 20px;
        width: 380px;
        height: 550px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        display: none;
        flex-direction: column;
        overflow: hidden;
        animation: slideUp 0.3s ease-out;
    }

    .chatbot-window.show {
        display: flex;
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .chatbot-header {
        background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
        color: white;
        padding: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .chatbot-header-left {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .chatbot-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: white;
        color: #0891b2;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
    }

    .chatbot-header-text h3 {
        margin: 0;
        font-size: 1.1rem;
        font-weight: 600;
    }

    .chatbot-header-text p {
        margin: 0;
        font-size: 0.85rem;
        opacity: 0.9;
    }

    .chatbot-close {
        background: none;
        border: none;
        color: white;
        font-size: 1.5rem;
        cursor: pointer;
        padding: 5px;
        opacity: 0.8;
        transition: opacity 0.3s;
    }

    .chatbot-close:hover {
        opacity: 1;
    }

    .chatbot-messages {
        flex: 1;
        overflow-y: auto;
        padding: 20px;
        background: #f8f9fa;
    }

    .chatbot-message {
        margin-bottom: 15px;
        display: flex;
        gap: 10px;
        animation: fadeIn 0.3s ease-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .chatbot-message.user {
        flex-direction: row-reverse;
    }

    .message-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
        flex-shrink: 0;
    }

    .message-avatar.bot {
        background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
        color: white;
    }

    .message-avatar.user {
        background: #e0e0e0;
        color: #666;
    }

    .message-content {
        max-width: 75%;
        padding: 12px 16px;
        border-radius: 18px;
        line-height: 1.5;
        font-size: 0.95rem;
    }

    .message-content a {
        color: inherit;
        text-decoration: underline;
        font-weight: 600;
    }

    .chatbot-message.bot .message-content a {
        color: #0891b2;
    }

    .chatbot-message.user .message-content a {
        color: white;
    }

    /* Out of stock warning */
    .message-content .out-of-stock-warning {
        color: #dc3545;
        font-weight: 500;
        display: block;
        margin-top: 4px;
    }

    .chatbot-message.bot .message-content {
        background: white;
        color: #333;
        border-bottom-left-radius: 4px;
    }

    .chatbot-message.user .message-content {
        background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
        color: white;
        border-bottom-right-radius: 4px;
    }

    .chatbot-typing {
        display: none;
        align-items: center;
        gap: 10px;
        margin-bottom: 15px;
    }

    .chatbot-typing.show {
        display: flex;
    }

    .typing-dots {
        display: flex;
        gap: 4px;
        padding: 12px 16px;
        background: white;
        border-radius: 18px;
        border-bottom-left-radius: 4px;
    }

    .typing-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #0891b2;
        animation: typing 1.4s infinite;
    }

    .typing-dot:nth-child(2) {
        animation-delay: 0.2s;
    }

    .typing-dot:nth-child(3) {
        animation-delay: 0.4s;
    }

    @keyframes typing {
        0%, 60%, 100% {
            transform: translateY(0);
            opacity: 0.7;
        }
        30% {
            transform: translateY(-10px);
            opacity: 1;
        }
    }

    .chatbot-input-area {
        padding: 15px 20px;
        border-top: 1px solid #e0e0e0;
        background: white;
    }

    .chatbot-input-container {
        display: flex;
        gap: 10px;
        align-items: center;
    }

    .chatbot-input {
        flex: 1;
        padding: 12px 16px;
        border: 2px solid #e0e0e0;
        border-radius: 25px;
        font-size: 0.95rem;
        outline: none;
        transition: border-color 0.3s;
    }

    .chatbot-input:focus {
        border-color: #0891b2;
    }

    .chatbot-send-btn {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, #0891b2 0%, #0d9488 100%);
        border: none;
        color: white;
        font-size: 1.2rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }

    .chatbot-send-btn:hover {
        transform: scale(1.1);
    }

    .chatbot-send-btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    .quick-questions {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-top: 12px;
        padding: 0;
    }

    .quick-question-btn {
        padding: 8px 14px;
        background: #ecfeff;
        border: 1px solid #0891b2;
        color: #0891b2;
        border-radius: 20px;
        font-size: 0.85rem;
        cursor: pointer;
        transition: all 0.3s;
        white-space: nowrap;
    }

    .quick-question-btn:hover {
        background: #0891b2;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(8, 145, 178, 0.3);
    }

    @media (max-width: 768px) {
        .chatbot-window {
            width: calc(100% - 40px);
            height: calc(100% - 110px);
            bottom: 90px;
            right: 20px;
            left: 20px;
        }
    }
</style>

<!-- Chatbot HTML -->
<div class="chatbot-container">
    <!-- Toggle Button -->
    <button class="chatbot-button" id="chatbotToggle" onclick="toggleChatbot()">
        <i class="fas fa-comments"></i>
    </button>

    <!-- Chat Window -->
    <div class="chatbot-window" id="chatbotWindow">
        <!-- Header -->
        <div class="chatbot-header">
            <div class="chatbot-header-left">
                <div class="chatbot-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="chatbot-header-text">
                    <h3>Trợ lý AI</h3>
                    <p>Nhà Thuốc MS</p>
                </div>
            </div>
            <button class="chatbot-close" onclick="toggleChatbot()">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <!-- Messages Area -->
        <div class="chatbot-messages" id="chatbotMessages">
            <div class="chatbot-message bot">
                <div class="message-avatar bot">
                    <i class="fas fa-robot"></i>
                </div>
                <div>
                    <div class="message-content">
                        Xin chào! Tôi là trợ lý AI của Nhà Thuốc MS. Tôi có thể giúp gì cho bạn hôm nay? 😊
                    </div>
                    <div class="quick-questions">
                        <button class="quick-question-btn" onclick="askQuestion('Giới thiệu về nhà thuốc')">
                            Giới thiệu về nhà thuốc
                        </button>
                        <button class="quick-question-btn" onclick="askQuestion('Thuốc giảm đau có gì?')">
                            Thuốc giảm đau
                        </button>
                        <button class="quick-question-btn" onclick="askQuestion('Giá thuốc kháng sinh')">
                            Giá thuốc
                        </button>
                    </div>
                </div>
            </div>

            <!-- Typing Indicator (moved inside messages for proper scrolling) -->
            <div class="chatbot-typing" id="typingIndicator">
                <div class="message-avatar bot">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="typing-dots">
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                </div>
            </div>
        </div>

        <!-- Input Area -->
        <div class="chatbot-input-area">
            <div class="chatbot-input-container">
                <input type="text" class="chatbot-input" id="chatbotInput"
                       placeholder="Nhập câu hỏi của bạn..."
                       onkeypress="handleKeyPress(event)">
                <button class="chatbot-send-btn" id="chatbotSendBtn" onclick="sendMessage()">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Load chat history and state on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadChatHistory();
        loadChatbotState();
    });

    function loadChatHistory() {
        const history = sessionStorage.getItem('chatHistory');
        if (history) {
            try {
                const messages = JSON.parse(history);
                if (messages && messages.length > 0) {
                    const messagesContainer = document.getElementById('chatbotMessages');

                    // Save typing indicator
                    const typingIndicator = document.getElementById('typingIndicator');
                    const typingHTML = typingIndicator ? typingIndicator.outerHTML : '';

                    // Clear welcome message only if we have history
                    messagesContainer.innerHTML = '';

                    // Restore messages
                    messages.forEach(msg => {
                        addMessageToUI(msg.text, msg.sender, false); // false = don't save again
                    });

                    // Restore typing indicator
                    if (typingHTML) {
                        messagesContainer.insertAdjacentHTML('beforeend', typingHTML);
                    }
                }
            } catch (e) {
                console.error('Error loading chat history:', e);
            }
        }
    }

    function saveChatHistory() {
        const messages = [];
        const messagesContainer = document.getElementById('chatbotMessages');
        messagesContainer.querySelectorAll('.chatbot-message').forEach(msg => {
            const sender = msg.classList.contains('user') ? 'user' : 'bot';
            const content = msg.querySelector('.message-content');
            if (content) {
                const text = content.textContent || content.innerText;
                if (text && text.trim().length > 0) {
                    messages.push({ sender, text });
                }
            }
        });
        sessionStorage.setItem('chatHistory', JSON.stringify(messages));
    }

    function loadChatbotState() {
        const isOpen = sessionStorage.getItem('chatbotOpen') === 'true';
        if (isOpen) {
            const window = document.getElementById('chatbotWindow');
            const button = document.getElementById('chatbotToggle');
            window.classList.add('show');
            button.classList.add('active');
        }
    }

    function saveChatbotState(isOpen) {
        sessionStorage.setItem('chatbotOpen', isOpen);
    }

    function toggleChatbot() {
        const window = document.getElementById('chatbotWindow');
        const button = document.getElementById('chatbotToggle');

        if (window.classList.contains('show')) {
            window.classList.remove('show');
            button.classList.remove('active');
            saveChatbotState(false);
        } else {
            window.classList.add('show');
            button.classList.add('active');
            saveChatbotState(true);
            document.getElementById('chatbotInput').focus();
        }
    }

    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            sendMessage();
        }
    }

    function askQuestion(question) {
        document.getElementById('chatbotInput').value = question;
        sendMessage();
    }

    function sendMessage() {
        const input = document.getElementById('chatbotInput');
        const message = input.value.trim();

        if (!message) return;

        // Disable input
        input.disabled = true;
        document.getElementById('chatbotSendBtn').disabled = true;

        // Add user message
        addMessage(message, 'user');
        input.value = '';

        // Show typing indicator
        document.getElementById('typingIndicator').classList.add('show');

        // Get chat history (exclude current message, get last 10)
        const history = [];
        const allMessages = document.querySelectorAll('.chatbot-message');
        const startIdx = Math.max(0, allMessages.length - 10);

        for (let i = startIdx; i < allMessages.length; i++) {
            const msg = allMessages[i];
            const sender = msg.classList.contains('user') ? 'user' : 'bot';
            const content = msg.querySelector('.message-content');
            if (content) {
                const text = content.textContent || content.innerText;
                history.push({ sender, text });
            }
        }

        // Send to server
        const params = new URLSearchParams();
        params.append('message', message);
        params.append('chatHistory', JSON.stringify(history));

        fetch('chatbot', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
        .then(response => response.json())
        .then(data => {
            // Hide typing indicator
            document.getElementById('typingIndicator').classList.remove('show');

            // Add bot response
            if (data.success) {
                addMessage(data.message, 'bot');
            } else {
                addMessage('Xin lỗi, tôi gặp sự cố. Vui lòng thử lại sau.', 'bot');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('typingIndicator').classList.remove('show');
            addMessage('Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại sau.', 'bot');
        })
        .finally(() => {
            // Re-enable input
            input.disabled = false;
            document.getElementById('chatbotSendBtn').disabled = false;
            input.focus();
        });
    }

    function addMessage(text, sender) {
        addMessageToUI(text, sender, true);
    }

    function addMessageToUI(text, sender, saveHistory = true) {
        const messagesContainer = document.getElementById('chatbotMessages');

        const messageDiv = document.createElement('div');
        messageDiv.className = 'chatbot-message ' + sender;

        const avatarDiv = document.createElement('div');
        avatarDiv.className = 'message-avatar ' + sender;
        avatarDiv.innerHTML = sender === 'bot'
            ? '<i class="fas fa-robot"></i>'
            : '<i class="fas fa-user"></i>';

        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';

        // Parse links and convert to HTML
        if (sender === 'bot') {
            contentDiv.innerHTML = parseLinks(text);
        } else {
            contentDiv.textContent = text;
        }

        messageDiv.appendChild(avatarDiv);
        messageDiv.appendChild(contentDiv);

        messagesContainer.appendChild(messageDiv);

        // Scroll to bottom
        messagesContainer.scrollTop = messagesContainer.scrollHeight;

        // Save to sessionStorage
        if (saveHistory) {
            saveChatHistory();
        }
    }

    function parseLinks(text) {
        // Replace medicine links pattern [Medicine Name](medicine-id)
        text = text.replace(/\[([^\]]+)\]\((\d+)\)/g, '<a href="medicine-detail?id=$2">$1</a>');

        // Parse out of stock warnings (text with ⚠️ emoji)
        text = text.replace(/⚠️([^⚠️]+)/g, '<span class="out-of-stock-warning">⚠️$1</span>');

        // Replace URLs
        text = text.replace(/(https?:\/\/[^\s]+)/g, '<a href="$1" target="_blank">$1</a>');

        return text;
    }
</script>
