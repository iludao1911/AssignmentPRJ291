package controller;

import config.ChatbotConfig;
import dao.MedicineDAO;
import model.Medicine;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chatbot"})
public class ChatbotServlet extends HttpServlet {

    private MedicineDAO medicineDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        medicineDAO = new MedicineDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Map<String, Object> result = new HashMap<>();

        try {
            String userMessage = request.getParameter("message");
            String chatHistoryJson = request.getParameter("chatHistory");

            if (userMessage == null || userMessage.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "Vui lòng nhập câu hỏi");
                out.print(gson.toJson(result));
                return;
            }

            // Lấy context từ database
            String context = buildContext(userMessage);

            // Parse chat history
            List<Map<String, String>> chatHistory = new java.util.ArrayList<>();
            if (chatHistoryJson != null && !chatHistoryJson.trim().isEmpty()) {
                try {
                    com.google.gson.reflect.TypeToken<List<Map<String, String>>> typeToken =
                        new com.google.gson.reflect.TypeToken<List<Map<String, String>>>() {};
                    chatHistory = gson.fromJson(chatHistoryJson, typeToken.getType());
                } catch (Exception e) {
                    System.err.println("Error parsing chat history: " + e.getMessage());
                }
            }

            // Gọi OpenRouter API với chat history
            String aiResponse = callOpenRouterAPI(userMessage, context, chatHistory);

            result.put("success", true);
            result.put("message", aiResponse);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau.");
        }

        out.print(gson.toJson(result));
    }

    private String buildContext(String userMessage) {
        StringBuilder context = new StringBuilder();

        try {
            // Lấy thông tin thuốc nếu câu hỏi liên quan
            if (isAboutMedicines(userMessage)) {
                List<Medicine> medicines = medicineDAO.getAllMedicines();
                context.append("Thông tin thuốc trong hệ thống:\n");
                context.append(ChatbotConfig.CONTEXT_INSTRUCTION);

                int count = 0;
                for (Medicine med : medicines) {
                    if (count >= ChatbotConfig.getMaxMedicines()) break; // Giới hạn thuốc để tránh context quá dài

                    context.append("- ID: ").append(med.getMedicineId())
                           .append(", Tên: ").append(med.getName())
                           .append(", Giá: ").append(String.format("%,d", med.getPrice().longValue())).append("đ")
                           .append(", Tồn kho: ").append(med.getQuantity());

                    if (med.getSalePrice() != null && med.getSalePrice().compareTo(java.math.BigDecimal.ZERO) > 0) {
                        context.append(", Giảm giá: ").append(String.format("%,d", med.getSalePrice().longValue())).append("đ");
                    }

                    if (med.getDescription() != null && !med.getDescription().isEmpty()) {
                        String shortDesc = med.getDescription().length() > 100
                            ? med.getDescription().substring(0, 100) + "..."
                            : med.getDescription();
                        context.append(", Mô tả: ").append(shortDesc);
                    }

                    context.append("\n");
                    count++;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return context.toString();
    }

    private boolean isAboutMedicines(String message) {
        String lowerMessage = message.toLowerCase();
        return lowerMessage.contains("thuốc") || lowerMessage.contains("medicine") ||
               lowerMessage.contains("giá") || lowerMessage.contains("price") ||
               lowerMessage.contains("mua") || lowerMessage.contains("buy") ||
               lowerMessage.contains("có") || lowerMessage.contains("bán");
    }

    private String callOpenRouterAPI(String userMessage, String context, List<Map<String, String>> chatHistory) throws IOException {
        URL url = new URL(ChatbotConfig.getBaseUrl());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + ChatbotConfig.getApiKey());
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // Tạo system prompt
        String systemPrompt = ChatbotConfig.SYSTEM_PROMPT;

        if (!context.isEmpty()) {
            systemPrompt += "Thông tin từ hệ thống:\n" + context;
        }

        // Tạo request body
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", ChatbotConfig.getModel());

        JsonArray messages = new JsonArray();

        JsonObject systemMessage = new JsonObject();
        systemMessage.addProperty("role", "system");
        systemMessage.addProperty("content", systemPrompt);
        messages.add(systemMessage);

        // Add chat history (last 10 messages to avoid context overflow)
        int startIndex = Math.max(0, chatHistory.size() - 10);
        for (int i = startIndex; i < chatHistory.size(); i++) {
            Map<String, String> msg = chatHistory.get(i);
            String sender = msg.get("sender");
            String text = msg.get("text");

            JsonObject historyMsg = new JsonObject();
            historyMsg.addProperty("role", "bot".equals(sender) ? "assistant" : "user");
            historyMsg.addProperty("content", text);
            messages.add(historyMsg);
        }

        // Add current user message
        JsonObject userMessageObj = new JsonObject();
        userMessageObj.addProperty("role", "user");
        userMessageObj.addProperty("content", userMessage);
        messages.add(userMessageObj);

        requestBody.add("messages", messages);
        requestBody.addProperty("temperature", ChatbotConfig.getTemperature());
        requestBody.addProperty("max_tokens", ChatbotConfig.getMaxTokens());

        // Gửi request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Đọc response
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                StringBuilder responseBuilder = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    responseBuilder.append(responseLine.trim());
                }

                // Parse JSON response
                JsonObject jsonResponse = gson.fromJson(responseBuilder.toString(), JsonObject.class);

                if (jsonResponse.has("choices") && jsonResponse.getAsJsonArray("choices").size() > 0) {
                    JsonObject choice = jsonResponse.getAsJsonArray("choices").get(0).getAsJsonObject();
                    JsonObject message = choice.getAsJsonObject("message");
                    return message.get("content").getAsString();
                }
            }
        } else {
            System.err.println("OpenRouter API error: " + responseCode);
        }

        return "Xin lỗi, tôi không thể trả lời câu hỏi này lúc này. Vui lòng thử lại sau.";
    }
}
